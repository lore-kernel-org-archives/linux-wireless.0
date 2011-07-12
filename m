Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33076 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1GLKbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 06:31:07 -0400
Subject: [PATCH] mac80211: allow driver to disconnect after resume
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 12:30:59 +0200
Message-ID: <1310466659.3884.0.camel@jlt3.sipsolutions.net> (sfid-20110712_123134_432075_3D4B982E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In WoWLAN, devices may use crypto keys for TX/RX
and could also implement GTK rekeying. If the
driver isn't able to retrieve replay counters and
similar information from the device upon resume,
or if the device isn't responsive due to platform
issues, it isn't safe to keep the connection up
as GTK rekey messages from during the sleep time
could be replayed against it.

The only protection against that is disconnecting
from the AP. Modifying mac80211 to do that while
it is resuming would be very complex and invasive
in the case that the driver requires a reconfig,
so do it after it has resumed completely. In that
case, however, packets might be replayed since it
can then only happen after TX/RX are up again, so
mark keys for interfaces that need to disconnect
as "tainted" and drop all packets that are sent
or received with those keys.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |   23 +++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/key.h         |    2 ++
 net/mac80211/mlme.c        |   32 ++++++++++++++++++++++++++------
 net/mac80211/rx.c          |    3 +++
 net/mac80211/tx.c          |    3 +++
 net/mac80211/util.c        |   27 +++++++++++++++++++++++++++
 7 files changed, 86 insertions(+), 6 deletions(-)

--- a/net/mac80211/rx.c	2011-07-11 18:11:52.000000000 +0200
+++ b/net/mac80211/rx.c	2011-07-11 18:12:47.000000000 +0200
@@ -1019,6 +1019,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	}
 
 	if (rx->key) {
+		if (unlikely(rx->key->flags & KEY_FLAG_TAINTED))
+			return RX_DROP_MONITOR;
+
 		rx->key->tx_rx_count++;
 		/* TODO: add threshold stuff again */
 	} else {
--- a/net/mac80211/tx.c	2011-07-11 18:11:52.000000000 +0200
+++ b/net/mac80211/tx.c	2011-07-11 18:12:47.000000000 +0200
@@ -589,6 +589,9 @@ ieee80211_tx_h_select_key(struct ieee802
 			break;
 		}
 
+		if (unlikely(tx->key && tx->key->flags & KEY_FLAG_TAINTED))
+			return TX_DROP;
+
 		if (!skip_hw && tx->key &&
 		    tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 			info->control.hw_key = &tx->key->conf;
--- a/include/net/mac80211.h	2011-07-11 18:11:52.000000000 +0200
+++ b/include/net/mac80211.h	2011-07-11 18:12:47.000000000 +0200
@@ -3024,6 +3024,29 @@ void ieee80211_beacon_loss(struct ieee80
 void ieee80211_connection_loss(struct ieee80211_vif *vif);
 
 /**
+ * ieee80211_resume_disconnect - disconnect from AP after resume
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * Instructs mac80211 to disconnect from the AP after resume.
+ * Drivers can use this after WoWLAN if they know that the
+ * connection cannot be kept up, for example because keys were
+ * used while the device was asleep but the replay counters or
+ * similar cannot be retrieved from the device during resume.
+ *
+ * Note that due to implementation issues, if the driver uses
+ * the reconfiguration functionality during resume the interface
+ * will still be added as associated first during resume and then
+ * disconnect normally later.
+ *
+ * This function can only be called from the resume callback and
+ * the driver must not be holding any of its own locks while it
+ * calls this function, or at least not any locks it needs in the
+ * key configuration paths (if it supports HW crypto).
+ */
+void ieee80211_resume_disconnect(struct ieee80211_vif *vif);
+
+/**
  * ieee80211_disable_dyn_ps - force mac80211 to temporarily disable dynamic psm
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
--- a/net/mac80211/ieee80211_i.h	2011-07-11 18:11:52.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-07-11 18:12:47.000000000 +0200
@@ -538,12 +538,14 @@ struct ieee80211_if_mesh {
  * @IEEE80211_SDATA_DONT_BRIDGE_PACKETS: bridge packets between
  *	associated stations and deliver multicast frames both
  *	back to wireless media and to the local net stack.
+ * @IEEE80211_SDATA_DISCONNECT_RESUME: Disconnect after resume.
  */
 enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_ALLMULTI		= BIT(0),
 	IEEE80211_SDATA_PROMISC			= BIT(1),
 	IEEE80211_SDATA_OPERATING_GMODE		= BIT(2),
 	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(3),
+	IEEE80211_SDATA_DISCONNECT_RESUME	= BIT(4),
 };
 
 /**
--- a/net/mac80211/util.c	2011-07-11 18:11:52.000000000 +0200
+++ b/net/mac80211/util.c	2011-07-12 11:26:32.000000000 +0200
@@ -1334,6 +1334,33 @@ int ieee80211_reconfig(struct ieee80211_
 	return 0;
 }
 
+void ieee80211_resume_disconnect(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local;
+	struct ieee80211_key *key;
+
+	if (WARN_ON(!vif))
+		return;
+
+	sdata = vif_to_sdata(vif);
+	local = sdata->local;
+
+	if (WARN_ON(!local->resuming))
+		return;
+
+	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
+		return;
+
+	sdata->flags |= IEEE80211_SDATA_DISCONNECT_RESUME;
+
+	mutex_lock(&local->key_mtx);
+	list_for_each_entry(key, &sdata->key_list, list)
+		key->flags |= KEY_FLAG_TAINTED;
+	mutex_unlock(&local->key_mtx);
+}
+EXPORT_SYMBOL_GPL(ieee80211_resume_disconnect);
+
 static int check_mgd_smps(struct ieee80211_if_managed *ifmgd,
 			  enum ieee80211_smps_mode *smps_mode)
 {
--- a/net/mac80211/key.h	2011-07-11 18:11:52.000000000 +0200
+++ b/net/mac80211/key.h	2011-07-11 18:12:47.000000000 +0200
@@ -41,9 +41,11 @@ struct sta_info;
  *
  * @KEY_FLAG_UPLOADED_TO_HARDWARE: Indicates that this key is present
  *	in the hardware for TX crypto hardware acceleration.
+ * @KEY_FLAG_TAINTED: Key is tainted and packets should be dropped.
  */
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
+	KEY_FLAG_TAINTED		= BIT(1),
 };
 
 enum ieee80211_internal_tkip_state {
--- a/net/mac80211/mlme.c	2011-07-11 18:11:52.000000000 +0200
+++ b/net/mac80211/mlme.c	2011-07-11 18:12:47.000000000 +0200
@@ -2052,7 +2052,7 @@ static void ieee80211_sta_timer(unsigned
 }
 
 static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
-					  u8 *bssid)
+					  u8 *bssid, u8 reason)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -2070,8 +2070,7 @@ static void ieee80211_sta_connection_los
 	 * but that's not a problem.
 	 */
 	ieee80211_send_deauth_disassoc(sdata, bssid,
-			IEEE80211_STYPE_DEAUTH,
-			WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
+			IEEE80211_STYPE_DEAUTH, reason,
 			NULL, true);
 	mutex_lock(&ifmgd->mtx);
 }
@@ -2117,7 +2116,8 @@ void ieee80211_sta_work(struct ieee80211
 					    " AP %pM, disconnecting.\n",
 					    sdata->name, bssid);
 #endif
-				ieee80211_sta_connection_lost(sdata, bssid);
+				ieee80211_sta_connection_lost(sdata, bssid,
+					WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
 			}
 		} else if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(ifmgd, ifmgd->probe_timeout);
@@ -2129,7 +2129,8 @@ void ieee80211_sta_work(struct ieee80211
 				    sdata->name,
 				    bssid, probe_wait_ms);
 #endif
-			ieee80211_sta_connection_lost(sdata, bssid);
+			ieee80211_sta_connection_lost(sdata, bssid,
+				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
 		} else if (ifmgd->probe_send_count < max_tries) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			wiphy_debug(local->hw.wiphy,
@@ -2151,7 +2152,8 @@ void ieee80211_sta_work(struct ieee80211
 				    sdata->name,
 				    bssid, probe_wait_ms);
 
-			ieee80211_sta_connection_lost(sdata, bssid);
+			ieee80211_sta_connection_lost(sdata, bssid,
+				WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
 		}
 	}
 
@@ -2241,6 +2243,24 @@ void ieee80211_sta_restart(struct ieee80
 	if (!ifmgd->associated)
 		return;
 
+	if (sdata->flags & IEEE80211_SDATA_DISCONNECT_RESUME) {
+		sdata->flags &= ~IEEE80211_SDATA_DISCONNECT_RESUME;
+		mutex_lock(&ifmgd->mtx);
+		if (ifmgd->associated) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+			wiphy_debug(sdata->local->hw.wiphy,
+				    "%s: driver requested disconnect after resume.\n",
+				    sdata->name);
+#endif
+			ieee80211_sta_connection_lost(sdata,
+				ifmgd->associated->bssid,
+				WLAN_REASON_UNSPECIFIED);
+			mutex_unlock(&ifmgd->mtx);
+			return;
+		}
+		mutex_unlock(&ifmgd->mtx);
+	}
+
 	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
 		add_timer(&ifmgd->timer);
 	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))



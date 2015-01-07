Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48826 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbbAGNmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:42:49 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH *** REVIEW ME ***] mac80211: let flush() drop packets when possible [BUGFIX]
Date: Wed,  7 Jan 2015 15:42:39 +0200
Message-Id: <1420638159-16779-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150107_144253_400436_9053DA92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When roaming / suspending, it makes no sense to wait until
the transmit queues of the device are empty. In extreme
condition they can be starved (VO saturating the air), but
even in regular cases, it is pointless to delay the roaming
because the low level driver is trying to send packets to
an AP which is far away. We'd rather drop these packets and
let TCP retransmit if needed. This will allow to speed up
the roaming.

For suspend, the explanation is even more trivial.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
The noisy title is becuse this change really changes the disconnection flow.
I quickly glanced at the tree, ath (many drivers) and cw1200 seem impacted.
rtlwifi and ti implement the callback but don't relate to the drop param.
---
 net/mac80211/cfg.c         |  2 +-
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/iface.c       |  2 +-
 net/mac80211/mlme.c        | 15 ++++++++++-----
 net/mac80211/offchannel.c  |  4 ++--
 net/mac80211/pm.c          |  2 +-
 net/mac80211/scan.c        |  4 ++--
 net/mac80211/tdls.c        |  6 +++---
 net/mac80211/tx.c          |  2 +-
 net/mac80211/util.c        |  8 ++++----
 10 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 246fe0f..12baf81 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3670,7 +3670,7 @@ static int ieee80211_del_tx_ts(struct wiphy *wiphy, struct net_device *dev,
 		 * queues.
 		 */
 		synchronize_net();
-		ieee80211_flush_queues(local, sdata);
+		ieee80211_flush_queues(local, sdata, false);
 
 		/* restore the normal QoS parameters
 		 * (unconditionally to avoid races)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3d10314..ac3455b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1927,10 +1927,10 @@ void ieee80211_add_pending_skb(struct ieee80211_local *local,
 void ieee80211_add_pending_skbs(struct ieee80211_local *local,
 				struct sk_buff_head *skbs);
 void ieee80211_flush_queues(struct ieee80211_local *local,
-			    struct ieee80211_sub_if_data *sdata);
+			    struct ieee80211_sub_if_data *sdata, bool drop);
 void __ieee80211_flush_queues(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata,
-			      unsigned int queues);
+			      unsigned int queues, bool drop);
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f7c759a..93e4639 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -93,7 +93,7 @@ static u32 __ieee80211_idle_on(struct ieee80211_local *local)
 	if (local->hw.conf.flags & IEEE80211_CONF_IDLE)
 		return 0;
 
-	ieee80211_flush_queues(local, NULL);
+	ieee80211_flush_queues(local, NULL, false);
 
 	local->hw.conf.flags |= IEEE80211_CONF_IDLE;
 	return IEEE80211_CONF_CHANGE_IDLE;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6449ed3..24f776d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1609,7 +1609,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		} else {
 			ieee80211_send_nullfunc(local, sdata, 1);
 			/* Flush to get the tx status of nullfunc frame */
-			ieee80211_flush_queues(local, sdata);
+			ieee80211_flush_queues(local, sdata, false);
 		}
 	}
 
@@ -2016,18 +2016,23 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	/* disable per-vif ps */
 	ieee80211_recalc_ps_vif(sdata);
 
-	/* flush out any pending frame (e.g. DELBA) before deauth/disassoc */
+	/*
+	 * drop any frame before deauth/disassoc, this can be data or
+	 * management frame. Since we are disconnecting, we should not
+	 * insist sending these frames which can take time and delay
+	 * the disconnection and possible the roaming.
+	 */
 	if (tx)
-		ieee80211_flush_queues(local, sdata);
+		ieee80211_flush_queues(local, sdata, true);
 
 	/* deauthenticate/disassociate now */
 	if (tx || frame_buf)
 		ieee80211_send_deauth_disassoc(sdata, ifmgd->bssid, stype,
 					       reason, tx, frame_buf);
 
-	/* flush out frame */
+	/* flush out frame - make sure the deauth was actually sent */
 	if (tx)
-		ieee80211_flush_queues(local, sdata);
+		ieee80211_flush_queues(local, sdata, false);
 
 	/* clear bssid only after building the needed mgmt frames */
 	memset(ifmgd->bssid, 0, ETH_ALEN);
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index ff20b2e..683f0e3 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -121,7 +121,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 	ieee80211_stop_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
 					false);
-	ieee80211_flush_queues(local, NULL);
+	ieee80211_flush_queues(local, NULL, false);
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
@@ -398,7 +398,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 		ieee80211_roc_notify_destroy(roc, !roc->abort);
 
 		if (started && !on_channel) {
-			ieee80211_flush_queues(local, NULL);
+			ieee80211_flush_queues(local, NULL, false);
 
 			local->tmp_channel = NULL;
 			ieee80211_hw_config(local, 0);
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 4c5192e..8c8c678 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -41,7 +41,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	/* flush out all packets */
 	synchronize_net();
 
-	ieee80211_flush_queues(local, NULL);
+	ieee80211_flush_queues(local, NULL, true);
 
 	local->quiescing = true;
 	/* make quiescing visible to timers everywhere */
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index ae84267..844fb5f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -416,7 +416,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local,
 	ieee80211_offchannel_stop_vifs(local);
 
 	/* ensure nullfunc is transmitted before leaving operating channel */
-	ieee80211_flush_queues(local, NULL);
+	ieee80211_flush_queues(local, NULL, false);
 
 	ieee80211_configure_filter(local);
 
@@ -805,7 +805,7 @@ static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 	ieee80211_offchannel_stop_vifs(local);
 
 	if (local->ops->flush) {
-		ieee80211_flush_queues(local, NULL);
+		ieee80211_flush_queues(local, NULL, false);
 		*next_delay = 0;
 	} else
 		*next_delay = HZ / 10;
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index bd89249..90b056d 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -919,7 +919,7 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 		rcu_read_unlock();
 	}
 
-	ieee80211_flush_queues(local, sdata);
+	ieee80211_flush_queues(local, sdata, false);
 
 	ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer, action_code,
 					      dialog_token, status_code,
@@ -959,7 +959,7 @@ ieee80211_tdls_mgmt_teardown(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	ieee80211_stop_vif_queues(local, sdata,
 				  IEEE80211_QUEUE_STOP_REASON_TDLS_TEARDOWN);
-	ieee80211_flush_queues(local, sdata);
+	ieee80211_flush_queues(local, sdata, false);
 
 	ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer, action_code,
 					      dialog_token, status_code,
@@ -1105,7 +1105,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		 */
 		tasklet_kill(&local->tx_pending_tasklet);
 		/* flush a potentially queued teardown packet */
-		ieee80211_flush_queues(local, sdata);
+		ieee80211_flush_queues(local, sdata, false);
 
 		ret = sta_info_destroy_addr(sdata, peer);
 		break;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b6b709d..5d4da5c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3157,7 +3157,7 @@ int ieee80211_reserve_tid(struct ieee80211_sta *pubsta, u8 tid)
 	}
 
 	queues = BIT(sdata->vif.hw_queue[ieee802_1d_to_ac[tid]]);
-	__ieee80211_flush_queues(local, sdata, queues);
+	__ieee80211_flush_queues(local, sdata, queues, false);
 
 	sta->reserved_tid = tid;
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ad8cb4f..83ba6cd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -578,7 +578,7 @@ ieee80211_get_vif_queues(struct ieee80211_local *local,
 
 void __ieee80211_flush_queues(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata,
-			      unsigned int queues)
+			      unsigned int queues, bool drop)
 {
 	if (!local->ops->flush)
 		return;
@@ -594,7 +594,7 @@ void __ieee80211_flush_queues(struct ieee80211_local *local,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH,
 					false);
 
-	drv_flush(local, sdata, queues, false);
+	drv_flush(local, sdata, queues, drop);
 
 	ieee80211_wake_queues_by_reason(&local->hw, queues,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH,
@@ -602,9 +602,9 @@ void __ieee80211_flush_queues(struct ieee80211_local *local,
 }
 
 void ieee80211_flush_queues(struct ieee80211_local *local,
-			    struct ieee80211_sub_if_data *sdata)
+			    struct ieee80211_sub_if_data *sdata, bool drop)
 {
-	__ieee80211_flush_queues(local, sdata, 0);
+	__ieee80211_flush_queues(local, sdata, 0, drop);
 }
 
 void ieee80211_stop_vif_queues(struct ieee80211_local *local,
-- 
1.9.1


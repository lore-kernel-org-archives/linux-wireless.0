Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab0JMKHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 06:07:37 -0400
Message-Id: <20101013100658.046233239@sipsolutions.net>
Date: Wed, 13 Oct 2010 12:06:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: add probe request filter flag
References: <20101013100622.939014559@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using the frame registration notification, we
can see when probe requests are requested and
notify the low-level driver via filtering. The
flag is also set in AP and IBSS modes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |    9 ++++++---
 net/mac80211/cfg.c         |   18 ++++++++++++++++++
 net/mac80211/ieee80211_i.h |    4 +++-
 net/mac80211/iface.c       |    9 ++++++++-
 net/mac80211/main.c        |    3 +++
 5 files changed, 38 insertions(+), 5 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-10-13 11:35:49.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-10-13 11:36:27.000000000 +0200
@@ -1478,12 +1478,14 @@ ieee80211_get_alt_retry_rate(const struc
  *	honour this flag if possible.
  *
  * @FIF_CONTROL: pass control frames (except for PS Poll), if PROMISC_IN_BSS
- *  is not set then only those addressed to this station.
+ * 	is not set then only those addressed to this station.
  *
  * @FIF_OTHER_BSS: pass frames destined to other BSSes
  *
- * @FIF_PSPOLL: pass PS Poll frames, if PROMISC_IN_BSS  is not set then only
- *  those addressed to this station.
+ * @FIF_PSPOLL: pass PS Poll frames, if PROMISC_IN_BSS is not set then only
+ * 	those addressed to this station.
+ *
+ * @FIF_PROBE_REQ: pass probe request frames
  */
 enum ieee80211_filter_flags {
 	FIF_PROMISC_IN_BSS	= 1<<0,
@@ -1494,6 +1496,7 @@ enum ieee80211_filter_flags {
 	FIF_CONTROL		= 1<<5,
 	FIF_OTHER_BSS		= 1<<6,
 	FIF_PSPOLL		= 1<<7,
+	FIF_PROBE_REQ		= 1<<8,
 };
 
 /**
--- wireless-testing.orig/net/mac80211/main.c	2010-10-13 11:35:49.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-10-13 11:36:27.000000000 +0200
@@ -54,6 +54,9 @@ void ieee80211_configure_filter(struct i
 	if (local->monitors || local->scanning)
 		new_flags |= FIF_BCN_PRBRESP_PROMISC;
 
+	if (local->fif_probe_req || local->probe_req_reg)
+		new_flags |= FIF_PROBE_REQ;
+
 	if (local->fif_fcsfail)
 		new_flags |= FIF_FCSFAIL;
 
--- wireless-testing.orig/net/mac80211/cfg.c	2010-10-13 11:35:49.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-10-13 11:42:05.000000000 +0200
@@ -1604,6 +1604,23 @@ static int ieee80211_mgmt_tx(struct wiph
 	return 0;
 }
 
+static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
+					  struct net_device *dev,
+					  u16 frame_type, bool reg)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	if (frame_type != (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_REQ))
+		return;
+
+	if (reg)
+		local->probe_req_reg++;
+	else
+		local->probe_req_reg--;
+
+	ieee80211_queue_work(&local->hw, &local->reconfig_filter);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1655,4 +1672,5 @@ struct cfg80211_ops mac80211_config_ops
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.mgmt_tx = ieee80211_mgmt_tx,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
+	.mgmt_frame_register = ieee80211_mgmt_frame_register,
 };
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-10-13 11:35:49.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-10-13 11:36:27.000000000 +0200
@@ -707,7 +707,9 @@ struct ieee80211_local {
 	int open_count;
 	int monitors, cooked_mntrs;
 	/* number of interfaces with corresponding FIF_ flags */
-	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss, fif_pspoll;
+	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss, fif_pspoll,
+	    fif_probe_req;
+	int probe_req_reg;
 	unsigned int filter_flags; /* FIF_* */
 
 	bool wiphy_ciphers_allocated;
--- wireless-testing.orig/net/mac80211/iface.c	2010-10-13 11:35:49.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-10-13 11:36:27.000000000 +0200
@@ -280,8 +280,11 @@ static int ieee80211_do_open(struct net_
 			ieee80211_start_mesh(sdata);
 		} else if (sdata->vif.type == NL80211_IFTYPE_AP) {
 			local->fif_pspoll++;
+			local->fif_probe_req++;
 
 			ieee80211_configure_filter(local);
+		} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+			local->fif_probe_req++;
 		}
 
 		changed |= ieee80211_reset_erp_info(sdata);
@@ -428,8 +431,12 @@ static void ieee80211_do_stop(struct iee
 	if (sdata->flags & IEEE80211_SDATA_PROMISC)
 		atomic_dec(&local->iff_promiscs);
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP)
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		local->fif_pspoll--;
+		local->fif_probe_req--;
+	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		local->fif_probe_req--;
+	}
 
 	netif_addr_lock_bh(sdata->dev);
 	spin_lock_bh(&local->filter_lock);



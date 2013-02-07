Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54655 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3BGI5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 03:57:47 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove IEEE80211_HW_SCAN_WHILE_IDLE
Date: Thu,  7 Feb 2013 09:58:09 +0100
Message-Id: <1360227489-11145-1-git-send-email-johannes@sipsolutions.net> (sfid-20130207_095751_187755_D548B602)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are only a few drivers that use HW scan, and
all of those don't need a non-idle transition before
starting the scan -- some don't even care about idle
at all. Remove the flag and code associated with it.

The only driver that really actually needed this is
wl1251 and it can just do it itself in the hw_scan
callback -- implement that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  3 +--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  1 -
 drivers/net/wireless/ti/wl1251/event.c      |  6 +++++-
 drivers/net/wireless/ti/wl1251/main.c       | 24 +++++++++++++++++++-----
 drivers/net/wireless/ti/wlcore/main.c       |  1 -
 include/net/mac80211.h                      |  5 -----
 net/mac80211/debugfs.c                      |  2 --
 net/mac80211/iface.c                        |  8 ++------
 net/mac80211/main.c                         |  3 ---
 9 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 75f6f6c..0fccf72 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -151,8 +151,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		    IEEE80211_HW_QUEUE_CONTROL |
 		    IEEE80211_HW_SUPPORTS_PS |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
-		    IEEE80211_HW_WANT_MONITOR_VIF |
-		    IEEE80211_HW_SCAN_WHILE_IDLE;
+		    IEEE80211_HW_WANT_MONITOR_VIF;
 
 	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
 	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_FMT;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index a6b05a0..ef7bc4b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -113,7 +113,6 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		    IEEE80211_HW_QUEUE_CONTROL |
 		    IEEE80211_HW_WANT_MONITOR_VIF |
-		    IEEE80211_HW_SCAN_WHILE_IDLE |
 		    IEEE80211_HW_NEED_DTIM_PERIOD |
 		    IEEE80211_HW_SUPPORTS_PS |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index 5ec50a4..74ae8e1 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -29,6 +29,8 @@
 static int wl1251_event_scan_complete(struct wl1251 *wl,
 				      struct event_mailbox *mbox)
 {
+	int ret = 0;
+
 	wl1251_debug(DEBUG_EVENT, "status: 0x%x, channels: %d",
 		     mbox->scheduled_scan_status,
 		     mbox->scheduled_scan_channels);
@@ -37,9 +39,11 @@ static int wl1251_event_scan_complete(struct wl1251 *wl,
 		ieee80211_scan_completed(wl->hw, false);
 		wl1251_debug(DEBUG_MAC80211, "mac80211 hw scan completed");
 		wl->scanning = false;
+		if (wl->hw->conf.flags & IEEE80211_CONF_IDLE)
+			ret = wl1251_ps_set_mode(wl, STATION_IDLE);
 	}
 
-	return 0;
+	return ret;
 }
 
 static void wl1251_event_mbox_dump(struct event_mailbox *mbox)
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index f47e8b0..bbbf68c 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -623,7 +623,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+	if (changed & IEEE80211_CONF_CHANGE_IDLE && !wl->scanning) {
 		if (conf->flags & IEEE80211_CONF_IDLE) {
 			ret = wl1251_ps_set_mode(wl, STATION_IDLE);
 			if (ret < 0)
@@ -895,11 +895,21 @@ static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
+	if (hw->conf.flags & IEEE80211_CONF_IDLE) {
+		ret = wl1251_ps_set_mode(wl, STATION_ACTIVE_MODE);
+		if (ret < 0)
+			goto out_sleep;
+		ret = wl1251_join(wl, wl->bss_type, wl->channel,
+				  wl->beacon_int, wl->dtim_period);
+		if (ret < 0)
+			goto out_sleep;
+	}
+
 	skb = ieee80211_probereq_get(wl->hw, wl->vif, ssid, ssid_len,
 				     req->ie_len);
 	if (!skb) {
 		ret = -ENOMEM;
-		goto out;
+		goto out_idle;
 	}
 	if (req->ie_len)
 		memcpy(skb_put(skb, req->ie_len), req->ie, req->ie_len);
@@ -908,11 +918,11 @@ static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 				      skb->len);
 	dev_kfree_skb(skb);
 	if (ret < 0)
-		goto out_sleep;
+		goto out_idle;
 
 	ret = wl1251_cmd_trigger_scan_to(wl, 0);
 	if (ret < 0)
-		goto out_sleep;
+		goto out_idle;
 
 	wl->scanning = true;
 
@@ -920,9 +930,13 @@ static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 			      req->n_channels, WL1251_SCAN_NUM_PROBES);
 	if (ret < 0) {
 		wl->scanning = false;
-		goto out_sleep;
+		goto out_idle;
 	}
+	goto out_sleep;
 
+out_idle:
+	if (hw->conf.flags & IEEE80211_CONF_IDLE)
+		ret = wl1251_ps_set_mode(wl, STATION_IDLE);
 out_sleep:
 	wl1251_ps_elp_sleep(wl);
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index e1dfdf9..748bb01 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5639,7 +5639,6 @@ static int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_AP_LINK_PS |
 		IEEE80211_HW_AMPDU_AGGREGATION |
 		IEEE80211_HW_TX_AMPDU_SETUP_IN_HW |
-		IEEE80211_HW_SCAN_WHILE_IDLE |
 		IEEE80211_HW_QUEUE_CONTROL;
 
 	wl->hw->wiphy->cipher_suites = cipher_suites;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dc20df9..6fa7cc8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1368,10 +1368,6 @@ struct ieee80211_tx_control {
  *	setup strictly in HW. mac80211 should not attempt to do this in
  *	software.
  *
- * @IEEE80211_HW_SCAN_WHILE_IDLE: The device can do hw scan while
- *	being idle (i.e. mac80211 doesn't have to go idle-off during the
- *	the scan).
- *
  * @IEEE80211_HW_WANT_MONITOR_VIF: The driver would like to be informed of
  *	a virtual monitor interface when monitor interfaces are the only
  *	active interfaces.
@@ -1413,7 +1409,6 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
-	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
 	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
 	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
 };
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 8e604099..b0e32d6 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -151,8 +151,6 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 		sf += snprintf(buf + sf, mxln - sf, "AP_LINK_PS\n");
 	if (local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW)
 		sf += snprintf(buf + sf, mxln - sf, "TX_AMPDU_SETUP_IN_HW\n");
-	if (local->hw.flags & IEEE80211_HW_SCAN_WHILE_IDLE)
-		sf += snprintf(buf + sf, mxln - sf, "SCAN_WHILE_IDLE\n");
 
 	rv = simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 	kfree(buf);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index deb78e8..3ece8eb 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -151,12 +151,8 @@ static u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 		}
 	}
 
-	sdata = rcu_dereference_protected(local->scan_sdata,
-					  lockdep_is_held(&local->mtx));
-	if (sdata && !(local->hw.flags & IEEE80211_HW_SCAN_WHILE_IDLE)) {
-		scanning = true;
-		sdata->vif.bss_conf.idle = false;
-	}
+	scanning = test_bit(SCAN_SW_SCANNING, &local->scanning) ||
+		   test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning);
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2bdd454..aa42488 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -707,9 +707,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		return -EINVAL;
 #endif
 
-	if ((hw->flags & IEEE80211_HW_SCAN_WHILE_IDLE) && !local->ops->hw_scan)
-		return -EINVAL;
-
 	if (!local->use_chanctx) {
 		for (i = 0; i < local->hw.wiphy->n_iface_combinations; i++) {
 			const struct ieee80211_iface_combination *comb;
-- 
1.8.0


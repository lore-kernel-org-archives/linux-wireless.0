Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab3BFW7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 17:59:14 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: remove IEEE80211_HW_SCAN_WHILE_IDLE
Date: Wed,  6 Feb 2013 23:59:36 +0100
Message-Id: <1360191576-6894-1-git-send-email-johannes@sipsolutions.net> (sfid-20130206_235920_042084_4E0C382B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are only a few drivers that use HW scan, and
all of those don't need a non-idle transition before
starting the scan -- some don't even care about idle
at all. Remove the flag and code associated with it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Actually I'm not 100% sure about wl1251, but I think if
it has a problem with that it can fix it in the hw_scan
callback?
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 3 +--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 1 -
 drivers/net/wireless/ti/wlcore/main.c       | 1 -
 include/net/mac80211.h                      | 5 -----
 net/mac80211/debugfs.c                      | 2 --
 net/mac80211/iface.c                        | 8 ++------
 net/mac80211/main.c                         | 3 ---
 7 files changed, 3 insertions(+), 20 deletions(-)

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


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41178 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079Ab3HMKdi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 06:33:38 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 1/5] ath9k: remove ath9k_sta_remove_debugfs
Date: Tue, 13 Aug 2013 12:33:26 +0200
Message-Id: <1376390010-81819-1-git-send-email-nbd@openwrt.org> (sfid-20130813_123345_354968_5760E249)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 uses debugfs_remove_recursive, so there's no need for the
driver to do an explicit cleanup of its sta debugfs entry.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  4 ----
 drivers/net/wireless/ath/ath9k/debug.c | 12 +-----------
 drivers/net/wireless/ath/ath9k/debug.h |  4 ----
 drivers/net/wireless/ath/ath9k/main.c  |  1 -
 4 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7b1d036..df1c495 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -262,10 +262,6 @@ struct ath_node {
 
 	bool sleeping;
 	bool no_ps_filter;
-
-#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
-	struct dentry *node_stat;
-#endif
 };
 
 struct ath_tx_control {
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index c10cec5..e5c8333 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1725,17 +1725,7 @@ void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 			   struct dentry *dir)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
-	an->node_stat = debugfs_create_file("node_stat", S_IRUGO,
-					    dir, an, &fops_node_stat);
-}
-
-void ath9k_sta_remove_debugfs(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif,
-			      struct ieee80211_sta *sta,
-			      struct dentry *dir)
-{
-	struct ath_node *an = (struct ath_node *)sta->drv_priv;
-	debugfs_remove(an->node_stat);
+	debugfs_create_file("node_stat", S_IRUGO, dir, an, &fops_node_stat);
 }
 
 /* Ethtool support for get-stats */
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 01c5c6a..6e1556f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -292,10 +292,6 @@ void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 			   struct ieee80211_vif *vif,
 			   struct ieee80211_sta *sta,
 			   struct dentry *dir);
-void ath9k_sta_remove_debugfs(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif,
-			      struct ieee80211_sta *sta,
-			      struct dentry *dir);
 void ath_debug_send_fft_sample(struct ath_softc *sc,
 			       struct fft_sample_tlv *fft_sample);
 void ath9k_debug_stat_ant(struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 911744f..0bee105 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2364,7 +2364,6 @@ struct ieee80211_ops ath9k_ops = {
 
 #if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
 	.sta_add_debugfs    = ath9k_sta_add_debugfs,
-	.sta_remove_debugfs = ath9k_sta_remove_debugfs,
 #endif
 	.sw_scan_start	    = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
-- 
1.8.0.2


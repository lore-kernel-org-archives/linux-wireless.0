Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37034 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753038AbeDSSR7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 14:17:59 -0400
From: greearb@candelatech.com
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 3/3] ath10k:  Support ethtool gstats2 API.
Date: Thu, 19 Apr 2018 11:17:43 -0700
Message-Id: <1524161863-30860-3-git-send-email-greearb@candelatech.com> (sfid-20180419_201812_780658_139C36EC)
In-Reply-To: <1524161863-30860-1-git-send-email-greearb@candelatech.com>
References: <1524161863-30860-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Skip a firmware stats update when calling
code indicates the stats refresh is not needed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Convert to new flag name, attempt to fix build
   when there is not DEBUGFS enabled for ath10k.

 drivers/net/wireless/ath/ath10k/debug.c | 18 +++++++++++++++---
 drivers/net/wireless/ath/ath10k/debug.h |  5 +++++
 drivers/net/wireless/ath/ath10k/mac.c   |  1 +
 3 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index bac832c..235cd04 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1159,9 +1159,10 @@ int ath10k_debug_get_et_sset_count(struct ieee80211_hw *hw,
 	return 0;
 }
 
-void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       struct ethtool_stats *stats, u64 *data)
+void ath10k_debug_get_et_stats2(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ethtool_stats *stats, u64 *data,
+				u32 flags)
 {
 	struct ath10k *ar = hw->priv;
 	static const struct ath10k_fw_stats_pdev zero_stats = {};
@@ -1170,6 +1171,9 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
+	if (flags & ETHTOOL_GS2_NO_REFRESH_FW)
+		goto skip_query_fw_stats;
+
 	if (ar->state == ATH10K_STATE_ON) {
 		ret = ath10k_debug_fw_stats_request(ar);
 		if (ret) {
@@ -1180,6 +1184,7 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 		}
 	}
 
+skip_query_fw_stats:
 	pdev_stats = list_first_entry_or_null(&ar->debug.fw_stats.pdevs,
 					      struct ath10k_fw_stats_pdev,
 					      list);
@@ -1244,6 +1249,13 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 	WARN_ON(i != ATH10K_SSTATS_LEN);
 }
 
+void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ethtool_stats *stats, u64 *data)
+{
+	ath10k_debug_get_et_stats2(hw, vif, stats, data, 0);
+}
+
 static const struct file_operations fops_fw_dbglog = {
 	.read = ath10k_read_fw_dbglog,
 	.write = ath10k_write_fw_dbglog,
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 0afca5c..e953dd0 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -117,6 +117,10 @@ int ath10k_debug_get_et_sset_count(struct ieee80211_hw *hw,
 void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ethtool_stats *stats, u64 *data);
+void ath10k_debug_get_et_stats2(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ethtool_stats *stats, u64 *data,
+				u32 level);
 
 static inline u64 ath10k_debug_get_fw_dbglog_mask(struct ath10k *ar)
 {
@@ -195,6 +199,7 @@ static inline u32 ath10k_debug_get_fw_dbglog_level(struct ath10k *ar)
 #define ath10k_debug_get_et_strings NULL
 #define ath10k_debug_get_et_sset_count NULL
 #define ath10k_debug_get_et_stats NULL
+#define ath10k_debug_get_et_stats2 NULL
 
 #endif /* CONFIG_ATH10K_DEBUGFS */
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bf05a36..27b793c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7734,6 +7734,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.ampdu_action			= ath10k_ampdu_action,
 	.get_et_sset_count		= ath10k_debug_get_et_sset_count,
 	.get_et_stats			= ath10k_debug_get_et_stats,
+	.get_et_stats2			= ath10k_debug_get_et_stats2,
 	.get_et_strings			= ath10k_debug_get_et_strings,
 	.add_chanctx			= ath10k_mac_op_add_chanctx,
 	.remove_chanctx			= ath10k_mac_op_remove_chanctx,
-- 
2.4.11

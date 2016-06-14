Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48938 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbcFNHxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 03:53:02 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH v4 1/2] ath10k: Add support for ath10k_sta_statistics support
Date: Tue, 14 Jun 2016 13:24:25 +0530
Message-ID: <1465890866-2390-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160614_095308_126371_2EA9241B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Enable support for 'drv_sta_statistics' callback.
Export rx_duration support if available to cfg80211/nl80211

This can also act as a placeholder for any new per STA stats support

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---

[v4] rebased over 'pending' branch
[v3] removed conditions for ath10k state checks based on Michal's suggestion

Both the dependent changes are merged now in master tree

1. cfg80211/nl80211: Add support for NL80211_STA_INFO_RX_DURATION
2. iw: Add support for NL80211_STA_INFO_RX_DURATION netlink
 attribute
---
 drivers/net/wireless/ath/ath10k/debug.h       |  3 +++
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 14 ++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c         |  1 +
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index dc549c4..c458fa9 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -156,6 +156,9 @@ void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir);
 void ath10k_sta_update_rx_duration(struct ath10k *ar,
 				   struct ath10k_fw_stats *stats);
+void ath10k_sta_statistics(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   struct station_info *sinfo);
 #else
 static inline
 void ath10k_sta_update_rx_duration(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 0da8a57..60e5da0 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -65,6 +65,20 @@ void ath10k_sta_update_rx_duration(struct ath10k *ar,
 		ath10k_sta_update_stats_rx_duration(ar, stats);
 }
 
+void ath10k_sta_statistics(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   struct station_info *sinfo)
+{
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k *ar = arsta->arvif->ar;
+
+	if (!ath10k_peer_stats_enabled(ar))
+		return;
+
+	sinfo->rx_duration = arsta->rx_duration;
+	sinfo->filled |= 1ULL << NL80211_STA_INFO_RX_DURATION;
+}
+
 static ssize_t ath10k_dbg_sta_read_aggr_mode(struct file *file,
 					     char __user *user_buf,
 					     size_t count, loff_t *ppos)
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3a170b1..1fe33c36 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7402,6 +7402,7 @@ static const struct ieee80211_ops ath10k_ops = {
 #endif
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.sta_add_debugfs		= ath10k_sta_add_debugfs,
+	.sta_statistics			= ath10k_sta_statistics,
 #endif
 };
 
-- 
1.9.1


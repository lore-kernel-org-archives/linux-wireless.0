Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41686 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbcEBPwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 11:52:00 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH v3 RESEND 1/2] ath10k: Add support for ath10k_sta_statistics support
Date: Mon, 2 May 2016 21:22:27 +0530
Message-ID: <1462204347-31012-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160502_175213_851313_75358714)
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
[v3] removed conditions for ath10k state checks based on Michal's suggestion

Dependencies:

1. cfg80211/nl80211: Add support for NL80211_STA_INFO_RX_DURATION (under review)
2. iw: Add support for NL80211_STA_INFO_RX_DURATION netlink
 attribute (under review)
3. ath10k: Enable debugfs provision to enable Peer Stats feature (merged in pending branch)

 drivers/net/wireless/ath/ath10k/debug.h       |    4 ++++
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |   14 ++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c         |    1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 6206edd..01c500f 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -155,6 +155,10 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir);
 void ath10k_sta_update_rx_duration(struct ath10k *ar, struct list_head *peer);
+void ath10k_sta_statistics(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   struct station_info *sinfo);
+
 #else
 static inline void ath10k_sta_update_rx_duration(struct ath10k *ar,
 						 struct list_head *peer)
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 67ef75b..c5396bf 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -35,6 +35,20 @@ void ath10k_sta_update_rx_duration(struct ath10k *ar, struct list_head *head)
 	rcu_read_unlock();
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
index 20d72e2..02edeff 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7271,6 +7271,7 @@ static const struct ieee80211_ops ath10k_ops = {
 #endif
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.sta_add_debugfs		= ath10k_sta_add_debugfs,
+	.sta_statistics			= ath10k_sta_statistics,
 #endif
 };
 
-- 
1.7.9.5


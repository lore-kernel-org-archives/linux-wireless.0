Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55530 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbeIDLHh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:07:37 -0400
From: akolli@codeaurora.org
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCHv2 4/4] ath10k: add debugfs support to dump per sta tx stats
Date: Tue,  4 Sep 2018 12:15:16 +0530
Message-Id: <1536043516-12462-5-git-send-email-akolli@codeaurora.org> (sfid-20180904_084358_851809_4E20AF0B)
In-Reply-To: <1536043516-12462-1-git-send-email-akolli@codeaurora.org>
References: <1536043516-12462-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@codeaurora.org>

This patch adds 'tx_stats' in per station debugfs entry.

Use this command to dump tx_stats:
cat /sys/kernel/debug/ieee80211/phy0/netdev\:wlan0/
    stations/<MACADDR>/tx_stats

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
V2:
  - Fix kbuild, warning: the frame size of 1088 bytes is 
    larger than 1024 bytes [-Wframe-larger-than=]

 drivers/net/wireless/ath/ath10k/debugfs_sta.c |  101 +++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index a63c97e2c50c..929f2f66fdce 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -626,9 +626,105 @@ static ssize_t ath10k_dbg_sta_read_tid_stats(struct file *file,
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_dbg_sta_dump_tx_stats(struct file *file,
+					    char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	struct ieee80211_sta *sta = file->private_data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k *ar = arsta->arvif->ar;
+	struct ath10k_htt_data_stats *stats;
+	const char *str_name[ATH10K_STATS_TYPE_MAX] = {"succ", "fail",
+						       "retry", "ampdu"};
+	const char *str[ATH10K_COUNTER_TYPE_MAX] = {"bytes", "packets"};
+	int len = 0, i, j, k, retval = 0;
+	const int size = 2 * 4096;
+	char *buf;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&ar->conf_mutex);
+
+	spin_lock_bh(&ar->data_lock);
+	for (k = 0; k < ATH10K_STATS_TYPE_MAX; k++) {
+		for (j = 0; j < ATH10K_COUNTER_TYPE_MAX; j++) {
+			stats = &arsta->tx_stats->stats[k];
+			len += scnprintf(buf + len, size - len, "%s_%s\n",
+					 str_name[k],
+					 str[j]);
+			len += scnprintf(buf + len, size - len,
+					 " VHT MCS %s\n",
+					 str[j]);
+			for (i = 0; i < ATH10K_VHT_MCS_NUM; i++)
+				len += scnprintf(buf + len, size - len,
+						 "  %llu ",
+						 stats->vht[j][i]);
+			len += scnprintf(buf + len, size - len, "\n");
+			len += scnprintf(buf + len, size - len, " HT MCS %s\n",
+					 str[j]);
+			for (i = 0; i < ATH10K_HT_MCS_NUM; i++)
+				len += scnprintf(buf + len, size - len,
+						 "  %llu ", stats->ht[j][i]);
+			len += scnprintf(buf + len, size - len, "\n");
+			len += scnprintf(buf + len, size - len,
+					" BW %s (20,40,80,160 MHz)\n", str[j]);
+			len += scnprintf(buf + len, size - len,
+					 "  %llu %llu %llu %llu\n",
+					 stats->bw[j][0], stats->bw[j][1],
+					 stats->bw[j][2], stats->bw[j][3]);
+			len += scnprintf(buf + len, size - len,
+					 " NSS %s (1x1,2x2,3x3,4x4)\n", str[j]);
+			len += scnprintf(buf + len, size - len,
+					 "  %llu %llu %llu %llu\n",
+					 stats->nss[j][0], stats->nss[j][1],
+					 stats->nss[j][2], stats->nss[j][3]);
+			len += scnprintf(buf + len, size - len,
+					 " GI %s (LGI,SGI)\n",
+					 str[j]);
+			len += scnprintf(buf + len, size - len, "  %llu %llu\n",
+					 stats->gi[j][0], stats->gi[j][1]);
+			len += scnprintf(buf + len, size - len,
+					 " legacy rate %s (1,2 ... Mbps)\n  ",
+					 str[j]);
+			for (i = 0; i < ATH10K_LEGACY_NUM; i++)
+				len += scnprintf(buf + len, size - len, "%llu ",
+						 stats->legacy[j][i]);
+			len += scnprintf(buf + len, size - len, "\n");
+		}
+	}
+
+	len += scnprintf(buf + len, size - len,
+			 "\nTX duration\n %llu usecs\n",
+			 arsta->tx_stats->tx_duration);
+	len += scnprintf(buf + len, size - len,
+			"BA fails\n %llu\n", arsta->tx_stats->ba_fails);
+	len += scnprintf(buf + len, size - len,
+			"ack fails\n %llu\n", arsta->tx_stats->ack_fails);
+	spin_unlock_bh(&ar->data_lock);
+
+	if (len > size)
+		len = size;
+	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+
+	mutex_unlock(&ar->conf_mutex);
+	return retval;
+}
+
+static const struct file_operations fops_tx_stats = {
+	.read = ath10k_dbg_sta_dump_tx_stats,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir)
 {
+	struct ath10k *ar = hw->priv;
+
 	debugfs_create_file("aggr_mode", 0644, dir, sta, &fops_aggr_mode);
 	debugfs_create_file("addba", 0200, dir, sta, &fops_addba);
 	debugfs_create_file("addba_resp", 0200, dir, sta, &fops_addba_resp);
@@ -637,4 +733,9 @@ void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    &fops_peer_debug_trigger);
 	debugfs_create_file("dump_tid_stats", 0400, dir, sta,
 			    &fops_tid_stats_dump);
+
+	if (ath10k_peer_stats_enabled(ar) &&
+	    ath10k_debug_is_extd_tx_stats_enabled(ar))
+		debugfs_create_file("tx_stats", 0400, dir, sta,
+				    &fops_tx_stats);
 }
-- 
1.7.9.5

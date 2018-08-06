Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45460 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732393AbeHFPWK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Aug 2018 11:22:10 -0400
From: Anilkumar Kolli <akolli@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath10k: add debugfs support to dump per sta tx stats
Date: Mon,  6 Aug 2018 18:43:43 +0530
Message-Id: <1533561223-342-5-git-send-email-akolli@codeaurora.org> (sfid-20180806_151310_190886_4896B239)
In-Reply-To: <1533561223-342-1-git-send-email-akolli@codeaurora.org>
References: <1533561223-342-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds 'tx_stats' in per station debugfs entry.

Use this command to dump tx_stats:
cat /sys/kernel/debug/ieee80211/phy0/netdev\:wlan0/
    stations/<MACADDR>/tx_stats

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debugfs_sta.c |  100 +++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index a63c97e2c50c..800eddd26af8 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -626,9 +626,105 @@ static ssize_t ath10k_dbg_sta_read_tid_stats(struct file *file,
 	.llseek = default_llseek,
 };
 
+static inline int  ath10k_dump_htt_tx_stats(char *buf, int len, int size,
+					    struct ath10k_htt_data_stats stats,
+					    int type, const char *name)
+{
+	static const char *str[ATH10K_COUNTER_TYPE_MAX] = {
+						"bytes", "packets"};
+	int i;
+
+	len += scnprintf(buf + len, size - len, "%s_%s\n", name,
+			 str[type]);
+	len += scnprintf(buf + len, size - len, " VHT MCS %s\n",
+			 str[type]);
+	for (i = 0; i < NUM_VHT_MCS; i++)
+		len += scnprintf(buf + len, size - len, "  %llu ",
+				 stats.vht[type][i]);
+	len += scnprintf(buf + len, size - len, "\n");
+	len += scnprintf(buf + len, size - len, " HT MCS %s\n",
+			 str[type]);
+	for (i = 0; i < NUM_HT_MCS; i++)
+		len += scnprintf(buf + len, size - len, "  %llu ",
+				 stats.ht[type][i]);
+	len += scnprintf(buf + len, size - len, "\n");
+	len += scnprintf(buf + len, size - len,
+			" BW %s (20,40,80,160 MHz)\n", str[type]);
+	len += scnprintf(buf + len, size - len, "  %llu %llu %llu %llu\n",
+			 stats.bw[type][0], stats.bw[type][1],
+			 stats.bw[type][2], stats.bw[type][3]);
+	len += scnprintf(buf + len, size - len,
+			" NSS %s (1x1,2x2,3x3,4x4)\n", str[type]);
+	len += scnprintf(buf + len, size - len, "  %llu %llu %llu %llu\n",
+			 stats.nss[type][0], stats.nss[type][1],
+			 stats.nss[type][2], stats.nss[type][3]);
+	len += scnprintf(buf + len, size - len, " GI %s (LGI,SGI)\n",
+			 str[type]);
+	len += scnprintf(buf + len, size - len, "  %llu %llu\n",
+			 stats.gi[type][0], stats.gi[type][1]);
+	len += scnprintf(buf + len, size - len,
+			 " legacy rate %s (1,2 ... Mbps)\n  ", str[type]);
+	for (i = 0; i < NUM_LEGACY; i++)
+		len += scnprintf(buf + len, size - len, "%llu ",
+				 stats.legacy[type][i]);
+	len += scnprintf(buf + len, size - len, "\n");
+
+	return len;
+}
+
+static ssize_t ath10k_dbg_sta_dump_tx_stats(struct file *file,
+					    char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	struct ieee80211_sta *sta = file->private_data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k *ar = arsta->arvif->ar;
+	char *buf;
+	static const char *str_name[ATH10K_STATS_TYPE_MAX] = {
+				"succ", "fail", "retry", "ampdu"};
+	int len = 0, i, j, retval = 0, size = 2 * 1024;
+
+	buf = kzalloc(size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&ar->conf_mutex);
+
+	for (i = 0; i < ATH10K_STATS_TYPE_MAX; i++)
+		for (j = 0; j < ATH10K_COUNTER_TYPE_MAX; j++)
+			len = ath10k_dump_htt_tx_stats(buf, len, size,
+						       arsta->tx_stats->stats[i],
+						       j, str_name[i]);
+
+	len += scnprintf(buf + len, size - len,
+			 "\nTX duration\n %llu usecs\n",
+			 arsta->tx_stats->tx_duration);
+	len += scnprintf(buf + len, size - len,
+			"BA fails\n %llu\n", arsta->tx_stats->ba_fails);
+	len += scnprintf(buf + len, size - len,
+			"ack fails\n %llu\n", arsta->tx_stats->ack_fails);
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
@@ -637,4 +733,8 @@ void ath10k_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    &fops_peer_debug_trigger);
 	debugfs_create_file("dump_tid_stats", 0400, dir, sta,
 			    &fops_tid_stats_dump);
+
+	if (ath10k_peer_stats_enabled(ar) && ar->debug.enable_extd_tx_stats)
+		debugfs_create_file("tx_stats", 0400, dir, sta,
+				    &fops_tx_stats);
 }
-- 
1.7.9.5

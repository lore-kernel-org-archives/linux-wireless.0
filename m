Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41766 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1HYHa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 03:30:56 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: [PATCH V2 2/3] ath6kl: Add debugfs entry to dump target stats
Date: Thu, 25 Aug 2011 13:00:40 +0530
Message-ID: <1314257441-8092-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110825_093059_297173_57CA6DD6)
In-Reply-To: <1314257441-8092-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1314257441-8092-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |  147 ++++++++++++++++++++++++++++++-
 1 files changed, 146 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 12775e8..5a082c0 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -147,6 +147,149 @@ void dump_cred_dist_stats(struct htc_target *target)
 		   target->cred_dist_cntxt->cur_free_credits);
 }
 
+static int ath6kl_debugfs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath6kl *ar = file->private_data;
+	struct target_stats *tgt_stats = &ar->target_stats;
+	char *buf;
+	unsigned int len = 0, buf_len = 1500;
+	int i;
+	long left;
+	ssize_t ret_cnt;
+
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (down_interruptible(&ar->sem)) {
+		kfree(buf);
+		return -EBUSY;
+	}
+
+	set_bit(STATS_UPDATE_PEND, &ar->flag);
+
+	if (ath6kl_wmi_get_stats_cmd(ar->wmi)) {
+		up(&ar->sem);
+		kfree(buf);
+		return -EIO;
+	}
+
+	left = wait_event_interruptible_timeout(ar->event_wq,
+						!test_bit(STATS_UPDATE_PEND,
+						&ar->flag), WMI_TIMEOUT);
+
+	up(&ar->sem);
+
+	if (left <= 0) {
+		kfree(buf);
+		return -ETIMEDOUT;
+	}
+
+	len += scnprintf(buf + len, buf_len - len, "\n");
+	len += scnprintf(buf + len, buf_len - len, "%25s\n",
+			 "Target Tx stats");
+	len += scnprintf(buf + len, buf_len - len, "%25s\n\n",
+			 "=================");
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Ucast packets", tgt_stats->tx_ucast_pkt);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Bcast packets", tgt_stats->tx_bcast_pkt);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Ucast byte", tgt_stats->tx_ucast_byte);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Bcast byte", tgt_stats->tx_bcast_byte);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Rts success cnt", tgt_stats->tx_rts_success_cnt);
+	for (i = 0; i < 4; i++)
+		len += scnprintf(buf + len, buf_len - len,
+				 "%18s %d %10llu\n", "PER on ac",
+				 i, tgt_stats->tx_pkt_per_ac[i]);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Error", tgt_stats->tx_err);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Fail count", tgt_stats->tx_fail_cnt);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Retry count", tgt_stats->tx_retry_cnt);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Multi retry cnt", tgt_stats->tx_mult_retry_cnt);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Rts fail cnt", tgt_stats->tx_rts_fail_cnt);
+	len += scnprintf(buf + len, buf_len - len, "%25s %10llu\n\n",
+			 "TKIP counter measure used",
+			 tgt_stats->tkip_cnter_measures_invoked);
+
+	len += scnprintf(buf + len, buf_len - len, "%25s\n",
+			 "Target Rx stats");
+	len += scnprintf(buf + len, buf_len - len, "%25s\n",
+			 "=================");
+
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Ucast packets", tgt_stats->rx_ucast_pkt);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10d\n",
+			 "Ucast Rate", tgt_stats->rx_ucast_rate);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Bcast packets", tgt_stats->rx_bcast_pkt);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Ucast byte", tgt_stats->rx_ucast_byte);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Bcast byte", tgt_stats->rx_bcast_byte);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Fragmented pkt", tgt_stats->rx_frgment_pkt);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Error", tgt_stats->rx_err);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "CRC Err", tgt_stats->rx_crc_err);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Key chache miss", tgt_stats->rx_key_cache_miss);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Decrypt Err", tgt_stats->rx_decrypt_err);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Duplicate frame", tgt_stats->rx_dupl_frame);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Tkip Mic failure", tgt_stats->tkip_local_mic_fail);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "TKIP format err", tgt_stats->tkip_fmt_err);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "CCMP format Err", tgt_stats->ccmp_fmt_err);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n\n",
+			 "CCMP Replay Err", tgt_stats->ccmp_replays);
+
+	len += scnprintf(buf + len, buf_len - len, "%25s\n",
+			 "Misc Target stats");
+	len += scnprintf(buf + len, buf_len - len, "%25s\n",
+			 "=================");
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Beacon Miss count", tgt_stats->cs_bmiss_cnt);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Num Connects", tgt_stats->cs_connect_cnt);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10llu\n",
+			 "Num disconnects", tgt_stats->cs_discon_cnt);
+	len += scnprintf(buf + len, buf_len - len, "%20s %10d\n",
+			 "Beacon avg rssi", tgt_stats->cs_ave_beacon_rssi);
+
+	if (len > buf_len)
+		len = buf_len;
+
+	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	kfree(buf);
+	return ret_cnt;
+}
+
+static const struct file_operations fops_tgt_stats = {
+	.read = read_file_tgt_stats,
+	.open = ath6kl_debugfs_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath6kl_debug_init(struct ath6kl *ar)
 {
 	ar->debugfs_phy = debugfs_create_dir("ath6kl",
@@ -154,7 +297,9 @@ int ath6kl_debug_init(struct ath6kl *ar)
 	if (!ar->debugfs_phy)
 		return -ENOMEM;
 
-	/* TODO: Create debugfs file entries for various target/host stats */
+	debugfs_create_file("tgt_stats", S_IRUSR, ar->debugfs_phy, ar,
+			    &fops_tgt_stats);
+
 	return 0;
 }
 #endif
-- 
1.7.0.4


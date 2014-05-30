Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62391 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbaE3IYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 04:24:36 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so1564612wgh.4
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 01:24:34 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2] ath10k: add implementation for configure max amsdu, ampdu
Date: Fri, 30 May 2014 10:24:15 +0200
Message-Id: <1401438255-7349-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140530_102441_750942_ED41EC25)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow to setup maximum subframes for AMSDU and AMPDU aggregation
via debugfs htt_max_amsdu_ampdu file.

Eg.
echo "2 64" > htt_max_amsdu_ampdu
will setup maximum amsdu subframes equal 2 and
maximum ampdu subframes equal to 64.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |    3 ++
 drivers/net/wireless/ath/ath10k/debug.c  |   73 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt.h    |   13 ++----
 drivers/net/wireless/ath/ath10k/htt_tx.c |   46 +++++++++++++++++++
 4 files changed, 127 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 68ceef6..83a5fa9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -290,6 +290,9 @@ struct ath10k_debug {
 	struct ath_dfs_pool_stats dfs_pool_stats;
 
 	u32 fw_dbglog_mask;
+
+	u8 htt_max_amsdu;
+	u8 htt_max_ampdu;
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 1b7ff4b..3030158 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -671,6 +671,72 @@ static const struct file_operations fops_htt_stats_mask = {
 	.llseek = default_llseek,
 };
 
+static ssize_t ath10k_read_htt_max_amsdu_ampdu(struct file *file,
+					       char __user *user_buf,
+					       size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char buf[64];
+	u8 amsdu = 3, ampdu = 64;
+	unsigned int len;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->debug.htt_max_amsdu)
+		amsdu = ar->debug.htt_max_amsdu;
+
+	if (ar->debug.htt_max_ampdu)
+		ampdu = ar->debug.htt_max_ampdu;
+
+	mutex_unlock(&ar->conf_mutex);
+
+	len = scnprintf(buf, sizeof(buf), "%u %u\n", amsdu, ampdu);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath10k_write_htt_max_amsdu_ampdu(struct file *file,
+						const char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	int res;
+	char buf[64];
+	unsigned int amsdu, ampdu;
+
+	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+
+	/* make sure that buf is null terminated */
+	buf[sizeof(buf) - 1] = 0;
+
+	res = sscanf(buf, "%u %u", &amsdu, &ampdu);
+
+	if (res != 2)
+		return -EINVAL;
+
+	mutex_lock(&ar->conf_mutex);
+
+	res = ath10k_htt_h2t_aggr_cfg_msg(&ar->htt, ampdu, amsdu);
+	if (res)
+		goto out;
+
+	res = count;
+	ar->debug.htt_max_amsdu = amsdu;
+	ar->debug.htt_max_ampdu = ampdu;
+
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return res;
+}
+
+static const struct file_operations fops_htt_max_amsdu_ampdu = {
+	.read = ath10k_read_htt_max_amsdu_ampdu,
+	.write = ath10k_write_htt_max_amsdu_ampdu,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static ssize_t ath10k_read_fw_dbglog(struct file *file,
 					    char __user *user_buf,
 					    size_t count, loff_t *ppos)
@@ -757,6 +823,9 @@ void ath10k_debug_stop(struct ath10k *ar)
 	 * warning from del_timer(). */
 	if (ar->debug.htt_stats_mask != 0)
 		cancel_delayed_work(&ar->debug.htt_stats_dwork);
+
+	ar->debug.htt_max_amsdu = 0;
+	ar->debug.htt_max_ampdu = 0;
 }
 
 static ssize_t ath10k_write_simulate_radar(struct file *file,
@@ -867,6 +936,10 @@ int ath10k_debug_create(struct ath10k *ar)
 	debugfs_create_file("htt_stats_mask", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_htt_stats_mask);
 
+	debugfs_create_file("htt_max_amsdu_ampdu", S_IRUSR | S_IWUSR,
+			    ar->debug.debugfs_phy, ar,
+			    &fops_htt_max_amsdu_ampdu);
+
 	debugfs_create_file("fw_dbglog", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_fw_dbglog);
 
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 9a26346..6c93f38 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -240,16 +240,10 @@ struct htt_oob_sync_req {
 	__le16 rsvd0;
 } __packed;
 
-#define HTT_AGGR_CONF_MAX_NUM_AMSDU_SUBFRAMES_MASK 0x1F
-#define HTT_AGGR_CONF_MAX_NUM_AMSDU_SUBFRAMES_LSB  0
-
 struct htt_aggr_conf {
 	u8 max_num_ampdu_subframes;
-	union {
-		/* dont use bitfields; undefined behaviour */
-		u8 flags; /* see %HTT_AGGR_CONF_MAX_NUM_AMSDU_SUBFRAMES_ */
-		u8 max_num_amsdu_subframes:5;
-	} __packed;
+	/* amsdu_subframes is limited by 0x1F mask */
+	u8 max_num_amsdu_subframes;
 } __packed;
 
 #define HTT_MGMT_FRM_HDR_DOWNLOAD_LEN 32
@@ -1343,6 +1337,9 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt);
 int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie);
 int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt);
+int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
+				u8 max_subfrms_ampdu,
+				u8 max_subfrms_amsdu);
 
 void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt);
 int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 7064354..accb6b4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -307,6 +307,52 @@ int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt)
 	return 0;
 }
 
+int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
+				u8 max_subfrms_ampdu,
+				u8 max_subfrms_amsdu)
+{
+	struct htt_aggr_conf *aggr_conf;
+	struct sk_buff *skb;
+	struct htt_cmd *cmd;
+	int len;
+	int ret;
+
+	/* Firmware defaults are: amsdu = 3 and ampdu = 64 */
+
+	if (max_subfrms_ampdu == 0 || max_subfrms_ampdu > 64)
+		return -EINVAL;
+
+	if (max_subfrms_amsdu == 0 || max_subfrms_amsdu > 31)
+		return -EINVAL;
+
+	len = sizeof(cmd->hdr);
+	len += sizeof(cmd->aggr_conf);
+
+	skb = ath10k_htc_alloc_skb(len);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_put(skb, len);
+	cmd = (struct htt_cmd *)skb->data;
+	cmd->hdr.msg_type = HTT_H2T_MSG_TYPE_AGGR_CFG;
+
+	aggr_conf = &cmd->aggr_conf;
+	aggr_conf->max_num_ampdu_subframes = max_subfrms_ampdu;
+	aggr_conf->max_num_amsdu_subframes = max_subfrms_amsdu;
+
+	ath10k_dbg(ATH10K_DBG_HTT, "htt h2t aggr cfg msg amsdu %d ampdu %d",
+		   aggr_conf->max_num_amsdu_subframes,
+		   aggr_conf->max_num_ampdu_subframes);
+
+	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
+	if (ret) {
+		dev_kfree_skb_any(skb);
+		return ret;
+	}
+
+	return 0;
+}
+
 int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 {
 	struct device *dev = htt->ar->dev;
-- 
1.7.9.5


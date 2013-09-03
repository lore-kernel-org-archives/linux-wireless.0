Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:39631 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab3ICIoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 04:44:13 -0400
Subject: [PATCH 3/3] ath10k: add htt_stats_enable debugfs file
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Sep 2013 11:44:10 +0300
Message-ID: <20130903084410.26199.96306.stgit@localhost6.localdomain6> (sfid-20130903_104416_726803_B0FF5249)
In-Reply-To: <20130903084302.26199.3538.stgit@localhost6.localdomain6>
References: <20130903084302.26199.3538.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |    3 +
 drivers/net/wireless/ath/ath10k/debug.c  |  111 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt.h    |    1 
 drivers/net/wireless/ath/ath10k/htt_tx.c |   42 +++++++++++
 4 files changed, 157 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 174c4b4..22b17d6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -246,6 +246,9 @@ struct ath10k_debug {
 	u32 wmi_service_bitmap[WMI_SERVICE_BM_SIZE];
 
 	struct completion event_stats_compl;
+
+	unsigned long htt_stats_mask;
+	struct delayed_work htt_stats_dwork;
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 219d469..59615c7 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -21,6 +21,9 @@
 #include "core.h"
 #include "debug.h"
 
+/* ms */
+#define ATH10K_DEBUG_HTT_STATS_INTERVAL 1000
+
 static int ath10k_printk(const char *level, const char *fmt, ...)
 {
 	struct va_format vaf;
@@ -517,13 +520,115 @@ static const struct file_operations fops_chip_id = {
 	.llseek = default_llseek,
 };
 
+static int ath10k_debug_htt_stats_req(struct ath10k *ar)
+{
+	u64 cookie;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (ar->debug.htt_stats_mask == 0)
+		/* htt stats are disabled */
+		return 0;
+
+	if (ar->state != ATH10K_STATE_ON)
+		return 0;
+
+	cookie = get_jiffies_64();
+
+	ret = ath10k_htt_h2t_stats_req(&ar->htt, ar->debug.htt_stats_mask,
+				       cookie);
+	if (ret) {
+		ath10k_warn("failed to send htt stats request: %d\n", ret);
+		return ret;
+	}
+
+	queue_delayed_work(ar->workqueue, &ar->debug.htt_stats_dwork,
+			   msecs_to_jiffies(ATH10K_DEBUG_HTT_STATS_INTERVAL));
+
+	return 0;
+}
+
+static void ath10k_debug_htt_stats_dwork(struct work_struct *work)
+{
+	struct ath10k *ar = container_of(work, struct ath10k,
+					 debug.htt_stats_dwork.work);
+
+	mutex_lock(&ar->conf_mutex);
+
+	ath10k_debug_htt_stats_req(ar);
+
+	mutex_unlock(&ar->conf_mutex);
+}
+
+static ssize_t ath10k_read_htt_stats_mask(struct file *file,
+					    char __user *user_buf,
+					    size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = scnprintf(buf, sizeof(buf), "%lu\n", ar->debug.htt_stats_mask);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t ath10k_write_htt_stats_mask(struct file *file,
+					     const char __user *user_buf,
+					     size_t count, loff_t *ppos)
+{
+	struct ath10k *ar = file->private_data;
+	unsigned long mask;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 0, &mask);
+	if (ret)
+		return ret;
+
+	/* max 8 bit masks (for now) */
+	if (mask > 0xff)
+		return -E2BIG;
+
+	mutex_lock(&ar->conf_mutex);
+
+	ar->debug.htt_stats_mask = mask;
+
+	ret = ath10k_debug_htt_stats_req(ar);
+	if (ret)
+		goto out;
+
+	ret = count;
+
+out:
+	mutex_unlock(&ar->conf_mutex);
+
+	return ret;
+}
+
+static const struct file_operations fops_htt_stats_mask = {
+	.read = ath10k_read_htt_stats_mask,
+	.write = ath10k_write_htt_stats_mask,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath10k_debug_start(struct ath10k *ar)
 {
+	int ret;
+
+	ret = ath10k_debug_htt_stats_req(ar);
+	if (ret)
+		/* continue normally anyway, this isn't serious */
+		ath10k_warn("failed to start htt stats workqueue: %d\n", ret);
+
 	return 0;
 }
 
 void ath10k_debug_stop(struct ath10k *ar)
 {
+	cancel_delayed_work_sync(&ar->debug.htt_stats_dwork);
 }
 
 int ath10k_debug_create(struct ath10k *ar)
@@ -534,6 +639,9 @@ int ath10k_debug_create(struct ath10k *ar)
 	if (!ar->debug.debugfs_phy)
 		return -ENOMEM;
 
+	INIT_DELAYED_WORK(&ar->debug.htt_stats_dwork,
+			  ath10k_debug_htt_stats_dwork);
+
 	init_completion(&ar->debug.event_stats_compl);
 
 	debugfs_create_file("fw_stats", S_IRUSR, ar->debug.debugfs_phy, ar,
@@ -548,6 +656,9 @@ int ath10k_debug_create(struct ath10k *ar)
 	debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
 			    ar, &fops_chip_id);
 
+	debugfs_create_file("htt_stats_mask", S_IRUSR, ar->debug.debugfs_phy,
+			    ar, &fops_htt_stats_mask);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 26c78a9..e090902 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1327,6 +1327,7 @@ void ath10k_htt_rx_detach(struct ath10k_htt *htt);
 void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt);
+int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie);
 int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt);
 
 void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index d4fb387..b6b1420 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -203,6 +203,48 @@ int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt)
 	return 0;
 }
 
+int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie)
+{
+	struct htt_stats_req *req;
+	struct sk_buff *skb;
+	struct htt_cmd *cmd;
+	int len = 0, ret;
+
+	len += sizeof(cmd->hdr);
+	len += sizeof(cmd->stats_req);
+
+	skb = ath10k_htc_alloc_skb(len);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_put(skb, len);
+	cmd = (struct htt_cmd *)skb->data;
+	cmd->hdr.msg_type = HTT_H2T_MSG_TYPE_STATS_REQ;
+
+	req = &cmd->stats_req;
+
+	memset(req, 0, sizeof(*req));
+
+	/* currently we support only max 8 bit masks so no need to worry
+	 * about endian support */
+	req->upload_types[0] = mask;
+	req->reset_types[0] = mask;
+	req->stat_type = HTT_STATS_REQ_CFG_STAT_TYPE_INVALID;
+	req->cookie_lsb = cpu_to_le32(cookie & 0xffffffff);
+	req->cookie_msb = cpu_to_le32((cookie & 0xffffffff00000000ULL) >> 32);
+
+	ATH10K_SKB_CB(skb)->htt.is_conf = true;
+
+	ret = ath10k_htc_send(&htt->ar->htc, htt->eid, skb);
+	if (ret) {
+		ath10k_warn("failed to send htt type stats request: %d", ret);
+		dev_kfree_skb_any(skb);
+		return ret;
+	}
+
+	return 0;
+}
+
 int ath10k_htt_send_rx_ring_cfg_ll(struct ath10k_htt *htt)
 {
 	struct sk_buff *skb;


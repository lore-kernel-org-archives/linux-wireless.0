Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43412 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaLSGzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 01:55:47 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/8] ath10k: add wmi support for addba_send
Date: Fri, 19 Dec 2014 12:24:53 +0530
Message-ID: <1418972099-5296-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141219_075614_605002_D5FB7B66)
In-Reply-To: <1418972099-5296-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1418972099-5296-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WMI support for sending addba request. This command is meant
for debugging purpose.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 19 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c     | 29 +++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index b161043..badf422 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -121,6 +121,8 @@ struct wmi_ops {
 	struct sk_buff *(*gen_pdev_get_temperature)(struct ath10k *ar);
 	struct sk_buff *(*gen_addba_clear_resp)(struct ath10k *ar, u32 vdev_id,
 						const u8 *mac);
+	struct sk_buff *(*gen_addba_send)(struct ath10k *ar, u32 vdev_id,
+					  const u8 *mac, u32 tid, u32 buf_size);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -875,4 +877,21 @@ ath10k_wmi_addba_clear_resp(struct ath10k *ar, u32 vdev_id, const u8 *mac)
 				   ar->wmi.cmd->addba_clear_resp_cmdid);
 }
 
+static inline int
+ath10k_wmi_addba_send(struct ath10k *ar, u32 vdev_id, const u8 *mac,
+		      u32 tid, u32 buf_size)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_addba_send)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_addba_send(ar, vdev_id, mac, tid, buf_size);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->addba_send_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 499a779..74a0598 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2208,6 +2208,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	/* .gen_pdev_set_quiet_mode not implemented */
 	/* .gen_pdev_get_temperature not implemented */
 	/* .gen_addba_clear_resp not implemented */
+	/* .gen_addba_send not implemented */
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 0053641..b118795 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4668,6 +4668,32 @@ ath10k_wmi_op_gen_addba_clear_resp(struct ath10k *ar, u32 vdev_id,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_op_gen_addba_send(struct ath10k *ar, u32 vdev_id, const u8 *mac,
+			     u32 tid, u32 buf_size)
+{
+	struct wmi_addba_send_cmd *cmd;
+	struct sk_buff *skb;
+
+	if (!mac)
+		return ERR_PTR(-EINVAL);
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_addba_send_cmd *)skb->data;
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	ether_addr_copy(cmd->peer_macaddr.addr, mac);
+	cmd->tid = __cpu_to_le32(tid);
+	cmd->buffersize = __cpu_to_le32(buf_size);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi addba send vdev_id 0x%X mac_addr %pM tid %u bufsize %u\n",
+		   vdev_id, mac, tid, buf_size);
+	return skb;
+}
+
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -4720,6 +4746,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	/* .gen_pdev_get_temperature not implemented */
 	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
+	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -4775,6 +4802,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
+	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -4831,6 +4859,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
+	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
2.2.0


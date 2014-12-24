Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40254 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaLXIAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 03:00:10 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 3/8] ath10k: add wmi support for addba_set_resp
Date: Wed, 24 Dec 2014 13:29:04 +0530
Message-ID: <1419407949-32367-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141224_090014_179405_31865841)
In-Reply-To: <1419407949-32367-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1419407949-32367-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WMI support for sending addba response manually. This command
is used for debugging purpose.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c     | 30 ++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index badf422..e8f49de 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -123,6 +123,9 @@ struct wmi_ops {
 						const u8 *mac);
 	struct sk_buff *(*gen_addba_send)(struct ath10k *ar, u32 vdev_id,
 					  const u8 *mac, u32 tid, u32 buf_size);
+	struct sk_buff *(*gen_addba_set_resp)(struct ath10k *ar, u32 vdev_id,
+					      const u8 *mac, u32 tid,
+					      u32 status);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -894,4 +897,21 @@ ath10k_wmi_addba_send(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 				   ar->wmi.cmd->addba_send_cmdid);
 }
 
+static inline int
+ath10k_wmi_addba_set_resp(struct ath10k *ar, u32 vdev_id, const u8 *mac,
+			  u32 tid, u32 status)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_addba_set_resp)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_addba_set_resp(ar, vdev_id, mac, tid, status);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->addba_set_resp_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 74a0598..63f9860 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2209,6 +2209,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	/* .gen_pdev_get_temperature not implemented */
 	/* .gen_addba_clear_resp not implemented */
 	/* .gen_addba_send not implemented */
+	/* .gen_addba_set_resp not implemented */
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 8103cbc..dd17c00 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4927,6 +4927,32 @@ ath10k_wmi_op_gen_addba_send(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_op_gen_addba_set_resp(struct ath10k *ar, u32 vdev_id, const u8 *mac,
+				 u32 tid, u32 status)
+{
+	struct wmi_addba_setresponse_cmd *cmd;
+	struct sk_buff *skb;
+
+	if (!mac)
+		return ERR_PTR(-EINVAL);
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_addba_setresponse_cmd *)skb->data;
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	ether_addr_copy(cmd->peer_macaddr.addr, mac);
+	cmd->tid = __cpu_to_le32(tid);
+	cmd->statuscode = __cpu_to_le32(status);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi addba set resp vdev_id 0x%X mac_addr %pM tid %u status %u\n",
+		   vdev_id, mac, tid, status);
+	return skb;
+}
+
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -4980,6 +5006,7 @@ static const struct wmi_ops wmi_ops = {
 	/* .gen_pdev_get_temperature not implemented */
 	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
+	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -5036,6 +5063,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
+	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -5093,6 +5121,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
+	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 };
 
 static const struct wmi_ops wmi_10_2_4_ops = {
@@ -5150,6 +5179,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
 	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
+	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
2.2.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46676 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaLQPWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 10:22:17 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so16480536wiv.7
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 07:22:16 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/5] ath10k: implement prb tmpl wmi command
Date: Wed, 17 Dec 2014 16:21:49 +0100
Message-Id: <1418829711-19713-4-git-send-email-bartosz.markowski@tieto.com> (sfid-20141217_162227_225841_89E22091)
In-Reply-To: <1418829711-19713-1-git-send-email-bartosz.markowski@tieto.com>
References: <1418829711-19713-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

New firmware revisions with beacon templates need
probe templates as well because they don't forward
probe requests to host at all.

This is required for new firmware to work with
direct probe requests (notably required by hidden
ssid AP).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 17 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 50 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  5 ++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  3 ++
 4 files changed, 75 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index fb12666..5eff204 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -118,6 +118,8 @@ struct wmi_ops {
 					u32 tim_ie_offset, struct sk_buff *bcn,
 					u32 prb_caps, u32 prb_erp,
 					void *prb_ies, size_t prb_ies_len);
+	struct sk_buff *(*gen_prb_tmpl)(struct ath10k *ar, u32 vdev_id,
+					struct sk_buff *bcn);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -841,4 +843,19 @@ ath10k_wmi_bcn_tmpl(struct ath10k *ar, u32 vdev_id, u32 tim_ie_offset,
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->bcn_tmpl_cmdid);
 }
 
+static inline int
+ath10k_wmi_prb_tmpl(struct ath10k *ar, u32 vdev_id, struct sk_buff *prb)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_prb_tmpl)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_prb_tmpl(ar, vdev_id, prb);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->prb_tmpl_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index f6ea938..096407c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2036,6 +2036,55 @@ ath10k_wmi_tlv_op_gen_bcn_tmpl(struct ath10k *ar, u32 vdev_id,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_prb_tmpl(struct ath10k *ar, u32 vdev_id,
+			       struct sk_buff *prb)
+{
+	struct wmi_tlv_prb_tmpl_cmd *cmd;
+	struct wmi_tlv_bcn_prb_info *info;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	void *ptr;
+	size_t len;
+
+	len = sizeof(*tlv) + sizeof(*cmd) +
+	      sizeof(*tlv) + sizeof(*info) +
+	      sizeof(*tlv) + roundup(prb->len, 4);
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ptr = (void *)skb->data;
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_PRB_TMPL_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	cmd->buf_len = __cpu_to_le32(prb->len);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_BCN_PRB_INFO);
+	tlv->len = __cpu_to_le16(sizeof(*info));
+	info = (void *)tlv->value;
+	info->caps = 0;
+	info->erp = 0;
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*info);
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_BYTE);
+	tlv->len = __cpu_to_le16(roundup(prb->len, 4));
+	memcpy(tlv->value, prb->data, prb->len);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv prb tmpl vdev_id %i\n",
+		   vdev_id);
+	return skb;
+}
+
 /****************/
 /* TLV mappings */
 /****************/
@@ -2319,6 +2368,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_pktlog_enable = ath10k_wmi_tlv_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_tlv_op_gen_pktlog_disable,
 	.gen_bcn_tmpl = ath10k_wmi_tlv_op_gen_bcn_tmpl,
+	.gen_prb_tmpl = ath10k_wmi_tlv_op_gen_prb_tmpl,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index c477365..5772519 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1399,6 +1399,11 @@ struct wmi_tlv_bcn_tmpl_cmd {
 	__le32 buf_len;
 } __packed;
 
+struct wmi_tlv_prb_tmpl_cmd {
+	__le32 vdev_id;
+	__le32 buf_len;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f75a1a3..dc76ff8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4639,6 +4639,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	/* .gen_bcn_tmpl not implemented */
+	/* .gen_prb_tmpl not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -4692,6 +4693,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	/* .gen_bcn_tmpl not implemented */
+	/* .gen_prb_tmpl not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -4746,6 +4748,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	/* .gen_bcn_tmpl not implemented */
+	/* .gen_prb_tmpl not implemented */
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
1.8.2


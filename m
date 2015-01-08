Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:63742 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbbAHLM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 06:12:57 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so1849328wes.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 03:12:56 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/5] ath10k: implement prb tmpl wmi command
Date: Thu,  8 Jan 2015 12:12:28 +0100
Message-Id: <1420715550-16017-4-git-send-email-michal.kazior@tieto.com> (sfid-20150108_121303_825373_8F00DDA9)
In-Reply-To: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
References: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 2ef75ef..148a44a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -123,6 +123,8 @@ struct wmi_ops {
 					u32 tim_ie_offset, struct sk_buff *bcn,
 					u32 prb_caps, u32 prb_erp,
 					void *prb_ies, size_t prb_ies_len);
+	struct sk_buff *(*gen_prb_tmpl)(struct ath10k *ar, u32 vdev_id,
+					struct sk_buff *bcn);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -880,4 +882,19 @@ ath10k_wmi_bcn_tmpl(struct ath10k *ar, u32 vdev_id, u32 tim_ie_offset,
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
index 11be2d5..1713f8c 100644
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
@@ -2322,6 +2371,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	/* .gen_pdev_set_quiet_mode not implemented */
 	/* .gen_pdev_get_temperature not implemented */
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
index 491c18c..8c46de1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4929,6 +4929,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	/* .gen_pdev_get_temperature not implemented */
 	/* .gen_bcn_tmpl not implemented */
+	/* .gen_prb_tmpl not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -4984,6 +4985,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	/* .gen_bcn_tmpl not implemented */
+	/* .gen_prb_tmpl not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -5095,6 +5097,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	/* .gen_bcn_tmpl not implemented */
+	/* .gen_prb_tmpl not implemented */
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
1.8.5.3


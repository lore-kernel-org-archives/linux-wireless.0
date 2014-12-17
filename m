Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52474 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQPWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 10:22:16 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so20479626wgg.21
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 07:22:15 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/5] ath10k: implement beacon template command
Date: Wed, 17 Dec 2014 16:21:48 +0100
Message-Id: <1418829711-19713-3-git-send-email-bartosz.markowski@tieto.com> (sfid-20141217_162222_069253_660D694D)
In-Reply-To: <1418829711-19713-1-git-send-email-bartosz.markowski@tieto.com>
References: <1418829711-19713-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

New firmware revisions may support setting beacon
template. Implement wmi interface for it.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 23 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 65 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 12 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  3 ++
 4 files changed, 103 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 1fbc520..fb12666 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -114,6 +114,10 @@ struct wmi_ops {
 	struct sk_buff *(*gen_dbglog_cfg)(struct ath10k *ar, u32 module_enable);
 	struct sk_buff *(*gen_pktlog_enable)(struct ath10k *ar, u32 filter);
 	struct sk_buff *(*gen_pktlog_disable)(struct ath10k *ar);
+	struct sk_buff *(*gen_bcn_tmpl)(struct ath10k *ar, u32 vdev_id,
+					u32 tim_ie_offset, struct sk_buff *bcn,
+					u32 prb_caps, u32 prb_erp,
+					void *prb_ies, size_t prb_ies_len);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -818,4 +822,23 @@ ath10k_wmi_pdev_pktlog_disable(struct ath10k *ar)
 				   ar->wmi.cmd->pdev_pktlog_disable_cmdid);
 }
 
+static inline int
+ath10k_wmi_bcn_tmpl(struct ath10k *ar, u32 vdev_id, u32 tim_ie_offset,
+		    struct sk_buff *bcn, u32 prb_caps, u32 prb_erp,
+		    void *prb_ies, size_t prb_ies_len)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_bcn_tmpl)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_bcn_tmpl(ar, vdev_id, tim_ie_offset, bcn,
+					prb_caps, prb_erp, prb_ies,
+					prb_ies_len);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->bcn_tmpl_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 0f7a3ae..f6ea938 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1972,6 +1972,70 @@ ath10k_wmi_tlv_op_gen_pktlog_disable(struct ath10k *ar)
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_bcn_tmpl(struct ath10k *ar, u32 vdev_id,
+			       u32 tim_ie_offset, struct sk_buff *bcn,
+			       u32 prb_caps, u32 prb_erp, void *prb_ies,
+			       size_t prb_ies_len)
+{
+	struct wmi_tlv_bcn_tmpl_cmd *cmd;
+	struct wmi_tlv_bcn_prb_info *info;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	void *ptr;
+	size_t len;
+
+	if (WARN_ON(prb_ies_len > 0 && !prb_ies))
+		return ERR_PTR(-EINVAL);
+
+	len = sizeof(*tlv) + sizeof(*cmd) +
+	      sizeof(*tlv) + sizeof(*info) + prb_ies_len +
+	      sizeof(*tlv) + roundup(bcn->len, 4);
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ptr = (void *)skb->data;
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_BCN_TMPL_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	cmd->tim_ie_offset = __cpu_to_le32(tim_ie_offset);
+	cmd->buf_len = __cpu_to_le32(bcn->len);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	/* FIXME: prb_ies_len should be probably aligned to 4byte boundary but
+	 * then it is then impossible to pass original ie len.
+	 * This chunk is not used yet so if setting probe resp template yields
+	 * problems with beaconing or crashes firmware look here.
+	 */
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_BCN_PRB_INFO);
+	tlv->len = __cpu_to_le16(sizeof(*info) + prb_ies_len);
+	info = (void *)tlv->value;
+	info->caps = __cpu_to_le32(prb_caps);
+	info->erp = __cpu_to_le32(prb_erp);
+	memcpy(info->ies, prb_ies, prb_ies_len);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*info);
+	ptr += prb_ies_len;
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_BYTE);
+	tlv->len = __cpu_to_le16(roundup(bcn->len, 4));
+	memcpy(tlv->value, bcn->data, bcn->len);
+
+	/* FIXME: Adjust TSF? */
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv bcn tmpl vdev_id %i\n",
+		   vdev_id);
+	return skb;
+}
+
 /****************/
 /* TLV mappings */
 /****************/
@@ -2254,6 +2318,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_dbglog_cfg = ath10k_wmi_tlv_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_tlv_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_tlv_op_gen_pktlog_disable,
+	.gen_bcn_tmpl = ath10k_wmi_tlv_op_gen_bcn_tmpl,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index ee19353..c477365 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1387,6 +1387,18 @@ struct wmi_tlv_bcn_tx_status_ev {
 	__le32 tx_status;
 } __packed;
 
+struct wmi_tlv_bcn_prb_info {
+	__le32 caps;
+	__le32 erp;
+	u8 ies[0];
+} __packed;
+
+struct wmi_tlv_bcn_tmpl_cmd {
+	__le32 vdev_id;
+	__le32 tim_ie_offset;
+	__le32 buf_len;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index fa486f6..f75a1a3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4638,6 +4638,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+	/* .gen_bcn_tmpl not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -4690,6 +4691,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+	/* .gen_bcn_tmpl not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -4743,6 +4745,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+	/* .gen_bcn_tmpl not implemented */
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
1.8.2


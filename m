Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47343 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbbAHLM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 06:12:56 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so2507197wib.4
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 03:12:54 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/5] ath10k: implement beacon template command
Date: Thu,  8 Jan 2015 12:12:27 +0100
Message-Id: <1420715550-16017-3-git-send-email-michal.kazior@tieto.com> (sfid-20150108_121259_348859_B6BCCA69)
In-Reply-To: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
References: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 20e2c30..2ef75ef 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -119,6 +119,10 @@ struct wmi_ops {
 						   u32 next_offset,
 						   u32 enabled);
 	struct sk_buff *(*gen_pdev_get_temperature)(struct ath10k *ar);
+	struct sk_buff *(*gen_bcn_tmpl)(struct ath10k *ar, u32 vdev_id,
+					u32 tim_ie_offset, struct sk_buff *bcn,
+					u32 prb_caps, u32 prb_erp,
+					void *prb_ies, size_t prb_ies_len);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -857,4 +861,23 @@ ath10k_wmi_pdev_get_temperature(struct ath10k *ar)
 				   ar->wmi.cmd->pdev_get_temperature_cmdid);
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
index ae7c898..11be2d5 100644
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
@@ -2257,6 +2321,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_pktlog_disable = ath10k_wmi_tlv_op_gen_pktlog_disable,
 	/* .gen_pdev_set_quiet_mode not implemented */
 	/* .gen_pdev_get_temperature not implemented */
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
index ac74290..491c18c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4928,6 +4928,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	/* .gen_pdev_get_temperature not implemented */
+	/* .gen_bcn_tmpl not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -4982,6 +4983,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
+	/* .gen_bcn_tmpl not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -5092,6 +5094,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
+	/* .gen_bcn_tmpl not implemented */
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
1.8.5.3


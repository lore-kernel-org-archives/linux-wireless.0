Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:47587 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546AbbAILOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 06:14:50 -0500
Received: by mail-we0-f176.google.com with SMTP id w61so7361941wes.7
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 03:14:49 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 4/8] ath10k: implement adaptive qcs command
Date: Fri,  9 Jan 2015 12:14:05 +0100
Message-Id: <1420802049-11962-5-git-send-email-michal.kazior@tieto.com> (sfid-20150109_121505_674219_03F264DD)
In-Reply-To: <1420802049-11962-1-git-send-email-michal.kazior@tieto.com>
References: <1420802049-11962-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This command is used in latest firmware revisions
to control multi-channel scheduler.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  3 +++
 drivers/net/wireless/ath/ath10k/wmi.h     |  1 +
 5 files changed, 54 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 8e815d4..7dc7b1b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -127,6 +127,7 @@ struct wmi_ops {
 					struct sk_buff *bcn);
 	struct sk_buff *(*gen_p2p_go_bcn_ie)(struct ath10k *ar, u32 vdev_id,
 					     const u8 *p2p_ie);
+	struct sk_buff *(*gen_adaptive_qcs)(struct ath10k *ar, bool enable);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -914,4 +915,19 @@ ath10k_wmi_p2p_go_bcn_ie(struct ath10k *ar, u32 vdev_id, const u8 *p2p_ie)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->p2p_go_set_beacon_ie);
 }
 
+static inline int
+ath10k_wmi_adaptive_qcs(struct ath10k *ar, bool enable)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_adaptive_qcs)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_adaptive_qcs(ar, enable);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->adaptive_qcs_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ea7fe78..ef55110 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2222,6 +2222,34 @@ ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie(struct ath10k *ar, u32 vdev_id,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_adaptive_qcs(struct ath10k *ar, bool enable)
+{
+	struct wmi_tlv_adaptive_qcs *cmd;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	void *ptr;
+	size_t len;
+
+	len = sizeof(*tlv) + sizeof(*cmd);
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ptr = (void *)skb->data;
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_RESMGR_ADAPTIVE_OCS_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+	cmd->enable = __cpu_to_le32(enable ? 1 : 0);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv adaptive qcs %d\n", enable);
+	return skb;
+}
+
 /****************/
 /* TLV mappings */
 /****************/
@@ -2345,6 +2373,7 @@ static struct wmi_cmd_map wmi_tlv_cmd_map = {
 	.gpio_config_cmdid = WMI_TLV_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_TLV_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_TLV_CMD_UNSUPPORTED,
+	.adaptive_qcs_cmdid = WMI_TLV_RESMGR_ADAPTIVE_OCS_CMDID,
 };
 
 static struct wmi_pdev_param_map wmi_tlv_pdev_param_map = {
@@ -2510,6 +2539,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_bcn_tmpl = ath10k_wmi_tlv_op_gen_bcn_tmpl,
 	.gen_prb_tmpl = ath10k_wmi_tlv_op_gen_prb_tmpl,
 	.gen_p2p_go_bcn_ie = ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie,
+	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 87db762..c311b3c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1428,6 +1428,10 @@ struct wmi_tlv_diag_data_ev {
 	__le32 num_items;
 } __packed;
 
+struct wmi_tlv_adaptive_qcs {
+	__le32 enable;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index cff16e4..ee68e6b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4944,6 +4944,7 @@ static const struct wmi_ops wmi_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -5001,6 +5002,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -5114,6 +5116,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index bd7f29a..af5f88cf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -551,6 +551,7 @@ struct wmi_cmd_map {
 	u32 gpio_config_cmdid;
 	u32 gpio_output_cmdid;
 	u32 pdev_get_temperature_cmdid;
+	u32 adaptive_qcs_cmdid;
 };
 
 /*
-- 
1.8.5.3


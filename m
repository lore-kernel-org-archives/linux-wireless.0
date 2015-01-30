Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:42614 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbbA3Mdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 07:33:35 -0500
Received: by mail-we0-f181.google.com with SMTP id k48so26899420wev.12
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 04:33:34 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/7] ath10k: implement adaptive qcs command
Date: Fri, 30 Jan 2015 13:31:22 +0100
Message-Id: <1422621086-28970-4-git-send-email-michal.kazior@tieto.com> (sfid-20150130_133343_807604_1CDC1FB0)
In-Reply-To: <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
 <1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This command will be used to configure
multi-channel scheduler in firmware.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  3 +++
 drivers/net/wireless/ath/ath10k/wmi.h     |  1 +
 5 files changed, 54 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 058f88b..cf9d34f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -145,6 +145,7 @@ struct wmi_ops {
 					      u32 num_ac);
 	struct sk_buff *(*gen_sta_keepalive)(struct ath10k *ar,
 					     const struct wmi_sta_keepalive_arg *arg);
+	struct sk_buff *(*gen_adaptive_qcs)(struct ath10k *ar, bool enable);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1054,4 +1055,19 @@ ath10k_wmi_sta_keepalive(struct ath10k *ar,
 	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
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
index ccafb69..0e36b34 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2381,6 +2381,34 @@ ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie(struct ath10k *ar, u32 vdev_id,
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
@@ -2505,6 +2533,7 @@ static struct wmi_cmd_map wmi_tlv_cmd_map = {
 	.gpio_output_cmdid = WMI_TLV_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_TLV_CMD_UNSUPPORTED,
 	.vdev_set_wmm_params_cmdid = WMI_TLV_VDEV_SET_WMM_PARAMS_CMDID,
+	.adaptive_qcs_cmdid = WMI_TLV_RESMGR_ADAPTIVE_OCS_CMDID,
 };
 
 static struct wmi_pdev_param_map wmi_tlv_pdev_param_map = {
@@ -2677,6 +2706,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_p2p_go_bcn_ie = ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie,
 	.gen_vdev_sta_uapsd = ath10k_wmi_tlv_op_gen_vdev_sta_uapsd,
 	.gen_sta_keepalive = ath10k_wmi_tlv_op_gen_sta_keepalive,
+	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index de68fe7..a05952a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1439,6 +1439,10 @@ struct wmi_tlv_sta_keepalive_cmd {
 	__le32 interval; /* in seconds */
 } __packed;
 
+struct wmi_tlv_adaptive_qcs {
+	__le32 enable;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 0b49ec4..8966848 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5224,6 +5224,7 @@ static const struct wmi_ops wmi_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -5286,6 +5287,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -5408,6 +5410,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 20ce360..69c7cf4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -552,6 +552,7 @@ struct wmi_cmd_map {
 	u32 gpio_output_cmdid;
 	u32 pdev_get_temperature_cmdid;
 	u32 vdev_set_wmm_params_cmdid;
+	u32 adaptive_qcs_cmdid;
 };
 
 /*
-- 
1.8.5.3


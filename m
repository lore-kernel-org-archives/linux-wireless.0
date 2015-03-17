Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:33952 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbbCQMd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 08:33:26 -0400
Received: by lagg8 with SMTP id g8so7135844lag.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2015 05:33:24 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 3/7] ath10k: implement adaptive qcs command
Date: Tue, 17 Mar 2015 12:30:44 +0000
Message-Id: <1426595448-1630-4-git-send-email-michal.kazior@tieto.com> (sfid-20150317_133332_548601_934B534C)
In-Reply-To: <1426595448-1630-1-git-send-email-michal.kazior@tieto.com>
References: <1426595448-1630-1-git-send-email-michal.kazior@tieto.com>
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
index f0a8b8d..3c8325c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -150,6 +150,7 @@ struct wmi_ops {
 					      u32 num_ac);
 	struct sk_buff *(*gen_sta_keepalive)(struct ath10k *ar,
 					     const struct wmi_sta_keepalive_arg *arg);
+	struct sk_buff *(*gen_adaptive_qcs)(struct ath10k *ar, bool enable);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1072,4 +1073,19 @@ ath10k_wmi_sta_keepalive(struct ath10k *ar,
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
index fa3eb1b..a359a7e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2561,6 +2561,34 @@ ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie(struct ath10k *ar, u32 vdev_id,
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
@@ -2685,6 +2713,7 @@ static struct wmi_cmd_map wmi_tlv_cmd_map = {
 	.gpio_output_cmdid = WMI_TLV_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_TLV_CMD_UNSUPPORTED,
 	.vdev_set_wmm_params_cmdid = WMI_TLV_VDEV_SET_WMM_PARAMS_CMDID,
+	.adaptive_qcs_cmdid = WMI_TLV_RESMGR_ADAPTIVE_OCS_CMDID,
 };
 
 static struct wmi_pdev_param_map wmi_tlv_pdev_param_map = {
@@ -2858,6 +2887,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_p2p_go_bcn_ie = ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie,
 	.gen_vdev_sta_uapsd = ath10k_wmi_tlv_op_gen_vdev_sta_uapsd,
 	.gen_sta_keepalive = ath10k_wmi_tlv_op_gen_sta_keepalive,
+	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 06b37b2..1b373f2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1464,6 +1464,10 @@ struct wmi_tlv_roam_ev {
 	__le32 rssi;
 } __packed;
 
+struct wmi_tlv_adaptive_qcs {
+	__le32 enable;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index eb66fc4..34412ee 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5249,6 +5249,7 @@ static const struct wmi_ops wmi_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -5312,6 +5313,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -5436,6 +5438,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 938e652..714c211 100644
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
2.1.4


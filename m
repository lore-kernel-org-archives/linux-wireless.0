Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:32818 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbCXMp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 08:45:56 -0400
Received: by lbcmq2 with SMTP id mq2so29721385lbc.0
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 05:45:54 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v5 3/7] ath10k: implement adaptive qcs command
Date: Tue, 24 Mar 2015 12:43:09 +0000
Message-Id: <1427200993-7550-4-git-send-email-michal.kazior@tieto.com> (sfid-20150324_134603_538208_B7C5567E)
In-Reply-To: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
References: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
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
index 5d7bbec17b53..47fe2e756bec 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -173,6 +173,7 @@ struct wmi_ops {
 						const struct wmi_tdls_peer_update_cmd_arg *arg,
 						const struct wmi_tdls_peer_capab_arg *cap,
 						const struct wmi_channel_arg *chan);
+	struct sk_buff *(*gen_adaptive_qcs)(struct ath10k *ar, bool enable);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1232,4 +1233,19 @@ ath10k_wmi_tdls_peer_update(struct ath10k *ar,
 				   ar->wmi.cmd->tdls_peer_update_cmdid);
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
index d4804645f8c2..04a83308778f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2948,6 +2948,34 @@ ath10k_wmi_tlv_op_gen_wow_del_pattern(struct ath10k *ar, u32 vdev_id,
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
@@ -3074,6 +3102,7 @@ static struct wmi_cmd_map wmi_tlv_cmd_map = {
 	.vdev_set_wmm_params_cmdid = WMI_TLV_VDEV_SET_WMM_PARAMS_CMDID,
 	.tdls_set_state_cmdid = WMI_TLV_TDLS_SET_STATE_CMDID,
 	.tdls_peer_update_cmdid = WMI_TLV_TDLS_PEER_UPDATE_CMDID,
+	.adaptive_qcs_cmdid = WMI_TLV_RESMGR_ADAPTIVE_OCS_CMDID,
 };
 
 static struct wmi_pdev_param_map wmi_tlv_pdev_param_map = {
@@ -3255,6 +3284,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_wow_del_pattern = ath10k_wmi_tlv_op_gen_wow_del_pattern,
 	.gen_update_fw_tdls_state = ath10k_wmi_tlv_op_gen_update_fw_tdls_state,
 	.gen_tdls_peer_update = ath10k_wmi_tlv_op_gen_tdls_peer_update,
+	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index f65b6148cc77..8d41492f3aff 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1576,6 +1576,10 @@ struct wmi_tdls_peer_capab {
 	__le32 pref_offchan_bw;
 } __packed;
 
+struct wmi_tlv_adaptive_qcs {
+	__le32 enable;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 9694cd0a0249..20fd9f61fbad 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5212,6 +5212,7 @@ static const struct wmi_ops wmi_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -5275,6 +5276,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -5399,6 +5401,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
+	/* .gen_adaptive_qcs not implemented */
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 00b5799c5cdb..d0942b0a4326 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -554,6 +554,7 @@ struct wmi_cmd_map {
 	u32 vdev_set_wmm_params_cmdid;
 	u32 tdls_set_state_cmdid;
 	u32 tdls_peer_update_cmdid;
+	u32 adaptive_qcs_cmdid;
 };
 
 /*
-- 
2.1.4


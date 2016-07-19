Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33096 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbcGSKce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 06:32:34 -0400
Received: by mail-lf0-f45.google.com with SMTP id b199so10170427lfe.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 03:32:32 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	marek.puzyniak@tieto.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/4] ath10k: implement wmi echo command
Date: Tue, 19 Jul 2016 12:34:09 +0200
Message-Id: <1468924452-23877-2-git-send-email-michal.kazior@tieto.com> (sfid-20160719_123236_868549_7DE43A4A)
In-Reply-To: <1468924452-23877-1-git-send-email-michal.kazior@tieto.com>
References: <1468924452-23877-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Will be useful for implementing command barriers.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 17 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 29 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 23 +++++++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 64ebd304f907..b1d88fa60d11 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -194,6 +194,7 @@ struct wmi_ops {
 	struct sk_buff *(*gen_pdev_bss_chan_info_req)
 					(struct ath10k *ar,
 					 enum wmi_bss_survey_req_type type);
+	struct sk_buff *(*gen_echo)(struct ath10k *ar, u32 value);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1382,4 +1383,20 @@ ath10k_wmi_pdev_bss_chan_info_request(struct ath10k *ar,
 				   wmi->cmd->pdev_bss_chan_info_request_cmdid);
 }
 
+static inline int
+ath10k_wmi_echo(struct ath10k *ar, u32 value)
+{
+	struct ath10k_wmi *wmi = &ar->wmi;
+	struct sk_buff *skb;
+
+	if (!wmi->ops->gen_echo)
+		return -EOPNOTSUPP;
+
+	skb = wmi->ops->gen_echo(ar, value);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, wmi->cmd->echo_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index e09337ee7c96..cd595855af36 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3081,6 +3081,34 @@ ath10k_wmi_tlv_op_gen_adaptive_qcs(struct ath10k *ar, bool enable)
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_echo(struct ath10k *ar, u32 value)
+{
+	struct wmi_echo_cmd *cmd;
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
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_ECHO_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+	cmd->value = cpu_to_le32(value);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv echo value 0x%08x\n", value);
+	return skb;
+}
+
 /****************/
 /* TLV mappings */
 /****************/
@@ -3485,6 +3513,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
 	.fw_stats_fill = ath10k_wmi_main_op_fw_stats_fill,
 	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
+	.gen_echo = ath10k_wmi_tlv_op_gen_echo,
 };
 
 static const struct wmi_peer_flags_map wmi_tlv_peer_flags_map = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 169cd2e783eb..9ae4aacadb38 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -7649,6 +7649,24 @@ ath10k_wmi_10_4_ext_resource_config(struct ath10k *ar,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_op_gen_echo(struct ath10k *ar, u32 value)
+{
+	struct wmi_echo_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_echo_cmd *)skb->data;
+	cmd->value = cpu_to_le32(value);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi echo value 0x%08x\n", value);
+	return skb;
+}
+
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -7709,6 +7727,7 @@ static const struct wmi_ops wmi_ops = {
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
 	.fw_stats_fill = ath10k_wmi_main_op_fw_stats_fill,
 	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
+	.gen_echo = ath10k_wmi_op_gen_echo,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -7777,6 +7796,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
 	.fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
 	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
+	.gen_echo = ath10k_wmi_op_gen_echo,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
 	/* .gen_p2p_go_bcn_ie not implemented */
@@ -7796,6 +7816,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.pull_svc_rdy = ath10k_wmi_10x_op_pull_svc_rdy_ev,
 	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
 	.gen_start_scan = ath10k_wmi_10x_op_gen_start_scan,
+	.gen_echo = ath10k_wmi_op_gen_echo,
 
 	.pull_scan = ath10k_wmi_op_pull_scan_ev,
 	.pull_mgmt_rx = ath10k_wmi_op_pull_mgmt_rx_ev,
@@ -7862,6 +7883,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.pull_svc_rdy = ath10k_wmi_10x_op_pull_svc_rdy_ev,
 	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
 	.gen_start_scan = ath10k_wmi_10x_op_gen_start_scan,
+	.gen_echo = ath10k_wmi_op_gen_echo,
 
 	.pull_scan = ath10k_wmi_op_pull_scan_ev,
 	.pull_mgmt_rx = ath10k_wmi_op_pull_mgmt_rx_ev,
@@ -7984,6 +8006,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.gen_pdev_get_temperature = ath10k_wmi_10_2_op_gen_pdev_get_temperature,
 	.get_vdev_subtype = ath10k_wmi_10_4_op_get_vdev_subtype,
 	.gen_pdev_bss_chan_info_req = ath10k_wmi_10_2_op_gen_pdev_bss_chan_info,
+	.gen_echo = ath10k_wmi_op_gen_echo,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
2.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63427 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161AbbAHLSL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 06:18:11 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so2538172wiv.0
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 03:18:09 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/5] ath10k: implement p2p bcn ie command
Date: Thu,  8 Jan 2015 12:12:29 +0100
Message-Id: <1420715550-16017-5-git-send-email-michal.kazior@tieto.com> (sfid-20150108_121816_536789_0C476D83)
In-Reply-To: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
References: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Along beacon template host is expected to setup
p2p information elements as well. Implement wmi
interface for it.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 17 +++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 41 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  5 ++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  3 +++
 4 files changed, 66 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 148a44a..8e815d4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -125,6 +125,8 @@ struct wmi_ops {
 					void *prb_ies, size_t prb_ies_len);
 	struct sk_buff *(*gen_prb_tmpl)(struct ath10k *ar, u32 vdev_id,
 					struct sk_buff *bcn);
+	struct sk_buff *(*gen_p2p_go_bcn_ie)(struct ath10k *ar, u32 vdev_id,
+					     const u8 *p2p_ie);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -897,4 +899,19 @@ ath10k_wmi_prb_tmpl(struct ath10k *ar, u32 vdev_id, struct sk_buff *prb)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->prb_tmpl_cmdid);
 }
 
+static inline int
+ath10k_wmi_p2p_go_bcn_ie(struct ath10k *ar, u32 vdev_id, const u8 *p2p_ie)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_p2p_go_bcn_ie)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_p2p_go_bcn_ie(ar, vdev_id, p2p_ie);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->p2p_go_set_beacon_ie);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 1713f8c..7c4297e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2085,6 +2085,46 @@ ath10k_wmi_tlv_op_gen_prb_tmpl(struct ath10k *ar, u32 vdev_id,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie(struct ath10k *ar, u32 vdev_id,
+				    const u8 *p2p_ie)
+{
+	struct wmi_tlv_p2p_go_bcn_ie *cmd;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	void *ptr;
+	size_t len;
+
+	len = sizeof(*tlv) + sizeof(*cmd) +
+	      sizeof(*tlv) + roundup(p2p_ie[1] + 2, 4);
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ptr = (void *)skb->data;
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_P2P_GO_SET_BEACON_IE);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	cmd->ie_len = __cpu_to_le32(p2p_ie[1] + 2);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_BYTE);
+	tlv->len = __cpu_to_le16(roundup(p2p_ie[1] + 2, 4));
+	memcpy(tlv->value, p2p_ie, p2p_ie[1] + 2);
+
+	ptr += sizeof(*tlv);
+	ptr += roundup(p2p_ie[1] + 2, 4);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv p2p go bcn ie for vdev %i\n",
+		   vdev_id);
+	return skb;
+}
+
 /****************/
 /* TLV mappings */
 /****************/
@@ -2372,6 +2412,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	/* .gen_pdev_get_temperature not implemented */
 	.gen_bcn_tmpl = ath10k_wmi_tlv_op_gen_bcn_tmpl,
 	.gen_prb_tmpl = ath10k_wmi_tlv_op_gen_prb_tmpl,
+	.gen_p2p_go_bcn_ie = ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 5772519..eb02290 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1404,6 +1404,11 @@ struct wmi_tlv_prb_tmpl_cmd {
 	__le32 buf_len;
 } __packed;
 
+struct wmi_tlv_p2p_go_bcn_ie {
+	__le32 vdev_id;
+	__le32 ie_len;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 8c46de1..2a1a98f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4930,6 +4930,7 @@ static const struct wmi_ops wmi_ops = {
 	/* .gen_pdev_get_temperature not implemented */
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
+	/* .gen_p2p_go_bcn_ie not implemented */
 };
 
 static const struct wmi_ops wmi_10_1_ops = {
@@ -4986,6 +4987,7 @@ static const struct wmi_ops wmi_10_1_ops = {
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
+	/* .gen_p2p_go_bcn_ie not implemented */
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
@@ -5098,6 +5100,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
 	/* .gen_bcn_tmpl not implemented */
 	/* .gen_prb_tmpl not implemented */
+	/* .gen_p2p_go_bcn_ie not implemented */
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
1.8.5.3


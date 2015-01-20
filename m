Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47702 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbATKYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 05:24:45 -0500
Received: by mail-wi0-f169.google.com with SMTP id bs8so22295541wib.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 02:24:43 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: implement sta keepalive command
Date: Tue, 20 Jan 2015 11:23:59 +0100
Message-Id: <1421749440-10457-1-git-send-email-michal.kazior@tieto.com> (sfid-20150120_112451_848294_CBCD47FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janusz Dziedzic <janusz.dziedzic@tieto.com>

New wmi-tlv firmware for qca6174 has STA keepalive
service available. The service can provide
automatic idle connection polling via NullFunc
frames to AP when acting as a client.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 20 ++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 45 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  7 +++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 10 +++++++
 4 files changed, 82 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 0dd49a7..d430f92 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -137,6 +137,8 @@ struct wmi_ops {
 					struct sk_buff *bcn);
 	struct sk_buff *(*gen_p2p_go_bcn_ie)(struct ath10k *ar, u32 vdev_id,
 					     const u8 *p2p_ie);
+	struct sk_buff *(*gen_sta_keepalive)(struct ath10k *ar,
+					     const struct wmi_sta_keepalive_arg *arg);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -992,4 +994,22 @@ ath10k_wmi_p2p_go_bcn_ie(struct ath10k *ar, u32 vdev_id, const u8 *p2p_ie)
 	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->p2p_go_set_beacon_ie);
 }
 
+static inline int
+ath10k_wmi_sta_keepalive(struct ath10k *ar,
+			 const struct wmi_sta_keepalive_arg *arg)
+{
+	struct sk_buff *skb;
+	u32 cmd_id;
+
+	if (!ar->wmi.ops->gen_sta_keepalive)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_sta_keepalive(ar, arg);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	cmd_id = ar->wmi.cmd->sta_keepalive_cmd;
+	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 6f34fc7..3f1a022 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1407,6 +1407,50 @@ ath10k_wmi_tlv_op_gen_vdev_install_key(struct ath10k *ar,
 }
 
 static struct sk_buff *
+ath10k_wmi_tlv_op_gen_sta_keepalive(struct ath10k *ar,
+				    const struct wmi_sta_keepalive_arg *arg)
+{
+	struct wmi_tlv_sta_keepalive_cmd *cmd;
+	struct wmi_sta_keepalive_arp_resp *arp;
+	struct sk_buff *skb;
+	struct wmi_tlv *tlv;
+	void *ptr;
+	size_t len;
+
+	len = sizeof(*tlv) + sizeof(*cmd) +
+	      sizeof(*tlv) + sizeof(*arp);
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ptr = (void *)skb->data;
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_STA_KEEPALIVE_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+	cmd->vdev_id = __cpu_to_le32(arg->vdev_id);
+	cmd->enabled = __cpu_to_le32(arg->enabled);
+	cmd->method = __cpu_to_le32(arg->method);
+	cmd->interval = __cpu_to_le32(arg->interval);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_STA_KEEPALVE_ARP_RESPONSE);
+	tlv->len = __cpu_to_le16(sizeof(*arp));
+	arp = (void *)tlv->value;
+
+	arp->src_ip4_addr = arg->src_ip4_addr;
+	arp->dest_ip4_addr = arg->dest_ip4_addr;
+	ether_addr_copy(arp->dest_mac_addr.addr, arg->dest_mac_addr);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv sta keepalive vdev %d enabled %d method %d inverval %d\n",
+		   arg->vdev_id, arg->enabled, arg->method, arg->interval);
+	return skb;
+}
+
+static struct sk_buff *
 ath10k_wmi_tlv_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
 				  const u8 peer_addr[ETH_ALEN])
 {
@@ -2417,6 +2461,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_bcn_tmpl = ath10k_wmi_tlv_op_gen_bcn_tmpl,
 	.gen_prb_tmpl = ath10k_wmi_tlv_op_gen_prb_tmpl,
 	.gen_p2p_go_bcn_ie = ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie,
+	.gen_sta_keepalive = ath10k_wmi_tlv_op_gen_sta_keepalive,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index eb02290..ac9fb85 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1409,6 +1409,13 @@ struct wmi_tlv_p2p_go_bcn_ie {
 	__le32 ie_len;
 } __packed;
 
+struct wmi_tlv_sta_keepalive_cmd {
+	__le32 vdev_id;
+	__le32 enabled;
+	__le32 method; /* WMI_STA_KEEPALIVE_METHOD_ */
+	__le32 interval; /* in seconds */
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index bd7f29a..99f091d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4596,6 +4596,16 @@ struct wmi_sta_keepalive_cmd {
 	struct wmi_sta_keepalive_arp_resp arp_resp;
 } __packed;
 
+struct wmi_sta_keepalive_arg {
+	u32 vdev_id;
+	u32 enabled;
+	u32 method;
+	u32 interval;
+	__be32 src_ip4_addr;
+	__be32 dest_ip4_addr;
+	const u8 dest_mac_addr[ETH_ALEN];
+};
+
 enum wmi_force_fw_hang_type {
 	WMI_FORCE_FW_HANG_ASSERT = 1,
 	WMI_FORCE_FW_HANG_NO_DETECT,
-- 
1.8.5.3


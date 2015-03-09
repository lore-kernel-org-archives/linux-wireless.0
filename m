Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:46867 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbbCIH4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 03:56:33 -0400
Received: by lbiz11 with SMTP id z11so43271202lbi.13
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 00:56:32 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 3/4] ath10k: add WMI support for WOW patterns
Date: Mon,  9 Mar 2015 08:55:19 +0100
Message-Id: <1425887720-11466-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150309_085639_144564_3DA73383)
In-Reply-To: <1425887720-11466-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1425887720-11466-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WMI support for WOW patterns.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  45 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 130 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  38 +++++++++
 3 files changed, 213 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 1dee6ed..f038551 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -155,6 +155,14 @@ struct wmi_ops {
 						    enum wmi_wow_wakeup_event event,
 						    u32 enable);
 	struct sk_buff *(*gen_wow_host_wakeup_ind)(struct ath10k *ar);
+	struct sk_buff *(*gen_wow_add_pattern)(struct ath10k *ar, u32 vdev_id,
+					       u32 pattern_id,
+					       const u8 *pattern,
+					       const u8 *mask,
+					       int pattern_len,
+					       int pattern_offset);
+	struct sk_buff *(*gen_wow_del_pattern)(struct ath10k *ar, u32 vdev_id,
+					       u32 pattern_id);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1130,4 +1138,41 @@ ath10k_wmi_wow_host_wakeup_ind(struct ath10k *ar)
 	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
 }
 
+static inline int
+ath10k_wmi_wow_add_pattern(struct ath10k *ar, u32 vdev_id, u32 pattern_id,
+			   const u8 *pattern, const u8 *mask,
+			   int pattern_len, int pattern_offset)
+{
+	struct sk_buff *skb;
+	u32 cmd_id;
+
+	if (!ar->wmi.ops->gen_wow_add_pattern)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_wow_add_pattern(ar, vdev_id, pattern_id,
+					       pattern, mask, pattern_len,
+					       pattern_offset);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	cmd_id = ar->wmi.cmd->wow_add_wake_pattern_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
+}
+
+static inline int
+ath10k_wmi_wow_del_pattern(struct ath10k *ar, u32 vdev_id, u32 pattern_id)
+{
+	struct sk_buff *skb;
+	u32 cmd_id;
+
+	if (!ar->wmi.ops->gen_wow_del_pattern)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_wow_del_pattern(ar, vdev_id, pattern_id);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	cmd_id = ar->wmi.cmd->wow_del_wake_pattern_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 409db3e..0c38b5e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2642,6 +2642,134 @@ ath10k_wmi_tlv_gen_wow_host_wakeup_ind(struct ath10k *ar)
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_wow_add_pattern(struct ath10k *ar, u32 vdev_id,
+				      u32 pattern_id, const u8 *pattern,
+				      const u8 *bitmask, int pattern_len,
+				      int pattern_offset)
+{
+	struct wmi_tlv_wow_add_pattern_cmd *cmd;
+	struct wmi_tlv_wow_bitmap_pattern *bitmap;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	void *ptr;
+	size_t len;
+
+	len = sizeof(*tlv) + sizeof(*cmd) +
+	      sizeof(*tlv) +			/* array struct */
+	      sizeof(*tlv) + sizeof(*bitmap) +  /* bitmap */
+	      sizeof(*tlv) +			/* empty ipv4 sync */
+	      sizeof(*tlv) +			/* empty ipv6 sync */
+	      sizeof(*tlv) +			/* empty magic */
+	      sizeof(*tlv) +			/* empty info timeout */
+	      sizeof(*tlv) + sizeof(u32);	/* ratelimit interval */
+
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	/* cmd */
+	ptr = (void *)skb->data;
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_WOW_ADD_PATTERN_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	cmd->pattern_id = __cpu_to_le32(pattern_id);
+	cmd->pattern_type = __cpu_to_le32(WOW_BITMAP_PATTERN);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	/* bitmap */
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
+	tlv->len = __cpu_to_le16(sizeof(*tlv) + sizeof(*bitmap));
+
+	ptr += sizeof(*tlv);
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_WOW_BITMAP_PATTERN_T);
+	tlv->len = __cpu_to_le16(sizeof(*bitmap));
+	bitmap = (void *)tlv->value;
+
+	memcpy(bitmap->patternbuf, pattern, pattern_len);
+	memcpy(bitmap->bitmaskbuf, bitmask, pattern_len);
+	bitmap->pattern_offset = __cpu_to_le32(pattern_offset);
+	bitmap->pattern_len = __cpu_to_le32(pattern_len);
+	bitmap->bitmask_len = __cpu_to_le32(pattern_len);
+	bitmap->pattern_id = __cpu_to_le32(pattern_id);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*bitmap);
+
+	/* ipv4 sync */
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
+	tlv->len = __cpu_to_le16(0);
+
+	ptr += sizeof(*tlv);
+
+	/* ipv6 sync */
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
+	tlv->len = __cpu_to_le16(0);
+
+	ptr += sizeof(*tlv);
+
+	/* magic */
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
+	tlv->len = __cpu_to_le16(0);
+
+	ptr += sizeof(*tlv);
+
+	/* pattern info timeout */
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_UINT32);
+	tlv->len = __cpu_to_le16(0);
+
+	ptr += sizeof(*tlv);
+
+	/* ratelimit interval */
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_UINT32);
+	tlv->len = __cpu_to_le16(sizeof(u32));
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv wow add pattern vdev_id %d pattern_id %d, pattern_offset %d\n",
+		   vdev_id, pattern_id, pattern_offset);
+	return skb;
+}
+
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_wow_del_pattern(struct ath10k *ar, u32 vdev_id,
+				      u32 pattern_id)
+{
+	struct wmi_tlv_wow_del_pattern_cmd *cmd;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	size_t len;
+
+	len = sizeof(*tlv) + sizeof(*cmd);
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	tlv = (struct wmi_tlv *)skb->data;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_WOW_DEL_PATTERN_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	cmd->pattern_id = __cpu_to_le32(pattern_id);
+	cmd->pattern_type = __cpu_to_le32(WOW_BITMAP_PATTERN);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv wow del pattern vdev_id %d pattern_id %d\n",
+		   vdev_id, pattern_id);
+	return skb;
+}
+
 /****************/
 /* TLV mappings */
 /****************/
@@ -2942,6 +3070,8 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_wow_enable = ath10k_wmi_tlv_op_gen_wow_enable,
 	.gen_wow_add_wakeup_event = ath10k_wmi_tlv_op_gen_wow_add_wakeup_event,
 	.gen_wow_host_wakeup_ind = ath10k_wmi_tlv_gen_wow_host_wakeup_ind,
+	.gen_wow_add_pattern = ath10k_wmi_tlv_op_gen_wow_add_pattern,
+	.gen_wow_del_pattern = ath10k_wmi_tlv_op_gen_wow_del_pattern,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index f8754a3..228c27e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1479,6 +1479,44 @@ struct wmi_tlv_wow_event_info {
 	__le32 data_len;
 } __packed;
 
+enum wmi_tlv_pattern_type {
+	WOW_PATTERN_MIN = 0,
+	WOW_BITMAP_PATTERN = WOW_PATTERN_MIN,
+	WOW_IPV4_SYNC_PATTERN,
+	WOW_IPV6_SYNC_PATTERN,
+	WOW_WILD_CARD_PATTERN,
+	WOW_TIMER_PATTERN,
+	WOW_MAGIC_PATTERN,
+	WOW_IPV6_RA_PATTERN,
+	WOW_IOAC_PKT_PATTERN,
+	WOW_IOAC_TMR_PATTERN,
+	WOW_PATTERN_MAX
+};
+
+#define WOW_DEFAULT_BITMAP_PATTERN_SIZE		148
+#define WOW_DEFAULT_BITMASK_SIZE		148
+
+struct wmi_tlv_wow_bitmap_pattern {
+	u8 patternbuf[WOW_DEFAULT_BITMAP_PATTERN_SIZE];
+	u8 bitmaskbuf[WOW_DEFAULT_BITMASK_SIZE];
+	__le32 pattern_offset;
+	__le32 pattern_len;
+	__le32 bitmask_len;
+	__le32 pattern_id;
+} __packed;
+
+struct wmi_tlv_wow_add_pattern_cmd {
+	__le32 vdev_id;
+	__le32 pattern_id;
+	__le32 pattern_type;
+} __packed;
+
+struct wmi_tlv_wow_del_pattern_cmd {
+	__le32 vdev_id;
+	__le32 pattern_id;
+	__le32 pattern_type;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
-- 
1.9.1


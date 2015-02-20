Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:37600 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbbBTFiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 00:38:52 -0500
Received: by labpn19 with SMTP id pn19so4088018lab.4
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 21:38:50 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 2/2] ath10k: add WOW patterns/magic packet
Date: Fri, 20 Feb 2015 06:38:02 +0100
Message-Id: <1424410682-5553-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150220_063857_103858_ED978E19)
In-Reply-To: <1424410682-5553-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1424410682-5553-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for WOW magic packet and patterns.

Signed-off-by: Janusz Dziedzic  <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h    |   1 +
 drivers/net/wireless/ath/ath10k/mac.c     |  45 ++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  45 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 130 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  50 ++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   5 ++
 6 files changed, 275 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 3312458..72c18ed 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -340,6 +340,7 @@ struct ath10k_vif {
 	int num_legacy_stations;
 	int txpower;
 	struct wmi_wmm_params_all_arg wmm_params;
+	int wow_pattern_id;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8ffb4ef..552a3a4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4479,6 +4479,13 @@ static int ath10k_suspend_wow_arvif(struct ath10k *ar,
 {
 	int ret, i;
 	unsigned long wow_mask = 0;
+	struct cfg80211_pkt_pattern *patterns = wowlan->patterns;
+
+	/* Clear existing WOW patterns */
+	for (i = 0; i < arvif->wow_pattern_id; i++)
+		ath10k_wmi_wow_del_pattern(ar, arvif->vdev_id, i);
+
+	arvif->wow_pattern_id = 0;
 
 	switch (arvif->vdev_type) {
 	case WMI_VDEV_TYPE_IBSS:
@@ -4502,11 +4509,37 @@ static int ath10k_suspend_wow_arvif(struct ath10k *ar,
 			set_bit(WOW_BMISS_EVENT, &wow_mask);
 			set_bit(WOW_CSA_IE_EVENT, &wow_mask);
 		}
+		if (wowlan->magic_pkt)
+			set_bit(WOW_MAGIC_PKT_RECVD_EVENT, &wow_mask);
 		break;
 	default:
 		break;
 	}
 
+	for (i = 0; i < wowlan->n_patterns; i++) {
+		u8 bitmask[WOW_MAX_PATTERN_SIZE] = {};
+		int j;
+
+		if (patterns[i].pattern_len > WOW_MAX_PATTERN_SIZE)
+			continue;
+
+		/* convert bytemask to bitmask */
+		for (j = 0; j < patterns[i].pattern_len; j++)
+			if (patterns[i].mask[j/8] & BIT(j%8))
+				bitmask[j] = 0xff;
+
+		ret = ath10k_wmi_wow_add_pattern(ar, arvif->vdev_id,
+						 arvif->wow_pattern_id++,
+						 patterns[i].pattern,
+						 bitmask,
+						 patterns[i].pattern_len,
+						 patterns[i].pkt_offset);
+		if (ret)
+			ath10k_warn(ar, "wow add pattern failed %d\n", ret);
+
+		set_bit(WOW_PATTERN_MATCH_EVENT, &wow_mask);
+	}
+
 	for (i = 0; i < WOW_EVENT_MAX; i++) {
 		if (!test_bit(i, &wow_mask))
 			continue;
@@ -4534,6 +4567,12 @@ static int ath10k_suspend(struct ieee80211_hw *hw,
 		goto exit;
 	}
 
+	if (wowlan && (wowlan->n_patterns > WOW_MAX_PATTERNS)) {
+			ret = 1;
+			goto exit;
+	}
+
+	/* Install filters for each vif */
 	list_for_each_entry(arvif, &ar->arvifs, list)
 		ath10k_suspend_wow_arvif(ar, arvif, wowlan);
 
@@ -5337,7 +5376,11 @@ static const struct ieee80211_iface_combination ath10k_10x_if_comb[] = {
 
 #ifdef CONFIG_PM
 static const struct wiphy_wowlan_support ath10k_wowlan_support = {
-	.flags = WIPHY_WOWLAN_DISCONNECT,
+	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
+	.n_patterns = WOW_MAX_PATTERNS,
+	.pattern_min_len = WOW_MIN_PATTERN_SIZE,
+	.pattern_max_len = WOW_MAX_PATTERN_SIZE,
+	.max_pkt_offset = WOW_MAX_PKT_OFFSET,
 };
 #endif
 
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
index f8b7a8b..5ab47d0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2599,6 +2599,134 @@ ath10k_wmi_tlv_gen_wow_host_wakeup_ind(struct ath10k *ar)
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
@@ -2899,6 +3027,8 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_wow_enable = ath10k_wmi_tlv_op_gen_wow_enable,
 	.gen_wow_add_wakeup_event = ath10k_wmi_tlv_op_gen_wow_add_wakeup_event,
 	.gen_wow_host_wakeup_ind = ath10k_wmi_tlv_gen_wow_host_wakeup_ind,
+	.gen_wow_add_pattern = ath10k_wmi_tlv_op_gen_wow_add_pattern,
+	.gen_wow_del_pattern = ath10k_wmi_tlv_op_gen_wow_del_pattern,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 2456786..f2c3d29 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1469,6 +1469,56 @@ struct wmi_tlv_wow_event_info {
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
+	/*
+	 * Following this struct are these TLVs. Note that they are all array
+	 * of structures but can have at most one element. Which TLV is empty
+	 * or has one element depends on the field pattern_type.
+	 * This is to emulate an union.
+	 *     WOW_BITMAP_PATTERN_T	pattern_info_bitmap[];
+	 *     WOW_IPV4_SYNC_PATTERN_T	pattern_info_ipv4[];
+	 *     WOW_IPV6_SYNC_PATTERN_T	pattern_info_ipv6[];
+	 *     WOW_MAGIC_PATTERN_CMD	pattern_info_magic_pattern[];
+	 *     A_UINT32			pattern_info_timeout[];
+	 *     A_UINT32			ra_ratelimit_interval;
+	 */
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
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 7e0c9eb..ef6308a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5005,6 +5005,11 @@ struct wmi_wow_ev_arg {
 	u32 data_len;
 };
 
+#define WOW_MAX_PATTERNS	16
+#define WOW_MIN_PATTERN_SIZE	2
+#define WOW_MAX_PATTERN_SIZE	148
+#define WOW_MAX_PKT_OFFSET	128
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
-- 
1.9.1


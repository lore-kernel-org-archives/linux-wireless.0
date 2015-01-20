Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:65358 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbATKZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 05:25:37 -0500
Received: by mail-wg0-f41.google.com with SMTP id a1so14297605wgh.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 02:25:36 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: implement uapsd autotrigger command
Date: Tue, 20 Jan 2015 11:24:56 +0100
Message-Id: <1421749497-10553-1-git-send-email-michal.kazior@tieto.com> (sfid-20150120_112544_130249_587749AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janusz Dziedzic <janusz.dziedzic@tieto.com>

New wmi-tlv firmware for qca6174 has u-UAPSD
autotrigger service. If it is enabled firmware
generates trigger frames automatically as
configured.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 25 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 73 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 24 ++++++++++
 3 files changed, 122 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 0dd49a7..80bd28a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -137,6 +137,10 @@ struct wmi_ops {
 					struct sk_buff *bcn);
 	struct sk_buff *(*gen_p2p_go_bcn_ie)(struct ath10k *ar, u32 vdev_id,
 					     const u8 *p2p_ie);
+	struct sk_buff *(*gen_vdev_sta_uapsd)(struct ath10k *ar, u32 vdev_id,
+					      const u8 peer_addr[ETH_ALEN],
+					      const struct wmi_sta_uapsd_auto_trig_arg *args,
+					      u32 num_ac);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -576,6 +580,27 @@ ath10k_wmi_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id, u32 trigger,
 }
 
 static inline int
+ath10k_wmi_vdev_sta_uapsd(struct ath10k *ar, u32 vdev_id,
+			  const u8 peer_addr[ETH_ALEN],
+			  const struct wmi_sta_uapsd_auto_trig_arg *args,
+			  u32 num_ac)
+{
+	struct sk_buff *skb;
+	u32 cmd_id;
+
+	if (!ar->wmi.ops->gen_vdev_sta_uapsd)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_vdev_sta_uapsd(ar, vdev_id, peer_addr, args,
+					      num_ac);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	cmd_id = ar->wmi.cmd->sta_uapsd_auto_trig_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
+}
+
+static inline int
 ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
 		       const u8 peer_addr[ETH_ALEN])
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 6f34fc7..0540c64 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1406,6 +1406,78 @@ ath10k_wmi_tlv_op_gen_vdev_install_key(struct ath10k *ar,
 	return skb;
 }
 
+static void *ath10k_wmi_tlv_put_uapsd_ac(struct ath10k *ar, void *ptr,
+					 const struct wmi_sta_uapsd_auto_trig_arg *arg)
+{
+	struct wmi_sta_uapsd_auto_trig_param *ac;
+	struct wmi_tlv *tlv;
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_STA_UAPSD_AUTO_TRIG_PARAM);
+	tlv->len = __cpu_to_le16(sizeof(*ac));
+	ac = (void *)tlv->value;
+
+	ac->wmm_ac = __cpu_to_le32(arg->wmm_ac);
+	ac->user_priority = __cpu_to_le32(arg->user_priority);
+	ac->service_interval = __cpu_to_le32(arg->service_interval);
+	ac->suspend_interval = __cpu_to_le32(arg->suspend_interval);
+	ac->delay_interval = __cpu_to_le32(arg->delay_interval);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi tlv vdev sta uapsd auto trigger ac %d prio %d svc int %d susp int %d delay int %d\n",
+		   ac->wmm_ac, ac->user_priority, ac->service_interval,
+		   ac->suspend_interval, ac->delay_interval);
+
+	return ptr + sizeof(*tlv) + sizeof(*ac);
+}
+
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_vdev_sta_uapsd(struct ath10k *ar, u32 vdev_id,
+				     const u8 peer_addr[ETH_ALEN],
+				     const struct wmi_sta_uapsd_auto_trig_arg *args,
+				     u32 num_ac)
+{
+	struct wmi_sta_uapsd_auto_trig_cmd_fixed_param *cmd;
+	struct wmi_sta_uapsd_auto_trig_param *ac;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	size_t len;
+	size_t ac_tlv_len;
+	void *ptr;
+	int i;
+
+	ac_tlv_len = num_ac * (sizeof(*tlv) + sizeof(*ac));
+	len = sizeof(*tlv) + sizeof(*cmd) +
+	      sizeof(*tlv) + ac_tlv_len;
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ptr = (void *)skb->data;
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_STA_UAPSD_AUTO_TRIG_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	cmd->num_ac = __cpu_to_le32(num_ac);
+	ether_addr_copy(cmd->peer_macaddr.addr, peer_addr);
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
+	tlv->len = __cpu_to_le16(ac_tlv_len);
+	ac = (void *)tlv->value;
+
+	ptr += sizeof(*tlv);
+	for (i = 0; i < num_ac; i++)
+		ptr = ath10k_wmi_tlv_put_uapsd_ac(ar, ptr, &args[i]);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv vdev sta uapsd auto trigger\n");
+	return skb;
+}
+
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
 				  const u8 peer_addr[ETH_ALEN])
@@ -2417,6 +2489,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_bcn_tmpl = ath10k_wmi_tlv_op_gen_bcn_tmpl,
 	.gen_prb_tmpl = ath10k_wmi_tlv_op_gen_prb_tmpl,
 	.gen_p2p_go_bcn_ie = ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie,
+	.gen_vdev_sta_uapsd = ath10k_wmi_tlv_op_gen_vdev_sta_uapsd,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index bd7f29a..a943ebd 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4060,6 +4060,30 @@ enum wmi_sta_ps_param_uapsd {
 	WMI_STA_PS_UAPSD_AC3_TRIGGER_EN  = (1 << 7),
 };
 
+#define WMI_STA_UAPSD_MAX_INTERVAL_MSEC UINT_MAX
+
+struct wmi_sta_uapsd_auto_trig_param {
+	__le32 wmm_ac;
+	__le32 user_priority;
+	__le32 service_interval;
+	__le32 suspend_interval;
+	__le32 delay_interval;
+};
+
+struct wmi_sta_uapsd_auto_trig_cmd_fixed_param {
+	__le32 vdev_id;
+	struct wmi_mac_addr peer_macaddr;
+	__le32 num_ac;
+};
+
+struct wmi_sta_uapsd_auto_trig_arg {
+	u32 wmm_ac;
+	u32 user_priority;
+	u32 service_interval;
+	u32 suspend_interval;
+	u32 delay_interval;
+};
+
 enum wmi_sta_powersave_param {
 	/*
 	 * Controls how frames are retrievd from AP while STA is sleeping
-- 
1.8.5.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:38180 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbbBYMpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 07:45:51 -0500
Received: by lbiz11 with SMTP id z11so3555760lbi.5
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 04:45:49 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFCv2 1/4] ath10k: add WMI support for WOW
Date: Wed, 25 Feb 2015 13:44:55 +0100
Message-Id: <1424868298-17372-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150225_134554_971867_93C7778D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add WMI support for WOW like enable,
wakeup events and host wakeup indication.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  70 +++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 116 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  21 +++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 144 ++++++++++++++++++++++++++++++
 4 files changed, 349 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index c8b64e7..1dee6ed 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -45,6 +45,8 @@ struct wmi_ops {
 			struct wmi_rdy_ev_arg *arg);
 	int (*pull_fw_stats)(struct ath10k *ar, struct sk_buff *skb,
 			     struct ath10k_fw_stats *stats);
+	int (*pull_wow_event)(struct ath10k *ar, struct sk_buff *skb,
+			      struct wmi_wow_ev_arg *arg);
 
 	struct sk_buff *(*gen_pdev_suspend)(struct ath10k *ar, u32 suspend_opt);
 	struct sk_buff *(*gen_pdev_resume)(struct ath10k *ar);
@@ -148,6 +150,11 @@ struct wmi_ops {
 					      u32 num_ac);
 	struct sk_buff *(*gen_sta_keepalive)(struct ath10k *ar,
 					     const struct wmi_sta_keepalive_arg *arg);
+	struct sk_buff *(*gen_wow_enable)(struct ath10k *ar);
+	struct sk_buff *(*gen_wow_add_wakeup_event)(struct ath10k *ar, u32 vdev_id,
+						    enum wmi_wow_wakeup_event event,
+						    u32 enable);
+	struct sk_buff *(*gen_wow_host_wakeup_ind)(struct ath10k *ar);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -274,6 +281,16 @@ ath10k_wmi_pull_fw_stats(struct ath10k *ar, struct sk_buff *skb,
 }
 
 static inline int
+ath10k_wmi_pull_wow_event(struct ath10k *ar, struct sk_buff *skb,
+			  struct wmi_wow_ev_arg *arg)
+{
+	if (!ar->wmi.ops->pull_wow_event)
+		return -EOPNOTSUPP;
+
+	return ar->wmi.ops->pull_wow_event(ar, skb, arg);
+}
+
+static inline int
 ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(msdu);
@@ -1060,4 +1077,57 @@ ath10k_wmi_sta_keepalive(struct ath10k *ar,
 	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
 }
 
+static inline int
+ath10k_wmi_wow_enable(struct ath10k *ar)
+{
+	struct sk_buff *skb;
+	u32 cmd_id;
+
+	if (!ar->wmi.ops->gen_wow_enable)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_wow_enable(ar);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	cmd_id = ar->wmi.cmd->wow_enable_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
+}
+
+static inline int
+ath10k_wmi_wow_add_wakeup_event(struct ath10k *ar, u32 vdev_id,
+				enum wmi_wow_wakeup_event event,
+				u32 enable)
+{
+	struct sk_buff *skb;
+	u32 cmd_id;
+
+	if (!ar->wmi.ops->gen_wow_add_wakeup_event)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_wow_add_wakeup_event(ar, vdev_id, event, enable);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	cmd_id = ar->wmi.cmd->wow_enable_disable_wake_event_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
+}
+
+static inline int
+ath10k_wmi_wow_host_wakeup_ind(struct ath10k *ar)
+{
+	struct sk_buff *skb;
+	u32 cmd_id;
+
+	if (!ar->wmi.ops->gen_wow_host_wakeup_ind)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_wow_host_wakeup_ind(ar);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	cmd_id = ar->wmi.cmd->wow_hostwakeup_from_sleep_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ebd1c45..3b40a13 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -31,9 +31,9 @@ struct wmi_tlv_policy {
 
 static const struct wmi_tlv_policy wmi_tlv_policies[] = {
 	[WMI_TLV_TAG_ARRAY_BYTE]
-		= { .min_len = sizeof(u8) },
+		= { .min_len = 0 },
 	[WMI_TLV_TAG_ARRAY_UINT32]
-		= { .min_len = sizeof(u32) },
+		= { .min_len = 0 },
 	[WMI_TLV_TAG_STRUCT_SCAN_EVENT]
 		= { .min_len = sizeof(struct wmi_scan_event) },
 	[WMI_TLV_TAG_STRUCT_MGMT_RX_HDR]
@@ -62,6 +62,8 @@ static const struct wmi_tlv_policy wmi_tlv_policies[] = {
 		= { .min_len = sizeof(struct wmi_tlv_bcn_tx_status_ev) },
 	[WMI_TLV_TAG_STRUCT_DIAG_DATA_CONTAINER_EVENT]
 		= { .min_len = sizeof(struct wmi_tlv_diag_data_ev) },
+	[WMI_TLV_TAG_STRUCT_WOW_EVENT_INFO]
+		= { .min_len = sizeof(struct wmi_tlv_wow_event_info) },
 };
 
 static int
@@ -1012,6 +1014,36 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
 	return 0;
 }
 
+static int
+ath10k_wmi_tlv_op_pull_wow_ev(struct ath10k *ar, struct sk_buff *skb,
+			      struct wmi_wow_ev_arg *arg)
+{
+	const void **tb;
+	const struct wmi_tlv_wow_event_info *ev;
+	int ret;
+
+	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
+	if (IS_ERR(tb)) {
+		ret = PTR_ERR(tb);
+		ath10k_warn(ar, "failed to parse tlv: %d\n", ret);
+		return ret;
+	}
+
+	ev = tb[WMI_TLV_TAG_STRUCT_WOW_EVENT_INFO];
+	if (!ev) {
+		kfree(tb);
+		return -EPROTO;
+	}
+
+	arg->vdev_id = __le32_to_cpu(ev->vdev_id);
+	arg->flag = __le32_to_cpu(ev->flag);
+	arg->wake_reason = __le32_to_cpu(ev->wake_reason);
+	arg->data_len = __le32_to_cpu(ev->data_len);
+
+	kfree(tb);
+	return 0;
+}
+
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_pdev_suspend(struct ath10k *ar, u32 opt)
 {
@@ -2493,6 +2525,82 @@ ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie(struct ath10k *ar, u32 vdev_id,
 	return skb;
 }
 
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_wow_enable(struct ath10k *ar)
+{
+	struct wmi_tlv_wow_enable_cmd *cmd;
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
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_WOW_ENABLE_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+
+	cmd->enable = __cpu_to_le32(1);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv wow enable\n");
+	return skb;
+}
+
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_wow_add_wakeup_event(struct ath10k *ar,
+					   u32 vdev_id,
+					   enum wmi_wow_wakeup_event event,
+					   u32 enable)
+{
+	struct wmi_tlv_wow_add_del_event_cmd *cmd;
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
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_WOW_ADD_DEL_EVT_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	cmd->is_add = __cpu_to_le32(enable);
+	cmd->event_bitmap = __cpu_to_le32(1 << event);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv wow add wakeup event %s enable %d vdev_id %d\n",
+		   wow_wakeup_event(event), enable, vdev_id);
+	return skb;
+}
+
+static struct sk_buff *
+ath10k_wmi_tlv_gen_wow_host_wakeup_ind(struct ath10k *ar)
+{
+	struct wmi_tlv_wow_host_wakeup_ind *cmd;
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
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_WOW_HOSTWAKEUP_FROM_SLEEP_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv wow host wakeup ind\n");
+	return skb;
+}
+
 /****************/
 /* TLV mappings */
 /****************/
@@ -2744,6 +2852,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.pull_svc_rdy = ath10k_wmi_tlv_op_pull_svc_rdy_ev,
 	.pull_rdy = ath10k_wmi_tlv_op_pull_rdy_ev,
 	.pull_fw_stats = ath10k_wmi_tlv_op_pull_fw_stats,
+	.pull_wow_event = ath10k_wmi_tlv_op_pull_wow_ev,
 
 	.gen_pdev_suspend = ath10k_wmi_tlv_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_tlv_op_gen_pdev_resume,
@@ -2789,6 +2898,9 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.gen_p2p_go_bcn_ie = ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie,
 	.gen_vdev_sta_uapsd = ath10k_wmi_tlv_op_gen_vdev_sta_uapsd,
 	.gen_sta_keepalive = ath10k_wmi_tlv_op_gen_sta_keepalive,
+	.gen_wow_enable = ath10k_wmi_tlv_op_gen_wow_enable,
+	.gen_wow_add_wakeup_event = ath10k_wmi_tlv_op_gen_wow_add_wakeup_event,
+	.gen_wow_host_wakeup_ind = ath10k_wmi_tlv_gen_wow_host_wakeup_ind,
 };
 
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index d7a31e1..2456786 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1448,6 +1448,27 @@ struct wmi_tlv_stats_ev {
 	__le32 num_chan_stats;
 } __packed;
 
+struct wmi_tlv_wow_add_del_event_cmd {
+	__le32 vdev_id;
+	__le32 is_add;
+	__le32 event_bitmap;
+} __packed;
+
+struct wmi_tlv_wow_enable_cmd {
+	__le32 enable;
+} __packed;
+
+struct wmi_tlv_wow_host_wakeup_ind {
+	__le32 reserved;
+} __packed;
+
+struct wmi_tlv_wow_event_info {
+	__le32 vdev_id;
+	__le32 flag;
+	__le32 wake_reason;
+	__le32 data_len;
+} __packed;
+
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 28c1822..7e0c9eb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4861,6 +4861,150 @@ struct wmi_pdev_temperature_event {
 	__le32 temperature;
 } __packed;
 
+/* WOW structures */
+enum wmi_wow_wakeup_event {
+	WOW_BMISS_EVENT = 0,
+	WOW_BETTER_AP_EVENT,
+	WOW_DEAUTH_RECVD_EVENT,
+	WOW_MAGIC_PKT_RECVD_EVENT,
+	WOW_GTK_ERR_EVENT,
+	WOW_FOURWAY_HSHAKE_EVENT,
+	WOW_EAPOL_RECVD_EVENT,
+	WOW_NLO_DETECTED_EVENT,
+	WOW_DISASSOC_RECVD_EVENT,
+	WOW_PATTERN_MATCH_EVENT,
+	WOW_CSA_IE_EVENT,
+	WOW_PROBE_REQ_WPS_IE_EVENT,
+	WOW_AUTH_REQ_EVENT,
+	WOW_ASSOC_REQ_EVENT,
+	WOW_HTT_EVENT,
+	WOW_RA_MATCH_EVENT,
+	WOW_HOST_AUTO_SHUTDOWN_EVENT,
+	WOW_IOAC_MAGIC_EVENT,
+	WOW_IOAC_SHORT_EVENT,
+	WOW_IOAC_EXTEND_EVENT,
+	WOW_IOAC_TIMER_EVENT,
+	WOW_DFS_PHYERR_RADAR_EVENT,
+	WOW_BEACON_EVENT,
+	WOW_CLIENT_KICKOUT_EVENT,
+	WOW_EVENT_MAX,
+};
+
+#define C2S(x) case x: return #x
+
+static inline const char *wow_wakeup_event(enum wmi_wow_wakeup_event ev)
+{
+	switch (ev) {
+	C2S(WOW_BMISS_EVENT);
+	C2S(WOW_BETTER_AP_EVENT);
+	C2S(WOW_DEAUTH_RECVD_EVENT);
+	C2S(WOW_MAGIC_PKT_RECVD_EVENT);
+	C2S(WOW_GTK_ERR_EVENT);
+	C2S(WOW_FOURWAY_HSHAKE_EVENT);
+	C2S(WOW_EAPOL_RECVD_EVENT);
+	C2S(WOW_NLO_DETECTED_EVENT);
+	C2S(WOW_DISASSOC_RECVD_EVENT);
+	C2S(WOW_PATTERN_MATCH_EVENT);
+	C2S(WOW_CSA_IE_EVENT);
+	C2S(WOW_PROBE_REQ_WPS_IE_EVENT);
+	C2S(WOW_AUTH_REQ_EVENT);
+	C2S(WOW_ASSOC_REQ_EVENT);
+	C2S(WOW_HTT_EVENT);
+	C2S(WOW_RA_MATCH_EVENT);
+	C2S(WOW_HOST_AUTO_SHUTDOWN_EVENT);
+	C2S(WOW_IOAC_MAGIC_EVENT);
+	C2S(WOW_IOAC_SHORT_EVENT);
+	C2S(WOW_IOAC_EXTEND_EVENT);
+	C2S(WOW_IOAC_TIMER_EVENT);
+	C2S(WOW_DFS_PHYERR_RADAR_EVENT);
+	C2S(WOW_BEACON_EVENT);
+	C2S(WOW_CLIENT_KICKOUT_EVENT);
+	C2S(WOW_EVENT_MAX);
+	default:
+		return NULL;
+	}
+}
+
+enum wmi_wow_wake_reason {
+	WOW_REASON_UNSPECIFIED = -1,
+	WOW_REASON_NLOD = 0,
+	WOW_REASON_AP_ASSOC_LOST,
+	WOW_REASON_LOW_RSSI,
+	WOW_REASON_DEAUTH_RECVD,
+	WOW_REASON_DISASSOC_RECVD,
+	WOW_REASON_GTK_HS_ERR,
+	WOW_REASON_EAP_REQ,
+	WOW_REASON_FOURWAY_HS_RECV,
+	WOW_REASON_TIMER_INTR_RECV,
+	WOW_REASON_PATTERN_MATCH_FOUND,
+	WOW_REASON_RECV_MAGIC_PATTERN,
+	WOW_REASON_P2P_DISC,
+	WOW_REASON_WLAN_HB,
+	WOW_REASON_CSA_EVENT,
+	WOW_REASON_PROBE_REQ_WPS_IE_RECV,
+	WOW_REASON_AUTH_REQ_RECV,
+	WOW_REASON_ASSOC_REQ_RECV,
+	WOW_REASON_HTT_EVENT,
+	WOW_REASON_RA_MATCH,
+	WOW_REASON_HOST_AUTO_SHUTDOWN,
+	WOW_REASON_IOAC_MAGIC_EVENT,
+	WOW_REASON_IOAC_SHORT_EVENT,
+	WOW_REASON_IOAC_EXTEND_EVENT,
+	WOW_REASON_IOAC_TIMER_EVENT,
+	WOW_REASON_ROAM_HO,
+	WOW_REASON_DFS_PHYERR_RADADR_EVENT,
+	WOW_REASON_BEACON_RECV,
+	WOW_REASON_CLIENT_KICKOUT_EVENT,
+	WOW_REASON_DEBUG_TEST = 0xFF,
+};
+
+static inline const char *wow_reason(enum wmi_wow_wake_reason reason)
+{
+	switch (reason) {
+	C2S(WOW_REASON_UNSPECIFIED);
+	C2S(WOW_REASON_NLOD);
+	C2S(WOW_REASON_AP_ASSOC_LOST);
+	C2S(WOW_REASON_LOW_RSSI);
+	C2S(WOW_REASON_DEAUTH_RECVD);
+	C2S(WOW_REASON_DISASSOC_RECVD);
+	C2S(WOW_REASON_GTK_HS_ERR);
+	C2S(WOW_REASON_EAP_REQ);
+	C2S(WOW_REASON_FOURWAY_HS_RECV);
+	C2S(WOW_REASON_TIMER_INTR_RECV);
+	C2S(WOW_REASON_PATTERN_MATCH_FOUND);
+	C2S(WOW_REASON_RECV_MAGIC_PATTERN);
+	C2S(WOW_REASON_P2P_DISC);
+	C2S(WOW_REASON_WLAN_HB);
+	C2S(WOW_REASON_CSA_EVENT);
+	C2S(WOW_REASON_PROBE_REQ_WPS_IE_RECV);
+	C2S(WOW_REASON_AUTH_REQ_RECV);
+	C2S(WOW_REASON_ASSOC_REQ_RECV);
+	C2S(WOW_REASON_HTT_EVENT);
+	C2S(WOW_REASON_RA_MATCH);
+	C2S(WOW_REASON_HOST_AUTO_SHUTDOWN);
+	C2S(WOW_REASON_IOAC_MAGIC_EVENT);
+	C2S(WOW_REASON_IOAC_SHORT_EVENT);
+	C2S(WOW_REASON_IOAC_EXTEND_EVENT);
+	C2S(WOW_REASON_IOAC_TIMER_EVENT);
+	C2S(WOW_REASON_ROAM_HO);
+	C2S(WOW_REASON_DFS_PHYERR_RADADR_EVENT);
+	C2S(WOW_REASON_BEACON_RECV);
+	C2S(WOW_REASON_CLIENT_KICKOUT_EVENT);
+	C2S(WOW_REASON_DEBUG_TEST);
+	default:
+		return NULL;
+	}
+}
+
+#undef C2S
+
+struct wmi_wow_ev_arg {
+	u32 vdev_id;
+	u32 flag;
+	enum wmi_wow_wake_reason wake_reason;
+	u32 data_len;
+};
+
 struct ath10k;
 struct ath10k_vif;
 struct ath10k_fw_stats_pdev;
-- 
1.9.1


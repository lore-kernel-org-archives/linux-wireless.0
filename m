Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:37761 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbbBTFiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 00:38:51 -0500
Received: by lbvn10 with SMTP id n10so4278677lbv.4
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 21:38:49 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 1/2] ath10k: add WOW disconnect support
Date: Fri, 20 Feb 2015 06:38:01 +0100
Message-Id: <1424410682-5553-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150220_063856_159958_E3CB39E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for WOW disconnect.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c    |   1 +
 drivers/net/wireless/ath/ath10k/core.h    |   7 ++
 drivers/net/wireless/ath/ath10k/mac.c     | 113 ++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  70 +++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 117 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  21 +++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  29 ++++++
 drivers/net/wireless/ath/ath10k/wmi.h     | 144 ++++++++++++++++++++++++++++++
 8 files changed, 487 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 310e12b..55f07ef 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1386,6 +1386,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	init_completion(&ar->scan.completed);
 	init_completion(&ar->scan.on_channel);
 	init_completion(&ar->target_suspend);
+	init_completion(&ar->wow_wakeup_completed);
 
 	init_completion(&ar->install_key_done);
 	init_completion(&ar->vdev_setup_done);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7cba781..3312458 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -433,6 +433,11 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_WMI_10_2 = 4,
 
+	/* Some firmware revisions report WOWLAN service support, even
+	 * wowlan don't work correctly (fw dump).
+	 */
+	ATH10K_FW_FEATURE_WOWLAN_SUPPORT = 6,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
@@ -680,6 +685,8 @@ struct ath10k {
 
 	struct ath10k_thermal thermal;
 
+	struct completion wow_wakeup_completed;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0f39af7..8ffb4ef 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4473,18 +4473,84 @@ static int ath10k_tx_last_beacon(struct ieee80211_hw *hw)
 }
 
 #ifdef CONFIG_PM
+static int ath10k_suspend_wow_arvif(struct ath10k *ar,
+				    struct ath10k_vif *arvif,
+				    struct cfg80211_wowlan *wowlan)
+{
+	int ret, i;
+	unsigned long wow_mask = 0;
+
+	switch (arvif->vdev_type) {
+	case WMI_VDEV_TYPE_IBSS:
+		set_bit(WOW_BEACON_EVENT, &wow_mask);
+		 /* fall through */
+	case WMI_VDEV_TYPE_AP:
+		set_bit(WOW_DEAUTH_RECVD_EVENT, &wow_mask);
+		set_bit(WOW_DISASSOC_RECVD_EVENT, &wow_mask);
+		set_bit(WOW_BMISS_EVENT, &wow_mask);
+		set_bit(WOW_CSA_IE_EVENT, &wow_mask);
+		set_bit(WOW_PROBE_REQ_WPS_IE_EVENT, &wow_mask);
+		set_bit(WOW_AUTH_REQ_EVENT, &wow_mask);
+		set_bit(WOW_ASSOC_REQ_EVENT, &wow_mask);
+		set_bit(WOW_HTT_EVENT, &wow_mask);
+		set_bit(WOW_RA_MATCH_EVENT, &wow_mask);
+		break;
+	case WMI_VDEV_TYPE_STA:
+		if (wowlan->disconnect) {
+			set_bit(WOW_DEAUTH_RECVD_EVENT, &wow_mask);
+			set_bit(WOW_DISASSOC_RECVD_EVENT, &wow_mask);
+			set_bit(WOW_BMISS_EVENT, &wow_mask);
+			set_bit(WOW_CSA_IE_EVENT, &wow_mask);
+		}
+		break;
+	default:
+		break;
+	}
+
+	for (i = 0; i < WOW_EVENT_MAX; i++) {
+		if (!test_bit(i, &wow_mask))
+			continue;
+		ret = ath10k_wmi_wow_add_wakeup_event(ar, arvif->vdev_id, i, 1);
+		if (ret)
+			ath10k_warn(ar, "add wakeup event %s, failed %d\n",
+				    wow_wakeup_event(i), ret);
+	}
+
+	return 0;
+}
+
 static int ath10k_suspend(struct ieee80211_hw *hw,
 			  struct cfg80211_wowlan *wowlan)
 {
 	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif;
 	int ret;
 
 	mutex_lock(&ar->conf_mutex);
 
-	ret = ath10k_wait_for_suspend(ar, WMI_PDEV_SUSPEND);
+	if (!(test_bit(WMI_SERVICE_WOW, ar->wmi.svc_map) &&
+	      test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT, ar->fw_features))) {
+		ret = 1;
+		goto exit;
+	}
+
+	list_for_each_entry(arvif, &ar->arvifs, list)
+		ath10k_suspend_wow_arvif(ar, arvif, wowlan);
+
+	reinit_completion(&ar->target_suspend);
+
+	ret = ath10k_wmi_wow_enable(ar);
 	if (ret) {
-		if (ret == -ETIMEDOUT)
-			goto resume;
+		ath10k_warn(ar, "wmi wow enable failed %d\n", ret);
+		ret = 1;
+		goto exit;
+	}
+
+	/* Wait for wow ack from FW */
+	ret = wait_for_completion_timeout(&ar->target_suspend, 3 * HZ);
+
+	if (ret == 0) {
+		ath10k_warn(ar, "suspend timed out - target pause event never came\n");
 		ret = 1;
 		goto exit;
 	}
@@ -4492,17 +4558,12 @@ static int ath10k_suspend(struct ieee80211_hw *hw,
 	ret = ath10k_hif_suspend(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to suspend hif: %d\n", ret);
-		goto resume;
+		ath10k_wmi_wow_host_wakeup_ind(ar);
+		ret = 1;
+		goto exit;
 	}
 
 	ret = 0;
-	goto exit;
-resume:
-	ret = ath10k_wmi_pdev_resume_target(ar);
-	if (ret)
-		ath10k_warn(ar, "failed to resume target: %d\n", ret);
-
-	ret = 1;
 exit:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
@@ -4515,6 +4576,12 @@ static int ath10k_resume(struct ieee80211_hw *hw)
 
 	mutex_lock(&ar->conf_mutex);
 
+	if (!(test_bit(WMI_SERVICE_WOW, ar->wmi.svc_map) &&
+	      test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT, ar->fw_features))) {
+		ret = 1;
+		goto exit;
+	}
+
 	ret = ath10k_hif_resume(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to resume hif: %d\n", ret);
@@ -4522,9 +4589,18 @@ static int ath10k_resume(struct ieee80211_hw *hw)
 		goto exit;
 	}
 
-	ret = ath10k_wmi_pdev_resume_target(ar);
+	reinit_completion(&ar->wow_wakeup_completed);
+
+	ret = ath10k_wmi_wow_host_wakeup_ind(ar);
 	if (ret) {
-		ath10k_warn(ar, "failed to resume target: %d\n", ret);
+		ath10k_warn(ar, "failed to send wakeup ind\n");
+		return ret;
+	}
+
+	/* Wait complete event */
+	ret = wait_for_completion_timeout(&ar->wow_wakeup_completed, 3*HZ);
+	if (ret == 0) {
+		ath10k_warn(ar, "timed out while waiting for wow wakeup completion\n");
 		ret = 1;
 		goto exit;
 	}
@@ -5259,6 +5335,12 @@ static const struct ieee80211_iface_combination ath10k_10x_if_comb[] = {
 	},
 };
 
+#ifdef CONFIG_PM
+static const struct wiphy_wowlan_support ath10k_wowlan_support = {
+	.flags = WIPHY_WOWLAN_DISCONNECT,
+};
+#endif
+
 static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 {
 	struct ieee80211_sta_vht_cap vht_cap = {0};
@@ -5500,6 +5582,11 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 	ar->hw->wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
 
+#ifdef CONFIG_PM
+	if (test_bit(WMI_SERVICE_WOW, ar->wmi.svc_map) &&
+	    test_bit(ATH10K_FW_FEATURE_WOWLAN_SUPPORT, ar->fw_features))
+		ar->hw->wiphy->wowlan = &ath10k_wowlan_support;
+#endif
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
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
index f34baa0..f8b7a8b 100644
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
@@ -1012,6 +1014,37 @@ static int ath10k_wmi_tlv_op_pull_fw_stats(struct ath10k *ar,
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
+
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
@@ -2490,6 +2523,82 @@ ath10k_wmi_tlv_op_gen_p2p_go_bcn_ie(struct ath10k *ar, u32 vdev_id,
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
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv wow host wakup ind\n");
+	return skb;
+}
+
 /****************/
 /* TLV mappings */
 /****************/
@@ -2741,6 +2850,7 @@ static const struct wmi_ops wmi_tlv_ops = {
 	.pull_svc_rdy = ath10k_wmi_tlv_op_pull_svc_rdy_ev,
 	.pull_rdy = ath10k_wmi_tlv_op_pull_rdy_ev,
 	.pull_fw_stats = ath10k_wmi_tlv_op_pull_fw_stats,
+	.pull_wow_event = ath10k_wmi_tlv_op_pull_wow_ev,
 
 	.gen_pdev_suspend = ath10k_wmi_tlv_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_tlv_op_gen_pdev_resume,
@@ -2786,6 +2896,9 @@ static const struct wmi_ops wmi_tlv_ops = {
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
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c7ea77e..7e96084 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2942,7 +2942,36 @@ void ath10k_wmi_event_rtt_error_report(struct ath10k *ar, struct sk_buff *skb)
 
 void ath10k_wmi_event_wow_wakeup_host(struct ath10k *ar, struct sk_buff *skb)
 {
+	struct wmi_wow_ev_arg ev = {};
+	int ret;
+
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "WMI_WOW_WAKEUP_HOST_EVENTID\n");
+	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi wow wakeup: ",
+			skb->data, skb->len);
+
+	complete(&ar->wow_wakeup_completed);
+
+	ret = ath10k_wmi_pull_wow_event(ar, skb, &ev);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse wow wakeup event: %d\n", ret);
+		return;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wow wakeup host reason: %s\n",
+		   wow_reason(ev.wake_reason));
+	switch (ev.wake_reason) {
+	case WOW_REASON_DEAUTH_RECVD:
+		break;
+	case WOW_REASON_DISASSOC_RECVD:
+		break;
+	case WOW_REASON_AP_ASSOC_LOST:
+		break;
+	case WOW_REASON_CSA_EVENT:
+		break;
+	default:
+		break;
+	}
+
 }
 
 void ath10k_wmi_event_dcs_interference(struct ath10k *ar, struct sk_buff *skb)
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


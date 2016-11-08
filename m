Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60090 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752348AbcKHPDQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 10:03:16 -0500
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <tamizhchelvam@codeaurora.org>,
        "Tamizh chelvam" <c_traja@qti.qualcomm.com>
Subject: [PATCH 2/4] ath10k: Add support to update btcoex priority value via nl80211
Date: Tue, 8 Nov 2016 20:32:32 +0530
Message-ID: <1478617354-28146-3-git-send-email-c_traja@qti.qualcomm.com> (sfid-20161108_160321_968851_51FBDD54)
In-Reply-To: <1478617354-28146-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1478617354-28146-1-git-send-email-c_traja@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch adds support to update btcoex priority value via nl80211.
Here driver will be exposing the supported frame format for this
feature via btcoex_support_flags which is a member of
wiphy structure. 10.4 based firmware support this feature.
WMI service WMI_SERVICE_BTCOEX is used to identify the firmware support
of this feature. BTCOEX needs to enable to modify this value.

This patch has dependency of
"cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY to support BTCOEX"
patch.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     |   76 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   19 ++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     |   19 ++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   18 +++++++
 4 files changed, 132 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f276391..6b0f1ea 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7504,6 +7504,69 @@ static int ath10k_mac_op_set_btcoex(struct ieee80211_hw *hw, bool enabled)
 	return ret;
 }
 
+u32
+ath10k_mac_get_btcoex_prio(struct cfg80211_btcoex_priority *btcoex_priority)
+{
+	u32 btcoex_prio = 0;
+
+	if (btcoex_priority->wlan_be_preferred)
+		btcoex_prio |= WIPHY_WLAN_BE_PREFERRED;
+
+	if (btcoex_priority->wlan_bk_preferred)
+		btcoex_prio |= WIPHY_WLAN_BK_PREFERRED;
+
+	if (btcoex_priority->wlan_vi_preferred)
+		btcoex_prio |= WIPHY_WLAN_VI_PREFERRED;
+
+	if (btcoex_priority->wlan_vo_preferred)
+		btcoex_prio |= WIPHY_WLAN_VO_PREFERRED;
+
+	if (btcoex_priority->wlan_beacon_preferred)
+		btcoex_prio |= WIPHY_WLAN_BEACON_PREFERRED;
+
+	if (btcoex_priority->wlan_mgmt_preferred)
+		btcoex_prio |= WIPHY_WLAN_MGMT_PREFERRED;
+
+	return btcoex_prio;
+}
+
+static int ath10k_mac_op_set_btcoex_priority(struct ieee80211_hw *hw,
+			struct cfg80211_btcoex_priority *btcoex_priority)
+{
+	u32 btcoex_prio;
+	struct ath10k *ar = hw->priv;
+	int ret;
+
+	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags))) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state != ATH10K_STATE_ON &&
+	    ar->state != ATH10K_STATE_RESTARTED) {
+		ret = -ENETDOWN;
+		goto exit;
+	}
+
+	btcoex_prio = ath10k_mac_get_btcoex_prio(btcoex_priority);
+
+	if (btcoex_prio > 0x3f)
+		return -E2BIG;
+
+	ret = ath10k_wmi_set_coex_param(ar, btcoex_prio);
+
+	if (ret) {
+		ath10k_warn(ar, "failed to set btcoex priority: %d\n", ret);
+		goto exit;
+	}
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_mac_op_tx,
 	.wake_tx_queue			= ath10k_mac_op_wake_tx_queue,
@@ -7546,6 +7609,7 @@ static int ath10k_mac_op_set_btcoex(struct ieee80211_hw *hw, bool enabled)
 	.unassign_vif_chanctx		= ath10k_mac_op_unassign_vif_chanctx,
 	.switch_vif_chanctx		= ath10k_mac_op_switch_vif_chanctx,
 	.set_btcoex                     = ath10k_mac_op_set_btcoex,
+	.set_btcoex_priority		= ath10k_mac_op_set_btcoex_priority,
 
 	CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
 
@@ -8136,6 +8200,18 @@ int ath10k_mac_register(struct ath10k *ar)
 	 */
 	ar->hw->offchannel_tx_hw_queue = IEEE80211_MAX_QUEUES - 1;
 
+	if (test_bit(WMI_SERVICE_BTCOEX, ar->wmi.svc_map)) {
+		ar->hw->wiphy->btcoex_support_flags =
+			WIPHY_WLAN_BE_PREFERRED |
+			WIPHY_WLAN_BK_PREFERRED |
+			WIPHY_WLAN_VI_PREFERRED |
+			WIPHY_WLAN_VO_PREFERRED |
+			WIPHY_WLAN_BEACON_PREFERRED |
+			WIPHY_WLAN_MGMT_PREFERRED;
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "btcoex supported mask :%u\n",
+			   ar->hw->wiphy->btcoex_support_flags);
+	}
+
 	switch (ar->running_fw->fw_file.wmi_op_version) {
 	case ATH10K_FW_WMI_OP_VERSION_MAIN:
 		ar->hw->wiphy->iface_combinations = ath10k_if_comb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index c9a8bb1..90c8390 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -197,6 +197,8 @@ struct wmi_ops {
 					(struct ath10k *ar,
 					 enum wmi_bss_survey_req_type type);
 	struct sk_buff *(*gen_echo)(struct ath10k *ar, u32 value);
+	struct sk_buff *(*gen_set_coex_param)(struct ath10k *ar,
+					      u32 btcoex_prio);
 };
 
 int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb, u32 cmd_id);
@@ -1411,4 +1413,21 @@ struct wmi_ops {
 	return ath10k_wmi_cmd_send(ar, skb, wmi->cmd->echo_cmdid);
 }
 
+static inline int
+ath10k_wmi_set_coex_param(struct ath10k *ar, u32 btcoex_prio)
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_set_coex_param)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_set_coex_param(ar, btcoex_prio);
+
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->set_coex_param_cmdid);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 387c4ee..de35c17 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -710,6 +710,7 @@
 	.pdev_bss_chan_info_request_cmdid =
 			WMI_10_4_PDEV_BSS_CHAN_INFO_REQUEST_CMDID,
 	.ext_resource_cfg_cmdid = WMI_10_4_EXT_RESOURCE_CFG_CMDID,
+	.set_coex_param_cmdid = WMI_10_4_BTCOEX_CFG_CMDID,
 };
 
 /* MAIN WMI VDEV param map */
@@ -7859,6 +7860,23 @@ static int ath10k_wmi_10_4_op_get_vdev_subtype(struct ath10k *ar,
 	return 0;
 }
 
+static struct sk_buff *
+ath10k_wmi_10_4_op_gen_set_coex_param(struct ath10k *ar,
+				      u32 btcoex_prio)
+{
+	struct wmi_set_coex_param_10_4_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_set_coex_param_10_4_cmd *)skb->data;
+	cmd->btcoex_prio = __cpu_to_le32(btcoex_prio);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "BTCOEX priority :%u\n", btcoex_prio);
+	return skb;
+}
 static const struct wmi_ops wmi_ops = {
 	.rx = ath10k_wmi_op_rx,
 	.map_svc = wmi_main_svc_map,
@@ -8205,6 +8223,7 @@ static int ath10k_wmi_10_4_op_get_vdev_subtype(struct ath10k *ar,
 	.gen_pdev_bss_chan_info_req = ath10k_wmi_10_2_op_gen_pdev_bss_chan_info,
 	.gen_echo = ath10k_wmi_op_gen_echo,
 	.gen_pdev_get_tpc_config = ath10k_wmi_10_2_4_op_gen_pdev_get_tpc_config,
+	.gen_set_coex_param = ath10k_wmi_10_4_op_gen_set_coex_param,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1b243c8..3a739e3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -184,6 +184,8 @@ enum wmi_service {
 	WMI_SERVICE_TX_MODE_PUSH_ONLY,
 	WMI_SERVICE_TX_MODE_PUSH_PULL,
 	WMI_SERVICE_TX_MODE_DYNAMIC,
+	WMI_SERVICE_VDEV_RX_FILTER,
+	WMI_SERVICE_BTCOEX,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -310,6 +312,8 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_TX_MODE_PUSH_ONLY,
 	WMI_10_4_SERVICE_TX_MODE_PUSH_PULL,
 	WMI_10_4_SERVICE_TX_MODE_DYNAMIC,
+	WMI_10_4_SERVICE_VDEV_RX_FILTER,
+	WMI_10_4_SERVICE_BTCOEX,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -408,6 +412,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_TX_MODE_PUSH_ONLY);
 	SVCSTR(WMI_SERVICE_TX_MODE_PUSH_PULL);
 	SVCSTR(WMI_SERVICE_TX_MODE_DYNAMIC);
+	SVCSTR(WMI_SERVICE_BTCOEX);
 	default:
 		return NULL;
 	}
@@ -663,6 +668,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_TX_MODE_PUSH_PULL, len);
 	SVCMAP(WMI_10_4_SERVICE_TX_MODE_DYNAMIC,
 	       WMI_SERVICE_TX_MODE_DYNAMIC, len);
+	SVCMAP(WMI_10_4_SERVICE_BTCOEX,
+	       WMI_SERVICE_BTCOEX, len);
 }
 
 #undef SVCMAP
@@ -837,6 +844,7 @@ struct wmi_cmd_map {
 	u32 pdev_bss_chan_info_request_cmdid;
 	u32 pdev_enable_adaptive_cca_cmdid;
 	u32 ext_resource_cfg_cmdid;
+	u32 set_coex_param_cmdid;
 };
 
 /*
@@ -1646,6 +1654,11 @@ enum wmi_10_4_cmd_id {
 	WMI_10_4_EXT_RESOURCE_CFG_CMDID,
 	WMI_10_4_VDEV_SET_IE_CMDID,
 	WMI_10_4_SET_LTEU_CONFIG_CMDID,
+	WMI_10_4_ATF_SSID_GROUPING_REQUEST_CMDID,
+	WMI_10_4_PEER_ATF_EXT_REQUEST_CMDID,
+	WMI_10_4_SET_PERIODIC_CHANNEL_STATS_CONFIG,
+	WMI_10_4_PEER_BWF_REQUEST_CMDID,
+	WMI_10_4_BTCOEX_CFG_CMDID,
 	WMI_10_4_PDEV_UTF_CMDID = WMI_10_4_END_CMDID - 1,
 };
 
@@ -2723,6 +2736,11 @@ struct wmi_ext_resource_config_10_4_cmd {
 	__le32 fw_feature_bitmap;
 };
 
+struct wmi_set_coex_param_10_4_cmd {
+	/* contains wlan priority frame type value preferred over bt */
+	__le32 btcoex_prio;
+};
+
 /* strucutre describing host memory chunk. */
 struct host_memory_chunk {
 	/* id of the request that is passed up in service ready */
-- 
1.7.9.5

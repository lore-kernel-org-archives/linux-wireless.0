Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52036 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbeHOKye (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 06:54:34 -0400
From: Wen Gong <wgong@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] ath10k: support NET_DETECT WoWLAN feature
Date: Wed, 15 Aug 2018 16:02:46 +0800
Message-Id: <1534320166-10380-1-git-send-email-wgong@codeaurora.org> (sfid-20180815_100412_361408_FAD6B2FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For WoWLAN support, it expect to support wake up based on discovery of
one or more known SSIDs. This is the WIPHY_WOWLAN_NET_DETECT feature,
which shows up as an NL80211 feature flag.

With an upgrade iw, this shows up in 'iw phy' as:
WoWLAN support:
* wake up on network detection, up to 16 match sets
And it can use command:
"iw phy0 wowlan enable net-detect interval 5000 delay 30 freqs 2412
matches ssid foo" to configure the parameters of net detect.

Firmware will do scan by the configured parameters after suspend and
wakeup if it found matched SSIDs. Tested with QCA6174 hw3.0 with
firmware WLAN.RM.4.4.1-00110-QCARMSWPZ-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
V2:
-fix the waring of endian
 drivers/net/wireless/ath/ath10k/core.h    |   1 +
 drivers/net/wireless/ath/ath10k/mac.c     |  12 ++
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  21 +++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 180 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 226 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  57 ++++++++
 drivers/net/wireless/ath/ath10k/wow.c     | 168 ++++++++++++++++++++++
 7 files changed, 664 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 427ee57..7885462 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -904,6 +904,7 @@ struct ath10k {
 	u32 high_5ghz_chan;
 	bool ani_enabled;
 
+	bool nlo_enabled;
 	bool p2p;
 
 	struct {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 95243b4..ba9b9af 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8361,6 +8361,18 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->wiphy->max_scan_ssids = WLAN_SCAN_PARAMS_MAX_SSID;
 	ar->hw->wiphy->max_scan_ie_len = WLAN_SCAN_PARAMS_MAX_IE_LEN;
 
+	if (test_bit(WMI_SERVICE_NLO, ar->wmi.svc_map)) {
+		ar->hw->wiphy->max_sched_scan_reqs = 1;
+		ar->hw->wiphy->max_sched_scan_ssids = WMI_PNO_MAX_SUPP_NETWORKS;
+		ar->hw->wiphy->max_match_sets       = WMI_PNO_MAX_SUPP_NETWORKS;
+		ar->hw->wiphy->max_sched_scan_ie_len = WMI_PNO_MAX_IE_LENGTH;
+		ar->hw->wiphy->max_sched_scan_plans = WMI_PNO_MAX_SCHED_SCAN_PLANS;
+		ar->hw->wiphy->max_sched_scan_plan_interval =
+			WMI_PNO_MAX_SCHED_SCAN_PLAN_INT;
+		ar->hw->wiphy->max_sched_scan_plan_iterations =
+			WMI_PNO_MAX_SCHED_SCAN_PLAN_ITRNS;
+	}
+
 	ar->hw->vif_data_size = sizeof(struct ath10k_vif);
 	ar->hw->sta_data_size = sizeof(struct ath10k_sta);
 	ar->hw->txq_data_size = sizeof(struct ath10k_txq);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 5ecce04..68fff3a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -208,6 +208,9 @@ struct wmi_ops {
 					       u32 fw_feature_bitmap);
 	int (*get_vdev_subtype)(struct ath10k *ar,
 				enum wmi_vdev_subtype subtype);
+	struct sk_buff *(*gen_wow_config_pno)(struct ath10k *ar,
+					      u32 vdev_id,
+					      struct wmi_pno_scan_req *pno_scan);
 	struct sk_buff *(*gen_pdev_bss_chan_info_req)
 					(struct ath10k *ar,
 					 enum wmi_bss_survey_req_type type);
@@ -1349,6 +1352,24 @@ struct wmi_ops {
 }
 
 static inline int
+ath10k_wmi_wow_config_pno(struct ath10k *ar, u32 vdev_id,
+			  struct wmi_pno_scan_req  *pno_scan)
+{
+	struct sk_buff *skb;
+	u32 cmd_id;
+
+	if (!ar->wmi.ops->gen_wow_config_pno)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_wow_config_pno(ar, vdev_id, pno_scan);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	cmd_id = ar->wmi.cmd->network_list_offload_config_cmdid;
+	return ath10k_wmi_cmd_send(ar, skb, cmd_id);
+}
+
+static inline int
 ath10k_wmi_update_fw_tdls_state(struct ath10k *ar, u32 vdev_id,
 				enum wmi_tdls_state state)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index b04f86f..e74f222 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3239,7 +3239,6 @@ static u32 ath10k_wmi_tlv_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_WOW_HOSTWAKEUP_FROM_SLEEP_CMD);
 	tlv->len = __cpu_to_le16(sizeof(*cmd));
 	cmd = (void *)tlv->value;
-
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv wow host wakeup ind\n");
 	return skb;
 }
@@ -3372,6 +3371,184 @@ static u32 ath10k_wmi_tlv_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	return skb;
 }
 
+/* Request FW to start PNO operation */
+static struct sk_buff *ath10k_wmi_tlv_op_gen_config_pno_start
+				(struct ath10k *ar,
+				u32 vdev_id,
+				struct wmi_pno_scan_req *pno)
+{
+	struct wmi_tlv_wow_nlo_config_cmd *cmd;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	struct nlo_configured_parameters *nlo_list;
+	u32 *channel_list;
+	void *ptr;
+	size_t len;
+	u32 i;
+
+	len = sizeof(*tlv) + sizeof(*cmd) +
+	      sizeof(*tlv) +
+	      /* TLV place holder for array of structures
+	       * nlo_configured_parameters(nlo_list)
+	       */
+	      sizeof(*tlv);
+	      /* TLV place holder for array of uint32 channel_list */
+
+	len += sizeof(u32) * min_t(u8, pno->a_networks[0].channel_count,
+				   WMI_NLO_MAX_CHAN);
+	len += sizeof(struct nlo_configured_parameters) *
+				min_t(u8, pno->uc_networks_count, WMI_NLO_MAX_SSIDS);
+
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ptr = (void *)skb->data;
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_NLO_CONFIG_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+
+	/* wmi_tlv_wow_nlo_config_cmd parameters*/
+	cmd->vdev_id = __cpu_to_le32(pno->vdev_id);
+	cmd->flags = __cpu_to_le32(WMI_NLO_CONFIG_START | WMI_NLO_CONFIG_SSID_HIDE_EN);
+
+	/* Current FW does not support min-max range for dwell time */
+	cmd->active_dwell_time = __cpu_to_le32(pno->active_max_time);
+	cmd->passive_dwell_time = __cpu_to_le32(pno->passive_max_time);
+
+	if (pno->do_passive_scan)
+		cmd->flags |= WMI_NLO_CONFIG_SCAN_PASSIVE;
+	/* Copy scan interval */
+	cmd->fast_scan_period = __cpu_to_le32(pno->fast_scan_period);
+	cmd->slow_scan_period = __cpu_to_le32(pno->slow_scan_period);
+	cmd->fast_scan_max_cycles = __cpu_to_le32(pno->fast_scan_max_cycles);
+	cmd->delay_start_time = __cpu_to_le32(pno->delay_start_time);
+	if (pno->enable_pno_scan_randomization) {
+		cmd->flags |= __cpu_to_le32(WMI_NLO_CONFIG_SPOOFED_MAC_IN_PROBE_REQ |
+				WMI_NLO_CONFIG_RANDOM_SEQ_NO_IN_PROBE_REQ);
+		ether_addr_copy(cmd->mac_addr.addr, pno->mac_addr);
+		ether_addr_copy(cmd->mac_mask.addr, pno->mac_addr_mask);
+	}
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	/* nlo_configured_parameters(nlo_list) */
+	cmd->no_of_ssids = __cpu_to_le32(min_t(u8, pno->uc_networks_count,
+					       WMI_NLO_MAX_SSIDS));
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
+	tlv->len = __cpu_to_le16
+		((u16)(cmd->no_of_ssids * sizeof(struct nlo_configured_parameters)));
+
+	ptr += sizeof(*tlv);
+	nlo_list = ptr;
+	for (i = 0; i < cmd->no_of_ssids; i++) {
+		tlv = (struct wmi_tlv *)(&nlo_list[i].tlv_header);
+		tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_BYTE);
+		tlv->len = __cpu_to_le16
+			(sizeof(struct nlo_configured_parameters) - sizeof(*tlv));
+		/* Copy ssid and it's length */
+		nlo_list[i].ssid.valid = __cpu_to_le32(true);
+		nlo_list[i].ssid.ssid.ssid_len = pno->a_networks[i].ssid.ssid_len;
+		memcpy(nlo_list[i].ssid.ssid.ssid,
+		       pno->a_networks[i].ssid.ssid,
+		       __le32_to_cpu(nlo_list[i].ssid.ssid.ssid_len));
+
+		/* Copy rssi threshold */
+		if (pno->a_networks[i].rssi_threshold &&
+		    pno->a_networks[i].rssi_threshold > -300) {
+			nlo_list[i].rssi_cond.valid = __cpu_to_le32(true);
+			nlo_list[i].rssi_cond.rssi =
+				__cpu_to_le32(pno->a_networks[i].rssi_threshold);
+		}
+
+		nlo_list[i].bcast_nw_type.valid = __cpu_to_le32(true);
+		nlo_list[i].bcast_nw_type.bcast_nw_type =
+			__cpu_to_le32(pno->a_networks[i].bcast_nw_type);
+	}
+
+	ptr += cmd->no_of_ssids * sizeof(struct nlo_configured_parameters);
+
+	/* Copy channel info */
+	cmd->num_of_channels = __cpu_to_le32(min_t(u8, pno->a_networks[0].channel_count,
+						   WMI_NLO_MAX_CHAN));
+
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_UINT32);
+	tlv->len = __cpu_to_le16(cmd->num_of_channels * sizeof(u_int32_t));
+	ptr += sizeof(*tlv);
+
+	channel_list = (u32 *)ptr;
+	for (i = 0; i < cmd->num_of_channels; i++)
+		channel_list[i] = pno->a_networks[0].channels[i];
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv start pno config vdev_id %d\n", vdev_id);
+	return skb;
+}
+
+/* Request FW to stop ongoing PNO operation */
+static struct sk_buff *ath10k_wmi_tlv_op_gen_config_pno_stop(struct ath10k *ar,
+							     u32 vdev_id)
+{
+	struct wmi_tlv_wow_nlo_config_cmd *cmd;
+	struct wmi_tlv *tlv;
+	struct sk_buff *skb;
+	void *ptr;
+	size_t len;
+
+	len = sizeof(*tlv) + sizeof(*cmd) +
+	      sizeof(*tlv) +
+	      /* TLV place holder for array of structures
+	       * nlo_configured_parameters(nlo_list)
+	       */
+	      sizeof(*tlv);
+	      /* TLV place holder for array of uint32 channel_list */
+	skb = ath10k_wmi_alloc_skb(ar, len);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	ptr = (void *)skb->data;
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_STRUCT_NLO_CONFIG_CMD);
+	tlv->len = __cpu_to_le16(sizeof(*cmd));
+	cmd = (void *)tlv->value;
+
+	cmd->vdev_id = __cpu_to_le32(vdev_id);
+	cmd->flags = WMI_NLO_CONFIG_STOP;
+
+	ptr += sizeof(*tlv);
+	ptr += sizeof(*cmd);
+
+	/* nlo_configured_parameters(nlo_list) */
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
+	tlv->len = __cpu_to_le16(0);
+
+	ptr += sizeof(*tlv);
+
+	/* channel list */
+	tlv = ptr;
+	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_UINT32);
+	tlv->len = __cpu_to_le16(0);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv stop pno config vdev_id %d\n", vdev_id);
+	return skb;
+}
+
+static struct sk_buff *
+ath10k_wmi_tlv_op_gen_config_pno(struct ath10k *ar, u32 vdev_id,
+				 struct wmi_pno_scan_req *pno_scan)
+{
+	struct sk_buff *skb;
+
+	if (pno_scan->enable)
+		skb = ath10k_wmi_tlv_op_gen_config_pno_start(ar, vdev_id, pno_scan);
+	else
+		skb = ath10k_wmi_tlv_op_gen_config_pno_stop(ar, vdev_id);
+	return skb;
+}
+
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_adaptive_qcs(struct ath10k *ar, bool enable)
 {
@@ -3903,6 +4080,7 @@ static u32 ath10k_wmi_tlv_prepare_peer_qos(u8 uapsd_queues, u8 sp)
 	.gen_wow_host_wakeup_ind = ath10k_wmi_tlv_gen_wow_host_wakeup_ind,
 	.gen_wow_add_pattern = ath10k_wmi_tlv_op_gen_wow_add_pattern,
 	.gen_wow_del_pattern = ath10k_wmi_tlv_op_gen_wow_del_pattern,
+	.gen_wow_config_pno = ath10k_wmi_tlv_op_gen_config_pno,
 	.gen_update_fw_tdls_state = ath10k_wmi_tlv_op_gen_update_fw_tdls_state,
 	.gen_tdls_peer_update = ath10k_wmi_tlv_op_gen_tdls_peer_update,
 	.gen_adaptive_qcs = ath10k_wmi_tlv_op_gen_adaptive_qcs,
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 3e1e340..ce706eb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -2129,6 +2129,232 @@ struct wmi_tlv_tdls_peer_event {
 
 void ath10k_wmi_tlv_attach(struct ath10k *ar);
 
+enum wmi_nlo_auth_algorithm {
+	WMI_NLO_AUTH_ALGO_80211_OPEN        = 1,
+	WMI_NLO_AUTH_ALGO_80211_SHARED_KEY  = 2,
+	WMI_NLO_AUTH_ALGO_WPA               = 3,
+	WMI_NLO_AUTH_ALGO_WPA_PSK           = 4,
+	WMI_NLO_AUTH_ALGO_WPA_NONE          = 5,
+	WMI_NLO_AUTH_ALGO_RSNA              = 6,
+	WMI_NLO_AUTH_ALGO_RSNA_PSK          = 7,
+};
+
+enum wmi_nlo_cipher_algorithm {
+	WMI_NLO_CIPHER_ALGO_NONE           = 0x00,
+	WMI_NLO_CIPHER_ALGO_WEP40          = 0x01,
+	WMI_NLO_CIPHER_ALGO_TKIP           = 0x02,
+	WMI_NLO_CIPHER_ALGO_CCMP           = 0x04,
+	WMI_NLO_CIPHER_ALGO_WEP104         = 0x05,
+	WMI_NLO_CIPHER_ALGO_BIP            = 0x06,
+	WMI_NLO_CIPHER_ALGO_WPA_USE_GROUP  = 0x100,
+	WMI_NLO_CIPHER_ALGO_RSN_USE_GROUP  = 0x100,
+	WMI_NLO_CIPHER_ALGO_WEP            = 0x101,
+};
+
+/* SSID broadcast  type passed in NLO params */
+enum wmi_nlo_ssid_bcastnwtype {
+	WMI_NLO_BCAST_UNKNOWN      = 0,
+	WMI_NLO_BCAST_NORMAL       = 1,
+	WMI_NLO_BCAST_HIDDEN       = 2,
+};
+
+#define WMI_NLO_MAX_SSIDS    16
+#define WMI_NLO_MAX_CHAN     48
+
+#define WMI_NLO_CONFIG_STOP                             (0x1 << 0)
+#define WMI_NLO_CONFIG_START                            (0x1 << 1)
+#define WMI_NLO_CONFIG_RESET                            (0x1 << 2)
+#define WMI_NLO_CONFIG_SLOW_SCAN                        (0x1 << 4)
+#define WMI_NLO_CONFIG_FAST_SCAN                        (0x1 << 5)
+#define WMI_NLO_CONFIG_SSID_HIDE_EN                     (0x1 << 6)
+/* This bit is used to indicate if EPNO or supplicant PNO is enabled.
+ * Only one of them can be enabled at a given time
+ */
+#define WMI_NLO_CONFIG_ENLO                             (0x1 << 7)
+#define WMI_NLO_CONFIG_SCAN_PASSIVE                     (0x1 << 8)
+#define WMI_NLO_CONFIG_ENLO_RESET                       (0x1 << 9)
+#define WMI_NLO_CONFIG_SPOOFED_MAC_IN_PROBE_REQ         (0x1 << 10)
+#define WMI_NLO_CONFIG_RANDOM_SEQ_NO_IN_PROBE_REQ       (0x1 << 11)
+#define WMI_NLO_CONFIG_ENABLE_IE_WHITELIST_IN_PROBE_REQ (0x1 << 12)
+#define WMI_NLO_CONFIG_ENABLE_CNLO_RSSI_CONFIG          (0x1 << 13)
+
+/* Whether directed scan needs to be performed (for hidden SSIDs) */
+#define WMI_ENLO_FLAG_DIRECTED_SCAN      1
+/* Whether PNO event shall be triggered if the network is found on A band */
+#define WMI_ENLO_FLAG_A_BAND             2
+/* Whether PNO event shall be triggered if the network is found on G band */
+#define WMI_ENLO_FLAG_G_BAND             4
+/* Whether strict matching is required (i.e. firmware shall not
+ * match on the entire SSID)
+ */
+#define WMI_ENLO_FLAG_STRICT_MATCH       8
+
+/* Code for matching the beacon AUTH IE - additional codes TBD */
+/* open */
+#define WMI_ENLO_AUTH_CODE_OPEN  1
+/* WPA_PSK or WPA2PSK */
+#define WMI_ENLO_AUTH_CODE_PSK   2
+/* any EAPOL */
+#define WMI_ENLO_AUTH_CODE_EAPOL 4
+
+/* NOTE: wmi_nlo_ssid_param structure can't be changed
+ * without breaking the compatibility
+ */
+struct wmi_nlo_ssid_param {
+	__le32 valid;
+	struct wmi_ssid ssid;
+} __packed;
+
+/* NOTE: wmi_nlo_enc_param structure can't be changed without
+ * breaking the compatibility
+ */
+struct wmi_nlo_enc_param {
+	__le32 valid;
+	__le32 enc_type;
+} __packed;
+
+/* NOTE: wmi_nlo_auth_param structure can't be changed without
+ * breaking the compatibility
+ */
+struct wmi_nlo_auth_param {
+	__le32 valid;
+	__le32 auth_type;
+} __packed;
+
+/* NOTE: wmi_nlo_bcast_nw_param structure can't be changed without
+ * breaking the compatibility
+ */
+struct wmi_nlo_bcast_nw_param {
+	__le32 valid;
+	/* If WMI_NLO_CONFIG_EPNO is not set. Supplicant PNO is enabled.
+	 * The value should be true/false. Otherwise EPNO is enabled.
+	 * bcast_nw_type would be used as a bit flag contains WMI_ENLO_FLAG_XXX
+	 */
+	__le32 bcast_nw_type;
+} __packed;
+
+/* NOTE: wmi_nlo_rssi_param structure can't be changed without
+ * breaking the compatibility
+ */
+struct wmi_nlo_rssi_param {
+	__le32 valid;
+	__le32 rssi;
+} __packed;
+
+struct nlo_configured_parameters {
+	/* TLV tag and len;*/
+	__le32 tlv_header;
+	struct wmi_nlo_ssid_param ssid;
+	struct wmi_nlo_enc_param enc_type;
+	struct wmi_nlo_auth_param auth_type;
+	struct wmi_nlo_rssi_param rssi_cond;
+	/* indicates if the SSID is hidden or not */
+	struct wmi_nlo_bcast_nw_param bcast_nw_type;
+} __packed;
+
+/* Support channel prediction for PNO scan after scanning top_k_num channels
+ * if stationary_threshold is met.
+ */
+struct nlo_channel_prediction_cfg {
+	__le32 tlv_header;
+	/* Enable or disable this feature. */
+	__le32 enable;
+	/* Top K channels will be scanned before deciding whether to further scan
+	 * or stop. Minimum value is 3 and maximum is 5.
+	 */
+	__le32 top_k_num;
+	/* Preconfigured stationary threshold.
+	 * Lesser value means more conservative. Bigger value means more aggressive.
+	 * Maximum is 100 and mininum is 0.
+	 */
+	__le32 stationary_threshold;
+	/* Periodic full channel scan in milliseconds unit.
+	 * After full_scan_period_ms since last full scan, channel prediction
+	 * scan is suppressed and will do full scan.
+	 * This is to help detecting sudden AP power-on or -off. Value 0 means no
+	 * full scan at all (not recommended).
+	 */
+	__le32 full_scan_period_ms;
+} __packed;
+
+struct enlo_candidate_score_params_t {
+	__le32 tlv_header;   /* TLV tag and len; */
+	/* minimum 5GHz RSSI for a BSSID to be considered (units = dBm) */
+	__le32 min5GHz_rssi;
+	/* minimum 2.4GHz RSSI for a BSSID to be considered (units = dBm) */
+	__le32 min24GHz_rssi;
+	/* the maximum score that a network can have before bonuses */
+	__le32 initial_score_max;
+	/* current_connection_bonus:
+	 * only report when there is a network's score this much higher
+	 * than the current connection
+	 */
+	__le32 current_connection_bonus;
+	/* score bonus for all networks with the same network flag */
+	__le32 same_network_bonus;
+	__le32 secure_bonus; /* score bonus for networks that are not open */
+	__le32 band5GHz_bonus; /* 5GHz RSSI score bonus (applied to all 5GHz networks) */
+} __packed;
+
+struct connected_nlo_bss_band_rssi_pref_t {
+	__le32 tlv_header; /* TLV tag and len;*/
+	/* band which needs to get preference over other band
+	 * - see wmi_set_vdev_ie_band enum
+	 */
+	__le32 band;
+	/* Amount of RSSI preference (in dB) that can be given to a band */
+	__le32  rssi_pref;
+} __packed;
+
+struct connected_nlo_rssi_params_t {
+	__le32 tlv_header; /* TLV tag and len;*/
+	/* Relative rssi threshold (in dB) by which new BSS should have better rssi than
+	 * the current connected BSS.
+	 */
+	__le32  relative_rssi;
+	/* The amount of rssi preference (in dB) that can be given
+	 * to a 5G BSS over 2.4G BSS.
+	 */
+	__le32  relative_rssi_5g_pref;
+} __packed;
+
+struct wmi_tlv_wow_nlo_config_cmd {
+	__le32 flags;
+	__le32 vdev_id;
+	__le32 fast_scan_max_cycles;
+	__le32 active_dwell_time;
+	__le32 passive_dwell_time; /* PDT in msecs */
+	__le32 probe_bundle_size;
+	__le32 rest_time;  /* ART = IRT */
+	__le32 max_rest_time; /* Max value that can be reached after SBM */
+	__le32 scan_backoff_multiplier;  /* SBM */
+	__le32 fast_scan_period; /* SCBM */
+	__le32 slow_scan_period; /* specific to windows */
+	__le32 no_of_ssids;
+	__le32 num_of_channels;
+	__le32 delay_start_time; /* NLO scan start delay time in milliseconds */
+	/** MAC Address to use in Probe Req as SA **/
+	struct wmi_mac_addr mac_addr;
+	/** Mask on which MAC has to be randomized **/
+	struct wmi_mac_addr mac_mask;
+	/** IE bitmap to use in Probe Req **/
+	__le32 ie_bitmap[8];
+	/** Number of vendor OUIs. In the TLV vendor_oui[] **/
+	__le32 num_vendor_oui;
+	/** Number of connected NLO band preferences **/
+	__le32 num_cnlo_band_pref;
+
+	/* The TLVs will follow.
+	 * nlo_configured_parameters nlo_list[];
+	 * A_UINT32 channel_list[num_of_channels];
+	 * nlo_channel_prediction_cfg ch_prediction_cfg;
+	 * enlo_candidate_score_params candidate_score_params;
+	 * wmi_vendor_oui vendor_oui[num_vendor_oui];
+	 * connected_nlo_rssi_params cnlo_rssi_params;
+	 * connected_nlo_bss_band_rssi_pref cnlo_bss_band_rssi_pref[num_cnlo_band_pref];
+	 */
+} __packed;
+
 struct wmi_tlv_mgmt_tx_cmd {
 	__le32 vdev_id;
 	__le32 desc_id;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index d68afb6..6b7e603 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -7013,6 +7013,63 @@ struct wmi_pdev_set_adaptive_cca_params {
 	__le32 cca_detect_margin;
 } __packed;
 
+#define WMI_PNO_MAX_SCHED_SCAN_PLANS      2
+#define WMI_PNO_MAX_SCHED_SCAN_PLAN_INT   7200
+#define WMI_PNO_MAX_SCHED_SCAN_PLAN_ITRNS 100
+#define WMI_PNO_MAX_NETW_CHANNELS         26
+#define WMI_PNO_MAX_NETW_CHANNELS_EX      60
+#define WMI_PNO_MAX_SUPP_NETWORKS         WLAN_SCAN_PARAMS_MAX_SSID
+#define WMI_PNO_MAX_IE_LENGTH             WLAN_SCAN_PARAMS_MAX_IE_LEN
+
+/*size based of dot11 declaration without extra IEs as we will not carry those for PNO*/
+#define WMI_PNO_MAX_PB_REQ_SIZE    450
+
+#define WMI_PNO_24G_DEFAULT_CH     1
+#define WMI_PNO_5G_DEFAULT_CH      36
+
+#define WMI_ACTIVE_MAX_CHANNEL_TIME 40
+#define WMI_PASSIVE_MAX_CHANNEL_TIME   110
+
+/* SSID broadcast type */
+enum wmi_SSID_bcast_type {
+	BCAST_UNKNOWN      = 0,
+	BCAST_NORMAL       = 1,
+	BCAST_HIDDEN       = 2,
+};
+
+struct wmi_network_type {
+	struct wmi_ssid ssid;
+	u32 authentication;
+	u32 encryption;
+	u32 bcast_nw_type;
+	u8 channel_count;
+	u16 channels[WMI_PNO_MAX_NETW_CHANNELS_EX];
+	s32 rssi_threshold;
+} __packed;
+
+struct wmi_pno_scan_req {
+	u8 enable;
+	u8 vdev_id;
+	u8 uc_networks_count;
+	struct wmi_network_type a_networks[WMI_PNO_MAX_SUPP_NETWORKS];
+	u32 fast_scan_period;
+	u32 slow_scan_period;
+	u8 fast_scan_max_cycles;
+
+	bool do_passive_scan;
+
+	u32 delay_start_time;
+	u32 active_min_time;
+	u32 active_max_time;
+	u32 passive_min_time;
+	u32 passive_max_time;
+
+	/* mac address randomization attributes */
+	u32 enable_pno_scan_randomization;
+	u8 mac_addr[ETH_ALEN];
+	u8 mac_addr_mask[ETH_ALEN];
+} __packed;
+
 enum wmi_host_platform_type {
 	WMI_HOST_PLATFORM_HIGH_PERF,
 	WMI_HOST_PLATFORM_LOW_PERF,
diff --git a/drivers/net/wireless/ath/ath10k/wow.c b/drivers/net/wireless/ath/ath10k/wow.c
index a6b179f..c7ec610 100644
--- a/drivers/net/wireless/ath/ath10k/wow.c
+++ b/drivers/net/wireless/ath/ath10k/wow.c
@@ -180,6 +180,106 @@ static int ath10k_wow_cleanup(struct ath10k *ar)
 	}
 }
 
+static int ath10k_wmi_pno_check
+	(struct ath10k *ar, u32 vdev_id,
+	struct cfg80211_sched_scan_request *nd_config,
+	struct wmi_pno_scan_req *pno)
+{
+	int ret = 0;
+	int i, j;
+
+	pno->enable = 1;
+	pno->vdev_id = vdev_id;
+	pno->uc_networks_count = nd_config->n_match_sets;
+	if (!pno->uc_networks_count ||
+	    pno->uc_networks_count > WMI_PNO_MAX_SUPP_NETWORKS) {
+		ret = -EINVAL;
+		return ret;
+	}
+
+	if (nd_config->n_channels > WMI_PNO_MAX_NETW_CHANNELS_EX) {
+		ret = -EINVAL;
+		return ret;
+	}
+
+	/* Filling per profile  params */
+	for (i = 0; i < pno->uc_networks_count; i++) {
+		pno->a_networks[i].ssid.ssid_len =
+			nd_config->match_sets[i].ssid.ssid_len;
+
+		if (pno->a_networks[i].ssid.ssid_len == 0 ||
+		    pno->a_networks[i].ssid.ssid_len > 32) {
+			ret = -EINVAL;
+			return ret;
+		}
+
+		memcpy(pno->a_networks[i].ssid.ssid,
+		       nd_config->match_sets[i].ssid.ssid,
+		       nd_config->match_sets[i].ssid.ssid_len);
+		pno->a_networks[i].authentication = 0;
+		pno->a_networks[i].encryption     = 0;
+		pno->a_networks[i].bcast_nw_type  = 0;
+
+		/*Copying list of valid channel into request */
+		pno->a_networks[i].channel_count = nd_config->n_channels;
+		pno->a_networks[i].rssi_threshold = nd_config->match_sets[i].rssi_thold;
+
+		for (j = 0; j < nd_config->n_channels; j++) {
+			pno->a_networks[i].channels[j] =
+					nd_config->channels[j]->center_freq;
+		}
+	}
+
+	/* set scan to passive if no SSIDs are specified in the request */
+	if (nd_config->n_ssids == 0)
+		pno->do_passive_scan = true;
+	else
+		pno->do_passive_scan = false;
+
+	for (i = 0; i < nd_config->n_ssids; i++) {
+		j = 0;
+		while (j < pno->uc_networks_count) {
+			if (pno->a_networks[j].ssid.ssid_len ==
+				nd_config->ssids[i].ssid_len &&
+			(memcmp(pno->a_networks[j].ssid.ssid,
+				nd_config->ssids[i].ssid,
+				pno->a_networks[j].ssid.ssid_len) == 0)) {
+				pno->a_networks[j].bcast_nw_type = BCAST_HIDDEN;
+				break;
+			}
+			j++;
+		}
+	}
+
+	if (nd_config->n_scan_plans == 2) {
+		pno->fast_scan_period = nd_config->scan_plans[0].interval * MSEC_PER_SEC;
+		pno->fast_scan_max_cycles = nd_config->scan_plans[0].iterations;
+		pno->slow_scan_period =
+			nd_config->scan_plans[1].interval * MSEC_PER_SEC;
+	} else if (nd_config->n_scan_plans == 1) {
+		pno->fast_scan_period = nd_config->scan_plans[0].interval * MSEC_PER_SEC;
+		pno->fast_scan_max_cycles = 1;
+		pno->slow_scan_period = nd_config->scan_plans[0].interval * MSEC_PER_SEC;
+	} else {
+		ath10k_warn(ar, "Invalid number of scan plans %d !!",
+			    nd_config->n_scan_plans);
+	}
+
+	if (nd_config->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
+		/* enable mac randomization */
+		pno->enable_pno_scan_randomization = 1;
+		memcpy(pno->mac_addr, nd_config->mac_addr, ETH_ALEN);
+		memcpy(pno->mac_addr_mask, nd_config->mac_addr_mask, ETH_ALEN);
+	}
+
+	pno->delay_start_time = nd_config->delay;
+
+	/* Current FW does not support min-max range for dwell time */
+	pno->active_max_time = WMI_ACTIVE_MAX_CHANNEL_TIME;
+	pno->passive_max_time = WMI_PASSIVE_MAX_CHANNEL_TIME;
+	return ret;
+}
+
 static int ath10k_vif_wow_set_wakeups(struct ath10k_vif *arvif,
 				      struct cfg80211_wowlan *wowlan)
 {
@@ -213,6 +313,23 @@ static int ath10k_vif_wow_set_wakeups(struct ath10k_vif *arvif,
 
 		if (wowlan->magic_pkt)
 			__set_bit(WOW_MAGIC_PKT_RECVD_EVENT, &wow_mask);
+
+		if (wowlan->nd_config) {
+			struct wmi_pno_scan_req *pno;
+			int ret;
+
+			pno = kzalloc(sizeof(*pno), GFP_KERNEL);
+			ar->nlo_enabled = true;
+
+			ret = ath10k_wmi_pno_check(ar, arvif->vdev_id,
+						   wowlan->nd_config, pno);
+			if (!ret) {
+				ath10k_wmi_wow_config_pno(ar, arvif->vdev_id, pno);
+				__set_bit(WOW_NLO_DETECTED_EVENT, &wow_mask);
+			}
+
+			kfree(pno);
+		}
 		break;
 	default:
 		break;
@@ -299,6 +416,48 @@ static int ath10k_wow_set_wakeups(struct ath10k *ar,
 	return 0;
 }
 
+static int ath10k_vif_wow_clean_nlo(struct ath10k_vif *arvif)
+{
+	int ret = 0;
+	struct ath10k *ar = arvif->ar;
+
+	switch (arvif->vdev_type) {
+	case WMI_VDEV_TYPE_STA:
+		if (ar->nlo_enabled) {
+			struct wmi_pno_scan_req *pno;
+
+			pno = kzalloc(sizeof(*pno), GFP_KERNEL);
+			pno->enable = 0;
+			ar->nlo_enabled = false;
+			ret = ath10k_wmi_wow_config_pno(ar, arvif->vdev_id, pno);
+			kfree(pno);
+		}
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+static int ath10k_wow_nlo_cleanup(struct ath10k *ar)
+{
+	struct ath10k_vif *arvif;
+	int ret = 0;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	list_for_each_entry(arvif, &ar->arvifs, list) {
+		ret = ath10k_vif_wow_clean_nlo(arvif);
+		if (ret) {
+			ath10k_warn(ar, "failed to clean nlo settings on vdev %i: %d\n",
+				    arvif->vdev_id, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int ath10k_wow_enable(struct ath10k *ar)
 {
 	int ret;
@@ -434,6 +593,10 @@ int ath10k_wow_op_resume(struct ieee80211_hw *hw)
 	if (ret)
 		ath10k_warn(ar, "failed to wakeup from wow: %d\n", ret);
 
+	ret = ath10k_wow_nlo_cleanup(ar);
+	if (ret)
+		ath10k_warn(ar, "failed to cleanup nlo: %d\n", ret);
+
 exit:
 	if (ret) {
 		switch (ar->state) {
@@ -473,6 +636,11 @@ int ath10k_wow_init(struct ath10k *ar)
 		ar->wow.wowlan_support.max_pkt_offset -= WOW_MAX_REDUCE;
 	}
 
+	if (test_bit(WMI_SERVICE_NLO, ar->wmi.svc_map)) {
+		ar->wow.wowlan_support.flags |= WIPHY_WOWLAN_NET_DETECT;
+		ar->wow.wowlan_support.max_nd_match_sets = WMI_PNO_MAX_SUPP_NETWORKS;
+	}
+
 	ar->wow.wowlan_support.n_patterns = ar->wow.max_num_patterns;
 	ar->hw->wiphy->wowlan = &ar->wow.wowlan_support;
 
-- 
1.9.1

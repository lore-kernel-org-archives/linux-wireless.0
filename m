Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:55912 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab3IYJia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 05:38:30 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 11/13] ath10k: introduce dynamic vdev parameters
Date: Wed, 25 Sep 2013 11:38:09 +0200
Message-ID: <1380101891-18312-12-git-send-email-bartosz.markowski@tieto.com> (sfid-20130925_113839_221895_60D6D644)
In-Reply-To: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both firmwares (main and 10.x) have different set of vdev
parameters. To stay in sync with FW API, this patch introduces
a dynamic registering method.

ath10k_wmi_vdev_set_param() takes now indirect u32 value
to identify the Vdev parameter it want's to set.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    1 +
 drivers/net/wireless/ath/ath10k/mac.c  |   55 +++++-----
 drivers/net/wireless/ath/ath10k/wmi.c  |  136 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h  |  172 +++++++++++++++++++++++++++++++-
 4 files changed, 339 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 377560d..c9ad626 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -117,6 +117,7 @@ struct ath10k_wmi {
 	struct completion unified_ready;
 	wait_queue_head_t tx_credits_wq;
 	struct wmi_cmd_map *cmd;
+	struct wmi_vdev_param_map *vdev_param;
 
 	u32 num_mem_chunks;
 	struct ath10k_mem_chunk mem_chunks[ATH10K_MAX_MEM_REQS];
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 18fae5e..ea11a03 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -334,25 +334,29 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 
 static int  ath10k_mac_set_rts(struct ath10k_vif *arvif, u32 value)
 {
+	struct ath10k *ar = arvif->ar;
+	u32 vdev_param;
+
 	if (value != 0xFFFFFFFF)
 		value = min_t(u32, arvif->ar->hw->wiphy->rts_threshold,
 			      ATH10K_RTS_MAX);
 
-	return ath10k_wmi_vdev_set_param(arvif->ar, arvif->vdev_id,
-					 WMI_VDEV_PARAM_RTS_THRESHOLD,
-					 value);
+	vdev_param = ar->wmi.vdev_param->wmi_vdev_param_rts_threshold;
+	return ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param, value);
 }
 
 static int ath10k_mac_set_frag(struct ath10k_vif *arvif, u32 value)
 {
+	struct ath10k *ar = arvif->ar;
+	u32 vdev_param;
+
 	if (value != 0xFFFFFFFF)
 		value = clamp_t(u32, arvif->ar->hw->wiphy->frag_threshold,
 				ATH10K_FRAGMT_THRESHOLD_MIN,
 				ATH10K_FRAGMT_THRESHOLD_MAX);
 
-	return ath10k_wmi_vdev_set_param(arvif->ar, arvif->vdev_id,
-					 WMI_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
-					 value);
+	vdev_param = ar->wmi.vdev_param->wmi_vdev_param_fragmentation_threshold;
+	return ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param, value);
 }
 
 static int ath10k_peer_delete(struct ath10k *ar, u32 vdev_id, const u8 *addr)
@@ -677,6 +681,7 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 				struct ieee80211_bss_conf *info,
 				const u8 self_peer[ETH_ALEN])
 {
+	u32 vdev_param;
 	int ret = 0;
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
@@ -710,8 +715,8 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 		return;
 	}
 
-	ret = ath10k_wmi_vdev_set_param(arvif->ar, arvif->vdev_id,
-					WMI_VDEV_PARAM_ATIM_WINDOW,
+	vdev_param = arvif->ar->wmi.vdev_param->wmi_vdev_param_atim_window;
+	ret = ath10k_wmi_vdev_set_param(arvif->ar, arvif->vdev_id, vdev_param,
 					ATH10K_DEFAULT_ATIM);
 	if (ret)
 		ath10k_warn("Failed to set IBSS ATIM for VDEV:%d ret:%d\n",
@@ -1433,6 +1438,7 @@ static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
 	struct ath10k *ar = arvif->ar;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_key_conf *key = info->control.hw_key;
+	u32 vdev_param;
 	int ret;
 
 	if (!ieee80211_has_protected(hdr->frame_control))
@@ -1451,8 +1457,8 @@ static void ath10k_tx_h_update_wep_key(struct sk_buff *skb)
 	ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d keyidx %d\n",
 		   arvif->vdev_id, key->keyidx);
 
-	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
-					WMI_VDEV_PARAM_DEF_KEYID,
+	vdev_param = ar->wmi.vdev_param->wmi_vdev_param_def_keyid;
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 					key->keyidx);
 	if (ret) {
 		ath10k_warn("could not update wep keyidx (%d)\n", ret);
@@ -1943,6 +1949,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	int ret = 0;
 	u32 value;
 	int bit;
+	u32 vdev_param;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -2004,13 +2011,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		goto exit;
 	}
 
-	ret = ath10k_wmi_vdev_set_param(ar, 0, WMI_VDEV_PARAM_DEF_KEYID,
+	vdev_param = ar->wmi.vdev_param->wmi_vdev_param_def_keyid;
+	ret = ath10k_wmi_vdev_set_param(ar, 0, vdev_param,
 					arvif->def_wep_key_index);
 	if (ret)
 		ath10k_warn("Failed to set default keyid: %d\n", ret);
 
-	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
-					WMI_VDEV_PARAM_TX_ENCAP_TYPE,
+	vdev_param = ar->wmi.vdev_param->wmi_vdev_param_tx_encap_type;
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 					ATH10K_HW_TXRX_NATIVE_WIFI);
 	if (ret)
 		ath10k_warn("Failed to set TX encap: %d\n", ret);
@@ -2161,6 +2169,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	int ret = 0;
+	u32 vdev_param;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -2169,8 +2178,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		arvif->beacon_interval = info->beacon_int;
-		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
-						WMI_VDEV_PARAM_BEACON_INTERVAL,
+		vdev_param = ar->wmi.vdev_param->wmi_vdev_param_beacon_interval;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						arvif->beacon_interval);
 		ath10k_dbg(ATH10K_DBG_MAC,
 			   "mac vdev %d beacon_interval %d\n",
@@ -2201,8 +2210,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			   "mac vdev %d dtim_period %d\n",
 			   arvif->vdev_id, arvif->dtim_period);
 
-		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
-						WMI_VDEV_PARAM_DTIM_PERIOD,
+		vdev_param = ar->wmi.vdev_param->wmi_vdev_param_dtim_period;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						arvif->dtim_period);
 		if (ret)
 			ath10k_warn("Failed to set dtim period for VDEV: %d\n",
@@ -2269,8 +2278,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d cts_prot %d\n",
 			   arvif->vdev_id, cts_prot);
 
-		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
-						WMI_VDEV_PARAM_ENABLE_RTSCTS,
+		vdev_param = ar->wmi.vdev_param->wmi_vdev_param_enable_rtscts;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						cts_prot);
 		if (ret)
 			ath10k_warn("Failed to set CTS prot for VDEV: %d\n",
@@ -2288,8 +2297,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		ath10k_dbg(ATH10K_DBG_MAC, "mac vdev %d slot_time %d\n",
 			   arvif->vdev_id, slottime);
 
-		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
-						WMI_VDEV_PARAM_SLOT_TIME,
+		vdev_param = ar->wmi.vdev_param->wmi_vdev_param_slot_time;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						slottime);
 		if (ret)
 			ath10k_warn("Failed to set erp slot for VDEV: %d\n",
@@ -2307,8 +2316,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 			   "mac vdev %d preamble %dn",
 			   arvif->vdev_id, preamble);
 
-		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
-						WMI_VDEV_PARAM_PREAMBLE,
+		vdev_param = ar->wmi.vdev_param->wmi_vdev_param_preamble;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
 						preamble);
 		if (ret)
 			ath10k_warn("Failed to set preamble for VDEV: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f0e1ea9..44ed523 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -274,6 +274,131 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.wmi_gpio_output_cmdid = WMI_10X_GPIO_OUTPUT_CMDID,
 };
 
+/* MAIN WMI VDEV param map */
+static struct wmi_vdev_param_map wmi_vdev_param_map = {
+	.wmi_vdev_param_rts_threshold = WMI_VDEV_PARAM_RTS_THRESHOLD,
+	.wmi_vdev_param_fragmentation_threshold =
+				WMI_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
+	.wmi_vdev_param_beacon_interval = WMI_VDEV_PARAM_BEACON_INTERVAL,
+	.wmi_vdev_param_listen_interval = WMI_VDEV_PARAM_LISTEN_INTERVAL,
+	.wmi_vdev_param_multicast_rate = WMI_VDEV_PARAM_MULTICAST_RATE,
+	.wmi_vdev_param_mgmt_tx_rate = WMI_VDEV_PARAM_MGMT_TX_RATE,
+	.wmi_vdev_param_slot_time = WMI_VDEV_PARAM_SLOT_TIME,
+	.wmi_vdev_param_preamble = WMI_VDEV_PARAM_PREAMBLE,
+	.wmi_vdev_param_swba_time = WMI_VDEV_PARAM_SWBA_TIME,
+	.wmi_vdev_stats_update_period = WMI_VDEV_STATS_UPDATE_PERIOD,
+	.wmi_vdev_pwrsave_ageout_time = WMI_VDEV_PWRSAVE_AGEOUT_TIME,
+	.wmi_vdev_host_swba_interval = WMI_VDEV_HOST_SWBA_INTERVAL,
+	.wmi_vdev_param_dtim_period = WMI_VDEV_PARAM_DTIM_PERIOD,
+	.wmi_vdev_oc_scheduler_air_time_limit =
+					WMI_VDEV_OC_SCHEDULER_AIR_TIME_LIMIT,
+	.wmi_vdev_param_wds = WMI_VDEV_PARAM_WDS,
+	.wmi_vdev_param_atim_window = WMI_VDEV_PARAM_ATIM_WINDOW,
+	.wmi_vdev_param_bmiss_count_max = WMI_VDEV_PARAM_BMISS_COUNT_MAX,
+	.wmi_vdev_param_bmiss_first_bcnt = WMI_VDEV_PARAM_BMISS_FIRST_BCNT,
+	.wmi_vdev_param_bmiss_final_bcnt = WMI_VDEV_PARAM_BMISS_FINAL_BCNT,
+	.wmi_vdev_param_feature_wmm = WMI_VDEV_PARAM_FEATURE_WMM,
+	.wmi_vdev_param_chwidth = WMI_VDEV_PARAM_CHWIDTH,
+	.wmi_vdev_param_chextoffset = WMI_VDEV_PARAM_CHEXTOFFSET,
+	.wmi_vdev_param_disable_htprotection =
+					WMI_VDEV_PARAM_DISABLE_HTPROTECTION,
+	.wmi_vdev_param_sta_quickkickout = WMI_VDEV_PARAM_DISABLE_HTPROTECTION,
+	.wmi_vdev_param_mgmt_rate = WMI_VDEV_PARAM_MGMT_RATE,
+	.wmi_vdev_param_protection_mode = WMI_VDEV_PARAM_PROTECTION_MODE,
+	.wmi_vdev_param_fixed_rate = WMI_VDEV_PARAM_FIXED_RATE,
+	.wmi_vdev_param_sgi = WMI_VDEV_PARAM_SGI,
+	.wmi_vdev_param_ldpc = WMI_VDEV_PARAM_LDPC,
+	.wmi_vdev_param_tx_stbc = WMI_VDEV_PARAM_TX_STBC,
+	.wmi_vdev_param_rx_stbc = WMI_VDEV_PARAM_RX_STBC,
+	.wmi_vdev_param_intra_bss_fwd = WMI_VDEV_PARAM_INTRA_BSS_FWD,
+	.wmi_vdev_param_def_keyid = WMI_VDEV_PARAM_DEF_KEYID,
+	.wmi_vdev_param_nss = WMI_VDEV_PARAM_NSS,
+	.wmi_vdev_param_bcast_data_rate = WMI_VDEV_PARAM_BCAST_DATA_RATE,
+	.wmi_vdev_param_mcast_data_rate = WMI_VDEV_PARAM_MCAST_DATA_RATE,
+	.wmi_vdev_param_mcast_indicate = WMI_VDEV_PARAM_MCAST_INDICATE,
+	.wmi_vdev_param_dhcp_indicate = WMI_VDEV_PARAM_DHCP_INDICATE,
+	.wmi_vdev_param_unknown_dest_indicate =
+			WMI_VDEV_PARAM_UNKNOWN_DEST_INDICATE,
+	.wmi_vdev_param_ap_keepalive_min_idle_inactive_time_secs =
+			WMI_VDEV_PARAM_AP_KEEPALIVE_MIN_IDLE_INACTIVE_TIME_SECS,
+	.wmi_vdev_param_ap_keepalive_max_idle_inactive_time_secs =
+			WMI_VDEV_PARAM_AP_KEEPALIVE_MAX_IDLE_INACTIVE_TIME_SECS,
+	.wmi_vdev_param_ap_keepalive_max_unresponsive_time_secs =
+			WMI_VDEV_PARAM_AP_KEEPALIVE_MAX_UNRESPONSIVE_TIME_SECS,
+	.wmi_vdev_param_ap_enable_nawds = WMI_VDEV_PARAM_AP_ENABLE_NAWDS,
+	.wmi_vdev_param_mcast2ucast_set = WMI_VDEV_PARAM_UNSUPPORTED,
+	.wmi_vdev_param_enable_rtscts = WMI_VDEV_PARAM_ENABLE_RTSCTS,
+	.wmi_vdev_param_txbf = WMI_VDEV_PARAM_TXBF,
+	.wmi_vdev_param_packet_powersave = WMI_VDEV_PARAM_PACKET_POWERSAVE,
+	.wmi_vdev_param_drop_unencry = WMI_VDEV_PARAM_DROP_UNENCRY,
+	.wmi_vdev_param_tx_encap_type = WMI_VDEV_PARAM_TX_ENCAP_TYPE,
+	.wmi_vdev_param_ap_detect_out_of_sync_sleeping_sta_time_secs =
+		WMI_VDEV_PARAM_UNSUPPORTED,
+};
+
+/* 10.X WMI VDEV param map */
+static struct wmi_vdev_param_map wmi_10x_vdev_param_map = {
+	.wmi_vdev_param_rts_threshold = WMI_10X_VDEV_PARAM_RTS_THRESHOLD,
+	.wmi_vdev_param_fragmentation_threshold =
+				WMI_10X_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
+	.wmi_vdev_param_beacon_interval = WMI_10X_VDEV_PARAM_BEACON_INTERVAL,
+	.wmi_vdev_param_listen_interval = WMI_10X_VDEV_PARAM_LISTEN_INTERVAL,
+	.wmi_vdev_param_multicast_rate = WMI_10X_VDEV_PARAM_MULTICAST_RATE,
+	.wmi_vdev_param_mgmt_tx_rate = WMI_10X_VDEV_PARAM_MGMT_TX_RATE,
+	.wmi_vdev_param_slot_time = WMI_10X_VDEV_PARAM_SLOT_TIME,
+	.wmi_vdev_param_preamble = WMI_10X_VDEV_PARAM_PREAMBLE,
+	.wmi_vdev_param_swba_time = WMI_10X_VDEV_PARAM_SWBA_TIME,
+	.wmi_vdev_stats_update_period = WMI_10X_VDEV_STATS_UPDATE_PERIOD,
+	.wmi_vdev_pwrsave_ageout_time = WMI_10X_VDEV_PWRSAVE_AGEOUT_TIME,
+	.wmi_vdev_host_swba_interval = WMI_10X_VDEV_HOST_SWBA_INTERVAL,
+	.wmi_vdev_param_dtim_period = WMI_10X_VDEV_PARAM_DTIM_PERIOD,
+	.wmi_vdev_oc_scheduler_air_time_limit =
+				WMI_10X_VDEV_OC_SCHEDULER_AIR_TIME_LIMIT,
+	.wmi_vdev_param_wds = WMI_10X_VDEV_PARAM_WDS,
+	.wmi_vdev_param_atim_window = WMI_10X_VDEV_PARAM_ATIM_WINDOW,
+	.wmi_vdev_param_bmiss_count_max = WMI_10X_VDEV_PARAM_BMISS_COUNT_MAX,
+	.wmi_vdev_param_bmiss_first_bcnt = WMI_VDEV_PARAM_UNSUPPORTED,
+	.wmi_vdev_param_bmiss_final_bcnt = WMI_VDEV_PARAM_UNSUPPORTED,
+	.wmi_vdev_param_feature_wmm = WMI_10X_VDEV_PARAM_FEATURE_WMM,
+	.wmi_vdev_param_chwidth = WMI_10X_VDEV_PARAM_CHWIDTH,
+	.wmi_vdev_param_chextoffset = WMI_10X_VDEV_PARAM_CHEXTOFFSET,
+	.wmi_vdev_param_disable_htprotection =
+					WMI_10X_VDEV_PARAM_DISABLE_HTPROTECTION,
+	.wmi_vdev_param_sta_quickkickout =
+					WMI_10X_VDEV_PARAM_DISABLE_HTPROTECTION,
+	.wmi_vdev_param_mgmt_rate = WMI_10X_VDEV_PARAM_MGMT_RATE,
+	.wmi_vdev_param_protection_mode = WMI_10X_VDEV_PARAM_PROTECTION_MODE,
+	.wmi_vdev_param_fixed_rate = WMI_10X_VDEV_PARAM_FIXED_RATE,
+	.wmi_vdev_param_sgi = WMI_10X_VDEV_PARAM_SGI,
+	.wmi_vdev_param_ldpc = WMI_10X_VDEV_PARAM_LDPC,
+	.wmi_vdev_param_tx_stbc = WMI_10X_VDEV_PARAM_TX_STBC,
+	.wmi_vdev_param_rx_stbc = WMI_10X_VDEV_PARAM_RX_STBC,
+	.wmi_vdev_param_intra_bss_fwd = WMI_10X_VDEV_PARAM_INTRA_BSS_FWD,
+	.wmi_vdev_param_def_keyid = WMI_10X_VDEV_PARAM_DEF_KEYID,
+	.wmi_vdev_param_nss = WMI_10X_VDEV_PARAM_NSS,
+	.wmi_vdev_param_bcast_data_rate = WMI_10X_VDEV_PARAM_BCAST_DATA_RATE,
+	.wmi_vdev_param_mcast_data_rate = WMI_10X_VDEV_PARAM_MCAST_DATA_RATE,
+	.wmi_vdev_param_mcast_indicate = WMI_10X_VDEV_PARAM_MCAST_INDICATE,
+	.wmi_vdev_param_dhcp_indicate = WMI_10X_VDEV_PARAM_DHCP_INDICATE,
+	.wmi_vdev_param_unknown_dest_indicate =
+			WMI_10X_VDEV_PARAM_UNKNOWN_DEST_INDICATE,
+	.wmi_vdev_param_ap_keepalive_min_idle_inactive_time_secs =
+		WMI_10X_VDEV_PARAM_AP_KEEPALIVE_MIN_IDLE_INACTIVE_TIME_SECS,
+	.wmi_vdev_param_ap_keepalive_max_idle_inactive_time_secs =
+		WMI_10X_VDEV_PARAM_AP_KEEPALIVE_MAX_IDLE_INACTIVE_TIME_SECS,
+	.wmi_vdev_param_ap_keepalive_max_unresponsive_time_secs =
+		WMI_10X_VDEV_PARAM_AP_KEEPALIVE_MAX_UNRESPONSIVE_TIME_SECS,
+	.wmi_vdev_param_ap_enable_nawds = WMI_10X_VDEV_PARAM_AP_ENABLE_NAWDS,
+	.wmi_vdev_param_mcast2ucast_set = WMI_10X_VDEV_PARAM_MCAST2UCAST_SET,
+	.wmi_vdev_param_enable_rtscts = WMI_10X_VDEV_PARAM_ENABLE_RTSCTS,
+	.wmi_vdev_param_txbf = WMI_VDEV_PARAM_UNSUPPORTED,
+	.wmi_vdev_param_packet_powersave = WMI_VDEV_PARAM_UNSUPPORTED,
+	.wmi_vdev_param_drop_unencry = WMI_VDEV_PARAM_UNSUPPORTED,
+	.wmi_vdev_param_tx_encap_type = WMI_VDEV_PARAM_UNSUPPORTED,
+	.wmi_vdev_param_ap_detect_out_of_sync_sleeping_sta_time_secs =
+		WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
+};
+
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
 	int ret;
@@ -1760,9 +1885,11 @@ int ath10k_wmi_attach(struct ath10k *ar)
 	if (test_bit(ATH10K_FW_FEATURE_10X, ar->fw_features)) {
 		ath10k_warn("Firmware 10.X is not yet supported\n");
 		ar->wmi.cmd = &wmi_10x_cmd_map;
+		ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
 		ret = -ENOTSUPP;
 	} else {
 		ar->wmi.cmd = &wmi_cmd_map;
+		ar->wmi.vdev_param = &wmi_vdev_param_map;
 		ret = 0;
 	}
 
@@ -2520,11 +2647,18 @@ int ath10k_wmi_vdev_down(struct ath10k *ar, u32 vdev_id)
 }
 
 int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
-			      enum wmi_vdev_param param_id, u32 param_value)
+			      u32 param_id, u32 param_value)
 {
 	struct wmi_vdev_set_param_cmd *cmd;
 	struct sk_buff *skb;
 
+	if (param_id == WMI_VDEV_PARAM_UNSUPPORTED) {
+		ath10k_dbg(ATH10K_DBG_WMI,
+			   "vdev param %d not supported by firmware\n",
+			    param_id);
+		return -EINVAL;
+	}
+
 	skb = ath10k_wmi_alloc_skb(sizeof(*cmd));
 	if (!skb)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 2f18349..fbff5cb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2695,6 +2695,61 @@ enum wmi_rate_preamble {
 /* Value to disable fixed rate setting */
 #define WMI_FIXED_RATE_NONE    (0xff)
 
+struct wmi_vdev_param_map {
+	u32 wmi_vdev_param_rts_threshold;
+	u32 wmi_vdev_param_fragmentation_threshold;
+	u32 wmi_vdev_param_beacon_interval;
+	u32 wmi_vdev_param_listen_interval;
+	u32 wmi_vdev_param_multicast_rate;
+	u32 wmi_vdev_param_mgmt_tx_rate;
+	u32 wmi_vdev_param_slot_time;
+	u32 wmi_vdev_param_preamble;
+	u32 wmi_vdev_param_swba_time;
+	u32 wmi_vdev_stats_update_period;
+	u32 wmi_vdev_pwrsave_ageout_time;
+	u32 wmi_vdev_host_swba_interval;
+	u32 wmi_vdev_param_dtim_period;
+	u32 wmi_vdev_oc_scheduler_air_time_limit;
+	u32 wmi_vdev_param_wds;
+	u32 wmi_vdev_param_atim_window;
+	u32 wmi_vdev_param_bmiss_count_max;
+	u32 wmi_vdev_param_bmiss_first_bcnt;
+	u32 wmi_vdev_param_bmiss_final_bcnt;
+	u32 wmi_vdev_param_feature_wmm;
+	u32 wmi_vdev_param_chwidth;
+	u32 wmi_vdev_param_chextoffset;
+	u32 wmi_vdev_param_disable_htprotection;
+	u32 wmi_vdev_param_sta_quickkickout;
+	u32 wmi_vdev_param_mgmt_rate;
+	u32 wmi_vdev_param_protection_mode;
+	u32 wmi_vdev_param_fixed_rate;
+	u32 wmi_vdev_param_sgi;
+	u32 wmi_vdev_param_ldpc;
+	u32 wmi_vdev_param_tx_stbc;
+	u32 wmi_vdev_param_rx_stbc;
+	u32 wmi_vdev_param_intra_bss_fwd;
+	u32 wmi_vdev_param_def_keyid;
+	u32 wmi_vdev_param_nss;
+	u32 wmi_vdev_param_bcast_data_rate;
+	u32 wmi_vdev_param_mcast_data_rate;
+	u32 wmi_vdev_param_mcast_indicate;
+	u32 wmi_vdev_param_dhcp_indicate;
+	u32 wmi_vdev_param_unknown_dest_indicate;
+	u32 wmi_vdev_param_ap_keepalive_min_idle_inactive_time_secs;
+	u32 wmi_vdev_param_ap_keepalive_max_idle_inactive_time_secs;
+	u32 wmi_vdev_param_ap_keepalive_max_unresponsive_time_secs;
+	u32 wmi_vdev_param_ap_enable_nawds;
+	u32 wmi_vdev_param_mcast2ucast_set;
+	u32 wmi_vdev_param_enable_rtscts;
+	u32 wmi_vdev_param_txbf;
+	u32 wmi_vdev_param_packet_powersave;
+	u32 wmi_vdev_param_drop_unencry;
+	u32 wmi_vdev_param_tx_encap_type;
+	u32 wmi_vdev_param_ap_detect_out_of_sync_sleeping_sta_time_secs;
+};
+
+#define WMI_VDEV_PARAM_UNSUPPORTED 0
+
 /* the definition of different VDEV parameters */
 enum wmi_vdev_param {
 	/* RTS Threshold */
@@ -2826,6 +2881,121 @@ enum wmi_vdev_param {
 	WMI_VDEV_PARAM_TX_ENCAP_TYPE,
 };
 
+/* the definition of different VDEV parameters */
+enum wmi_10x_vdev_param {
+	/* RTS Threshold */
+	WMI_10X_VDEV_PARAM_RTS_THRESHOLD = 0x1,
+	/* Fragmentation threshold */
+	WMI_10X_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
+	/* beacon interval in TUs */
+	WMI_10X_VDEV_PARAM_BEACON_INTERVAL,
+	/* Listen interval in TUs */
+	WMI_10X_VDEV_PARAM_LISTEN_INTERVAL,
+	/* muticast rate in Mbps */
+	WMI_10X_VDEV_PARAM_MULTICAST_RATE,
+	/* management frame rate in Mbps */
+	WMI_10X_VDEV_PARAM_MGMT_TX_RATE,
+	/* slot time (long vs short) */
+	WMI_10X_VDEV_PARAM_SLOT_TIME,
+	/* preamble (long vs short) */
+	WMI_10X_VDEV_PARAM_PREAMBLE,
+	/* SWBA time (time before tbtt in msec) */
+	WMI_10X_VDEV_PARAM_SWBA_TIME,
+	/* time period for updating VDEV stats */
+	WMI_10X_VDEV_STATS_UPDATE_PERIOD,
+	/* age out time in msec for frames queued for station in power save */
+	WMI_10X_VDEV_PWRSAVE_AGEOUT_TIME,
+	/*
+	 * Host SWBA interval (time in msec before tbtt for SWBA event
+	 * generation).
+	 */
+	WMI_10X_VDEV_HOST_SWBA_INTERVAL,
+	/* DTIM period (specified in units of num beacon intervals) */
+	WMI_10X_VDEV_PARAM_DTIM_PERIOD,
+	/*
+	 * scheduler air time limit for this VDEV. used by off chan
+	 * scheduler.
+	 */
+	WMI_10X_VDEV_OC_SCHEDULER_AIR_TIME_LIMIT,
+	/* enable/dsiable WDS for this VDEV  */
+	WMI_10X_VDEV_PARAM_WDS,
+	/* ATIM Window */
+	WMI_10X_VDEV_PARAM_ATIM_WINDOW,
+	/* BMISS max */
+	WMI_10X_VDEV_PARAM_BMISS_COUNT_MAX,
+	/* WMM enables/disabled */
+	WMI_10X_VDEV_PARAM_FEATURE_WMM,
+	/* Channel width */
+	WMI_10X_VDEV_PARAM_CHWIDTH,
+	/* Channel Offset */
+	WMI_10X_VDEV_PARAM_CHEXTOFFSET,
+	/* Disable HT Protection */
+	WMI_10X_VDEV_PARAM_DISABLE_HTPROTECTION,
+	/* Quick STA Kickout */
+	WMI_10X_VDEV_PARAM_STA_QUICKKICKOUT,
+	/* Rate to be used with Management frames */
+	WMI_10X_VDEV_PARAM_MGMT_RATE,
+	/* Protection Mode */
+	WMI_10X_VDEV_PARAM_PROTECTION_MODE,
+	/* Fixed rate setting */
+	WMI_10X_VDEV_PARAM_FIXED_RATE,
+	/* Short GI Enable/Disable */
+	WMI_10X_VDEV_PARAM_SGI,
+	/* Enable LDPC */
+	WMI_10X_VDEV_PARAM_LDPC,
+	/* Enable Tx STBC */
+	WMI_10X_VDEV_PARAM_TX_STBC,
+	/* Enable Rx STBC */
+	WMI_10X_VDEV_PARAM_RX_STBC,
+	/* Intra BSS forwarding  */
+	WMI_10X_VDEV_PARAM_INTRA_BSS_FWD,
+	/* Setting Default xmit key for Vdev */
+	WMI_10X_VDEV_PARAM_DEF_KEYID,
+	/* NSS width */
+	WMI_10X_VDEV_PARAM_NSS,
+	/* Set the custom rate for the broadcast data frames */
+	WMI_10X_VDEV_PARAM_BCAST_DATA_RATE,
+	/* Set the custom rate (rate-code) for multicast data frames */
+	WMI_10X_VDEV_PARAM_MCAST_DATA_RATE,
+	/* Tx multicast packet indicate Enable/Disable */
+	WMI_10X_VDEV_PARAM_MCAST_INDICATE,
+	/* Tx DHCP packet indicate Enable/Disable */
+	WMI_10X_VDEV_PARAM_DHCP_INDICATE,
+	/* Enable host inspection of Tx unicast packet to unknown destination */
+	WMI_10X_VDEV_PARAM_UNKNOWN_DEST_INDICATE,
+
+	/* The minimum amount of time AP begins to consider STA inactive */
+	WMI_10X_VDEV_PARAM_AP_KEEPALIVE_MIN_IDLE_INACTIVE_TIME_SECS,
+
+	/*
+	 * An associated STA is considered inactive when there is no recent
+	 * TX/RX activity and no downlink frames are buffered for it. Once a
+	 * STA exceeds the maximum idle inactive time, the AP will send an
+	 * 802.11 data-null as a keep alive to verify the STA is still
+	 * associated. If the STA does ACK the data-null, or if the data-null
+	 * is buffered and the STA does not retrieve it, the STA will be
+	 * considered unresponsive
+	 * (see WMI_10X_VDEV_AP_KEEPALIVE_MAX_UNRESPONSIVE_TIME_SECS).
+	 */
+	WMI_10X_VDEV_PARAM_AP_KEEPALIVE_MAX_IDLE_INACTIVE_TIME_SECS,
+
+	/*
+	 * An associated STA is considered unresponsive if there is no recent
+	 * TX/RX activity and downlink frames are buffered for it. Once a STA
+	 * exceeds the maximum unresponsive time, the AP will send a
+	 * WMI_10X_STA_KICKOUT event to the host so the STA can be deleted. */
+	WMI_10X_VDEV_PARAM_AP_KEEPALIVE_MAX_UNRESPONSIVE_TIME_SECS,
+
+	/* Enable NAWDS : MCAST INSPECT Enable, NAWDS Flag set */
+	WMI_10X_VDEV_PARAM_AP_ENABLE_NAWDS,
+
+	WMI_10X_VDEV_PARAM_MCAST2UCAST_SET,
+	/* Enable/Disable RTS-CTS */
+	WMI_10X_VDEV_PARAM_ENABLE_RTSCTS,
+
+	WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
+};
+
 /* slot time long */
 #define WMI_VDEV_SLOT_TIME_LONG		0x1
 /* slot time short */
@@ -3649,7 +3819,7 @@ int ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid,
 		       const u8 *bssid);
 int ath10k_wmi_vdev_down(struct ath10k *ar, u32 vdev_id);
 int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
-			      enum wmi_vdev_param param_id, u32 param_value);
+			      u32 param_id, u32 param_value);
 int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 				const struct wmi_vdev_install_key_arg *arg);
 int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
-- 
1.7.10


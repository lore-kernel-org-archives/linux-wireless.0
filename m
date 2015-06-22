Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57002 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbbFVOmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:42:05 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 05/10] ath10k: add 10.4 fw wmi vdev cmd ids
Date: Mon, 22 Jun 2015 20:10:13 +0530
Message-ID: <1434984018-24057-6-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_164209_123215_F234B44F)
In-Reply-To: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Include 10.4 firmware wmi vdev cmd id and make up wmi vdev map
table wmi_10_4_vdev_param_map and also update non 10.4 firmware
vdev cmd map table with newly added vdev cmd id specifically for
10.4 firmware as unsupported.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
v2 changes:
 - udpated vdev cmd id table based on stable 10.4 firmware.

 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  16 ++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 124 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  85 ++++++++++++++++++++
 3 files changed, 225 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 7e75dec..b2a8e32 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3294,6 +3294,22 @@ static struct wmi_vdev_param_map wmi_tlv_vdev_param_map = {
 	.tx_encap_type = WMI_TLV_VDEV_PARAM_TX_ENCAP_TYPE,
 	.ap_detect_out_of_sync_sleeping_sta_time_secs =
 					WMI_TLV_VDEV_PARAM_UNSUPPORTED,
+	.rc_num_retries = WMI_VDEV_PARAM_UNSUPPORTED,
+	.cabq_maxdur = WMI_VDEV_PARAM_UNSUPPORTED,
+	.mfptest_set = WMI_VDEV_PARAM_UNSUPPORTED,
+	.rts_fixed_rate = WMI_VDEV_PARAM_UNSUPPORTED,
+	.vht_sgimask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.vht80_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_adjust_enable = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_tgt_bmiss_num = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_bmiss_sample_cycle = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_slop_step = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_init_slop = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_adjust_pause = WMI_VDEV_PARAM_UNSUPPORTED,
+	.proxy_sta = WMI_VDEV_PARAM_UNSUPPORTED,
+	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
+	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
+	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
 };
 
 static const struct wmi_ops wmi_tlv_ops = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index a58ddb7..087dea8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -761,6 +761,22 @@ static struct wmi_vdev_param_map wmi_vdev_param_map = {
 	.tx_encap_type = WMI_VDEV_PARAM_TX_ENCAP_TYPE,
 	.ap_detect_out_of_sync_sleeping_sta_time_secs =
 					WMI_VDEV_PARAM_UNSUPPORTED,
+	.rc_num_retries = WMI_VDEV_PARAM_UNSUPPORTED,
+	.cabq_maxdur = WMI_VDEV_PARAM_UNSUPPORTED,
+	.mfptest_set = WMI_VDEV_PARAM_UNSUPPORTED,
+	.rts_fixed_rate = WMI_VDEV_PARAM_UNSUPPORTED,
+	.vht_sgimask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.vht80_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_adjust_enable = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_tgt_bmiss_num = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_bmiss_sample_cycle = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_slop_step = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_init_slop = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_adjust_pause = WMI_VDEV_PARAM_UNSUPPORTED,
+	.proxy_sta = WMI_VDEV_PARAM_UNSUPPORTED,
+	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
+	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
+	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
 };
 
 /* 10.X WMI VDEV param map */
@@ -820,6 +836,22 @@ static struct wmi_vdev_param_map wmi_10x_vdev_param_map = {
 	.tx_encap_type = WMI_VDEV_PARAM_UNSUPPORTED,
 	.ap_detect_out_of_sync_sleeping_sta_time_secs =
 		WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
+	.rc_num_retries = WMI_VDEV_PARAM_UNSUPPORTED,
+	.cabq_maxdur = WMI_VDEV_PARAM_UNSUPPORTED,
+	.mfptest_set = WMI_VDEV_PARAM_UNSUPPORTED,
+	.rts_fixed_rate = WMI_VDEV_PARAM_UNSUPPORTED,
+	.vht_sgimask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.vht80_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_adjust_enable = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_tgt_bmiss_num = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_bmiss_sample_cycle = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_slop_step = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_init_slop = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_adjust_pause = WMI_VDEV_PARAM_UNSUPPORTED,
+	.proxy_sta = WMI_VDEV_PARAM_UNSUPPORTED,
+	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
+	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
+	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_vdev_param_map wmi_10_2_4_vdev_param_map = {
@@ -878,6 +910,97 @@ static struct wmi_vdev_param_map wmi_10_2_4_vdev_param_map = {
 	.tx_encap_type = WMI_VDEV_PARAM_UNSUPPORTED,
 	.ap_detect_out_of_sync_sleeping_sta_time_secs =
 		WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
+	.rc_num_retries = WMI_VDEV_PARAM_UNSUPPORTED,
+	.cabq_maxdur = WMI_VDEV_PARAM_UNSUPPORTED,
+	.mfptest_set = WMI_VDEV_PARAM_UNSUPPORTED,
+	.rts_fixed_rate = WMI_VDEV_PARAM_UNSUPPORTED,
+	.vht_sgimask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.vht80_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_adjust_enable = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_tgt_bmiss_num = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_bmiss_sample_cycle = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_slop_step = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_init_slop = WMI_VDEV_PARAM_UNSUPPORTED,
+	.early_rx_adjust_pause = WMI_VDEV_PARAM_UNSUPPORTED,
+	.proxy_sta = WMI_VDEV_PARAM_UNSUPPORTED,
+	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
+	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
+	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+};
+
+static struct wmi_vdev_param_map wmi_10_4_vdev_param_map = {
+	.rts_threshold = WMI_10_4_VDEV_PARAM_RTS_THRESHOLD,
+	.fragmentation_threshold = WMI_10_4_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
+	.beacon_interval = WMI_10_4_VDEV_PARAM_BEACON_INTERVAL,
+	.listen_interval = WMI_10_4_VDEV_PARAM_LISTEN_INTERVAL,
+	.multicast_rate = WMI_10_4_VDEV_PARAM_MULTICAST_RATE,
+	.mgmt_tx_rate = WMI_10_4_VDEV_PARAM_MGMT_TX_RATE,
+	.slot_time = WMI_10_4_VDEV_PARAM_SLOT_TIME,
+	.preamble = WMI_10_4_VDEV_PARAM_PREAMBLE,
+	.swba_time = WMI_10_4_VDEV_PARAM_SWBA_TIME,
+	.wmi_vdev_stats_update_period = WMI_10_4_VDEV_STATS_UPDATE_PERIOD,
+	.wmi_vdev_pwrsave_ageout_time = WMI_10_4_VDEV_PWRSAVE_AGEOUT_TIME,
+	.wmi_vdev_host_swba_interval = WMI_10_4_VDEV_HOST_SWBA_INTERVAL,
+	.dtim_period = WMI_10_4_VDEV_PARAM_DTIM_PERIOD,
+	.wmi_vdev_oc_scheduler_air_time_limit =
+	       WMI_10_4_VDEV_OC_SCHEDULER_AIR_TIME_LIMIT,
+	.wds = WMI_10_4_VDEV_PARAM_WDS,
+	.atim_window = WMI_10_4_VDEV_PARAM_ATIM_WINDOW,
+	.bmiss_count_max = WMI_10_4_VDEV_PARAM_BMISS_COUNT_MAX,
+	.bmiss_first_bcnt = WMI_10_4_VDEV_PARAM_BMISS_FIRST_BCNT,
+	.bmiss_final_bcnt = WMI_10_4_VDEV_PARAM_BMISS_FINAL_BCNT,
+	.feature_wmm = WMI_10_4_VDEV_PARAM_FEATURE_WMM,
+	.chwidth = WMI_10_4_VDEV_PARAM_CHWIDTH,
+	.chextoffset = WMI_10_4_VDEV_PARAM_CHEXTOFFSET,
+	.disable_htprotection = WMI_10_4_VDEV_PARAM_DISABLE_HTPROTECTION,
+	.sta_quickkickout = WMI_10_4_VDEV_PARAM_STA_QUICKKICKOUT,
+	.mgmt_rate = WMI_10_4_VDEV_PARAM_MGMT_RATE,
+	.protection_mode = WMI_10_4_VDEV_PARAM_PROTECTION_MODE,
+	.fixed_rate = WMI_10_4_VDEV_PARAM_FIXED_RATE,
+	.sgi = WMI_10_4_VDEV_PARAM_SGI,
+	.ldpc = WMI_10_4_VDEV_PARAM_LDPC,
+	.tx_stbc = WMI_10_4_VDEV_PARAM_TX_STBC,
+	.rx_stbc = WMI_10_4_VDEV_PARAM_RX_STBC,
+	.intra_bss_fwd = WMI_10_4_VDEV_PARAM_INTRA_BSS_FWD,
+	.def_keyid = WMI_10_4_VDEV_PARAM_DEF_KEYID,
+	.nss = WMI_10_4_VDEV_PARAM_NSS,
+	.bcast_data_rate = WMI_10_4_VDEV_PARAM_BCAST_DATA_RATE,
+	.mcast_data_rate = WMI_10_4_VDEV_PARAM_MCAST_DATA_RATE,
+	.mcast_indicate = WMI_10_4_VDEV_PARAM_MCAST_INDICATE,
+	.dhcp_indicate = WMI_10_4_VDEV_PARAM_DHCP_INDICATE,
+	.unknown_dest_indicate = WMI_10_4_VDEV_PARAM_UNKNOWN_DEST_INDICATE,
+	.ap_keepalive_min_idle_inactive_time_secs =
+	       WMI_10_4_VDEV_PARAM_AP_KEEPALIVE_MIN_IDLE_INACTIVE_TIME_SECS,
+	.ap_keepalive_max_idle_inactive_time_secs =
+	       WMI_10_4_VDEV_PARAM_AP_KEEPALIVE_MAX_IDLE_INACTIVE_TIME_SECS,
+	.ap_keepalive_max_unresponsive_time_secs =
+	       WMI_10_4_VDEV_PARAM_AP_KEEPALIVE_MAX_UNRESPONSIVE_TIME_SECS,
+	.ap_enable_nawds = WMI_10_4_VDEV_PARAM_AP_ENABLE_NAWDS,
+	.mcast2ucast_set = WMI_10_4_VDEV_PARAM_MCAST2UCAST_SET,
+	.enable_rtscts = WMI_10_4_VDEV_PARAM_ENABLE_RTSCTS,
+	.txbf = WMI_10_4_VDEV_PARAM_TXBF,
+	.packet_powersave = WMI_10_4_VDEV_PARAM_PACKET_POWERSAVE,
+	.drop_unencry = WMI_10_4_VDEV_PARAM_DROP_UNENCRY,
+	.tx_encap_type = WMI_10_4_VDEV_PARAM_TX_ENCAP_TYPE,
+	.ap_detect_out_of_sync_sleeping_sta_time_secs =
+	       WMI_10_4_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
+	.rc_num_retries = WMI_10_4_VDEV_PARAM_RC_NUM_RETRIES,
+	.cabq_maxdur = WMI_10_4_VDEV_PARAM_CABQ_MAXDUR,
+	.mfptest_set = WMI_10_4_VDEV_PARAM_MFPTEST_SET,
+	.rts_fixed_rate = WMI_10_4_VDEV_PARAM_RTS_FIXED_RATE,
+	.vht_sgimask = WMI_10_4_VDEV_PARAM_VHT_SGIMASK,
+	.vht80_ratemask = WMI_10_4_VDEV_PARAM_VHT80_RATEMASK,
+	.early_rx_adjust_enable = WMI_10_4_VDEV_PARAM_EARLY_RX_ADJUST_ENABLE,
+	.early_rx_tgt_bmiss_num = WMI_10_4_VDEV_PARAM_EARLY_RX_TGT_BMISS_NUM,
+	.early_rx_bmiss_sample_cycle =
+	       WMI_10_4_VDEV_PARAM_EARLY_RX_BMISS_SAMPLE_CYCLE,
+	.early_rx_slop_step = WMI_10_4_VDEV_PARAM_EARLY_RX_SLOP_STEP,
+	.early_rx_init_slop = WMI_10_4_VDEV_PARAM_EARLY_RX_INIT_SLOP,
+	.early_rx_adjust_pause = WMI_10_4_VDEV_PARAM_EARLY_RX_ADJUST_PAUSE,
+	.proxy_sta = WMI_10_4_VDEV_PARAM_PROXY_STA,
+	.meru_vc = WMI_10_4_VDEV_PARAM_MERU_VC,
+	.rx_decap_type = WMI_10_4_VDEV_PARAM_RX_DECAP_TYPE,
+	.bw_nss_ratemask = WMI_10_4_VDEV_PARAM_BW_NSS_RATEMASK,
 };
 
 static struct wmi_pdev_param_map wmi_pdev_param_map = {
@@ -5763,6 +5886,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 	case ATH10K_FW_WMI_OP_VERSION_10_4:
 		ar->wmi.ops = &wmi_10_4_ops;
 		ar->wmi.cmd = &wmi_10_4_cmd_map;
+		ar->wmi.vdev_param = &wmi_10_4_vdev_param_map;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		ar->wmi.cmd = &wmi_10_2_4_cmd_map;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index c3a05a9..ecc7288 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3904,6 +3904,22 @@ struct wmi_vdev_param_map {
 	u32 drop_unencry;
 	u32 tx_encap_type;
 	u32 ap_detect_out_of_sync_sleeping_sta_time_secs;
+	u32 rc_num_retries;
+	u32 cabq_maxdur;
+	u32 mfptest_set;
+	u32 rts_fixed_rate;
+	u32 vht_sgimask;
+	u32 vht80_ratemask;
+	u32 early_rx_adjust_enable;
+	u32 early_rx_tgt_bmiss_num;
+	u32 early_rx_bmiss_sample_cycle;
+	u32 early_rx_slop_step;
+	u32 early_rx_init_slop;
+	u32 early_rx_adjust_pause;
+	u32 proxy_sta;
+	u32 meru_vc;
+	u32 rx_decap_type;
+	u32 bw_nss_ratemask;
 };
 
 #define WMI_VDEV_PARAM_UNSUPPORTED 0
@@ -4162,6 +4178,75 @@ enum wmi_10x_vdev_param {
 	WMI_10X_VDEV_PARAM_VHT80_RATEMASK,
 };
 
+enum wmi_10_4_vdev_param {
+	WMI_10_4_VDEV_PARAM_RTS_THRESHOLD = 0x1,
+	WMI_10_4_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
+	WMI_10_4_VDEV_PARAM_BEACON_INTERVAL,
+	WMI_10_4_VDEV_PARAM_LISTEN_INTERVAL,
+	WMI_10_4_VDEV_PARAM_MULTICAST_RATE,
+	WMI_10_4_VDEV_PARAM_MGMT_TX_RATE,
+	WMI_10_4_VDEV_PARAM_SLOT_TIME,
+	WMI_10_4_VDEV_PARAM_PREAMBLE,
+	WMI_10_4_VDEV_PARAM_SWBA_TIME,
+	WMI_10_4_VDEV_STATS_UPDATE_PERIOD,
+	WMI_10_4_VDEV_PWRSAVE_AGEOUT_TIME,
+	WMI_10_4_VDEV_HOST_SWBA_INTERVAL,
+	WMI_10_4_VDEV_PARAM_DTIM_PERIOD,
+	WMI_10_4_VDEV_OC_SCHEDULER_AIR_TIME_LIMIT,
+	WMI_10_4_VDEV_PARAM_WDS,
+	WMI_10_4_VDEV_PARAM_ATIM_WINDOW,
+	WMI_10_4_VDEV_PARAM_BMISS_COUNT_MAX,
+	WMI_10_4_VDEV_PARAM_BMISS_FIRST_BCNT,
+	WMI_10_4_VDEV_PARAM_BMISS_FINAL_BCNT,
+	WMI_10_4_VDEV_PARAM_FEATURE_WMM,
+	WMI_10_4_VDEV_PARAM_CHWIDTH,
+	WMI_10_4_VDEV_PARAM_CHEXTOFFSET,
+	WMI_10_4_VDEV_PARAM_DISABLE_HTPROTECTION,
+	WMI_10_4_VDEV_PARAM_STA_QUICKKICKOUT,
+	WMI_10_4_VDEV_PARAM_MGMT_RATE,
+	WMI_10_4_VDEV_PARAM_PROTECTION_MODE,
+	WMI_10_4_VDEV_PARAM_FIXED_RATE,
+	WMI_10_4_VDEV_PARAM_SGI,
+	WMI_10_4_VDEV_PARAM_LDPC,
+	WMI_10_4_VDEV_PARAM_TX_STBC,
+	WMI_10_4_VDEV_PARAM_RX_STBC,
+	WMI_10_4_VDEV_PARAM_INTRA_BSS_FWD,
+	WMI_10_4_VDEV_PARAM_DEF_KEYID,
+	WMI_10_4_VDEV_PARAM_NSS,
+	WMI_10_4_VDEV_PARAM_BCAST_DATA_RATE,
+	WMI_10_4_VDEV_PARAM_MCAST_DATA_RATE,
+	WMI_10_4_VDEV_PARAM_MCAST_INDICATE,
+	WMI_10_4_VDEV_PARAM_DHCP_INDICATE,
+	WMI_10_4_VDEV_PARAM_UNKNOWN_DEST_INDICATE,
+	WMI_10_4_VDEV_PARAM_AP_KEEPALIVE_MIN_IDLE_INACTIVE_TIME_SECS,
+	WMI_10_4_VDEV_PARAM_AP_KEEPALIVE_MAX_IDLE_INACTIVE_TIME_SECS,
+	WMI_10_4_VDEV_PARAM_AP_KEEPALIVE_MAX_UNRESPONSIVE_TIME_SECS,
+	WMI_10_4_VDEV_PARAM_AP_ENABLE_NAWDS,
+	WMI_10_4_VDEV_PARAM_MCAST2UCAST_SET,
+	WMI_10_4_VDEV_PARAM_ENABLE_RTSCTS,
+	WMI_10_4_VDEV_PARAM_RC_NUM_RETRIES,
+	WMI_10_4_VDEV_PARAM_TXBF,
+	WMI_10_4_VDEV_PARAM_PACKET_POWERSAVE,
+	WMI_10_4_VDEV_PARAM_DROP_UNENCRY,
+	WMI_10_4_VDEV_PARAM_TX_ENCAP_TYPE,
+	WMI_10_4_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
+	WMI_10_4_VDEV_PARAM_CABQ_MAXDUR,
+	WMI_10_4_VDEV_PARAM_MFPTEST_SET,
+	WMI_10_4_VDEV_PARAM_RTS_FIXED_RATE,
+	WMI_10_4_VDEV_PARAM_VHT_SGIMASK,
+	WMI_10_4_VDEV_PARAM_VHT80_RATEMASK,
+	WMI_10_4_VDEV_PARAM_EARLY_RX_ADJUST_ENABLE,
+	WMI_10_4_VDEV_PARAM_EARLY_RX_TGT_BMISS_NUM,
+	WMI_10_4_VDEV_PARAM_EARLY_RX_BMISS_SAMPLE_CYCLE,
+	WMI_10_4_VDEV_PARAM_EARLY_RX_SLOP_STEP,
+	WMI_10_4_VDEV_PARAM_EARLY_RX_INIT_SLOP,
+	WMI_10_4_VDEV_PARAM_EARLY_RX_ADJUST_PAUSE,
+	WMI_10_4_VDEV_PARAM_PROXY_STA,
+	WMI_10_4_VDEV_PARAM_MERU_VC,
+	WMI_10_4_VDEV_PARAM_RX_DECAP_TYPE,
+	WMI_10_4_VDEV_PARAM_BW_NSS_RATEMASK,
+};
+
 #define WMI_VDEV_PARAM_TXBF_SU_TX_BFEE BIT(0)
 #define WMI_VDEV_PARAM_TXBF_MU_TX_BFEE BIT(1)
 #define WMI_VDEV_PARAM_TXBF_SU_TX_BFER BIT(2)
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:35293 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaINJmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 05:42:52 -0400
Subject: [PATCH 03/10] ath10k: fix use of multiple blank lines
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 14 Sep 2014 12:50:11 +0300
Message-ID: <20140914095011.9063.98994.stgit@x230> (sfid-20140914_114255_521788_BE586963)
In-Reply-To: <20140914094728.9063.32593.stgit@x230>
References: <20140914094728.9063.32593.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes checkpatch warnings:

CHECK: Please don't use multiple blank lines

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/bmi.h       |    1 -
 drivers/net/wireless/ath/ath10k/ce.c        |    2 --
 drivers/net/wireless/ath/ath10k/ce.h        |    3 ---
 drivers/net/wireless/ath/ath10k/hif.h       |    1 -
 drivers/net/wireless/ath/ath10k/htc.h       |    1 -
 drivers/net/wireless/ath/ath10k/htt.h       |    2 --
 drivers/net/wireless/ath/ath10k/htt_rx.c    |    1 -
 drivers/net/wireless/ath/ath10k/htt_tx.c    |    1 -
 drivers/net/wireless/ath/ath10k/mac.c       |    4 ----
 drivers/net/wireless/ath/ath10k/rx_desc.h   |    1 -
 drivers/net/wireless/ath/ath10k/targaddrs.h |    1 -
 drivers/net/wireless/ath/ath10k/wmi.c       |    2 --
 drivers/net/wireless/ath/ath10k/wmi.h       |    9 ---------
 13 files changed, 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index 111ab701465c..31a990635490 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -177,7 +177,6 @@ struct bmi_target_info {
 	u32 type;
 };
 
-
 /* in msec */
 #define BMI_COMMUNICATION_TIMEOUT_HZ (1*HZ)
 
diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 71eef233bd01..101cadb6e4ba 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -260,7 +260,6 @@ static inline void ath10k_ce_engine_int_status_clear(struct ath10k *ar,
 	ath10k_pci_write32(ar, ce_ctrl_addr + HOST_IS_ADDRESS, mask);
 }
 
-
 /*
  * Guts of ath10k_ce_send, used by both ath10k_ce_send and
  * ath10k_ce_sendlist_send.
@@ -385,7 +384,6 @@ int ath10k_ce_num_free_src_entries(struct ath10k_ce_pipe *pipe)
 	return delta;
 }
 
-
 int __ath10k_ce_rx_num_free_bufs(struct ath10k_ce_pipe *pipe)
 {
 	struct ath10k *ar = pipe->ar;
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index ad4fa7eb945f..329b7340fa72 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -20,7 +20,6 @@
 
 #include "hif.h"
 
-
 /* Maximum number of Copy Engine's supported */
 #define CE_COUNT_MAX 8
 #define CE_HTT_H2T_MSG_SRC_NENTRIES 4096
@@ -37,7 +36,6 @@
 
 struct ath10k_ce_pipe;
 
-
 #define CE_DESC_FLAGS_GATHER         (1 << 0)
 #define CE_DESC_FLAGS_BYTE_SWAP      (1 << 1)
 #define CE_DESC_FLAGS_META_DATA_MASK 0xFFFC
@@ -383,7 +381,6 @@ struct ce_attr {
 #define DST_WATERMARK_HIGH_RESET		0
 #define DST_WATERMARK_ADDRESS			0x0050
 
-
 static inline u32 ath10k_ce_base_address(unsigned int ce_id)
 {
 	return CE0_BASE_ADDRESS + (CE1_BASE_ADDRESS - CE0_BASE_ADDRESS) * ce_id;
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 2ac7beacddca..62323fea27e1 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -91,7 +91,6 @@ struct ath10k_hif_ops {
 	int (*resume)(struct ath10k *ar);
 };
 
-
 static inline int ath10k_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 				   struct ath10k_hif_sg_item *items,
 				   int n_items)
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index bf532f671189..527179c0edce 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -214,7 +214,6 @@ struct ath10k_htc_frame {
 	struct ath10k_htc_record trailer[0];
 } __packed __aligned(4);
 
-
 /*******************/
 /* Host-side stuff */
 /*******************/
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 6c93f3885ee5..e20472672efe 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -265,7 +265,6 @@ enum htt_mgmt_tx_status {
 
 /*=== target -> host messages ===============================================*/
 
-
 enum htt_t2h_msg_type {
 	HTT_T2H_MSG_TYPE_VERSION_CONF		= 0x0,
 	HTT_T2H_MSG_TYPE_RX_IND			= 0x1,
@@ -1148,7 +1147,6 @@ struct htt_resp {
 	};
 } __packed;
 
-
 /*** host side structures follow ***/
 
 struct htt_tx_done {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a720de3d20c4..1e69db52e465 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -42,7 +42,6 @@
 /* when under memory pressure rx ring refill may fail and needs a retry */
 #define HTT_RX_RING_REFILL_RETRY_MS 50
 
-
 static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb);
 static void ath10k_htt_txrx_compl_task(unsigned long ptr);
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index eaa73aa99c20..1ab64631ba1b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -377,7 +377,6 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	int msdu_id = -1;
 	int res;
 
-
 	res = ath10k_htt_tx_inc_pending(htt);
 	if (res)
 		goto err;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index bd852078a413..75b30adfd367 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -225,7 +225,6 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 	return first_errno;
 }
 
-
 /*********************/
 /* General utilities */
 /*********************/
@@ -1262,7 +1261,6 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 			uapsd |= WMI_AP_PS_UAPSD_AC0_DELIVERY_EN |
 				 WMI_AP_PS_UAPSD_AC0_TRIGGER_EN;
 
-
 		if (sta->max_sp < MAX_WMI_AP_PS_PEER_PARAM_MAX_SP)
 			max_sp = sta->max_sp;
 
@@ -1316,7 +1314,6 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	arg->peer_flags |= WMI_PEER_VHT;
 	arg->peer_vht_caps = vht_cap->cap;
 
-
 	ampdu_factor = (vht_cap->cap &
 			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK) >>
 		       IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
@@ -4715,7 +4712,6 @@ static struct ieee80211_sta_ht_cap ath10k_get_ht_cap(struct ath10k *ar)
 	return ht_cap;
 }
 
-
 static void ath10k_get_arvif_iter(void *data, u8 *mac,
 				  struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index 1c584c4b019c..e1ffdd57a18c 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -839,7 +839,6 @@ struct rx_ppdu_start {
  *		Reserved: HW should fill with 0, FW should ignore.
 */
 
-
 #define RX_PPDU_END_FLAGS_PHY_ERR             (1 << 0)
 #define RX_PPDU_END_FLAGS_RX_LOCATION         (1 << 1)
 #define RX_PPDU_END_FLAGS_TXBF_H_INFO         (1 << 2)
diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index be7ba1e78afe..9d0ae30f9ff1 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -284,7 +284,6 @@ Fw Mode/SubMode Mask
 #define HI_OPTION_ALL_FW_SUBMODE_MASK  0xFF00
 #define HI_OPTION_ALL_FW_SUBMODE_SHIFT 0x8
 
-
 /* hi_option_flag2 options */
 #define HI_OPTION_OFFLOAD_AMSDU     0x01
 #define HI_OPTION_DFS_SUPPORT       0x02 /* Enable DFS support */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 3b5749d8b081..ed438edb9763 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1511,7 +1511,6 @@ static u32 ath10k_p2p_calc_noa_ie_len(struct wmi_p2p_noa_info *noa)
 	u8 opp_ps_info = noa->ctwindow_oppps;
 	bool opps_enabled = !!(opp_ps_info & WMI_P2P_OPPPS_ENABLE_BIT);
 
-
 	if (!noa_descriptors && !opps_enabled)
 		return len;
 
@@ -1568,7 +1567,6 @@ cleanup:
 	kfree(old_data);
 }
 
-
 static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_host_swba_event *ev;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1cc594e18a07..86f5ebccfe79 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1269,7 +1269,6 @@ enum wmi_channel_change_cause {
 				WMI_HT_CAP_RX_STBC       | \
 				WMI_HT_CAP_LDPC)
 
-
 /*
  * WMI_VHT_CAP_* these maps to ieee 802.11ac vht capability information
  * field. The fields not defined here are not supported, or reserved.
@@ -1471,7 +1470,6 @@ struct wmi_service_ready_event_10x {
 	struct wlan_host_mem_req mem_reqs[1];
 } __packed;
 
-
 #define WMI_SERVICE_READY_TIMEOUT_HZ (5*HZ)
 #define WMI_UNIFIED_READY_TIMEOUT_HZ (5*HZ)
 
@@ -2125,7 +2123,6 @@ struct wmi_start_scan_cmd_10x {
 	 */
 } __packed;
 
-
 struct wmi_ssid_arg {
 	int len;
 	const u8 *ssid;
@@ -2186,7 +2183,6 @@ struct wmi_start_scan_arg {
 /* WMI_SCAN_CLASS_MASK must be the same value as IEEE80211_SCAN_CLASS_MASK */
 #define WMI_SCAN_CLASS_MASK 0xFF000000
 
-
 enum wmi_stop_scan_type {
 	WMI_SCAN_STOP_ONE	= 0x00000000, /* stop by scan_id */
 	WMI_SCAN_STOP_VDEV_ALL	= 0x01000000, /* stop by vdev_id */
@@ -2371,7 +2367,6 @@ struct wmi_single_phyerr_rx_hdr {
 	__le32 nf_list_1;
 	__le32 nf_list_2;
 
-
 	/* Length of the frame */
 	__le32 buf_len;
 } __packed;
@@ -2473,7 +2468,6 @@ struct phyerr_fft_report {
 #define SEARCH_FFT_REPORT_REG1_NUM_STR_BINS_IB_MASK	0x000000FF
 #define SEARCH_FFT_REPORT_REG1_NUM_STR_BINS_IB_LSB	0
 
-
 struct phyerr_tlv {
 	__le16 len;
 	u8 tag;
@@ -2504,7 +2498,6 @@ struct wmi_echo_cmd {
 	__le32 value;
 } __packed;
 
-
 struct wmi_pdev_set_regdomain_cmd {
 	__le32 reg_domain;
 	__le32 reg_domain_2G;
@@ -2553,7 +2546,6 @@ struct wmi_pdev_set_quiet_cmd {
 	__le32 enabled;
 } __packed;
 
-
 /*
  * 802.11g protection mode.
  */
@@ -4291,7 +4283,6 @@ struct wmi_tbtt_offset_event {
 	__le32 tbttoffset_list[WMI_MAX_AP_VDEV];
 } __packed;
 
-
 struct wmi_peer_create_cmd {
 	__le32 vdev_id;
 	struct wmi_mac_addr peer_macaddr;


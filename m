Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34875 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752726AbdBTOhw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 09:37:52 -0500
Received: by mail-lf0-f47.google.com with SMTP id z127so50503426lfa.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2017 06:37:51 -0800 (PST)
From: Marcin Rokicki <marcin.rokicki@tieto.com>
To: marcin.rokicki@tieto.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: Clean header files from bad block comments
Date: Mon, 20 Feb 2017 15:37:47 +0100
Message-Id: <1487601467-22881-1-git-send-email-marcin.rokicki@tieto.com> (sfid-20170220_153759_334812_14BDCD6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix output from checkpatch.pl like:
 Block comments use a trailing */ on a separate line

Signed-off-by: Marcin Rokicki <marcin.rokicki@tieto.com>
---
 drivers/net/wireless/ath/ath10k/bmi.h       |  3 ++-
 drivers/net/wireless/ath/ath10k/core.h      |  9 ++++++---
 drivers/net/wireless/ath/ath10k/hif.h       |  6 ++++--
 drivers/net/wireless/ath/ath10k/htt.h       | 24 +++++++++++++++--------
 drivers/net/wireless/ath/ath10k/hw.h        |  3 ++-
 drivers/net/wireless/ath/ath10k/rx_desc.h   | 13 ++++++++-----
 drivers/net/wireless/ath/ath10k/targaddrs.h | 19 +++++++++---------
 drivers/net/wireless/ath/ath10k/wmi-ops.h   |  3 ++-
 drivers/net/wireless/ath/ath10k/wmi.h       | 30 +++++++++++++++++++----------
 9 files changed, 70 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index 7d3231a..98be562 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -176,7 +176,8 @@ union bmi_resp {
 	} rompatch_uninstall;
 	struct {
 		/* 0 = nothing executed
-		 * otherwise = NVRAM segment return value */
+		 * otherwise = NVRAM segment return value
+		 */
 		__le32 result;
 	} nvram_process;
 	u8 payload[BMI_MAX_CMDBUF_SIZE];
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 88d14be..53a66e6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -501,14 +501,16 @@ enum ath10k_state {
 	 * stopped in ath10k_core_restart() work holding conf_mutex. The state
 	 * RESTARTED means that the device is up and mac80211 has started hw
 	 * reconfiguration. Once mac80211 is done with the reconfiguration we
-	 * set the state to STATE_ON in reconfig_complete(). */
+	 * set the state to STATE_ON in reconfig_complete().
+	 */
 	ATH10K_STATE_RESTARTING,
 	ATH10K_STATE_RESTARTED,
 
 	/* The device has crashed while restarting hw. This state is like ON
 	 * but commands are blocked in HTC and -ECOMM response is given. This
 	 * prevents completion timeouts and makes the driver more responsive to
-	 * userspace commands. This is also prevents recursive recovery. */
+	 * userspace commands. This is also prevents recursive recovery.
+	 */
 	ATH10K_STATE_WEDGED,
 
 	/* factory tests */
@@ -918,7 +920,8 @@ struct ath10k {
 	struct work_struct restart_work;
 
 	/* cycle count is reported twice for each visited channel during scan.
-	 * access protected by data_lock */
+	 * access protected by data_lock
+	 */
 	u32 survey_last_rx_clear_count;
 	u32 survey_last_cycle_count;
 	struct survey_info survey[ATH10K_NUM_CHANS];
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index b2566b0..6679dd9 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -54,7 +54,8 @@ struct ath10k_hif_ops {
 	int (*start)(struct ath10k *ar);
 
 	/* Clean up what start() did. This does not revert to BMI phase. If
-	 * desired so, call power_down() and power_up() */
+	 * desired so, call power_down() and power_up()
+	 */
 	void (*stop)(struct ath10k *ar);
 
 	int (*map_service_to_pipe)(struct ath10k *ar, u16 service_id,
@@ -82,7 +83,8 @@ struct ath10k_hif_ops {
 	int (*power_up)(struct ath10k *ar);
 
 	/* Power down the device and free up resources. stop() must be called
-	 * before this if start() was called earlier */
+	 * before this if start() was called earlier
+	 */
 	void (*power_down)(struct ath10k *ar);
 
 	int (*suspend)(struct ath10k *ar);
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 90c2f72..6305308 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -51,7 +51,8 @@ enum htt_h2t_msg_type { /* host-to-target */
 	HTT_H2T_MSG_TYPE_FRAG_DESC_BANK_CFG = 6,
 
 	/* This command is used for sending management frames in HTT < 3.0.
-	 * HTT >= 3.0 uses TX_FRM for everything. */
+	 * HTT >= 3.0 uses TX_FRM for everything.
+	 */
 	HTT_H2T_MSG_TYPE_MGMT_TX            = 7,
 	HTT_H2T_MSG_TYPE_TX_FETCH_RESP      = 11,
 
@@ -910,7 +911,8 @@ struct htt_rx_test {
 
 	/* payload consists of 2 lists:
 	 *  a) num_ints * sizeof(__le32)
-	 *  b) num_chars * sizeof(u8) aligned to 4bytes */
+	 *  b) num_chars * sizeof(u8) aligned to 4bytes
+	 */
 	u8 payload[0];
 } __packed;
 
@@ -1307,7 +1309,8 @@ struct htt_frag_desc_bank_id {
 } __packed;
 
 /* real is 16 but it wouldn't fit in the max htt message size
- * so we use a conservatively safe value for now */
+ * so we use a conservatively safe value for now
+ */
 #define HTT_FRAG_DESC_BANK_MAX 4
 
 #define HTT_FRAG_DESC_BANK_CFG_INFO_PDEV_ID_MASK		0x03
@@ -1684,12 +1687,14 @@ struct ath10k_htt {
 	DECLARE_KFIFO_PTR(txdone_fifo, struct htt_tx_done);
 
 	/* set if host-fw communication goes haywire
-	 * used to avoid further failures */
+	 * used to avoid further failures
+	 */
 	bool rx_confused;
 	atomic_t num_mpdus_ready;
 
 	/* This is used to group tx/rx completions separately and process them
-	 * in batches to reduce cache stalls */
+	 * in batches to reduce cache stalls
+	 */
 	struct sk_buff_head rx_compl_q;
 	struct sk_buff_head rx_in_ord_compl_q;
 	struct sk_buff_head tx_fetch_ind_q;
@@ -1725,11 +1730,13 @@ struct ath10k_htt {
 
 /* This structure layout is programmed via rx ring setup
  * so that FW knows how to transfer the rx descriptor to the host.
- * Buffers like this are placed on the rx ring. */
+ * Buffers like this are placed on the rx ring.
+ */
 struct htt_rx_desc {
 	union {
 		/* This field is filled on the host using the msdu buffer
-		 * from htt_rx_indication */
+		 * from htt_rx_indication
+		 */
 		struct fw_rx_desc_base fw_desc;
 		u32 pad;
 	} __packed;
@@ -1760,7 +1767,8 @@ struct htt_rx_desc {
 #define HTT_RX_MSDU_SIZE (HTT_RX_BUF_SIZE - (int)sizeof(struct htt_rx_desc))
 
 /* Refill a bunch of RX buffers for each refill round so that FW/HW can handle
- * aggregated traffic more nicely. */
+ * aggregated traffic more nicely.
+ */
 #define ATH10K_HTT_MAX_NUM_REFILL 100
 
 /*
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index f0fda0f..5343376 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -293,7 +293,8 @@ void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
  *  - raw appears in nwifi decap, raw and nwifi appear in ethernet decap
  *  - raw have FCS, nwifi doesn't
  *  - ethernet frames have 802.11 header decapped and parts (base hdr, cipher
- *    param, llc/snap) are aligned to 4byte boundaries each */
+ *    param, llc/snap) are aligned to 4byte boundaries each
+ */
 enum ath10k_hw_txrx_mode {
 	ATH10K_HW_TXRX_RAW = 0,
 
diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index 034e7a5..c1022a1 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -439,19 +439,22 @@ struct rx_mpdu_end {
  *  c) A-MSDU subframe header (14 bytes) if appliable
  *  d) LLC/SNAP (RFC1042, 8 bytes)
  *
- * In case of A-MSDU only first frame in sequence contains (a) and (b). */
+ * In case of A-MSDU only first frame in sequence contains (a) and (b).
+ */
 enum rx_msdu_decap_format {
 	RX_MSDU_DECAP_RAW = 0,
 
 	/* Note: QoS frames are reported as non-QoS. The rx_hdr_status in
-	 * htt_rx_desc contains the original decapped 802.11 header. */
+	 * htt_rx_desc contains the original decapped 802.11 header.
+	 */
 	RX_MSDU_DECAP_NATIVE_WIFI = 1,
 
 	/* Payload contains an ethernet header (struct ethhdr). */
 	RX_MSDU_DECAP_ETHERNET2_DIX = 2,
 
 	/* Payload contains two 48-bit addresses and 2-byte length (14 bytes
-	 * total), followed by an RFC1042 header (8 bytes). */
+	 * total), followed by an RFC1042 header (8 bytes).
+	 */
 	RX_MSDU_DECAP_8023_SNAP_LLC = 3
 };
 
@@ -867,7 +870,7 @@ struct rx_ppdu_start {
  *
  * reserved_9
  *		Reserved: HW should fill with 0, FW should ignore.
-*/
+ */
 
 #define RX_PPDU_END_FLAGS_PHY_ERR             (1 << 0)
 #define RX_PPDU_END_FLAGS_RX_LOCATION         (1 << 1)
@@ -1207,7 +1210,7 @@ struct rx_ppdu_end {
  *		Every time HW sets this bit in memory FW/SW must clear this
  *		bit in memory.  FW will initialize all the ppdu_done dword
  *		to 0.
-*/
+ */
 
 #define FW_RX_DESC_INFO0_DISCARD  (1 << 0)
 #define FW_RX_DESC_INFO0_FORWARD  (1 << 1)
diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index a47cab4..cbac9e42 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -268,13 +268,13 @@ struct host_interest {
 #define HI_OPTION_FW_BRIDGE_SHIFT 0x04
 
 /*
-Fw Mode/SubMode Mask
-|-----------------------------------------------------------------------------|
-|  SUB   |   SUB   |   SUB   |  SUB    |         |         |         |        |
-|MODE[3] | MODE[2] | MODE[1] | MODE[0] | MODE[3] | MODE[2] | MODE[1] | MODE[0]|
-|  (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)  |
-|-----------------------------------------------------------------------------|
-*/
+ * Fw Mode/SubMode Mask
+ *-----------------------------------------------------------------------------
+ *  SUB   |   SUB   |   SUB   |  SUB    |         |         |         |
+ *MODE[3] | MODE[2] | MODE[1] | MODE[0] | MODE[3] | MODE[2] | MODE[1] | MODE[0]
+ *  (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)   |   (2)
+ *-----------------------------------------------------------------------------
+ */
 #define HI_OPTION_FW_MODE_BITS         0x2
 #define HI_OPTION_FW_MODE_MASK         0x3
 #define HI_OPTION_FW_MODE_SHIFT        0xC
@@ -428,8 +428,9 @@ Fw Mode/SubMode Mask
 #define HI_PWR_SAVE_LPL_ENABLED   0x1
 /*b1-b3 reserved*/
 /*b4-b5 : dev0 LPL type : 0 - none
-			  1- Reduce Pwr Search
-			  2- Reduce Pwr Listen*/
+ *			  1- Reduce Pwr Search
+ *			  2- Reduce Pwr Listen
+ */
 /*b6-b7 : dev1 LPL type and so on for Max 8 devices*/
 #define HI_PWR_SAVE_LPL_DEV0_LSB   4
 #define HI_PWR_SAVE_LPL_DEV_MASK   0x3
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index c7956e1..2fc3f24 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -390,7 +390,8 @@ ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *msdu)
 		return ret;
 
 	/* FIXME There's no ACK event for Management Tx. This probably
-	 * shouldn't be called here either. */
+	 * shouldn't be called here either.
+	 */
 	info->flags |= IEEE80211_TX_STAT_ACK;
 	ieee80211_tx_status_irqsafe(ar->hw, msdu);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 386aa51..427220c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1038,7 +1038,8 @@ enum wmi_cmd_id {
 	WMI_STA_UAPSD_AUTO_TRIG_CMDID,
 
 	/* STA Keep alive parameter configuration,
-	   Requires WMI_SERVICE_STA_KEEP_ALIVE */
+	 * Requires WMI_SERVICE_STA_KEEP_ALIVE
+	 */
 	WMI_STA_KEEPALIVE_CMD,
 
 	/* misc command group */
@@ -1774,7 +1775,8 @@ static inline const char *ath10k_wmi_phymode_str(enum wmi_phy_mode mode)
 		break;
 
 		/* no default handler to allow compiler to check that the
-		 * enum is fully handled */
+		 * enum is fully handled
+		 */
 	};
 
 	return "<unknown>";
@@ -2974,7 +2976,8 @@ struct wmi_start_scan_arg {
 /* When set, DFS channels will not be scanned */
 #define WMI_SCAN_BYPASS_DFS_CHN 0x40
 /* Different FW scan engine may choose to bail out on errors.
- * Allow the driver to have influence over that. */
+ * Allow the driver to have influence over that.
+ */
 #define WMI_SCAN_CONTINUE_ON_ERROR 0x80
 
 /* WMI_SCAN_CLASS_MASK must be the same value as IEEE80211_SCAN_CLASS_MASK */
@@ -4447,14 +4450,16 @@ enum wmi_vdev_subtype_10_4 {
 /* values for vdev_start_request flags */
 /*
  * Indicates that AP VDEV uses hidden ssid. only valid for
- *  AP/GO */
+ *  AP/GO
+ */
 #define WMI_VDEV_START_HIDDEN_SSID  (1 << 0)
 /*
  * Indicates if robust management frame/management frame
  *  protection is enabled. For GO/AP vdevs, it indicates that
  *  it may support station/client associations with RMF enabled.
  *  For STA/client vdevs, it indicates that sta will
- *  associate with AP with RMF enabled. */
+ *  associate with AP with RMF enabled.
+ */
 #define WMI_VDEV_START_PMF_ENABLED  (1 << 1)
 
 struct wmi_p2p_noa_descriptor {
@@ -4814,7 +4819,8 @@ enum wmi_vdev_param {
 	 * An associated STA is considered unresponsive if there is no recent
 	 * TX/RX activity and downlink frames are buffered for it. Once a STA
 	 * exceeds the maximum unresponsive time, the AP will send a
-	 * WMI_STA_KICKOUT event to the host so the STA can be deleted. */
+	 * WMI_STA_KICKOUT event to the host so the STA can be deleted.
+	 */
 	WMI_VDEV_PARAM_AP_KEEPALIVE_MAX_UNRESPONSIVE_TIME_SECS,
 
 	/* Enable NAWDS : MCAST INSPECT Enable, NAWDS Flag set */
@@ -4941,7 +4947,8 @@ enum wmi_10x_vdev_param {
 	 * An associated STA is considered unresponsive if there is no recent
 	 * TX/RX activity and downlink frames are buffered for it. Once a STA
 	 * exceeds the maximum unresponsive time, the AP will send a
-	 * WMI_10X_STA_KICKOUT event to the host so the STA can be deleted. */
+	 * WMI_10X_STA_KICKOUT event to the host so the STA can be deleted.
+	 */
 	WMI_10X_VDEV_PARAM_AP_KEEPALIVE_MAX_UNRESPONSIVE_TIME_SECS,
 
 	/* Enable NAWDS : MCAST INSPECT Enable, NAWDS Flag set */
@@ -5605,12 +5612,14 @@ struct wmi_tim_info_arg {
 
 struct wmi_p2p_noa_info {
 	/* Bit 0 - Flag to indicate an update in NOA schedule
-	   Bits 7-1 - Reserved */
+	 * Bits 7-1 - Reserved
+	 */
 	u8 changed;
 	/* NOA index */
 	u8 index;
 	/* Bit 0 - Opp PS state of the AP
-	   Bits 1-7 - Ctwindow in TUs */
+	 * Bits 1-7 - Ctwindow in TUs
+	 */
 	u8 ctwindow_oppps;
 	/* Number of NOA descriptors */
 	u8 num_descriptors;
@@ -6000,7 +6009,8 @@ struct wmi_main_peer_assoc_complete_cmd {
 	struct wmi_common_peer_assoc_complete_cmd cmd;
 
 	/* HT Operation Element of the peer. Five bytes packed in 2
-	 *  INT32 array and filled from lsb to msb. */
+	 *  INT32 array and filled from lsb to msb.
+	 */
 	__le32 peer_ht_info[2];
 } __packed;
 
-- 
2.7.4

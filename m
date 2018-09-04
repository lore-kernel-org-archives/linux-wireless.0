Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbeIDQeP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:34:15 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v3] ath10k: average ack rssi support for data frames
Date: Tue,  4 Sep 2018 17:39:11 +0530
Message-Id: <1536062951-17955-1-git-send-email-bpothuno@codeaurora.org> (sfid-20180904_140925_752942_48D6792B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Average ack rssi value is weighted average of ack rssi for
no of msdu's has been sent.
This feature is enabled by the host driver if firmware is capable.
After receiving event from host, firmware allocates the necessary
memory to store the ack_rssi for data packets during the init time.

After each successful transmission, If tx completion status is OK
and 24th bit is set in HTT message header then host will fetch the
ack_rssi else host can ignore the ack_rssi field

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
v2:
   Addressed ath10k-check warnings
v3:
   cfg80211/mac80211 changes are already merged hence 
   rebased ath10k patch alone.

 drivers/net/wireless/ath/ath10k/core.c   |  4 ++++
 drivers/net/wireless/ath/ath10k/htt.h    |  4 +++-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 22 +++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/mac.c    |  4 ++++
 drivers/net/wireless/ath/ath10k/txrx.c   |  4 ++--
 drivers/net/wireless/ath/ath10k/wmi.h    |  8 ++++++++
 6 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f5f71c0..f25ed13 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2385,6 +2385,10 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 			     ar->wmi.svc_map))
 			val |= WMI_10_4_TDLS_UAPSD_BUFFER_STA;
 
+		if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI,
+			     ar->wmi.svc_map))
+			val |= WMI_10_4_TX_DATA_ACK_RSSI;
+
 		status = ath10k_mac_ext_resource_config(ar, val);
 		if (status) {
 			ath10k_err(ar,
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 5d3ff80..26ce532 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -577,6 +577,8 @@ struct htt_mgmt_tx_completion {
 #define HTT_RX_INDICATION_INFO1_NUM_MPDU_RANGES_MASK     0xFF000000
 #define HTT_RX_INDICATION_INFO1_NUM_MPDU_RANGES_LSB      24
 
+#define HTT_TX_CMPL_FLAG_DATA_RSSI BIT(0)
+
 struct htt_rx_indication_hdr {
 	u8 info0; /* %HTT_RX_INDICATION_INFO0_ */
 	__le16 peer_id;
@@ -840,7 +842,7 @@ struct htt_data_tx_completion {
 		} __packed;
 	} __packed;
 	u8 num_msdus;
-	u8 rsvd0;
+	u8 flags2; /* HTT_TX_CMPL_FLAG_DATA_RSSI */
 	__le16 msdus[0]; /* variable length based on %num_msdus */
 } __packed;
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 4d1cd90..025fd1e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1886,6 +1886,8 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 	int status = MS(resp->data_tx_completion.flags, HTT_DATA_TX_STATUS);
 	__le16 msdu_id;
 	int i;
+	bool rssi_enabled = false;
+	u8 msdu_count = 0;
 
 	switch (status) {
 	case HTT_DATA_TX_STATUS_NO_ACK:
@@ -1908,10 +1910,28 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx completion num_msdus %d\n",
 		   resp->data_tx_completion.num_msdus);
 
-	for (i = 0; i < resp->data_tx_completion.num_msdus; i++) {
+	msdu_count = resp->data_tx_completion.num_msdus;
+
+	if (resp->data_tx_completion.flags2 & HTT_TX_CMPL_FLAG_DATA_RSSI)
+		rssi_enabled = true;
+
+	for (i = 0; i < msdu_count; i++) {
 		msdu_id = resp->data_tx_completion.msdus[i];
 		tx_done.msdu_id = __le16_to_cpu(msdu_id);
 
+		if (rssi_enabled) {
+			/* Total no of MSDUs should be even,
+			 * if odd MSDUs are sent firmware fills
+			 * last msdu id with 0xffff
+			 */
+			if (msdu_count & 0x01) {
+				msdu_id = resp->data_tx_completion.msdus[msdu_count +  i + 1];
+				tx_done.ack_rssi = __le16_to_cpu(msdu_id);
+			} else {
+				msdu_id = resp->data_tx_completion.msdus[msdu_count +  i];
+				tx_done.ack_rssi = __le16_to_cpu(msdu_id);
+			}
+		}
 		/* kfifo_put: In practice firmware shouldn't fire off per-CE
 		 * interrupt and main interrupt (MSI/-X range case) for the same
 		 * HTC service so it should be safe to use kfifo_put w/o lock.
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 078058e..3fa22ef 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8469,6 +8469,10 @@ int ath10k_mac_register(struct ath10k *ar)
 	wiphy_ext_feature_set(ar->hw->wiphy,
 			      NL80211_EXT_FEATURE_SET_SCAN_DWELL);
 
+	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT);
+
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index cda164f..784e2ff 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -109,8 +109,8 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	if (tx_done->status == HTT_TX_COMPL_STATE_NOACK)
 		info->flags &= ~IEEE80211_TX_STAT_ACK;
 
-	if ((tx_done->status == HTT_TX_COMPL_STATE_ACK) &&
-	    (info->flags & IEEE80211_TX_CTL_NO_ACK))
+	if (tx_done->status == HTT_TX_COMPL_STATE_ACK &&
+	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
 
 	if (tx_done->status == HTT_TX_COMPL_STATE_DISCARD) {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 3622025..489bc7e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -203,6 +203,7 @@ enum wmi_service {
 	WMI_SERVICE_TPC_STATS_FINAL,
 	WMI_SERVICE_RESET_CHIP,
 	WMI_SERVICE_SPOOF_MAC_SUPPORT,
+	WMI_SERVICE_TX_DATA_ACK_RSSI,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -350,6 +351,8 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
 	WMI_10_4_SERVICE_HOST_DFS_CHECK_SUPPORT,
 	WMI_10_4_SERVICE_TPC_STATS_FINAL,
+	WMI_10_4_SERVICE_CFR_CAPTURE_SUPPORT,
+	WMI_10_4_SERVICE_TX_DATA_ACK_RSSI,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -463,6 +466,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_HOST_DFS_CHECK_SUPPORT);
 	SVCSTR(WMI_SERVICE_TPC_STATS_FINAL);
 	SVCSTR(WMI_SERVICE_RESET_CHIP);
+	SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
 	default:
 		return NULL;
 	}
@@ -771,6 +775,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_HOST_DFS_CHECK_SUPPORT, len);
 	SVCMAP(WMI_10_4_SERVICE_TPC_STATS_FINAL,
 	       WMI_SERVICE_TPC_STATS_FINAL, len);
+	SVCMAP(WMI_10_4_SERVICE_TX_DATA_ACK_RSSI,
+	       WMI_SERVICE_TX_DATA_ACK_RSSI, len);
 }
 
 #undef SVCMAP
@@ -2924,6 +2930,7 @@ enum wmi_coex_version {
  * @WMI_10_4_TDLS_CONN_TRACKER_IN_HOST_MODE: TDLS connection tracker in host
  *	enable/disable
  * @WMI_10_4_TDLS_EXPLICIT_MODE_ONLY:Explicit TDLS mode enable/disable
+ * @WMI_10_4_TX_DATA_ACK_RSSI: Enable DATA ACK RSSI if firmware is capable
  */
 enum wmi_10_4_feature_mask {
 	WMI_10_4_LTEU_SUPPORT			= BIT(0),
@@ -2939,6 +2946,7 @@ enum wmi_10_4_feature_mask {
 	WMI_10_4_TDLS_UAPSD_SLEEP_STA		= BIT(10),
 	WMI_10_4_TDLS_CONN_TRACKER_IN_HOST_MODE = BIT(11),
 	WMI_10_4_TDLS_EXPLICIT_MODE_ONLY	= BIT(12),
+	WMI_10_4_TX_DATA_ACK_RSSI               = BIT(16),
 
 };
 
-- 
2.7.4

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39156 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753025AbeDPOt3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 10:49:29 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, bpothuno@codeaurora.org
Subject: [PATCHv2 3/3] ath10k: average ack rssi support for data frames
Date: Mon, 16 Apr 2018 20:18:42 +0530
Message-Id: <1523890122-23952-4-git-send-email-bpothuno@codeaurora.org> (sfid-20180416_164934_500620_CD6E3BBE)
In-Reply-To: <1523890122-23952-1-git-send-email-bpothuno@codeaurora.org>
References: <1523890122-23952-1-git-send-email-bpothuno@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Average ack rssi value is weighted average of ack rssi for
no of msdu's has been sent.
This feature is enabled by the host driver if firmware is capable.
After receiving event from host, firmware allocates the necessary
memory to store the ack_rssi for data packets during the init time.

After each successful transmission, If tx completion status is OK
and 24th bit is set in HTT message header then host will fetch the
ack_rssi else host can ignore the ack_rssi field.

Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c   |  4 ++++
 drivers/net/wireless/ath/ath10k/htt.h    |  6 +++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 22 +++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/mac.c    |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi.h    |  8 ++++++++
 5 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 8a3020d..0fe98e9 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2307,6 +2307,10 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
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
index 8cc2a8b..bd39d6b 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -557,6 +558,8 @@ struct htt_mgmt_tx_completion {
 #define HTT_RX_INDICATION_INFO1_NUM_MPDU_RANGES_MASK     0xFF000000
 #define HTT_RX_INDICATION_INFO1_NUM_MPDU_RANGES_LSB      24
 
+#define HTT_TX_CMPL_FLAG_DATA_RSSI BIT(0)
+
 struct htt_rx_indication_hdr {
 	u8 info0; /* %HTT_RX_INDICATION_INFO0_ */
 	__le16 peer_id;
@@ -820,7 +823,7 @@ struct htt_data_tx_completion {
 		} __packed;
 	} __packed;
 	u8 num_msdus;
-	u8 rsvd0;
+	u8 flags2; /* HTT_TX_CMPL_FLAG_DATA_RSSI */
 	__le16 msdus[0]; /* variable length based on %num_msdus */
 } __packed;
 
@@ -1648,6 +1651,7 @@ struct htt_resp {
 struct htt_tx_done {
 	u16 msdu_id;
 	u16 status;
+	u8 ack_rssi;
 };
 
 enum htt_tx_compl_state {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 5e02e26..0228bbe 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1882,6 +1882,8 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 	int status = MS(resp->data_tx_completion.flags, HTT_DATA_TX_STATUS);
 	__le16 msdu_id;
 	int i;
+	bool rssi_enabled = false;
+	u8 msdu_count = 0;
 
 	switch (status) {
 	case HTT_DATA_TX_STATUS_NO_ACK:
@@ -1904,10 +1906,28 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
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
index bf05a36..f62ddd6 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8352,6 +8352,10 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
+	if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				NL80211_EXT_FEATURE_DATA_ACK_SIGNAL_SUPPORT);
+
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 6fbc84c..5c43c26 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -201,6 +201,7 @@ enum wmi_service {
 	WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
 	WMI_SERVICE_HOST_DFS_CHECK_SUPPORT,
 	WMI_SERVICE_TPC_STATS_FINAL,
+	WMI_SERVICE_TX_DATA_ACK_RSSI,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -346,6 +347,8 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
 	WMI_10_4_SERVICE_HOST_DFS_CHECK_SUPPORT,
 	WMI_10_4_SERVICE_TPC_STATS_FINAL,
+	WMI_10_4_SERVICE_CFR_CAPTURE_SUPPORT,
+	WMI_10_4_SERVICE_TX_DATA_ACK_RSSI,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -458,6 +461,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS);
 	SVCSTR(WMI_SERVICE_HOST_DFS_CHECK_SUPPORT);
 	SVCSTR(WMI_SERVICE_TPC_STATS_FINAL);
+	SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
 	default:
 		return NULL;
 	}
@@ -762,6 +766,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_HOST_DFS_CHECK_SUPPORT, len);
 	SVCMAP(WMI_10_4_SERVICE_TPC_STATS_FINAL,
 	       WMI_SERVICE_TPC_STATS_FINAL, len);
+	SVCMAP(WMI_10_4_SERVICE_TX_DATA_ACK_RSSI,
+	       WMI_SERVICE_TX_DATA_ACK_RSSI, len);
 }
 
 #undef SVCMAP
@@ -2904,6 +2910,7 @@ enum wmi_coex_version {
  * @WMI_10_4_TDLS_CONN_TRACKER_IN_HOST_MODE: TDLS connection tracker in host
  *	enable/disable
  * @WMI_10_4_TDLS_EXPLICIT_MODE_ONLY:Explicit TDLS mode enable/disable
+ * @WMI_10_4_TX_DATA_ACK_RSSI: Enable DATA ACK RSSI if firmware is capable
  */
 enum wmi_10_4_feature_mask {
 	WMI_10_4_LTEU_SUPPORT			= BIT(0),
@@ -2919,6 +2926,7 @@ enum wmi_10_4_feature_mask {
 	WMI_10_4_TDLS_UAPSD_SLEEP_STA		= BIT(10),
 	WMI_10_4_TDLS_CONN_TRACKER_IN_HOST_MODE = BIT(11),
 	WMI_10_4_TDLS_EXPLICIT_MODE_ONLY	= BIT(12),
+	WMI_10_4_TX_DATA_ACK_RSSI               = BIT(16),
 
 };
 
-- 
2.7.4

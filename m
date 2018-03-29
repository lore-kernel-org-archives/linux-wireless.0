Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60902 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbeC2Jso (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 05:48:44 -0400
From: Venkateswara Naralasetty <vnaralas@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Subject: [PATCHv3] ath10k: Add tx ack signal support for management frames
Date: Thu, 29 Mar 2018 15:18:35 +0530
Message-Id: <1522316915-27518-1-git-send-email-vnaralas@codeaurora.org> (sfid-20180329_114848_527301_E28A5D55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add support to get RSSI from acknowledgment
frames for transmitted management frames.

hardware_used: QCA4019, QCA9984.
firmware version: 10.4-3.5.3-00052.

Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
---
v2:
 * renamed HTT_MGMT_TX_CMPL_INFO_ACK_RSSI to HTT_MGMT_TX_CMPL_INFO_ACK_RSSI_MASK
 * removed WMI_SERVICE_TDLS_WIDER_BANDWIDTH, which has already added recently.

v3:
 * Addressed warnings.
 * removed WMI_SERVICE which has already added recently
---
 drivers/net/wireless/ath/ath10k/core.h   |  2 ++
 drivers/net/wireless/ath/ath10k/htt.h    | 10 +++++++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 10 ++++++++++
 drivers/net/wireless/ath/ath10k/txrx.c   |  8 ++++++++
 drivers/net/wireless/ath/ath10k/wmi.h    |  7 +++++++
 5 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 73712c8..692aa29 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -52,6 +52,8 @@
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
 
+#define ATH10K_INVALID_RSSI 128
+
 #define ATH10K_MAX_NUM_MGMT_PENDING 128
 
 /* number of failed packets (20 packets with 16 sw reties each) */
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 8cc2a8b..e5dbb0b 100644
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
@@ -533,12 +534,18 @@ struct htt_ver_resp {
 	u8 rsvd0;
 } __packed;
 
+#define HTT_MGMT_TX_CMPL_FLAG_ACK_RSSI BIT(0)
+
+#define HTT_MGMT_TX_CMPL_INFO_ACK_RSSI_MASK	GENMASK(7, 0)
+
 struct htt_mgmt_tx_completion {
 	u8 rsvd0;
 	u8 rsvd1;
-	u8 rsvd2;
+	u8 flags;
 	__le32 desc_id;
 	__le32 status;
+	__le32 ppdu_id;
+	__le32 info;
 } __packed;
 
 #define HTT_RX_INDICATION_INFO0_EXT_TID_MASK  (0x1F)
@@ -1648,6 +1655,7 @@ struct htt_resp {
 struct htt_tx_done {
 	u16 msdu_id;
 	u16 status;
+	u8 ack_rssi;
 };
 
 enum htt_tx_compl_state {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 64996ab..351ab93 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -25,6 +25,7 @@
 #include "mac.h"
 
 #include <linux/log2.h>
+#include <linux/bitfield.h>
 
 /* when under memory pressure rx ring refill may fail and needs a retry */
 #define HTT_RX_RING_REFILL_RETRY_MS 50
@@ -2713,12 +2714,21 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	case HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION: {
 		struct htt_tx_done tx_done = {};
 		int status = __le32_to_cpu(resp->mgmt_tx_completion.status);
+		int info = __le32_to_cpu(resp->mgmt_tx_completion.info);
 
 		tx_done.msdu_id = __le32_to_cpu(resp->mgmt_tx_completion.desc_id);
 
 		switch (status) {
 		case HTT_MGMT_TX_STATUS_OK:
 			tx_done.status = HTT_TX_COMPL_STATE_ACK;
+			if (test_bit(WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
+				     ar->wmi.svc_map) &&
+			    (resp->mgmt_tx_completion.flags &
+			     HTT_MGMT_TX_CMPL_FLAG_ACK_RSSI)) {
+				tx_done.ack_rssi =
+				FIELD_GET(HTT_MGMT_TX_CMPL_INFO_ACK_RSSI_MASK,
+					  info);
+			}
 			break;
 		case HTT_MGMT_TX_STATUS_RETRY:
 			tx_done.status = HTT_TX_COMPL_STATE_NOACK;
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 70e23bb..cda164f 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2016 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -119,6 +120,13 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 			info->flags &= ~IEEE80211_TX_STAT_ACK;
 	}
 
+	if (tx_done->status == HTT_TX_COMPL_STATE_ACK &&
+	    tx_done->ack_rssi != ATH10K_INVALID_RSSI) {
+		info->status.ack_signal = ATH10K_DEFAULT_NOISE_FLOOR +
+						tx_done->ack_rssi;
+		info->status.is_valid_ack_signal = true;
+	}
+
 	ieee80211_tx_status(htt->ar->hw, msdu);
 	/* we do not own the msdu anymore */
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index c8fc45d..191df29 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -201,6 +201,7 @@ enum wmi_service {
 	WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
 	WMI_SERVICE_HOST_DFS_CHECK_SUPPORT,
 	WMI_SERVICE_TPC_STATS_FINAL,
+	WMI_SERVICE_RESET_CHIP,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -238,6 +239,8 @@ enum wmi_10x_service {
 	WMI_10X_SERVICE_MESH,
 	WMI_10X_SERVICE_EXT_RES_CFG_SUPPORT,
 	WMI_10X_SERVICE_PEER_STATS,
+	WMI_10X_SERVICE_RESET_CHIP,
+	WMI_10X_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
 };
 
 enum wmi_main_service {
@@ -548,6 +551,10 @@ static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_EXT_RES_CFG_SUPPORT, len);
 	SVCMAP(WMI_10X_SERVICE_PEER_STATS,
 	       WMI_SERVICE_PEER_STATS, len);
+	SVCMAP(WMI_10X_SERVICE_RESET_CHIP,
+	       WMI_SERVICE_RESET_CHIP, len);
+	SVCMAP(WMI_10X_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
+	       WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS, len);
 }
 
 static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out,
-- 
2.7.4

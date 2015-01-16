Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46240 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbbAPLVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 06:21:06 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so19984828wgh.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 03:21:04 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: add support for qca6174 Rx descriptors
Date: Fri, 16 Jan 2015 12:20:36 +0100
Message-Id: <1421407237-24159-2-git-send-email-michal.kazior@tieto.com> (sfid-20150116_122112_499332_E9FF133F)
In-Reply-To: <1421407237-24159-1-git-send-email-michal.kazior@tieto.com>
References: <1421407237-24159-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The QCA6174 chip has an extra 4 bytes in
rx_ppdu_end structure which is used in htt_rx_desc
and HTT Rx ring offset setup. This is necessary
for correct Rx for QCA6174 (otherwise Rx
descriptors are overwritten and corrupted).

This means QCA988X will have an extra 4 byte
padding in Rx descriptor layout which is harmless.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  2 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h | 25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index baa1c44..143728f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -696,7 +696,7 @@ static void ath10k_htt_rx_h_mactime(struct ath10k *ar,
 	 *
 	 * FIXME: Can we get/compute 64bit TSF?
 	 */
-	status->mactime = __le32_to_cpu(rxd->ppdu_end.tsf_timestamp);
+	status->mactime = __le32_to_cpu(rxd->ppdu_end.common.tsf_timestamp);
 	status->flag |= RX_FLAG_MACTIME_END;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index e1ffdd5..e9cc778 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -850,7 +850,7 @@ struct rx_ppdu_start {
 
 #define RX_PPDU_END_INFO1_PPDU_DONE (1 << 15)
 
-struct rx_ppdu_end {
+struct rx_ppdu_end_common {
 	__le32 evm_p0;
 	__le32 evm_p1;
 	__le32 evm_p2;
@@ -873,10 +873,33 @@ struct rx_ppdu_end {
 	u8 phy_err_code;
 	__le16 flags; /* %RX_PPDU_END_FLAGS_ */
 	__le32 info0; /* %RX_PPDU_END_INFO0_ */
+} __packed;
+
+struct rx_ppdu_end_qca988x {
 	__le16 bb_length;
 	__le16 info1; /* %RX_PPDU_END_INFO1_ */
 } __packed;
 
+#define RX_PPDU_END_RTT_CORRELATION_VALUE_MASK 0x00ffffff
+#define RX_PPDU_END_RTT_CORRELATION_VALUE_LSB  0
+#define RX_PPDU_END_RTT_UNUSED_MASK            0x7f000000
+#define RX_PPDU_END_RTT_UNUSED_LSB             24
+#define RX_PPDU_END_RTT_NORMAL_MODE            BIT(31)
+
+struct rx_ppdu_end_qca6174 {
+	__le32 rtt; /* %RX_PPDU_END_RTT_ */
+	__le16 bb_length;
+	__le16 info1; /* %RX_PPDU_END_INFO1_ */
+} __packed;
+
+struct rx_ppdu_end {
+	struct rx_ppdu_end_common common;
+	union {
+		struct rx_ppdu_end_qca988x qca988x;
+		struct rx_ppdu_end_qca6174 qca6174;
+	} __packed;
+} __packed;
+
 /*
  * evm_p0
  *		EVM for pilot 0.  Contain EVM for streams: 0, 1, 2 and 3.
-- 
1.8.5.3


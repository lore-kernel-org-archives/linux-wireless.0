Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26057 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbcDTPAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 11:00:34 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 3/4] ath10k: Define rx_ppdu_end for QCA9984
Date: Wed, 20 Apr 2016 20:29:15 +0530
Message-ID: <1461164356-9158-4-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160420_170037_135128_3C927E77)
In-Reply-To: <1461164356-9158-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1461164356-9158-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

QCA9984 Rx descriptor has two 32-bit words of location information
when compared to one 32-bit word in QCA99X0. To handle this difference in
rx descriptor ppdu_end, define a new ppdu_end for QCA9984 descriptor
which has the new structure to represent rx_location_info.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/rx_desc.h | 46 +++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index 3e7dfaa..9ceebea 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -996,6 +996,41 @@ struct rx_pkt_end {
 	__le32 phy_timestamp_2;
 } __packed;
 
+#define RX_LOCATION_INFO0_RTT_FAC_LEGACY_MASK		0x00003fff
+#define RX_LOCATION_INFO0_RTT_FAC_LEGACY_LSB		0
+#define RX_LOCATION_INFO0_RTT_FAC_VHT_MASK		0x1fff8000
+#define RX_LOCATION_INFO0_RTT_FAC_VHT_LSB		15
+#define RX_LOCATION_INFO0_RTT_STRONGEST_CHAIN_MASK	0xc0000000
+#define RX_LOCATION_INFO0_RTT_STRONGEST_CHAIN_LSB	30
+#define RX_LOCATION_INFO0_RTT_FAC_LEGACY_STATUS		BIT(14)
+#define RX_LOCATION_INFO0_RTT_FAC_VHT_STATUS		BIT(29)
+
+#define RX_LOCATION_INFO1_RTT_PREAMBLE_TYPE_MASK	0x0000000c
+#define RX_LOCATION_INFO1_RTT_PREAMBLE_TYPE_LSB		2
+#define RX_LOCATION_INFO1_PKT_BW_MASK			0x00000030
+#define RX_LOCATION_INFO1_PKT_BW_LSB			4
+#define RX_LOCATION_INFO1_SKIP_P_SKIP_BTCF_MASK		0x0000ff00
+#define RX_LOCATION_INFO1_SKIP_P_SKIP_BTCF_LSB		8
+#define RX_LOCATION_INFO1_RTT_MSC_RATE_MASK		0x000f0000
+#define RX_LOCATION_INFO1_RTT_MSC_RATE_LSB		16
+#define RX_LOCATION_INFO1_RTT_PBD_LEG_BW_MASK		0x00300000
+#define RX_LOCATION_INFO1_RTT_PBD_LEG_BW_LSB		20
+#define RX_LOCATION_INFO1_TIMING_BACKOFF_MASK		0x07c00000
+#define RX_LOCATION_INFO1_TIMING_BACKOFF_LSB		22
+#define RX_LOCATION_INFO1_RTT_TX_FRAME_PHASE_MASK	0x18000000
+#define RX_LOCATION_INFO1_RTT_TX_FRAME_PHASE_LSB	27
+#define RX_LOCATION_INFO1_RTT_CFR_STATUS		BIT(0)
+#define RX_LOCATION_INFO1_RTT_CIR_STATUS		BIT(1)
+#define RX_LOCATION_INFO1_RTT_GI_TYPE			BIT(7)
+#define RX_LOCATION_INFO1_RTT_MAC_PHY_PHASE		BIT(29)
+#define RX_LOCATION_INFO1_RTT_TX_DATA_START_X_PHASE	BIT(30)
+#define RX_LOCATION_INFO1_RX_LOCATION_VALID		BIT(31)
+
+struct rx_location_info {
+	__le32 rx_location_info0; /* %RX_LOCATION_INFO0_ */
+	__le32 rx_location_info1; /* %RX_LOCATION_INFO1_ */
+} __packed;
+
 enum rx_phy_ppdu_end_info0 {
 	RX_PHY_PPDU_END_INFO0_ERR_RADAR           = BIT(2),
 	RX_PHY_PPDU_END_INFO0_ERR_RX_ABORT        = BIT(3),
@@ -1074,12 +1109,23 @@ struct rx_ppdu_end_qca99x0 {
 	__le16 info1; /* %RX_PPDU_END_INFO1_ */
 } __packed;
 
+struct rx_ppdu_end_qca9984 {
+	struct rx_pkt_end rx_pkt_end;
+	struct rx_location_info rx_location_info;
+	struct rx_phy_ppdu_end rx_phy_ppdu_end;
+	__le32 rx_timing_offset; /* %RX_PPDU_END_RX_TIMING_OFFSET_ */
+	__le32 rx_info; /* %RX_PPDU_END_RX_INFO_ */
+	__le16 bb_length;
+	__le16 info1; /* %RX_PPDU_END_INFO1_ */
+} __packed;
+
 struct rx_ppdu_end {
 	struct rx_ppdu_end_common common;
 	union {
 		struct rx_ppdu_end_qca988x qca988x;
 		struct rx_ppdu_end_qca6174 qca6174;
 		struct rx_ppdu_end_qca99x0 qca99x0;
+		struct rx_ppdu_end_qca9984 qca9984;
 	} __packed;
 } __packed;
 
-- 
1.9.1


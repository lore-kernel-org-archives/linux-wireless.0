Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29213 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbGMR4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 13:56:15 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 3/3] ath10k: add support for qca99x0 Rx descriptors
Date: Mon, 13 Jul 2015 10:54:08 -0700
Message-ID: <ebd66548f8598a0c45c5bc9f2f7895910248ecee.1436809751.git.poh@qca.qualcomm.com> (sfid-20150713_195618_428051_1450CFB5)
In-Reply-To: <cover.1436809751.git.poh@qca.qualcomm.com>
References: <cover.1436809751.git.poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

QCA99X0 chip has an extra 4 bytes in rx_msdu_start,
20 bytes in rx_msdu_end and 20 bytes in rx_ppdu_end structure
which are used in htt_rx_desc and HTT Rx ring offset setup.
This is necessary for correct Rx for QCA99X0 or Rx descriptors
will be overwritten and corrupted.

With this patch QCA988X and QCA6174 will have extra 44 bytes
padding in Rx descriptor layout which is harmless.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  24 ++---
 drivers/net/wireless/ath/ath10k/rx_desc.h | 163 +++++++++++++++++++++++++++++-
 2 files changed, 172 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index d7d1183..61a2626 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -368,7 +368,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 		msdu_len_invalid = !!(__le32_to_cpu(rx_desc->attention.flags)
 					& (RX_ATTENTION_FLAGS_MPDU_LENGTH_ERR |
 					   RX_ATTENTION_FLAGS_MSDU_LENGTH_ERR));
-		msdu_len = MS(__le32_to_cpu(rx_desc->msdu_start.info0),
+		msdu_len = MS(__le32_to_cpu(rx_desc->msdu_start.common.info0),
 			      RX_MSDU_START_INFO0_MSDU_LENGTH);
 		msdu_chained = rx_desc->frag_info.ring2_more_count;
 
@@ -394,7 +394,7 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 			msdu_chaining = 1;
 		}
 
-		last_msdu = __le32_to_cpu(rx_desc->msdu_end.info0) &
+		last_msdu = __le32_to_cpu(rx_desc->msdu_end.common.info0) &
 				RX_MSDU_END_INFO0_LAST_MSDU;
 
 		trace_ath10k_htt_rx_desc(ar, &rx_desc->attention,
@@ -740,7 +740,7 @@ ath10k_htt_rx_h_peer_channel(struct ath10k *ar, struct htt_rx_desc *rxd)
 	    __cpu_to_le32(RX_ATTENTION_FLAGS_PEER_IDX_INVALID))
 		return NULL;
 
-	if (!(rxd->msdu_end.info0 &
+	if (!(rxd->msdu_end.common.info0 &
 	      __cpu_to_le32(RX_MSDU_END_INFO0_FIRST_MSDU)))
 		return NULL;
 
@@ -991,9 +991,9 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 	bool is_last;
 
 	rxd = (void *)msdu->data - sizeof(*rxd);
-	is_first = !!(rxd->msdu_end.info0 &
+	is_first = !!(rxd->msdu_end.common.info0 &
 		      __cpu_to_le32(RX_MSDU_END_INFO0_FIRST_MSDU));
-	is_last = !!(rxd->msdu_end.info0 &
+	is_last = !!(rxd->msdu_end.common.info0 &
 		     __cpu_to_le32(RX_MSDU_END_INFO0_LAST_MSDU));
 
 	/* Delivered decapped frame:
@@ -1104,9 +1104,9 @@ static void *ath10k_htt_rx_h_find_rfc1042(struct ath10k *ar,
 	rxd = (void *)msdu->data - sizeof(*rxd);
 	hdr = (void *)rxd->rx_hdr_status;
 
-	is_first = !!(rxd->msdu_end.info0 &
+	is_first = !!(rxd->msdu_end.common.info0 &
 		      __cpu_to_le32(RX_MSDU_END_INFO0_FIRST_MSDU));
-	is_last = !!(rxd->msdu_end.info0 &
+	is_last = !!(rxd->msdu_end.common.info0 &
 		     __cpu_to_le32(RX_MSDU_END_INFO0_LAST_MSDU));
 	is_amsdu = !(is_first && is_last);
 
@@ -1214,7 +1214,7 @@ static void ath10k_htt_rx_h_undecap(struct ath10k *ar,
 	 */
 
 	rxd = (void *)msdu->data - sizeof(*rxd);
-	decap = MS(__le32_to_cpu(rxd->msdu_start.info1),
+	decap = MS(__le32_to_cpu(rxd->msdu_start.common.info1),
 		   RX_MSDU_START_INFO1_DECAP_FORMAT);
 
 	switch (decap) {
@@ -1244,7 +1244,7 @@ static int ath10k_htt_rx_get_csum_state(struct sk_buff *skb)
 
 	rxd = (void *)skb->data - sizeof(*rxd);
 	flags = __le32_to_cpu(rxd->attention.flags);
-	info = __le32_to_cpu(rxd->msdu_start.info1);
+	info = __le32_to_cpu(rxd->msdu_start.common.info1);
 
 	is_ip4 = !!(info & RX_MSDU_START_INFO1_IPV4_PROTO);
 	is_ip6 = !!(info & RX_MSDU_START_INFO1_IPV6_PROTO);
@@ -1437,7 +1437,7 @@ static void ath10k_htt_rx_h_unchain(struct ath10k *ar,
 
 	first = skb_peek(amsdu);
 	rxd = (void *)first->data - sizeof(*rxd);
-	decap = MS(__le32_to_cpu(rxd->msdu_start.info1),
+	decap = MS(__le32_to_cpu(rxd->msdu_start.common.info1),
 		   RX_MSDU_START_INFO1_DECAP_FORMAT);
 
 	if (!chained)
@@ -1757,14 +1757,14 @@ static int ath10k_htt_rx_extract_amsdu(struct sk_buff_head *list,
 		__skb_queue_tail(amsdu, msdu);
 
 		rxd = (void *)msdu->data - sizeof(*rxd);
-		if (rxd->msdu_end.info0 &
+		if (rxd->msdu_end.common.info0 &
 		    __cpu_to_le32(RX_MSDU_END_INFO0_LAST_MSDU))
 			break;
 	}
 
 	msdu = skb_peek_tail(amsdu);
 	rxd = (void *)msdu->data - sizeof(*rxd);
-	if (!(rxd->msdu_end.info0 &
+	if (!(rxd->msdu_end.common.info0 &
 	      __cpu_to_le32(RX_MSDU_END_INFO0_LAST_MSDU))) {
 		skb_queue_splice_init(amsdu, list);
 		return -EAGAIN;
diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index 6cb078d..ca8d168 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -422,6 +422,12 @@ struct rx_mpdu_end {
 #define RX_MSDU_START_INFO1_IP_FRAG             (1 << 14)
 #define RX_MSDU_START_INFO1_TCP_ONLY_ACK        (1 << 15)
 
+#define RX_MSDU_START_INFO2_DA_IDX_MASK         0x000007ff
+#define RX_MSDU_START_INFO2_DA_IDX_LSB          0
+#define RX_MSDU_START_INFO2_IP_PROTO_FIELD_MASK 0x00ff0000
+#define RX_MSDU_START_INFO2_IP_PROTO_FIELD_LSB  16
+#define RX_MSDU_START_INFO2_DA_BCAST_MCAST      BIT(11)
+
 /* The decapped header (rx_hdr_status) contains the following:
  *  a) 802.11 header
  *  [padding to 4 bytes]
@@ -449,12 +455,23 @@ enum rx_msdu_decap_format {
 	RX_MSDU_DECAP_8023_SNAP_LLC = 3
 };
 
-struct rx_msdu_start {
+struct rx_msdu_start_common {
 	__le32 info0; /* %RX_MSDU_START_INFO0_ */
 	__le32 flow_id_crc;
 	__le32 info1; /* %RX_MSDU_START_INFO1_ */
 } __packed;
 
+struct rx_msdu_start_qca99x0 {
+	__le32 info2; /* %RX_MSDU_START_INFO2_ */
+} __packed;
+
+struct rx_msdu_start {
+	struct rx_msdu_start_common common;
+	union {
+		struct rx_msdu_start_qca99x0 qca99x0;
+	} __packed;
+} __packed;
+
 /*
  * msdu_length
  *		MSDU length in bytes after decapsulation.  This field is
@@ -540,7 +557,7 @@ struct rx_msdu_start {
 #define RX_MSDU_END_INFO0_PRE_DELIM_ERR             (1 << 30)
 #define RX_MSDU_END_INFO0_RESERVED_3B               (1 << 31)
 
-struct rx_msdu_end {
+struct rx_msdu_end_common {
 	__le16 ip_hdr_cksum;
 	__le16 tcp_hdr_cksum;
 	u8 key_id_octet;
@@ -549,6 +566,36 @@ struct rx_msdu_end {
 	__le32 info0;
 } __packed;
 
+#define RX_MSDU_END_INFO1_TCP_FLAG_MASK     0x000001ff
+#define RX_MSDU_END_INFO1_TCP_FLAG_LSB      0
+#define RX_MSDU_END_INFO1_L3_HDR_PAD_MASK   0x00001c00
+#define RX_MSDU_END_INFO1_L3_HDR_PAD_LSB    10
+#define RX_MSDU_END_INFO1_WINDOW_SIZE_MASK  0xffff0000
+#define RX_MSDU_END_INFO1_WINDOW_SIZE_LSB   16
+#define RX_MSDU_END_INFO1_IRO_ELIGIBLE      BIT(9)
+
+#define RX_MSDU_END_INFO2_DA_OFFSET_MASK    0x0000003f
+#define RX_MSDU_END_INFO2_DA_OFFSET_LSB     0
+#define RX_MSDU_END_INFO2_SA_OFFSET_MASK    0x00000fc0
+#define RX_MSDU_END_INFO2_SA_OFFSET_LSB     6
+#define RX_MSDU_END_INFO2_TYPE_OFFSET_MASK  0x0003f000
+#define RX_MSDU_END_INFO2_TYPE_OFFSET_LSB   12
+
+struct rx_msdu_end_qca99x0 {
+	__le32 ipv6_crc;
+	__le32 tcp_seq_no;
+	__le32 tcp_ack_no;
+	__le32 info1;
+	__le32 info2;
+} __packed;
+
+struct rx_msdu_end {
+	struct rx_msdu_end_common common;
+	union {
+		struct rx_msdu_end_qca99x0 qca99x0;
+	} __packed;
+} __packed;
+
 /*
  *ip_hdr_chksum
  *		This can include the IP header checksum or the pseudo header
@@ -870,7 +917,11 @@ struct rx_ppdu_start {
 #define RX_PPDU_END_INFO0_FLAGS_TX_HT_VHT_ACK (1 << 24)
 #define RX_PPDU_END_INFO0_BB_CAPTURED_CHANNEL (1 << 25)
 
-#define RX_PPDU_END_INFO1_PPDU_DONE (1 << 15)
+#define RX_PPDU_END_INFO1_PEER_IDX_MASK       0x1ffc
+#define RX_PPDU_END_INFO1_PEER_IDX_LSB        2
+#define RX_PPDU_END_INFO1_BB_DATA             BIT(0)
+#define RX_PPDU_END_INFO1_PEER_IDX_VALID      BIT(1)
+#define RX_PPDU_END_INFO1_PPDU_DONE           BIT(15)
 
 struct rx_ppdu_end_common {
 	__le32 evm_p0;
@@ -918,11 +969,117 @@ struct rx_ppdu_end_qca6174 {
 	__le16 info1; /* %RX_PPDU_END_INFO1_ */
 } __packed;
 
+#define RX_PKT_END_INFO0_RX_SUCCESS              BIT(0)
+#define RX_PKT_END_INFO0_ERR_TX_INTERRUPT_RX     BIT(3)
+#define RX_PKT_END_INFO0_ERR_OFDM_POWER_DROP     BIT(4)
+#define RX_PKT_END_INFO0_ERR_OFDM_RESTART        BIT(5)
+#define RX_PKT_END_INFO0_ERR_CCK_POWER_DROP      BIT(6)
+#define RX_PKT_END_INFO0_ERR_CCK_RESTART         BIT(7)
+
+#define RX_LOCATION_INFO_RTT_CORR_VAL_MASK       0x0001ffff
+#define RX_LOCATION_INFO_RTT_CORR_VAL_LSB        0
+#define RX_LOCATION_INFO_FAC_STATUS_MASK         0x000c0000
+#define RX_LOCATION_INFO_FAC_STATUS_LSB          18
+#define RX_LOCATION_INFO_PKT_BW_MASK             0x00700000
+#define RX_LOCATION_INFO_PKT_BW_LSB              20
+#define RX_LOCATION_INFO_RTT_TX_FRAME_PHASE_MASK 0x01800000
+#define RX_LOCATION_INFO_RTT_TX_FRAME_PHASE_LSB  23
+#define RX_LOCATION_INFO_CIR_STATUS              BIT(17)
+#define RX_LOCATION_INFO_RTT_MAC_PHY_PHASE       BIT(25)
+#define RX_LOCATION_INFO_RTT_TX_DATA_START_X     BIT(26)
+#define RX_LOCATION_INFO_HW_IFFT_MODE            BIT(30)
+#define RX_LOCATION_INFO_RX_LOCATION_VALID       BIT(31)
+
+struct rx_pkt_end {
+	__le32 info0; /* %RX_PKT_END_INFO0_ */
+	__le32 phy_timestamp_1;
+	__le32 phy_timestamp_2;
+	__le32 rx_location_info; /* %RX_LOCATION_INFO_ */
+} __packed;
+
+enum rx_phy_ppdu_end_info0 {
+	RX_PHY_PPDU_END_INFO0_ERR_RADAR           = BIT(2),
+	RX_PHY_PPDU_END_INFO0_ERR_RX_ABORT        = BIT(3),
+	RX_PHY_PPDU_END_INFO0_ERR_RX_NAP          = BIT(4),
+	RX_PHY_PPDU_END_INFO0_ERR_OFDM_TIMING     = BIT(5),
+	RX_PHY_PPDU_END_INFO0_ERR_OFDM_PARITY     = BIT(6),
+	RX_PHY_PPDU_END_INFO0_ERR_OFDM_RATE       = BIT(7),
+	RX_PHY_PPDU_END_INFO0_ERR_OFDM_LENGTH     = BIT(8),
+	RX_PHY_PPDU_END_INFO0_ERR_OFDM_RESTART    = BIT(9),
+	RX_PHY_PPDU_END_INFO0_ERR_OFDM_SERVICE    = BIT(10),
+	RX_PHY_PPDU_END_INFO0_ERR_OFDM_POWER_DROP = BIT(11),
+	RX_PHY_PPDU_END_INFO0_ERR_CCK_BLOCKER     = BIT(12),
+	RX_PHY_PPDU_END_INFO0_ERR_CCK_TIMING      = BIT(13),
+	RX_PHY_PPDU_END_INFO0_ERR_CCK_HEADER_CRC  = BIT(14),
+	RX_PHY_PPDU_END_INFO0_ERR_CCK_RATE        = BIT(15),
+	RX_PHY_PPDU_END_INFO0_ERR_CCK_LENGTH      = BIT(16),
+	RX_PHY_PPDU_END_INFO0_ERR_CCK_RESTART     = BIT(17),
+	RX_PHY_PPDU_END_INFO0_ERR_CCK_SERVICE     = BIT(18),
+	RX_PHY_PPDU_END_INFO0_ERR_CCK_POWER_DROP  = BIT(19),
+	RX_PHY_PPDU_END_INFO0_ERR_HT_CRC          = BIT(20),
+	RX_PHY_PPDU_END_INFO0_ERR_HT_LENGTH       = BIT(21),
+	RX_PHY_PPDU_END_INFO0_ERR_HT_RATE         = BIT(22),
+	RX_PHY_PPDU_END_INFO0_ERR_HT_ZLF          = BIT(23),
+	RX_PHY_PPDU_END_INFO0_ERR_FALSE_RADAR_EXT = BIT(24),
+	RX_PHY_PPDU_END_INFO0_ERR_GREEN_FIELD     = BIT(25),
+	RX_PHY_PPDU_END_INFO0_ERR_SPECTRAL_SCAN   = BIT(26),
+	RX_PHY_PPDU_END_INFO0_ERR_RX_DYN_BW       = BIT(27),
+	RX_PHY_PPDU_END_INFO0_ERR_LEG_HT_MISMATCH = BIT(28),
+	RX_PHY_PPDU_END_INFO0_ERR_VHT_CRC         = BIT(29),
+	RX_PHY_PPDU_END_INFO0_ERR_VHT_SIGA        = BIT(30),
+	RX_PHY_PPDU_END_INFO0_ERR_VHT_LSIG        = BIT(31),
+};
+
+enum rx_phy_ppdu_end_info1 {
+	RX_PHY_PPDU_END_INFO1_ERR_VHT_NDP            = BIT(0),
+	RX_PHY_PPDU_END_INFO1_ERR_VHT_NSYM           = BIT(1),
+	RX_PHY_PPDU_END_INFO1_ERR_VHT_RX_EXT_SYM     = BIT(2),
+	RX_PHY_PPDU_END_INFO1_ERR_VHT_RX_SKIP_ID0    = BIT(3),
+	RX_PHY_PPDU_END_INFO1_ERR_VHT_RX_SKIP_ID1_62 = BIT(4),
+	RX_PHY_PPDU_END_INFO1_ERR_VHT_RX_SKIP_ID63   = BIT(5),
+	RX_PHY_PPDU_END_INFO1_ERR_OFDM_LDPC_DECODER  = BIT(6),
+	RX_PHY_PPDU_END_INFO1_ERR_DEFER_NAP          = BIT(7),
+	RX_PHY_PPDU_END_INFO1_ERR_FDOMAIN_TIMEOUT    = BIT(8),
+	RX_PHY_PPDU_END_INFO1_ERR_LSIG_REL_CHECK     = BIT(9),
+	RX_PHY_PPDU_END_INFO1_ERR_BT_COLLISION       = BIT(10),
+	RX_PHY_PPDU_END_INFO1_ERR_MU_FEEDBACK        = BIT(11),
+	RX_PHY_PPDU_END_INFO1_ERR_TX_INTERRUPT_RX    = BIT(12),
+	RX_PHY_PPDU_END_INFO1_ERR_RX_CBF             = BIT(13),
+};
+
+struct rx_phy_ppdu_end {
+	__le32 info0; /* %RX_PHY_PPDU_END_INFO0_ */
+	__le32 info1; /* %RX_PHY_PPDU_END_INFO1_ */
+} __packed;
+
+#define RX_PPDU_END_RX_TIMING_OFFSET_MASK          0x00000fff
+#define RX_PPDU_END_RX_TIMING_OFFSET_LSB           0
+
+#define RX_PPDU_END_RX_INFO_RX_ANTENNA_MASK        0x00ffffff
+#define RX_PPDU_END_RX_INFO_RX_ANTENNA_LSB         0
+#define RX_PPDU_END_RX_INFO_TX_HT_VHT_ACK          BIT(24)
+#define RX_PPDU_END_RX_INFO_RX_PKT_END_VALID       BIT(25)
+#define RX_PPDU_END_RX_INFO_RX_PHY_PPDU_END_VALID  BIT(26)
+#define RX_PPDU_END_RX_INFO_RX_TIMING_OFFSET_VALID BIT(27)
+#define RX_PPDU_END_RX_INFO_BB_CAPTURED_CHANNEL    BIT(28)
+#define RX_PPDU_END_RX_INFO_UNSUPPORTED_MU_NC      BIT(29)
+#define RX_PPDU_END_RX_INFO_OTP_TXBF_DISABLE       BIT(30)
+
+struct rx_ppdu_end_qca99x0 {
+	struct rx_pkt_end rx_pkt_end;
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
+		struct rx_ppdu_end_qca99x0 qca99x0;
 	} __packed;
 } __packed;
 
-- 
1.9.1


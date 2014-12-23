Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21144 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbaLWHsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:35 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 20/22] wil6210: Tx/Rx descriptors documentation
Date: Tue, 23 Dec 2014 09:47:22 +0200
Message-Id: <1419320844-23989-21-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091348_340945_F14942F3)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sync documentation for the Tx/Rx descriptors with the
firmware/hardware documentation.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c |   2 +-
 drivers/net/wireless/ath/wil6210/txrx.h | 149 +++++++++++++++++++++-----------
 2 files changed, 98 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 5fc5f56..b58ee52 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -463,7 +463,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	 * and in case of error drop the packet
 	 * higher stack layers will handle retransmission (if required)
 	 */
-	if (d->dma.status & RX_DMA_STATUS_L4_IDENT) {
+	if (d->dma.status & RX_DMA_STATUS_L4I) {
 		/* L4 protocol identified, csum calculated */
 		if ((d->dma.error & RX_DMA_ERROR_L4_ERR) == 0)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index c906c5f0..d90c8aa 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -28,9 +28,7 @@
 
 /* Tx/Rx path */
 
-/*
- * Common representation of physical address in Vring
- */
+/* Common representation of physical address in Vring */
 struct vring_dma_addr {
 	__le32 addr_low;
 	__le16 addr_high;
@@ -49,11 +47,10 @@ static inline void wil_desc_addr_set(struct vring_dma_addr *addr,
 	addr->addr_high = cpu_to_le16((u16)upper_32_bits(pa));
 }
 
-/*
- * Tx descriptor - MAC part
+/* Tx descriptor - MAC part
  * [dword 0]
  * bit  0.. 9 : lifetime_expiry_value:10
- * bit     10 : interrup_en:1
+ * bit     10 : interrupt_en:1
  * bit     11 : status_en:1
  * bit 12..13 : txss_override:2
  * bit     14 : timestamp_insertion:1
@@ -61,15 +58,12 @@ static inline void wil_desc_addr_set(struct vring_dma_addr *addr,
  * bit 16..21 : reserved0:6
  * bit 22..26 : mcs_index:5
  * bit     27 : mcs_en:1
- * bit 28..29 : reserved1:2
- * bit     30 : reserved2:1
+ * bit 28..30 : reserved1:3
  * bit     31 : sn_preserved:1
  * [dword 1]
  * bit  0.. 3 : pkt_mode:4
  * bit      4 : pkt_mode_en:1
- * bit  5.. 7 : reserved0:3
- * bit  8..13 : reserved1:6
- * bit     14 : reserved2:1
+ * bit  5..14 : reserved0:10
  * bit     15 : ack_policy_en:1
  * bit 16..19 : dst_index:4
  * bit     20 : dst_index_en:1
@@ -80,7 +74,7 @@ static inline void wil_desc_addr_set(struct vring_dma_addr *addr,
  * [dword 2]
  * bit  0.. 7 : num_of_descriptors:8
  * bit  8..17 : reserved:10
- * bit 18..19 : l2_translation_type:2
+ * bit 18..19 : l2_translation_type:2 00 - bypass, 01 - 802.3, 10 - 802.11
  * bit     20 : snap_hdr_insertion_en:1
  * bit     21 : vlan_removal_en:1
  * bit 22..31 : reserved0:10
@@ -247,6 +241,46 @@ struct vring_tx_mac {
 
 #define TX_DMA_STATUS_DU         BIT(0)
 
+/* Tx descriptor - DMA part
+ * [dword 0]
+ * bit  0.. 7 : l4_length:8 layer 4 length
+ * bit      8 : cmd_eop:1 This descriptor is the last one in the packet
+ * bit      9 : reserved
+ * bit     10 : cmd_dma_it:1 immediate interrupt
+ * bit 11..12 : SBD - Segment Buffer Details
+ *		00 - Header Segment
+ *		01 - First Data Segment
+ *		10 - Medium Data Segment
+ *		11 - Last Data Segment
+ * bit     13 : TSE - TCP Segmentation Enable
+ * bit     14 : IIC - Directs the HW to Insert IPv4 Checksum
+ * bit     15 : ITC - Directs the HW to Insert TCP/UDP Checksum
+ * bit 16..20 : QID - The target QID that the packet should be stored
+ *		in the MAC.
+ * bit     21 : PO - Pseudo header Offload:
+ *		0 - Use the pseudo header value from the TCP checksum field
+ *		1- Calculate Pseudo header Checksum
+ * bit     22 : NC - No UDP Checksum
+ * bit 23..29 : reserved
+ * bit 30..31 : L4T - Layer 4 Type: 00 - UDP , 10 - TCP , 10, 11 - Reserved
+ *		If L4Len equal 0, no L4 at all
+ * [dword 1]
+ * bit  0..31 : addr_low:32 The payload buffer low address
+ * [dword 2]
+ * bit  0..15 : addr_high:16 The payload buffer high address
+ * bit 16..23 : ip_length:8 The IP header length for the TX IP checksum
+ *		offload feature
+ * bit 24..30 : mac_length:7
+ * bit     31 : ip_version:1 1 - IPv4, 0 - IPv6
+ * [dword 3]
+ *  [byte 12] error
+ * bit  0   2 : mac_status:3
+ * bit  3   7 : reserved:5
+ *  [byte 13] status
+ * bit      0 : DU:1 Descriptor Used
+ * bit  1   7 : reserved:7
+ *  [word 7] length
+ */
 struct vring_tx_dma {
 	u32 d0;
 	struct vring_dma_addr addr;
@@ -257,45 +291,45 @@ struct vring_tx_dma {
 	__le16 length;
 } __packed;
 
-/*
- * Rx descriptor - MAC part
+/* Rx descriptor - MAC part
  * [dword 0]
  * bit  0.. 3 : tid:4 The QoS (b3-0) TID Field
- * bit  4.. 6 : connection_id:3 :The Source index that  was found during
- *  Parsing the TA.  This field is used to  define the source of the packet
+ * bit  4.. 6 : cid:3 The Source index that  was found during parsing the TA.
+ *		This field is used to define the source of the packet
  * bit      7 : reserved:1
- * bit  8.. 9 : mac_id:2 : The MAC virtual  Ring number (always zero)
- * bit 10..11 : frame_type:2 : The FC Control  (b3-2) -  MPDU Type
- *              (management, data, control  and extension)
- * bit 12..15 : frame_subtype:4 : The FC Control  (b7-4) -  Frame Subtype
+ * bit  8.. 9 : mid:2 The MAC virtual number
+ * bit 10..11 : frame_type:2 : The FC (b3-2) - MPDU Type
+ *		(management, data, control and extension)
+ * bit 12..15 : frame_subtype:4 : The FC (b7-4) - Frame Subtype
  * bit 16..27 : seq_number:12 The received Sequence number field
  * bit 28..31 : extended:4 extended subtype
  * [dword 1]
  * bit  0.. 3 : reserved
  * bit  4.. 5 : key_id:2
  * bit      6 : decrypt_bypass:1
- * bit      7 : security:1
- * bit  8.. 9 : ds_bits:2
- * bit     10 : a_msdu_present:1  from qos header
- * bit     11 : a_msdu_type:1  from qos header
+ * bit      7 : security:1 FC (b14)
+ * bit  8.. 9 : ds_bits:2 FC (b9-8)
+ * bit     10 : a_msdu_present:1  QoS (b7)
+ * bit     11 : a_msdu_type:1  QoS (b8)
  * bit     12 : a_mpdu:1  part of AMPDU aggregation
  * bit     13 : broadcast:1
  * bit     14 : mutlicast:1
  * bit     15 : reserved:1
- * bit 16..20 : rx_mac_qid:5   The Queue Identifier that the packet
- *                             is received from
+ * bit 16..20 : rx_mac_qid:5 The Queue Identifier that the packet
+ *		is received from
  * bit 21..24 : mcs:4
- * bit 25..28 : mic_icr:4
+ * bit 25..28 : mic_icr:4 this signal tells the DMA to assert an interrupt
+ *		after it writes the packet
  * bit 29..31 : reserved:3
  * [dword 2]
  * bit  0.. 2 : time_slot:3 The timeslot that the MPDU is received
- * bit      3 : fc_protocol_ver:1 The FC Control  (b0) - Protocol  Version
- * bit      4 : fc_order:1 The FC Control (b15) -Order
- * bit  5.. 7 : qos_ack_policy:3  The QoS (b6-5) ack policy Field
+ * bit  3.. 4 : fc_protocol_ver:1 The FC (b1-0) - Protocol Version
+ * bit      5 : fc_order:1 The FC Control (b15) -Order
+ * bit  6.. 7 : qos_ack_policy:2 The QoS (b6-5) ack policy Field
  * bit      8 : esop:1 The QoS (b4) ESOP field
- * bit      9 : qos_rdg_more_ppdu:1 The QoS (b9) RDG  field
- * bit 10..14 : qos_reserved:5 The QoS (b14-10) Reserved  field
- * bit     15 : qos_ac_constraint:1
+ * bit      9 : qos_rdg_more_ppdu:1 The QoS (b9) RDG field
+ * bit 10..14 : qos_reserved:5 The QoS (b14-10) Reserved field
+ * bit     15 : qos_ac_constraint:1 QoS (b15)
  * bit 16..31 : pn_15_0:16 low 2 bytes of PN
  * [dword 3]
  * bit  0..31 : pn_47_16:32 high 4 bytes of PN
@@ -308,35 +342,46 @@ struct vring_rx_mac {
 	u32 pn_47_16;
 } __packed;
 
-/*
- * Rx descriptor - DMA part
+/* Rx descriptor - DMA part
  * [dword 0]
- * bit  0.. 7 : l4_length:8 layer 4 length
- * bit  8.. 9 : reserved:2
- * bit     10 : cmd_dma_it:1
+ * bit  0.. 7 : l4_length:8 layer 4 length. The field is only valid if
+ *		L4I bit is set
+ * bit      8 : cmd_eop:1 set to 1
+ * bit      9 : cmd_rt:1 set to 1
+ * bit     10 : cmd_dma_it:1 immediate interrupt
  * bit 11..15 : reserved:5
- * bit 16..29 : phy_info_length:14
+ * bit 16..29 : phy_info_length:14 It is valid when the PII is set.
+ *		When the FFM bit is set bits 29-27 are used for for
+ *		Flex Filter Match. Matching Index to one of the L2
+ *		EtherType Flex Filter
  * bit 30..31 : l4_type:2 valid if the L4I bit is set in the status field
+ *		00 - UDP, 01 - TCP, 10, 11 - reserved
  * [dword 1]
  * bit  0..31 : addr_low:32 The payload buffer low address
  * [dword 2]
  * bit  0..15 : addr_high:16 The payload buffer high address
- * bit 16..23 : ip_length:8
+ * bit 16..23 : ip_length:8 The filed is valid only if the L3I bit is set
  * bit 24..30 : mac_length:7
- * bit     31 : ip_version:1
+ * bit     31 : ip_version:1 1 - IPv4, 0 - IPv6
  * [dword 3]
  *  [byte 12] error
+ * bit      0 : FCS:1
+ * bit      1 : MIC:1
+ * bit      2 : Key miss:1
+ * bit      3 : Replay:1
+ * bit      4 : L3:1 IPv4 checksum
+ * bit      5 : L4:1 TCP/UDP checksum
+ * bit  6   7 : reserved:2
  *  [byte 13] status
- * bit      0 : du:1
- * bit      1 : eop:1
+ * bit      0 : DU:1 Descriptor Used
+ * bit      1 : EOP:1 The descriptor indicates the End of Packet
  * bit      2 : error:1
- * bit      3 : mi:1
- * bit      4 : l3_identified:1
- * bit      5 : l4_identified:1
- * bit      6 : phy_info_included:1
- * bit      7 : reserved:1
+ * bit      3 : MI:1 MAC Interrupt is asserted (according to parser decision)
+ * bit      4 : L3I:1 L3 identified and checksum calculated
+ * bit      5 : L4I:1 L4 identified and checksum calculated
+ * bit      6 : PII:1 PHY Info Included in the packet
+ * bit      7 : FFM:1 EtherType Flex Filter Match
  *  [word 7] length
- *
  */
 
 #define RX_DMA_D0_CMD_DMA_IT     BIT(10)
@@ -349,9 +394,9 @@ struct vring_rx_mac {
 #define RX_DMA_STATUS_DU         BIT(0)
 #define RX_DMA_STATUS_ERROR      BIT(2)
 
-#define RX_DMA_STATUS_L3_IDENT   BIT(4)
-#define RX_DMA_STATUS_L4_IDENT   BIT(5)
-#define RX_DMA_STATUS_PHY_INFO   BIT(6)
+#define RX_DMA_STATUS_L3I	BIT(4)
+#define RX_DMA_STATUS_L4I	BIT(5)
+#define RX_DMA_STATUS_PHY_INFO	BIT(6)
 
 struct vring_rx_dma {
 	u32 d0;
-- 
2.1.0


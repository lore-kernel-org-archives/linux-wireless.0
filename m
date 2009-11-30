Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45410 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZK3Rbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:31:55 -0500
Date: Mon, 30 Nov 2009 18:32:00 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 04/11] mwl8k: inline qos field manipulation functions
Message-ID: <20091130173200.GT20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   51 ++++++++---------------------------------
 1 files changed, 10 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9a60381..df26414 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -659,35 +659,6 @@ struct peer_capability_info {
 	__le16	amsdu_enabled;
 } __attribute__((packed));
 
-/* Inline functions to manipulate QoS field in data descriptor.  */
-static inline u16 mwl8k_qos_setbit_eosp(u16 qos)
-{
-	u16 val_mask = 1 << 4;
-
-	/* End of Service Period Bit 4 */
-	return qos | val_mask;
-}
-
-static inline u16 mwl8k_qos_setbit_ack(u16 qos, u8 ack_policy)
-{
-	u16 val_mask = 0x3;
-	u8	shift = 5;
-	u16 qos_mask = ~(val_mask << shift);
-
-	/* Ack Policy Bit 5-6 */
-	return (qos & qos_mask) | ((ack_policy & val_mask) << shift);
-}
-
-static inline u16 mwl8k_qos_setbit_qlen(u16 qos, u8 len)
-{
-	u16 val_mask = 0xff;
-	u8	shift = 8;
-	u16 qos_mask = ~(val_mask << shift);
-
-	/* Queue Length Bits 8-15 */
-	return (qos & qos_mask) | ((len & val_mask) << shift);
-}
-
 /* DMA header used by firmware and hardware.  */
 struct mwl8k_dma_data {
 	__le16 fwlen;
@@ -1146,16 +1117,18 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
  * Packet transmission.
  */
 
-/* Transmit packet ACK policy */
-#define MWL8K_TXD_ACK_POLICY_NORMAL		0
-#define MWL8K_TXD_ACK_POLICY_BLOCKACK		3
-
 #define MWL8K_TXD_STATUS_OK			0x00000001
 #define MWL8K_TXD_STATUS_OK_RETRY		0x00000002
 #define MWL8K_TXD_STATUS_OK_MORE_RETRY		0x00000004
 #define MWL8K_TXD_STATUS_MULTICAST_TX		0x00000008
 #define MWL8K_TXD_STATUS_FW_OWNED		0x80000000
 
+#define MWL8K_QOS_QLEN_UNSPEC			0xff00
+#define MWL8K_QOS_ACK_POLICY_MASK		0x0060
+#define MWL8K_QOS_ACK_POLICY_NORMAL		0x0000
+#define MWL8K_QOS_ACK_POLICY_BLOCKACK		0x0060
+#define MWL8K_QOS_EOSP				0x0010
+
 struct mwl8k_tx_desc {
 	__le32 status;
 	__u8 data_rate;
@@ -1452,21 +1425,17 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	if (ieee80211_is_mgmt(wh->frame_control) ||
 	    ieee80211_is_ctl(wh->frame_control)) {
 		txdatarate = 0;
-		qos = mwl8k_qos_setbit_eosp(qos);
-		/* Set Queue size to unspecified */
-		qos = mwl8k_qos_setbit_qlen(qos, 0xff);
+		qos |= MWL8K_QOS_QLEN_UNSPEC | MWL8K_QOS_EOSP;
 	} else if (ieee80211_is_data(wh->frame_control)) {
 		txdatarate = 1;
 		if (is_multicast_ether_addr(wh->addr1))
 			txstatus |= MWL8K_TXD_STATUS_MULTICAST_TX;
 
-		/* Send pkt in an aggregate if AMPDU frame.  */
+		qos &= ~MWL8K_QOS_ACK_POLICY_MASK;
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
-			qos = mwl8k_qos_setbit_ack(qos,
-				MWL8K_TXD_ACK_POLICY_BLOCKACK);
+			qos |= MWL8K_QOS_ACK_POLICY_BLOCKACK;
 		else
-			qos = mwl8k_qos_setbit_ack(qos,
-				MWL8K_TXD_ACK_POLICY_NORMAL);
+			qos |= MWL8K_QOS_ACK_POLICY_NORMAL;
 	}
 
 	dma = pci_map_single(priv->pdev, skb->data,
-- 
1.5.6.4

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:38629 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab3ACH7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 02:59:04 -0500
Date: Thu, 3 Jan 2013 13:22:56 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 1/5] mwl8k: Enable support to support additional ampdu streams
Message-ID: <20130103075252.GA20263@markyou.marvell.com> (sfid-20130103_085908_082020_CF88D649)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, we have 2 ampdu streams that can be created
simultaneously. Firmware is capable of supporting
additional streams. Add support to use these streams.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index c9c9c99..704d7d3 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -101,6 +101,18 @@ MODULE_PARM_DESC(ap_mode_default,
 #define MWL8K_MAX_TX_QUEUES	(MWL8K_TX_WMM_QUEUES + MWL8K_MAX_AMPDU_QUEUES)
 #define mwl8k_tx_queues(priv)	(MWL8K_TX_WMM_QUEUES + (priv)->num_ampdu_queues)
 
+/* txpriorities are mapped with hw queues.
+ * Each hw queue has a txpriority.
+ */
+#define TOTAL_HW_TX_QUEUES	8
+
+/* Each HW queue can have one AMPDU stream.
+ * But, because one of the hw queue is reserved,
+ * maximum AMPDU queues that can be created are
+ * one short of total tx queues.
+ */
+#define MWL8K_NUM_AMPDU_STREAMS	(TOTAL_HW_TX_QUEUES - 1)
+
 struct rxd_ops {
 	int rxd_size;
 	void (*rxd_init)(void *rxd, dma_addr_t next_dma_addr);
@@ -1733,7 +1745,7 @@ mwl8k_add_stream(struct ieee80211_hw *hw, struct ieee80211_sta *sta, u8 tid)
 	struct mwl8k_priv *priv = hw->priv;
 	int i;
 
-	for (i = 0; i < priv->num_ampdu_queues; i++) {
+	for (i = 0; i < MWL8K_NUM_AMPDU_STREAMS; i++) {
 		stream = &priv->ampdu[i];
 		if (stream->state == AMPDU_NO_STREAM) {
 			stream->sta = sta;
@@ -1780,7 +1792,7 @@ mwl8k_lookup_stream(struct ieee80211_hw *hw, u8 *addr, u8 tid)
 	struct mwl8k_priv *priv = hw->priv;
 	int i;
 
-	for (i = 0 ; i < priv->num_ampdu_queues; i++) {
+	for (i = 0; i < MWL8K_NUM_AMPDU_STREAMS; i++) {
 		struct mwl8k_ampdu_stream *stream;
 		stream = &priv->ampdu[i];
 		if (stream->state == AMPDU_NO_STREAM)
@@ -1827,6 +1839,13 @@ static inline void mwl8k_tx_count_packet(struct ieee80211_sta *sta, u8 tid)
 		tx_stats->pkts++;
 }
 
+/* The hardware ampdu queues start from 5.
+ * txpriorities for ampdu queues are
+ * 5 6 7 0 1 2 3 4 ie., queue 5 is highest
+ * and queue 3 is lowest (queue 4 is reserved)
+ */
+#define BA_QUEUE		5
+
 static void
 mwl8k_txq_xmit(struct ieee80211_hw *hw,
 	       int index,
@@ -1927,8 +1946,12 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 		if (stream != NULL) {
 			if (stream->state == AMPDU_STREAM_ACTIVE) {
 				WARN_ON(!(qos & MWL8K_QOS_ACK_POLICY_BLOCKACK));
-				txpriority = stream->idx + MWL8K_TX_WMM_QUEUES;
-				index = stream->idx + MWL8K_TX_WMM_QUEUES;
+				txpriority = (BA_QUEUE + stream->idx) %
+					     TOTAL_HW_TX_QUEUES;
+				if (stream->idx <= 1)
+					index = stream->idx +
+						MWL8K_TX_WMM_QUEUES;
+
 			} else if (stream->state == AMPDU_STREAM_NEW) {
 				/* We get here if the driver sends us packets
 				 * after we've initiated a stream, but before
-- 
1.8.0.3


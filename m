Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:27115 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754299AbXGUU6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 16:58:43 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: maximum length for ack_wait_queue
Message-Id: <20070721205839.C36637B40A0@zog.reactivated.net>
Date: Sat, 21 Jul 2007 21:58:39 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

This patch implements the maximum length ZD_MAC_MAX_ACK_WAITERS
for the ack_wait_queue simply by removing waiting packets in the
same way as an error had reported for them.

The ZD1211 chips don't inform the host, whether a packet has been
successfully transmitted. Sometimes transmission errors are
reported, but it is very difficult to link them back to the
original transmitted packet. We try to emulate the behaviour by
keeping the packets waiting for ACKs in a specific queue and
report success or failure if ACKs or error messages are received.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.c |   59 ++++++++++++----------
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.h |    4 +-
 2 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index 2461507..9a2d6f3 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -313,6 +313,32 @@ static int init_tx_skb_control_block(struct sk_buff *skb,
 }
 
 /**
+ * zd_mac_tx_failed - callback for failed frames
+ * @dev: the mac80211 wireless device
+ *
+ * This function is called if a frame couldn't be succesfully be
+ * transferred. The first frame from the tx queue, will be selected and
+ * reported as error to the upper layers.
+ */
+void zd_mac_tx_failed(struct ieee80211_hw *dev)
+{
+	struct sk_buff_head *ack_wait_queue = &zd_dev_mac(dev)->ack_wait_queue;
+	struct sk_buff *skb;
+	struct ieee80211_tx_status status;
+	struct zd_tx_skb_control_block *cb;
+
+	skb = skb_dequeue(ack_wait_queue);
+	if (skb == NULL)
+		return;
+	cb = (struct zd_tx_skb_control_block *)skb->cb;
+	ZD_ASSERT(cb->control != NULL);
+	memset(&status, 0, sizeof(status));
+	memcpy(&status.control, cb->control, sizeof(status.control));
+	clear_tx_skb_control_block(skb);
+	ieee80211_tx_status_irqsafe(dev, skb, &status);
+}
+
+/**
  * zd_mac_tx_to_dev - callback for USB layer
  * @skb: a &sk_buff pointer
  * @error: error value, 0 if transmission successful
@@ -338,7 +364,12 @@ void zd_mac_tx_to_dev(struct sk_buff *skb, int error)
 			clear_tx_skb_control_block(skb);
 			ieee80211_tx_status_irqsafe(dev, skb, &status);
 		} else {
-			skb_queue_tail(&zd_dev_mac(dev)->ack_wait_queue, skb);
+			struct sk_buff_head *q =
+				&zd_dev_mac(dev)->ack_wait_queue;
+
+			skb_queue_tail(q, skb);
+			while (skb_queue_len(q) > ZD_MAC_MAX_ACK_WAITERS)
+				zd_mac_tx_failed(dev);
 			return;
 		}
 	} else {
@@ -516,32 +547,6 @@ static int zd_mac_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	return 0;
 }
 
-/**
- * zd_mac_tx_failed - callback for failed frames
- * @dev: the mac80211 wireless device
- *
- * This function is called if a frame couldn't be succesfully be
- * transferred. The first frame from the tx queue, will be selected and
- * reported as error to the upper layers.
- */
-void zd_mac_tx_failed(struct ieee80211_hw *dev)
-{
-	struct sk_buff_head *ack_wait_queue = &zd_dev_mac(dev)->ack_wait_queue;
-	struct sk_buff *skb;
-	struct ieee80211_tx_status status;
-	struct zd_tx_skb_control_block *cb;
-
-	skb = skb_dequeue(ack_wait_queue);
-	if (skb == NULL)
-		return;
-	cb = (struct zd_tx_skb_control_block *)skb->cb;
-	ZD_ASSERT(cb->control != NULL);
-	memset(&status, 0, sizeof(status));
-	memcpy(&status.control, cb->control, sizeof(status.control));
-	clear_tx_skb_control_block(skb);
-	ieee80211_tx_status_irqsafe(dev, skb, &status);
-}
-
 struct zd_rt_hdr {
 	struct ieee80211_radiotap_header rt_hdr;
 	u8  rt_flags;
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
index 1d4753e..6a3fe41 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
@@ -114,7 +114,7 @@ struct rx_status {
 #define ZD_RX_CRC16_ERROR		0x40
 #define ZD_RX_ERROR			0x80
 
-enum mac_flags { 
+enum mac_flags {
 	MAC_FIXED_CHANNEL = 0x01,
 };
 
@@ -140,6 +140,8 @@ struct zd_tx_skb_control_block {
 
 #define ZD_MAC_STATS_BUFFER_SIZE 16
 
+#define ZD_MAC_MAX_ACK_WAITERS 10
+
 struct zd_mac {
 	struct zd_chip chip;
 	spinlock_t lock;
-- 
1.5.2.2


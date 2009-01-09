Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:34298 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbZAIUGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 15:06:09 -0500
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] p54: upgrade memrecord to p54_tx_info
Date: Fri, 9 Jan 2009 21:06:06 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901092106.06592.chunkeey@web.de> (sfid-20090109_210614_619180_A051AC41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 reserves 24 bytes in skb->cb for the driver.
So far, we only used them to keep track of used and free device memory.
But p54spi will need a slice of it, as well as the stuck frame detection.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-01-09 19:12:47.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-01-09 19:14:11.000000000 +0100
@@ -690,7 +690,7 @@ void p54_free_skb(struct ieee80211_hw *d
 {
 	struct p54_common *priv = dev->priv;
 	struct ieee80211_tx_info *info;
-	struct memrecord *range;
+	struct p54_tx_info *range;
 	unsigned long flags;
 	u32 freed = 0, last_addr = priv->rx_start;
 
@@ -708,18 +708,18 @@ void p54_free_skb(struct ieee80211_hw *d
 	range = (void *)info->rate_driver_data;
 	if (skb->prev != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *ni;
-		struct memrecord *mr;
+		struct p54_tx_info *mr;
 
 		ni = IEEE80211_SKB_CB(skb->prev);
-		mr = (struct memrecord *)ni->rate_driver_data;
+		mr = (struct p54_tx_info *)ni->rate_driver_data;
 		last_addr = mr->end_addr;
 	}
 	if (skb->next != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *ni;
-		struct memrecord *mr;
+		struct p54_tx_info *mr;
 
 		ni = IEEE80211_SKB_CB(skb->next);
-		mr = (struct memrecord *)ni->rate_driver_data;
+		mr = (struct p54_tx_info *)ni->rate_driver_data;
 		freed = mr->start_addr - last_addr;
 	} else
 		freed = priv->rx_end - last_addr;
@@ -761,7 +761,7 @@ static void p54_rx_frame_sent(struct iee
 	struct p54_frame_sent *payload = (struct p54_frame_sent *) hdr->data;
 	struct sk_buff *entry = (struct sk_buff *) priv->tx_queue.next;
 	u32 addr = le32_to_cpu(hdr->req_id) - priv->headroom;
-	struct memrecord *range = NULL;
+	struct p54_tx_info *range = NULL;
 	u32 freed = 0;
 	u32 last_addr = priv->rx_start;
 	unsigned long flags;
@@ -783,10 +783,10 @@ static void p54_rx_frame_sent(struct iee
 
 		if (entry->next != (struct sk_buff *)&priv->tx_queue) {
 			struct ieee80211_tx_info *ni;
-			struct memrecord *mr;
+			struct p54_tx_info *mr;
 
 			ni = IEEE80211_SKB_CB(entry->next);
-			mr = (struct memrecord *)ni->rate_driver_data;
+			mr = (struct p54_tx_info *)ni->rate_driver_data;
 			freed = mr->start_addr - last_addr;
 		} else
 			freed = priv->rx_end - last_addr;
@@ -989,8 +989,8 @@ EXPORT_SYMBOL_GPL(p54_rx);
  * can find some unused memory to upload our packets to. However, data that we
  * want the card to TX needs to stay intact until the card has told us that
  * it is done with it. This function finds empty places we can upload to and
- * marks allocated areas as reserved if necessary. p54_rx_frame_sent frees
- * allocated areas.
+ * marks allocated areas as reserved if necessary. p54_rx_frame_sent or
+ * p54_free_skb frees allocated areas.
  */
 static int p54_assign_address(struct ieee80211_hw *dev, struct sk_buff *skb,
 			       struct p54_hdr *data, u32 len)
@@ -999,7 +999,7 @@ static int p54_assign_address(struct iee
 	struct sk_buff *entry = priv->tx_queue.next;
 	struct sk_buff *target_skb = NULL;
 	struct ieee80211_tx_info *info;
-	struct memrecord *range;
+	struct p54_tx_info *range;
 	u32 last_addr = priv->rx_start;
 	u32 largest_hole = 0;
 	u32 target_addr = priv->rx_start;
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2009-01-09 15:29:58.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2009-01-09 15:18:12.000000000 +0100
@@ -247,12 +247,6 @@ struct pda_country {
 #define PDR_COUNTRY_CERT_IODOOR_OUTDOOR	0x30
 #define PDR_COUNTRY_CERT_INDEX		0x0F
 
-/* stored in skb->cb */
-struct memrecord {
-	u32 start_addr;
-	u32 end_addr;
-};
-
 struct p54_eeprom_lm86 {
 	union {
 		struct {
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2009-01-09 15:29:36.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2009-01-09 18:52:34.000000000 +0100
@@ -44,6 +44,16 @@ enum p54_control_frame_types {
 	P54_CONTROL_TYPE_BT_OPTIONS = 35
 };
 
+/* provide 16 bytes for the transport back-end */
+#define P54_TX_INFO_DATA_SIZE		16
+
+/* stored in ieee80211_tx_info's rate_driver_data */
+struct p54_tx_info {
+	u32 start_addr;
+	u32 end_addr;
+	void *data[P54_TX_INFO_DATA_SIZE / sizeof(void *)];
+};
+
 #define P54_MAX_FRAME_LEN		0x1000
 
 #define P54_HDR_FLAG_CONTROL		BIT(15)

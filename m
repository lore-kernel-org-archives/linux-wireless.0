Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42829 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1HKOhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 10:37:23 -0400
Received: by fxh19 with SMTP id 19so1708583fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 07:37:22 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/3 V2] b43: support new RX header, noticed to be used in 598.314+ fw
Date: Thu, 11 Aug 2011 17:16:27 +0200
Message-Id: <1313075787-23195-4-git-send-email-zajec5@gmail.com> (sfid-20110811_163728_365857_4D543841)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/dma.c  |   13 +++++++++++--
 drivers/net/wireless/b43/dma.h  |    7 +++++--
 drivers/net/wireless/b43/pio.c  |   10 +++++++++-
 drivers/net/wireless/b43/xmit.c |   21 ++++++++++++++++-----
 drivers/net/wireless/b43/xmit.h |   20 +++++++++++++++++---
 5 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 7fb6da9..82168f8 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -893,8 +893,17 @@ struct b43_dmaring *b43_setup_dmaring(struct b43_wldev *dev,
 		ring->current_slot = -1;
 	} else {
 		if (ring->index == 0) {
-			ring->rx_buffersize = B43_DMA0_RX_BUFFERSIZE;
-			ring->frameoffset = B43_DMA0_RX_FRAMEOFFSET;
+			switch (dev->fw.hdr_format) {
+			case B43_FW_HDR_598:
+				ring->rx_buffersize = B43_DMA0_RX_FW598_BUFSIZE;
+				ring->frameoffset = B43_DMA0_RX_FW598_FO;
+				break;
+			case B43_FW_HDR_410:
+			case B43_FW_HDR_351:
+				ring->rx_buffersize = B43_DMA0_RX_FW351_BUFSIZE;
+				ring->frameoffset = B43_DMA0_RX_FW351_FO;
+				break;
+			}
 		} else
 			B43_WARN_ON(1);
 	}
diff --git a/drivers/net/wireless/b43/dma.h b/drivers/net/wireless/b43/dma.h
index 1a5313d..7e20b04f 100644
--- a/drivers/net/wireless/b43/dma.h
+++ b/drivers/net/wireless/b43/dma.h
@@ -162,12 +162,15 @@ struct b43_dmadesc_generic {
 
 /* Misc DMA constants */
 #define B43_DMA_RINGMEMSIZE		PAGE_SIZE
-#define B43_DMA0_RX_FRAMEOFFSET		30
+/* Offset of frame with actual data */
+#define B43_DMA0_RX_FW598_FO		38
+#define B43_DMA0_RX_FW351_FO		30
 
 /* DMA engine tuning knobs */
 #define B43_TXRING_SLOTS		256
 #define B43_RXRING_SLOTS		64
-#define B43_DMA0_RX_BUFFERSIZE		(B43_DMA0_RX_FRAMEOFFSET + IEEE80211_MAX_FRAME_LEN)
+#define B43_DMA0_RX_FW598_BUFSIZE	(B43_DMA0_RX_FW598_FO + IEEE80211_MAX_FRAME_LEN)
+#define B43_DMA0_RX_FW351_BUFSIZE	(B43_DMA0_RX_FW351_FO + IEEE80211_MAX_FRAME_LEN)
 
 /* Pointer poison */
 #define B43_DMA_PTR_POISON		((void *)ERR_PTR(-ENOMEM))
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index 6e4228c..ce8a4bd 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -676,7 +676,15 @@ data_ready:
 		goto rx_error;
 	}
 
-	macstat = le32_to_cpu(rxhdr->mac_status);
+	switch (dev->fw.hdr_format) {
+	case B43_FW_HDR_598:
+		macstat = le32_to_cpu(rxhdr->format_598.mac_status);
+		break;
+	case B43_FW_HDR_410:
+	case B43_FW_HDR_351:
+		macstat = le32_to_cpu(rxhdr->format_351.mac_status);
+		break;
+	}
 	if (macstat & B43_RX_MAC_FCSERR) {
 		if (!(q->dev->wl->filter_flags & FIF_FCSFAIL)) {
 			/* Drop frames with failed FCS. */
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index b02170d..5b82409 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -653,8 +653,9 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	struct ieee80211_hdr *wlhdr;
 	const struct b43_rxhdr_fw4 *rxhdr = _rxhdr;
 	__le16 fctl;
-	u16 phystat0, phystat3, chanstat, mactime;
-	u32 macstat;
+	u16 phystat0, phystat3;
+	u16 uninitialized_var(chanstat), uninitialized_var(mactime);
+	u32 uninitialized_var(macstat);
 	u16 chanid;
 	u16 phytype;
 	int padding;
@@ -664,9 +665,19 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	/* Get metadata about the frame from the header. */
 	phystat0 = le16_to_cpu(rxhdr->phy_status0);
 	phystat3 = le16_to_cpu(rxhdr->phy_status3);
-	macstat = le32_to_cpu(rxhdr->mac_status);
-	mactime = le16_to_cpu(rxhdr->mac_time);
-	chanstat = le16_to_cpu(rxhdr->channel);
+	switch (dev->fw.hdr_format) {
+	case B43_FW_HDR_598:
+		macstat = le32_to_cpu(rxhdr->format_598.mac_status);
+		mactime = le16_to_cpu(rxhdr->format_598.mac_time);
+		chanstat = le16_to_cpu(rxhdr->format_598.channel);
+		break;
+	case B43_FW_HDR_410:
+	case B43_FW_HDR_351:
+		macstat = le32_to_cpu(rxhdr->format_351.mac_status);
+		mactime = le16_to_cpu(rxhdr->format_351.mac_time);
+		chanstat = le16_to_cpu(rxhdr->format_351.channel);
+		break;
+	}
 	phytype = chanstat & B43_RX_CHAN_PHYTYPE;
 
 	if (unlikely(macstat & B43_RX_MAC_FCSERR)) {
diff --git a/drivers/net/wireless/b43/xmit.h b/drivers/net/wireless/b43/xmit.h
index dccf7c1..f6e8bc4 100644
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -250,9 +250,23 @@ struct b43_rxhdr_fw4 {
 	} __packed;
 	__le16 phy_status2;	/* PHY RX Status 2 */
 	__le16 phy_status3;	/* PHY RX Status 3 */
-	__le32 mac_status;	/* MAC RX status */
-	__le16 mac_time;
-	__le16 channel;
+	union {
+		/* Tested with 598.314, 644.1001 and 666.2 */
+		struct {
+			__le16 phy_status4;	/* PHY RX Status 4 */
+			__le16 phy_status5;	/* PHY RX Status 5 */
+			__le32 mac_status;	/* MAC RX status */
+			__le16 mac_time;
+			__le16 channel;
+		} format_598 __packed;
+
+		/* Tested with 351.126, 410.2160, 478.104 and 508.* */
+		struct {
+			__le32 mac_status;	/* MAC RX status */
+			__le16 mac_time;
+			__le16 channel;
+		} format_351 __packed;
+	} __packed;
 } __packed;
 
 /* PHY RX Status 0 */
-- 
1.7.3.4


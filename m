Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:20973 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751377AbXIXWNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 18:13:18 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 5/6] adm8211: Pass all TXed frames to tx_status_irqsafe
Date: Mon, 24 Sep 2007 18:10:25 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20070924221025.6870.90503.stgit@magic.sourmilk.net>
In-Reply-To: <20070924221025.6870.53754.stgit@magic.sourmilk.net>
References: <20070924221025.6870.53754.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

ieee80211_tx_status_irqsafe can handle the freeing of all TXed frames.

Also, set excessive_retries for failed frames.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index e950a7d..95c8315 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -299,6 +299,7 @@ static void adm8211_interrupt_tci(struct ieee80211_hw *dev)
 	for (dirty_tx = priv->dirty_tx; priv->cur_tx - dirty_tx; dirty_tx++) {
 		unsigned int entry = dirty_tx % priv->tx_ring_size;
 		u32 status = le32_to_cpu(priv->tx_ring[entry].status);
+		struct ieee80211_tx_status tx_status;
 		struct adm8211_tx_ring_info *info;
 		struct sk_buff *skb;
 
@@ -314,21 +315,19 @@ static void adm8211_interrupt_tci(struct ieee80211_hw *dev)
 		pci_unmap_single(priv->pdev, info->mapping,
 				 info->skb->len, PCI_DMA_TODEVICE);
 
-		if (info->tx_control.flags & IEEE80211_TXCTL_REQ_TX_STATUS) {
-			struct ieee80211_tx_status tx_status = {{0}};
-			struct ieee80211_hdr *hdr;
-			size_t hdrlen = info->hdrlen;
-
-			skb_pull(skb, sizeof(struct adm8211_tx_hdr));
-			hdr = (struct ieee80211_hdr *)skb_push(skb, hdrlen);
-			memcpy(hdr, skb->cb, hdrlen);
-			memcpy(&tx_status.control, &info->tx_control,
-			       sizeof(tx_status.control));
-			if (!(status & TDES0_STATUS_ES))
+		memset(&tx_status, 0, sizeof(tx_status));
+		skb_pull(skb, sizeof(struct adm8211_tx_hdr));
+		memcpy(skb_push(skb, info->hdrlen), skb->cb, info->hdrlen);
+		memcpy(&tx_status.control, &info->tx_control,
+		       sizeof(tx_status.control));
+		if (!(tx_status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
+			if (status & TDES0_STATUS_ES)
+				tx_status.excessive_retries = 1;
+			else
 				tx_status.flags |= IEEE80211_TX_STATUS_ACK;
-			ieee80211_tx_status_irqsafe(dev, skb, &tx_status);
-		} else
-			dev_kfree_skb_irq(skb);
+		}
+		ieee80211_tx_status_irqsafe(dev, skb, &tx_status);
+
 		info->skb = NULL;
 	}
 


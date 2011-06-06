Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35764 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1FFOMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 10:12:17 -0400
Received: by pzk9 with SMTP id 9so1905044pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 07:12:17 -0700 (PDT)
Message-ID: <4DECE02C.1030205@ring3k.org> (sfid-20110606_161220_855047_D384F064)
Date: Mon, 06 Jun 2011 23:11:56 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] rtlwifi: Allocate new skb before modifying old
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure not to modify the skb we resubmit.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/pci.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index fc44005..e502db0 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -670,6 +670,19 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 							 &rx_status,
 							 (u8 *) pdesc, skb);
 
+			new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
+			if (unlikely(!new_skb)) {
+				RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
+					 DBG_DMESG,
+					 ("can't alloc skb for rx\n"));
+				goto done;
+			}
+
+			pci_unmap_single(rtlpci->pdev,
+					 *((dma_addr_t *) skb->cb),
+					 rtlpci->rxbuffersize,
+					 PCI_DMA_FROMDEVICE);
+
 			skb_put(skb, rtlpriv->cfg->ops->get_desc((u8 *) pdesc,
 							 false,
 							 HW_DESC_RXPKT_LEN));
@@ -686,21 +699,6 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			hdr = rtl_get_hdr(skb);
 			fc = rtl_get_fc(skb);
 
-			/* try for new buffer - if allocation fails, drop
-			 * frame and reuse old buffer
-			 */
-			new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
-			if (unlikely(!new_skb)) {
-				RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV),
-					 DBG_DMESG,
-					 ("can't alloc skb for rx\n"));
-				goto done;
-			}
-			pci_unmap_single(rtlpci->pdev,
-					 *((dma_addr_t *) skb->cb),
-					 rtlpci->rxbuffersize,
-					 PCI_DMA_FROMDEVICE);
-
 			if (!stats.crc && !stats.hwerror) {
 				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
 				       sizeof(rx_status));
-- 
1.7.4.1



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38637 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab1EYAjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 20:39:47 -0400
Received: by mail-pv0-f174.google.com with SMTP id 12so3196876pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 17:39:47 -0700 (PDT)
Message-ID: <4DDC4FBB.4010407@ring3k.org> (sfid-20110525_023949_455628_EB288779)
Date: Wed, 25 May 2011 09:39:23 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] rtlwifi: Store loop index in local variable
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

_rtl_pci_rx_interrupt uses rtlpci->rx_ring[rx_queue_idx].idx a
few times, so store it in a separate variable.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index a409528..5eedb91 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -644,22 +644,23 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		.noise = -98,
 		.rate = 0,
 	};
+	int index = rtlpci->rx_ring[rx_queue_idx].idx;
 
 	/*RX NORMAL PKT */
 	while (count--) {
 		/*rx descriptor */
 		struct rtl_rx_desc *pdesc = &rtlpci->rx_ring[rx_queue_idx].desc[
-				rtlpci->rx_ring[rx_queue_idx].idx];
+				index];
 		/*rx pkt */
 		struct sk_buff *skb = rtlpci->rx_ring[rx_queue_idx].rx_buf[
-				rtlpci->rx_ring[rx_queue_idx].idx];
+				index];
 
 		own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) pdesc,
 						       false, HW_DESC_OWN);
 
 		if (own) {
 			/*wait data to be filled by hardware */
-			return;
+			break;
 		} else {
 			struct ieee80211_hdr *hdr;
 			__le16 fc;
@@ -768,10 +769,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			skb = new_skb;
 			/*skb->dev = dev; */
 
-			rtlpci->rx_ring[rx_queue_idx].rx_buf[rtlpci->
-							     rx_ring
-							     [rx_queue_idx].
-							     idx] = skb;
+			rtlpci->rx_ring[rx_queue_idx].rx_buf[index] = skb;
 			*((dma_addr_t *) skb->cb) =
 			    pci_map_single(rtlpci->pdev, skb_tail_pointer(skb),
 					   rtlpci->rxbuffersize,
@@ -790,17 +788,15 @@ done:
 					    HW_DESC_RXPKT_LEN,
 					    (u8 *)&rtlpci->rxbuffersize);
 
-		if (rtlpci->rx_ring[rx_queue_idx].idx ==
-		    rtlpci->rxringcount - 1)
+		if (index == rtlpci->rxringcount - 1)
 			rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false,
 						    HW_DESC_RXERO,
 						    (u8 *)&tmp_one);
 
-		rtlpci->rx_ring[rx_queue_idx].idx =
-		    (rtlpci->rx_ring[rx_queue_idx].idx + 1) %
-		    rtlpci->rxringcount;
+		index = (index + 1) % rtlpci->rxringcount;
 	}
 
+	rtlpci->rx_ring[rx_queue_idx].idx = index;
 }
 
 static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
-- 
1.7.4.1



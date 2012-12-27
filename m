Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f45.google.com ([209.85.210.45]:64832 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab2L0Qhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 11:37:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 3.8 1/5 V2] rtlwifi: Fix warning for unchecked pci_map_single() call
Date: Thu, 27 Dec 2012 10:37:28 -0600
Message-Id: <1356626252-4058-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20121227_173758_816537_E980CA80)
In-Reply-To: <1356626252-4058-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1356626252-4058-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel 3.8 implements checking of all DMA mapping calls and issues
a WARNING for the first it finds that is not checked.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.c |    6 ++++++
 1 file changed, 6 insertions(+)

No change for V2.

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 3deacaf..4261e8e 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -743,6 +743,8 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 
 done:
 		bufferaddress = (*((dma_addr_t *)skb->cb));
+		if (pci_dma_mapping_error(rtlpci->pdev, bufferaddress))
+			return;
 		tmp_one = 1;
 		rtlpriv->cfg->ops->set_desc((u8 *) pdesc, false,
 					    HW_DESC_RXBUFF_ADDR,
@@ -1115,6 +1117,10 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
 					   PCI_DMA_FROMDEVICE);
 
 			bufferaddress = (*((dma_addr_t *)skb->cb));
+			if (pci_dma_mapping_error(rtlpci->pdev, bufferaddress)) {
+				dev_kfree_skb_any(skb);
+				return 1;
+			}
 			rtlpriv->cfg->ops->set_desc((u8 *)entry, false,
 						    HW_DESC_RXBUFF_ADDR,
 						    (u8 *)&bufferaddress);
-- 
1.7.10.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12731 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509Ab2CZPsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 11:48:22 -0400
Date: Mon, 26 Mar 2012 10:48:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Add missing DMA buffer unmapping for PCI drivers
Message-ID: <4f708fc4.MoefCE/S2mC5iHWx%Larry.Finger@lwfinger.net> (sfid-20120326_174826_112192_DD4DE03C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In https://bugzilla.kernel.org/show_bug.cgi?id=42976, a system with driver
rtl8192se used as an AP suffers from "Out of SW-IOMMU space" errors. These
are caused by the DMA buffers used for beacons never being unmapped.

This bug was also reported at
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/961618

Reported-and-Tested-by: Da Xue <da@lessconfused.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

John,

This is not a regression. The problem has been in the driver from the
beginning. It has not been found earlier due to the infrequent use of
these devices in access points.

I think it can be applied to 3.5.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -912,8 +912,13 @@ static void _rtl_pci_prepare_bcn_tasklet
 	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 	ring = &rtlpci->tx_ring[BEACON_QUEUE];
 	pskb = __skb_dequeue(&ring->queue);
-	if (pskb)
+	if (pskb) {
+		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
+		pci_unmap_single(rtlpci->pdev, rtlpriv->cfg->ops->get_desc(
+				 (u8 *) entry, true, HW_DESC_TXBUFF_ADDR),
+				 pskb->len, PCI_DMA_TODEVICE);
 		kfree_skb(pskb);
+	}
 
 	/*NB: the beacon data buffer must be 32-bit aligned. */
 	pskb = ieee80211_beacon_get(hw, mac->vif);

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab1EKQRy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:17:54 -0400
Date: Wed, 11 May 2011 11:17:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix panic due to memory allocation failure
Message-ID: <4dcab6af.skkZ1nWg46gP0cdM%Larry.Finger@lwfinger.net> (sfid-20110511_181816_489739_D540ED95)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCI routine of this driver is allocating receive buffers of order 2,
which causes an unnecessary fragmentation of memory. To make matters
worse, there are locations that fail to check for allocation failures,
or return success when the allocation actually failed. Kernel panics
result.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>              [2.6.37 and 2.6.38]
---

John,

This is 2.6.39 material. I hope we make the cutoff.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -732,10 +732,12 @@ static void _rtl_pci_rx_interrupt(struct
 					    false))) {
 						dev_kfree_skb_any(skb);
 					} else {
-						struct sk_buff *uskb = NULL;
+						struct sk_buff *uskb;
 						u8 *pdata;
 						uskb = dev_alloc_skb(skb->len
 								     + 128);
+						if (!uskb)
+							return;
 						memcpy(IEEE80211_SKB_RXCB(uskb),
 						       &rx_status,
 						       sizeof(rx_status));
@@ -996,7 +998,7 @@ static void _rtl_pci_init_trx_var(struct
 	 */
 	rtlpci->txringcount[BE_QUEUE] = RT_TXDESC_NUM_BE_QUEUE;
 
-	rtlpci->rxbuffersize = 9100;	/*2048/1024; */
+	rtlpci->rxbuffersize = 4096;
 	rtlpci->rxringcount = RTL_PCI_MAX_RX_COUNT;	/*64; */
 }
 
@@ -1118,7 +1120,7 @@ static int _rtl_pci_init_rx_ring(struct
 			    dev_alloc_skb(rtlpci->rxbuffersize);
 			u32 bufferaddress;
 			if (!skb)
-				return 0;
+				return -ENOMEM;
 			entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
 
 			/*skb->dev = dev; */

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4183 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab3E3VVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 17:21:49 -0400
Date: Thu, 30 May 2013 16:21:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix a false leak indication for PCI devices
Message-ID: <51a7c2eb.pqitUULLF65rAsdi%Larry.Finger@lwfinger.net> (sfid-20130530_232206_813351_C22FCAFD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This false leak indication is avoided with a no-leak annotation to kmemleak.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

AFAIK, the false leak indication was not present before 3.10.

Please include it in the 3.10 stream.

Thanks,

Larry
---

Index: wireless-testing-save/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/pci.c
@@ -764,6 +764,7 @@ static void _rtl_pci_rx_interrupt(struct
 				 "can't alloc skb for rx\n");
 			goto done;
 		}
+		kmemleak_not_leak(new_skb);
 
 		pci_unmap_single(rtlpci->pdev,
 				 *((dma_addr_t *) skb->cb),

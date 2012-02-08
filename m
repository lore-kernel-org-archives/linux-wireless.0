Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55614 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab2BHAHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 19:07:41 -0500
Date: Tue, 07 Feb 2012 18:07:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: simon.graham@virtualcomputer.com, linux-wireless@vger.kernel.org
Subject: [PATCH V2] rtlwifi: Handle previous allocation failures when
 freeing device memory
Message-ID: <4f31bcca.a/idtjYoA2MEwh/h%Larry.Finger@lwfinger.net> (sfid-20120208_010746_211916_73142984)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Simon Graham <simon.graham@virtualcomputer.com>

Handle previous allocation failures when freeing device memory

Signed-off-by: Simon Graham <simon.graham@virtualcomputer.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

V2 - fix mailer mangling
---

 pci.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1148,10 +1148,12 @@ static void _rtl_pci_free_tx_ring(struct
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
 
-	pci_free_consistent(rtlpci->pdev,
-			    sizeof(*ring->desc) * ring->entries,
-			    ring->desc, ring->dma);
-	ring->desc = NULL;
+	if (ring->desc) {
+		pci_free_consistent(rtlpci->pdev,
+				    sizeof(*ring->desc) * ring->entries,
+				    ring->desc, ring->dma);
+		ring->desc = NULL;
+	}
 }
 
 static void _rtl_pci_free_rx_ring(struct rtl_pci *rtlpci)
@@ -1175,12 +1177,14 @@ static void _rtl_pci_free_rx_ring(struct
 			kfree_skb(skb);
 		}
 
-		pci_free_consistent(rtlpci->pdev,
+		if (rtlpci->rx_ring[rx_queue_idx].desc) {
+			pci_free_consistent(rtlpci->pdev,
 				    sizeof(*rtlpci->rx_ring[rx_queue_idx].
 					   desc) * rtlpci->rxringcount,
 				    rtlpci->rx_ring[rx_queue_idx].desc,
 				    rtlpci->rx_ring[rx_queue_idx].dma);
-		rtlpci->rx_ring[rx_queue_idx].desc = NULL;
+			rtlpci->rx_ring[rx_queue_idx].desc = NULL;
+		}
 	}
 }
 

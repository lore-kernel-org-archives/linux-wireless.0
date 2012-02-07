Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server514f.exghost.com ([72.32.253.73]:4961 "EHLO
	server514.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756161Ab2BGVmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 16:42:07 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: [PATCH] rtlwifi: Handle previous allocation failures when freeing device memory
Date: Tue, 7 Feb 2012 15:31:59 -0600
Message-ID: <BC8BC73D12649F439B502B4CB6FD58B1053E2C92@BE23.exg4.exghost.com> (sfid-20120207_224211_537199_E4E789CD)
From: "Simon Graham" <simon.graham@virtualcomputer.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <Larry.Finger@lwfinger.net>,
	<chaoming_li@realsil.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle previous allocation failures when freeing device memory

Signed-off-by: Simon Graham <simon.graham@virtualcomputer.com>
---
 drivers/net/wireless/rtlwifi/pci.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c
b/drivers/net/wireless/rtlwifi/pci.c
index c5f6a32..fb84707 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1148,10 +1148,12 @@ static void _rtl_pci_free_tx_ring(struct
ieee80211_hw *hw,
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
@@ -1175,12 +1177,14 @@ static void _rtl_pci_free_rx_ring(struct rtl_pci
*rtlpci)
 			kfree_skb(skb);
 		}
 
-		pci_free_consistent(rtlpci->pdev,
-				sizeof(*rtlpci->rx_ring[rx_queue_idx].
-				       desc) * rtlpci->rxringcount,
-				rtlpci->rx_ring[rx_queue_idx].desc,
-				rtlpci->rx_ring[rx_queue_idx].dma);
-		rtlpci->rx_ring[rx_queue_idx].desc = NULL;
+		if (rtlpci->rx_ring[rx_queue_idx].desc) {
+			pci_free_consistent(rtlpci->pdev,
+
sizeof(*rtlpci->rx_ring[rx_queue_idx].
+						 desc) *
rtlpci->rxringcount,
+
rtlpci->rx_ring[rx_queue_idx].desc,
+
rtlpci->rx_ring[rx_queue_idx].dma);
+			rtlpci->rx_ring[rx_queue_idx].desc = NULL;
+		}
 	}
 }
 
-- 
1.7.8.3




Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0014.hostedemail.com ([216.40.44.14]:59199 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754673AbaFWNnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 09:43:09 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 18/22] rtlwifi: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:46 -0700
Message-Id: <4aac54b883b1664453c24d292e9d20595a2794c6.1403530604.git.joe@perches.com> (sfid-20140623_154458_979670_437EB02A)
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/rtlwifi/pci.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index dae5525..67d1ee6 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1092,16 +1092,14 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 	u32 nextdescaddress;
 	int i;
 
-	ring = pci_alloc_consistent(rtlpci->pdev,
-				    sizeof(*ring) * entries, &dma);
-
+	ring = pci_zalloc_consistent(rtlpci->pdev, sizeof(*ring) * entries,
+				     &dma);
 	if (!ring || (unsigned long)ring & 0xFF) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Cannot allocate TX ring (prio = %d)\n", prio);
 		return -ENOMEM;
 	}
 
-	memset(ring, 0, sizeof(*ring) * entries);
 	rtlpci->tx_ring[prio].desc = ring;
 	rtlpci->tx_ring[prio].dma = dma;
 	rtlpci->tx_ring[prio].idx = 0;
@@ -1139,10 +1137,9 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
 	for (rx_queue_idx = 0; rx_queue_idx < RTL_PCI_MAX_RX_QUEUE;
 	     rx_queue_idx++) {
 		rtlpci->rx_ring[rx_queue_idx].desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rx_queue_idx].
-						desc) * rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rx_queue_idx].dma);
+			pci_zalloc_consistent(rtlpci->pdev,
+					      sizeof(*rtlpci->rx_ring[rx_queue_idx].desc) * rtlpci->rxringcount,
+					      &rtlpci->rx_ring[rx_queue_idx].dma);
 
 		if (!rtlpci->rx_ring[rx_queue_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rx_queue_idx].desc & 0xFF) {
@@ -1151,10 +1148,6 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
 			return -ENOMEM;
 		}
 
-		memset(rtlpci->rx_ring[rx_queue_idx].desc, 0,
-		       sizeof(*rtlpci->rx_ring[rx_queue_idx].desc) *
-		       rtlpci->rxringcount);
-
 		rtlpci->rx_ring[rx_queue_idx].idx = 0;
 
 		/* If amsdu_8k is disabled, set buffersize to 4096. This
-- 
1.8.1.2.459.gbcd45b4.dirty


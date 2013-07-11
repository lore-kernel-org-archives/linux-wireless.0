Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2272 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3GKPD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 11:03:59 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/5] wil6210: Optimize Tx completion
Date: Thu, 11 Jul 2013 18:03:39 +0300
Message-ID: <1373555021-11763-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130711_170410_944652_F90F6CD0)
In-Reply-To: <1373555021-11763-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1373555021-11763-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to modify HW descriptor, as it will be re-initialized on Tx.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 8fde73a..dd5f35e 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -855,10 +855,12 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		} else {
 			dma_unmap_page(dev, pa, dmalen, DMA_TO_DEVICE);
 		}
-		d->dma.addr.addr_low = 0;
-		d->dma.addr.addr_high = 0;
-		d->dma.length = 0;
-		d->dma.status = TX_DMA_STATUS_DU;
+		/*
+		 * There is no need to touch HW descriptor:
+		 * - ststus bit TX_DMA_STATUS_DU is set by design,
+		 *   so hardware will not try to process this desc.,
+		 * - rest of descriptor will be initialized on Tx.
+		 */
 		vring->swtail = wil_vring_next_tail(vring);
 		done++;
 	}
-- 
1.8.1.2


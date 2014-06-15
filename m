Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:49854 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752632AbaFOUiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:50 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	netdev@vger.kernel.org
Subject: [PATCH -next 14/26] rt2x00: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:43 -0700
Message-Id: <cbc917d6b5c2682ad90ca712eae7da9c041ab1af.1402863905.git.joe@perches.com> (sfid-20140615_224255_535322_37D26482)
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/rt2x00/rt2x00mmio.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mmio.c b/drivers/net/wireless/rt2x00/rt2x00mmio.c
index 6f236ea..f0178fd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mmio.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mmio.c
@@ -119,14 +119,12 @@ static int rt2x00mmio_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Allocate DMA memory for descriptor and buffer.
 	 */
-	addr = dma_alloc_coherent(rt2x00dev->dev,
-				  queue->limit * queue->desc_size,
-				  &dma, GFP_KERNEL);
+	addr = dma_zalloc_coherent(rt2x00dev->dev,
+				   queue->limit * queue->desc_size, &dma,
+				   GFP_KERNEL);
 	if (!addr)
 		return -ENOMEM;
 
-	memset(addr, 0, queue->limit * queue->desc_size);
-
 	/*
 	 * Initialize all queue entries to contain valid addresses.
 	 */
-- 
1.8.1.2.459.gbcd45b4.dirty


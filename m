Return-Path: <SRS0=yoP0=R3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D832C4360F
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 13:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5574222DA
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 13:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553434331;
	bh=+X0ggVubXnDee5xsUa36ECKwOER5tlYZcsyXzDpOtq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JVuvEj8kxw7fI7k5NxFHXc29JS2j+04QPnFu/ZfqIyzU8brnla9r7xSRpOLveYsdb
	 p3XnzZSOpEDd02+k2mAapUtyMWBXspsmCaILMqlMIUq+YMRAwCXXOoZpj88j59dshC
	 Py64x28AXskQHNe+b2gf4ZQWN4sT5jG9n/B6BtRM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfCXNcK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Mar 2019 09:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727252AbfCXNcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Mar 2019 09:32:10 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08EC5222D6;
        Sun, 24 Mar 2019 13:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553434329;
        bh=+X0ggVubXnDee5xsUa36ECKwOER5tlYZcsyXzDpOtq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q6xSdgSdixjYlAk/KWZR70tnWC/SL6i4sCXpbLPQ/UfwEJwn+0RG7N0vesV6ih1e/
         REi1JbSBUVWeflLry/PhZ+i+rbq+1o1XFOLM9afXMFzWljswxEWiSwpUSu4qBqoShQ
         Z5G5fs91QHh+udGglrOkW/haPxtPwr7eRzChoqmA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mt76: dma: add skb check for dummy pointer
Date:   Sun, 24 Mar 2019 14:31:11 +0100
Message-Id: <7c3cc3aa6a07a902a25e64b84266964702846de7.1553425942.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1553425942.git.lorenzo@kernel.org>
References: <cover.1553425942.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce skb check for dummy address in mt76_dma_tx_cleanup_idx.
This is a preliminary patch to add support for new chipsets (e.g. 7615)

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 9 +++++----
 drivers/net/wireless/mediatek/mt76/dma.h | 2 ++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 8302ebd89338..8a4b935d03b2 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -18,8 +18,6 @@
 #include "mt76.h"
 #include "dma.h"
 
-#define DMA_DUMMY_TXWI	((void *) ~0)
-
 static int
 mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
 		     int idx, int n_desc, int bufsize,
@@ -67,7 +65,7 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
 	int i, idx = -1;
 
 	if (txwi)
-		q->entry[q->head].txwi = DMA_DUMMY_TXWI;
+		q->entry[q->head].txwi = DMA_DUMMY_DATA;
 
 	for (i = 0; i < nbufs; i += 2, buf += 2) {
 		u32 buf0 = buf[0].addr, buf1 = 0;
@@ -126,9 +124,12 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 				 DMA_TO_DEVICE);
 	}
 
-	if (e->txwi == DMA_DUMMY_TXWI)
+	if (e->txwi == DMA_DUMMY_DATA)
 		e->txwi = NULL;
 
+	if (e->skb == DMA_DUMMY_DATA)
+		e->skb = NULL;
+
 	*prev_e = *e;
 	memset(e, 0, sizeof(*e));
 }
diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index e3292df5e9b2..03dd2bafa4e8 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -16,6 +16,8 @@
 #ifndef __MT76_DMA_H
 #define __MT76_DMA_H
 
+#define DMA_DUMMY_DATA			((void *)~0)
+
 #define MT_RING_SIZE			0x10
 
 #define MT_DMA_CTL_SD_LEN1		GENMASK(13, 0)
-- 
2.20.1


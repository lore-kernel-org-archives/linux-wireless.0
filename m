Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D1FC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 14:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D945D20857
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 14:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731845AbfCZO2c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 10:28:32 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:27787 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731475AbfCZO2U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 10:28:20 -0400
X-UUID: 5f85ea2dd4ba4c28b3777424eeff3904-20190326
X-UUID: 5f85ea2dd4ba4c28b3777424eeff3904-20190326
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1194350895; Tue, 26 Mar 2019 22:28:14 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 26 Mar 2019 22:28:13 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 26 Mar 2019 22:28:13 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
CC:     Roy Luo <royluo@google.com>, Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        YF Luo <yf.luo@mediatek.com>, Kai Lin <kai.lin@mediatek.com>,
        Rorscha Yang <rorscha.yang@mediatek.com>,
        Kyle Lee <kyle.lee@mediatek.com>,
        Miller Shen <miller.shen@mediatek.com>,
        Haipin Liang <haipin.liang@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 2/4] mt76: add unlikely() for dma_mapping_error() check
Date:   Tue, 26 Mar 2019 22:28:08 +0800
Message-ID: <ebd07347cc26a2e7dd7d7e1e1d213d80fc9d0940.1553607739.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1553607739.git.ryder.lee@mediatek.com>
References: <cover.1553607739.git.ryder.lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In the tx/rx fastpath, the funciton dma_map_single() rarely fails.
This adds unlikely() optimization to this error check conditional.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 8a4b935..6f3ef09 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -272,7 +272,7 @@
 
 	addr = dma_map_single(dev->dev, skb->data, skb->len,
 			      DMA_TO_DEVICE);
-	if (dma_mapping_error(dev->dev, addr))
+	if (unlikely(dma_mapping_error(dev->dev, addr)))
 		return -ENOMEM;
 
 	buf.addr = addr;
@@ -315,7 +315,7 @@
 
 	len = skb_headlen(skb);
 	addr = dma_map_single(dev->dev, skb->data, len, DMA_TO_DEVICE);
-	if (dma_mapping_error(dev->dev, addr))
+	if (unlikely(dma_mapping_error(dev->dev, addr)))
 		goto free;
 
 	tx_info.buf[n].addr = t->dma_addr;
@@ -329,7 +329,7 @@
 
 		addr = dma_map_single(dev->dev, iter->data, iter->len,
 				      DMA_TO_DEVICE);
-		if (dma_mapping_error(dev->dev, addr))
+		if (unlikely(dma_mapping_error(dev->dev, addr)))
 			goto unmap;
 
 		tx_info.buf[n].addr = addr;
@@ -386,7 +386,7 @@
 			break;
 
 		addr = dma_map_single(dev->dev, buf, len, DMA_FROM_DEVICE);
-		if (dma_mapping_error(dev->dev, addr)) {
+		if (unlikely(dma_mapping_error(dev->dev, addr))) {
 			skb_free_frag(buf);
 			break;
 		}
-- 
1.9.1


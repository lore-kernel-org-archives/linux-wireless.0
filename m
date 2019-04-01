Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E02C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 06:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9949F2084B
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 06:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731686AbfDAG4g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 02:56:36 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:51576 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725867AbfDAG4g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 02:56:36 -0400
X-UUID: 42525c55dd284c4bae42b98f6b8bb3a8-20190401
X-UUID: 42525c55dd284c4bae42b98f6b8bb3a8-20190401
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 50836532; Mon, 01 Apr 2019 14:56:29 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 1 Apr 2019 14:56:27 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 1 Apr 2019 14:56:27 +0800
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
        KL Huang <kl.huang@mediatek.com>,
        YH chen <yh.chen@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH v2 2/4] mt76: add unlikely() for dma_mapping_error() check
Date:   Mon, 1 Apr 2019 14:56:23 +0800
Message-ID: <3a9f54e6a5bbbdab2a3129b1b541a951e8b695fa.1554100584.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1554100584.git.ryder.lee@mediatek.com>
References: <cover.1554100584.git.ryder.lee@mediatek.com>
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


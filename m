Return-Path: <SRS0=76X5=YW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA886CA9EC2
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Oct 2019 04:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91AE62087F
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Oct 2019 04:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731704AbfJ2El1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Oct 2019 00:41:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46854 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727294AbfJ2El1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Oct 2019 00:41:27 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5EB26E443D1CB4F03C80;
        Tue, 29 Oct 2019 12:41:23 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 29 Oct 2019
 12:41:16 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <royluo@google.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <matthias.bgg@gmail.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH] mt76: Remove set but not used variable 'idx'
Date:   Tue, 29 Oct 2019 12:48:39 +0800
Message-ID: <1572324519-39669-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/mediatek/mt76/dma.c: In function mt76_dma_rx_fill:
drivers/net/wireless/mediatek/mt76/dma.c:377:6: warning: variable idx set but not used [-Wunused-but-set-variable]

It is not used since commit 17f1de56df05 ("mt76:
add common code shared between multiple chipsets")

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index c747eb2..70fab98 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -363,7 +363,6 @@ mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q)
 	int frames = 0;
 	int len = SKB_WITH_OVERHEAD(q->buf_size);
 	int offset = q->buf_offset;
-	int idx;

 	spin_lock_bh(&q->lock);

@@ -382,7 +381,7 @@ mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q)

 		qbuf.addr = addr + offset;
 		qbuf.len = len - offset;
-		idx = mt76_dma_add_buf(dev, q, &qbuf, 1, 0, buf, NULL);
+		mt76_dma_add_buf(dev, q, &qbuf, 1, 0, buf, NULL);
 		frames++;
 	}

--
2.7.4


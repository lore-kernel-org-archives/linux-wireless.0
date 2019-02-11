Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46943C282D7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 08:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1785C20823
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 08:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfBKIst (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 03:48:49 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:1489 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726663AbfBKIst (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 03:48:49 -0500
X-UUID: b70ecbec81c0485083de5ba5a381ccd3-20190211
X-UUID: b70ecbec81c0485083de5ba5a381ccd3-20190211
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 313218281; Mon, 11 Feb 2019 16:48:39 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 11 Feb 2019 16:48:37 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 11 Feb 2019 16:48:37 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>
CC:     Roy Luo <roychl666@gmail.com>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Subject: [Resend PATCH] mt76: change the return type of mt76_dma_attach()
Date:   Mon, 11 Feb 2019 16:48:29 +0800
Message-ID:
 <228fdddb9ca96e8ce861e324eb9039722cf18f49.1549850911.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Message-ID: <20190211084829.EG2lf0PWA93f7pUXaAnhpR3vCmxCko9n4Wu5-I3EK-o@z>

There is no need to return 0 in mt76_dma_attach(), so switch it to void.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 3 +--
 drivers/net/wireless/mediatek/mt76/dma.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index e2ba263..d934d72 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -522,10 +522,9 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	.kick = mt76_dma_kick_queue,
 };
 
-int mt76_dma_attach(struct mt76_dev *dev)
+void mt76_dma_attach(struct mt76_dev *dev)
 {
 	dev->queue_ops = &mt76_dma_ops;
-	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76_dma_attach);
 
diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index 357cc35..e3292df 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -54,7 +54,7 @@ enum mt76_mcu_evt_type {
 	EVT_EVENT_DFS_DETECT_RSP,
 };
 
-int mt76_dma_attach(struct mt76_dev *dev);
+void mt76_dma_attach(struct mt76_dev *dev);
 void mt76_dma_cleanup(struct mt76_dev *dev);
 
 #endif
-- 
1.9.1


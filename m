Return-Path: <SRS0=sJ5f=TE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2342C43219
	for <linux-wireless@archiver.kernel.org>; Sat,  4 May 2019 10:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CF322084A
	for <linux-wireless@archiver.kernel.org>; Sat,  4 May 2019 10:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfEDKXH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 4 May 2019 06:23:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56432 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfEDKXG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 May 2019 06:23:06 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C39828FB586CBB087327;
        Sat,  4 May 2019 18:23:04 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 4 May 2019
 18:22:54 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <royluo@google.com>,
        <kvalo@codeaurora.org>, <matthias.bgg@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] mt76: mt7615: Make mt7615_irq_handler static
Date:   Sat, 4 May 2019 18:22:47 +0800
Message-ID: <20190504102247.43720-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix sparse warning:

drivers/net/wireless/mediatek/mt76/mt7615/pci.c:37:13:
 warning: symbol 'mt7615_irq_handler' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
index 11122bd..c181e59 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
@@ -34,7 +34,7 @@ void mt7615_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
 	mt7615_irq_enable(dev, MT_INT_RX_DONE(q));
 }
 
-irqreturn_t mt7615_irq_handler(int irq, void *dev_instance)
+static irqreturn_t mt7615_irq_handler(int irq, void *dev_instance)
 {
 	struct mt7615_dev *dev = dev_instance;
 	u32 intr;
-- 
2.7.4



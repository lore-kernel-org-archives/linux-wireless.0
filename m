Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397A7C4361B
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Dec 2020 17:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA25D233EA
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Dec 2020 17:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgLPRZY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:25:24 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:60011 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727092AbgLPRZY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Dec 2020 12:25:24 -0500
X-UUID: 47f6b95d57d641b6b4ad8e77449b6b1b-20201217
X-UUID: 47f6b95d57d641b6b4ad8e77449b6b1b-20201217
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1504879476; Thu, 17 Dec 2020 01:24:39 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 17 Dec 2020 01:24:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 01:24:31 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC:     Shayne Chen <shayne.chen@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH] mt76: mt7915: increase buffer size to receive large MPDUs
Date:   Thu, 17 Dec 2020 01:24:33 +0800
Message-ID: <00af8edba9bad0e3635ca6024fcf56b3bcd407f8.1608139125.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 22E80B00BD3160462AC45C12C5C498467279081312E2CABE828927BE4E031CA82000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This improves 5G/HE Rx performance around 70mbps.

Tested-by: Chih-Min Chen <chih-min.chen@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
index 8c1f9c77b14f..a8c783be297f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
@@ -203,7 +203,7 @@ int mt7915_dma_init(struct mt7915_dev *dev)
 {
 	/* Increase buffer size to receive large VHT/HE MPDUs */
 	struct mt76_bus_ops *bus_ops;
-	int rx_buf_size = MT_RX_BUF_SIZE * 2;
+	int rx_buf_size = MT_RX_BUF_SIZE * 4;
 	int ret;
 
 	dev->bus_ops = dev->mt76.bus;
-- 
2.18.0


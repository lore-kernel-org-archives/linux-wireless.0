Return-Path: <SRS0=Pq/w=BU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F30C433DF
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 08:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6128B2070B
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 08:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="VVrwsCIX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHJI6h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Aug 2020 04:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgHJI6h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Aug 2020 04:58:37 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C41C061756
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2020 01:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=txyU2DYS92zJPi/+HLJ2HqnUNymAW/ZBywe1P9zGKqg=; b=VVrwsCIXkAzy81wTvh2dEbsoM7
        SsSUWdIlxpSRvu5r3Ep9XMH2kRzvH8ZhTxik+ONu/yI6cbBmURI/zYNDgNzUe69cci5h19lMY7vVa
        +7W3T4O0E2km00QK7da8igMXdc5clTdI3N8F6m9sHH1yOTAE6xFwhwIrJ+mhnlVJMehc=;
Received: from p54ae996c.dip0.t-ipconnect.de ([84.174.153.108] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1k53da-0003XJ-8P
        for linux-wireless@vger.kernel.org; Mon, 10 Aug 2020 10:58:34 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] mt76: mt7615: only clear unmasked interrupts in irq tasklet
Date:   Mon, 10 Aug 2020 10:58:29 +0200
Message-Id: <20200810085832.65662-3-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810085832.65662-1-nbd@nbd.name>
References: <20200810085832.65662-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If an interrupt is temporarily masked, its pending events need to be processed
later, even if another interrupt happened in the mean time.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7615/mmio.c  | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
index a0526f06262b..99ece641bdef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mmio.c
@@ -106,25 +106,24 @@ static void mt7615_irq_tasklet(unsigned long data)
 	mt76_wr(dev, MT_INT_MASK_CSR, 0);
 
 	intr = mt76_rr(dev, MT_INT_SOURCE_CSR);
+	intr &= dev->mt76.mmio.irqmask;
 	mt76_wr(dev, MT_INT_SOURCE_CSR, intr);
 
 	trace_dev_irq(&dev->mt76, intr, dev->mt76.mmio.irqmask);
-	intr &= dev->mt76.mmio.irqmask;
 
-	if (intr & MT_INT_TX_DONE_ALL) {
+	mask |= intr & MT_INT_RX_DONE_ALL;
+	if (intr & MT_INT_TX_DONE_ALL)
 		mask |= MT_INT_TX_DONE_ALL;
+	mt76_set_irq_mask(&dev->mt76, MT_INT_MASK_CSR, mask, 0);
+
+	if (intr & MT_INT_TX_DONE_ALL)
 		napi_schedule(&dev->mt76.tx_napi);
-	}
 
-	if (intr & MT_INT_RX_DONE(0)) {
-		mask |= MT_INT_RX_DONE(0);
+	if (intr & MT_INT_RX_DONE(0))
 		napi_schedule(&dev->mt76.napi[0]);
-	}
 
-	if (intr & MT_INT_RX_DONE(1)) {
-		mask |= MT_INT_RX_DONE(1);
+	if (intr & MT_INT_RX_DONE(1))
 		napi_schedule(&dev->mt76.napi[1]);
-	}
 
 	if (intr & MT_INT_MCU_CMD) {
 		u32 val = mt76_rr(dev, MT_MCU_CMD);
@@ -135,8 +134,6 @@ static void mt7615_irq_tasklet(unsigned long data)
 			wake_up(&dev->reset_wait);
 		}
 	}
-
-	mt76_set_irq_mask(&dev->mt76, MT_INT_MASK_CSR, mask, 0);
 }
 
 static u32 __mt7615_reg_addr(struct mt7615_dev *dev, u32 addr)
-- 
2.28.0


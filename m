Return-Path: <SRS0=Pq/w=BU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6F8C433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 08:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E18C120729
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Aug 2020 08:58:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="K86tOoWF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHJI6i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Aug 2020 04:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgHJI6h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Aug 2020 04:58:37 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D022C06178A
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2020 01:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eygD9HeAHdonIJ/fF2KL4r1c9/o5pFJ/6XhIOIYvZEM=; b=K86tOoWFxzFfRu3gmIPqSTugsN
        6dOYpNSEb6WvWy3nFbJmm4+SUeNI6pVDx/ufn5xN6/YU7x7WybzTk4thwWcTmq/tpNuy7gqW4qlcY
        uf4K0QuYwOnIkUGTh6Y+4I7F/kgET3kFKSbZaaBnWXcRmmUh53PqA6yoFhnzrz52AuHM=;
Received: from p54ae996c.dip0.t-ipconnect.de ([84.174.153.108] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1k53da-0003XJ-E4
        for linux-wireless@vger.kernel.org; Mon, 10 Aug 2020 10:58:34 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] mt76: mt76x02: clean up and fix interrupt masking in the irq handler
Date:   Mon, 10 Aug 2020 10:58:30 +0200
Message-Id: <20200810085832.65662-4-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810085832.65662-1-nbd@nbd.name>
References: <20200810085832.65662-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Only clear unmasked interrupts. If an interrupt is temporarily masked,
its pending events need to be processed later, even if another interrupt
happened in the mean time.
Disable interrupts in one call before scheduling

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 25 ++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 99611515a093..20db80849b09 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -263,9 +263,10 @@ EXPORT_SYMBOL_GPL(mt76x02_rx_poll_complete);
 irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance)
 {
 	struct mt76x02_dev *dev = dev_instance;
-	u32 intr;
+	u32 intr, mask;
 
 	intr = mt76_rr(dev, MT_INT_SOURCE_CSR);
+	intr &= dev->mt76.mmio.irqmask;
 	mt76_wr(dev, MT_INT_SOURCE_CSR, intr);
 
 	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mphy.state))
@@ -273,17 +274,17 @@ irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance)
 
 	trace_dev_irq(&dev->mt76, intr, dev->mt76.mmio.irqmask);
 
-	intr &= dev->mt76.mmio.irqmask;
+	mask = intr & (MT_INT_RX_DONE_ALL | MT_INT_GPTIMER);
+	if (intr & (MT_INT_TX_DONE_ALL | MT_INT_TX_STAT))
+		mask |= MT_INT_TX_DONE_ALL;
+
+	mt76x02_irq_disable(dev, mask);
 
-	if (intr & MT_INT_RX_DONE(0)) {
-		mt76x02_irq_disable(dev, MT_INT_RX_DONE(0));
+	if (intr & MT_INT_RX_DONE(0))
 		napi_schedule(&dev->mt76.napi[0]);
-	}
 
-	if (intr & MT_INT_RX_DONE(1)) {
-		mt76x02_irq_disable(dev, MT_INT_RX_DONE(1));
+	if (intr & MT_INT_RX_DONE(1))
 		napi_schedule(&dev->mt76.napi[1]);
-	}
 
 	if (intr & MT_INT_PRE_TBTT)
 		tasklet_schedule(&dev->mt76.pre_tbtt_tasklet);
@@ -299,15 +300,11 @@ irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance)
 	if (intr & MT_INT_TX_STAT)
 		mt76x02_mac_poll_tx_status(dev, true);
 
-	if (intr & (MT_INT_TX_STAT | MT_INT_TX_DONE_ALL)) {
-		mt76x02_irq_disable(dev, MT_INT_TX_DONE_ALL);
+	if (intr & (MT_INT_TX_STAT | MT_INT_TX_DONE_ALL))
 		napi_schedule(&dev->mt76.tx_napi);
-	}
 
-	if (intr & MT_INT_GPTIMER) {
-		mt76x02_irq_disable(dev, MT_INT_GPTIMER);
+	if (intr & MT_INT_GPTIMER)
 		tasklet_schedule(&dev->dfs_pd.dfs_tasklet);
-	}
 
 	return IRQ_HANDLED;
 }
-- 
2.28.0


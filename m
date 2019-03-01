Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53829C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 14:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 162982084F
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 14:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="KuCKFzE0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388333AbfCAOU1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:20:27 -0500
Received: from nbd.name ([46.4.11.11]:50344 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388320AbfCAOUZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 09:20:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gszdvwF6/QEm3MsLM2KwECcq7mGIzKg0q/99W4/5tU0=; b=KuCKFzE0ncLxEuTvV1ijMpM7L1
        UUSrdU4HVJQWuzn3wwplspqNh1M1/6iH5jf58yLrlU1N/rm4fHt62BwcaJA2uAkpwZwvmJYFM3ARC
        ZRZ+xgl9FjOZbpdOgD/UUDq4fahR2NjxXZZ/ygd0PfnFxSVXW9XE+nhfg6lbPnh2enWk=;
Received: by maeck.lan (Postfix, from userid 501)
        id 09FDA50B0028; Fri,  1 Mar 2019 15:20:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mt76: rewrite dma descriptor base and ring size on queue reset
Date:   Fri,  1 Mar 2019 15:20:21 +0100
Message-Id: <20190301142023.18179-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Useful in case the hardware reset clobbers these values

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 4db1f088ee91..4e2dfb0f20c3 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -137,6 +137,8 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 static void
 mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_queue *q)
 {
+	iowrite32(q->desc_dma, &q->regs->desc_base);
+	iowrite32(q->ndesc, &q->regs->ring_size);
 	q->head = ioread32(&q->regs->dma_idx);
 	q->tail = q->head;
 	iowrite32(q->head, &q->regs->cpu_idx);
-- 
2.17.0


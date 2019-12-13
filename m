Return-Path: <SRS0=3oid=2D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06486C43603
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Dec 2019 21:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A4EB2253D
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Dec 2019 21:36:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="frISWk8f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfLMVgb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Dec 2019 16:36:31 -0500
Received: from nbd.name ([46.4.11.11]:47438 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfLMVgb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Dec 2019 16:36:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=arTOw5i32gwSH/Vxa9XtdEqYfXK+VS+6EA+nIi4oE8M=; b=frISWk8fH8ou0RSLuHZg2TupRx
        DdNSVxflreYzrOagX3Z7SNNbBgCF9bFtOTz6p8j9toRBlSNlKp+WRjHqR9JJvm0asp/btPqP+nqiw
        Lz3UX4ld4cW9oPuUFolJPMVjoAHjlKT5mTEZ9jNh9SpF6qe4BdGj+pSZU8IcST3glelo=;
Received: from p4ff13e83.dip0.t-ipconnect.de ([79.241.62.131] helo=maeck.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ifsbt-0001nY-NS
        for linux-wireless@vger.kernel.org; Fri, 13 Dec 2019 22:36:30 +0100
Received: by maeck.local (Postfix, from userid 501)
        id 21E6373C1141; Fri, 13 Dec 2019 22:36:28 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mt76: fix rx dma ring descriptor state on reset
Date:   Fri, 13 Dec 2019 22:36:27 +0100
Message-Id: <20191213213628.73840-3-nbd@nbd.name>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191213213628.73840-1-nbd@nbd.name>
References: <20191213213628.73840-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

To avoid having the hardware potentially write to memory behind stale
descriptors, set the dma-done flag on all of them before cleaning up
allocated rx buffers

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index f88d017ff987..2298a4e91943 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -437,7 +437,7 @@ mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
 	int i;
 
 	for (i = 0; i < q->ndesc; i++)
-		q->desc[i].ctrl &= ~cpu_to_le32(MT_DMA_CTL_DMA_DONE);
+		q->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
 
 	mt76_dma_rx_cleanup(dev, q);
 	mt76_dma_sync_idx(dev, q);
-- 
2.24.0


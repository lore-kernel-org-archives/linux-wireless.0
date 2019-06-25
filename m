Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8372C48BD5
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 10:30:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1CB621655
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 10:30:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r48n87qm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfFYKaN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 06:30:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731567AbfFYK3l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 06:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rkl/uuobm6HdnQQiw4phyXCzZ7W1wU0AW7nL80/+SRc=; b=r48n87qmXKWVn7chb2eV1XCzLB
        cKzby3GZvg/e0AP+Nru9toZGD5Y/W/LsFXXaB3xwLygLHlgMEqih+ubEWFgG4PhyvhOERcbVJ0aCD
        YtKW9/3ei1uS8N1Uad6SFFmAy49fBXdg1yLJHofljw4XSKPiFrLRJWqjTQFfRXM+g2cgoGQGoJEBq
        2ycDHs+76zQIdvfdv2eYv+O0SRRJKhH4A3uLNiDr9UOmF7L4G7C+QUEbWkeHJDyRq7tPgEGkcVnBC
        cGlfXuaa9YNfO4K5HFdwMDaoLVsOGUAzyMMZs1gdyofAS3ge9bIhgI4qbwVwWPs6l7b3z2ByG3gHh
        NwHSReaA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfiho-0005TL-5H; Tue, 25 Jun 2019 10:29:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] b43legacy: simplify engine type / DMA mask selection
Date:   Tue, 25 Jun 2019 12:29:30 +0200
Message-Id: <20190625102932.32257-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190625102932.32257-1-hch@lst.de>
References: <20190625102932.32257-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Return the engine type from the function looking at the registers, and
just derive the DMA mask from that in the one place we care.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/wireless/broadcom/b43legacy/dma.c | 20 +++----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/dma.c b/drivers/net/wireless/broadcom/b43legacy/dma.c
index 0c2de20622e3..e66d05ae2466 100644
--- a/drivers/net/wireless/broadcom/b43legacy/dma.c
+++ b/drivers/net/wireless/broadcom/b43legacy/dma.c
@@ -616,7 +616,7 @@ static void free_all_descbuffers(struct b43legacy_dmaring *ring)
 	}
 }
 
-static u64 supported_dma_mask(struct b43legacy_wldev *dev)
+static enum b43legacy_dmatype b43legacy_engine_type(struct b43legacy_wldev *dev)
 {
 	u32 tmp;
 	u16 mmio_base;
@@ -628,18 +628,7 @@ static u64 supported_dma_mask(struct b43legacy_wldev *dev)
 	tmp = b43legacy_read32(dev, mmio_base +
 			       B43legacy_DMA32_TXCTL);
 	if (tmp & B43legacy_DMA32_TXADDREXT_MASK)
-		return DMA_BIT_MASK(32);
-
-	return DMA_BIT_MASK(30);
-}
-
-static enum b43legacy_dmatype dma_mask_to_engine_type(u64 dmamask)
-{
-	if (dmamask == DMA_BIT_MASK(30))
-		return B43legacy_DMA_30BIT;
-	if (dmamask == DMA_BIT_MASK(32))
 		return B43legacy_DMA_32BIT;
-	B43legacy_WARN_ON(1);
 	return B43legacy_DMA_30BIT;
 }
 
@@ -801,13 +790,10 @@ int b43legacy_dma_init(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_dma *dma = &dev->dma;
 	struct b43legacy_dmaring *ring;
+	enum b43legacy_dmatype type = b43legacy_engine_type(dev);
 	int err;
-	u64 dmamask;
-	enum b43legacy_dmatype type;
 
-	dmamask = supported_dma_mask(dev);
-	type = dma_mask_to_engine_type(dmamask);
-	err = dma_set_mask_and_coherent(dev->dev->dma_dev, dmamask);
+	err = dma_set_mask_and_coherent(dev->dev->dma_dev, DMA_BIT_MASK(type));
 	if (err) {
 #ifdef CONFIG_B43LEGACY_PIO
 		b43legacywarn(dev->wl, "DMA for this device not supported. "
-- 
2.20.1


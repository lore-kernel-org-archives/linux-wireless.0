Return-Path: <SRS0=mNjQ=UN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BCEDC31E4D
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 13:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 040D720866
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 13:49:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fFAKLKpe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbfFNNtj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:49:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52676 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbfFNNsM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Jun 2019 09:48:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7ZdZ3kFG7vLtpGzKUifkfy5au7mGeecDZr7pOAa/mbQ=; b=fFAKLKpeX1UXm3FTcf0KpVo86s
        TAVWErFRg7UqZpj/joIjhsfplRvSdKGAbFeP6PmZqe8B9ErySOXGc93t2ofqJ0PfW5tVLu+2bO7c7
        tlkcsmUTpcJGdiZudPM+9H/J7qA++YYntqBAP5nQMfi/0VmsaFYiz8iIh+FqmdmOSIDCUkX2AxyUg
        4+iPQe6FbA5imHkaPuPHdlmpbWkOZY2IPMBFcFQu5749gI0wQ18r1UkUghz38MdwIvcYqglGbv42Q
        OE9k8pQvOkUoTghcB7fXqj/U8J8TtUon4YKIlHWSSpbaJgmCuw3j4dq3Y7DAL3QyTY+SLK4x/iHsn
        p71d6N7w==;
Received: from 213-225-9-13.nat.highway.a1.net ([213.225.9.13] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbmYk-0005GV-78; Fri, 14 Jun 2019 13:48:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Intel Linux Wireless <linuxwifi@intel.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/16] cnic: stop passing bogus gfp flags arguments to dma_alloc_coherent
Date:   Fri, 14 Jun 2019 15:47:19 +0200
Message-Id: <20190614134726.3827-10-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614134726.3827-1-hch@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

dma_alloc_coherent is not just the page allocator.  The only valid
arguments to pass are either GFP_ATOMIC or GFP_ATOMIC with possible
modifiers of __GFP_NORETRY or __GFP_NOWARN.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/broadcom/cnic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 57dc3cbff36e..bd1c993680e5 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -1028,7 +1028,7 @@ static int __cnic_alloc_uio_rings(struct cnic_uio_dev *udev, int pages)
 	udev->l2_ring_size = pages * CNIC_PAGE_SIZE;
 	udev->l2_ring = dma_alloc_coherent(&udev->pdev->dev, udev->l2_ring_size,
 					   &udev->l2_ring_map,
-					   GFP_KERNEL | __GFP_COMP);
+					   GFP_KERNEL);
 	if (!udev->l2_ring)
 		return -ENOMEM;
 
@@ -1036,7 +1036,7 @@ static int __cnic_alloc_uio_rings(struct cnic_uio_dev *udev, int pages)
 	udev->l2_buf_size = CNIC_PAGE_ALIGN(udev->l2_buf_size);
 	udev->l2_buf = dma_alloc_coherent(&udev->pdev->dev, udev->l2_buf_size,
 					  &udev->l2_buf_map,
-					  GFP_KERNEL | __GFP_COMP);
+					  GFP_KERNEL);
 	if (!udev->l2_buf) {
 		__cnic_free_uio_rings(udev);
 		return -ENOMEM;
-- 
2.20.1


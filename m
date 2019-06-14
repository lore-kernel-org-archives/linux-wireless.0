Return-Path: <SRS0=mNjQ=UN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE52C31E4C
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 13:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3E0320866
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 13:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Tpc9x4lP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbfFNNsh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:48:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53828 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbfFNNsf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Jun 2019 09:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uJddLBdDNaWL4wSSvZ2YhjeFWIY1bS4Okt/V8tHSUJw=; b=Tpc9x4lPYqhK3XjIXO4GqJY9rv
        9rJeQeQNbim7ZbrvzWwlYZe6uviPZA8B8PnxWsyT6JGwXhhBWJVdSZXfCFQexWetdjj9pyjlFh9xF
        NNuQWOD5YMIca+yt05/XIg8Wkq6pGz0Z85GD2RuHezWtfbKqQOoREoRWCESCbTHgW7AMp5BbVshrc
        pEh3xewVIl6LVjW2c5Fh7o0QsoPF6TFPCQBrS9GLC8RQ30e45tR99TsjbM05NZ0+J3y0gAw3KzjRt
        lGDsivXtuD6ZbALT0tjqUJ7bWzADYRpbOi1VBP2HP7AECc7ayAViL+6MV1bLNQPDXazLoyPeSUXcq
        WTLTT30Q==;
Received: from 213-225-9-13.nat.highway.a1.net ([213.225.9.13] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbmYv-0005Sj-P5; Fri, 14 Jun 2019 13:48:14 +0000
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
Subject: [PATCH 12/16] staging/comedi: mark as broken
Date:   Fri, 14 Jun 2019 15:47:22 +0200
Message-Id: <20190614134726.3827-13-hch@lst.de>
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

comedi_buf.c abuse the DMA API in gravely broken ways, as it assumes it
can call virt_to_page on the result, and the just remap it as uncached
using vmap.  Disable the driver until this API abuse has been fixed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/staging/comedi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 049b659fa6ad..e7c021d76cfa 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config COMEDI
 	tristate "Data acquisition support (comedi)"
+	depends on BROKEN
 	help
 	  Enable support for a wide range of data acquisition devices
 	  for Linux.
-- 
2.20.1


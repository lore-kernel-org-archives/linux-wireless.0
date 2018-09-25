Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 312D0C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 19:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E22662089D
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 19:53:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E22662089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hauke-m.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbeIZCCQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 22:02:16 -0400
Received: from mx1.mailbox.org ([80.241.60.212]:25756 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727057AbeIZCCQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 22:02:16 -0400
Received: from smtp2.mailbox.org (unknown [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.mailbox.org (Postfix) with ESMTPS id 911AA49D1F;
        Tue, 25 Sep 2018 21:53:05 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id HkMqyK3pWIe2; Tue, 25 Sep 2018 21:53:03 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     kvalo@codeaurora.org, lorenzo.bianconi@redhat.com
Cc:     linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        matthias.bgg@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] mt76: use skb_pad() instead of __skb_pad()
Date:   Tue, 25 Sep 2018 21:52:51 +0200
Message-Id: <20180925195251.10568-1-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

mt76 uses __skb_pad() with free_on_error set to true, this is the same
as calling skb_pad().
This patch does not change any functionality, but it makes it easier to
backport this driver in backports, because skb_pad() is also available
in older kernel versions.

Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 7780b07543bb..e03de13f5afe 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -535,7 +535,7 @@ int mt76u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
 	}
 
 	if (unlikely(pad)) {
-		if (__skb_pad(last, pad, true))
+		if (skb_pad(last, pad))
 			return -ENOMEM;
 		__skb_put(last, pad);
 	}
-- 
2.11.0


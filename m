Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DB1C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C400321874
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbfCUP0g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:26:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbfCUP0f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 11:26:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 970D7811D3;
        Thu, 21 Mar 2019 15:26:35 +0000 (UTC)
Received: from localhost (ovpn-204-211.brq.redhat.com [10.40.204.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 342B190A8;
        Thu, 21 Mar 2019 15:26:35 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 11/12] mt76usb: allocate urb and sg as linear data
Date:   Thu, 21 Mar 2019 16:25:36 +0100
Message-Id: <20190321152537.19105-12-sgruszka@redhat.com>
In-Reply-To: <20190321152537.19105-1-sgruszka@redhat.com>
References: <20190321152537.19105-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 21 Mar 2019 15:26:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Alloc sg table at the end of urb structure. This will increase
cache usage.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 0ae69c2fedaf..a80d6abee748 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -336,19 +336,19 @@ mt76u_refill_rx(struct mt76_dev *dev, struct urb *urb, int nsgs, gfp_t gfp)
 static int
 mt76u_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
 {
-	struct urb *urb;
+	unsigned int size = sizeof(struct urb);
+
+	if (dev->usb.sg_en)
+		size += MT_SG_MAX_SIZE * sizeof(struct scatterlist);
 
-	urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!urb)
+	e->urb = kzalloc(size, GFP_KERNEL);
+	if (!e->urb)
 		return -ENOMEM;
-	e->urb = urb;
 
-	if (dev->usb.sg_en) {
-		urb->sg = devm_kcalloc(dev->dev, MT_SG_MAX_SIZE,
-				       sizeof(*urb->sg), GFP_KERNEL);
-		if (!urb->sg)
-			return -ENOMEM;
-	}
+	usb_init_urb(e->urb);
+
+	if (dev->usb.sg_en)
+		e->urb->sg = (struct scatterlist *)(e->urb + 1);
 
 	return 0;
 }
-- 
2.20.1


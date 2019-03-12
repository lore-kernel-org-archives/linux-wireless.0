Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1458C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 806F620693
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfCLPHX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:07:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8323 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbfCLPHX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:07:23 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8886D307CB54;
        Tue, 12 Mar 2019 15:07:23 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A37C5DE6E;
        Tue, 12 Mar 2019 15:07:11 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 11/12] mt76usb: allocate urb and sg as linear data
Date:   Tue, 12 Mar 2019 16:06:05 +0100
Message-Id: <1552403166-3821-12-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 12 Mar 2019 15:07:23 +0000 (UTC)
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
index 0b9f0b5fd37d..dd487f65f44e 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -336,19 +336,19 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
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
-				       sizeof(urb->sg), GFP_KERNEL);
-		if (!urb->sg)
-			return -ENOMEM;
-	}
+	usb_init_urb(e->urb);
+
+	if (dev->usb.sg_en)
+		e->urb->sg = (struct scatterlist *)((u8 *)e->urb + sizeof(struct urb));
 
 	return 0;
 }
-- 
1.9.3


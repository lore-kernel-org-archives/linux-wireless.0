Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E519DC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C02C820693
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfCLPGs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:06:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfCLPGs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:06:48 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 04FD0C04D2E8;
        Tue, 12 Mar 2019 15:06:48 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E42A1001E78;
        Tue, 12 Mar 2019 15:06:47 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 08/12] mt76usb: remove MT_RXQ_MAIN queue from mt76u_urb_alloc
Date:   Tue, 12 Mar 2019 16:06:02 +0100
Message-Id: <1552403166-3821-9-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 12 Mar 2019 15:06:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Get the RX queue inside mt76u_refill_rx. This will allow to reuse
mt76u_urb_alloc for TX allocations.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 2c21f4773a19..ca62ddc03be2 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -283,12 +283,10 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 }
 
 static int
-mt76u_fill_rx_sg(struct mt76_dev *dev, struct urb *urb, int nsgs,
-		 gfp_t gfp)
+mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76_queue *q, struct urb *urb,
+		 int nsgs, gfp_t gfp)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	int sglen = SKB_WITH_OVERHEAD(q->buf_size);
-
 	int i;
 
 	for (i = 0; i < nsgs; i++) {
@@ -321,11 +319,12 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 }
 
 static int
-mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
-		struct urb *urb, int nsgs, gfp_t gfp)
+mt76u_refill_rx(struct mt76_dev *dev, struct urb *urb, int nsgs, gfp_t gfp)
 {
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+
 	if (dev->usb.sg_en) {
-		return mt76u_fill_rx_sg(dev, urb, nsgs, gfp);
+		return mt76u_fill_rx_sg(dev, q, urb, nsgs, gfp);
 	} else {
 		urb->transfer_buffer_length = SKB_WITH_OVERHEAD(q->buf_size);
 		urb->transfer_buffer = page_frag_alloc(&q->rx_page,
@@ -337,7 +336,6 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 static int
 mt76u_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	struct urb *urb;
 
 	urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -354,7 +352,7 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 		sg_init_table(urb->sg, MT_SG_MAX_SIZE);
 	}
 
-	return mt76u_refill_rx(dev, q, urb, MT_SG_MAX_SIZE, GFP_KERNEL);
+	return mt76u_refill_rx(dev, urb, MT_SG_MAX_SIZE, GFP_KERNEL);
 }
 
 static void mt76u_urb_free(struct urb *urb)
@@ -521,8 +519,7 @@ static void mt76u_rx_tasklet(unsigned long data)
 
 		count = mt76u_process_rx_entry(dev, urb);
 		if (count > 0) {
-			err = mt76u_refill_rx(dev, q, urb, count,
-					      GFP_ATOMIC);
+			err = mt76u_refill_rx(dev, urb, count, GFP_ATOMIC);
 			if (err < 0)
 				break;
 		}
-- 
1.9.3


Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB75CC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C627521874
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbfCUP02 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbfCUP01 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 11:26:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D872B58E3E;
        Thu, 21 Mar 2019 15:26:27 +0000 (UTC)
Received: from localhost (ovpn-204-211.brq.redhat.com [10.40.204.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E96111001DE4;
        Thu, 21 Mar 2019 15:26:24 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/12] mt76usb: remove MT_RXQ_MAIN queue from mt76u_urb_alloc
Date:   Thu, 21 Mar 2019 16:25:33 +0100
Message-Id: <20190321152537.19105-9-sgruszka@redhat.com>
In-Reply-To: <20190321152537.19105-1-sgruszka@redhat.com>
References: <20190321152537.19105-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 21 Mar 2019 15:26:27 +0000 (UTC)
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
index 48bbb4e3db2f..10507a26d598 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -283,12 +283,10 @@ mt76u_set_endpoints(struct usb_interface *intf,
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
@@ -321,11 +319,12 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct urb *urb, int nsgs,
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
@@ -337,7 +336,6 @@ mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
 static int
 mt76u_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	struct urb *urb;
 
 	urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -354,7 +352,7 @@ mt76u_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
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
2.20.1


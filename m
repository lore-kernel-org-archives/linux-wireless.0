Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECD5C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A723E20693
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfCLPHA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:07:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbfCLPHA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:07:00 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9F75F307DAB7;
        Tue, 12 Mar 2019 15:07:00 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 010C566D24;
        Tue, 12 Mar 2019 15:06:48 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 09/12] mt76usb: resue mt76u_urb_alloc for tx
Date:   Tue, 12 Mar 2019 16:06:03 +0100
Message-Id: <1552403166-3821-10-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 12 Mar 2019 15:07:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add new rx_urb_alloc routine and reuse common urb_alloc for tx
allocations.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 36 ++++++++++++++++----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index ca62ddc03be2..64fac91f1a72 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -352,7 +352,19 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 		sg_init_table(urb->sg, MT_SG_MAX_SIZE);
 	}
 
-	return mt76u_refill_rx(dev, urb, MT_SG_MAX_SIZE, GFP_KERNEL);
+	return 0;
+}
+
+static int
+mt76u_rx_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
+{
+	int err;
+
+	err = mt76u_urb_alloc(dev, e);
+	if (err)
+		return err;
+
+	return mt76u_refill_rx(dev, e->urb, MT_SG_MAX_SIZE, GFP_KERNEL);
 }
 
 static void mt76u_urb_free(struct urb *urb)
@@ -570,7 +582,7 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	q->buf_size = dev->usb.sg_en ? MT_RX_BUF_SIZE : PAGE_SIZE;
 	q->ndesc = MT_NUM_RX_ENTRIES;
 	for (i = 0; i < q->ndesc; i++) {
-		err = mt76u_urb_alloc(dev, &q->entry[i]);
+		err = mt76u_rx_urb_alloc(dev, &q->entry[i]);
 		if (err < 0)
 			return err;
 	}
@@ -769,9 +781,8 @@ static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)
 
 static int mt76u_alloc_tx(struct mt76_dev *dev)
 {
-	struct urb *urb;
 	struct mt76_queue *q;
-	int i, j;
+	int i, j, err;
 
 	for (i = 0; i <= MT_TXQ_PSD; i++) {
 		INIT_LIST_HEAD(&dev->q_tx[i].swq);
@@ -797,20 +808,9 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 
 		q->ndesc = MT_NUM_TX_ENTRIES;
 		for (j = 0; j < q->ndesc; j++) {
-			urb = usb_alloc_urb(0, GFP_KERNEL);
-			if (!urb)
-				return -ENOMEM;
-			q->entry[j].urb = urb;
-
-			if (dev->usb.sg_en) {
-				size_t size = MT_SG_MAX_SIZE *
-					      sizeof(struct scatterlist);
-
-				urb->sg = devm_kzalloc(dev->dev, size,
-						       GFP_KERNEL);
-				if (!urb->sg)
-					return -ENOMEM;
-			}
+			err = mt76u_urb_alloc(dev, &q->entry[j]);
+			if (err < 0)
+				return err;
 		}
 	}
 	return 0;
-- 
1.9.3


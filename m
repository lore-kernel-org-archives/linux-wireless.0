Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BF8C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D713221874
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbfCUP0a (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:26:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbfCUP03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 11:26:29 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD57B3168912;
        Thu, 21 Mar 2019 15:26:29 +0000 (UTC)
Received: from localhost (ovpn-204-211.brq.redhat.com [10.40.204.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8ABC1001E87;
        Thu, 21 Mar 2019 15:26:28 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 09/12] mt76usb: resue mt76u_urb_alloc for tx
Date:   Thu, 21 Mar 2019 16:25:34 +0100
Message-Id: <20190321152537.19105-10-sgruszka@redhat.com>
In-Reply-To: <20190321152537.19105-1-sgruszka@redhat.com>
References: <20190321152537.19105-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 21 Mar 2019 15:26:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add new rx_urb_alloc routine and reuse common urb_alloc for tx
allocations.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 35 ++++++++++++------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 10507a26d598..7cefa4fe8251 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -352,7 +352,19 @@ mt76u_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
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
@@ -770,9 +782,8 @@ static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)
 
 static int mt76u_alloc_tx(struct mt76_dev *dev)
 {
-	struct urb *urb;
 	struct mt76_queue *q;
-	int i, j;
+	int i, j, err;
 
 	for (i = 0; i <= MT_TXQ_PSD; i++) {
 		INIT_LIST_HEAD(&dev->q_tx[i].swq);
@@ -798,19 +809,9 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 
 		q->ndesc = MT_NUM_TX_ENTRIES;
 		for (j = 0; j < q->ndesc; j++) {
-			urb = usb_alloc_urb(0, GFP_KERNEL);
-			if (!urb)
-				return -ENOMEM;
-			q->entry[j].urb = urb;
-
-			if (!dev->usb.sg_en)
-				continue;
-
-			urb->sg = devm_kcalloc(dev->dev, MT_SG_MAX_SIZE,
-					       sizeof(struct scatterlist),
-					       GFP_KERNEL);
-			if (!urb->sg)
-				return -ENOMEM;
+			err = mt76u_urb_alloc(dev, &q->entry[j]);
+			if (err < 0)
+				return err;
 		}
 	}
 	return 0;
-- 
2.20.1


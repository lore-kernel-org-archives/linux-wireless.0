Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E81C3C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1785214AE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfCLPGa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:06:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50142 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726966AbfCLPGa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:06:30 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB72C307D775;
        Tue, 12 Mar 2019 15:06:29 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6DF35DE83;
        Tue, 12 Mar 2019 15:06:25 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 03/12] mt76usb: change mt76u_fill_rx_sg arguments
Date:   Tue, 12 Mar 2019 16:05:57 +0100
Message-Id: <1552403166-3821-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 12 Mar 2019 15:06:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We do not need to pass len and sglen to the function.
Additionally pass gfp to control allocation context.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 883e8a2b519f..dbabf7971798 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -285,11 +285,13 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 }
 
 static int
-mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
-		 int nsgs, int len, int sglen)
+mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf, int nsgs,
+		 gfp_t gfp)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	int sglen = SKB_WITH_OVERHEAD(q->buf_size);
 	struct urb *urb = buf->urb;
+
 	int i;
 
 	for (i = 0; i < nsgs; i++) {
@@ -297,7 +299,7 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 		void *data;
 		int offset;
 
-		data = page_frag_alloc(&q->rx_page, len, GFP_ATOMIC);
+		data = page_frag_alloc(&q->rx_page, q->buf_size, gfp);
 		if (!data)
 			break;
 
@@ -326,8 +328,7 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 		struct mt76u_buf *buf, int nsgs, gfp_t gfp)
 {
 	if (dev->usb.sg_en) {
-		return mt76u_fill_rx_sg(dev, buf, nsgs, q->buf_size,
-					SKB_WITH_OVERHEAD(q->buf_size));
+		return mt76u_fill_rx_sg(dev, buf, nsgs, gfp);
 	} else {
 		buf->buf = page_frag_alloc(&q->rx_page, q->buf_size, gfp);
 		return buf->buf ? 0 : -ENOMEM;
-- 
1.9.3


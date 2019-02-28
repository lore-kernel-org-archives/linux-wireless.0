Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B02C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 11:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3DAD20854
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 11:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551352139;
	bh=LvnQjPwNU+xWa8dFW7ZTxAP0/d0rMt5Ohvx4YJs4N6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZNYswLHIYcuvyi/J3ymCHAny0haDE/Uv2o29Tjv3WQ1dOlw6j7Xu1C+/w4nDl1v3l
	 MvQAMAStq/Abs0YFJWpQpScA7BCEambK4lIbTGP6wDvfdd0VB29qBxRMlcVfMQDI9d
	 4t3ljhpF2X+OhgLXX7QLToyIl6Temm1BWYMZTKkI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbfB1LI6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 06:08:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725918AbfB1LI6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 06:08:58 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E89E2083D;
        Thu, 28 Feb 2019 11:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551352137;
        bh=LvnQjPwNU+xWa8dFW7ZTxAP0/d0rMt5Ohvx4YJs4N6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNSoodyWxL35fT5Zl5ofcAgEv9+Rw+K9cB6TNj2GiRahIuXPS0g7S/xhVzI+uwaIY
         Ao6xChMbFuw0usMXDl6iXKZeQF/jZBVEwjNW6qwoRgzjWatz53VFD98hTldmzpzfGz
         xPfsncaArWuicEf1ADee+y3ctUUhB8J8VcqqU8OQ=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76: usb: grab rx_page_lock for legacy mode in mt76u_refill_rx
Date:   Thu, 28 Feb 2019 12:08:45 +0100
Message-Id: <ec679a39f00e9f8fabc698ef3d977ff97c841873.1551350717.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551350717.git.lorenzo@kernel.org>
References: <cover.1551350717.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Grab rx_page_lock in mt76u_refill_rx allocating rx buffer for 'legacy'
mode. Remove gfp from mt76u_refill_rx signature since we need to
use GFP_ATOMIC

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index ae6ada370597..7ce3c7f9d5d8 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -325,15 +325,17 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 
 static int
 mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
-		struct mt76u_buf *buf, int nsgs, gfp_t gfp)
+		struct mt76u_buf *buf, int nsgs)
 {
-	if (dev->usb.sg_en) {
+	if (dev->usb.sg_en)
 		return mt76u_fill_rx_sg(dev, buf, nsgs, q->buf_size,
 					SKB_WITH_OVERHEAD(q->buf_size));
-	} else {
-		buf->buf = page_frag_alloc(&q->rx_page, q->buf_size, gfp);
-		return buf->buf ? 0 : -ENOMEM;
-	}
+
+	spin_lock_bh(&q->rx_page_lock);
+	buf->buf = page_frag_alloc(&q->rx_page, q->buf_size, GFP_ATOMIC);
+	spin_unlock_bh(&q->rx_page_lock);
+
+	return buf->buf ? 0 : -ENOMEM;
 }
 
 static int
@@ -358,7 +360,7 @@ mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf)
 		sg_init_table(buf->urb->sg, MT_SG_MAX_SIZE);
 	}
 
-	return mt76u_refill_rx(dev, q, buf, MT_SG_MAX_SIZE, GFP_KERNEL);
+	return mt76u_refill_rx(dev, q, buf, MT_SG_MAX_SIZE);
 }
 
 static void mt76u_buf_free(struct mt76u_buf *buf)
@@ -529,8 +531,7 @@ static void mt76u_rx_tasklet(unsigned long data)
 
 		count = mt76u_process_rx_entry(dev, buf);
 		if (count > 0) {
-			err = mt76u_refill_rx(dev, q, buf, count,
-					      GFP_ATOMIC);
+			err = mt76u_refill_rx(dev, q, buf, count);
 			if (err < 0)
 				break;
 		}
-- 
2.20.1


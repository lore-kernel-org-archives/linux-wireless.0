Return-Path: <SRS0=LItA=3E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69FB1C33CB1
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jan 2020 10:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 372A024671
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jan 2020 10:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579085982;
	bh=xtmM5FZaQwnB9SqFaDHwLYHEr2a+XYvmCTsvqftsxWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uxkoJaD7rhyRQyhZEqVtEupoaBNCyp5AeUHhDzXnapzm66Pp6e5NSjSTX1eVUP0Ig
	 UYb0vErKlPKhx6l/8sxIVnnJm2q4qOGsQFFKPWd2iHT8DkcXKDrKwDxbORX+10qAtn
	 VzG8fUtBYDOQyMBeN49DpGYrPIUQekCdZeFjl7k0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgAOK7l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Jan 2020 05:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729856AbgAOK7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Jan 2020 05:59:41 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84F062467D;
        Wed, 15 Jan 2020 10:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579085980;
        bh=xtmM5FZaQwnB9SqFaDHwLYHEr2a+XYvmCTsvqftsxWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6W0IgnWAFGASarg5Of/+WRtArgNXz7XJeOD2CpjhZmN9FqfNnzRj1MSbc+vmAsgC
         oB3SyW1OKUHFSy9tXj3omRP9bAzV3H3LA4gJ0dG4k6oubbC+HBrUMEOKbyEAAf4szg
         WQd1qyMZ/6CfFSRkqZyVZKAgF8u3s25Os71fvvNU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        Sean.Wang@mediatek.com
Subject: [PATCH v3 06/18] mt76: mt76u: add queue id parameter to mt76u_submit_rx_buffers
Date:   Wed, 15 Jan 2020 11:58:46 +0100
Message-Id: <78c7c7b621fb3ce04fb47fe2e8351d1849e3d568.1579085367.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1579085367.git.lorenzo@kernel.org>
References: <cover.1579085367.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add queue_id parameter to mt76u_submit_rx_buffers in order to reuse it
adding mt7663u support

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 88be4d553b70..678720c53886 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -583,15 +583,16 @@ static void mt76u_rx_tasklet(unsigned long data)
 	rcu_read_unlock();
 }
 
-static int mt76u_submit_rx_buffers(struct mt76_dev *dev)
+static int
+mt76u_submit_rx_buffers(struct mt76_dev *dev, enum mt76_rxq_id qid)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct mt76_queue *q = &dev->q_rx[qid];
 	unsigned long flags;
 	int i, err = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
 	for (i = 0; i < q->ndesc; i++) {
-		err = mt76u_submit_rx_buf(dev, MT_RXQ_MAIN, q->entry[i].urb);
+		err = mt76u_submit_rx_buf(dev, qid, q->entry[i].urb);
 		if (err < 0)
 			break;
 	}
@@ -628,7 +629,7 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 			return err;
 	}
 
-	return mt76u_submit_rx_buffers(dev);
+	return mt76u_submit_rx_buffers(dev, MT_RXQ_MAIN);
 }
 
 static void mt76u_free_rx(struct mt76_dev *dev)
@@ -668,7 +669,7 @@ int mt76u_resume_rx(struct mt76_dev *dev)
 	for (i = 0; i < q->ndesc; i++)
 		usb_unpoison_urb(q->entry[i].urb);
 
-	return mt76u_submit_rx_buffers(dev);
+	return mt76u_submit_rx_buffers(dev, MT_RXQ_MAIN);
 }
 EXPORT_SYMBOL_GPL(mt76u_resume_rx);
 
-- 
2.21.1


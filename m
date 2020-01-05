Return-Path: <SRS0=kXDB=22=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F99AC33C99
	for <linux-wireless@archiver.kernel.org>; Sun,  5 Jan 2020 12:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF719218AC
	for <linux-wireless@archiver.kernel.org>; Sun,  5 Jan 2020 12:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578226968;
	bh=pLHMhdPVlngqQbFjxqN7sxVW0bSFZdjSK62jx2PGf2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=f4MKbphZ4av8iRys8phFauNufbtH6XiW2IRzfrBtLTKZzU1CSL/57Y+YuuW3uDu+y
	 kTHu7vRg1+bGzYoe8GLlijrb53NKjyz6DT44Eb120kLH8IvdahdZDTH2cLHxRQD0qJ
	 6RGMjBY68R6bi5xVSm7YUHPUyYitasqm7w9kfVHI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgAEMWr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 5 Jan 2020 07:22:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgAEMWr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Jan 2020 07:22:47 -0500
Received: from new-host-5.station (net-2-42-61-77.cust.vodafonedsl.it [2.42.61.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DB08215A4;
        Sun,  5 Jan 2020 12:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578226966;
        bh=pLHMhdPVlngqQbFjxqN7sxVW0bSFZdjSK62jx2PGf2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqhsuZA9L+2ij9ynhw+gqGzFI+RgMw4l3druCNDpz/9Aja3YKZ5Py1e5v3UPKgibA
         kjBFr+Wdu9mXIfeTYTvUJ9CxPg9BZBAeXtnthIvgSLrdCRB8b+QSOzPC9aDB0d784F
         Ze7gttTPL+FADwtVPVYHBSsrQZ3MGYHZW+/TrWJo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        Sean.Wang@mediatek.com
Subject: [PATCH v2 06/18] mt76: mt76u: add queue id parameter to mt76u_submit_rx_buffers
Date:   Sun,  5 Jan 2020 13:21:44 +0100
Message-Id: <28683a3ca45bb7630a3226fb8be8bd618cc8187d.1578226544.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1578226544.git.lorenzo@kernel.org>
References: <cover.1578226544.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add queue_id parameter to mt76u_submit_rx_buffers in order to reuse it
adding mt7663u support

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


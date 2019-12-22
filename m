Return-Path: <SRS0=74Mc=2M=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43436C2D0C0
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Dec 2019 10:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1501020CC7
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Dec 2019 10:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577010829;
	bh=dhh2csumO0PqPNr9Y8ZontGz+zmPCd5qolWdofwPps0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vM2s4ZCA6cAkRAWX3zXOoGAFY94abckzqec4s2bLrerjn8/lsIduzFsrRnWAB7MdT
	 yU84fp8Z4a5sPXLA0wyrX7V8eKyYxdDszPvZrvcJBpcGsKvMCBBUApSExZE2jLuPzM
	 URXAUGMY05/sL1nYgo8Ps3rZCJrjNF2wWlNwULTE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfLVKds (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 22 Dec 2019 05:33:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfLVKds (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Dec 2019 05:33:48 -0500
Received: from lore-desk-wlan.lan (unknown [151.66.53.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 799412084D;
        Sun, 22 Dec 2019 10:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577010827;
        bh=dhh2csumO0PqPNr9Y8ZontGz+zmPCd5qolWdofwPps0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGhaD8ceuZHpKioam87bDv6RaRr2ft+5Ea1xmgFexHu7Z//eJawJIky3jFYBFBOb2
         UnAd0fB96KdpLpl+sZMtQPf7ISxEjv9IfHezrRrE31arrDjuJryBk6mgknSfFjPz/N
         6pKhR+E61HaEOrjEcpVT+7F55mOG05fNdNbh5PVk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        Sean.Wang@mediatek.com
Subject: [PATCH 06/18] mt76: mt76u: add queue id parameter to mt76u_submit_rx_buffers
Date:   Sun, 22 Dec 2019 11:33:08 +0100
Message-Id: <e296086b7c636e5a1d2d55def65ab4daba5036c0.1577010183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1577010183.git.lorenzo@kernel.org>
References: <cover.1577010183.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add queue_id parameter to mt76u_submit_rx_buffers in order to reuse it
adding mt7663u support

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 03b9ffaa0e8b..23a2abf28bde 100644
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
2.24.1


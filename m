Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BF0C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94B5D213F2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfBJVtq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 16:49:46 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52326 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfBJVtp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 16:49:45 -0500
Received: by mail-wm1-f68.google.com with SMTP id m1so13786909wml.2
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 13:49:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EQeYL9uyP/dFrsUbpXBcL0FMiGD+/51bsSe3i9CZAqY=;
        b=IWr/+S5DC+NRvdTCf/mtaknx3Imiqv1Or6qWxJ7WZg+xOgmMFNJT1JLTWSymuK34bt
         5XrU1WbrONIPdnrY3QH0pWQAvWBWTRuR7KkqDntgXjX033QTCmat5MDRJUTc4oSGd886
         jKl9n3U3gALbC3YHt+xOnegbghewjCV+7n7mcnQw+h0yPGkqZxo5vzrMLh6xgfMZlfik
         54V1tMuMFX7tFEWvI8R3j1OZioVQnueltjyzUOqPmRujTSpcLkwRsNzFkfs8xKUX+n9F
         Bd06obelDlBdDCYcKVNoZo9+/L9/icjhLEvB2948Mgq9tu/1VPO3fKHidDIPxl01u2vS
         5olA==
X-Gm-Message-State: AHQUAuYadaPVMZFbMdT38FKl5mPmF4sVXCxfTJcL29jtJk5rPRR8M+1p
        eN9xUteIooJRp4E+U8iN/HEHFjxeneM=
X-Google-Smtp-Source: AHgI3IYP1UXiI/MFhhLiUSFVe6JnFIOnckkhVOkw4ZAp0wb4F4i6bxkqaOfK5PIUSnSkeTLffNcpNw==
X-Received: by 2002:a7b:c302:: with SMTP id k2mr6800452wmj.71.1549835383485;
        Sun, 10 Feb 2019 13:49:43 -0800 (PST)
Received: from lore-desk.lan ([151.66.10.5])
        by smtp.gmail.com with ESMTPSA id q14sm5436323wrw.39.2019.02.10.13.49.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 10 Feb 2019 13:49:42 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name, sgruszka@redhat.com, stefan.wahren@i2se.com
Subject: [PATCH wireless-drivers 2/3] mt76: usb: fix possible memory leak in mt76u_buf_free
Date:   Sun, 10 Feb 2019 22:49:14 +0100
Message-Id: <5d9891a95014b3bf724d81fc5693f3c7d00d4df2.1549832428.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549832428.git.lorenzo.bianconi@redhat.com>
References: <cover.1549832428.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move q->ndesc initialization before the for loop in mt76u_alloc_rx
since otherwise allocated urbs will not be freed in mt76u_buf_free
Double-check scatterlist pointer in mt76u_buf_free

Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index b061263453d4..31c18ac1c94a 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -331,10 +331,16 @@ EXPORT_SYMBOL_GPL(mt76u_buf_alloc);
 void mt76u_buf_free(struct mt76u_buf *buf)
 {
 	struct urb *urb = buf->urb;
+	struct scatterlist *sg;
 	int i;
 
-	for (i = 0; i < urb->num_sgs; i++)
-		skb_free_frag(sg_virt(&urb->sg[i]));
+	for (i = 0; i < urb->num_sgs; i++) {
+		sg = &urb->sg[i];
+		if (!sg)
+			continue;
+
+		skb_free_frag(sg_virt(sg));
+	}
 	usb_free_urb(buf->urb);
 }
 EXPORT_SYMBOL_GPL(mt76u_buf_free);
@@ -540,7 +546,8 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 		nsgs = 1;
 	}
 
-	for (i = 0; i < MT_NUM_RX_ENTRIES; i++) {
+	q->ndesc = MT_NUM_RX_ENTRIES;
+	for (i = 0; i < q->ndesc; i++) {
 		err = mt76u_buf_alloc(dev, &q->entry[i].ubuf,
 				      nsgs, q->buf_size,
 				      SKB_WITH_OVERHEAD(q->buf_size),
@@ -548,7 +555,6 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 		if (err < 0)
 			return err;
 	}
-	q->ndesc = MT_NUM_RX_ENTRIES;
 
 	return mt76u_submit_rx_buffers(dev);
 }
-- 
2.20.1


Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE77C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 11:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07A5E206B8
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 11:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551179974;
	bh=Cr5O6cBO13F9OPerV7Gu9TFgt64qxxWudJbyqxQ92Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZPqzdVxEutSTVqo3ukh8hwh3i6P7eUe8hbM2mJjU69hJgq/2yYjOSw/V54jJRtPov
	 CC7X5mXV+caf3tCoJX5/NrM1XQNnKPJw2KIkOgxDhBB5G5Uz7Q5KRjJ0jEIH3fJzV9
	 6rwvjdm1dOAxXJXlgPtm0rEXjvb+KK/2oTEbYPIk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfBZLTd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 06:19:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfBZLTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 06:19:33 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83560206B8;
        Tue, 26 Feb 2019 11:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551179971;
        bh=Cr5O6cBO13F9OPerV7Gu9TFgt64qxxWudJbyqxQ92Uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4yOsJ18CmabBoK4cq9sG0bJATtXXTJGkc/Cq7j6euWBqYwNGfDLrYe/OS4dZ4C+N
         siNKkEuAF52vSP2xjtkOQq38GdIJoj8EwW28CW7M+wjss3NzOotDyAH8RUtUIty0KT
         NPJqDvkO1JBV+tGoNvhnFNKbtjOT/xkYaIWZ8LI8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76: remove no longer used routine declarations
Date:   Tue, 26 Feb 2019 12:19:04 +0100
Message-Id: <28ad73820a28eb791fcdefa18fd364e4707b8fc9.1551179704.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551179704.git.lorenzo@kernel.org>
References: <cover.1551179704.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove following routine declarations that are no longer used
after commit cfca5f693c5d ("mt76usb: remove usb_mcu.c"):

- mt76u_mcu_complete_urb
- mt76u_deinit
- mt76u_buf_free
- mt76u_submit_urb

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  7 -------
 drivers/net/wireless/mediatek/mt76/usb.c  | 11 +++++------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 3555ed931dd0..5dfb0601f101 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -753,11 +753,6 @@ int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
 void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
 		     const u16 offset, const u32 val);
 int mt76u_init(struct mt76_dev *dev, struct usb_interface *intf);
-void mt76u_deinit(struct mt76_dev *dev);
-void mt76u_buf_free(struct mt76u_buf *buf);
-int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
-		     struct mt76u_buf *buf, gfp_t gfp,
-		     usb_complete_t complete_fn, void *context);
 int mt76u_submit_rx_buffers(struct mt76_dev *dev);
 int mt76u_alloc_queues(struct mt76_dev *dev);
 void mt76u_stop_queues(struct mt76_dev *dev);
@@ -771,6 +766,4 @@ void mt76_mcu_rx_event(struct mt76_dev *dev, struct sk_buff *skb);
 struct sk_buff *mt76_mcu_get_response(struct mt76_dev *dev,
 				      unsigned long expires);
 
-void mt76u_mcu_complete_urb(struct urb *urb);
-
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 096bc99378f5..b587f0c34793 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -361,7 +361,7 @@ mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf)
 	return mt76u_refill_rx(dev, q, buf, MT_SG_MAX_SIZE, GFP_KERNEL);
 }
 
-void mt76u_buf_free(struct mt76u_buf *buf)
+static void mt76u_buf_free(struct mt76u_buf *buf)
 {
 	struct urb *urb = buf->urb;
 	int i;
@@ -374,7 +374,6 @@ void mt76u_buf_free(struct mt76u_buf *buf)
 
 	usb_free_urb(buf->urb);
 }
-EXPORT_SYMBOL_GPL(mt76u_buf_free);
 
 static void
 mt76u_fill_bulk_urb(struct mt76_dev *dev, int dir, int index,
@@ -395,9 +394,10 @@ mt76u_fill_bulk_urb(struct mt76_dev *dev, int dir, int index,
 			  complete_fn, context);
 }
 
-int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
-		     struct mt76u_buf *buf, gfp_t gfp,
-		     usb_complete_t complete_fn, void *context)
+static int
+mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
+		 struct mt76u_buf *buf, gfp_t gfp,
+		 usb_complete_t complete_fn, void *context)
 {
 	mt76u_fill_bulk_urb(dev, dir, index, buf, complete_fn,
 			    context);
@@ -405,7 +405,6 @@ int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 
 	return usb_submit_urb(buf->urb, gfp);
 }
-EXPORT_SYMBOL_GPL(mt76u_submit_buf);
 
 static inline struct mt76u_buf
 *mt76u_get_next_rx_entry(struct mt76_queue *q)
-- 
2.20.1


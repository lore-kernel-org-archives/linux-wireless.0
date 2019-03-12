Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CDAC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3460120693
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfCLPGi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:06:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfCLPGi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:06:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B52D307D866;
        Tue, 12 Mar 2019 15:06:37 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7B9B57993;
        Tue, 12 Mar 2019 15:06:30 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 04/12] mt76usb: use usb_dev private data
Date:   Tue, 12 Mar 2019 16:05:58 +0100
Message-Id: <1552403166-3821-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 12 Mar 2019 15:06:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Setup usb device private data. This allows to remove mt76u_buf->dev
and simplify some routines as no longer we need to get usb device
through usb interface.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h       |  4 +---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c |  4 +++-
 drivers/net/wireless/mediatek/mt76/usb.c        | 13 ++++---------
 4 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 424f9090680d..89cdfe4abf33 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -84,7 +84,6 @@ struct mt76_queue_buf {
 };
 
 struct mt76u_buf {
-	struct mt76_dev *dev;
 	struct urb *urb;
 	size_t len;
 	void *buf;
@@ -744,8 +743,7 @@ static inline u8 q2ep(u8 qid)
 mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int *actual_len,
 	       int timeout)
 {
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
+	struct usb_device *udev = to_usb_device(dev->dev);
 	struct mt76_usb *usb = &dev->usb;
 	unsigned int pipe;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 69d6328a098d..1ef00e971cfa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -234,7 +234,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 	u32 mac_rev;
 	int ret;
 
-	mdev = mt76_alloc_device(&usb_intf->dev, sizeof(*dev), &mt76x0u_ops,
+	mdev = mt76_alloc_device(&usb_dev->dev, sizeof(*dev), &mt76x0u_ops,
 				 &drv_ops);
 	if (!mdev)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 47fe536bf896..0a7df308b2f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -50,7 +50,7 @@ static int mt76x2u_probe(struct usb_interface *intf,
 	struct mt76_dev *mdev;
 	int err;
 
-	mdev = mt76_alloc_device(&intf->dev, sizeof(*dev), &mt76x2u_ops,
+	mdev = mt76_alloc_device(&udev->dev, sizeof(*dev), &mt76x2u_ops,
 				 &drv_ops);
 	if (!mdev)
 		return -ENOMEM;
@@ -60,6 +60,8 @@ static int mt76x2u_probe(struct usb_interface *intf,
 	udev = usb_get_dev(udev);
 	usb_reset_device(udev);
 
+	usb_set_intfdata(intf, dev);
+
 	mt76x02u_init_mcu(mdev);
 	err = mt76u_init(mdev, intf);
 	if (err < 0)
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index dbabf7971798..954feb311620 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -31,8 +31,7 @@ static int __mt76u_vendor_request(struct mt76_dev *dev, u8 req,
 				  u8 req_type, u16 val, u16 offset,
 				  void *buf, size_t len)
 {
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
+	struct usb_device *udev = to_usb_device(dev->dev);
 	unsigned int pipe;
 	int i, ret;
 
@@ -247,8 +246,7 @@ void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
 
 static bool mt76u_check_sg(struct mt76_dev *dev)
 {
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
+	struct usb_device *udev = to_usb_device(dev->dev);
 
 	return (!disable_usb_sg && udev->bus->sg_tablesize > 0 &&
 		(udev->bus->no_sg_constraint ||
@@ -341,7 +339,6 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 
 	buf->len = SKB_WITH_OVERHEAD(q->buf_size);
-	buf->dev = dev;
 
 	buf->urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!buf->urb)
@@ -379,8 +376,7 @@ static void mt76u_buf_free(struct mt76u_buf *buf)
 		    struct mt76u_buf *buf, usb_complete_t complete_fn,
 		    void *context)
 {
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
+	struct usb_device *udev = to_usb_device(dev->dev);
 	u8 *data = buf->urb->num_sgs ? NULL : buf->buf;
 	unsigned int pipe;
 
@@ -694,8 +690,8 @@ static void mt76u_tx_status_data(struct work_struct *work)
 
 static void mt76u_complete_tx(struct urb *urb)
 {
+	struct mt76_dev *dev = dev_get_drvdata(&urb->dev->dev);
 	struct mt76u_buf *buf = urb->context;
-	struct mt76_dev *dev = buf->dev;
 
 	if (mt76u_urb_error(urb))
 		dev_err(dev->dev, "tx urb failed: %d\n", urb->status);
@@ -806,7 +802,6 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 		q->ndesc = MT_NUM_TX_ENTRIES;
 		for (j = 0; j < q->ndesc; j++) {
 			buf = &q->entry[j].ubuf;
-			buf->dev = dev;
 
 			buf->urb = usb_alloc_urb(0, GFP_KERNEL);
 			if (!buf->urb)
-- 
1.9.3


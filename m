Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE3FC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D85021874
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfCUP0J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:26:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbfCUP0I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 11:26:08 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C75230832EF;
        Thu, 21 Mar 2019 15:26:08 +0000 (UTC)
Received: from localhost (ovpn-204-211.brq.redhat.com [10.40.204.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5AF690A8;
        Thu, 21 Mar 2019 15:26:03 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 04/12] mt76usb: use usb_dev private data
Date:   Thu, 21 Mar 2019 16:25:29 +0100
Message-Id: <20190321152537.19105-5-sgruszka@redhat.com>
In-Reply-To: <20190321152537.19105-1-sgruszka@redhat.com>
References: <20190321152537.19105-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 21 Mar 2019 15:26:08 +0000 (UTC)
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
index 67ff9bce94c0..ab93d7e94b36 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -90,7 +90,6 @@ struct mt76_tx_info {
 };
 
 struct mt76u_buf {
-	struct mt76_dev *dev;
 	struct urb *urb;
 	size_t len;
 	void *buf;
@@ -763,8 +762,7 @@ static inline int
 mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int *actual_len,
 	       int timeout)
 {
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
+	struct usb_device *udev = to_usb_device(dev->dev);
 	struct mt76_usb *usb = &dev->usb;
 	unsigned int pipe;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index cf97bbd89485..c27769f062af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -234,7 +234,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 	u32 asic_rev, mac_rev;
 	int ret;
 
-	mdev = mt76_alloc_device(&usb_intf->dev, sizeof(*dev), &mt76x0u_ops,
+	mdev = mt76_alloc_device(&usb_dev->dev, sizeof(*dev), &mt76x0u_ops,
 				 &drv_ops);
 	if (!mdev)
 		return -ENOMEM;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 1f0b1bebed79..b112b2f8342a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -49,7 +49,7 @@ static int mt76x2u_probe(struct usb_interface *intf,
 	struct mt76_dev *mdev;
 	int err;
 
-	mdev = mt76_alloc_device(&intf->dev, sizeof(*dev), &mt76x2u_ops,
+	mdev = mt76_alloc_device(&udev->dev, sizeof(*dev), &mt76x2u_ops,
 				 &drv_ops);
 	if (!mdev)
 		return -ENOMEM;
@@ -59,6 +59,8 @@ static int mt76x2u_probe(struct usb_interface *intf,
 	udev = usb_get_dev(udev);
 	usb_reset_device(udev);
 
+	usb_set_intfdata(intf, dev);
+
 	mt76x02u_init_mcu(mdev);
 	err = mt76u_init(mdev, intf);
 	if (err < 0)
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 56e7a2ca8930..28552c622fee 100644
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
 
@@ -247,8 +246,7 @@ mt76u_rd_rp(struct mt76_dev *dev, u32 base,
 
 static bool mt76u_check_sg(struct mt76_dev *dev)
 {
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
+	struct usb_device *udev = to_usb_device(dev->dev);
 
 	return (!disable_usb_sg && udev->bus->sg_tablesize > 0 &&
 		(udev->bus->no_sg_constraint ||
@@ -341,7 +339,6 @@ mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf)
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 
 	buf->len = SKB_WITH_OVERHEAD(q->buf_size);
-	buf->dev = dev;
 
 	buf->urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!buf->urb)
@@ -379,8 +376,7 @@ mt76u_fill_bulk_urb(struct mt76_dev *dev, int dir, int index,
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
2.20.1


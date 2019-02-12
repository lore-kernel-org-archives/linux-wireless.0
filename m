Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1210FC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:43:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D431C21773
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549978988;
	bh=KE6A9oOh1VlDF0UoUTbDBq/RlY0eAeZdea6g2k62Vfw=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Bw7u5MI5ee6ITHefZEfhx363g3Khe1GqVVgbyQZPH22lG+3qP0HaPxp1DO8WSr2ci
	 FjHltnCrT9CS1LgRp8a9ZG9UnKjdHO7Nuj7sszEOEeBLDH11fue90QgAXIEoFDznwo
	 s+ebiqzCASYSQGYJZ1SiperZcJBn8brenexQ3FiM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbfBLNnI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 08:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbfBLNnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 08:43:08 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AF8621773
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549978986;
        bh=KE6A9oOh1VlDF0UoUTbDBq/RlY0eAeZdea6g2k62Vfw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=df1grqvYrzIch8T5eYlLXXLJqDST932aI5WseocdlvGMtl0cSUg1EaDw/oD81wJlo
         4FkWLULZBGYqmIG/Y/BvVFxXkXJmYLcJB6ewEta4NWGEc4nuMBBp7qXa7zeXz/BMzG
         Z08557qd9LwZe3KHvC4Oh/tMMpRGLq3wNIJfsvGY=
From:   lorenzo@kernel.org
To:     linux-wireless@vger.kernel.org
Subject: [PATCH RESEND 1/4] mt76: usb: move mt76u_check_sg in usb.c
Date:   Tue, 12 Feb 2019 14:42:39 +0100
Message-Id: <7ba0501e4f10d410b5f6b77f84e2757e7e70567f.1549977282.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549977282.git.lorenzo@kernel.org>
References: <cover.1549977282.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Move mt76u_check_sg routine in usb.c and introduce sg_en variable
in mt76_usb in order to check if scatter-gather is supported by
mt76u layer

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          | 11 +----------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/usb.c           | 14 +++++++++++++-
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 13f6febc9b0f..0eb9152c5d18 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -379,6 +379,7 @@ struct mt76_usb {
 	u16 out_max_packet;
 	u8 in_ep[__MT_EP_IN_MAX];
 	u16 in_max_packet;
+	bool sg_en;
 
 	struct mt76u_mcu {
 		struct mutex mutex;
@@ -726,16 +727,6 @@ static inline u8 q2ep(u8 qid)
 	return qid + 1;
 }
 
-static inline bool mt76u_check_sg(struct mt76_dev *dev)
-{
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
-
-	return (udev->bus->sg_tablesize > 0 &&
-		(udev->bus->no_sg_constraint ||
-		 udev->speed == USB_SPEED_WIRELESS));
-}
-
 static inline int
 mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int timeout)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 2f259bc0ad9e..da9d05f6074d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -206,7 +206,7 @@ static int mt76x0u_register_device(struct mt76x02_dev *dev)
 		goto out_err;
 
 	/* check hw sg support in order to enable AMSDU */
-	if (mt76u_check_sg(&dev->mt76))
+	if (dev->mt76.usb.sg_en)
 		hw->max_tx_fragments = MT_SG_MAX_SIZE;
 	else
 		hw->max_tx_fragments = 1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 006e430e374e..090aaf71b3ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -228,7 +228,7 @@ int mt76x2u_register_device(struct mt76x02_dev *dev)
 		goto fail;
 
 	/* check hw sg support in order to enable AMSDU */
-	if (mt76u_check_sg(&dev->mt76))
+	if (dev->mt76.usb.sg_en)
 		hw->max_tx_fragments = MT_SG_MAX_SIZE;
 	else
 		hw->max_tx_fragments = 1;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index c7db8a9f6acc..829128a07701 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -241,6 +241,16 @@ mt76u_rd_rp(struct mt76_dev *dev, u32 base,
 		return mt76u_req_rd_rp(dev, base, data, n);
 }
 
+static bool mt76u_check_sg(struct mt76_dev *dev)
+{
+	struct usb_interface *intf = to_usb_interface(dev->dev);
+	struct usb_device *udev = interface_to_usbdev(intf);
+
+	return (udev->bus->sg_tablesize > 0 &&
+		(udev->bus->no_sg_constraint ||
+		 udev->speed == USB_SPEED_WIRELESS));
+}
+
 static int
 mt76u_set_endpoints(struct usb_interface *intf,
 		    struct mt76_usb *usb)
@@ -536,7 +546,7 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	if (!q->entry)
 		return -ENOMEM;
 
-	if (mt76u_check_sg(dev)) {
+	if (dev->usb.sg_en) {
 		q->buf_size = MT_RX_BUF_SIZE;
 		nsgs = MT_SG_MAX_SIZE;
 	} else {
@@ -881,6 +891,8 @@ int mt76u_init(struct mt76_dev *dev,
 	dev->bus = &mt76u_ops;
 	dev->queue_ops = &usb_queue_ops;
 
+	usb->sg_en = mt76u_check_sg(dev);
+
 	return mt76u_set_endpoints(intf, usb);
 }
 EXPORT_SYMBOL_GPL(mt76u_init);
-- 
2.20.1


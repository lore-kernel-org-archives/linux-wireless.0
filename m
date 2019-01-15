Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D207DC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC81820657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbfAOMd4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:33:56 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40558 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729562AbfAOMdz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 07:33:55 -0500
Received: by mail-wm1-f67.google.com with SMTP id f188so2995923wmf.5
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 04:33:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RuJ/WWpRTTiu4D5Hs2UAEtWpz2NJs3J/QjjiVzy6IdM=;
        b=ssbva0i+RTYZTYf7zAd6hJWEUX0RAZ0Ucu5AjQ6Bg2ubDJ0hyoW6PgfGM9xdqoPNP7
         3LYDzJKAPMkuT5A8Cws5IAMzVNtkrtiwECh3MtEXA0+Lc5giXNJaGjLeTtBQABkcSePF
         PjEXxM5r1k3l8HEs7yTz3iG/g4YTc8+i/ZysJf1RbbUTjP6UgmKyS2it9u2+9dx6BbfB
         YTiqyqea8a6omKah6Pt9FF08IFo0uCD9GIFf3viapV6/GiJLQLuqpV2nUzBCl31Xvgo1
         8OfWCD5BYHXzNdAvhMSZC7GAyRMHbJiKbG/bE+1nK23xauPLv/mwR6ZT33I3+f/dgWkR
         qd+g==
X-Gm-Message-State: AJcUukcmTdETUbDkV6aknmYYLCYr45QK7+CTYve6xaT7ZXyT9foW9xVz
        ODS3eIF+prgFslCtROwAdhNRSA==
X-Google-Smtp-Source: ALg8bN4Ncy9hsIGWp8EuzZzSmsQHK4QItqsHjCBcxXkibaSSz6xq/KX/0rUMiG0XtqCZuoXxI6Gypw==
X-Received: by 2002:a1c:f613:: with SMTP id w19mr3250699wmc.0.1547555633192;
        Tue, 15 Jan 2019 04:33:53 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a6sm28218186wmh.10.2019.01.15.04.33.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Jan 2019 04:33:52 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, rosenp@gmail.com,
        sgruszka@redhat.com
Subject: [RFC 1/4] mt76: usb: move mt76u_check_sg in usb.c
Date:   Tue, 15 Jan 2019 13:33:42 +0100
Message-Id: <efafd01aba214c9d7e7bed195413a5ba925871b9.1547549771.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76u_check_sg routine in usb.c and introduce sg_en variable
in mt76_usb in order to check if scatter-gather is supported by
mt76u layer

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          | 11 +----------
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/usb.c           | 14 +++++++++++++-
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 8ef430d8afc4..d31681f90ff2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -368,6 +368,7 @@ struct mt76_usb {
 	u16 out_max_packet;
 	u8 in_ep[__MT_EP_IN_MAX];
 	u16 in_max_packet;
+	bool sg_en;
 
 	struct mt76u_mcu {
 		struct mutex mutex;
@@ -704,16 +705,6 @@ static inline u8 q2ep(u8 qid)
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
 int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
 			 u8 req_type, u16 val, u16 offset,
 			 void *buf, size_t len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 0e6b43bb4678..2c140f411972 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -196,7 +196,7 @@ static int mt76x0u_register_device(struct mt76x02_dev *dev)
 		goto out_err;
 
 	/* check hw sg support in order to enable AMSDU */
-	if (mt76u_check_sg(&dev->mt76))
+	if (dev->mt76.usb.sg_en)
 		hw->max_tx_fragments = MT_SG_MAX_SIZE;
 	else
 		hw->max_tx_fragments = 1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 0be3784f44fb..e39bd876b040 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -256,7 +256,7 @@ int mt76x2u_register_device(struct mt76x02_dev *dev)
 		goto fail;
 
 	/* check hw sg support in order to enable AMSDU */
-	if (mt76u_check_sg(&dev->mt76))
+	if (dev->mt76.usb.sg_en)
 		hw->max_tx_fragments = MT_SG_MAX_SIZE;
 	else
 		hw->max_tx_fragments = 1;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 6a2507524c6c..44e9f5d66326 100644
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
@@ -530,7 +540,7 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	if (!q->entry)
 		return -ENOMEM;
 
-	if (mt76u_check_sg(dev)) {
+	if (dev->usb.sg_en) {
 		q->buf_size = MT_RX_BUF_SIZE;
 		nsgs = MT_SG_MAX_SIZE;
 	} else {
@@ -882,6 +892,8 @@ int mt76u_init(struct mt76_dev *dev,
 	dev->bus = &mt76u_ops;
 	dev->queue_ops = &usb_queue_ops;
 
+	usb->sg_en = mt76u_check_sg(dev);
+
 	return mt76u_set_endpoints(intf, usb);
 }
 EXPORT_SYMBOL_GPL(mt76u_init);
-- 
2.20.1


Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 463B5C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EF2120C01
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfBTMs3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:48:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfBTMs3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:48:29 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8EFBE81226;
        Wed, 20 Feb 2019 12:48:28 +0000 (UTC)
Received: from localhost (ovpn-204-58.brq.redhat.com [10.40.204.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E6B35D6B3;
        Wed, 20 Feb 2019 12:48:25 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v2 3/3] mt76usb: remove usb_mcu.c
Date:   Wed, 20 Feb 2019 13:48:17 +0100
Message-Id: <1550666897-3099-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1550666897-3099-1-git-send-email-sgruszka@redhat.com>
References: <1550666897-3099-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 20 Feb 2019 12:48:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Don't need separate file just for kmalloc/kfree.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v2: use dev_kmalloc()

 drivers/net/wireless/mediatek/mt76/mt76.h          |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  5 ----
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |  5 ----
 drivers/net/wireless/mediatek/mt76/usb.c           |  5 ++++
 drivers/net/wireless/mediatek/mt76/usb_mcu.c       | 34 ----------------------
 5 files changed, 5 insertions(+), 46 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/usb_mcu.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index c9b5eb9b0582..a689af307a71 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -771,7 +771,5 @@ struct sk_buff *mt76_mcu_get_response(struct mt76_dev *dev,
 				      unsigned long expires);
 
 void mt76u_mcu_complete_urb(struct urb *urb);
-int mt76u_mcu_init_rx(struct mt76_dev *dev);
-void mt76u_mcu_deinit(struct mt76_dev *dev);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index f0c33890f1a5..91718647da02 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -79,7 +79,6 @@ static void mt76x0u_cleanup(struct mt76x02_dev *dev)
 	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
 	mt76x0_chip_onoff(dev, false, false);
 	mt76u_queues_deinit(&dev->mt76);
-	mt76u_mcu_deinit(&dev->mt76);
 }
 
 static void mt76x0u_mac_stop(struct mt76x02_dev *dev)
@@ -193,10 +192,6 @@ static int mt76x0u_register_device(struct mt76x02_dev *dev)
 	if (err < 0)
 		goto out_err;
 
-	err = mt76u_mcu_init_rx(&dev->mt76);
-	if (err < 0)
-		goto out_err;
-
 	err = mt76x0u_init_hardware(dev);
 	if (err < 0)
 		goto out_err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 090aaf71b3ef..1da90e58d942 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -214,10 +214,6 @@ int mt76x2u_register_device(struct mt76x02_dev *dev)
 	if (err < 0)
 		goto fail;
 
-	err = mt76u_mcu_init_rx(&dev->mt76);
-	if (err < 0)
-		goto fail;
-
 	err = mt76x2u_init_hardware(dev);
 	if (err < 0)
 		goto fail;
@@ -259,5 +255,4 @@ void mt76x2u_cleanup(struct mt76x02_dev *dev)
 	mt76x02_mcu_set_radio_state(dev, false);
 	mt76x2u_stop_hw(dev);
 	mt76u_queues_deinit(&dev->mt76);
-	mt76u_mcu_deinit(&dev->mt76);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 5c3b7f735aae..792f5012f1b1 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -577,9 +577,14 @@ EXPORT_SYMBOL_GPL(mt76u_submit_rx_buffers);
 
 static int mt76u_alloc_rx(struct mt76_dev *dev)
 {
+	struct mt76_usb *usb = &dev->usb;
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	int i, err;
 
+	usb->mcu.data = devm_kmalloc(dev->dev, MCU_RESP_URB_SIZE, GFP_KERNEL);
+	if (!usb->mcu.data)
+		return -ENOMEM;
+
 	spin_lock_init(&q->rx_page_lock);
 	spin_lock_init(&q->lock);
 	q->entry = devm_kcalloc(dev->dev,
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
deleted file mode 100644
index 747231edc57d..000000000000
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include "mt76.h"
-
-int mt76u_mcu_init_rx(struct mt76_dev *dev)
-{
-	struct mt76_usb *usb = &dev->usb;
-
-	usb->mcu.data = kmalloc(MCU_RESP_URB_SIZE, GFP_KERNEL);
-	return usb->mcu.data ? 0 : -ENOMEM;
-}
-EXPORT_SYMBOL_GPL(mt76u_mcu_init_rx);
-
-void mt76u_mcu_deinit(struct mt76_dev *dev)
-{
-	struct mt76_usb *usb = &dev->usb;
-
-	kfree(usb->mcu.data);
-}
-EXPORT_SYMBOL_GPL(mt76u_mcu_deinit);
-- 
2.7.5


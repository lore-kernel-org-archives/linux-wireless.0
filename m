Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA88C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFD6420C01
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfBTMsZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:48:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15053 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfBTMsZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:48:25 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DC6B189AFB;
        Wed, 20 Feb 2019 12:48:24 +0000 (UTC)
Received: from localhost (ovpn-204-58.brq.redhat.com [10.40.204.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CB5D19C72;
        Wed, 20 Feb 2019 12:48:22 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v2 2/3] mt76usb: use synchronous msg for mcu command responses
Date:   Wed, 20 Feb 2019 13:48:16 +0100
Message-Id: <1550666897-3099-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1550666897-3099-1-git-send-email-sgruszka@redhat.com>
References: <1550666897-3099-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 20 Feb 2019 12:48:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use usb_bulk_msg for reading MCU command responses. This simplify code
a lot.

Together with 97a3005759c ("mt76usb: allow mt76u_bulk_msg be used
for reads") it also fix possible problems with rx data buffers
not being aligned and contained within single page. After doing
page_frag_alloc(1024) consecutive page_frag_alloc(PAGE_SIZE) will
alloc PAGE_SIZE buffer at PAGE_SIZE - 1024 offset.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    | 11 --------
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   | 32 +++++++---------------
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    | 11 --------
 drivers/net/wireless/mediatek/mt76/usb.c           |  1 -
 drivers/net/wireless/mediatek/mt76/usb_mcu.c       | 31 +++------------------
 6 files changed, 15 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 6092646014c4..c9b5eb9b0582 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -384,8 +384,7 @@ struct mt76_usb {
 
 	struct mt76u_mcu {
 		struct mutex mutex;
-		struct completion cmpl;
-		struct mt76u_buf res;
+		u8 *data;
 		u32 msg_seq;
 
 		/* multiple reads */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index da9d05f6074d..f0c33890f1a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -311,13 +311,11 @@ static int __maybe_unused mt76x0_suspend(struct usb_interface *usb_intf,
 					 pm_message_t state)
 {
 	struct mt76x02_dev *dev = usb_get_intfdata(usb_intf);
-	struct mt76_usb *usb = &dev->mt76.usb;
 
 	mt76u_stop_queues(&dev->mt76);
 	mt76x0u_mac_stop(dev);
 	clear_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state);
 	mt76x0_chip_onoff(dev, false, false);
-	usb_kill_urb(usb->mcu.res.urb);
 
 	return 0;
 }
@@ -328,15 +326,6 @@ static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 	struct mt76_usb *usb = &dev->mt76.usb;
 	int ret;
 
-	reinit_completion(&usb->mcu.cmpl);
-	ret = mt76u_submit_buf(&dev->mt76, USB_DIR_IN,
-			       MT_EP_IN_CMD_RESP,
-			       &usb->mcu.res, GFP_KERNEL,
-			       mt76u_mcu_complete_urb,
-			       &usb->mcu.cmpl);
-	if (ret < 0)
-		goto err;
-
 	ret = mt76u_submit_rx_buffers(&dev->mt76);
 	if (ret < 0)
 		goto err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index f497c8e4332a..0cb8751321a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -61,33 +61,21 @@ mt76x02u_multiple_mcu_reads(struct mt76_dev *dev, u8 *data, int len)
 static int mt76x02u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 {
 	struct mt76_usb *usb = &dev->usb;
-	struct mt76u_buf *buf = &usb->mcu.res;
-	struct urb *urb = buf->urb;
-	u8 *data = buf->buf;
-	int i, ret;
+	u8 *data = usb->mcu.data;
+	int i, len, ret;
 	u32 rxfce;
 
 	for (i = 0; i < 5; i++) {
-		if (!wait_for_completion_timeout(&usb->mcu.cmpl,
-						 msecs_to_jiffies(300)))
+		ret = mt76u_bulk_msg(dev, data, MCU_RESP_URB_SIZE, &len, 300);
+		if (ret == -ETIMEDOUT)
 			continue;
-
-		if (urb->status)
-			return -EIO;
+		if (ret)
+			goto out;
 
 		if (usb->mcu.rp)
-			mt76x02u_multiple_mcu_reads(dev, data + 4,
-						    urb->actual_length - 8);
+			mt76x02u_multiple_mcu_reads(dev, data + 4, len - 8);
 
 		rxfce = get_unaligned_le32(data);
-		ret = mt76u_submit_buf(dev, USB_DIR_IN,
-				       MT_EP_IN_CMD_RESP,
-				       buf, GFP_KERNEL,
-				       mt76u_mcu_complete_urb,
-				       &usb->mcu.cmpl);
-		if (ret)
-			return ret;
-
 		if (seq == FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, rxfce) &&
 		    FIELD_GET(MT_RX_FCE_INFO_EVT_TYPE, rxfce) == EVT_CMD_DONE)
 			return 0;
@@ -96,9 +84,9 @@ static int mt76x02u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 			FIELD_GET(MT_RX_FCE_INFO_EVT_TYPE, rxfce),
 			seq, FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, rxfce));
 	}
-
-	dev_err(dev->dev, "error: %s timed out\n", __func__);
-	return -ETIMEDOUT;
+out:
+	dev_err(dev->dev, "error: %s failed with %d\n", __func__, ret);
+	return ret;
 }
 
 static int
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index f81a85e96922..ddb6b2c48e01 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -100,11 +100,9 @@ static int __maybe_unused mt76x2u_suspend(struct usb_interface *intf,
 					  pm_message_t state)
 {
 	struct mt76x02_dev *dev = usb_get_intfdata(intf);
-	struct mt76_usb *usb = &dev->mt76.usb;
 
 	mt76u_stop_queues(&dev->mt76);
 	mt76x2u_stop_hw(dev);
-	usb_kill_urb(usb->mcu.res.urb);
 
 	return 0;
 }
@@ -115,15 +113,6 @@ static int __maybe_unused mt76x2u_resume(struct usb_interface *intf)
 	struct mt76_usb *usb = &dev->mt76.usb;
 	int err;
 
-	reinit_completion(&usb->mcu.cmpl);
-	err = mt76u_submit_buf(&dev->mt76, USB_DIR_IN,
-			       MT_EP_IN_CMD_RESP,
-			       &usb->mcu.res, GFP_KERNEL,
-			       mt76u_mcu_complete_urb,
-			       &usb->mcu.cmpl);
-	if (err < 0)
-		goto err;
-
 	err = mt76u_submit_rx_buffers(&dev->mt76);
 	if (err < 0)
 		goto err;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 78191968b4fa..5c3b7f735aae 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -933,7 +933,6 @@ int mt76u_init(struct mt76_dev *dev,
 	INIT_DELAYED_WORK(&usb->stat_work, mt76u_tx_status_data);
 	skb_queue_head_init(&dev->rx_skb[MT_RXQ_MAIN]);
 
-	init_completion(&usb->mcu.cmpl);
 	mutex_init(&usb->mcu.mutex);
 
 	mutex_init(&usb->usb_ctrl_mtx);
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 72c8607da4b4..747231edc57d 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -16,42 +16,19 @@
 
 #include "mt76.h"
 
-void mt76u_mcu_complete_urb(struct urb *urb)
-{
-	struct completion *cmpl = urb->context;
-
-	complete(cmpl);
-}
-EXPORT_SYMBOL_GPL(mt76u_mcu_complete_urb);
-
 int mt76u_mcu_init_rx(struct mt76_dev *dev)
 {
 	struct mt76_usb *usb = &dev->usb;
-	int err;
 
-	err = mt76u_buf_alloc(dev, &usb->mcu.res, MCU_RESP_URB_SIZE,
-			      MCU_RESP_URB_SIZE, GFP_KERNEL);
-	if (err < 0)
-		return err;
-
-	err = mt76u_submit_buf(dev, USB_DIR_IN, MT_EP_IN_CMD_RESP,
-			       &usb->mcu.res, GFP_KERNEL,
-			       mt76u_mcu_complete_urb,
-			       &usb->mcu.cmpl);
-	if (err < 0)
-		mt76u_buf_free(&usb->mcu.res);
-
-	return err;
+	usb->mcu.data = kmalloc(MCU_RESP_URB_SIZE, GFP_KERNEL);
+	return usb->mcu.data ? 0 : -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(mt76u_mcu_init_rx);
 
 void mt76u_mcu_deinit(struct mt76_dev *dev)
 {
-	struct mt76u_buf *buf = &dev->usb.mcu.res;
+	struct mt76_usb *usb = &dev->usb;
 
-	if (buf->urb) {
-		usb_kill_urb(buf->urb);
-		mt76u_buf_free(buf);
-	}
+	kfree(usb->mcu.data);
 }
 EXPORT_SYMBOL_GPL(mt76u_mcu_deinit);
-- 
2.7.5


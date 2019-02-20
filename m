Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DAEC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 16:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB372146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 16:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfBTQP1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 11:15:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfBTQP1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 11:15:27 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 733D4A102F;
        Wed, 20 Feb 2019 16:15:27 +0000 (UTC)
Received: from localhost (ovpn-204-136.brq.redhat.com [10.40.204.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4748E60192;
        Wed, 20 Feb 2019 16:15:22 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v3 1/3] mt76usb: allow mt76u_bulk_msg be used for reads
Date:   Wed, 20 Feb 2019 17:15:18 +0100
Message-Id: <1550679320-14343-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 20 Feb 2019 16:15:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Extend mt76u_bulk_msg() such it can be used for synchronous bulk reads.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v2: pass NULL actual_len to usb_bulk_msg

 drivers/net/wireless/mediatek/mt76/mt76.h            | 12 ++++++++----
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c |  4 ++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index f55dc621e060..6092646014c4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -729,16 +729,20 @@ static inline u8 q2ep(u8 qid)
 }
 
 static inline int
-mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int timeout)
+mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int *actual_len,
+	       int timeout)
 {
 	struct usb_interface *intf = to_usb_interface(dev->dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct mt76_usb *usb = &dev->usb;
 	unsigned int pipe;
-	int sent;
 
-	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
-	return usb_bulk_msg(udev, pipe, data, len, &sent, timeout);
+	if (actual_len)
+		pipe = usb_rcvbulkpipe(udev, usb->in_ep[MT_EP_IN_CMD_RESP]);
+	else
+		pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
+
+	return usb_bulk_msg(udev, pipe, data, len, actual_len, timeout);
 }
 
 int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index e469e383cb88..f497c8e4332a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -126,7 +126,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	if (ret)
 		return ret;
 
-	ret = mt76u_bulk_msg(dev, skb->data, skb->len, 500);
+	ret = mt76u_bulk_msg(dev, skb->data, skb->len, NULL, 500);
 	if (ret)
 		return ret;
 
@@ -271,7 +271,7 @@ __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, u8 *data,
 
 	data_len = MT_CMD_HDR_LEN + len + sizeof(info);
 
-	err = mt76u_bulk_msg(&dev->mt76, data, data_len, 1000);
+	err = mt76u_bulk_msg(&dev->mt76, data, data_len, NULL, 1000);
 	if (err) {
 		dev_err(dev->mt76.dev, "firmware upload failed: %d\n", err);
 		return err;
-- 
2.7.5


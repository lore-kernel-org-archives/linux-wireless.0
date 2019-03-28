Return-Path: <SRS0=yxJm=R7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE6CC10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 13:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 500CD217F9
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 13:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfC1N3p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Mar 2019 09:29:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbfC1N3o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Mar 2019 09:29:44 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 35BD330BA37D;
        Thu, 28 Mar 2019 13:29:43 +0000 (UTC)
Received: from localhost (unknown [10.40.206.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DB8219C77;
        Thu, 28 Mar 2019 13:29:40 +0000 (UTC)
Date:   Thu, 28 Mar 2019 14:29:39 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Jan Viktorin <jan.viktorin@gmail.com>
Subject: [PATCH 4.20, 5.0] mt76x02u: use usb_bulk_msg to upload firmware
Message-ID: <20190328132932.GA16543@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 28 Mar 2019 13:29:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

commit 5de4db8fcb6d6fc7d9064c22841211790c0ab81b upstream.

We don't need to send firmware data asynchronously, much simpler is just
use synchronous usb_bulk_msg().

[ stable note: this patch was originally developed as cleanup, but it
remove incorrect usage of page_frag_alloc(): alloc more than PAGE_SIZE
and create not ARCH_DMA_MINALIGN dma buffers needed at least for
performance reason. Was tested on 5.0 and 4.20, see
https://bugzilla.kernel.org/show_bug.cgi?id=202673 and
https://bugzilla.kernel.org/show_bug.cgi?id=202241 ]

Tested-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          | 13 ++++++
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   | 52 +++++++---------------
 drivers/net/wireless/mediatek/mt76/usb.c           |  1 -
 3 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5cd508a68609..6d29ba4046c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -713,6 +713,19 @@ static inline bool mt76u_check_sg(struct mt76_dev *dev)
 		 udev->speed == USB_SPEED_WIRELESS));
 }
 
+static inline int
+mt76u_bulk_msg(struct mt76_dev *dev, void *data, int len, int timeout)
+{
+	struct usb_interface *intf = to_usb_interface(dev->dev);
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct mt76_usb *usb = &dev->usb;
+	unsigned int pipe;
+	int sent;
+
+	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
+	return usb_bulk_msg(udev, pipe, data, len, &sent, timeout);
+}
+
 int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
 			 u8 req_type, u16 val, u16 offset,
 			 void *buf, size_t len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index 6db789f90269..2ca393e267af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -121,18 +121,14 @@ static int
 __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 			int cmd, bool wait_resp)
 {
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
 	struct mt76_usb *usb = &dev->usb;
-	unsigned int pipe;
-	int ret, sent;
+	int ret;
 	u8 seq = 0;
 	u32 info;
 
 	if (test_bit(MT76_REMOVED, &dev->state))
 		return 0;
 
-	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
 	if (wait_resp) {
 		seq = ++usb->mcu.msg_seq & 0xf;
 		if (!seq)
@@ -146,7 +142,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	if (ret)
 		return ret;
 
-	ret = usb_bulk_msg(udev, pipe, skb->data, skb->len, &sent, 500);
+	ret = mt76u_bulk_msg(dev, skb->data, skb->len, 500);
 	if (ret)
 		return ret;
 
@@ -268,14 +264,12 @@ void mt76x02u_mcu_fw_reset(struct mt76x02_dev *dev)
 EXPORT_SYMBOL_GPL(mt76x02u_mcu_fw_reset);
 
 static int
-__mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
+__mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, u8 *data,
 			    const void *fw_data, int len, u32 dst_addr)
 {
-	u8 *data = sg_virt(&buf->urb->sg[0]);
-	DECLARE_COMPLETION_ONSTACK(cmpl);
 	__le32 info;
 	u32 val;
-	int err;
+	int err, data_len;
 
 	info = cpu_to_le32(FIELD_PREP(MT_MCU_MSG_PORT, CPU_TX_PORT) |
 			   FIELD_PREP(MT_MCU_MSG_LEN, len) |
@@ -291,25 +285,12 @@ __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
 	mt76u_single_wr(&dev->mt76, MT_VEND_WRITE_FCE,
 			MT_FCE_DMA_LEN, len << 16);
 
-	buf->len = MT_CMD_HDR_LEN + len + sizeof(info);
-	err = mt76u_submit_buf(&dev->mt76, USB_DIR_OUT,
-			       MT_EP_OUT_INBAND_CMD,
-			       buf, GFP_KERNEL,
-			       mt76u_mcu_complete_urb, &cmpl);
-	if (err < 0)
-		return err;
-
-	if (!wait_for_completion_timeout(&cmpl,
-					 msecs_to_jiffies(1000))) {
-		dev_err(dev->mt76.dev, "firmware upload timed out\n");
-		usb_kill_urb(buf->urb);
-		return -ETIMEDOUT;
-	}
+	data_len = MT_CMD_HDR_LEN + len + sizeof(info);
 
-	if (mt76u_urb_error(buf->urb)) {
-		dev_err(dev->mt76.dev, "firmware upload failed: %d\n",
-			buf->urb->status);
-		return buf->urb->status;
+	err = mt76u_bulk_msg(&dev->mt76, data, data_len, 1000);
+	if (err) {
+		dev_err(dev->mt76.dev, "firmware upload failed: %d\n", err);
+		return err;
 	}
 
 	val = mt76_rr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX);
@@ -322,17 +303,16 @@ __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
 int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
 			      int data_len, u32 max_payload, u32 offset)
 {
-	int err, len, pos = 0, max_len = max_payload - 8;
-	struct mt76u_buf buf;
+	int len, err = 0, pos = 0, max_len = max_payload - 8;
+	u8 *buf;
 
-	err = mt76u_buf_alloc(&dev->mt76, &buf, 1, max_payload, max_payload,
-			      GFP_KERNEL);
-	if (err < 0)
-		return err;
+	buf = kmalloc(max_payload, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
 	while (data_len > 0) {
 		len = min_t(int, data_len, max_len);
-		err = __mt76x02u_mcu_fw_send_data(dev, &buf, data + pos,
+		err = __mt76x02u_mcu_fw_send_data(dev, buf, data + pos,
 						  len, offset + pos);
 		if (err < 0)
 			break;
@@ -341,7 +321,7 @@ int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
 		pos += len;
 		usleep_range(5000, 10000);
 	}
-	mt76u_buf_free(&buf);
+	kfree(buf);
 
 	return err;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index b061263453d4..09923cedd039 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -326,7 +326,6 @@ int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
 
 	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
 }
-EXPORT_SYMBOL_GPL(mt76u_buf_alloc);
 
 void mt76u_buf_free(struct mt76u_buf *buf)
 {
-- 
2.7.5


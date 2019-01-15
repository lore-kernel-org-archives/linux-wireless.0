Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BE3C43444
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 650562085A
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbfAOMeB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:34:01 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:40754 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729572AbfAOMd5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 07:33:57 -0500
Received: by mail-wm1-f47.google.com with SMTP id f188so2996012wmf.5
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 04:33:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hl3Tn8m7qsr/gOSYjz12EGooAhsaerhrKDCZP32QUtg=;
        b=UnJCYWZy3eVD0TBEjYQqaicTaqvUgfnbYaBFyy1YGxWrN2BtNd2aj5xx6+eoaybVGY
         IvPTrseydIvv4DZHNs3+2M28YSIj0vz9UQu0cS9w1KDhbK0/GVDD+HsjkAV3cHirjF4g
         81aI/Rbq9eRtc9c/ajAvBgOPUbuS5P26rqsHS3xde/zDr5f7e0sXXBxYhQ75lyTy0nKy
         bkgiCjEBXzc1TcCmYJl1wu4Br1tBFO/WYEb4ZOc2zto8lwSxtHXjAzBS5ab+SBVVLqrP
         LZRntHIvR8zmT8jqjo247f17MvBarUoyeb+gX+QLnn8YLLGhVhzikCSd3SH3/ENRIpBO
         xOFA==
X-Gm-Message-State: AJcUukduD7UL/DEkrnTbuUBfE5Lmuz2Ili1NCX0hZmUhK5Tpp7gbV/sL
        QJi8lHkivBSyH+/XmFVSo/ozJw==
X-Google-Smtp-Source: ALg8bN7alPz9ODWlgwYLdD9z1WQGc/gzmlUIqLtOUHdIZkSWYtpJzcCMLDa1Q35BW1JmxhjxaStn+g==
X-Received: by 2002:a1c:a401:: with SMTP id n1mr3364452wme.101.1547555634480;
        Tue, 15 Jan 2019 04:33:54 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a6sm28218186wmh.10.2019.01.15.04.33.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Jan 2019 04:33:53 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, rosenp@gmail.com,
        sgruszka@redhat.com
Subject: [RFC 2/4] mt76: usb: do not use sg buffer for fw upload
Date:   Tue, 15 Jan 2019 13:33:43 +0100
Message-Id: <a135e093dc958c00ebb7d591f4b69d5dbf6fdc29.1547549771.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not use scatter-gather buffers for fw uploading.
Introduce mt76u_buf_alloc and mt76u_buf_alloc_sg routines.
mt76u_buf_alloc will be reused by mt76u for buffer allocation if
scatter-gather is not supported

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  3 +-
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |  9 ++---
 drivers/net/wireless/mediatek/mt76/usb.c      | 37 +++++++++++++++----
 drivers/net/wireless/mediatek/mt76/usb_mcu.c  |  5 +--
 4 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index d31681f90ff2..05ab6672a154 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -86,6 +86,7 @@ struct mt76u_buf {
 	struct mt76_dev *dev;
 	struct urb *urb;
 	size_t len;
+	void *buf;
 	bool done;
 };
 
@@ -713,7 +714,7 @@ void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
 int mt76u_init(struct mt76_dev *dev, struct usb_interface *intf);
 void mt76u_deinit(struct mt76_dev *dev);
 int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
-		    int nsgs, int len, int sglen, gfp_t gfp);
+		    int len, int data_len, gfp_t gfp);
 void mt76u_buf_free(struct mt76u_buf *buf);
 int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 		     struct mt76u_buf *buf, gfp_t gfp,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index 6db789f90269..925aeee56a3e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -78,9 +78,9 @@ static int mt76x02u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 	struct mt76_usb *usb = &dev->usb;
 	struct mt76u_buf *buf = &usb->mcu.res;
 	struct urb *urb = buf->urb;
+	u8 *data = buf->buf;
 	int i, ret;
 	u32 rxfce;
-	u8 *data;
 
 	for (i = 0; i < 5; i++) {
 		if (!wait_for_completion_timeout(&usb->mcu.cmpl,
@@ -90,7 +90,6 @@ static int mt76x02u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 		if (urb->status)
 			return -EIO;
 
-		data = sg_virt(&urb->sg[0]);
 		if (usb->mcu.rp)
 			mt76x02u_multiple_mcu_reads(dev, data + 4,
 						    urb->actual_length - 8);
@@ -271,8 +270,8 @@ static int
 __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
 			    const void *fw_data, int len, u32 dst_addr)
 {
-	u8 *data = sg_virt(&buf->urb->sg[0]);
 	DECLARE_COMPLETION_ONSTACK(cmpl);
+	u8 *data = buf->buf;
 	__le32 info;
 	u32 val;
 	int err;
@@ -325,8 +324,8 @@ int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
 	int err, len, pos = 0, max_len = max_payload - 8;
 	struct mt76u_buf buf;
 
-	err = mt76u_buf_alloc(&dev->mt76, &buf, 1, max_payload, max_payload,
-			      GFP_KERNEL);
+	err = mt76u_buf_alloc(&dev->mt76, &buf, max_payload,
+			      max_payload, GFP_KERNEL);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 44e9f5d66326..4dc288e86fd1 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -320,7 +320,28 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 }
 
 int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
-		    int nsgs, int len, int sglen, gfp_t gfp)
+		    int len, int data_len, gfp_t gfp)
+{
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+
+	buf->urb = usb_alloc_urb(0, gfp);
+	if (!buf->urb)
+		return -ENOMEM;
+
+	buf->buf = page_frag_alloc(&q->rx_page, len, gfp);
+	if (!buf->buf)
+		return -ENOMEM;
+
+	buf->len = data_len;
+	buf->dev = dev;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76u_buf_alloc);
+
+static int
+mt76u_buf_alloc_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
+		   int nsgs, int len, int sglen, gfp_t gfp)
 {
 	buf->urb = usb_alloc_urb(0, gfp);
 	if (!buf->urb)
@@ -336,7 +357,6 @@ int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
 
 	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
 }
-EXPORT_SYMBOL_GPL(mt76u_buf_alloc);
 
 void mt76u_buf_free(struct mt76u_buf *buf)
 {
@@ -345,6 +365,8 @@ void mt76u_buf_free(struct mt76u_buf *buf)
 
 	for (i = 0; i < urb->num_sgs; i++)
 		skb_free_frag(sg_virt(&urb->sg[i]));
+	if (buf->buf)
+		skb_free_frag(buf->buf);
 	usb_free_urb(buf->urb);
 }
 EXPORT_SYMBOL_GPL(mt76u_buf_free);
@@ -355,6 +377,7 @@ int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 {
 	struct usb_interface *intf = to_usb_interface(dev->dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
+	u8 *data = buf->urb->num_sgs ? NULL : buf->buf;
 	unsigned int pipe;
 
 	if (dir == USB_DIR_IN)
@@ -362,7 +385,7 @@ int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 	else
 		pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[index]);
 
-	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len,
+	usb_fill_bulk_urb(buf->urb, udev, pipe, data, buf->len,
 			  complete_fn, context);
 	trace_submit_urb(dev, buf->urb);
 
@@ -549,10 +572,10 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	}
 
 	for (i = 0; i < MT_NUM_RX_ENTRIES; i++) {
-		err = mt76u_buf_alloc(dev, &q->entry[i].ubuf,
-				      nsgs, q->buf_size,
-				      SKB_WITH_OVERHEAD(q->buf_size),
-				      GFP_KERNEL);
+		err = mt76u_buf_alloc_sg(dev, &q->entry[i].ubuf,
+					 nsgs, q->buf_size,
+					 SKB_WITH_OVERHEAD(q->buf_size),
+					 GFP_KERNEL);
 		if (err < 0)
 			return err;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 036be4163e69..e14e82a9e7c0 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -29,9 +29,8 @@ int mt76u_mcu_init_rx(struct mt76_dev *dev)
 	struct mt76_usb *usb = &dev->usb;
 	int err;
 
-	err = mt76u_buf_alloc(dev, &usb->mcu.res, 1,
-			      MCU_RESP_URB_SIZE, MCU_RESP_URB_SIZE,
-			      GFP_KERNEL);
+	err = mt76u_buf_alloc(dev, &usb->mcu.res, MCU_RESP_URB_SIZE,
+			      MCU_RESP_URB_SIZE, GFP_KERNEL);
 	if (err < 0)
 		return err;
 
-- 
2.20.1


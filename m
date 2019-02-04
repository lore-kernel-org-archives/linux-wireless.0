Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BA0C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 16:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 446FE20815
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 16:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbfBDQvw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 11:51:52 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43261 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbfBDQvw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 11:51:52 -0500
Received: by mail-wr1-f67.google.com with SMTP id r2so546347wrv.10
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2019 08:51:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iUB67EhbraYVMIlMDC8HP11pkOg3410J82wjYBgLcCU=;
        b=D/XCaTLVEgfKmvioKs5uRmu/+lXYMXiwFwxFB23AfSw/nkuSW6cil6YOMYtYJg+3fu
         q6gdMCuUiea0eRKCO/+F1AgFN5Ay2fiMVGafpjHxGf0brK9J8ZHOHAbH7Zoh+ix8KdUH
         J1YGq0EDfVawS6++mfag1mkxzQmEj1eUpxZenQVPHkVprpHQdVVppp4mFX/FLoDOkhs+
         3+FLhrBwO4bWZbrjIRBiVThAf6G7Fe5aI8RUoCf4yk+d3OtmFGgZmb8SBZSfnpV8SF59
         QKL4KrIn2qfKSMF1C8KVG0s9BRzNpYQMq5ZRdjT/edCBQFKVux5gYEK8o/NHd7kIo02q
         bY0g==
X-Gm-Message-State: AHQUAuZn/Dby2lotW4Am0yzvhRG+IRTOjY7axDeLpfMSITg27HMOXV07
        QtNxMXBnVDz6E/1V9BX8Eb5U2Q==
X-Google-Smtp-Source: AHgI3IYNgXWvr3RTrYXSsljGFq5honfZNUdnq9jDtu0bU06bhDtWCinnnvvFM+B3JntuciZJi/1boQ==
X-Received: by 2002:adf:f006:: with SMTP id j6mr279216wro.34.1549299109841;
        Mon, 04 Feb 2019 08:51:49 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r22sm11233707wmh.2.2019.02.04.08.51.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 04 Feb 2019 08:51:49 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 1/3] mt76: move mt76_mcu_msg_alloc in mt76-core
Date:   Mon,  4 Feb 2019 17:51:27 +0100
Message-Id: <575bd5eaecda4b99c272c69778dd48ff26ccf680.1549298196.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549298196.git.lorenzo.bianconi@redhat.com>
References: <cover.1549298196.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76_mcu_msg_alloc in mt76-core module and remove duplicated code.
mt76_mcu_msg_alloc will be reused adding support for mt7603 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |  3 +-
 drivers/net/wireless/mediatek/mt76/mcu.c      | 36 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  4 +++
 .../net/wireless/mediatek/mt76/mt76x02_mcu.c  | 12 -------
 .../net/wireless/mediatek/mt76/mt76x02_mcu.h  |  6 ++++
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  | 17 +--------
 6 files changed, 49 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mcu.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 17ab93ab25c3..29f7036c5bbc 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -4,7 +4,8 @@ obj-$(CONFIG_MT76x02_LIB) += mt76x02-lib.o
 obj-$(CONFIG_MT76x02_USB) += mt76x02-usb.o
 
 mt76-y := \
-	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o tx.o agg-rx.o
+	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o \
+	tx.o agg-rx.o mcu.o
 
 mt76-usb-y := usb.o usb_trace.o usb_mcu.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mcu.c b/drivers/net/wireless/mediatek/mt76/mcu.c
new file mode 100644
index 000000000000..f4c38ec78654
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mcu.c
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2019 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "mt76.h"
+
+struct sk_buff *
+mt76_mcu_msg_alloc(const void *data, int head_len,
+		   int data_len, int tail_len)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(head_len + data_len + tail_len,
+			GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, head_len);
+	if (data && data_len)
+		skb_put_data(skb, data, data_len);
+
+	return skb;
+}
+EXPORT_SYMBOL_GPL(mt76_mcu_msg_alloc);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 01130c9f8643..725991f748b4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -773,6 +773,10 @@ void mt76u_stop_queues(struct mt76_dev *dev);
 void mt76u_stop_stat_wk(struct mt76_dev *dev);
 void mt76u_queues_deinit(struct mt76_dev *dev);
 
+struct sk_buff *
+mt76_mcu_msg_alloc(const void *data, int head_len,
+		   int data_len, int tail_len);
+
 void mt76u_mcu_complete_urb(struct urb *urb);
 int mt76u_mcu_init_rx(struct mt76_dev *dev);
 void mt76u_mcu_deinit(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index b7f4edb729e3..d184551b9845 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
@@ -21,18 +21,6 @@
 
 #include "mt76x02_mcu.h"
 
-static struct sk_buff *mt76x02_mcu_msg_alloc(const void *data, int len)
-{
-	struct sk_buff *skb;
-
-	skb = alloc_skb(len, GFP_KERNEL);
-	if (!skb)
-		return NULL;
-	memcpy(skb_put(skb, len), data, len);
-
-	return skb;
-}
-
 static struct sk_buff *
 mt76x02_mcu_get_response(struct mt76x02_dev *dev, unsigned long expires)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
index 7e4004120102..a7b0d3e5df1d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
@@ -96,6 +96,12 @@ struct mt76x02_patch_header {
 	u8 pad[2];
 };
 
+static inline struct sk_buff *
+mt76x02_mcu_msg_alloc(const void *data, int len)
+{
+	return mt76_mcu_msg_alloc(data, 0, len, 0);
+}
+
 int mt76x02_mcu_cleanup(struct mt76x02_dev *dev);
 int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type, u32 param);
 int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index 6db789f90269..ff070f8fbc61 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -28,21 +28,6 @@
 
 #define MT_TX_CPU_FROM_FCE_CPU_DESC_IDX	0x09a8
 
-static struct sk_buff *
-mt76x02u_mcu_msg_alloc(const void *data, int len)
-{
-	struct sk_buff *skb;
-
-	skb = alloc_skb(MT_CMD_HDR_LEN + len + 8, GFP_KERNEL);
-	if (!skb)
-		return NULL;
-
-	skb_reserve(skb, MT_CMD_HDR_LEN);
-	skb_put_data(skb, data, len);
-
-	return skb;
-}
-
 static void
 mt76x02u_multiple_mcu_reads(struct mt76_dev *dev, u8 *data, int len)
 {
@@ -166,7 +151,7 @@ mt76x02u_mcu_send_msg(struct mt76_dev *dev, int cmd, const void *data,
 	struct sk_buff *skb;
 	int err;
 
-	skb = mt76x02u_mcu_msg_alloc(data, len);
+	skb = mt76_mcu_msg_alloc(data, MT_CMD_HDR_LEN, len, 8);
 	if (!skb)
 		return -ENOMEM;
 
-- 
2.20.1


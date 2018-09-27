Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14269C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC9C52156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC9C52156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbeI0PTU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34745 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbeI0PTT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id z4-v6so324125wrb.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ISf0X8KOnis/N1e7N6vQI4W0Fl4YQlCQ+XaHWw3R2Bc=;
        b=cRcpaVi5Kwntomb3mUj/LWEgxqBVWGwjb43wxdxtvrvTArX6YloCtqxbiqWuDHjD2b
         Fn/6McMQt5n5QvpNc2CnIktTcatXTG4/k35xLfVD9RjdXc3KhORiMM7vu7UxYK9Sd02y
         F02Vpwc35dQQBPiHBfCxnvgTjbqGtg6R/9HdQaq95qM39y8ngvF3s4UXr74SJ+/5JkNo
         IMLU3pwpCx5j440e2Nka+4m/gEd2QOZGPouI3I9uWOe+tqn9E5iV8pVO1BOVk1cTUYB7
         r2UBh5EyWvww4GMv2ZoUWodSfaqhDvqa9R+disx+4/94wiGc8nEb7FSXzl7BofydqyYC
         JO4w==
X-Gm-Message-State: ABuFfog3zddaqq6JY2epShLgx8/dQi8LL7Ja7tS5IaHp5EEIihWQAmdN
        fyJyjp1sfKFOjRiqLFb7sB9koA==
X-Google-Smtp-Source: ACcGV60h5nVuDqXdecZX1FwgiyID9QnT4/wFP9JH1llSVXMhIO7S0gbFKEhMtpWNqmN+9TKyeUOE9A==
X-Received: by 2002:adf:e98d:: with SMTP id h13-v6mr8338728wrm.238.1538038924671;
        Thu, 27 Sep 2018 02:02:04 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:04 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 03/26] mt76: add mt76x02_dma_enable/mt76x02_dma_disable utility routines
Date:   Thu, 27 Sep 2018 11:01:32 +0200
Message-Id: <829c1c000477a7600add8319e5a3cff46b690ff6.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76x02_dma_enable and mt76x02_dma_disable utility routines
in order to be reused in mt76x0 mac configuration and remove duplicated
code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_dma.c  | 51 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_dma.h  |  3 ++
 .../net/wireless/mediatek/mt76/mt76x2_init.c  | 20 +-------
 4 files changed, 57 insertions(+), 19 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_dma.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 1fc7450650ee..0cde9dff74a3 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -16,7 +16,7 @@ CFLAGS_trace.o := -I$(src)
 CFLAGS_usb_trace.o := -I$(src)
 
 mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o \
-		 mt76x02_eeprom.o mt76x02_phy.o
+		 mt76x02_eeprom.o mt76x02_phy.o mt76x02_dma.o
 
 mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.c
new file mode 100644
index 000000000000..f471c3a0674a
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
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
+#include <linux/kernel.h>
+
+#include "mt76.h"
+#include "mt76x02_dma.h"
+#include "mt76x02_regs.h"
+
+void mt76x02_dma_enable(struct mt76_dev *dev)
+{
+	u32 val;
+
+	__mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
+	mt76x02_wait_for_wpdma(dev, 1000);
+	usleep_range(50, 100);
+
+	val = FIELD_PREP(MT_WPDMA_GLO_CFG_DMA_BURST_SIZE, 3) |
+	      MT_WPDMA_GLO_CFG_TX_DMA_EN |
+	      MT_WPDMA_GLO_CFG_RX_DMA_EN;
+	__mt76_set(dev, MT_WPDMA_GLO_CFG, val);
+	__mt76_clear(dev, MT_WPDMA_GLO_CFG,
+		     MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
+}
+EXPORT_SYMBOL_GPL(mt76x02_dma_enable);
+
+void mt76x02_dma_disable(struct mt76_dev *dev)
+{
+	u32 val = __mt76_rr(dev, MT_WPDMA_GLO_CFG);
+
+	val &= MT_WPDMA_GLO_CFG_DMA_BURST_SIZE |
+	       MT_WPDMA_GLO_CFG_BIG_ENDIAN |
+	       MT_WPDMA_GLO_CFG_HDR_SEG_LEN;
+	val |= MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE;
+	__mt76_wr(dev, MT_WPDMA_GLO_CFG, val);
+}
+EXPORT_SYMBOL_GPL(mt76x02_dma_disable);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
index 2396d49a84dd..0b78857c9b4c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
@@ -67,4 +67,7 @@ mt76x02_wait_for_wpdma(struct mt76_dev *dev, int timeout)
 			   0, timeout);
 }
 
+void mt76x02_dma_enable(struct mt76_dev *dev);
+void mt76x02_dma_disable(struct mt76_dev *dev);
+
 #endif /* __MT76x02_DMA_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 68244b47312a..bd52c8b2ee9f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -206,16 +206,7 @@ int mt76x2_mac_start(struct mt76x2_dev *dev)
 
 	memset(dev->aggr_stats, 0, sizeof(dev->aggr_stats));
 
-	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
-	mt76x02_wait_for_wpdma(&dev->mt76, 1000);
-	usleep_range(50, 100);
-
-	mt76_set(dev, MT_WPDMA_GLO_CFG,
-		 MT_WPDMA_GLO_CFG_TX_DMA_EN |
-		 MT_WPDMA_GLO_CFG_RX_DMA_EN);
-
-	mt76_clear(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
-
+	mt76x02_dma_enable(&dev->mt76);
 	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
 
 	mt76_wr(dev, MT_MAC_SYS_CTRL,
@@ -354,20 +345,13 @@ int mt76x2_init_hardware(struct mt76x2_dev *dev)
 		0xc000,
 		0xc000,
 	};
-	u32 val;
 	int ret;
 
 	dev->beacon_offsets = beacon_offsets;
 	tasklet_init(&dev->pre_tbtt_tasklet, mt76x2_pre_tbtt_tasklet,
 		     (unsigned long) dev);
 
-	val = mt76_rr(dev, MT_WPDMA_GLO_CFG);
-	val &= MT_WPDMA_GLO_CFG_DMA_BURST_SIZE |
-	       MT_WPDMA_GLO_CFG_BIG_ENDIAN |
-	       MT_WPDMA_GLO_CFG_HDR_SEG_LEN;
-	val |= MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE;
-	mt76_wr(dev, MT_WPDMA_GLO_CFG, val);
-
+	mt76x02_dma_disable(&dev->mt76);
 	mt76x2_reset_wlan(dev, true);
 	mt76x2_power_on(dev);
 
-- 
2.17.1


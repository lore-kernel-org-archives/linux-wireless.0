Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF1CC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0CD02172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0CD02172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbeI1NCo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35065 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbeI1NCn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id o16so5090417wrx.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UX64svwxjg/ET6SxzH4xxaOquANenYPgX87kIMo4+VU=;
        b=Aq5Q+rVF7OCUSYaMhwAsFDxJOsuQeGNvPZezVFo3gptFYtn+QxJcmtCtpb0tHvTvHx
         ELjatFI4DivqXLEXQw7D6xyfFDIQrQkdFsJMWOdgOGDb7X+KrD5lOno4CruSX1AQ0hQY
         7UOuCBOBUn1TlSiqiHZuQrjirlFWcdVGMVLYBeO26Fytj+ZHC/j8j7c9Who/Q+imENGD
         HrJsoS6/FtQVchP6Jcji0JwmfqSJtuft6hD8HK1OIqNA8Ze7GxAm+lJDhqFAkKG6zs10
         QJmgJDcDRHI0S57dVX2bjtQFc/dP5aP16tMaXsLzfzMGu+JJgwAQA4FAGl8fdm+voQgK
         QS2Q==
X-Gm-Message-State: ABuFfoheBgQvOv2mquJsB493xoQ+sf/rkSLIyoGQ/n6zIh+ufi6ubMRL
        xlCFKjyJOmUeMBkS8HDGK/6NNA==
X-Google-Smtp-Source: ACcGV62sBV8kDSIcuc3pAmzZTbrqnU0SY8wyaDXZzI3V+ExloUpJbdbdhX2tho80rsrDvBpXlIWc8g==
X-Received: by 2002:adf:c08c:: with SMTP id d12-v6mr10871404wrf.268.1538116829581;
        Thu, 27 Sep 2018 23:40:29 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:28 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 02/24] mt76: move wait_for_wpdma in mt76x02_dma.h
Date:   Fri, 28 Sep 2018 08:39:55 +0200
Message-Id: <20180928064017.26870-3-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move wait_for_wpdma utility routine in mt76x02_dma.h
in order to be reused by mt76x0 driver. Moreover add
the possibility to specify the timeout value in
wait_for_wpdma signature

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h | 10 ++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h      |  8 --------
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c |  2 +-
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
index 32a323ebc6a7..2396d49a84dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
@@ -18,6 +18,7 @@
 #define __MT76x02_DMA_H
 
 #include "dma.h"
+#include "mt76x02_regs.h"
 
 #define MT_TXD_INFO_LEN			GENMASK(15, 0)
 #define MT_TXD_INFO_NEXT_VLD		BIT(16)
@@ -57,4 +58,13 @@ enum dma_msg_port {
 	DISCARD,
 };
 
+static inline bool
+mt76x02_wait_for_wpdma(struct mt76_dev *dev, int timeout)
+{
+	return __mt76_poll(dev, MT_WPDMA_GLO_CFG,
+			   MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
+			   MT_WPDMA_GLO_CFG_RX_DMA_BUSY,
+			   0, timeout);
+}
+
 #endif /* __MT76x02_DMA_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index a6dd35d00968..b950361e5f87 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -151,14 +151,6 @@ static inline bool mt76x2_wait_for_bbp(struct mt76x2_dev *dev)
 			      0, 100);
 }
 
-static inline bool wait_for_wpdma(struct mt76x2_dev *dev)
-{
-	return mt76_poll(dev, MT_WPDMA_GLO_CFG,
-			 MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
-			 MT_WPDMA_GLO_CFG_RX_DMA_BUSY,
-			 0, 1000);
-}
-
 extern const struct ieee80211_ops mt76x2_ops;
 
 struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 72005faee00e..68244b47312a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -19,6 +19,7 @@
 #include "mt76x2_eeprom.h"
 #include "mt76x2_mcu.h"
 #include "mt76x02_util.h"
+#include "mt76x02_dma.h"
 
 static void
 mt76x2_mac_pbf_init(struct mt76x2_dev *dev)
@@ -206,7 +207,7 @@ int mt76x2_mac_start(struct mt76x2_dev *dev)
 	memset(dev->aggr_stats, 0, sizeof(dev->aggr_stats));
 
 	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
-	wait_for_wpdma(dev);
+	mt76x02_wait_for_wpdma(&dev->mt76, 1000);
 	usleep_range(50, 100);
 
 	mt76_set(dev, MT_WPDMA_GLO_CFG,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
index 0f5d781b13dc..f28c6fbcc305 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
@@ -119,7 +119,7 @@ int mt76x2u_mac_start(struct mt76x2_dev *dev)
 	mt76x2u_mac_reset_counters(dev);
 
 	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
-	wait_for_wpdma(dev);
+	mt76x02_wait_for_wpdma(&dev->mt76, 1000);
 	usleep_range(50, 100);
 
 	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
-- 
2.19.0


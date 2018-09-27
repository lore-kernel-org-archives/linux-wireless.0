Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF96CC004D5
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92C702156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92C702156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbeI0PTS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35371 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbeI0PTR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id o16so1722890wrx.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O/KRut/6OnVTHohLxqYsEzDCoe7rPrOM1qDZrFV9Sdk=;
        b=GaR1xHRcoYkY6IE1YG3NBJsw2g/AOC6ffBaoPBbfwp1QAJgSGuzT5fXEr8wAvk3aPN
         ieBG1cQybb2RzfuefKo3vguGD2RMiL4YGVRUQVSg83m0N21RNzNZMNJSYoPXnZnoqW13
         zAI7TgnHjsD/w4TC5CEIDw2lWIeTMCVI0MDK6ymlobiwpMAzKraOjChGFe0xRmNfd3cj
         qWI+EcZfyHrnuxYfp3REcosAeyyBIbHO5mRak5ddwOgYpjKU+6Bbw0KWyPDJ3OU5b3TG
         Oj7DbCkLziZ5ZeWyU8ockUoUq5EsD6YDerCgDTqaY0pAzImOe4t5IXvA06G8mXyPo3br
         jq1Q==
X-Gm-Message-State: ABuFfohkDWNGXg8JBA2WBZbBzytJHtRZVrIv7euS53m7Gq24x9NdbhE1
        QFG8dBYcvjdXcnKKff9wwayOgQ==
X-Google-Smtp-Source: ACcGV62SGgVGZzC2Ikkc2yyV2oZtTVMC6sF9oZwUSDwcVSDHgSnOFxRDzCgNwqBN3RVjfQUfhQbIAA==
X-Received: by 2002:adf:81b5:: with SMTP id 50-v6mr8379515wra.10.1538038923638;
        Thu, 27 Sep 2018 02:02:03 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:03 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 02/26] mt76: move wait_for_wpdma in mt76x02_dma.h
Date:   Thu, 27 Sep 2018 11:01:31 +0200
Message-Id: <f81b70172c7f98f162a955125fe6270ba5679297.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
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
2.17.1


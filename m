Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79F0C004D5
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA8972156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA8972156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbeI0PTc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37021 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbeI0PTc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:32 -0400
Received: by mail-wm1-f66.google.com with SMTP id y26-v6so4527958wma.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OA1dwJWRBYs2TsUqIMmKOqrlbXu9v1AO+3rkG9Jkf1M=;
        b=ewDSpaZgk99roNLttL5vBrkb69XKZoc8CjZ/ygnMVEkV6qa3zZ3lGMkiFUcH7v3diw
         bzGI3woiKR3iX2Av6AAB6ubF4tf3DWnTWZVN+ywLpyM8ChUx917PQ5VNIXbQ5FBU3/3n
         Twe5J7mlNuYTRn9h1BK7BCd4AaDHm3okcwgVpA6ozPcbC6lfPW3v9P7lbfFQoYnCFVIa
         SmPFpFOeWkn8CUNOclglryjkdF6jtr+McoIfc68S+fyUciaxpbtptJspWyDLhqOPDe/Q
         BM7RihRAsiPQXOdUrJkTkDq0noOp3aPifN17dbwJRepPuQvwGpN/aRZy1oUZD3YsqUpG
         JeOw==
X-Gm-Message-State: ABuFfognIBataNU0g9IaTn7PWuaqnS9lkX7kuDToe00smLEjdQNx5hqA
        EDBcc1sj5pQQ8PJC/Zqr89mXXlR6qE0=
X-Google-Smtp-Source: ACcGV605XjGM80FQWyxL2tUTa5MELKkcE/b7OodY5HaPNrq03IhvC7AoOW80tWGsOSxcvYs4jytqew==
X-Received: by 2002:a7b:c10c:: with SMTP id w12-v6mr7434223wmi.132.1538038938409;
        Thu, 27 Sep 2018 02:02:18 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:17 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 17/26] mt76: add mt76x02_mac_start routine
Date:   Thu, 27 Sep 2018 11:01:46 +0200
Message-Id: <282971bcd54817ae02fbe065bc357ded9e068e56.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76x02_mac_start since the mac start code is shared between
mt76x0e and mt76x2 drivers.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 15 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 12 +-----------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index df4366a702c9..5f120c1fa79f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -18,6 +18,8 @@
 #include "mt76.h"
 #include "mt76x02_regs.h"
 #include "mt76x02_mac.h"
+#include "mt76x02_dma.h"
+#include "mt76x02_util.h"
 
 enum mt76x02_cipher_type
 mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
@@ -520,3 +522,16 @@ void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr)
 		  FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_setaddr);
+
+void mt76x02_mac_start(struct mt76_dev *dev)
+{
+	mt76x02_dma_enable(dev);
+	__mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+	__mt76_wr(dev, MT_MAC_SYS_CTRL,
+		  MT_MAC_SYS_CTRL_ENABLE_TX |
+		  MT_MAC_SYS_CTRL_ENABLE_RX);
+	mt76x02_irq_enable(dev,
+			   MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
+			   MT_INT_TX_STAT);
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_start);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 62072291e416..3d95b60392dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -203,4 +203,5 @@ void mt76x02_send_tx_status(struct mt76_dev *dev,
 int
 mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate);
 void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr);
+void mt76x02_mac_start(struct mt76_dev *dev);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 37cbe550ad1a..3f77c13a6d54 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -188,17 +188,7 @@ int mt76x2_mac_start(struct mt76x2_dev *dev)
 		mt76_rr(dev, MT_TX_STAT_FIFO);
 
 	memset(dev->aggr_stats, 0, sizeof(dev->aggr_stats));
-
-	mt76x02_dma_enable(&dev->mt76);
-	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
-
-	mt76_wr(dev, MT_MAC_SYS_CTRL,
-		MT_MAC_SYS_CTRL_ENABLE_TX |
-		MT_MAC_SYS_CTRL_ENABLE_RX);
-
-	mt76x02_irq_enable(&dev->mt76,
-			   MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
-			   MT_INT_TX_STAT);
+	mt76x02_mac_start(&dev->mt76);
 
 	return 0;
 }
-- 
2.17.1


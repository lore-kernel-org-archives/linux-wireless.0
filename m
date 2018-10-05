Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784F1C65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 327F920652
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:28:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 327F920652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbeJEP00 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:26:26 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40083 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbeJEP00 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:26:26 -0400
Received: by mail-wr1-f66.google.com with SMTP id d2-v6so8186188wro.7
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:28:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y0h/y7cVNABXZYAvp6m8eaA88dzKQ8+7GWdmgeTjW3M=;
        b=XEA2ta8XjtUKjnEbixzqoyDpWDTTdFTkQNZVlt36a85Htk3GGdBBf3OQQOLpuNAhkC
         Lza7we7+hIC9dkDFjUehTtKuQvjp7sTQDqB9iPTeO+0TfFNVICQoVcqsNbKlKDGl4QPu
         Zfuv8Hl7SJdQxRsOUoar6F3MdzjC4KHBeSOHsnv8ss4SdOqJBiigGCMDEeH5P5NsZUUT
         kB5P69jlPMLjXI3VupKyJpvF2c5s+3a0sAY5/p6WCDJC/f8bZVwy40bhOEmanBKLGAzN
         zL38C82cAllxa9bu2u9jvRwjIfcmpDbyzNx1ZklbF37+V4yQ6YPjKSbiSOnEAPGZ+uxX
         j7/Q==
X-Gm-Message-State: ABuFfohMO6MIMznJq+GHzLzhxrVI0fwHeTz5GZa6h5lykQ+AOyhIlLCM
        h1/sDh1nmJisTPcd81AMvNJnRWjA4pk=
X-Google-Smtp-Source: ACcGV61cs/9Uo8Dr4MrUvCjNGc5/7pJ+fzRK6W7CSaLp4rHmsusdCsf4WA5oyliBjKvyUvtWZBU+VQ==
X-Received: by 2002:a5d:5501:: with SMTP id b1-v6mr7169645wrv.228.1538728125773;
        Fri, 05 Oct 2018 01:28:45 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 77-v6sm3630227wmv.6.2018.10.05.01.28.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Oct 2018 01:28:45 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/8] mt76: move tpc routines in mt76x02-lib module
Date:   Fri,  5 Oct 2018 10:28:31 +0200
Message-Id: <d5be683e1454481d8e31298afe1d56953fdac9dc.1538726819.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538726819.git.lorenzo.bianconi@redhat.com>
References: <cover.1538726819.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_tx_get_txpwr_adj and mt76x02_tx_set_txpwr_auto routines
in mt76x02-lib module since they are shared between mt76x0 and mt76x2
drivers. Moreover remove get_txpwr_adj function pointer

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 -
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  2 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  8 ++-
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c | 30 ++++++++++++
 .../wireless/mediatek/mt76/mt76x2/Makefile    |  2 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  4 --
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/tx.c    | 49 -------------------
 9 files changed, 37 insertions(+), 63 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/tx.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 422b09a42bf6..c47ad67ce2ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -262,8 +262,6 @@ struct mt76_driver_ops {
 
 	void (*sta_ps)(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		       bool ps);
-	s8 (*get_tx_txpwr_adj)(struct mt76_dev *dev, s8 txpwr,
-			       s8 max_txpwr_adj);
 };
 
 struct mt76_channel_state {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index fe68cf33aef4..f7325ee10a1e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -138,6 +138,8 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_sta *sta);
 s8 mt76x02_tx_get_max_txpwr_adj(struct mt76_dev *dev,
 				const struct ieee80211_tx_rate *rate);
+s8 mt76x02_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj);
+void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr);
 int mt76x02_insert_hdr_pad(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
 void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 07b3217ecb51..a5058e4a9b14 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -384,11 +384,9 @@ void mt76x02_mac_write_txwi(struct mt76_dev *dev, struct mt76x02_txwi *txwi,
 	}
 	spin_unlock_bh(&dev->lock);
 
-	if (dev->drv->get_tx_txpwr_adj) {
-		txpwr_adj = dev->drv->get_tx_txpwr_adj(dev, dev->txpower_conf,
-						       max_txpwr_adj);
-		txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
-	}
+	txpwr_adj = mt76x02_tx_get_txpwr_adj(dev, dev->txpower_conf,
+					     max_txpwr_adj);
+	txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
 
 	if (nstreams > 1 && mt76_rev(dev) >= MT76XX_REV_E4)
 		txwi->txstream = 0x13;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index 24298b7ddd7d..ebd61c0e40c5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -112,6 +112,36 @@ s8 mt76x02_tx_get_max_txpwr_adj(struct mt76_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_get_max_txpwr_adj);
 
+s8 mt76x02_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj)
+{
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+
+	txpwr = min_t(s8, txpwr, dev->mt76.txpower_conf);
+	txpwr -= (dev->target_power + dev->target_power_delta[0]);
+	txpwr = min_t(s8, txpwr, max_txpwr_adj);
+
+	if (!dev->enable_tpc)
+		return 0;
+	else if (txpwr >= 0)
+		return min_t(s8, txpwr, 7);
+	else
+		return (txpwr < -16) ? 8 : (txpwr + 32) / 2;
+}
+EXPORT_SYMBOL_GPL(mt76x02_tx_get_txpwr_adj);
+
+void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr)
+{
+	s8 txpwr_adj;
+
+	txpwr_adj = mt76x02_tx_get_txpwr_adj(&dev->mt76, txpwr,
+					     dev->mt76.rate_power.ofdm[4]);
+	mt76_rmw_field(dev, MT_PROT_AUTO_TX_CFG,
+		       MT_PROT_AUTO_TX_CFG_PROT_PADJ, txpwr_adj);
+	mt76_rmw_field(dev, MT_PROT_AUTO_TX_CFG,
+		       MT_PROT_AUTO_TX_CFG_AUTO_PADJ, txpwr_adj);
+}
+EXPORT_SYMBOL_GPL(mt76x02_tx_set_txpwr_auto);
+
 static void mt76x02_remove_dma_hdr(struct sk_buff *skb)
 {
 	int hdr_len;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
index 043bfd737edf..2e6ef73944ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_MT76x2E) += mt76x2e.o
 obj-$(CONFIG_MT76x2U) += mt76x2u.o
 
 mt76x2-common-y := \
-	eeprom.o tx.o mac.o init.o phy.o debugfs.o mcu.o
+	eeprom.o mac.o init.o phy.o debugfs.o mcu.o
 
 mt76x2e-y := \
 	pci.o pci_dma.o pci_main.o pci_init.o pci_tx.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index c4d1e5d8cea2..26c1a24c4a2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -102,10 +102,6 @@ void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 
 void mt76x2_update_channel(struct mt76_dev *mdev);
 
-s8 mt76x2_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj);
-void mt76x2_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr);
-
-
 void mt76x2_reset_wlan(struct mt76x02_dev *dev, bool enable);
 void mt76x2_init_txpower(struct mt76x02_dev *dev,
 			 struct ieee80211_supported_band *sband);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 5f6e31f4a69a..194181275611 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -360,7 +360,6 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 		.rx_skb = mt76x02_queue_rx_skb,
 		.rx_poll_complete = mt76x2_rx_poll_complete,
 		.sta_ps = mt76x2_sta_ps,
-		.get_tx_txpwr_adj = mt76x2_tx_get_txpwr_adj,
 	};
 	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 8773ed4af51d..65fef082e7cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -112,7 +112,7 @@ mt76x2_config(struct ieee80211_hw *hw, u32 changed)
 
 		if (test_bit(MT76_STATE_RUNNING, &dev->mt76.state)) {
 			mt76x2_phy_set_txpower(dev);
-			mt76x2_tx_set_txpwr_auto(dev, dev->mt76.txpower_conf);
+			mt76x02_tx_set_txpwr_auto(dev, dev->mt76.txpower_conf);
 		}
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
deleted file mode 100644
index d4f1d6bdb179..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
-#include "mt76x2.h"
-#include "../dma.h"
-
-s8 mt76x2_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj)
-{
-	struct mt76x02_dev  *dev = container_of(mdev, struct mt76x02_dev, mt76);
-
-	txpwr = min_t(s8, txpwr, dev->mt76.txpower_conf);
-	txpwr -= (dev->target_power + dev->target_power_delta[0]);
-	txpwr = min_t(s8, txpwr, max_txpwr_adj);
-
-	if (!dev->enable_tpc)
-		return 0;
-	else if (txpwr >= 0)
-		return min_t(s8, txpwr, 7);
-	else
-		return (txpwr < -16) ? 8 : (txpwr + 32) / 2;
-}
-EXPORT_SYMBOL_GPL(mt76x2_tx_get_txpwr_adj);
-
-void mt76x2_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr)
-{
-	s8 txpwr_adj;
-
-	txpwr_adj = mt76x2_tx_get_txpwr_adj(&dev->mt76, txpwr,
-					    dev->mt76.rate_power.ofdm[4]);
-	mt76_rmw_field(dev, MT_PROT_AUTO_TX_CFG,
-		       MT_PROT_AUTO_TX_CFG_PROT_PADJ, txpwr_adj);
-	mt76_rmw_field(dev, MT_PROT_AUTO_TX_CFG,
-		       MT_PROT_AUTO_TX_CFG_AUTO_PADJ, txpwr_adj);
-}
-EXPORT_SYMBOL_GPL(mt76x2_tx_set_txpwr_auto);
-- 
2.17.1


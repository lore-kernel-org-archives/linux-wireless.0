Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9E8C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC59B20684
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC59B20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbeJCOgQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:36:16 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40276 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbeJCOgQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:36:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id z204-v6so3741297wmc.5
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 00:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y0h/y7cVNABXZYAvp6m8eaA88dzKQ8+7GWdmgeTjW3M=;
        b=la/B1n3qdYAPGVcqUGb6xZvo5xvLz5UmI52otspK7Kb0D+im3FPNuZime5wLEO/oTU
         OVysl9bYg28eNzXFDKZ0UxmeY68KxPFxdWbLNYk6m4/zNM+qGcv/D+eXcO5vgKhd09qi
         o80DXAEm+QGjxoYfUp6nCbYtgo+KrB7rO5bFIluwFqwL9eZxldPsonU6TINFr+zZNvSK
         vt6j+enoFo4AAors1f4qVLdo4wq7medb7Uq39i3+mO7c3X5xIIghjhjWVWISyeJ6gyF8
         QZCdzxE+7pJkvD0wuiO+sTId1x9TJfRyfIRxdINOe8aOLYkFbtXQ8hm/Y2GaD+2Hcjob
         eyog==
X-Gm-Message-State: ABuFfogC5cKR59VszgcfqNpn+jGGb/8U328EJzrYAgYHy0DDDxcWIeVw
        3fKwl9QLKWisy52ZQE7zb8tBUJMgn8M=
X-Google-Smtp-Source: ACcGV602xi25R/ZdoHL0mLqrzKbgooECVfj+tumBGowk4dUWeqdY/LoaKjpjFH1jhJUmhrEmANLEgw==
X-Received: by 2002:a1c:7704:: with SMTP id t4-v6mr534527wmi.136.1538552940133;
        Wed, 03 Oct 2018 00:49:00 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y3sm421878wrw.11.2018.10.03.00.48.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 00:48:59 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 1/9] mt76: move tpc routines in mt76x02-lib module
Date:   Wed,  3 Oct 2018 09:48:43 +0200
Message-Id: <9d36ee5d41f1b7b22ba502d2d818ca289c447783.1538552703.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
References: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
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


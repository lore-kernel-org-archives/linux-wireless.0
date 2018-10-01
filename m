Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C45E5C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 674282089A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 674282089A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbeJBE7f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 00:59:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46358 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbeJBE7f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 00:59:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id z3-v6so15651563wrr.13
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 15:19:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jxvyjPrpRvl4gVBvS0qyaa8zj6PMFT6AzcH2cZLE+7E=;
        b=gm7GYp0tVG4mf0eId4mc8IsH++rzmbFrGOovq47rcwC5yK/fkHiZmJUvpRS4BPaJj+
         hS48I+yBA3xDekC86YhqOcfiOlk8rIo3fCbsbBjePa+Q+xQWasTrWFXo5roXUyGytJYS
         J32hFnXU5Qo3xbY4WVOpB7qUxT7F88mxh8felrzn75lEaNgzqAKmY8yfNt9fywNcjoQn
         Za3WpvO+4WRVVEZfWHPQ3rzQaeC97dyU8polb8U8DffV2CWs2735fUA0dy9Ws02sA0YC
         6LyRl9vXfy5+i6d6UBO3FK7J5qezfyZ6DyUnvWjq8vREsTmbPKTdsbsfC8I0Qtdf/HaK
         YJyQ==
X-Gm-Message-State: ABuFfoinZFLvXVcqgtqYqdgkSOf1Vae5Uggs9G9iVR2IBAiRrJsGHaUy
        MD5+OqdCjZEQ+ulPjKRnKEd51w==
X-Google-Smtp-Source: ACcGV610VmWyFrdhMIQvno1DDKUp+vFQpKR3iv8bcZudXkEkDJ6IXNyyfr8nQwqUq0z3nkD96oTbfQ==
X-Received: by 2002:adf:db8e:: with SMTP id u14-v6mr8825215wri.217.1538432374418;
        Mon, 01 Oct 2018 15:19:34 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id t4-v6sm9203420wrb.45.2018.10.01.15.19.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 15:19:33 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 09/10] mt76: unify rxwi parsing between mt76x2 and mt76x0 drivers
Date:   Tue,  2 Oct 2018 00:19:07 +0200
Message-Id: <20181001221908.16005-10-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Unify rxwi parsing between mt76x2 and mt76x0. Remove the following
routines:
- mt76x0_phy_get_rssi
- mt76x0_queue_rx_skb
- mt76x0_mac_process_rx
Moreover remove mt76x2/common.c and mt76x0/mac.h since are empty files
Enable CCMP PN sw validation

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/initvals.h  |  3 +-
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   | 43 -------------------
 .../net/wireless/mediatek/mt76/mt76x0/mac.h   | 20 ---------
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  1 -
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  3 --
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  7 ---
 .../net/wireless/mediatek/mt76/mt76x0/trace.h |  1 -
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    | 16 -------
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  1 -
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 26 ++++++++++-
 .../net/wireless/mediatek/mt76/mt76x02_util.h |  2 +
 .../wireless/mediatek/mt76/mt76x2/Makefile    |  3 +-
 .../wireless/mediatek/mt76/mt76x2/common.c    | 42 ------------------
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  2 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  2 +-
 17 files changed, 32 insertions(+), 144 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/common.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
index 6f26dc6dabde..236dce6860b4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
@@ -83,7 +83,8 @@ static const struct mt76_reg_pair mt76x0_mac_reg_table[] = {
 	{ MT_LDO_CTRL_1,		0x6B006464 },
 	{ MT_HT_BASIC_RATE,		0x00004003 },
 	{ MT_HT_CTRL_CFG,		0x000001FF },
-	{ MT_TXOP_HLDR_ET,		0x00000000 }
+	{ MT_TXOP_HLDR_ET,		0x00000000 },
+	{ MT_PN_PAD_MODE,		0x00000003 },
 };
 
 static const struct mt76_reg_pair mt76x0_bbp_init_tab[] = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 5fe035323762..793297cd6bf1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -195,46 +195,3 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x02_dev *dev)
 	mt76_wr(dev, MT_MAX_LEN_CFG, 0xa0fff |
 		   FIELD_PREP(MT_MAX_LEN_CFG_AMPDU, min_factor));
 }
-
-u32 mt76x0_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
-			  void *rxi)
-{
-	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
-	struct mt76x02_rxwi *rxwi = rxi;
-	u32 len, ctl = le32_to_cpu(rxwi->ctl);
-	u16 rate = le16_to_cpu(rxwi->rate);
-	struct mt76x02_sta *sta;
-	int rssi, pad_len = 0;
-	u8 wcid;
-
-	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
-	if (WARN_ON(len < 10))
-		return 0;
-
-	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_DECRYPT)) {
-		status->flag |= RX_FLAG_DECRYPTED;
-		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
-	}
-
-	if (rxwi->rxinfo & MT_RXINFO_L2PAD)
-		pad_len += 2;
-
-	wcid = FIELD_GET(MT_RXWI_CTL_WCID, ctl);
-	sta = mt76x02_rx_get_sta(&dev->mt76, wcid);
-
-	mt76x02_remove_hdr_pad(skb, pad_len);
-
-	pskb_trim(skb, len);
-	status->chains = BIT(0);
-	rssi = mt76x0_phy_get_rssi(dev, rxwi);
-	status->chain_signal[0] = status->signal = rssi;
-	status->freq = dev->mt76.chandef.chan->center_freq;
-	status->band = dev->mt76.chandef.chan->band;
-
-	if (sta) {
-		ewma_signal_add(&sta->rssi, status->signal);
-		sta->inactive_count = 0;
-	}
-
-	return mt76x02_mac_process_rate(status, rate);
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
deleted file mode 100644
index c02228413e13..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
- * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __MT76_MAC_H
-#define __MT76_MAC_H
-
-u32 mt76x0_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
-			  void *rxi);
-#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 1f89570bb08b..7803aa00491e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -14,7 +14,6 @@
  */
 
 #include "mt76x0.h"
-#include "mac.h"
 #include "../mt76x02_util.h"
 #include <linux/etherdevice.h>
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 418a3cc76b43..640f6cd6ef1c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -74,7 +74,6 @@ void mt76x0_agc_restore(struct mt76x02_dev *dev);
 int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 			    struct cfg80211_chan_def *chandef);
 void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev);
-int mt76x0_phy_get_rssi(struct mt76x02_dev *dev, struct mt76x02_rxwi *rxwi);
 void mt76x0_phy_set_txpower(struct mt76x02_dev *dev);
 
 /* MAC */
@@ -88,7 +87,5 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x02_dev *dev);
 /* TX */
 void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb);
-void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
-			 struct sk_buff *skb);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 9296ccd53ce6..4850a2db18d7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -226,13 +226,6 @@ mt76x0_bbp_set_ctrlch(struct mt76x02_dev *dev, enum nl80211_chan_width width,
 	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
 }
 
-int mt76x0_phy_get_rssi(struct mt76x02_dev *dev, struct mt76x02_rxwi *rxwi)
-{
-	struct mt76x02_rx_freq_cal *caldata = &dev->cal.rx;
-
-	return rxwi->rssi[0] + caldata->rssi_offset[0] - caldata->lna_gain;
-}
-
 static void mt76x0_vco_cal(struct mt76x02_dev *dev, u8 channel)
 {
 	u8 val;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
index 36bbdd585163..75d1d6738c34 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
@@ -17,7 +17,6 @@
 
 #include <linux/tracepoint.h>
 #include "mt76x0.h"
-#include "mac.h"
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mt76x0
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index dd630fcfaa08..34d115be3447 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -45,19 +45,3 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	mt76_tx(&dev->mt76, control->sta, wcid, skb);
 }
 EXPORT_SYMBOL_GPL(mt76x0_tx);
-
-void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
-			 struct sk_buff *skb)
-{
-	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
-	void *rxwi = skb->data;
-
-	skb_pull(skb, sizeof(struct mt76x02_rxwi));
-	if (mt76x0_mac_process_rx(dev, skb, rxwi)) {
-		dev_kfree_skb(skb);
-		return;
-	}
-
-	mt76_rx(&dev->mt76, q, skb);
-}
-EXPORT_SYMBOL_GPL(mt76x0_queue_rx_skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index f9468bb4cba0..1a23dd1491b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -218,7 +218,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 		.tx_prepare_skb = mt76x02u_tx_prepare_skb,
 		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.tx_status_data = mt76x02_tx_status_data,
-		.rx_skb = mt76x0_queue_rx_skb,
+		.rx_skb = mt76x02_queue_rx_skb,
 	};
 	struct usb_device *usb_dev = interface_to_usbdev(usb_intf);
 	struct mt76x02_dev *dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 859b6c5c4117..a743f1c5fa55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -686,4 +686,3 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 
 	return mt76x02_mac_process_rate(status, rate);
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_process_rx);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 496be05e59a6..6e657c7d1d73 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -20,6 +20,7 @@
 #include "mt76x02_dma.h"
 #include "mt76x02_regs.h"
 #include "mt76x02_mac.h"
+#include "mt76x02_util.h"
 
 #define CCK_RATE(_idx, _rate) {					\
 	.bitrate = _rate,					\
@@ -545,7 +546,6 @@ mt76x02_rx_get_sta(struct mt76_dev *dev, u8 idx)
 
 	return container_of(wcid, struct mt76x02_sta, wcid);
 }
-EXPORT_SYMBOL_GPL(mt76x02_rx_get_sta);
 
 struct mt76_wcid *
 mt76x02_rx_get_sta_wcid(struct mt76x02_sta *sta, bool unicast)
@@ -558,6 +558,28 @@ mt76x02_rx_get_sta_wcid(struct mt76x02_sta *sta, bool unicast)
 	else
 		return &sta->vif->group_wcid;
 }
-EXPORT_SYMBOL_GPL(mt76x02_rx_get_sta_wcid);
+
+void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
+			  struct sk_buff *skb)
+{
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+	void *rxwi = skb->data;
+
+	if (q == MT_RXQ_MCU) {
+		/* this is used just by mmio code */
+		skb_queue_tail(&mdev->mmio.mcu.res_q, skb);
+		wake_up(&mdev->mmio.mcu.wait);
+		return;
+	}
+
+	skb_pull(skb, sizeof(struct mt76x02_rxwi));
+	if (mt76x02_mac_process_rx(dev, skb, rxwi)) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	mt76_rx(mdev, q, skb);
+}
+EXPORT_SYMBOL_GPL(mt76x02_queue_rx_skb);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index cfae0497fde0..d629823724b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -144,6 +144,8 @@ bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update);
 struct mt76x02_sta *mt76x02_rx_get_sta(struct mt76_dev *dev, u8 idx);
 struct mt76_wcid *
 mt76x02_rx_get_sta_wcid(struct mt76x02_sta *sta, bool unicast);
+void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
+			  struct sk_buff *skb);
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_set_beacon_offsets(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
index 560c46e02ec7..043bfd737edf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
@@ -3,8 +3,7 @@ obj-$(CONFIG_MT76x2E) += mt76x2e.o
 obj-$(CONFIG_MT76x2U) += mt76x2u.o
 
 mt76x2-common-y := \
-	eeprom.o tx.o mac.o init.o common.o phy.o \
-	debugfs.o mcu.o
+	eeprom.o tx.o mac.o init.o phy.o debugfs.o mcu.o
 
 mt76x2e-y := \
 	pci.o pci_dma.o pci_main.o pci_init.o pci_tx.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/common.c b/drivers/net/wireless/mediatek/mt76/mt76x2/common.c
deleted file mode 100644
index d953c65cac80..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/common.c
+++ /dev/null
@@ -1,42 +0,0 @@
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
-#include "../mt76x02_mac.h"
-
-void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
-			 struct sk_buff *skb)
-{
-	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
-	void *rxwi = skb->data;
-
-	if (q == MT_RXQ_MCU) {
-		/* this is used just by mmio code */
-		skb_queue_tail(&mdev->mmio.mcu.res_q, skb);
-		wake_up(&mdev->mmio.mcu.wait);
-		return;
-	}
-
-	skb_pull(skb, sizeof(struct mt76x02_rxwi));
-	if (mt76x02_mac_process_rx(dev, skb, rxwi)) {
-		dev_kfree_skb(skb);
-		return;
-	}
-
-	mt76_rx(&dev->mt76, q, skb);
-}
-EXPORT_SYMBOL_GPL(mt76x2_queue_rx_skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 238cbf1eb14c..fc5a09478d14 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -101,8 +101,6 @@ void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
 void mt76x2_pre_tbtt_tasklet(unsigned long arg);
 
 void mt76x2_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q);
-void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
-			 struct sk_buff *skb);
 
 void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 2b38f97c3103..c8077d4a62aa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -359,7 +359,7 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 		.update_survey = mt76x2_update_channel,
 		.tx_prepare_skb = mt76x2_tx_prepare_skb,
 		.tx_complete_skb = mt76x2_tx_complete_skb,
-		.rx_skb = mt76x2_queue_rx_skb,
+		.rx_skb = mt76x02_queue_rx_skb,
 		.rx_poll_complete = mt76x2_rx_poll_complete,
 		.sta_ps = mt76x2_sta_ps,
 		.get_tx_txpwr_adj = mt76x2_tx_get_txpwr_adj,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index abadcc503281..0e1a97e406a8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -141,7 +141,7 @@ struct mt76x02_dev *mt76x2u_alloc_device(struct device *pdev)
 		.tx_prepare_skb = mt76x02u_tx_prepare_skb,
 		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.tx_status_data = mt76x02_tx_status_data,
-		.rx_skb = mt76x2_queue_rx_skb,
+		.rx_skb = mt76x02_queue_rx_skb,
 	};
 	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
-- 
2.19.0


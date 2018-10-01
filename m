Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8458CC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E71B20645
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:34:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E71B20645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbeJBFOw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 01:14:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43518 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeJBFOw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 01:14:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id n1-v6so5551071wrt.10
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 15:34:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Hl9PxRPHqEylDyc70rLgo0COjsPjOOOKBgARUUFUbA=;
        b=i8It5IL5VhCmCqaDP783lmv26pJ9L8ywNA8se474fi8eX+p6nep3rsVKnyOBmj9DYI
         Zq4El47edGcDjGOviT9T36YAQNp/XkFhRefVjs3QiHKhbwXGnAS8JnJbDjfrU4fHX5b8
         NXr/6Wub1WSdUwY2W1+rIWIZp7R3mUnl5I5iE1FU/XNI1kBufgxv0z5ouvDwFcjW+QhT
         rs0zGMkQ28DI1NkrGs2TF9+n6e0xzQYsZ55g8hzMTv3LMbB/ICiePeJ97o4nT2CvZyJS
         TqLenzCihAylsuMpi6L2Pllh35myj376/5qCZSVw+y14sxZnHUj8qH7n1gZfOgDm56G9
         7LkQ==
X-Gm-Message-State: ABuFfojpf27BRC+TfR8hlX0VpxzBeyLSgBO2t0CZ1HD1juiG//qkqSNP
        z/RZZfCLv+eojkI9ebRvXLmuGZ/puBA=
X-Google-Smtp-Source: ACcGV60u5FB9LvdNKynSd9rNNASKKX1oZ9CbG3iq4qCOabIh8BBStJtp9MIfLeukNn3R0GGwQ8Q47Q==
X-Received: by 2002:a5d:5342:: with SMTP id t2-v6mr8379267wrv.257.1538433289185;
        Mon, 01 Oct 2018 15:34:49 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id 184-v6sm22231093wmv.6.2018.10.01.15.34.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 15:34:48 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mt76: move txrx shared routines in mt76x02_txrx.c
Date:   Tue,  2 Oct 2018 00:34:27 +0200
Message-Id: <20181001223429.21061-2-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x02_txrx.c source file in order to contain tx/rx shared
routines for mt76x0 and mt76x2 drivers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |   3 +-
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c | 162 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 140 ---------------
 3 files changed, 164 insertions(+), 141 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 907b9e2d7044..09c90eef61a4 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -12,7 +12,8 @@ CFLAGS_trace.o := -I$(src)
 CFLAGS_usb_trace.o := -I$(src)
 
 mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o \
-		 mt76x02_eeprom.o mt76x02_phy.o mt76x02_mmio.o
+		 mt76x02_eeprom.o mt76x02_phy.o mt76x02_mmio.o \
+		 mt76x02_txrx.o
 
 mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
new file mode 100644
index 000000000000..caa9bb107e68
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -0,0 +1,162 @@
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
+#include "mt76x02_regs.h"
+#include "mt76x02_dma.h"
+#include "mt76x02_util.h"
+
+void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
+		struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct mt76x02_dev *dev = hw->priv;
+	struct ieee80211_vif *vif = info->control.vif;
+	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
+
+	if (control->sta) {
+		struct mt76x02_sta *msta;
+
+		msta = (struct mt76x02_sta *)control->sta->drv_priv;
+		wcid = &msta->wcid;
+		/* sw encrypted frames */
+		if (!info->control.hw_key && wcid->hw_key_idx != 0xff)
+			control->sta = NULL;
+	}
+
+	if (vif && !control->sta) {
+		struct mt76x02_vif *mvif;
+
+		mvif = (struct mt76x02_vif *)vif->drv_priv;
+		wcid = &mvif->group_wcid;
+	}
+
+	mt76_tx(&dev->mt76, control->sta, wcid, skb);
+}
+EXPORT_SYMBOL_GPL(mt76x02_tx);
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
+
+s8 mt76x02_tx_get_max_txpwr_adj(struct mt76_dev *dev,
+				const struct ieee80211_tx_rate *rate)
+{
+	s8 max_txpwr;
+
+	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
+		u8 mcs = ieee80211_rate_get_vht_mcs(rate);
+
+		if (mcs == 8 || mcs == 9) {
+			max_txpwr = dev->rate_power.vht[8];
+		} else {
+			u8 nss, idx;
+
+			nss = ieee80211_rate_get_vht_nss(rate);
+			idx = ((nss - 1) << 3) + mcs;
+			max_txpwr = dev->rate_power.ht[idx & 0xf];
+		}
+	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
+		max_txpwr = dev->rate_power.ht[rate->idx & 0xf];
+	} else {
+		enum nl80211_band band = dev->chandef.chan->band;
+
+		if (band == NL80211_BAND_2GHZ) {
+			const struct ieee80211_rate *r;
+			struct wiphy *wiphy = dev->hw->wiphy;
+			struct mt76_rate_power *rp = &dev->rate_power;
+
+			r = &wiphy->bands[band]->bitrates[rate->idx];
+			if (r->flags & IEEE80211_RATE_SHORT_PREAMBLE)
+				max_txpwr = rp->cck[r->hw_value & 0x3];
+			else
+				max_txpwr = rp->ofdm[r->hw_value & 0x7];
+		} else {
+			max_txpwr = dev->rate_power.ofdm[rate->idx & 0x7];
+		}
+	}
+
+	return max_txpwr;
+}
+EXPORT_SYMBOL_GPL(mt76x02_tx_get_max_txpwr_adj);
+
+static void mt76x02_remove_dma_hdr(struct sk_buff *skb)
+{
+	int hdr_len;
+
+	skb_pull(skb, sizeof(struct mt76x02_txwi) + MT_DMA_HDR_LEN);
+	hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	if (hdr_len % 4)
+		mt76x02_remove_hdr_pad(skb, 2);
+}
+
+void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+		ieee80211_free_txskb(dev->hw, skb);
+	} else {
+		ieee80211_tx_info_clear_status(info);
+		info->status.rates[0].idx = -1;
+		info->flags |= IEEE80211_TX_STAT_ACK;
+		ieee80211_tx_status(dev->hw, skb);
+	}
+}
+EXPORT_SYMBOL_GPL(mt76x02_tx_complete);
+
+void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			     struct mt76_queue_entry *e, bool flush)
+{
+	mt76x02_remove_dma_hdr(e->skb);
+	mt76x02_tx_complete(mdev, e->skb);
+}
+EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
+
+bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update)
+{
+	struct mt76x02_tx_status stat;
+
+	if (!mt76x02_mac_load_tx_status(dev, &stat))
+		return false;
+
+	mt76x02_send_tx_status(dev, &stat, update);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(mt76x02_tx_status_data);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index a33fd1b0c640..8a099253b28d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -17,7 +17,6 @@
 
 #include <linux/module.h>
 #include "mt76.h"
-#include "mt76x02_dma.h"
 #include "mt76x02_regs.h"
 #include "mt76x02_mac.h"
 #include "mt76x02_util.h"
@@ -359,47 +358,6 @@ int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_conf_tx);
 
-s8 mt76x02_tx_get_max_txpwr_adj(struct mt76_dev *dev,
-				const struct ieee80211_tx_rate *rate)
-{
-	s8 max_txpwr;
-
-	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
-		u8 mcs = ieee80211_rate_get_vht_mcs(rate);
-
-		if (mcs == 8 || mcs == 9) {
-			max_txpwr = dev->rate_power.vht[8];
-		} else {
-			u8 nss, idx;
-
-			nss = ieee80211_rate_get_vht_nss(rate);
-			idx = ((nss - 1) << 3) + mcs;
-			max_txpwr = dev->rate_power.ht[idx & 0xf];
-		}
-	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
-		max_txpwr = dev->rate_power.ht[rate->idx & 0xf];
-	} else {
-		enum nl80211_band band = dev->chandef.chan->band;
-
-		if (band == NL80211_BAND_2GHZ) {
-			const struct ieee80211_rate *r;
-			struct wiphy *wiphy = dev->hw->wiphy;
-			struct mt76_rate_power *rp = &dev->rate_power;
-
-			r = &wiphy->bands[band]->bitrates[rate->idx];
-			if (r->flags & IEEE80211_RATE_SHORT_PREAMBLE)
-				max_txpwr = rp->cck[r->hw_value & 0x3];
-			else
-				max_txpwr = rp->ofdm[r->hw_value & 0x7];
-		} else {
-			max_txpwr = dev->rate_power.ofdm[rate->idx & 0x7];
-		}
-	}
-
-	return max_txpwr;
-}
-EXPORT_SYMBOL_GPL(mt76x02_tx_get_max_txpwr_adj);
-
 void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta)
@@ -448,52 +406,6 @@ void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len)
 }
 EXPORT_SYMBOL_GPL(mt76x02_remove_hdr_pad);
 
-static void mt76x02_remove_dma_hdr(struct sk_buff *skb)
-{
-	int hdr_len;
-
-	skb_pull(skb, sizeof(struct mt76x02_txwi) + MT_DMA_HDR_LEN);
-	hdr_len = ieee80211_get_hdrlen_from_skb(skb);
-	if (hdr_len % 4)
-		mt76x02_remove_hdr_pad(skb, 2);
-}
-
-void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
-	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-		ieee80211_free_txskb(dev->hw, skb);
-	} else {
-		ieee80211_tx_info_clear_status(info);
-		info->status.rates[0].idx = -1;
-		info->flags |= IEEE80211_TX_STAT_ACK;
-		ieee80211_tx_status(dev->hw, skb);
-	}
-}
-EXPORT_SYMBOL_GPL(mt76x02_tx_complete);
-
-void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
-			    struct mt76_queue_entry *e, bool flush)
-{
-	mt76x02_remove_dma_hdr(e->skb);
-	mt76x02_tx_complete(mdev, e->skb);
-}
-EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
-
-bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update)
-{
-	struct mt76x02_tx_status stat;
-
-	if (!mt76x02_mac_load_tx_status(dev, &stat))
-		return false;
-
-	mt76x02_send_tx_status(dev, &stat, update);
-
-	return true;
-}
-EXPORT_SYMBOL_GPL(mt76x02_tx_status_data);
-
 const u16 mt76x02_beacon_offsets[16] = {
 	/* 1024 byte per beacon */
 	0xc000,
@@ -559,56 +471,4 @@ mt76x02_rx_get_sta_wcid(struct mt76x02_sta *sta, bool unicast)
 		return &sta->vif->group_wcid;
 }
 
-void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
-			  struct sk_buff *skb)
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
-	mt76_rx(mdev, q, skb);
-}
-EXPORT_SYMBOL_GPL(mt76x02_queue_rx_skb);
-
-void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
-		struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct mt76x02_dev *dev = hw->priv;
-	struct ieee80211_vif *vif = info->control.vif;
-	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
-
-	if (control->sta) {
-		struct mt76x02_sta *msta;
-
-		msta = (struct mt76x02_sta *)control->sta->drv_priv;
-		wcid = &msta->wcid;
-		/* sw encrypted frames */
-		if (!info->control.hw_key && wcid->hw_key_idx != 0xff)
-			control->sta = NULL;
-	}
-
-	if (vif && !control->sta) {
-		struct mt76x02_vif *mvif;
-
-		mvif = (struct mt76x02_vif *)vif->drv_priv;
-		wcid = &mvif->group_wcid;
-	}
-
-	mt76_tx(&dev->mt76, control->sta, wcid, skb);
-}
-EXPORT_SYMBOL_GPL(mt76x02_tx);
-
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.19.0


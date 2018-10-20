Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0224CECDE3D
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCDB82150F
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCDB82150F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbeJTSX5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:23:57 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52084 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbeJTSX5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:23:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id 143-v6so5759907wmf.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hP46mzNzsEULLiuwjwvaFrmYr451FYJ1VphW/FVoPCk=;
        b=qzWBdszgtselTy9oz2ItqKVTtEpvCtlWjTy+fXIJX4VA20ZRLvb3G+brLBCwWP9TlR
         50bfgyzwwsjSIFlH8xwFH+mRHyoYQNMWr3xjqS2FPWjuO/Uwv1R2wdHs7jFh4KgIAOkh
         WavhTW9dVKXmmGFbclm0iN3YxLyo0gA/WfmLdX1uVlwHBPGxmOaSG+Eyz2cH/uwMhloY
         s+o2ylWtiSHYTlFP8ZiNuN8v4cG30jlkUppuW9Z32Nybsef7yl0eyC9usdtheqzzoYt2
         fN0skbhUpIedJjj7cEgILN6lgbHBppeAWp7tio/tDPE1DhKmLoQmqVgQ0E5RPxDE81QX
         fYmw==
X-Gm-Message-State: ABuFfoj7TFo4FX49efNN5+6aAlvFsJlh/HPBgfyGx8LAcc/NcFsNRWIO
        5NwIWBXUNmSuK810fOvmm7gc4A==
X-Google-Smtp-Source: ACcGV62vtulUnxPrnhYhvdOFFcoRupGbI5dRClPD1jXvDLx1FoaXr1FWTYRVrgoN/AOsj1nF3C8Bzw==
X-Received: by 2002:a1c:b9cf:: with SMTP id j198-v6mr8181865wmf.57.1540030440760;
        Sat, 20 Oct 2018 03:14:00 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id c2-v6sm19548631wrt.77.2018.10.20.03.13.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:14:00 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/9] mt76: move tx beacon routines in mt76x02-lib module
Date:   Sat, 20 Oct 2018 12:13:26 +0200
Message-Id: <8a9811f39ad6612ef25823c6b08c569a417d461e.1540029458.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
References: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_tx beacon utility routines in mt76x02_mmio.c
in order to be reused by mt76x0 driver adding AP support

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |   2 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 125 +++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/Makefile    |   4 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |   2 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |   2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_tx.c    | 142 ------------------
 6 files changed, 130 insertions(+), 147 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 1cd0f758587d..72343d329f81 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -148,6 +148,8 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			   u32 *tx_info);
 
+void mt76x02_pre_tbtt_tasklet(unsigned long arg);
+
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev);
 void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 784b76e08382..ab1c8c8ef15b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -21,6 +21,131 @@
 #include "mt76x02.h"
 #include "mt76x02_trace.h"
 
+struct beacon_bc_data {
+	struct mt76x02_dev *dev;
+	struct sk_buff_head q;
+	struct sk_buff *tail[8];
+};
+
+static void
+mt76x02_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt76x02_dev *dev = (struct mt76x02_dev *)priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
+	struct sk_buff *skb = NULL;
+
+	if (!(dev->beacon_mask & BIT(mvif->idx)))
+		return;
+
+	skb = ieee80211_beacon_get(mt76_hw(dev), vif);
+	if (!skb)
+		return;
+
+	mt76x02_mac_set_beacon(dev, mvif->idx, skb);
+}
+
+static void
+mt76x02_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct beacon_bc_data *data = priv;
+	struct mt76x02_dev *dev = data->dev;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
+	struct ieee80211_tx_info *info;
+	struct sk_buff *skb;
+
+	if (!(dev->beacon_mask & BIT(mvif->idx)))
+		return;
+
+	skb = ieee80211_get_buffered_bc(mt76_hw(dev), vif);
+	if (!skb)
+		return;
+
+	info = IEEE80211_SKB_CB(skb);
+	info->control.vif = vif;
+	info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
+	mt76_skb_set_moredata(skb, true);
+	__skb_queue_tail(&data->q, skb);
+	data->tail[mvif->idx] = skb;
+}
+
+static void
+mt76x02_resync_beacon_timer(struct mt76x02_dev *dev)
+{
+	u32 timer_val = dev->beacon_int << 4;
+
+	dev->tbtt_count++;
+
+	/*
+	 * Beacon timer drifts by 1us every tick, the timer is configured
+	 * in 1/16 TU (64us) units.
+	 */
+	if (dev->tbtt_count < 62)
+		return;
+
+	if (dev->tbtt_count >= 64) {
+		dev->tbtt_count = 0;
+		return;
+	}
+
+	/*
+	 * The updated beacon interval takes effect after two TBTT, because
+	 * at this point the original interval has already been loaded into
+	 * the next TBTT_TIMER value
+	 */
+	if (dev->tbtt_count == 62)
+		timer_val -= 1;
+
+	mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
+		       MT_BEACON_TIME_CFG_INTVAL, timer_val);
+}
+
+void mt76x02_pre_tbtt_tasklet(unsigned long arg)
+{
+	struct mt76x02_dev *dev = (struct mt76x02_dev *)arg;
+	struct mt76_queue *q = &dev->mt76.q_tx[MT_TXQ_PSD];
+	struct beacon_bc_data data = {};
+	struct sk_buff *skb;
+	int i, nframes;
+
+	mt76x02_resync_beacon_timer(dev);
+
+	data.dev = dev;
+	__skb_queue_head_init(&data.q);
+
+	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+		IEEE80211_IFACE_ITER_RESUME_ALL,
+		mt76x02_update_beacon_iter, dev);
+
+	do {
+		nframes = skb_queue_len(&data.q);
+		ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+			IEEE80211_IFACE_ITER_RESUME_ALL,
+			mt76x02_add_buffered_bc, &data);
+	} while (nframes != skb_queue_len(&data.q));
+
+	if (!nframes)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(data.tail); i++) {
+		if (!data.tail[i])
+			continue;
+
+		mt76_skb_set_moredata(data.tail[i], false);
+	}
+
+	spin_lock_bh(&q->lock);
+	while ((skb = __skb_dequeue(&data.q)) != NULL) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+		struct ieee80211_vif *vif = info->control.vif;
+		struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
+
+		mt76_dma_tx_queue_skb(&dev->mt76, q, skb, &mvif->group_wcid,
+				      NULL);
+	}
+	spin_unlock_bh(&q->lock);
+}
+EXPORT_SYMBOL_GPL(mt76x02_pre_tbtt_tasklet);
+
 static int
 mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
 		      int idx, int n_desc)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
index 696f071f47f8..cf8ef1a2f261 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
@@ -6,8 +6,8 @@ mt76x2-common-y := \
 	eeprom.o mac.o init.o phy.o mcu.o
 
 mt76x2e-y := \
-	pci.o pci_main.o pci_init.o pci_tx.o \
-	pci_mac.o pci_mcu.o pci_phy.o pci_dfs.o
+	pci.o pci_main.o pci_init.o pci_mac.o \
+	pci_mcu.o pci_phy.o pci_dfs.o
 
 mt76x2u-y := \
 	usb.o usb_init.o usb_main.o usb_mac.o usb_mcu.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index eaa44de14826..2bae70c63ab0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -77,8 +77,6 @@ void mt76x2_cleanup(struct mt76x02_dev *dev);
 
 void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
 
-void mt76x2_pre_tbtt_tasklet(unsigned long arg);
-
 void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 
 void mt76x2_reset_wlan(struct mt76x02_dev *dev, bool enable);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 5c1531ae8b93..bc1dbdf5af20 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -298,7 +298,7 @@ int mt76x2_init_hardware(struct mt76x02_dev *dev)
 {
 	int ret;
 
-	tasklet_init(&dev->pre_tbtt_tasklet, mt76x2_pre_tbtt_tasklet,
+	tasklet_init(&dev->pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
 		     (unsigned long) dev);
 
 	mt76x02_dma_disable(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
deleted file mode 100644
index fac38cbaa41b..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
+++ /dev/null
@@ -1,142 +0,0 @@
-/*
- * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
-
-struct beacon_bc_data {
-	struct mt76x02_dev *dev;
-	struct sk_buff_head q;
-	struct sk_buff *tail[8];
-};
-
-static void
-mt76x2_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
-{
-	struct mt76x02_dev *dev = (struct mt76x02_dev *) priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
-	struct sk_buff *skb = NULL;
-
-	if (!(dev->beacon_mask & BIT(mvif->idx)))
-		return;
-
-	skb = ieee80211_beacon_get(mt76_hw(dev), vif);
-	if (!skb)
-		return;
-
-	mt76x02_mac_set_beacon(dev, mvif->idx, skb);
-}
-
-static void
-mt76x2_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
-{
-	struct beacon_bc_data *data = priv;
-	struct mt76x02_dev *dev = data->dev;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
-	struct ieee80211_tx_info *info;
-	struct sk_buff *skb;
-
-	if (!(dev->beacon_mask & BIT(mvif->idx)))
-		return;
-
-	skb = ieee80211_get_buffered_bc(mt76_hw(dev), vif);
-	if (!skb)
-		return;
-
-	info = IEEE80211_SKB_CB(skb);
-	info->control.vif = vif;
-	info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
-	mt76_skb_set_moredata(skb, true);
-	__skb_queue_tail(&data->q, skb);
-	data->tail[mvif->idx] = skb;
-}
-
-static void
-mt76x2_resync_beacon_timer(struct mt76x02_dev *dev)
-{
-	u32 timer_val = dev->beacon_int << 4;
-
-	dev->tbtt_count++;
-
-	/*
-	 * Beacon timer drifts by 1us every tick, the timer is configured
-	 * in 1/16 TU (64us) units.
-	 */
-	if (dev->tbtt_count < 62)
-		return;
-
-	if (dev->tbtt_count >= 64) {
-		dev->tbtt_count = 0;
-		return;
-	}
-
-	/*
-	 * The updated beacon interval takes effect after two TBTT, because
-	 * at this point the original interval has already been loaded into
-	 * the next TBTT_TIMER value
-	 */
-	if (dev->tbtt_count == 62)
-		timer_val -= 1;
-
-	mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
-		       MT_BEACON_TIME_CFG_INTVAL, timer_val);
-}
-
-void mt76x2_pre_tbtt_tasklet(unsigned long arg)
-{
-	struct mt76x02_dev *dev = (struct mt76x02_dev *) arg;
-	struct mt76_queue *q = &dev->mt76.q_tx[MT_TXQ_PSD];
-	struct beacon_bc_data data = {};
-	struct sk_buff *skb;
-	int i, nframes;
-
-	mt76x2_resync_beacon_timer(dev);
-
-	data.dev = dev;
-	__skb_queue_head_init(&data.q);
-
-	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
-		IEEE80211_IFACE_ITER_RESUME_ALL,
-		mt76x2_update_beacon_iter, dev);
-
-	do {
-		nframes = skb_queue_len(&data.q);
-		ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
-			IEEE80211_IFACE_ITER_RESUME_ALL,
-			mt76x2_add_buffered_bc, &data);
-	} while (nframes != skb_queue_len(&data.q));
-
-	if (!nframes)
-		return;
-
-	for (i = 0; i < ARRAY_SIZE(data.tail); i++) {
-		if (!data.tail[i])
-			continue;
-
-		mt76_skb_set_moredata(data.tail[i], false);
-	}
-
-	spin_lock_bh(&q->lock);
-	while ((skb = __skb_dequeue(&data.q)) != NULL) {
-		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-		struct ieee80211_vif *vif = info->control.vif;
-		struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
-
-		mt76_dma_tx_queue_skb(&dev->mt76, q, skb, &mvif->group_wcid,
-				      NULL);
-	}
-	spin_unlock_bh(&q->lock);
-}
-
-- 
2.19.1


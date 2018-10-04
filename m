Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2EBC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 21:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAA202084D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 21:53:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAA202084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbeJEEtA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:49:00 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53103 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbeJEEs6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 00:48:58 -0400
Received: by mail-wm1-f68.google.com with SMTP id 189-v6so44673wmw.2
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 14:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+lhocSAdiXuU8mWJKNKCeU1mmdcv41Ri7yvbO9sQw+o=;
        b=gIZhGfX8jZXX082Xp53rmifRwiXuBDV+n1O34GW4LG/LCUCmn3hmTW5GFTH3TCBmuD
         BVbW6CbPTk+stRCeFXRXqFWpi/COHaH0JbgNsjacoI9Ur+W9MrMYQpP66zHCqBP5UR04
         9z6X+ofqKMrhj8Ud1XM/n3T/bbh34b1YhcbA8NZdmhZxiu2SdL4mNe3e6VTwnHAguxMf
         0gOe2gii303no9QyyUVK8RZvgZKJCX0G4QKLaQs8TgXGZsMuCK6qL8XPhcoYQcRJdaXg
         kyQoUEQUYnCSCVgrZQtFT+GrhsHfqxRNdb11M9UcBFMvHifE10bR3U4KIppsBCeWOeug
         mXRA==
X-Gm-Message-State: ABuFfogaCkciOQpu+tg9z0HNsdDrFT+fXQDPdVE+8e57T2pRmmHBeiwE
        k/9ctfb37snkdUj96yF+Ylh680mbazI=
X-Google-Smtp-Source: ACcGV62GghwDpccZ7QflaN55W2LvI9aik9mB7tdG2oG1vszL/N81/bMW546k0BQH7+H2LVuSETBxTw==
X-Received: by 2002:a1c:a9ce:: with SMTP id s197-v6mr5798777wme.82.1538690015573;
        Thu, 04 Oct 2018 14:53:35 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id e6-v6sm5696189wrc.70.2018.10.04.14.53.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Oct 2018 14:53:35 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 10/10] mt76: move mt76x02_tx in mt76x02-lib module
Date:   Thu,  4 Oct 2018 23:53:12 +0200
Message-Id: <20181004215312.3094-11-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_tx shared routine in mt76x02-lib module and remove
duplicated code. Moreover remove mt76x0/tx.c since it is an empty
file

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/Makefile    |  2 +-
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  4 --
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    | 47 -------------------
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 29 ++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.h |  2 +
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  2 -
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/tx.c    | 29 ------------
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  2 +-
 11 files changed, 36 insertions(+), 87 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
index 254d94efd24d..20672978dceb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_MT76x0_COMMON) += mt76x0-common.o
 
 mt76x0-common-y := \
 	init.o main.o trace.o eeprom.o phy.o \
-	mac.o debugfs.o tx.o
+	mac.o debugfs.o
 mt76x0u-y := usb.o usb_mcu.o
 mt76x0e-y := pci.o pci_mcu.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 640f6cd6ef1c..237407200908 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -84,8 +84,4 @@ void mt76x0_mac_set_short_preamble(struct mt76x02_dev *dev, bool short_preamb);
 void mt76x0_mac_config_tsf(struct mt76x02_dev *dev, bool enable, int interval);
 void mt76x0_mac_set_ampdu_factor(struct mt76x02_dev *dev);
 
-/* TX */
-void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
-		struct sk_buff *skb);
-
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index f6f54cac0326..80c6b1ca9065 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -70,7 +70,7 @@ static void mt76x0e_stop(struct ieee80211_hw *hw)
 }
 
 static const struct ieee80211_ops mt76x0e_ops = {
-	.tx = mt76x0_tx,
+	.tx = mt76x02_tx,
 	.start = mt76x0e_start,
 	.stop = mt76x0e_stop,
 	.config = mt76x0_config,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
deleted file mode 100644
index 34d115be3447..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ /dev/null
@@ -1,47 +0,0 @@
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
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
- * GNU General Public License for more details.
- */
-
-#include "mt76x0.h"
-#include "trace.h"
-#include "../mt76x02_util.h"
-#include "../mt76x02_usb.h"
-
-void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
-	       struct sk_buff *skb)
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
-EXPORT_SYMBOL_GPL(mt76x0_tx);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 7bcdaf9fe0a9..1a9450e6703f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -139,7 +139,7 @@ static void mt76x0u_stop(struct ieee80211_hw *hw)
 }
 
 static const struct ieee80211_ops mt76x0u_ops = {
-	.tx = mt76x0_tx,
+	.tx = mt76x02_tx,
 	.start = mt76x0u_start,
 	.stop = mt76x0u_stop,
 	.add_interface = mt76x02_add_interface,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 543f7723b038..1d7bec697842 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -555,4 +555,33 @@ void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 }
 EXPORT_SYMBOL_GPL(mt76x02_queue_rx_skb);
 
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
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index d442057273aa..f492e796613d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -143,6 +143,8 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update);
 void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			  struct sk_buff *skb);
+void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
+		struct sk_buff *skb);
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_set_beacon_offsets(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index fc5a09478d14..c7d5e666cc65 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -88,8 +88,6 @@ void mt76x2_dma_cleanup(struct mt76x02_dev *dev);
 
 void mt76x2_cleanup(struct mt76x02_dev *dev);
 
-void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
-	       struct sk_buff *skb);
 int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 			  struct sk_buff *skb, struct mt76_queue *q,
 			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 2556c65c6528..9f42372acd81 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -281,7 +281,7 @@ mt76x2_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
 }
 
 const struct ieee80211_ops mt76x2_ops = {
-	.tx = mt76x2_tx,
+	.tx = mt76x02_tx,
 	.start = mt76x2_start,
 	.stop = mt76x2_stop,
 	.add_interface = mt76x02_add_interface,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
index 144ee6973797..d4f1d6bdb179 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
@@ -18,35 +18,6 @@
 #include "mt76x2.h"
 #include "../dma.h"
 
-void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
-	       struct sk_buff *skb)
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
-EXPORT_SYMBOL_GPL(mt76x2_tx);
-
 s8 mt76x2_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj)
 {
 	struct mt76x02_dev  *dev = container_of(mdev, struct mt76x02_dev, mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 6c2f26c6722e..6c7699278582 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -160,7 +160,7 @@ mt76x2u_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 }
 
 const struct ieee80211_ops mt76x2u_ops = {
-	.tx = mt76x2_tx,
+	.tx = mt76x02_tx,
 	.start = mt76x2u_start,
 	.stop = mt76x2u_stop,
 	.add_interface = mt76x2u_add_interface,
-- 
2.19.0


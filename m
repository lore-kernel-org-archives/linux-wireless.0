Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15E9ECDE44
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89AD3214C4
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89AD3214C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbeJTSvM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:51:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40701 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbeJTSvM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:51:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id z204-v6so5878152wmc.5
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:41:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L1vj1JGQfN2KXuHClIU4lvNkvpyiXCaHiEfP4x4i10U=;
        b=FbMX+yne2+xDi68hUJ3viRRzg++g2a864ndTHRpw9KlZJMlm3YZa512ch2ztc118OV
         McSIAVweKkUWvKqJlfWhgyp6f4k94YlPYtxn2TCQvUTPNm11yoejbxDu3FRoihxxWE3p
         q/i13pLXrm6gXoModl3yQD0j8hyWlT8ns2rd7RvVUoiZj3xIHZ0/uCxvD6Igb4zsCPJG
         vcL0TiLTNpewHW3oQ7dy5kTTQEZiyar7fxPSZtYQ4cN/hZbRFgk730NWHXuHZ1wjYGbH
         XR7ER6OyNzPFnHdzBfM4obXaJzGDQw7xuUwX5ExfK8ZqSDBgfW/i6ASbPj+Idovm3vU+
         wM5g==
X-Gm-Message-State: ABuFfogdVsvblY9aLqzUegBhKomf8LTWPFLngDTfxZqeK4ZehAiursvn
        NrG6z/+HW2Uns5wTHrWoOvLnSA==
X-Google-Smtp-Source: ACcGV62VQq1RT8z4j4Zcdnnc8eBi77Q68puQCVqCBlTIpMPFx9MQerq0eypMy6yI83OAQZHea1bBgg==
X-Received: by 2002:a1c:5c2:: with SMTP id 185-v6mr8124611wmf.140.1540032068918;
        Sat, 20 Oct 2018 03:41:08 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id x17-v6sm23205207wrs.84.2018.10.20.03.41.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:41:08 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mt76: move tx protection routines in mt76x02-lib module
Date:   Sat, 20 Oct 2018 12:40:54 +0200
Message-Id: <536f81b1c71aa976ef6fac5a0668cf5d7eb065f3.1540031637.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540031637.git.lorenzo.bianconi@redhat.com>
References: <cover.1540031637.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_set_rts_threshold and mt76x02_mac_set_tx_protection
routines in mt76x02-lib module and remove duplicated code in mt76x0
and mt76x2 drivers. Remove pci_mac.c and mt76x0/mac.c since now are
empty files

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/Makefile    |  3 +-
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   | 77 -------------------
 .../net/wireless/mediatek/mt76/mt76x0/main.c  | 14 ----
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  5 --
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 30 ++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  4 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 15 ++++
 .../wireless/mediatek/mt76/mt76x2/Makefile    |  4 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  2 -
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   | 50 ------------
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  | 17 +---
 14 files changed, 54 insertions(+), 171 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
index 1b4f2fa99317..aa22ba954716 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
@@ -2,8 +2,7 @@ obj-$(CONFIG_MT76x0U) += mt76x0u.o
 obj-$(CONFIG_MT76x0E) += mt76x0e.o
 obj-$(CONFIG_MT76x0_COMMON) += mt76x0-common.o
 
-mt76x0-common-y := \
-	init.o main.o eeprom.o phy.o mac.o
+mt76x0-common-y := init.o main.o eeprom.o phy.o
 
 mt76x0u-y := usb.o usb_mcu.o
 mt76x0e-y := pci.o pci_mcu.o
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
deleted file mode 100644
index 78d15cb006e0..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ /dev/null
@@ -1,77 +0,0 @@
-/*
- * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
- * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
- * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
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
-#include <linux/etherdevice.h>
-
-#include "mt76x0.h"
-
-void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
-			       int ht_mode)
-{
-	int mode = ht_mode & IEEE80211_HT_OP_MODE_PROTECTION;
-	bool non_gf = !!(ht_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
-	u32 prot[6];
-	bool ht_rts[4] = {};
-	int i;
-
-	prot[0] = MT_PROT_NAV_SHORT |
-		  MT_PROT_TXOP_ALLOW_ALL |
-		  MT_PROT_RTS_THR_EN;
-	prot[1] = prot[0];
-	if (legacy_prot)
-		prot[1] |= MT_PROT_CTRL_CTS2SELF;
-
-	prot[2] = prot[4] = MT_PROT_NAV_SHORT | MT_PROT_TXOP_ALLOW_BW20;
-	prot[3] = prot[5] = MT_PROT_NAV_SHORT | MT_PROT_TXOP_ALLOW_ALL;
-
-	if (legacy_prot) {
-		prot[2] |= MT_PROT_RATE_CCK_11;
-		prot[3] |= MT_PROT_RATE_CCK_11;
-		prot[4] |= MT_PROT_RATE_CCK_11;
-		prot[5] |= MT_PROT_RATE_CCK_11;
-	} else {
-		prot[2] |= MT_PROT_RATE_OFDM_24;
-		prot[3] |= MT_PROT_RATE_DUP_OFDM_24;
-		prot[4] |= MT_PROT_RATE_OFDM_24;
-		prot[5] |= MT_PROT_RATE_DUP_OFDM_24;
-	}
-
-	switch (mode) {
-	case IEEE80211_HT_OP_MODE_PROTECTION_NONE:
-		break;
-
-	case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
-		ht_rts[0] = ht_rts[1] = ht_rts[2] = ht_rts[3] = true;
-		break;
-
-	case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
-		ht_rts[1] = ht_rts[3] = true;
-		break;
-
-	case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
-		ht_rts[0] = ht_rts[1] = ht_rts[2] = ht_rts[3] = true;
-		break;
-	}
-
-	if (non_gf)
-		ht_rts[2] = ht_rts[3] = true;
-
-	for (i = 0; i < 4; i++)
-		if (ht_rts[i])
-			prot[i + 2] |= MT_PROT_CTRL_RTS_CTS;
-
-	for (i = 0; i < 6; i++)
-		mt76_wr(dev, MT_CCK_PROT_CFG + i * 4, prot[i]);
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 8de19fe534a3..b8eba511d0f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -107,10 +107,6 @@ void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 		dev->tbtt_count = 0;
 	}
 
-	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
-		mt76x0_mac_set_protection(dev, info->use_cts_prot,
-					   info->ht_operation_mode);
-
 	if (changed & BSS_CHANGED_ERP_PREAMBLE)
 		mt76x02_mac_set_short_preamble(dev, info->use_short_preamble);
 
@@ -124,13 +120,3 @@ void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 	mutex_unlock(&dev->mt76.mutex);
 }
 EXPORT_SYMBOL_GPL(mt76x0_bss_info_changed);
-
-int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	mt76_rmw_field(dev, MT_TX_RTS_CFG, MT_TX_RTS_CFG_THRESH, value);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mt76x0_set_rts_threshold);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 5b4f30225dc1..14ca5937ed97 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -65,7 +65,6 @@ int mt76x0_config(struct ieee80211_hw *hw, u32 changed);
 void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_bss_conf *info, u32 changed);
-int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
 
 /* PHY */
 void mt76x0_phy_init(struct mt76x02_dev *dev);
@@ -74,8 +73,4 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 			    struct cfg80211_chan_def *chandef);
 void mt76x0_phy_set_txpower(struct mt76x02_dev *dev);
 void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on);
-
-/* MAC */
-void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
-				int ht_mode);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index b16227fdbdc4..0a5b499061e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -105,6 +105,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.set_tim = mt76x0e_set_tim,
 	.release_buffered_frames = mt76_release_buffered_frames,
 	.set_coverage_class = mt76x02_set_coverage_class,
+	.set_rts_threshold = mt76x02_set_rts_threshold,
 };
 
 static int mt76x0e_register_device(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 2105e966f745..690c2e6abaeb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -154,7 +154,7 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.ampdu_action = mt76x02_ampdu_action,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
-	.set_rts_threshold = mt76x0_set_rts_threshold,
+	.set_rts_threshold = mt76x02_set_rts_threshold,
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.get_txpower = mt76x02_get_txpower,
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 95af2b1c7eed..3b698f0e8b28 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -136,6 +136,7 @@ void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr);
 void mt76x02_set_tx_ackto(struct mt76x02_dev *dev);
 void mt76x02_set_coverage_class(struct ieee80211_hw *hw,
 				s16 coverage_class);
+int mt76x02_set_rts_threshold(struct ieee80211_hw *hw, u32 val);
 int mt76x02_insert_hdr_pad(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
 void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index d9d7f3e609fc..4fb9f095ffec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -739,6 +739,36 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
 
+void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val)
+{
+	u32 data = 0;
+
+	if (val != ~0)
+		data = FIELD_PREP(MT_PROT_CFG_CTRL, 1) |
+		       MT_PROT_CFG_RTS_THRESH;
+
+	mt76_rmw_field(dev, MT_TX_RTS_CFG, MT_TX_RTS_CFG_THRESH, val);
+
+	mt76_rmw(dev, MT_CCK_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_OFDM_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_MM20_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_MM40_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_GF20_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_GF40_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_TX_PROT_CFG6,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_TX_PROT_CFG7,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_TX_PROT_CFG8,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+}
+
 void mt76x02_update_channel(struct mt76_dev *mdev)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 350cb0fed980..f65157600779 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -216,8 +216,8 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 			    struct mt76x02_tx_status *stat, u8 *update);
 int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 			   void *rxi);
-int
-mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate);
+int mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate);
+void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
 void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr);
 void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index c485f6600ae9..65eed824d9c8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -468,6 +468,21 @@ void mt76x02_set_coverage_class(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x02_set_coverage_class);
 
+int mt76x02_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
+{
+	struct mt76x02_dev *dev = hw->priv;
+
+	if (val != ~0 && val > 0xffff)
+		return -EINVAL;
+
+	mutex_lock(&dev->mutex);
+	mt76x02_mac_set_tx_protection(dev, val);
+	mutex_unlock(&dev->mutex);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_set_rts_threshold);
+
 void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
index cf8ef1a2f261..eec18e293407 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
@@ -6,8 +6,8 @@ mt76x2-common-y := \
 	eeprom.o mac.o init.o phy.o mcu.o
 
 mt76x2e-y := \
-	pci.o pci_main.o pci_init.o pci_mac.o \
-	pci_mcu.o pci_phy.o pci_dfs.o
+	pci.o pci_main.o pci_init.o pci_mcu.o \
+	pci_phy.o pci_dfs.o
 
 mt76x2u-y := \
 	usb.o usb_init.o usb_main.o usb_mac.o usb_mcu.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 3f0b9c78625d..4dfd49190735 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -74,8 +74,6 @@ int mt76x2_mcu_load_cr(struct mt76x02_dev *dev, u8 type, u8 temp_level,
 
 void mt76x2_cleanup(struct mt76x02_dev *dev);
 
-void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
-
 void mt76x2_reset_wlan(struct mt76x02_dev *dev, bool enable);
 void mt76x2_init_txpower(struct mt76x02_dev *dev,
 			 struct ieee80211_supported_band *sband);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
deleted file mode 100644
index 31e1f5bd9050..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ /dev/null
@@ -1,50 +0,0 @@
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
-#include <linux/delay.h>
-#include "mt76x2.h"
-#include "mcu.h"
-#include "eeprom.h"
-
-void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val)
-{
-	u32 data = 0;
-
-	if (val != ~0)
-		data = FIELD_PREP(MT_PROT_CFG_CTRL, 1) |
-		       MT_PROT_CFG_RTS_THRESH;
-
-	mt76_rmw_field(dev, MT_TX_RTS_CFG, MT_TX_RTS_CFG_THRESH, val);
-
-	mt76_rmw(dev, MT_CCK_PROT_CFG,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_OFDM_PROT_CFG,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_MM20_PROT_CFG,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_MM40_PROT_CFG,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_GF20_PROT_CFG,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_GF40_PROT_CFG,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_TX_PROT_CFG6,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_TX_PROT_CFG7,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-	mt76_rmw(dev, MT_TX_PROT_CFG8,
-		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index f984bb0f9aa1..f1bd36c46036 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -210,21 +210,6 @@ static int mt76x2_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant,
 	return 0;
 }
 
-static int
-mt76x2_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	if (val != ~0 && val > 0xffff)
-		return -EINVAL;
-
-	mutex_lock(&dev->mutex);
-	mt76x2_mac_set_tx_protection(dev, val);
-	mutex_unlock(&dev->mutex);
-
-	return 0;
-}
-
 const struct ieee80211_ops mt76x2_ops = {
 	.tx = mt76x02_tx,
 	.start = mt76x2_start,
@@ -251,6 +236,6 @@ const struct ieee80211_ops mt76x2_ops = {
 	.set_tim = mt76x2_set_tim,
 	.set_antenna = mt76x2_set_antenna,
 	.get_antenna = mt76x2_get_antenna,
-	.set_rts_threshold = mt76x2_set_rts_threshold,
+	.set_rts_threshold = mt76x02_set_rts_threshold,
 };
 
-- 
2.19.1


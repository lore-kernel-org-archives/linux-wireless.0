Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA346C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 09:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEBAB20836
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 09:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfCDJsb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 04:48:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfCDJsb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 04:48:31 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B5C7713CE3;
        Mon,  4 Mar 2019 09:48:30 +0000 (UTC)
Received: from localhost (unknown [10.40.205.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 343276109E;
        Mon,  4 Mar 2019 09:48:25 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 01/11] mt76x02: introduce mt76x02_beacon.c
Date:   Mon,  4 Mar 2019 10:48:06 +0100
Message-Id: <1551692896-7062-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
References: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 04 Mar 2019 09:48:30 +0000 (UTC)
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move most of beaconing code into separate file and separate beacon
initialization for USB and MMIO as pre TBTT implementation for USB
will be different.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |   2 +-
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   1 -
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |   2 +
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |   1 +
 .../wireless/mediatek/mt76/mt76x02_beacon.c   | 212 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 138 ------------
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |  17 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |   1 +
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |   6 +
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  62 -----
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |   2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |   2 +-
 13 files changed, 242 insertions(+), 206 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 3fd1b64b4aa7..cad4fed1a6ac 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -16,7 +16,7 @@ CFLAGS_mt76x02_trace.o := -I$(src)
 mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o \
 		 mt76x02_eeprom.o mt76x02_phy.o mt76x02_mmio.o \
 		 mt76x02_txrx.o mt76x02_trace.o mt76x02_debugfs.o \
-		 mt76x02_dfs.o
+		 mt76x02_dfs.o mt76x02_beacon.o
 
 mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index bcb72e019fd2..e5f4ce3b595b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -259,7 +259,6 @@ int mt76x0_init_hardware(struct mt76x02_dev *dev)
 		return ret;
 
 	mt76x0_phy_init(dev);
-	mt76x02_init_beacon_config(dev);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index f302162036d0..fafe57653ac0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -128,6 +128,8 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
 	if (err < 0)
 		return err;
 
+	mt76x02e_init_beacon_config(dev);
+
 	if (mt76_chip(&dev->mt76) == 0x7610) {
 		u16 val;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 91718647da02..9d3ad8586530 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -175,6 +175,8 @@ static int mt76x0u_init_hardware(struct mt76x02_dev *dev)
 	if (err < 0)
 		return err;
 
+	mt76x02u_init_beacon_config(dev);
+
 	mt76_rmw(dev, MT_US_CYC_CFG, MT_US_CYC_CNT, 0x1e);
 	mt76_wr(dev, MT_TXOP_CTRL_CFG,
 		FIELD_PREP(MT_TXOP_TRUN_EN, 0x3f) |
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index e42262fd7380..7485abdcc842 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -183,6 +183,7 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_init_beacon_config(struct mt76x02_dev *dev);
+void mt76x02e_init_beacon_config(struct mt76x02_dev *dev);
 void mt76x02_mac_start(struct mt76x02_dev *dev);
 
 void mt76x02_init_debugfs(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
new file mode 100644
index 000000000000..e9f71def9f21
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
@@ -0,0 +1,212 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
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
+#include "mt76x02.h"
+
+const u16 mt76x02_beacon_offsets[16] = {
+	/* 1024 byte per beacon */
+	0xc000,
+	0xc400,
+	0xc800,
+	0xcc00,
+	0xd000,
+	0xd400,
+	0xd800,
+	0xdc00,
+	/* BSS idx 8-15 not used for beacons */
+	0xc000,
+	0xc000,
+	0xc000,
+	0xc000,
+	0xc000,
+	0xc000,
+	0xc000,
+	0xc000,
+};
+
+static void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
+{
+	u16 val, base = MT_BEACON_BASE;
+	u32 regs[4] = {};
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		val = mt76x02_beacon_offsets[i] - base;
+		regs[i / 4] |= (val / 64) << (8 * (i % 4));
+	}
+
+	for (i = 0; i < 4; i++)
+		mt76_wr(dev, MT_BCN_OFFSET(i), regs[i]);
+}
+
+static int
+mt76x02_write_beacon(struct mt76x02_dev *dev, int offset, struct sk_buff *skb)
+{
+	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
+	struct mt76x02_txwi txwi;
+
+	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x02_txwi)))
+		return -ENOSPC;
+
+	mt76x02_mac_write_txwi(dev, &txwi, skb, NULL, NULL, skb->len);
+
+	mt76_wr_copy(dev, offset, &txwi, sizeof(txwi));
+	offset += sizeof(txwi);
+
+	mt76_wr_copy(dev, offset, skb->data, skb->len);
+	return 0;
+}
+
+static int
+__mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 bcn_idx,
+			 struct sk_buff *skb)
+{
+	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
+	int beacon_addr = mt76x02_beacon_offsets[bcn_idx];
+	int ret = 0;
+	int i;
+
+	/* Prevent corrupt transmissions during update */
+	mt76_set(dev, MT_BCN_BYPASS_MASK, BIT(bcn_idx));
+
+	if (skb) {
+		ret = mt76x02_write_beacon(dev, beacon_addr, skb);
+		if (!ret)
+			dev->beacon_data_mask |= BIT(bcn_idx);
+	} else {
+		dev->beacon_data_mask &= ~BIT(bcn_idx);
+		for (i = 0; i < beacon_len; i += 4)
+			mt76_wr(dev, beacon_addr + i, 0);
+	}
+
+	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xff00 | ~dev->beacon_data_mask);
+
+	return ret;
+}
+
+int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
+			   struct sk_buff *skb)
+{
+	bool force_update = false;
+	int bcn_idx = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->beacons); i++) {
+		if (vif_idx == i) {
+			force_update = !!dev->beacons[i] ^ !!skb;
+
+			if (dev->beacons[i])
+				dev_kfree_skb(dev->beacons[i]);
+
+			dev->beacons[i] = skb;
+			__mt76x02_mac_set_beacon(dev, bcn_idx, skb);
+		} else if (force_update && dev->beacons[i]) {
+			__mt76x02_mac_set_beacon(dev, bcn_idx,
+						 dev->beacons[i]);
+		}
+
+		bcn_idx += !!dev->beacons[i];
+	}
+
+	for (i = bcn_idx; i < ARRAY_SIZE(dev->beacons); i++) {
+		if (!(dev->beacon_data_mask & BIT(i)))
+			break;
+
+		__mt76x02_mac_set_beacon(dev, i, NULL);
+	}
+
+	mt76_rmw_field(dev, MT_MAC_BSSID_DW1, MT_MAC_BSSID_DW1_MBEACON_N,
+		       bcn_idx - 1);
+	return 0;
+}
+
+static void
+__mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
+				bool val, struct sk_buff *skb)
+{
+	u8 old_mask = dev->beacon_mask;
+	bool en;
+	u32 reg;
+
+	if (val) {
+		dev->beacon_mask |= BIT(vif_idx);
+		if (skb)
+			mt76x02_mac_set_beacon(dev, vif_idx, skb);
+	} else {
+		dev->beacon_mask &= ~BIT(vif_idx);
+		mt76x02_mac_set_beacon(dev, vif_idx, NULL);
+	}
+
+	if (!!old_mask == !!dev->beacon_mask)
+		return;
+
+	en = dev->beacon_mask;
+
+	reg = MT_BEACON_TIME_CFG_BEACON_TX |
+	      MT_BEACON_TIME_CFG_TBTT_EN |
+	      MT_BEACON_TIME_CFG_TIMER_EN;
+	mt76_rmw(dev, MT_BEACON_TIME_CFG, reg, reg * en);
+
+	if (mt76_is_usb(dev))
+		return;
+
+	mt76_rmw_field(dev, MT_INT_TIMER_EN, MT_INT_TIMER_EN_PRE_TBTT_EN, en);
+	if (en)
+		mt76x02_irq_enable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+	else
+		mt76x02_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+}
+
+void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
+				   struct ieee80211_vif *vif, bool val)
+{
+	u8 vif_idx = ((struct mt76x02_vif *)vif->drv_priv)->idx;
+	struct sk_buff *skb = NULL;
+
+	if (mt76_is_mmio(dev))
+		tasklet_disable(&dev->pre_tbtt_tasklet);
+	else if (val)
+		skb = ieee80211_beacon_get(mt76_hw(dev), vif);
+
+	if (!dev->beacon_mask)
+		dev->tbtt_count = 0;
+
+	__mt76x02_mac_set_beacon_enable(dev, vif_idx, val, skb);
+
+	if (mt76_is_mmio(dev))
+		tasklet_enable(&dev->pre_tbtt_tasklet);
+}
+
+void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
+{
+	int i;
+
+	mt76_clear(dev, MT_BEACON_TIME_CFG, (MT_BEACON_TIME_CFG_TIMER_EN |
+					     MT_BEACON_TIME_CFG_TBTT_EN |
+					     MT_BEACON_TIME_CFG_BEACON_TX));
+	mt76_set(dev, MT_BEACON_TIME_CFG, MT_BEACON_TIME_CFG_SYNC_MODE);
+	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xffff);
+
+	for (i = 0; i < 8; i++)
+		mt76x02_mac_set_beacon(dev, i, NULL);
+
+	mt76x02_set_beacon_offsets(dev);
+}
+EXPORT_SYMBOL_GPL(mt76x02_init_beacon_config);
+
+
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index e2077ba3c761..f4448d43114c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -1036,141 +1036,3 @@ void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
 	mt76_rmw_field(dev, MT_MAC_APC_BSSID_H(idx), MT_MAC_APC_BSSID_H_ADDR,
 		       get_unaligned_le16(addr + 4));
 }
-
-static int
-mt76x02_write_beacon(struct mt76x02_dev *dev, int offset, struct sk_buff *skb)
-{
-	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
-	struct mt76x02_txwi txwi;
-
-	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x02_txwi)))
-		return -ENOSPC;
-
-	mt76x02_mac_write_txwi(dev, &txwi, skb, NULL, NULL, skb->len);
-
-	mt76_wr_copy(dev, offset, &txwi, sizeof(txwi));
-	offset += sizeof(txwi);
-
-	mt76_wr_copy(dev, offset, skb->data, skb->len);
-	return 0;
-}
-
-static int
-__mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 bcn_idx,
-			 struct sk_buff *skb)
-{
-	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
-	int beacon_addr = mt76x02_beacon_offsets[bcn_idx];
-	int ret = 0;
-	int i;
-
-	/* Prevent corrupt transmissions during update */
-	mt76_set(dev, MT_BCN_BYPASS_MASK, BIT(bcn_idx));
-
-	if (skb) {
-		ret = mt76x02_write_beacon(dev, beacon_addr, skb);
-		if (!ret)
-			dev->beacon_data_mask |= BIT(bcn_idx);
-	} else {
-		dev->beacon_data_mask &= ~BIT(bcn_idx);
-		for (i = 0; i < beacon_len; i += 4)
-			mt76_wr(dev, beacon_addr + i, 0);
-	}
-
-	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xff00 | ~dev->beacon_data_mask);
-
-	return ret;
-}
-
-int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
-			   struct sk_buff *skb)
-{
-	bool force_update = false;
-	int bcn_idx = 0;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(dev->beacons); i++) {
-		if (vif_idx == i) {
-			force_update = !!dev->beacons[i] ^ !!skb;
-
-			if (dev->beacons[i])
-				dev_kfree_skb(dev->beacons[i]);
-
-			dev->beacons[i] = skb;
-			__mt76x02_mac_set_beacon(dev, bcn_idx, skb);
-		} else if (force_update && dev->beacons[i]) {
-			__mt76x02_mac_set_beacon(dev, bcn_idx,
-						 dev->beacons[i]);
-		}
-
-		bcn_idx += !!dev->beacons[i];
-	}
-
-	for (i = bcn_idx; i < ARRAY_SIZE(dev->beacons); i++) {
-		if (!(dev->beacon_data_mask & BIT(i)))
-			break;
-
-		__mt76x02_mac_set_beacon(dev, i, NULL);
-	}
-
-	mt76_rmw_field(dev, MT_MAC_BSSID_DW1, MT_MAC_BSSID_DW1_MBEACON_N,
-		       bcn_idx - 1);
-	return 0;
-}
-
-static void
-__mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
-				bool val, struct sk_buff *skb)
-{
-	u8 old_mask = dev->beacon_mask;
-	bool en;
-	u32 reg;
-
-	if (val) {
-		dev->beacon_mask |= BIT(vif_idx);
-		if (skb)
-			mt76x02_mac_set_beacon(dev, vif_idx, skb);
-	} else {
-		dev->beacon_mask &= ~BIT(vif_idx);
-		mt76x02_mac_set_beacon(dev, vif_idx, NULL);
-	}
-
-	if (!!old_mask == !!dev->beacon_mask)
-		return;
-
-	en = dev->beacon_mask;
-
-	reg = MT_BEACON_TIME_CFG_BEACON_TX |
-	      MT_BEACON_TIME_CFG_TBTT_EN |
-	      MT_BEACON_TIME_CFG_TIMER_EN;
-	mt76_rmw(dev, MT_BEACON_TIME_CFG, reg, reg * en);
-
-	if (mt76_is_usb(dev))
-		return;
-
-	mt76_rmw_field(dev, MT_INT_TIMER_EN, MT_INT_TIMER_EN_PRE_TBTT_EN, en);
-	if (en)
-		mt76x02_irq_enable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
-	else
-		mt76x02_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
-}
-
-void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
-				   struct ieee80211_vif *vif, bool val)
-{
-	u8 vif_idx = ((struct mt76x02_vif *)vif->drv_priv)->idx;
-	struct sk_buff *skb = NULL;
-
-	if (mt76_is_mmio(dev))
-		tasklet_disable(&dev->pre_tbtt_tasklet);
-	else if (val)
-		skb = ieee80211_beacon_get(mt76_hw(dev), vif);
-
-	if (!dev->beacon_mask)
-		dev->tbtt_count = 0;
-
-	__mt76x02_mac_set_beacon_enable(dev, vif_idx, val, skb);
-
-	if (mt76_is_mmio(dev))
-		tasklet_enable(&dev->pre_tbtt_tasklet);
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index c2a2fa353297..73c950ace209 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -152,6 +152,21 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 	spin_unlock_bh(&q->lock);
 }
 
+void mt76x02e_init_beacon_config(struct mt76x02_dev *dev)
+{
+	tasklet_init(&dev->pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
+		     (unsigned long)dev);
+
+	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
+	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT, 8 << 4);
+	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
+		       MT_DFS_GP_INTERVAL);
+	mt76_wr(dev, MT_INT_TIMER_EN, 0);
+
+	mt76x02_init_beacon_config(dev);
+}
+EXPORT_SYMBOL_GPL(mt76x02e_init_beacon_config);
+
 static int
 mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_sw_queue *q,
 		      int idx, int n_desc)
@@ -230,8 +245,6 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
 		return -ENOMEM;
 
 	tasklet_init(&dev->tx_tasklet, mt76x02_tx_tasklet, (unsigned long) dev);
-	tasklet_init(&dev->pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
-		     (unsigned long)dev);
 
 	kfifo_init(&dev->txstatus_fifo, status_fifo, fifo_size);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index 98e647c8c7c7..2073f30667c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -31,4 +31,5 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			    u32 *tx_info);
 void mt76x02u_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
 			      struct mt76_queue_entry *e);
+void mt76x02u_init_beacon_config(struct mt76x02_dev *dev);
 #endif /* __MT76x02_USB_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 8ab63255ba6f..d4393fc8097d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -104,3 +104,9 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	return mt76x02u_skb_dma_info(skb, WLAN_PORT, flags);
 }
 EXPORT_SYMBOL_GPL(mt76x02u_tx_prepare_skb);
+
+void mt76x02u_init_beacon_config(struct mt76x02_dev *dev)
+{
+	mt76x02_init_beacon_config(dev);
+}
+EXPORT_SYMBOL_GPL(mt76x02u_init_beacon_config);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index b14a55737829..39748c67b377 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -635,68 +635,6 @@ void mt76x02_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta,
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_ps);
 
-const u16 mt76x02_beacon_offsets[16] = {
-	/* 1024 byte per beacon */
-	0xc000,
-	0xc400,
-	0xc800,
-	0xcc00,
-	0xd000,
-	0xd400,
-	0xd800,
-	0xdc00,
-	/* BSS idx 8-15 not used for beacons */
-	0xc000,
-	0xc000,
-	0xc000,
-	0xc000,
-	0xc000,
-	0xc000,
-	0xc000,
-	0xc000,
-};
-
-static void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
-{
-	u16 val, base = MT_BEACON_BASE;
-	u32 regs[4] = {};
-	int i;
-
-	for (i = 0; i < 16; i++) {
-		val = mt76x02_beacon_offsets[i] - base;
-		regs[i / 4] |= (val / 64) << (8 * (i % 4));
-	}
-
-	for (i = 0; i < 4; i++)
-		mt76_wr(dev, MT_BCN_OFFSET(i), regs[i]);
-}
-
-void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
-{
-	int i;
-
-	if (mt76_is_mmio(dev)) {
-		/* Fire a pre-TBTT interrupt 8 ms before TBTT */
-		mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
-			       8 << 4);
-		mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
-			       MT_DFS_GP_INTERVAL);
-		mt76_wr(dev, MT_INT_TIMER_EN, 0);
-	}
-
-	mt76_clear(dev, MT_BEACON_TIME_CFG, (MT_BEACON_TIME_CFG_TIMER_EN |
-					     MT_BEACON_TIME_CFG_TBTT_EN |
-					     MT_BEACON_TIME_CFG_BEACON_TX));
-	mt76_set(dev, MT_BEACON_TIME_CFG, MT_BEACON_TIME_CFG_SYNC_MODE);
-	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xffff);
-
-	for (i = 0; i < 8; i++)
-		mt76x02_mac_set_beacon(dev, i, NULL);
-
-	mt76x02_set_beacon_offsets(dev);
-}
-EXPORT_SYMBOL_GPL(mt76x02_init_beacon_config);
-
 void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_bss_conf *info,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index d3927a13e92e..9e88a8cec9e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -120,7 +120,7 @@ int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 	mt76_clear(dev, MT_FCE_L2_STUFF, MT_FCE_L2_STUFF_WR_MPDU_LEN_EN);
 
 	mt76x02_mac_setaddr(dev, macaddr);
-	mt76x02_init_beacon_config(dev);
+	mt76x02e_init_beacon_config(dev);
 	if (!hard)
 		return 0;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 1da90e58d942..35bdf5ffae00 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -183,7 +183,7 @@ int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 			mt76x02_mac_shared_key_setup(dev, i, k, NULL);
 	}
 
-	mt76x02_init_beacon_config(dev);
+	mt76x02u_init_beacon_config(dev);
 
 	mt76_rmw(dev, MT_US_CYC_CFG, MT_US_CYC_CNT, 0x1e);
 	mt76_wr(dev, MT_TXOP_CTRL_CFG, 0x583f);
-- 
2.20.1


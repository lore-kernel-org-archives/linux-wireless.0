Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbeIDTIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:08:24 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 21/22] mt76: unify {insert/remove}_hdr_pad
Date: Tue,  4 Sep 2018 16:41:14 +0200
Message-Id: <1536072075-6990-22-git-send-email-sgruszka@redhat.com> (sfid-20180904_164316_975757_1E898939)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge insert/remove _hdr_pad from mt76x0 and mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  4 ---
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  5 +--
 drivers/net/wireless/mediatek/mt76/mt76x0/util.c   | 42 ----------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 29 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  1 -
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 15 ++------
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |  3 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  | 16 ---------
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  |  3 +-
 11 files changed, 41 insertions(+), 81 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/util.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
index 2f1721263aa5..a4a446921d2f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
@@ -2,6 +2,6 @@ obj-$(CONFIG_MT76x0U)    += mt76x0.o
 
 mt76x0-objs	= \
 	usb.o init.o main.o mcu.o trace.o dma.o eeprom.o phy.o \
-	mac.o util.o debugfs.o tx.o
+	mac.o debugfs.o tx.o
 # ccflags-y := -DDEBUG
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 7fbf379064f1..8510f120a121 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -245,10 +245,6 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 void mt76x0_tx_status(struct mt76x0_dev *dev, struct sk_buff *skb);
 void mt76x0_tx_stat(struct work_struct *work);
 
-/* util */
-void mt76x0_remove_hdr_pad(struct sk_buff *skb);
-int mt76x0_insert_hdr_pad(struct sk_buff *skb);
-
 int mt76x0_dma_init(struct mt76x0_dev *dev);
 void mt76x0_dma_cleanup(struct mt76x0_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 35db38523e3b..92d06cca0266 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -14,6 +14,7 @@
 
 #include "mt76x0.h"
 #include "trace.h"
+#include "../mt76x02_util.h"
 
 /* Take mac80211 Q id from the skb and translate it to hardware Q id */
 static u8 skb2q(struct sk_buff *skb)
@@ -35,7 +36,7 @@ static void mt76x0_tx_skb_remove_dma_overhead(struct sk_buff *skb,
 
 	skb_pull(skb, sizeof(struct mt76x02_txwi) + 4);
 	if (ieee80211_get_hdrlen_from_skb(skb) % 4)
-		mt76x0_remove_hdr_pad(skb);
+		mt76x02_remove_hdr_pad(skb, 2);
 
 	skb_trim(skb, pkt_len);
 }
@@ -146,7 +147,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	BUILD_BUG_ON(ARRAY_SIZE(info->status.status_driver_data) < 1);
 	info->status.status_driver_data[0] = (void *)(unsigned long)pkt_len;
 
-	mt76x0_insert_hdr_pad(skb);
+	mt76x02_insert_hdr_pad(skb);
 
 	if (sta) {
 		msta = (struct mt76x02_sta *) sta->drv_priv;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/util.c b/drivers/net/wireless/mediatek/mt76/mt76x0/util.c
deleted file mode 100644
index 7856dd760419..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/util.c
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
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
-#include "mt76x0.h"
-
-void mt76x0_remove_hdr_pad(struct sk_buff *skb)
-{
-	int len = ieee80211_get_hdrlen_from_skb(skb);
-
-	memmove(skb->data + 2, skb->data, len);
-	skb_pull(skb, 2);
-}
-
-int mt76x0_insert_hdr_pad(struct sk_buff *skb)
-{
-	int len = ieee80211_get_hdrlen_from_skb(skb);
-	int ret;
-
-	if (len % 4 == 0)
-		return 0;
-
-	ret = skb_cow(skb, 2);
-	if (ret)
-		return ret;
-
-	skb_push(skb, 2);
-	memmove(skb->data, skb->data + 2, len);
-
-	skb->data[len] = 0;
-	skb->data[len + 1] = 0;
-	return 0;
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index e98bd874b4d0..a32ce164fb76 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -348,4 +348,33 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_rate_tbl_update);
 
+int mt76x02_insert_hdr_pad(struct sk_buff *skb)
+{
+	int len = ieee80211_get_hdrlen_from_skb(skb);
+
+	if (len % 4 == 0)
+		return 0;
+
+	skb_push(skb, 2);
+	memmove(skb->data, skb->data + 2, len);
+
+	skb->data[len] = 0;
+	skb->data[len + 1] = 0;
+	return 2;
+}
+EXPORT_SYMBOL_GPL(mt76x02_insert_hdr_pad);
+
+void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len)
+{
+	int hdrlen;
+
+	if (!len)
+		return;
+
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	memmove(skb->data + len, skb->data, hdrlen);
+	skb_pull(skb, len);
+}
+EXPORT_SYMBOL_GPL(mt76x02_remove_hdr_pad);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index cff3c8f6393c..953c4bea4051 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -43,4 +43,6 @@ int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta);
+int mt76x02_insert_hdr_pad(struct sk_buff *skb);
+void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index b3a936edfb30..f275411f0e3d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -239,7 +239,6 @@ s8 mt76x2_tx_get_max_txpwr_adj(struct mt76_dev *dev,
 s8 mt76x2_tx_get_txpwr_adj(struct mt76x2_dev *dev, s8 txpwr, s8 max_txpwr_adj);
 void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr);
 
-int mt76x2_insert_hdr_pad(struct sk_buff *skb);
 
 void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable);
 void mt76x2_init_txpower(struct mt76x2_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index 039fce3d1daa..dbc0e3ef1258 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -16,6 +16,7 @@
  */
 
 #include "mt76x2.h"
+#include "mt76x02_util.h"
 
 void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
 {
@@ -146,18 +147,6 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
 }
 EXPORT_SYMBOL_GPL(mt76x2_mac_write_txwi);
 
-static void mt76x2_remove_hdr_pad(struct sk_buff *skb, int len)
-{
-	int hdrlen;
-
-	if (!len)
-		return;
-
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	memmove(skb->data + len, skb->data, hdrlen);
-	skb_pull(skb, len);
-}
-
 int mt76x2_mac_get_rssi(struct mt76x2_dev *dev, s8 rssi, int chain)
 {
 	struct mt76x2_rx_freq_cal *cal = &dev->cal.rx;
@@ -254,7 +243,7 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 		}
 	}
 
-	mt76x2_remove_hdr_pad(skb, pad_len);
+	mt76x02_remove_hdr_pad(skb, pad_len);
 
 	if ((rxinfo & MT_RXINFO_BA) && !(rxinfo & MT_RXINFO_NULL))
 		status->aggr = true;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
index 5338e8efa606..41bae90e5f6a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
@@ -16,6 +16,7 @@
 
 #include "mt76x2.h"
 #include "mt76x2_dma.h"
+#include "mt76x02_util.h"
 
 struct beacon_bc_data {
 	struct mt76x2_dev *dev;
@@ -38,7 +39,7 @@ int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 
 	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta, skb->len);
 
-	ret = mt76x2_insert_hdr_pad(skb);
+	ret = mt76x02_insert_hdr_pad(skb);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
index 17da4ae1032d..056a21b006df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
@@ -47,22 +47,6 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 }
 EXPORT_SYMBOL_GPL(mt76x2_tx);
 
-int mt76x2_insert_hdr_pad(struct sk_buff *skb)
-{
-	int len = ieee80211_get_hdrlen_from_skb(skb);
-
-	if (len % 4 == 0)
-		return 0;
-
-	skb_push(skb, 2);
-	memmove(skb->data, skb->data + 2, len);
-
-	skb->data[len] = 0;
-	skb->data[len + 1] = 0;
-	return 2;
-}
-EXPORT_SYMBOL_GPL(mt76x2_insert_hdr_pad);
-
 s8 mt76x2_tx_get_max_txpwr_adj(struct mt76_dev *mdev,
 			       const struct ieee80211_tx_rate *rate)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
index 35cce40c7c90..ed62d6243bb9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
@@ -16,6 +16,7 @@
 
 #include "mt76x2u.h"
 #include "dma.h"
+#include "mt76x02_util.h"
 
 static void mt76x2u_remove_dma_hdr(struct sk_buff *skb)
 {
@@ -90,7 +91,7 @@ int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	if (err < 0)
 		return -ENOMEM;
 
-	mt76x2_insert_hdr_pad(skb);
+	mt76x02_insert_hdr_pad(skb);
 
 	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
 	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
-- 
2.7.5

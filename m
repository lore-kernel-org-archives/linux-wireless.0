Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44059 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727474AbeIVRjI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 13:39:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id v16-v6so15221480wro.11
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 04:45:50 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/9] mt76: add mt76x02_phy_set_txpower utility routine
Date: Sat, 22 Sep 2018 13:45:30 +0200
Message-Id: <20180922114537.24004-3-lorenzo.bianconi@redhat.com> (sfid-20180922_134902_890651_EB58522D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mt76x02_phy_set_txpower utility routine in mt76x02_phy.c
in order to be reused in mt76x0 tx power management code.
Moreover move following routines in mt76x02-lib module:
- mt76x02_tx_power_mask
- mt76x02_get_max_rate_power
- mt76x02_limit_rate_power
- mt76x02_add_rate_power_offset

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  | 97 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  | 27 ++++++
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    | 12 ---
 .../wireless/mediatek/mt76/mt76x2_eeprom.h    |  1 -
 .../mediatek/mt76/mt76x2_init_common.c        |  3 +-
 .../mediatek/mt76/mt76x2_phy_common.c         | 60 ++----------
 7 files changed, 133 insertions(+), 69 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index dbe0ec020391..1fc7450650ee 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -16,7 +16,7 @@ CFLAGS_trace.o := -I$(src)
 CFLAGS_usb_trace.o := -I$(src)
 
 mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o \
-		 mt76x02_eeprom.o
+		 mt76x02_eeprom.o mt76x02_phy.o
 
 mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
new file mode 100644
index 000000000000..969854b69981
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -0,0 +1,97 @@
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
+#include "mt76x02_phy.h"
+
+static u32
+mt76x02_tx_power_mask(u8 v1, u8 v2, u8 v3, u8 v4)
+{
+	u32 val = 0;
+
+	val |= (v1 & (BIT(6) - 1)) << 0;
+	val |= (v2 & (BIT(6) - 1)) << 8;
+	val |= (v3 & (BIT(6) - 1)) << 16;
+	val |= (v4 & (BIT(6) - 1)) << 24;
+	return val;
+}
+
+int mt76x02_get_max_rate_power(struct mt76_rate_power *r)
+{
+	s8 ret = 0;
+	int i;
+
+	for (i = 0; i < sizeof(r->all); i++)
+		ret = max(ret, r->all[i]);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mt76x02_get_max_rate_power);
+
+void mt76x02_limit_rate_power(struct mt76_rate_power *r, int limit)
+{
+	int i;
+
+	for (i = 0; i < sizeof(r->all); i++)
+		if (r->all[i] > limit)
+			r->all[i] = limit;
+}
+EXPORT_SYMBOL_GPL(mt76x02_limit_rate_power);
+
+void mt76x02_add_rate_power_offset(struct mt76_rate_power *r, int offset)
+{
+	int i;
+
+	for (i = 0; i < sizeof(r->all); i++)
+		r->all[i] += offset;
+}
+EXPORT_SYMBOL_GPL(mt76x02_add_rate_power_offset);
+
+void mt76x02_phy_set_txpower(struct mt76_dev *dev, int txp_0, int txp_1)
+{
+	struct mt76_rate_power *t = &dev->rate_power;
+
+	__mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_0,
+			 txp_0);
+	__mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_1,
+			 txp_1);
+
+	__mt76_wr(dev, MT_TX_PWR_CFG_0,
+		  mt76x02_tx_power_mask(t->cck[0], t->cck[2], t->ofdm[0],
+					t->ofdm[2]));
+	__mt76_wr(dev, MT_TX_PWR_CFG_1,
+		  mt76x02_tx_power_mask(t->ofdm[4], t->ofdm[6], t->ht[0],
+					t->ht[2]));
+	__mt76_wr(dev, MT_TX_PWR_CFG_2,
+		  mt76x02_tx_power_mask(t->ht[4], t->ht[6], t->ht[8],
+					t->ht[10]));
+	__mt76_wr(dev, MT_TX_PWR_CFG_3,
+		  mt76x02_tx_power_mask(t->ht[12], t->ht[14], t->stbc[0],
+					t->stbc[2]));
+	__mt76_wr(dev, MT_TX_PWR_CFG_4,
+		  mt76x02_tx_power_mask(t->stbc[4], t->stbc[6], 0, 0));
+	__mt76_wr(dev, MT_TX_PWR_CFG_7,
+		  mt76x02_tx_power_mask(t->ofdm[7], t->vht[8], t->ht[7],
+					t->vht[9]));
+	__mt76_wr(dev, MT_TX_PWR_CFG_8,
+		  mt76x02_tx_power_mask(t->ht[14], 0, t->vht[8], t->vht[9]));
+	__mt76_wr(dev, MT_TX_PWR_CFG_9,
+		  mt76x02_tx_power_mask(t->ht[7], 0, t->stbc[8], t->stbc[9]));
+}
+EXPORT_SYMBOL_GPL(mt76x02_phy_set_txpower);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
new file mode 100644
index 000000000000..25567f9f5070
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
@@ -0,0 +1,27 @@
+/*
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
+#ifndef __MT76x02_PHY_H
+#define __MT76x02_PHY_H
+
+#include "mt76x02_regs.h"
+
+void mt76x02_add_rate_power_offset(struct mt76_rate_power *r, int offset);
+void mt76x02_phy_set_txpower(struct mt76_dev *dev, int txp_0, int txp_2);
+void mt76x02_limit_rate_power(struct mt76_rate_power *r, int limit);
+int mt76x02_get_max_rate_power(struct mt76_rate_power *r);
+
+#endif /* __MT76x02_PHY_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index bb31aecca77a..4e287d5e2137 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -381,18 +381,6 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 }
 EXPORT_SYMBOL_GPL(mt76x2_get_rate_power);
 
-int mt76x2_get_max_rate_power(struct mt76_rate_power *r)
-{
-	int i;
-	s8 ret = 0;
-
-	for (i = 0; i < sizeof(r->all); i++)
-		ret = max(ret, r->all[i]);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(mt76x2_get_max_rate_power);
-
 static void
 mt76x2_get_power_info_2g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
 		         struct ieee80211_channel *chan, int chain, int offset)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
index 650f9564f0f4..c2e99bbeac3b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
@@ -53,7 +53,6 @@ struct mt76x2_temp_comp {
 
 void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 			   struct ieee80211_channel *chan);
-int mt76x2_get_max_rate_power(struct mt76_rate_power *r);
 void mt76x2_get_power_info(struct mt76x2_dev *dev,
 			   struct mt76x2_tx_power_info *t,
 			   struct ieee80211_channel *chan);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
index 31de3365cdb8..d13da7ad86ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
@@ -17,6 +17,7 @@
 
 #include "mt76x2.h"
 #include "mt76x2_eeprom.h"
+#include "mt76x02_phy.h"
 
 static void
 mt76x2_set_wlan_state(struct mt76x2_dev *dev, bool enable)
@@ -214,7 +215,7 @@ void mt76x2_init_txpower(struct mt76x2_dev *dev,
 
 		mt76x2_get_rate_power(dev, &t, chan);
 
-		chan->max_power = mt76x2_get_max_rate_power(&t) +
+		chan->max_power = mt76x02_get_max_rate_power(&t) +
 				  target_power;
 		chan->max_power /= 2;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
index e6baad9f4316..dd32e756d8b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
@@ -18,6 +18,7 @@
 #include "mt76x2.h"
 #include "mt76x2_eeprom.h"
 #include "mt76x2_mcu.h"
+#include "mt76x02_phy.h"
 
 static void
 mt76x2_adjust_high_lna_gain(struct mt76x2_dev *dev, int reg, s8 offset)
@@ -124,37 +125,6 @@ void mt76x2_phy_set_txpower_regs(struct mt76x2_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_set_txpower_regs);
 
-static void
-mt76x2_limit_rate_power(struct mt76_rate_power *r, int limit)
-{
-	int i;
-
-	for (i = 0; i < sizeof(r->all); i++)
-		if (r->all[i] > limit)
-			r->all[i] = limit;
-}
-
-static u32
-mt76x2_tx_power_mask(u8 v1, u8 v2, u8 v3, u8 v4)
-{
-	u32 val = 0;
-
-	val |= (v1 & (BIT(6) - 1)) << 0;
-	val |= (v2 & (BIT(6) - 1)) << 8;
-	val |= (v3 & (BIT(6) - 1)) << 16;
-	val |= (v4 & (BIT(6) - 1)) << 24;
-	return val;
-}
-
-static void
-mt76x2_add_rate_power_offset(struct mt76_rate_power *r, int offset)
-{
-	int i;
-
-	for (i = 0; i < sizeof(r->all); i++)
-		r->all[i] += offset;
-}
-
 static int
 mt76x2_get_min_rate_power(struct mt76_rate_power *r)
 {
@@ -191,9 +161,9 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 		delta = txp.delta_bw80;
 
 	mt76x2_get_rate_power(dev, &t, chan);
-	mt76x2_add_rate_power_offset(&t, txp.chain[0].target_power);
-	mt76x2_limit_rate_power(&t, dev->mt76.txpower_conf);
-	dev->mt76.txpower_cur = mt76x2_get_max_rate_power(&t);
+	mt76x02_add_rate_power_offset(&t, txp.chain[0].target_power);
+	mt76x02_limit_rate_power(&t, dev->mt76.txpower_conf);
+	dev->mt76.txpower_cur = mt76x02_get_max_rate_power(&t);
 
 	base_power = mt76x2_get_min_rate_power(&t);
 	delta += base_power - txp.chain[0].target_power;
@@ -211,31 +181,13 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 		txp_1 = 0x2f;
 	}
 
-	mt76x2_add_rate_power_offset(&t, -base_power);
+	mt76x02_add_rate_power_offset(&t, -base_power);
 	dev->target_power = txp.chain[0].target_power;
 	dev->target_power_delta[0] = txp_0 - txp.chain[0].target_power;
 	dev->target_power_delta[1] = txp_1 - txp.chain[0].target_power;
 	dev->mt76.rate_power = t;
 
-	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_0, txp_0);
-	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_1, txp_1);
-
-	mt76_wr(dev, MT_TX_PWR_CFG_0,
-		mt76x2_tx_power_mask(t.cck[0], t.cck[2], t.ofdm[0], t.ofdm[2]));
-	mt76_wr(dev, MT_TX_PWR_CFG_1,
-		mt76x2_tx_power_mask(t.ofdm[4], t.ofdm[6], t.ht[0], t.ht[2]));
-	mt76_wr(dev, MT_TX_PWR_CFG_2,
-		mt76x2_tx_power_mask(t.ht[4], t.ht[6], t.ht[8], t.ht[10]));
-	mt76_wr(dev, MT_TX_PWR_CFG_3,
-		mt76x2_tx_power_mask(t.ht[12], t.ht[14], t.stbc[0], t.stbc[2]));
-	mt76_wr(dev, MT_TX_PWR_CFG_4,
-		mt76x2_tx_power_mask(t.stbc[4], t.stbc[6], 0, 0));
-	mt76_wr(dev, MT_TX_PWR_CFG_7,
-		mt76x2_tx_power_mask(t.ofdm[7], t.vht[8], t.ht[7], t.vht[9]));
-	mt76_wr(dev, MT_TX_PWR_CFG_8,
-		mt76x2_tx_power_mask(t.ht[14], 0, t.vht[8], t.vht[9]));
-	mt76_wr(dev, MT_TX_PWR_CFG_9,
-		mt76x2_tx_power_mask(t.ht[7], 0, t.stbc[8], t.stbc[9]));
+	mt76x02_phy_set_txpower(&dev->mt76, txp_0, txp_1);
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_set_txpower);
 
-- 
2.18.0

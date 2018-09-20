Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40265 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387445AbeITOzC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207-v6so9998867wme.5
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:33 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 07/20] mt76: move mt76x2_get_efuse_data in mt76x02-lib module
Date: Thu, 20 Sep 2018 11:11:54 +0200
Message-Id: <5403d92a53303ed70c8257342a02e6d4d76804d5.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_111253_591428_AD73AB30)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x2_efuse_read and mt76x2_get_efuse_data in mt76x02_eeprom.c
in order to be reused in mt76x0 driver for eeprom parsing

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |  3 +-
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 59 +++------------
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  5 --
 .../wireless/mediatek/mt76/mt76x02_eeprom.c   | 72 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  8 +++
 .../wireless/mediatek/mt76/mt76x2_eeprom.c    | 49 +------------
 6 files changed, 95 insertions(+), 101 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 4d25b5c3b70b..dbe0ec020391 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -15,7 +15,8 @@ mt76-usb-y := usb.o usb_trace.o usb_mcu.o
 CFLAGS_trace.o := -I$(src)
 CFLAGS_usb_trace.o := -I$(src)
 
-mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o
+mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o \
+		 mt76x02_eeprom.o
 
 mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index a93da6c5ce59..43239a1cb1e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -21,41 +21,6 @@
 #include "mt76x0.h"
 #include "eeprom.h"
 
-static int
-mt76x0_efuse_read(struct mt76x0_dev *dev, u16 addr, u8 *data,
-		   enum mt76x0_eeprom_access_modes mode)
-{
-	u32 val;
-	int i;
-
-	val = mt76_rr(dev, MT_EFUSE_CTRL);
-	val &= ~(MT_EFUSE_CTRL_AIN |
-		 MT_EFUSE_CTRL_MODE);
-	val |= FIELD_PREP(MT_EFUSE_CTRL_AIN, addr & ~0xf) |
-	       FIELD_PREP(MT_EFUSE_CTRL_MODE, mode) |
-	       MT_EFUSE_CTRL_KICK;
-	mt76_wr(dev, MT_EFUSE_CTRL, val);
-
-	if (!mt76_poll(dev, MT_EFUSE_CTRL, MT_EFUSE_CTRL_KICK, 0, 1000))
-		return -ETIMEDOUT;
-
-	val = mt76_rr(dev, MT_EFUSE_CTRL);
-	if ((val & MT_EFUSE_CTRL_AOUT) == MT_EFUSE_CTRL_AOUT) {
-		/* Parts of eeprom not in the usage map (0x80-0xc0,0xf0)
-		 * will not return valid data but it's ok.
-		 */
-		memset(data, 0xff, 16);
-		return 0;
-	}
-
-	for (i = 0; i < 4; i++) {
-		val = mt76_rr(dev, MT_EFUSE_DATA(i));
-		put_unaligned_le32(val, data + 4 * i);
-	}
-
-	return 0;
-}
-
 #define MT_MAP_READS	DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16)
 static int
 mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
@@ -64,12 +29,10 @@ mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
 	int ret, i;
 	u32 start = 0, end = 0, cnt_free;
 
-	for (i = 0; i < MT_MAP_READS; i++) {
-		ret = mt76x0_efuse_read(dev, MT_EE_USAGE_MAP_START + i * 16,
-					 data + i * 16, MT_EE_PHYSICAL_READ);
-		if (ret)
-			return ret;
-	}
+	ret = mt76x02_get_efuse_data(&dev->mt76, MT_EE_USAGE_MAP_START,
+				     data, sizeof(data), MT_EE_PHYSICAL_READ);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < MT_EFUSE_USAGE_MAP_SIZE; i++)
 		if (!data[i]) {
@@ -80,7 +43,8 @@ mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
 	cnt_free = end - start + 1;
 
 	if (MT_EFUSE_USAGE_MAP_SIZE - cnt_free < 5) {
-		dev_err(dev->mt76.dev, "Error: your device needs default EEPROM file and this driver doesn't support it!\n");
+		dev_err(dev->mt76.dev,
+			"driver does not support default EEPROM\n");
 		return -EINVAL;
 	}
 
@@ -360,7 +324,7 @@ int
 mt76x0_eeprom_init(struct mt76x0_dev *dev)
 {
 	u8 *eeprom;
-	int i, ret;
+	int ret;
 
 	ret = mt76x0_efuse_physical_size_check(dev);
 	if (ret)
@@ -374,11 +338,10 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 	if (!eeprom)
 		return -ENOMEM;
 
-	for (i = 0; i + 16 <= MT76X0_EEPROM_SIZE; i += 16) {
-		ret = mt76x0_efuse_read(dev, i, eeprom + i, MT_EE_READ);
-		if (ret)
-			goto out;
-	}
+	ret = mt76x02_get_efuse_data(&dev->mt76, 0, eeprom,
+				     MT76X0_EEPROM_SIZE, MT_EE_READ);
+	if (ret)
+		goto out;
 
 	if (eeprom[MT_EE_VERSION + 1] > MT76X0U_EE_MAX_VER)
 		dev_warn(dev->mt76.dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index 1da90f056442..1051e3216614 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -23,11 +23,6 @@ struct mt76x0_dev;
 #define MT76X0U_EE_MAX_VER		0x0c
 #define MT76X0_EEPROM_SIZE		512
 
-enum mt76x0_eeprom_access_modes {
-	MT_EE_READ = 0,
-	MT_EE_PHYSICAL_READ = 1,
-};
-
 struct reg_channel_bounds {
 	u8 start;
 	u8 num;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
new file mode 100644
index 000000000000..21fe7eb0652d
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
@@ -0,0 +1,72 @@
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
+#include <asm/unaligned.h>
+
+#include "mt76.h"
+#include "mt76x02_eeprom.h"
+#include "mt76x02_regs.h"
+
+static int
+mt76x02_efuse_read(struct mt76_dev *dev, u16 addr, u8 *data,
+		   enum mt76x02_eeprom_modes mode)
+{
+	u32 val;
+	int i;
+
+	val = __mt76_rr(dev, MT_EFUSE_CTRL);
+	val &= ~(MT_EFUSE_CTRL_AIN |
+		 MT_EFUSE_CTRL_MODE);
+	val |= FIELD_PREP(MT_EFUSE_CTRL_AIN, addr & ~0xf);
+	val |= FIELD_PREP(MT_EFUSE_CTRL_MODE, mode);
+	val |= MT_EFUSE_CTRL_KICK;
+	__mt76_wr(dev, MT_EFUSE_CTRL, val);
+
+	if (!__mt76_poll_msec(dev, MT_EFUSE_CTRL, MT_EFUSE_CTRL_KICK,
+			      0, 1000))
+		return -ETIMEDOUT;
+
+	udelay(2);
+
+	val = __mt76_rr(dev, MT_EFUSE_CTRL);
+	if ((val & MT_EFUSE_CTRL_AOUT) == MT_EFUSE_CTRL_AOUT) {
+		memset(data, 0xff, 16);
+		return 0;
+	}
+
+	for (i = 0; i < 4; i++) {
+		val = __mt76_rr(dev, MT_EFUSE_DATA(i));
+		put_unaligned_le32(val, data + 4 * i);
+	}
+
+	return 0;
+}
+
+int mt76x02_get_efuse_data(struct mt76_dev *dev, u16 base, void *buf,
+			   int len, enum mt76x02_eeprom_modes mode)
+{
+	int ret, i;
+
+	for (i = 0; i + 16 <= len; i += 16) {
+		ret = mt76x02_efuse_read(dev, base + i, buf + i, mode);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_get_efuse_data);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index 85dd4f9b97a5..852ea9b51e97 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -121,6 +121,11 @@ enum mt76x02_eeprom_field {
 #define MT_EFUSE_USAGE_MAP_SIZE			(MT_EE_USAGE_MAP_END - \
 						 MT_EE_USAGE_MAP_START + 1)
 
+enum mt76x02_eeprom_modes {
+	MT_EE_READ,
+	MT_EE_PHYSICAL_READ,
+};
+
 static inline bool mt76x02_field_valid(u8 val)
 {
 	return val != 0 && val != 0xff;
@@ -146,4 +151,7 @@ mt76x02_eeprom_get(struct mt76_dev *dev,
 	return get_unaligned_le16(dev->eeprom.data + field);
 }
 
+int mt76x02_get_efuse_data(struct mt76_dev *dev, u16 base, void *buf,
+			   int len, enum mt76x02_eeprom_modes mode);
+
 #endif /* __MT76x02_EEPROM_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index aea8033f13ce..333faa44d7cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -59,52 +59,6 @@ void mt76x2_eeprom_parse_hw_cap(struct mt76x2_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x2_eeprom_parse_hw_cap);
 
-static int
-mt76x2_efuse_read(struct mt76x2_dev *dev, u16 addr, u8 *data)
-{
-	u32 val;
-	int i;
-
-	val = mt76_rr(dev, MT_EFUSE_CTRL);
-	val &= ~(MT_EFUSE_CTRL_AIN |
-		 MT_EFUSE_CTRL_MODE);
-	val |= FIELD_PREP(MT_EFUSE_CTRL_AIN, addr & ~0xf);
-	val |= MT_EFUSE_CTRL_KICK;
-	mt76_wr(dev, MT_EFUSE_CTRL, val);
-
-	if (!mt76_poll(dev, MT_EFUSE_CTRL, MT_EFUSE_CTRL_KICK, 0, 1000))
-		return -ETIMEDOUT;
-
-	udelay(2);
-
-	val = mt76_rr(dev, MT_EFUSE_CTRL);
-	if ((val & MT_EFUSE_CTRL_AOUT) == MT_EFUSE_CTRL_AOUT) {
-		memset(data, 0xff, 16);
-		return 0;
-	}
-
-	for (i = 0; i < 4; i++) {
-		val = mt76_rr(dev, MT_EFUSE_DATA(i));
-		put_unaligned_le32(val, data + 4 * i);
-	}
-
-	return 0;
-}
-
-static int
-mt76x2_get_efuse_data(struct mt76x2_dev *dev, void *buf, int len)
-{
-	int ret, i;
-
-	for (i = 0; i + 16 <= len; i += 16) {
-		ret = mt76x2_efuse_read(dev, i, buf + i);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 static bool
 mt76x2_has_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
 {
@@ -241,7 +195,8 @@ mt76x2_eeprom_load(struct mt76x2_dev *dev)
 
 	efuse = dev->mt76.otp.data;
 
-	if (mt76x2_get_efuse_data(dev, efuse, MT7662_EEPROM_SIZE))
+	if (mt76x02_get_efuse_data(&dev->mt76, 0, efuse,
+				   MT7662_EEPROM_SIZE, MT_EE_READ))
 		goto out;
 
 	if (found) {
-- 
2.17.1

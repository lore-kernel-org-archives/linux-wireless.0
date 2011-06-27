Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42178 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572Ab1F0M6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 08:58:04 -0400
Received: by fxd18 with SMTP id 18so1789080fxd.11
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 05:58:02 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/5] b43: HT-PHY: prepare place for HT-PHY tables
Date: Mon, 27 Jun 2011 14:58:50 +0200
Message-Id: <1309179534-8081-1-git-send-email-zajec5@gmail.com> (sfid-20110627_150219_490459_FC000F84)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They are big arrays uploaded to the hardware on init, calibration, etc.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Makefile        |    1 +
 drivers/net/wireless/b43/tables_phy_ht.c |  162 ++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/tables_phy_ht.h |   20 ++++
 3 files changed, 183 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/b43/tables_phy_ht.c
 create mode 100644 drivers/net/wireless/b43/tables_phy_ht.h

diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
index 900dc9c..1b25604 100644
--- a/drivers/net/wireless/b43/Makefile
+++ b/drivers/net/wireless/b43/Makefile
@@ -11,6 +11,7 @@ b43-$(CONFIG_B43_PHY_N)		+= phy_n.o
 b43-$(CONFIG_B43_PHY_LP)	+= phy_lp.o
 b43-$(CONFIG_B43_PHY_LP)	+= tables_lpphy.o
 b43-$(CONFIG_B43_PHY_HT)	+= phy_ht.o
+b43-$(CONFIG_B43_PHY_HT)	+= tables_phy_ht.o
 b43-$(CONFIG_B43_PHY_HT)	+= radio_2059.o
 b43-y				+= sysfs.o
 b43-y				+= xmit.o
diff --git a/drivers/net/wireless/b43/tables_phy_ht.c b/drivers/net/wireless/b43/tables_phy_ht.c
new file mode 100644
index 0000000..df08be2
--- /dev/null
+++ b/drivers/net/wireless/b43/tables_phy_ht.c
@@ -0,0 +1,162 @@
+/*
+
+  Broadcom B43 wireless driver
+  IEEE 802.11n HT-PHY data tables
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; see the file COPYING.  If not, write to
+  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
+  Boston, MA 02110-1301, USA.
+
+*/
+
+#include "b43.h"
+#include "tables_phy_ht.h"
+#include "phy_common.h"
+#include "phy_ht.h"
+
+u32 b43_httab_read(struct b43_wldev *dev, u32 offset)
+{
+	u32 type, value;
+
+	type = offset & B43_HTTAB_TYPEMASK;
+	offset &= ~B43_HTTAB_TYPEMASK;
+	B43_WARN_ON(offset > 0xFFFF);
+
+	switch (type) {
+	case B43_HTTAB_8BIT:
+		b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
+		value = b43_phy_read(dev, B43_PHY_HT_TABLE_DATALO) & 0xFF;
+		break;
+	case B43_HTTAB_16BIT:
+		b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
+		value = b43_phy_read(dev, B43_PHY_HT_TABLE_DATALO);
+		break;
+	case B43_HTTAB_32BIT:
+		b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
+		value = b43_phy_read(dev, B43_PHY_HT_TABLE_DATAHI);
+		value <<= 16;
+		value |= b43_phy_read(dev, B43_PHY_HT_TABLE_DATALO);
+		break;
+	default:
+		B43_WARN_ON(1);
+		value = 0;
+	}
+
+	return value;
+}
+
+void b43_httab_read_bulk(struct b43_wldev *dev, u32 offset,
+			 unsigned int nr_elements, void *_data)
+{
+	u32 type;
+	u8 *data = _data;
+	unsigned int i;
+
+	type = offset & B43_HTTAB_TYPEMASK;
+	offset &= ~B43_HTTAB_TYPEMASK;
+	B43_WARN_ON(offset > 0xFFFF);
+
+	b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
+
+	for (i = 0; i < nr_elements; i++) {
+		switch (type) {
+		case B43_HTTAB_8BIT:
+			*data = b43_phy_read(dev, B43_PHY_HT_TABLE_DATALO) & 0xFF;
+			data++;
+			break;
+		case B43_HTTAB_16BIT:
+			*((u16 *)data) = b43_phy_read(dev, B43_PHY_HT_TABLE_DATALO);
+			data += 2;
+			break;
+		case B43_HTTAB_32BIT:
+			*((u32 *)data) = b43_phy_read(dev, B43_PHY_HT_TABLE_DATAHI);
+			*((u32 *)data) <<= 16;
+			*((u32 *)data) |= b43_phy_read(dev, B43_PHY_HT_TABLE_DATALO);
+			data += 4;
+			break;
+		default:
+			B43_WARN_ON(1);
+		}
+	}
+}
+
+void b43_httab_write(struct b43_wldev *dev, u32 offset, u32 value)
+{
+	u32 type;
+
+	type = offset & B43_HTTAB_TYPEMASK;
+	offset &= 0xFFFF;
+
+	switch (type) {
+	case B43_HTTAB_8BIT:
+		B43_WARN_ON(value & ~0xFF);
+		b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
+		b43_phy_write(dev, B43_PHY_HT_TABLE_DATALO, value);
+		break;
+	case B43_HTTAB_16BIT:
+		B43_WARN_ON(value & ~0xFFFF);
+		b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
+		b43_phy_write(dev, B43_PHY_HT_TABLE_DATALO, value);
+		break;
+	case B43_HTTAB_32BIT:
+		b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
+		b43_phy_write(dev, B43_PHY_HT_TABLE_DATAHI, value >> 16);
+		b43_phy_write(dev, B43_PHY_HT_TABLE_DATALO, value & 0xFFFF);
+		break;
+	default:
+		B43_WARN_ON(1);
+	}
+
+	return;
+}
+
+void b43_httab_write_bulk(struct b43_wldev *dev, u32 offset,
+			  unsigned int nr_elements, const void *_data)
+{
+	u32 type, value;
+	const u8 *data = _data;
+	unsigned int i;
+
+	type = offset & B43_HTTAB_TYPEMASK;
+	offset &= ~B43_HTTAB_TYPEMASK;
+	B43_WARN_ON(offset > 0xFFFF);
+
+	b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
+
+	for (i = 0; i < nr_elements; i++) {
+		switch (type) {
+		case B43_HTTAB_8BIT:
+			value = *data;
+			data++;
+			B43_WARN_ON(value & ~0xFF);
+			b43_phy_write(dev, B43_PHY_HT_TABLE_DATALO, value);
+			break;
+		case B43_HTTAB_16BIT:
+			value = *((u16 *)data);
+			data += 2;
+			B43_WARN_ON(value & ~0xFFFF);
+			b43_phy_write(dev, B43_PHY_HT_TABLE_DATALO, value);
+			break;
+		case B43_HTTAB_32BIT:
+			value = *((u32 *)data);
+			data += 4;
+			b43_phy_write(dev, B43_PHY_HT_TABLE_DATAHI, value >> 16);
+			b43_phy_write(dev, B43_PHY_HT_TABLE_DATALO,
+					value & 0xFFFF);
+			break;
+		default:
+			B43_WARN_ON(1);
+		}
+	}
+}
diff --git a/drivers/net/wireless/b43/tables_phy_ht.h b/drivers/net/wireless/b43/tables_phy_ht.h
new file mode 100644
index 0000000..6a13614
--- /dev/null
+++ b/drivers/net/wireless/b43/tables_phy_ht.h
@@ -0,0 +1,20 @@
+#ifndef B43_TABLES_PHY_HT_H_
+#define B43_TABLES_PHY_HT_H_
+
+/* The HT-PHY tables. */
+#define B43_HTTAB_TYPEMASK		0xF0000000
+#define B43_HTTAB_8BIT			0x10000000
+#define B43_HTTAB_16BIT			0x20000000
+#define B43_HTTAB_32BIT			0x30000000
+#define B43_HTTAB8(table, offset)	(((table) << 10) | (offset) | B43_HTTAB_8BIT)
+#define B43_HTTAB16(table, offset)	(((table) << 10) | (offset) | B43_HTTAB_16BIT)
+#define B43_HTTAB32(table, offset)	(((table) << 10) | (offset) | B43_HTTAB_32BIT)
+
+u32 b43_httab_read(struct b43_wldev *dev, u32 offset);
+void b43_httab_read_bulk(struct b43_wldev *dev, u32 offset,
+			 unsigned int nr_elements, void *_data);
+void b43_httab_write(struct b43_wldev *dev, u32 offset, u32 value);
+void b43_httab_write_bulk(struct b43_wldev *dev, u32 offset,
+			  unsigned int nr_elements, const void *_data);
+
+#endif /* B43_TABLES_PHY_HT_H_ */
-- 
1.7.1


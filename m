Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39488 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2GYVXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 17:23:53 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1159983wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 14:23:53 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: N-PHY: init 0x2057 radio
Date: Thu, 26 Jul 2012 00:07:39 +0200
Message-Id: <1343254059-4788-3-git-send-email-zajec5@gmail.com> (sfid-20120725_232358_158248_15A4F5C6)
In-Reply-To: <1343254059-4788-1-git-send-email-zajec5@gmail.com>
References: <1343254059-4788-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Makefile     |    1 +
 drivers/net/wireless/b43/phy_n.c      |  142 +++++++++++-
 drivers/net/wireless/b43/radio_2057.c |  141 +++++++++++
 drivers/net/wireless/b43/radio_2057.h |  430 +++++++++++++++++++++++++++++++++
 4 files changed, 712 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/b43/radio_2057.c
 create mode 100644 drivers/net/wireless/b43/radio_2057.h

diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
index 4648bbf..098fe9e 100644
--- a/drivers/net/wireless/b43/Makefile
+++ b/drivers/net/wireless/b43/Makefile
@@ -4,6 +4,7 @@ b43-y				+= tables.o
 b43-$(CONFIG_B43_PHY_N)		+= tables_nphy.o
 b43-$(CONFIG_B43_PHY_N)		+= radio_2055.o
 b43-$(CONFIG_B43_PHY_N)		+= radio_2056.o
+b43-$(CONFIG_B43_PHY_N)		+= radio_2057.o
 b43-y				+= phy_common.o
 b43-y				+= phy_g.o
 b43-y				+= phy_a.o
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 0e75c35..113d5ca 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -32,6 +32,7 @@
 #include "tables_nphy.h"
 #include "radio_2055.h"
 #include "radio_2056.h"
+#include "radio_2057.h"
 #include "main.h"
 
 struct nphy_txgains {
@@ -459,6 +460,136 @@ static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
 }
 
 /**************************************************
+ * Radio 0x2057
+ **************************************************/
+
+/* http://bcm-v4.sipsolutions.net/PHY/radio2057_rcal */
+static u8 b43_radio_2057_rcal(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	u16 tmp;
+
+	if (phy->radio_rev == 5) {
+		b43_phy_mask(dev, 0x342, ~0x2);
+		udelay(10);
+		b43_radio_set(dev, R2057_IQTEST_SEL_PU, 0x1);
+		b43_radio_maskset(dev, 0x1ca, ~0x2, 0x1);
+	}
+
+	b43_radio_set(dev, R2057_RCAL_CONFIG, 0x1);
+	udelay(10);
+	b43_radio_set(dev, R2057_RCAL_CONFIG, 0x3);
+	if (!b43_radio_wait_value(dev, R2057_RCCAL_N1_1, 1, 1, 100, 1000000)) {
+		b43err(dev->wl, "Radio 0x2057 rcal timeout\n");
+		return 0;
+	}
+	b43_radio_mask(dev, R2057_RCAL_CONFIG, ~0x2);
+	tmp = b43_radio_read(dev, R2057_RCAL_STATUS) & 0x3E;
+	b43_radio_mask(dev, R2057_RCAL_CONFIG, ~0x1);
+
+	if (phy->radio_rev == 5) {
+		b43_radio_mask(dev, R2057_IPA2G_CASCONV_CORE0, ~0x1);
+		b43_radio_mask(dev, 0x1ca, ~0x2);
+	}
+	if (phy->radio_rev <= 4 || phy->radio_rev == 6) {
+		b43_radio_maskset(dev, R2057_TEMPSENSE_CONFIG, ~0x3C, tmp);
+		b43_radio_maskset(dev, R2057_BANDGAP_RCAL_TRIM, ~0xF0,
+				  tmp << 2);
+	}
+
+	return tmp & 0x3e;
+}
+
+/* http://bcm-v4.sipsolutions.net/PHY/radio2057_rccal */
+static u16 b43_radio_2057_rccal(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	bool special = (phy->radio_rev == 3 || phy->radio_rev == 4 ||
+			phy->radio_rev == 6);
+	u16 tmp;
+
+	if (special) {
+		b43_radio_write(dev, R2057_RCCAL_MASTER, 0x61);
+		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xC0);
+	} else {
+		b43_radio_write(dev, 0x1AE, 0x61);
+		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xE1);
+	}
+	b43_radio_write(dev, R2057_RCCAL_X1, 0x6E);
+	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x55);
+	if (!b43_radio_wait_value(dev, R2057_RCCAL_DONE_OSCCAP, 1, 1, 500,
+				  5000000))
+		b43dbg(dev->wl, "Radio 0x2057 rccal timeout\n");
+	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x15);
+	if (special) {
+		b43_radio_write(dev, R2057_RCCAL_MASTER, 0x69);
+		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xB0);
+	} else {
+		b43_radio_write(dev, 0x1AE, 0x69);
+		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xD5);
+	}
+	b43_radio_write(dev, R2057_RCCAL_X1, 0x6E);
+	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x55);
+	if (!b43_radio_wait_value(dev, R2057_RCCAL_DONE_OSCCAP, 1, 1, 500,
+				  5000000))
+	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x15);
+	if (special) {
+		b43_radio_write(dev, R2057_RCCAL_MASTER, 0x73);
+		b43_radio_write(dev, R2057_RCCAL_X1, 0x28);
+		b43_radio_write(dev, R2057_RCCAL_TRC0, 0xB0);
+	} else {
+		b43_radio_write(dev, 0x1AE, 0x73);
+		b43_radio_write(dev, R2057_RCCAL_X1, 0x6E);
+		b43_radio_write(dev, R2057_RCCAL_TRC0, 0x99);
+	}
+	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x55);
+	if (!b43_radio_wait_value(dev, R2057_RCCAL_DONE_OSCCAP, 1, 1, 500,
+				  5000000)) {
+		b43err(dev->wl, "Radio 0x2057 rcal timeout\n");
+		return 0;
+	}
+	tmp = b43_radio_read(dev, R2057_RCCAL_DONE_OSCCAP);
+	b43_radio_write(dev, R2057_RCCAL_START_R1_Q1_P1, 0x15);
+	return tmp;
+}
+
+static void b43_radio_2057_init_pre(struct b43_wldev *dev)
+{
+	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD, ~B43_NPHY_RFCTL_CMD_CHIP0PU);
+	/* Maybe wl meant to reset and set (order?) RFCTL_CMD_OEPORFORCE? */
+	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD, B43_NPHY_RFCTL_CMD_OEPORFORCE);
+	b43_phy_set(dev, B43_NPHY_RFCTL_CMD, ~B43_NPHY_RFCTL_CMD_OEPORFORCE);
+	b43_phy_set(dev, B43_NPHY_RFCTL_CMD, B43_NPHY_RFCTL_CMD_CHIP0PU);
+}
+
+static void b43_radio_2057_init_post(struct b43_wldev *dev)
+{
+	b43_radio_set(dev, R2057_XTALPUOVR_PINCTRL, 0x1);
+
+	b43_radio_set(dev, R2057_RFPLL_MISC_CAL_RESETN, 0x78);
+	b43_radio_set(dev, R2057_XTAL_CONFIG2, 0x80);
+	mdelay(2);
+	b43_radio_mask(dev, R2057_RFPLL_MISC_CAL_RESETN, ~0x78);
+	b43_radio_mask(dev, R2057_XTAL_CONFIG2, ~0x80);
+
+	if (dev->phy.n->init_por) {
+		b43_radio_2057_rcal(dev);
+		b43_radio_2057_rccal(dev);
+	}
+	b43_radio_mask(dev, R2057_RFPLL_MASTER, ~0x8);
+
+	dev->phy.n->init_por = false;
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/Radio/2057/Init */
+static void b43_radio_2057_init(struct b43_wldev *dev)
+{
+	b43_radio_2057_init_pre(dev);
+	r2057_upload_inittabs(dev);
+	b43_radio_2057_init_post(dev);
+}
+
+/**************************************************
  * Radio 0x2056
  **************************************************/
 
@@ -5212,6 +5343,8 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 		nphy->ipa2g_on = sprom->fem.ghz2.extpa_gain == 2;
 		nphy->ipa5g_on = sprom->fem.ghz5.extpa_gain == 2;
 	}
+
+	nphy->init_por = true;
 }
 
 static void b43_nphy_op_free(struct b43_wldev *dev)
@@ -5298,7 +5431,9 @@ static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 	if (blocked) {
 		b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
 				~B43_NPHY_RFCTL_CMD_CHIP0PU);
-		if (dev->phy.rev >= 3) {
+		if (dev->phy.rev >= 7) {
+			/* TODO */
+		} else if (dev->phy.rev >= 3) {
 			b43_radio_mask(dev, 0x09, ~0x2);
 
 			b43_radio_write(dev, 0x204D, 0);
@@ -5316,7 +5451,10 @@ static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 			b43_radio_write(dev, 0x3064, 0);
 		}
 	} else {
-		if (dev->phy.rev >= 3) {
+		if (dev->phy.rev >= 7) {
+			b43_radio_2057_init(dev);
+			b43_switch_channel(dev, dev->phy.channel);
+		} else if (dev->phy.rev >= 3) {
 			b43_radio_init2056(dev);
 			b43_switch_channel(dev, dev->phy.channel);
 		} else {
diff --git a/drivers/net/wireless/b43/radio_2057.c b/drivers/net/wireless/b43/radio_2057.c
new file mode 100644
index 0000000..d61d683
--- /dev/null
+++ b/drivers/net/wireless/b43/radio_2057.c
@@ -0,0 +1,141 @@
+/*
+
+  Broadcom B43 wireless driver
+  IEEE 802.11n 2057 radio device data tables
+
+  Copyright (c) 2010 Rafał Miłecki <zajec5@gmail.com>
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
+#include "radio_2057.h"
+#include "phy_common.h"
+
+static u16 r2057_rev4_init[42][2] = {
+	{ 0x0E, 0x20 }, { 0x31, 0x00 }, { 0x32, 0x00 }, { 0x33, 0x00 },
+	{ 0x35, 0x26 }, { 0x3C, 0xff }, { 0x3D, 0xff }, { 0x3E, 0xff },
+	{ 0x3F, 0xff }, { 0x62, 0x33 }, { 0x8A, 0xf0 }, { 0x8B, 0x10 },
+	{ 0x8C, 0xf0 }, { 0x91, 0x3f }, { 0x92, 0x36 }, { 0xA4, 0x8c },
+	{ 0xA8, 0x55 }, { 0xAF, 0x01 }, { 0x10F, 0xf0 }, { 0x110, 0x10 },
+	{ 0x111, 0xf0 }, { 0x116, 0x3f }, { 0x117, 0x36 }, { 0x129, 0x8c },
+	{ 0x12D, 0x55 }, { 0x134, 0x01 }, { 0x15E, 0x00 }, { 0x15F, 0x00 },
+	{ 0x160, 0x00 }, { 0x161, 0x00 }, { 0x162, 0x00 }, { 0x163, 0x00 },
+	{ 0x169, 0x02 }, { 0x16A, 0x00 }, { 0x16B, 0x00 }, { 0x16C, 0x00 },
+	{ 0x1A4, 0x00 }, { 0x1A5, 0x00 }, { 0x1A6, 0x00 }, { 0x1AA, 0x00 },
+	{ 0x1AB, 0x00 }, { 0x1AC, 0x00 },
+};
+
+static u16 r2057_rev5_init[44][2] = {
+	{ 0x00, 0x00 }, { 0x01, 0x57 }, { 0x02, 0x20 }, { 0x23, 0x6 },
+	{ 0x31, 0x00 }, { 0x32, 0x00 }, { 0x33, 0x00 }, { 0x51, 0x70 },
+	{ 0x59, 0x88 }, { 0x5C, 0x20 }, { 0x62, 0x33 }, { 0x63, 0x0f },
+	{ 0x64, 0x0f }, { 0x81, 0x01 }, { 0x91, 0x3f }, { 0x92, 0x36 },
+	{ 0xA1, 0x20 }, { 0xD6, 0x70 }, { 0xDE, 0x88 }, { 0xE1, 0x20 },
+	{ 0xE8, 0x0f }, { 0xE9, 0x0f }, { 0x106, 0x01 }, { 0x116, 0x3f },
+	{ 0x117, 0x36 }, { 0x126, 0x20 }, { 0x15E, 0x00 }, { 0x15F, 0x00 },
+	{ 0x160, 0x00 }, { 0x161, 0x00 }, { 0x162, 0x00 }, { 0x163, 0x00 },
+	{ 0x16A, 0x00 }, { 0x16B, 0x00 }, { 0x16C, 0x00 }, { 0x1A4, 0x00 },
+	{ 0x1A5, 0x00 }, { 0x1A6, 0x00 }, { 0x1AA, 0x00 }, { 0x1AB, 0x00 },
+	{ 0x1AC, 0x00 }, { 0x1B7, 0x0c }, { 0x1C1, 0x01 }, { 0x1C2, 0x80 },
+};
+
+static u16 r2057_rev5a_init[45][2] = {
+	{ 0x00, 0x15 }, { 0x01, 0x57 }, { 0x02, 0x20 }, { 0x23, 0x6 },
+	{ 0x31, 0x00 }, { 0x32, 0x00 }, { 0x33, 0x00 }, { 0x51, 0x70 },
+	{ 0x59, 0x88 }, { 0x5C, 0x20 }, { 0x62, 0x33 }, { 0x63, 0x0f },
+	{ 0x64, 0x0f }, { 0x81, 0x01 }, { 0x91, 0x3f }, { 0x92, 0x36 },
+	{ 0xC9, 0x01 }, { 0xD6, 0x70 }, { 0xDE, 0x88 }, { 0xE1, 0x20 },
+	{ 0xE8, 0x0f }, { 0xE9, 0x0f }, { 0x106, 0x01 }, { 0x116, 0x3f },
+	{ 0x117, 0x36 }, { 0x126, 0x20 }, { 0x14E, 0x01 }, { 0x15E, 0x00 },
+	{ 0x15F, 0x00 }, { 0x160, 0x00 }, { 0x161, 0x00 }, { 0x162, 0x00 },
+	{ 0x163, 0x00 }, { 0x16A, 0x00 }, { 0x16B, 0x00 }, { 0x16C, 0x00 },
+	{ 0x1A4, 0x00 }, { 0x1A5, 0x00 }, { 0x1A6, 0x00 }, { 0x1AA, 0x00 },
+	{ 0x1AB, 0x00 }, { 0x1AC, 0x00 }, { 0x1B7, 0x0c }, { 0x1C1, 0x01 },
+	{ 0x1C2, 0x80 },
+};
+
+static u16 r2057_rev7_init[54][2] = {
+	{ 0x00, 0x00 }, { 0x01, 0x57 }, { 0x02, 0x20 }, { 0x31, 0x00 },
+	{ 0x32, 0x00 }, { 0x33, 0x00 }, { 0x51, 0x70 }, { 0x59, 0x88 },
+	{ 0x5C, 0x20 }, { 0x62, 0x33 }, { 0x63, 0x0f }, { 0x64, 0x13 },
+	{ 0x66, 0xee }, { 0x6E, 0x58 }, { 0x75, 0x13 }, { 0x7B, 0x13 },
+	{ 0x7C, 0x14 }, { 0x7D, 0xee }, { 0x81, 0x01 }, { 0x91, 0x3f },
+	{ 0x92, 0x36 }, { 0xA1, 0x20 }, { 0xD6, 0x70 }, { 0xDE, 0x88 },
+	{ 0xE1, 0x20 }, { 0xE8, 0x0f }, { 0xE9, 0x13 }, { 0xEB, 0xee },
+	{ 0xF3, 0x58 }, { 0xFA, 0x13 }, { 0x100, 0x13 }, { 0x101, 0x14 },
+	{ 0x102, 0xee }, { 0x106, 0x01 }, { 0x116, 0x3f }, { 0x117, 0x36 },
+	{ 0x126, 0x20 }, { 0x15E, 0x00 }, { 0x15F, 0x00 }, { 0x160, 0x00 },
+	{ 0x161, 0x00 }, { 0x162, 0x00 }, { 0x163, 0x00 }, { 0x16A, 0x00 },
+	{ 0x16B, 0x00 }, { 0x16C, 0x00 }, { 0x1A4, 0x00 }, { 0x1A5, 0x00 },
+	{ 0x1A6, 0x00 }, { 0x1AA, 0x00 }, { 0x1AB, 0x00 }, { 0x1AC, 0x00 },
+	{ 0x1B7, 0x05 }, { 0x1C2, 0xa0 },
+};
+
+static u16 r2057_rev8_init[54][2] = {
+	{ 0x00, 0x08 }, { 0x01, 0x57 }, { 0x02, 0x20 }, { 0x31, 0x00 },
+	{ 0x32, 0x00 }, { 0x33, 0x00 }, { 0x51, 0x70 }, { 0x59, 0x88 },
+	{ 0x5C, 0x20 }, { 0x62, 0x33 }, { 0x63, 0x0f }, { 0x64, 0x0f },
+	{ 0x6E, 0x58 }, { 0x75, 0x13 }, { 0x7B, 0x13 }, { 0x7C, 0x0f },
+	{ 0x7D, 0xee }, { 0x81, 0x01 }, { 0x91, 0x3f }, { 0x92, 0x36 },
+	{ 0xA1, 0x20 }, { 0xC9, 0x01 }, { 0xD6, 0x70 }, { 0xDE, 0x88 },
+	{ 0xE1, 0x20 }, { 0xE8, 0x0f }, { 0xE9, 0x0f }, { 0xF3, 0x58 },
+	{ 0xFA, 0x13 }, { 0x100, 0x13 }, { 0x101, 0x0f }, { 0x102, 0xee },
+	{ 0x106, 0x01 }, { 0x116, 0x3f }, { 0x117, 0x36 }, { 0x126, 0x20 },
+	{ 0x14E, 0x01 }, { 0x15E, 0x00 }, { 0x15F, 0x00 }, { 0x160, 0x00 },
+	{ 0x161, 0x00 }, { 0x162, 0x00 }, { 0x163, 0x00 }, { 0x16A, 0x00 },
+	{ 0x16B, 0x00 }, { 0x16C, 0x00 }, { 0x1A4, 0x00 }, { 0x1A5, 0x00 },
+	{ 0x1A6, 0x00 }, { 0x1AA, 0x00 }, { 0x1AB, 0x00 }, { 0x1AC, 0x00 },
+	{ 0x1B7, 0x05 }, { 0x1C2, 0xa0 },
+};
+
+void r2057_upload_inittabs(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	u16 *table = NULL;
+	u16 size, i;
+
+	if (phy->rev == 7) {
+		table = r2057_rev4_init[0];
+		size = ARRAY_SIZE(r2057_rev4_init);
+	} else if (phy->rev == 8 || phy->rev == 9) {
+		if (phy->radio_rev == 5) {
+			if (phy->radio_rev == 8) {
+				table = r2057_rev5_init[0];
+				size = ARRAY_SIZE(r2057_rev5_init);
+			} else {
+				table = r2057_rev5a_init[0];
+				size = ARRAY_SIZE(r2057_rev5a_init);
+			}
+		} else if (phy->radio_rev == 7) {
+			table = r2057_rev7_init[0];
+			size = ARRAY_SIZE(r2057_rev7_init);
+		} else if (phy->radio_rev == 9) {
+			table = r2057_rev8_init[0];
+			size = ARRAY_SIZE(r2057_rev8_init);
+		}
+	}
+
+	if (table) {
+		for (i = 0; i < 10; i++) {
+			pr_info("radio_write 0x%X ", *table);
+			table++;
+			pr_info("0x%X\n", *table);
+			table++;
+		}
+	}
+}
diff --git a/drivers/net/wireless/b43/radio_2057.h b/drivers/net/wireless/b43/radio_2057.h
new file mode 100644
index 0000000..eeebd8f
--- /dev/null
+++ b/drivers/net/wireless/b43/radio_2057.h
@@ -0,0 +1,430 @@
+#ifndef B43_RADIO_2057_H_
+#define B43_RADIO_2057_H_
+
+#include <linux/types.h>
+
+#include "tables_nphy.h"
+
+#define R2057_DACBUF_VINCM_CORE0		0x000
+#define R2057_IDCODE				0x001
+#define R2057_RCCAL_MASTER			0x002
+#define R2057_RCCAL_CAP_SIZE			0x003
+#define R2057_RCAL_CONFIG			0x004
+#define R2057_GPAIO_CONFIG			0x005
+#define R2057_GPAIO_SEL1			0x006
+#define R2057_GPAIO_SEL0			0x007
+#define R2057_CLPO_CONFIG			0x008
+#define R2057_BANDGAP_CONFIG			0x009
+#define R2057_BANDGAP_RCAL_TRIM			0x00a
+#define R2057_AFEREG_CONFIG			0x00b
+#define R2057_TEMPSENSE_CONFIG			0x00c
+#define R2057_XTAL_CONFIG1			0x00d
+#define R2057_XTAL_ICORE_SIZE			0x00e
+#define R2057_XTAL_BUF_SIZE			0x00f
+#define R2057_XTAL_PULLCAP_SIZE			0x010
+#define R2057_RFPLL_MASTER			0x011
+#define R2057_VCOMONITOR_VTH_L			0x012
+#define R2057_VCOMONITOR_VTH_H			0x013
+#define R2057_VCOCAL_BIASRESET_RFPLLREG_VOUT	0x014
+#define R2057_VCO_VARCSIZE_IDAC			0x015
+#define R2057_VCOCAL_COUNTVAL0			0x016
+#define R2057_VCOCAL_COUNTVAL1			0x017
+#define R2057_VCOCAL_INTCLK_COUNT		0x018
+#define R2057_VCOCAL_MASTER			0x019
+#define R2057_VCOCAL_NUMCAPCHANGE		0x01a
+#define R2057_VCOCAL_WINSIZE			0x01b
+#define R2057_VCOCAL_DELAY_AFTER_REFRESH	0x01c
+#define R2057_VCOCAL_DELAY_AFTER_CLOSELOOP	0x01d
+#define R2057_VCOCAL_DELAY_AFTER_OPENLOOP	0x01e
+#define R2057_VCOCAL_DELAY_BEFORE_OPENLOOP	0x01f
+#define R2057_VCO_FORCECAPEN_FORCECAP1		0x020
+#define R2057_VCO_FORCECAP0			0x021
+#define R2057_RFPLL_REFMASTER_SPAREXTALSIZE	0x022
+#define R2057_RFPLL_PFD_RESET_PW		0x023
+#define R2057_RFPLL_LOOPFILTER_R2		0x024
+#define R2057_RFPLL_LOOPFILTER_R1		0x025
+#define R2057_RFPLL_LOOPFILTER_C3		0x026
+#define R2057_RFPLL_LOOPFILTER_C2		0x027
+#define R2057_RFPLL_LOOPFILTER_C1		0x028
+#define R2057_CP_KPD_IDAC			0x029
+#define R2057_RFPLL_IDACS			0x02a
+#define R2057_RFPLL_MISC_EN			0x02b
+#define R2057_RFPLL_MMD0			0x02c
+#define R2057_RFPLL_MMD1			0x02d
+#define R2057_RFPLL_MISC_CAL_RESETN		0x02e
+#define R2057_JTAGXTAL_SIZE_CPBIAS_FILTRES	0x02f
+#define R2057_VCO_ALCREF_BBPLLXTAL_SIZE		0x030
+#define R2057_VCOCAL_READCAP0			0x031
+#define R2057_VCOCAL_READCAP1			0x032
+#define R2057_VCOCAL_STATUS			0x033
+#define R2057_LOGEN_PUS				0x034
+#define R2057_LOGEN_PTAT_RESETS			0x035
+#define R2057_VCOBUF_IDACS			0x036
+#define R2057_VCOBUF_TUNE			0x037
+#define R2057_CMOSBUF_TX2GQ_IDACS		0x038
+#define R2057_CMOSBUF_TX2GI_IDACS		0x039
+#define R2057_CMOSBUF_TX5GQ_IDACS		0x03a
+#define R2057_CMOSBUF_TX5GI_IDACS		0x03b
+#define R2057_CMOSBUF_RX2GQ_IDACS		0x03c
+#define R2057_CMOSBUF_RX2GI_IDACS		0x03d
+#define R2057_CMOSBUF_RX5GQ_IDACS		0x03e
+#define R2057_CMOSBUF_RX5GI_IDACS		0x03f
+#define R2057_LOGEN_MX2G_IDACS			0x040
+#define R2057_LOGEN_MX2G_TUNE			0x041
+#define R2057_LOGEN_MX5G_IDACS			0x042
+#define R2057_LOGEN_MX5G_TUNE			0x043
+#define R2057_LOGEN_MX5G_RCCR			0x044
+#define R2057_LOGEN_INDBUF2G_IDAC		0x045
+#define R2057_LOGEN_INDBUF2G_IBOOST		0x046
+#define R2057_LOGEN_INDBUF2G_TUNE		0x047
+#define R2057_LOGEN_INDBUF5G_IDAC		0x048
+#define R2057_LOGEN_INDBUF5G_IBOOST		0x049
+#define R2057_LOGEN_INDBUF5G_TUNE		0x04a
+#define R2057_CMOSBUF_TX_RCCR			0x04b
+#define R2057_CMOSBUF_RX_RCCR			0x04c
+#define R2057_LOGEN_SEL_PKDET			0x04d
+#define R2057_CMOSBUF_SHAREIQ_PTAT		0x04e
+#define R2057_RXTXBIAS_CONFIG_CORE0		0x04f
+#define R2057_TXGM_TXRF_PUS_CORE0		0x050
+#define R2057_TXGM_IDAC_BLEED_CORE0		0x051
+#define R2057_TXGM_GAIN_CORE0			0x056
+#define R2057_TXGM2G_PKDET_PUS_CORE0		0x057
+#define R2057_PAD2G_PTATS_CORE0			0x058
+#define R2057_PAD2G_IDACS_CORE0			0x059
+#define R2057_PAD2G_BOOST_PU_CORE0		0x05a
+#define R2057_PAD2G_CASCV_GAIN_CORE0		0x05b
+#define R2057_TXMIX2G_TUNE_BOOST_PU_CORE0	0x05c
+#define R2057_TXMIX2G_LODC_CORE0		0x05d
+#define R2057_PAD2G_TUNE_PUS_CORE0		0x05e
+#define R2057_IPA2G_GAIN_CORE0			0x05f
+#define R2057_TSSI2G_SPARE1_CORE0		0x060
+#define R2057_TSSI2G_SPARE2_CORE0		0x061
+#define R2057_IPA2G_TUNEV_CASCV_PTAT_CORE0	0x062
+#define R2057_IPA2G_IMAIN_CORE0			0x063
+#define R2057_IPA2G_CASCONV_CORE0		0x064
+#define R2057_IPA2G_CASCOFFV_CORE0		0x065
+#define R2057_IPA2G_BIAS_FILTER_CORE0		0x066
+#define R2057_TX5G_PKDET_CORE0			0x069
+#define R2057_PGA_PTAT_TXGM5G_PU_CORE0		0x06a
+#define R2057_PAD5G_PTATS1_CORE0		0x06b
+#define R2057_PAD5G_CLASS_PTATS2_CORE0		0x06c
+#define R2057_PGA_BOOSTPTAT_IMAIN_CORE0		0x06d
+#define R2057_PAD5G_CASCV_IMAIN_CORE0		0x06e
+#define R2057_TXMIX5G_IBOOST_PAD_IAUX_CORE0	0x06f
+#define R2057_PGA_BOOST_TUNE_CORE0		0x070
+#define R2057_PGA_GAIN_CORE0			0x071
+#define R2057_PAD5G_CASCOFFV_GAIN_PUS_CORE0	0x072
+#define R2057_TXMIX5G_BOOST_TUNE_CORE0		0x073
+#define R2057_PAD5G_TUNE_MISC_PUS_CORE0		0x074
+#define R2057_IPA5G_IAUX_CORE0			0x075
+#define R2057_IPA5G_GAIN_CORE0			0x076
+#define R2057_TSSI5G_SPARE1_CORE0		0x077
+#define R2057_TSSI5G_SPARE2_CORE0		0x078
+#define R2057_IPA5G_CASCOFFV_PU_CORE0		0x079
+#define R2057_IPA5G_PTAT_CORE0			0x07a
+#define R2057_IPA5G_IMAIN_CORE0			0x07b
+#define R2057_IPA5G_CASCONV_CORE0		0x07c
+#define R2057_IPA5G_BIAS_FILTER_CORE0		0x07d
+#define R2057_PAD_BIAS_FILTER_BWS_CORE0		0x080
+#define R2057_TR2G_CONFIG1_CORE0_NU		0x081
+#define R2057_TR2G_CONFIG2_CORE0_NU		0x082
+#define R2057_LNA5G_RFEN_CORE0			0x083
+#define R2057_TR5G_CONFIG2_CORE0_NU		0x084
+#define R2057_RXRFBIAS_IBOOST_PU_CORE0		0x085
+#define R2057_RXRF_IABAND_RXGM_IMAIN_PTAT_CORE0	0x086
+#define R2057_RXGM_CMFBITAIL_AUXPTAT_CORE0	0x087
+#define R2057_RXMIX_ICORE_RXGM_IAUX_CORE0	0x088
+#define R2057_RXMIX_CMFBITAIL_PU_CORE0		0x089
+#define R2057_LNA2_IMAIN_PTAT_PU_CORE0		0x08a
+#define R2057_LNA2_IAUX_PTAT_CORE0		0x08b
+#define R2057_LNA1_IMAIN_PTAT_PU_CORE0		0x08c
+#define R2057_LNA15G_INPUT_MATCH_TUNE_CORE0	0x08d
+#define R2057_RXRFBIAS_BANDSEL_CORE0		0x08e
+#define R2057_TIA_CONFIG_CORE0			0x08f
+#define R2057_TIA_IQGAIN_CORE0			0x090
+#define R2057_TIA_IBIAS2_CORE0			0x091
+#define R2057_TIA_IBIAS1_CORE0			0x092
+#define R2057_TIA_SPARE_Q_CORE0			0x093
+#define R2057_TIA_SPARE_I_CORE0			0x094
+#define R2057_RXMIX2G_PUS_CORE0			0x095
+#define R2057_RXMIX2G_VCMREFS_CORE0		0x096
+#define R2057_RXMIX2G_LODC_QI_CORE0		0x097
+#define R2057_W12G_BW_LNA2G_PUS_CORE0		0x098
+#define R2057_LNA2G_GAIN_CORE0			0x099
+#define R2057_LNA2G_TUNE_CORE0			0x09a
+#define R2057_RXMIX5G_PUS_CORE0			0x09b
+#define R2057_RXMIX5G_VCMREFS_CORE0		0x09c
+#define R2057_RXMIX5G_LODC_QI_CORE0		0x09d
+#define R2057_W15G_BW_LNA5G_PUS_CORE0		0x09e
+#define R2057_LNA5G_GAIN_CORE0			0x09f
+#define R2057_LNA5G_TUNE_CORE0			0x0a0
+#define R2057_LPFSEL_TXRX_RXBB_PUS_CORE0	0x0a1
+#define R2057_RXBB_BIAS_MASTER_CORE0		0x0a2
+#define R2057_RXBB_VGABUF_IDACS_CORE0		0x0a3
+#define R2057_LPF_VCMREF_TXBUF_VCMREF_CORE0	0x0a4
+#define R2057_TXBUF_VINCM_CORE0			0x0a5
+#define R2057_TXBUF_IDACS_CORE0			0x0a6
+#define R2057_LPF_RESP_RXBUF_BW_CORE0		0x0a7
+#define R2057_RXBB_CC_CORE0			0x0a8
+#define R2057_RXBB_SPARE3_CORE0			0x0a9
+#define R2057_RXBB_RCCAL_HPC_CORE0		0x0aa
+#define R2057_LPF_IDACS_CORE0			0x0ab
+#define R2057_LPFBYP_DCLOOP_BYP_IDAC_CORE0	0x0ac
+#define R2057_TXBUF_GAIN_CORE0			0x0ad
+#define R2057_AFELOOPBACK_AACI_RESP_CORE0	0x0ae
+#define R2057_RXBUF_DEGEN_CORE0			0x0af
+#define R2057_RXBB_SPARE2_CORE0			0x0b0
+#define R2057_RXBB_SPARE1_CORE0			0x0b1
+#define R2057_RSSI_MASTER_CORE0			0x0b2
+#define R2057_W2_MASTER_CORE0			0x0b3
+#define R2057_NB_MASTER_CORE0			0x0b4
+#define R2057_W2_IDACS0_Q_CORE0			0x0b5
+#define R2057_W2_IDACS1_Q_CORE0			0x0b6
+#define R2057_W2_IDACS0_I_CORE0			0x0b7
+#define R2057_W2_IDACS1_I_CORE0			0x0b8
+#define R2057_RSSI_GPAIOSEL_W1_IDACS_CORE0	0x0b9
+#define R2057_NB_IDACS_Q_CORE0			0x0ba
+#define R2057_NB_IDACS_I_CORE0			0x0bb
+#define R2057_BACKUP4_CORE0			0x0c1
+#define R2057_BACKUP3_CORE0			0x0c2
+#define R2057_BACKUP2_CORE0			0x0c3
+#define R2057_BACKUP1_CORE0			0x0c4
+#define R2057_SPARE16_CORE0			0x0c5
+#define R2057_SPARE15_CORE0			0x0c6
+#define R2057_SPARE14_CORE0			0x0c7
+#define R2057_SPARE13_CORE0			0x0c8
+#define R2057_SPARE12_CORE0			0x0c9
+#define R2057_SPARE11_CORE0			0x0ca
+#define R2057_TX2G_BIAS_RESETS_CORE0		0x0cb
+#define R2057_TX5G_BIAS_RESETS_CORE0		0x0cc
+#define R2057_IQTEST_SEL_PU			0x0cd
+#define R2057_XTAL_CONFIG2			0x0ce
+#define R2057_BUFS_MISC_LPFBW_CORE0		0x0cf
+#define R2057_TXLPF_RCCAL_CORE0			0x0d0
+#define R2057_RXBB_GPAIOSEL_RXLPF_RCCAL_CORE0	0x0d1
+#define R2057_LPF_GAIN_CORE0			0x0d2
+#define R2057_DACBUF_IDACS_BW_CORE0		0x0d3
+#define R2057_RXTXBIAS_CONFIG_CORE1		0x0d4
+#define R2057_TXGM_TXRF_PUS_CORE1		0x0d5
+#define R2057_TXGM_IDAC_BLEED_CORE1		0x0d6
+#define R2057_TXGM_GAIN_CORE1			0x0db
+#define R2057_TXGM2G_PKDET_PUS_CORE1		0x0dc
+#define R2057_PAD2G_PTATS_CORE1			0x0dd
+#define R2057_PAD2G_IDACS_CORE1			0x0de
+#define R2057_PAD2G_BOOST_PU_CORE1		0x0df
+#define R2057_PAD2G_CASCV_GAIN_CORE1		0x0e0
+#define R2057_TXMIX2G_TUNE_BOOST_PU_CORE1	0x0e1
+#define R2057_TXMIX2G_LODC_CORE1		0x0e2
+#define R2057_PAD2G_TUNE_PUS_CORE1		0x0e3
+#define R2057_IPA2G_GAIN_CORE1			0x0e4
+#define R2057_TSSI2G_SPARE1_CORE1		0x0e5
+#define R2057_TSSI2G_SPARE2_CORE1		0x0e6
+#define R2057_IPA2G_TUNEV_CASCV_PTAT_CORE1	0x0e7
+#define R2057_IPA2G_IMAIN_CORE1			0x0e8
+#define R2057_IPA2G_CASCONV_CORE1		0x0e9
+#define R2057_IPA2G_CASCOFFV_CORE1		0x0ea
+#define R2057_IPA2G_BIAS_FILTER_CORE1		0x0eb
+#define R2057_TX5G_PKDET_CORE1			0x0ee
+#define R2057_PGA_PTAT_TXGM5G_PU_CORE1		0x0ef
+#define R2057_PAD5G_PTATS1_CORE1		0x0f0
+#define R2057_PAD5G_CLASS_PTATS2_CORE1		0x0f1
+#define R2057_PGA_BOOSTPTAT_IMAIN_CORE1		0x0f2
+#define R2057_PAD5G_CASCV_IMAIN_CORE1		0x0f3
+#define R2057_TXMIX5G_IBOOST_PAD_IAUX_CORE1	0x0f4
+#define R2057_PGA_BOOST_TUNE_CORE1		0x0f5
+#define R2057_PGA_GAIN_CORE1			0x0f6
+#define R2057_PAD5G_CASCOFFV_GAIN_PUS_CORE1	0x0f7
+#define R2057_TXMIX5G_BOOST_TUNE_CORE1		0x0f8
+#define R2057_PAD5G_TUNE_MISC_PUS_CORE1		0x0f9
+#define R2057_IPA5G_IAUX_CORE1			0x0fa
+#define R2057_IPA5G_GAIN_CORE1			0x0fb
+#define R2057_TSSI5G_SPARE1_CORE1		0x0fc
+#define R2057_TSSI5G_SPARE2_CORE1		0x0fd
+#define R2057_IPA5G_CASCOFFV_PU_CORE1		0x0fe
+#define R2057_IPA5G_PTAT_CORE1			0x0ff
+#define R2057_IPA5G_IMAIN_CORE1			0x100
+#define R2057_IPA5G_CASCONV_CORE1		0x101
+#define R2057_IPA5G_BIAS_FILTER_CORE1		0x102
+#define R2057_PAD_BIAS_FILTER_BWS_CORE1		0x105
+#define R2057_TR2G_CONFIG1_CORE1_NU		0x106
+#define R2057_TR2G_CONFIG2_CORE1_NU		0x107
+#define R2057_LNA5G_RFEN_CORE1			0x108
+#define R2057_TR5G_CONFIG2_CORE1_NU		0x109
+#define R2057_RXRFBIAS_IBOOST_PU_CORE1		0x10a
+#define R2057_RXRF_IABAND_RXGM_IMAIN_PTAT_CORE1	0x10b
+#define R2057_RXGM_CMFBITAIL_AUXPTAT_CORE1	0x10c
+#define R2057_RXMIX_ICORE_RXGM_IAUX_CORE1	0x10d
+#define R2057_RXMIX_CMFBITAIL_PU_CORE1		0x10e
+#define R2057_LNA2_IMAIN_PTAT_PU_CORE1		0x10f
+#define R2057_LNA2_IAUX_PTAT_CORE1		0x110
+#define R2057_LNA1_IMAIN_PTAT_PU_CORE1		0x111
+#define R2057_LNA15G_INPUT_MATCH_TUNE_CORE1	0x112
+#define R2057_RXRFBIAS_BANDSEL_CORE1		0x113
+#define R2057_TIA_CONFIG_CORE1			0x114
+#define R2057_TIA_IQGAIN_CORE1			0x115
+#define R2057_TIA_IBIAS2_CORE1			0x116
+#define R2057_TIA_IBIAS1_CORE1			0x117
+#define R2057_TIA_SPARE_Q_CORE1			0x118
+#define R2057_TIA_SPARE_I_CORE1			0x119
+#define R2057_RXMIX2G_PUS_CORE1			0x11a
+#define R2057_RXMIX2G_VCMREFS_CORE1		0x11b
+#define R2057_RXMIX2G_LODC_QI_CORE1		0x11c
+#define R2057_W12G_BW_LNA2G_PUS_CORE1		0x11d
+#define R2057_LNA2G_GAIN_CORE1			0x11e
+#define R2057_LNA2G_TUNE_CORE1			0x11f
+#define R2057_RXMIX5G_PUS_CORE1			0x120
+#define R2057_RXMIX5G_VCMREFS_CORE1		0x121
+#define R2057_RXMIX5G_LODC_QI_CORE1		0x122
+#define R2057_W15G_BW_LNA5G_PUS_CORE1		0x123
+#define R2057_LNA5G_GAIN_CORE1			0x124
+#define R2057_LNA5G_TUNE_CORE1			0x125
+#define R2057_LPFSEL_TXRX_RXBB_PUS_CORE1	0x126
+#define R2057_RXBB_BIAS_MASTER_CORE1		0x127
+#define R2057_RXBB_VGABUF_IDACS_CORE1		0x128
+#define R2057_LPF_VCMREF_TXBUF_VCMREF_CORE1	0x129
+#define R2057_TXBUF_VINCM_CORE1			0x12a
+#define R2057_TXBUF_IDACS_CORE1			0x12b
+#define R2057_LPF_RESP_RXBUF_BW_CORE1		0x12c
+#define R2057_RXBB_CC_CORE1			0x12d
+#define R2057_RXBB_SPARE3_CORE1			0x12e
+#define R2057_RXBB_RCCAL_HPC_CORE1		0x12f
+#define R2057_LPF_IDACS_CORE1			0x130
+#define R2057_LPFBYP_DCLOOP_BYP_IDAC_CORE1	0x131
+#define R2057_TXBUF_GAIN_CORE1			0x132
+#define R2057_AFELOOPBACK_AACI_RESP_CORE1	0x133
+#define R2057_RXBUF_DEGEN_CORE1			0x134
+#define R2057_RXBB_SPARE2_CORE1			0x135
+#define R2057_RXBB_SPARE1_CORE1			0x136
+#define R2057_RSSI_MASTER_CORE1			0x137
+#define R2057_W2_MASTER_CORE1			0x138
+#define R2057_NB_MASTER_CORE1			0x139
+#define R2057_W2_IDACS0_Q_CORE1			0x13a
+#define R2057_W2_IDACS1_Q_CORE1			0x13b
+#define R2057_W2_IDACS0_I_CORE1			0x13c
+#define R2057_W2_IDACS1_I_CORE1			0x13d
+#define R2057_RSSI_GPAIOSEL_W1_IDACS_CORE1	0x13e
+#define R2057_NB_IDACS_Q_CORE1			0x13f
+#define R2057_NB_IDACS_I_CORE1			0x140
+#define R2057_BACKUP4_CORE1			0x146
+#define R2057_BACKUP3_CORE1			0x147
+#define R2057_BACKUP2_CORE1			0x148
+#define R2057_BACKUP1_CORE1			0x149
+#define R2057_SPARE16_CORE1			0x14a
+#define R2057_SPARE15_CORE1			0x14b
+#define R2057_SPARE14_CORE1			0x14c
+#define R2057_SPARE13_CORE1			0x14d
+#define R2057_SPARE12_CORE1			0x14e
+#define R2057_SPARE11_CORE1			0x14f
+#define R2057_TX2G_BIAS_RESETS_CORE1		0x150
+#define R2057_TX5G_BIAS_RESETS_CORE1		0x151
+#define R2057_SPARE8_CORE1			0x152
+#define R2057_SPARE7_CORE1			0x153
+#define R2057_BUFS_MISC_LPFBW_CORE1		0x154
+#define R2057_TXLPF_RCCAL_CORE1			0x155
+#define R2057_RXBB_GPAIOSEL_RXLPF_RCCAL_CORE1	0x156
+#define R2057_LPF_GAIN_CORE1			0x157
+#define R2057_DACBUF_IDACS_BW_CORE1		0x158
+#define R2057_DACBUF_VINCM_CORE1		0x159
+#define R2057_RCCAL_START_R1_Q1_P1		0x15a
+#define R2057_RCCAL_X1				0x15b
+#define R2057_RCCAL_TRC0			0x15c
+#define R2057_RCCAL_TRC1			0x15d
+#define R2057_RCCAL_DONE_OSCCAP			0x15e
+#define R2057_RCCAL_N0_0			0x15f
+#define R2057_RCCAL_N0_1			0x160
+#define R2057_RCCAL_N1_0			0x161
+#define R2057_RCCAL_N1_1			0x162
+#define R2057_RCAL_STATUS			0x163
+#define R2057_XTALPUOVR_PINCTRL			0x164
+#define R2057_OVR_REG0				0x165
+#define R2057_OVR_REG1				0x166
+#define R2057_OVR_REG2				0x167
+#define R2057_OVR_REG3				0x168
+#define R2057_OVR_REG4				0x169
+#define R2057_RCCAL_SCAP_VAL			0x16a
+#define R2057_RCCAL_BCAP_VAL			0x16b
+#define R2057_RCCAL_HPC_VAL			0x16c
+#define R2057_RCCAL_OVERRIDES			0x16d
+#define R2057_TX0_IQCAL_GAIN_BW			0x170
+#define R2057_TX0_LOFT_FINE_I			0x171
+#define R2057_TX0_LOFT_FINE_Q			0x172
+#define R2057_TX0_LOFT_COARSE_I			0x173
+#define R2057_TX0_LOFT_COARSE_Q			0x174
+#define R2057_TX0_TX_SSI_MASTER			0x175
+#define R2057_TX0_IQCAL_VCM_HG			0x176
+#define R2057_TX0_IQCAL_IDAC			0x177
+#define R2057_TX0_TSSI_VCM			0x178
+#define R2057_TX0_TX_SSI_MUX			0x179
+#define R2057_TX0_TSSIA				0x17a
+#define R2057_TX0_TSSIG				0x17b
+#define R2057_TX0_TSSI_MISC1			0x17c
+#define R2057_TX0_TXRXCOUPLE_2G_ATTEN		0x17d
+#define R2057_TX0_TXRXCOUPLE_2G_PWRUP		0x17e
+#define R2057_TX0_TXRXCOUPLE_5G_ATTEN		0x17f
+#define R2057_TX0_TXRXCOUPLE_5G_PWRUP		0x180
+#define R2057_TX1_IQCAL_GAIN_BW			0x190
+#define R2057_TX1_LOFT_FINE_I			0x191
+#define R2057_TX1_LOFT_FINE_Q			0x192
+#define R2057_TX1_LOFT_COARSE_I			0x193
+#define R2057_TX1_LOFT_COARSE_Q			0x194
+#define R2057_TX1_TX_SSI_MASTER			0x195
+#define R2057_TX1_IQCAL_VCM_HG			0x196
+#define R2057_TX1_IQCAL_IDAC			0x197
+#define R2057_TX1_TSSI_VCM			0x198
+#define R2057_TX1_TX_SSI_MUX			0x199
+#define R2057_TX1_TSSIA				0x19a
+#define R2057_TX1_TSSIG				0x19b
+#define R2057_TX1_TSSI_MISC1			0x19c
+#define R2057_TX1_TXRXCOUPLE_2G_ATTEN		0x19d
+#define R2057_TX1_TXRXCOUPLE_2G_PWRUP		0x19e
+#define R2057_TX1_TXRXCOUPLE_5G_ATTEN		0x19f
+#define R2057_TX1_TXRXCOUPLE_5G_PWRUP		0x1a0
+#define R2057_AFE_VCM_CAL_MASTER_CORE0		0x1a1
+#define R2057_AFE_SET_VCM_I_CORE0		0x1a2
+#define R2057_AFE_SET_VCM_Q_CORE0		0x1a3
+#define R2057_AFE_STATUS_VCM_IQADC_CORE0	0x1a4
+#define R2057_AFE_STATUS_VCM_I_CORE0		0x1a5
+#define R2057_AFE_STATUS_VCM_Q_CORE0		0x1a6
+#define R2057_AFE_VCM_CAL_MASTER_CORE1		0x1a7
+#define R2057_AFE_SET_VCM_I_CORE1		0x1a8
+#define R2057_AFE_SET_VCM_Q_CORE1		0x1a9
+#define R2057_AFE_STATUS_VCM_IQADC_CORE1	0x1aa
+#define R2057_AFE_STATUS_VCM_I_CORE1		0x1ab
+#define R2057_AFE_STATUS_VCM_Q_CORE1		0x1ac
+
+#define R2057v7_DACBUF_VINCM_CORE0		0x1ad
+#define R2057v7_RCCAL_MASTER			0x1ae
+#define R2057v7_TR2G_CONFIG3_CORE0_NU		0x1af
+#define R2057v7_TR2G_CONFIG3_CORE1_NU		0x1b0
+#define R2057v7_LOGEN_PUS1			0x1b1
+#define R2057v7_OVR_REG5			0x1b2
+#define R2057v7_OVR_REG6			0x1b3
+#define R2057v7_OVR_REG7			0x1b4
+#define R2057v7_OVR_REG8			0x1b5
+#define R2057v7_OVR_REG9			0x1b6
+#define R2057v7_OVR_REG10			0x1b7
+#define R2057v7_OVR_REG11			0x1b8
+#define R2057v7_OVR_REG12			0x1b9
+#define R2057v7_OVR_REG13			0x1ba
+#define R2057v7_OVR_REG14			0x1bb
+#define R2057v7_OVR_REG15			0x1bc
+#define R2057v7_OVR_REG16			0x1bd
+#define R2057v7_OVR_REG1			0x1be
+#define R2057v7_OVR_REG18			0x1bf
+#define R2057v7_OVR_REG19			0x1c0
+#define R2057v7_OVR_REG20			0x1c1
+#define R2057v7_OVR_REG21			0x1c2
+#define R2057v7_OVR_REG2			0x1c3
+#define R2057v7_OVR_REG23			0x1c4
+#define R2057v7_OVR_REG24			0x1c5
+#define R2057v7_OVR_REG25			0x1c6
+#define R2057v7_OVR_REG26			0x1c7
+#define R2057v7_OVR_REG27			0x1c8
+#define R2057v7_OVR_REG28			0x1c9
+#define R2057v7_IQTEST_SEL_PU2			0x1ca
+
+#define R2057_VCM_MASK				0x7
+
+void r2057_upload_inittabs(struct b43_wldev *dev);
+
+#endif /* B43_RADIO_2057_H_ */
-- 
1.7.7


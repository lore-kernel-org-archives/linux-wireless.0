Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56846 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab1FMNmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 09:42:05 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2670499fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 06:42:04 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: HT-PHY: add place for writing HT PHY support
Date: Mon, 13 Jun 2011 16:20:06 +0200
Message-Id: <1307974806-25902-2-git-send-email-zajec5@gmail.com> (sfid-20110613_154210_012281_7D5B9CCB)
In-Reply-To: <1307974806-25902-1-git-send-email-zajec5@gmail.com>
References: <1307974806-25902-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is totally broken plus we do not have specs for HT PHY yet. Just
introduce place for writing driver if we discover anything.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Kconfig      |    8 ++
 drivers/net/wireless/b43/Makefile     |    1 +
 drivers/net/wireless/b43/main.c       |   10 +++
 drivers/net/wireless/b43/phy_common.c |    6 ++
 drivers/net/wireless/b43/phy_common.h |    3 +
 drivers/net/wireless/b43/phy_ht.c     |  119 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_ht.h     |   19 +++++
 7 files changed, 166 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/b43/phy_ht.c
 create mode 100644 drivers/net/wireless/b43/phy_ht.h

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index fe26bf4..e02db1b 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -112,6 +112,14 @@ config B43_PHY_LP
 	  and embedded devices. It supports 802.11a/g
 	  (802.11a support is optional, and currently disabled).
 
+config B43_PHY_HT
+	bool "Support for HT-PHY devices (BROKEN)"
+	depends on B43 && BROKEN
+	---help---
+	  Support for the HT-PHY.
+
+	  Say N, this is BROKEN and crashes driver.
+
 # This config option automatically enables b43 LEDS support,
 # if it's possible.
 config B43_LEDS
diff --git a/drivers/net/wireless/b43/Makefile b/drivers/net/wireless/b43/Makefile
index 95f7c00..58d614a 100644
--- a/drivers/net/wireless/b43/Makefile
+++ b/drivers/net/wireless/b43/Makefile
@@ -10,6 +10,7 @@ b43-y				+= phy_a.o
 b43-$(CONFIG_B43_PHY_N)		+= phy_n.o
 b43-$(CONFIG_B43_PHY_LP)	+= phy_lp.o
 b43-$(CONFIG_B43_PHY_LP)	+= tables_lpphy.o
+b43-$(CONFIG_B43_PHY_HT)	+= phy_ht.o
 b43-y				+= sysfs.o
 b43-y				+= xmit.o
 b43-y				+= lo.o
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 2260b36..ea9e737 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4102,6 +4102,12 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 			unsupported = 1;
 		break;
 #endif
+#ifdef CONFIG_B43_PHY_HT
+	case B43_PHYTYPE_HT:
+		if (phy_rev > 1)
+			unsupported = 1;
+		break;
+#endif
 	default:
 		unsupported = 1;
 	};
@@ -4158,6 +4164,10 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 		if (radio_ver != 0x2062 && radio_ver != 0x2063)
 			unsupported = 1;
 		break;
+	case B43_PHYTYPE_HT:
+		if (radio_ver != 0x2059)
+			unsupported = 1;
+		break;
 	default:
 		B43_WARN_ON(1);
 	}
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 425af28..9705950 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -31,6 +31,7 @@
 #include "phy_a.h"
 #include "phy_n.h"
 #include "phy_lp.h"
+#include "phy_ht.h"
 #include "b43.h"
 #include "main.h"
 
@@ -59,6 +60,11 @@ int b43_phy_allocate(struct b43_wldev *dev)
 		phy->ops = &b43_phyops_lp;
 #endif
 		break;
+	case B43_PHYTYPE_HT:
+#ifdef CONFIG_B43_PHY_HT
+		phy->ops = &b43_phyops_ht;
+#endif
+		break;
 	}
 	if (B43_WARN_ON(!phy->ops))
 		return -ENODEV;
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 2401bee..47dcb80 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -194,6 +194,7 @@ struct b43_phy_a;
 struct b43_phy_g;
 struct b43_phy_n;
 struct b43_phy_lp;
+struct b43_phy_ht;
 
 struct b43_phy {
 	/* Hardware operation callbacks. */
@@ -216,6 +217,8 @@ struct b43_phy {
 		struct b43_phy_n *n;
 		/* LP-PHY specific information */
 		struct b43_phy_lp *lp;
+		/* HT-PHY specific information */
+		struct b43_phy_ht *ht;
 	};
 
 	/* Band support flags. */
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
new file mode 100644
index 0000000..320be0e
--- /dev/null
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -0,0 +1,119 @@
+/*
+
+  Broadcom B43 wireless driver
+  IEEE 802.11n HT-PHY support
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
+#include <linux/slab.h>
+
+#include "b43.h"
+#include "phy_ht.h"
+#include "main.h"
+
+/**************************************************
+ * Basic PHY ops.
+ **************************************************/
+
+static int b43_phy_ht_op_allocate(struct b43_wldev *dev)
+{
+	struct b43_phy_ht *phy_ht;
+
+	phy_ht = kzalloc(sizeof(*phy_ht), GFP_KERNEL);
+	if (!phy_ht)
+		return -ENOMEM;
+	dev->phy.ht = phy_ht;
+
+	return 0;
+}
+
+static void b43_phy_ht_op_prepare_structs(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_ht *phy_ht = phy->ht;
+
+	memset(phy_ht, 0, sizeof(*phy_ht));
+}
+
+static void b43_phy_ht_op_free(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_ht *phy_ht = phy->ht;
+
+	kfree(phy_ht);
+	phy->ht = NULL;
+}
+
+static unsigned int b43_phy_ht_op_get_default_chan(struct b43_wldev *dev)
+{
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		return 1;
+	return 36;
+}
+
+/**************************************************
+ * R/W ops.
+ **************************************************/
+
+static u16 b43_phy_ht_op_read(struct b43_wldev *dev, u16 reg)
+{
+	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	return b43_read16(dev, B43_MMIO_PHY_DATA);
+}
+
+static void b43_phy_ht_op_write(struct b43_wldev *dev, u16 reg, u16 value)
+{
+	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16(dev, B43_MMIO_PHY_DATA, value);
+}
+
+static void b43_phy_ht_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
+				 u16 set)
+{
+	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16(dev, B43_MMIO_PHY_DATA,
+		    (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set);
+}
+
+/**************************************************
+ * PHY ops struct.
+ **************************************************/
+
+const struct b43_phy_operations b43_phyops_ht = {
+	.allocate		= b43_phy_ht_op_allocate,
+	.free			= b43_phy_ht_op_free,
+	.prepare_structs	= b43_phy_ht_op_prepare_structs,
+	/*
+	.init			= b43_phy_ht_op_init,
+	*/
+	.phy_read		= b43_phy_ht_op_read,
+	.phy_write		= b43_phy_ht_op_write,
+	.phy_maskset		= b43_phy_ht_op_maskset,
+	/*
+	.radio_read		= b43_phy_ht_op_radio_read,
+	.radio_write		= b43_phy_ht_op_radio_write,
+	.software_rfkill	= b43_phy_ht_op_software_rfkill,
+	.switch_analog		= b43_phy_ht_op_switch_analog,
+	.switch_channel		= b43_phy_ht_op_switch_channel,
+	*/
+	.get_default_chan	= b43_phy_ht_op_get_default_chan,
+	/*
+	.recalc_txpower		= b43_phy_ht_op_recalc_txpower,
+	.adjust_txpower		= b43_phy_ht_op_adjust_txpower,
+	*/
+};
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
new file mode 100644
index 0000000..aabad6f
--- /dev/null
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -0,0 +1,19 @@
+#ifndef B43_PHY_HT_H_
+#define B43_PHY_HT_H_
+
+#include "phy_common.h"
+
+
+#define B43_PHY_HT_TABLE_ADDR			0x072 /* Table address */
+#define B43_PHY_HT_TABLE_DATALO			0x073 /* Table data low */
+#define B43_PHY_HT_TABLE_DATAHI			0x074 /* Table data high */
+
+
+struct b43_phy_ht {
+};
+
+
+struct b43_phy_operations;
+extern const struct b43_phy_operations b43_phyops_ht;
+
+#endif /* B43_PHY_HT_H_ */
-- 
1.7.3.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38251 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYH3I7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2008 04:59:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add LP-PHY template
Date: Sat, 30 Aug 2008 10:55:48 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200808301055.49668.mb@bu3sch.de> (sfid-20080830_105951_991756_8C1AE3E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds template code for the LP-PHY.
No actual functionality is implemented.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next merge window.


Index: wireless-testing/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Kconfig	2008-08-30 10:43:51.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/Kconfig	2008-08-30 10:50:37.000000000 +0200
@@ -77,12 +77,24 @@ config B43_NPHY
 	  Support for the IEEE 802.11n draft.
 
 	  THIS IS BROKEN AND DOES NOT WORK YET.
 
 	  SAY N.
 
+config B43_PHY_LP
+	bool "IEEE 802.11g LP-PHY support (BROKEN)"
+	depends on B43 && EXPERIMENTAL && BROKEN
+	---help---
+	  Support for the LP-PHY.
+	  The LP-PHY is an IEEE 802.11g based PHY built into some notebooks
+	  and embedded devices.
+
+	  THIS IS BROKEN AND DOES NOT WORK YET.
+
+	  SAY N.
+
 # This config option automatically enables b43 LEDS support,
 # if it's possible.
 config B43_LEDS
 	bool
 	depends on B43 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = B43)
 	default y
Index: wireless-testing/drivers/net/wireless/b43/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.c	2008-08-30 10:44:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.c	2008-08-30 10:47:11.000000000 +0200
@@ -27,12 +27,13 @@
 */
 
 #include "phy_common.h"
 #include "phy_g.h"
 #include "phy_a.h"
 #include "phy_n.h"
+#include "phy_lp.h"
 #include "b43.h"
 #include "main.h"
 
 
 int b43_phy_operations_setup(struct b43_wldev *dev)
 {
@@ -51,13 +52,15 @@ int b43_phy_operations_setup(struct b43_
 	case B43_PHYTYPE_N:
 #ifdef CONFIG_B43_NPHY
 		phy->ops = &b43_phyops_n;
 #endif
 		break;
 	case B43_PHYTYPE_LP:
-		/* FIXME: Not yet */
+#ifdef CONFIG_B43_PHY_LP
+		phy->ops = &b43_phyops_lp;
+#endif
 		break;
 	}
 	if (B43_WARN_ON(!phy->ops))
 		return -ENODEV;
 
 	err = phy->ops->allocate(dev);
Index: wireless-testing/drivers/net/wireless/b43/phy_lp.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.c	2008-08-30 10:50:49.000000000 +0200
@@ -0,0 +1,142 @@
+/*
+
+  Broadcom B43 wireless driver
+  IEEE 802.11g LP-PHY driver
+
+  Copyright (c) 2008 Michael Buesch <mb@bu3sch.de>
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
+#include "phy_lp.h"
+#include "phy_common.h"
+
+
+static int b43_lpphy_op_allocate(struct b43_wldev *dev)
+{
+	struct b43_phy_lp *lpphy;
+
+	lpphy = kzalloc(sizeof(*lpphy), GFP_KERNEL);
+	if (!lpphy)
+		return -ENOMEM;
+	dev->phy.lp = lpphy;
+
+	//TODO
+
+	return 0;
+}
+
+static int b43_lpphy_op_init(struct b43_wldev *dev)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+
+	//TODO
+	lpphy->initialised = 1;
+
+	return 0;
+}
+
+static void b43_lpphy_op_exit(struct b43_wldev *dev)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+
+	if (lpphy->initialised) {
+		//TODO
+		lpphy->initialised = 0;
+	}
+
+	kfree(lpphy);
+	dev->phy.lp = NULL;
+}
+
+static u16 b43_lpphy_op_read(struct b43_wldev *dev, u16 reg)
+{
+	//TODO
+	return 0;
+}
+
+static void b43_lpphy_op_write(struct b43_wldev *dev, u16 reg, u16 value)
+{
+	//TODO
+}
+
+static u16 b43_lpphy_op_radio_read(struct b43_wldev *dev, u16 reg)
+{
+	//TODO
+	return 0;
+}
+
+static void b43_lpphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
+{
+	/* Register 1 is a 32-bit register. */
+	B43_WARN_ON(reg == 1);
+
+	//TODO
+}
+
+static void b43_lpphy_op_software_rfkill(struct b43_wldev *dev,
+					 enum rfkill_state state)
+{
+	//TODO
+}
+
+static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
+				       unsigned int new_channel)
+{
+	//TODO
+	return 0;
+}
+
+static unsigned int b43_lpphy_op_get_default_chan(struct b43_wldev *dev)
+{
+	return 1; /* Default to channel 1 */
+}
+
+static void b43_lpphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
+{
+	//TODO
+}
+
+static void b43_lpphy_op_adjust_txpower(struct b43_wldev *dev)
+{
+	//TODO
+}
+
+static enum b43_txpwr_result b43_lpphy_op_recalc_txpower(struct b43_wldev *dev,
+							 bool ignore_tssi)
+{
+	//TODO
+	return B43_TXPWR_RES_DONE;
+}
+
+
+const struct b43_phy_operations b43_phyops_lp = {
+	.allocate		= b43_lpphy_op_allocate,
+	.init			= b43_lpphy_op_init,
+	.exit			= b43_lpphy_op_exit,
+	.phy_read		= b43_lpphy_op_read,
+	.phy_write		= b43_lpphy_op_write,
+	.radio_read		= b43_lpphy_op_radio_read,
+	.radio_write		= b43_lpphy_op_radio_write,
+	.software_rfkill	= b43_lpphy_op_software_rfkill,
+	.switch_channel		= b43_lpphy_op_switch_channel,
+	.get_default_chan	= b43_lpphy_op_get_default_chan,
+	.set_rx_antenna		= b43_lpphy_op_set_rx_antenna,
+	.recalc_txpower		= b43_lpphy_op_recalc_txpower,
+	.adjust_txpower		= b43_lpphy_op_adjust_txpower,
+};
Index: wireless-testing/drivers/net/wireless/b43/phy_lp.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.h	2008-08-30 10:44:12.000000000 +0200
@@ -0,0 +1,14 @@
+#ifndef LINUX_B43_PHY_LP_H_
+#define LINUX_B43_PHY_LP_H_
+
+/* Definitions for the LP-PHY */
+
+struct b43_phy_lp {
+	bool initialised;
+};
+
+
+struct b43_phy_operations;
+extern const struct b43_phy_operations b43_phyops_lp;
+
+#endif /* LINUX_B43_PHY_LP_H_ */
Index: wireless-testing/drivers/net/wireless/b43/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Makefile	2008-08-30 10:44:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/Makefile	2008-08-30 10:44:12.000000000 +0200
@@ -2,12 +2,13 @@ b43-y				+= main.o
 b43-y				+= tables.o
 b43-$(CONFIG_B43_NPHY)		+= tables_nphy.o
 b43-y				+= phy_common.o
 b43-y				+= phy_g.o
 b43-y				+= phy_a.o
 b43-$(CONFIG_B43_NPHY)		+= phy_n.o
+b43-$(CONFIG_B43_PHY_LP)	+= phy_lp.o
 b43-y				+= sysfs.o
 b43-y				+= xmit.o
 b43-y				+= lo.o
 b43-y				+= wa.o
 b43-y				+= dma.o
 b43-$(CONFIG_B43_PIO)		+= pio.o
Index: wireless-testing/drivers/net/wireless/b43/phy_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.h	2008-08-30 02:13:22.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.h	2008-08-30 10:49:02.000000000 +0200
@@ -162,12 +162,13 @@ struct b43_phy_operations {
 	void (*pwork_60sec)(struct b43_wldev *dev);
 };
 
 struct b43_phy_a;
 struct b43_phy_g;
 struct b43_phy_n;
+struct b43_phy_lp;
 
 struct b43_phy {
 	/* Hardware operation callbacks. */
 	const struct b43_phy_operations *ops;
 
 	/* Most hardware context information is stored in the standard-
@@ -182,12 +183,14 @@ struct b43_phy {
 		/* A-PHY specific information */
 		struct b43_phy_a *a;
 		/* G-PHY specific information */
 		struct b43_phy_g *g;
 		/* N-PHY specific information */
 		struct b43_phy_n *n;
+		/* LP-PHY specific information */
+		struct b43_phy_lp *lp;
 	};
 
 	/* Band support flags. */
 	bool supports_2ghz;
 	bool supports_5ghz;
 

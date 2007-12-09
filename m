Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:33136 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXLIVgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 16:36:42 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix ofdmtab write regression
Date: Sun, 9 Dec 2007 22:34:59 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200712092235.00042.mb@bu3sch.de> (sfid-20071209_213645_882807_66692814)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit f04b3787bbce4567e28069a9ec97dcd804626ac7 introduced
a regression for the ofdmtable writing.

It incorrectly removed the writing of the high 16bits for
a 32bit table write and initialized the direction identifier
too late.

This patch does also some cleanups to make the code much more
readable and adds a few comments, so non rocket scientists are
also able to understand what this address caching is all about.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2007-12-09 20:50:43.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2007-12-09 20:56:55.000000000 +0100
@@ -545,12 +545,18 @@
 
 	u16 initval;		//FIXME rename?
 
-	/* OFDM address read/write caching for hardware auto-increment. */
-	u16 ofdm_addr;
-	u8 ofdm_valid; /* 0: invalid, 1: read, 2: write */
-
 	/* PHY TX errors counter. */
 	atomic_t txerr_cnt;
+
+	/* The device does address auto increment for the OFDM tables.
+	 * We cache the previously used address here and omit the address
+	 * write on the next table access, if possible. */
+	u16 ofdmtab_addr; /* The address currently set in hardware. */
+	enum { /* The last data flow direction. */
+		B43_OFDMTAB_DIRECTION_UNKNOWN = 0,
+		B43_OFDMTAB_DIRECTION_READ,
+		B43_OFDMTAB_DIRECTION_WRITE,
+	} ofdmtab_addr_direction;
 };
 
 /* Data structures for DMA transmission, per 80211 core. */
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-12-09 20:50:43.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-12-09 21:01:27.000000000 +0100
@@ -2266,12 +2266,6 @@
 	b43_write16(dev, B43_MMIO_POWERUP_DELAY,
 		    dev->dev->bus->chipco.fast_pwrup_delay);
 
-	/* OFDM address caching. */
-	phy->ofdm_valid = 0;
-
-	/* PHY TX errors counter. */
-	atomic_set(&phy->txerr_cnt, B43_PHY_TX_BADNESS_LIMIT);
-
 	err = 0;
 	b43dbg(dev->wl, "Chip initialized\n");
 out:
@@ -3198,6 +3192,12 @@
 	phy->channel = 0xFF;
 
 	phy->hardware_power_control = !!modparam_hwpctl;
+
+	/* PHY TX errors counter. */
+	atomic_set(&phy->txerr_cnt, B43_PHY_TX_BADNESS_LIMIT);
+
+	/* OFDM-table address caching. */
+	phy->ofdmtab_addr_direction = B43_OFDMTAB_DIRECTION_UNKNOWN;
 }
 
 static void setup_struct_wldev_for_init(struct b43_wldev *dev)
Index: wireless-2.6/drivers/net/wireless/b43/tables.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/tables.c	2007-12-09 20:50:43.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/tables.c	2007-12-09 20:55:01.000000000 +0100
@@ -381,13 +381,17 @@
 	u16 addr;
 
 	addr = table + offset;
-	if (addr - 1 != phy->ofdm_addr || phy->ofdm_valid != 1) {
+	if ((phy->ofdmtab_addr_direction != B43_OFDMTAB_DIRECTION_READ) ||
+	    (addr - 1 != phy->ofdmtab_addr)) {
+		/* The hardware has a different address in memory. Update it. */
 		b43_phy_write(dev, B43_PHY_OTABLECTL, addr);
-		phy->ofdm_valid = 1;
+		phy->ofdmtab_addr_direction = B43_OFDMTAB_DIRECTION_READ;
 	}
-	phy->ofdm_addr = addr;
+	phy->ofdmtab_addr = addr;
 
 	return b43_phy_read(dev, B43_PHY_OTABLEI);
+
+	/* Some compiletime assertions... */
 	assert_sizes();
 }
 
@@ -398,11 +402,13 @@
 	u16 addr;
 
 	addr = table + offset;
-	if (addr - 1 != phy->ofdm_addr || phy->ofdm_valid != 2) {
+	if ((phy->ofdmtab_addr_direction != B43_OFDMTAB_DIRECTION_WRITE) ||
+	    (addr -1 != phy->ofdmtab_addr)) {
+		/* The hardware has a different address in memory. Update it. */
 		b43_phy_write(dev, B43_PHY_OTABLECTL, addr);
-		phy->ofdm_valid = 2;
+		phy->ofdmtab_addr_direction = B43_OFDMTAB_DIRECTION_WRITE;
 	}
-	phy->ofdm_addr = addr;
+	phy->ofdmtab_addr = addr;
 	b43_phy_write(dev, B43_PHY_OTABLEI, value);
 }
 
@@ -413,11 +419,13 @@
 	u16 addr;
 
 	addr = table + offset;
-	if (addr - 1 != phy->ofdm_addr || phy->ofdm_valid != 1) {
+	if ((phy->ofdmtab_addr_direction != B43_OFDMTAB_DIRECTION_READ) ||
+	    (addr - 1 != phy->ofdmtab_addr)) {
+		/* The hardware has a different address in memory. Update it. */
 		b43_phy_write(dev, B43_PHY_OTABLECTL, addr);
-		phy->ofdm_valid = 1;
+		phy->ofdmtab_addr_direction = B43_OFDMTAB_DIRECTION_READ;
 	}
-	phy->ofdm_addr = addr;
+	phy->ofdmtab_addr = addr;
 	ret = b43_phy_read(dev, B43_PHY_OTABLEQ);
 	ret <<= 16;
 	ret |= b43_phy_read(dev, B43_PHY_OTABLEI);
@@ -432,13 +440,16 @@
 	u16 addr;
 
 	addr = table + offset;
-	if (addr - 1 != phy->ofdm_addr || phy->ofdm_valid != 2) {
+	if ((phy->ofdmtab_addr_direction != B43_OFDMTAB_DIRECTION_WRITE) ||
+	    (addr - 1 != phy->ofdmtab_addr)) {
+		/* The hardware has a different address in memory. Update it. */
 		b43_phy_write(dev, B43_PHY_OTABLECTL, addr);
-		phy->ofdm_valid = 2;
+		phy->ofdmtab_addr_direction = B43_OFDMTAB_DIRECTION_WRITE;
 	}
-	phy->ofdm_addr = addr;
+	phy->ofdmtab_addr = addr;
 
 	b43_phy_write(dev, B43_PHY_OTABLEI, value);
+	b43_phy_write(dev, B43_PHY_OTABLEQ, (value >> 16));
 }
 
 u16 b43_gtab_read(struct b43_wldev *dev, u16 table, u16 offset)

-- 
Greetings Michael.

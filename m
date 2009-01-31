Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43901 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZAaP6g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 10:58:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Add LP-PHY baseband init for >=rev2
Date: Sat, 31 Jan 2009 16:52:29 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901311652.30074.mb@bu3sch.de> (sfid-20090131_165841_799063_FEB699A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds code for the baseband init of LP-PHY >=2.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/net/wireless/b43/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Makefile	2009-01-31 16:16:57.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/Makefile	2009-01-31 16:17:18.000000000 +0100
@@ -6,6 +6,7 @@ b43-y				+= phy_g.o
 b43-y				+= phy_a.o
 b43-$(CONFIG_B43_NPHY)		+= phy_n.o
 b43-$(CONFIG_B43_PHY_LP)	+= phy_lp.o
+b43-$(CONFIG_B43_PHY_LP)	+= tables_lpphy.o
 b43-y				+= sysfs.o
 b43-y				+= xmit.o
 b43-y				+= lo.o
Index: wireless-testing/drivers/net/wireless/b43/phy_lp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_lp.c	2009-01-31 14:28:05.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.c	2009-01-31 16:45:19.000000000 +0100
@@ -3,7 +3,7 @@
   Broadcom B43 wireless driver
   IEEE 802.11g LP-PHY driver
 
-  Copyright (c) 2008 Michael Buesch <mb@bu3sch.de>
+  Copyright (c) 2008-2009 Michael Buesch <mb@bu3sch.de>
 
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
@@ -25,6 +25,7 @@
 #include "b43.h"
 #include "phy_lp.h"
 #include "phy_common.h"
+#include "tables_lpphy.h"
 
 
 static int b43_lpphy_op_allocate(struct b43_wldev *dev)
@@ -69,7 +70,80 @@ static void lpphy_baseband_rev0_1_init(s
 
 static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 {
-	//TODO
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+
+	b43_phy_write(dev, B43_LPPHY_AFE_DAC_CTL, 0x50);
+	b43_phy_write(dev, B43_LPPHY_AFE_CTL, 0x8800);
+	b43_phy_write(dev, B43_LPPHY_AFE_CTL_OVR, 0);
+	b43_phy_write(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0);
+	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_0, 0);
+	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_2, 0);
+	b43_phy_write(dev, B43_PHY_OFDM(0xF9), 0);
+	b43_phy_write(dev, B43_LPPHY_TR_LOOKUP_1, 0);
+	b43_phy_set(dev, B43_LPPHY_ADC_COMPENSATION_CTL, 0x10);
+	b43_phy_maskset(dev, B43_LPPHY_OFDMSYNCTHRESH0, 0xFF00, 0x78);
+	b43_phy_maskset(dev, B43_LPPHY_DCOFFSETTRANSIENT, 0xF8FF, 0x200);
+	b43_phy_maskset(dev, B43_LPPHY_DCOFFSETTRANSIENT, 0xFF00, 0x7F);
+	b43_phy_maskset(dev, B43_LPPHY_GAINDIRECTMISMATCH, 0xFF0F, 0x40);
+	b43_phy_maskset(dev, B43_LPPHY_PREAMBLECONFIRMTO, 0xFF00, 0x2);
+	b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, ~0x4000);
+	b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, ~0x2000);
+	b43_phy_set(dev, B43_PHY_OFDM(0x10A), 0x1);
+	b43_phy_maskset(dev, B43_LPPHY_CCKLMSSTEPSIZE, 0xFF01, 0x10);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0xDF), 0xFF00, 0xF4);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0xDF), 0x00FF, 0xF100);//FIXME specs are different
+	b43_phy_write(dev, B43_LPPHY_CLIPTHRESH, 0x48);
+	b43_phy_maskset(dev, B43_LPPHY_HIGAINDB, 0xFF00, 0x46);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0xE4), 0xFF00, 0x10);
+	b43_phy_maskset(dev, B43_LPPHY_PWR_THRESH1, 0xFFF0, 0x9);
+	b43_phy_mask(dev, B43_LPPHY_GAINDIRECTMISMATCH, ~0xF);
+	b43_phy_maskset(dev, B43_LPPHY_VERYLOWGAINDB, 0x00FF, 0x5500);
+	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xF81F, 0xA0);
+	b43_phy_maskset(dev, B43_LPPHY_GAINDIRECTMISMATCH, 0xE0FF, 0x300);
+	b43_phy_maskset(dev, B43_LPPHY_HIGAINDB, 0x00FF, 0x2A00);
+	b43_phy_maskset(dev, B43_LPPHY_LOWGAINDB, 0x00FF, 0x1E00);
+	b43_phy_maskset(dev, B43_LPPHY_VERYLOWGAINDB, 0xFF00, 0xD);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0xFE), 0xFFE0, 0x1F);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0xFF), 0xFFE0, 0xC);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x100), 0xFF00, 0x19);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0xFF), 0x03FF, 0x3C00);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0xFE), 0xFC1F, 0x3E0);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0xFF), 0xFFE0, 0xC);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x100), 0x00FF, 0x1900);
+	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0x83FF, 0x5800);
+	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xFFE0, 0x12);
+	b43_phy_maskset(dev, B43_LPPHY_GAINMISMATCH, 0x0FFF, 0x9000);
+
+	if (dev->phy.rev < 2) {
+		//FIXME this will never execute.
+
+		//FIXME 32bit?
+		b43_lptab_write(dev, B43_LPTAB32(0x11, 0x14), 0);
+		b43_lptab_write(dev, B43_LPTAB32(0x08, 0x12), 0x40);
+	} else {
+		//FIXME 32bit?
+		b43_lptab_write(dev, B43_LPTAB32(0x08, 0x14), 0);
+		b43_lptab_write(dev, B43_LPTAB32(0x08, 0x12), 0x40);
+	}
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x40);
+		b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xF0FF, 0xB00);
+		b43_phy_maskset(dev, B43_LPPHY_SYNCPEAKCNT, 0xFFF8, 0x6);
+		b43_phy_maskset(dev, B43_LPPHY_MINPWR_LEVEL, 0x00FF, 0x9D00);
+		b43_phy_maskset(dev, B43_LPPHY_MINPWR_LEVEL, 0xFF00, 0xA1);
+	} else /* 5GHz */
+		b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, ~0x40);
+
+	b43_phy_maskset(dev, B43_LPPHY_CRS_ED_THRESH, 0xFF00, 0xB3);
+	b43_phy_maskset(dev, B43_LPPHY_CRS_ED_THRESH, 0x00FF, 0xAD00);
+	b43_phy_maskset(dev, B43_LPPHY_INPUT_PWRDB, 0xFF00, lpphy->rx_pwr_offset);
+	b43_phy_set(dev, B43_LPPHY_RESET_CTL, 0x44);
+	b43_phy_write(dev, B43_LPPHY_RESET_CTL, 0x80);
+	b43_phy_write(dev, B43_LPPHY_AFE_RSSI_CTL_0, 0xA954);
+	b43_phy_write(dev, B43_LPPHY_AFE_RSSI_CTL_1,
+		      0x2000 | ((u16)lpphy->rssi_gs << 10) |
+		      ((u16)lpphy->rssi_vc << 4) | lpphy->rssi_vf);
 }
 
 static void lpphy_baseband_init(struct b43_wldev *dev)
Index: wireless-testing/drivers/net/wireless/b43/phy_lp.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_lp.h	2009-01-31 14:29:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.h	2009-01-31 15:50:31.000000000 +0100
@@ -803,7 +803,47 @@
 
 
 struct b43_phy_lp {
-	//TODO
+	/* Transmit isolation medium band */
+	u8 tx_isolation_med_band; /* FIXME initial value? */
+	/* Transmit isolation low band */
+	u8 tx_isolation_low_band; /* FIXME initial value? */
+	/* Transmit isolation high band */
+	u8 tx_isolation_hi_band; /* FIXME initial value? */
+
+	/* Receive power offset */
+	u8 rx_pwr_offset; /* FIXME initial value? */
+
+	/* TSSI transmit count */
+	u16 tssi_tx_count; /* FIXME initial value? */
+	/* TSSI index */
+	u16 tssi_idx; /* FIXME initial value? */
+	/* TSSI npt */
+	u16 tssi_npt; /* FIXME initial value? */
+
+	/* Target TX frequency */
+	u16 tgt_tx_freq; /* FIXME initial value? */
+
+	/* Transmit power index override */
+	s8 tx_pwr_idx_over; /* FIXME initial value? */
+
+	/* RSSI vf */
+	u8 rssi_vf; /* FIXME initial value? */
+	/* RSSI vc */
+	u8 rssi_vc; /* FIXME initial value? */
+	/* RSSI gs */
+	u8 rssi_gs; /* FIXME initial value? */
+
+	/* RC cap */
+	u8 rc_cap; /* FIXME initial value? */
+	/* BX arch */
+	u8 bx_arch; /* FIXME initial value? */
+
+	/* Full calibration channel */
+	u8 full_calib_chan; /* FIXME initial value? */
+
+	/* Transmit iqlocal best coeffs */
+	bool tx_iqloc_best_coeffs_valid;
+	u8 tx_iqloc_best_coeffs[11];
 };
 
 
Index: wireless-testing/drivers/net/wireless/b43/tables_lpphy.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/drivers/net/wireless/b43/tables_lpphy.c	2009-01-31 16:35:19.000000000 +0100
@@ -0,0 +1,89 @@
+/*
+
+  Broadcom B43 wireless driver
+  IEEE 802.11g LP-PHY and radio device data tables
+
+  Copyright (c) 2009 Michael Buesch <mb@bu3sch.de>
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
+#include "tables_lpphy.h"
+#include "phy_common.h"
+#include "phy_lp.h"
+
+
+u32 b43_lptab_read(struct b43_wldev *dev, u32 offset)
+{
+	u32 type, value;
+
+	type = offset & B43_LPTAB_TYPEMASK;
+	offset &= ~B43_LPTAB_TYPEMASK;
+	B43_WARN_ON(offset > 0xFFFF);
+
+	switch (type) {
+	case B43_LPTAB_8BIT:
+		b43_phy_write(dev, B43_LPPHY_TABLE_ADDR, offset);
+		value = b43_phy_read(dev, B43_LPPHY_TABLEDATALO) & 0xFF;
+		break;
+	case B43_LPTAB_16BIT:
+		b43_phy_write(dev, B43_LPPHY_TABLE_ADDR, offset);
+		value = b43_phy_read(dev, B43_LPPHY_TABLEDATALO);
+		break;
+	case B43_LPTAB_32BIT:
+		b43_phy_write(dev, B43_LPPHY_TABLE_ADDR, offset);
+		value = b43_phy_read(dev, B43_LPPHY_TABLEDATAHI);
+		value <<= 16;
+		value |= b43_phy_read(dev, B43_LPPHY_TABLEDATALO);
+		break;
+	default:
+		B43_WARN_ON(1);
+		value = 0;
+	}
+
+	return value;
+}
+
+void b43_lptab_write(struct b43_wldev *dev, u32 offset, u32 value)
+{
+	u32 type;
+
+	type = offset & B43_LPTAB_TYPEMASK;
+	offset &= ~B43_LPTAB_TYPEMASK;
+	B43_WARN_ON(offset > 0xFFFF);
+
+	switch (type) {
+	case B43_LPTAB_8BIT:
+		B43_WARN_ON(value & ~0xFF);
+		b43_phy_write(dev, B43_LPPHY_TABLE_ADDR, offset);
+		b43_phy_write(dev, B43_LPPHY_TABLEDATALO, value);
+		break;
+	case B43_LPTAB_16BIT:
+		B43_WARN_ON(value & ~0xFFFF);
+		b43_phy_write(dev, B43_LPPHY_TABLE_ADDR, offset);
+		b43_phy_write(dev, B43_LPPHY_TABLEDATALO, value);
+		break;
+	case B43_LPTAB_32BIT:
+		b43_phy_write(dev, B43_LPPHY_TABLE_ADDR, offset);
+		b43_phy_write(dev, B43_LPPHY_TABLEDATAHI, value >> 16);
+		b43_phy_write(dev, B43_LPPHY_TABLEDATALO, value);
+		break;
+	default:
+		B43_WARN_ON(1);
+	}
+}
Index: wireless-testing/drivers/net/wireless/b43/tables_lpphy.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/drivers/net/wireless/b43/tables_lpphy.h	2009-01-31 16:40:33.000000000 +0100
@@ -0,0 +1,21 @@
+#ifndef B43_TABLES_LPPHY_H_
+#define B43_TABLES_LPPHY_H_
+
+
+#define B43_LPTAB_TYPEMASK		0xF0000000
+#define B43_LPTAB_8BIT			0x10000000
+#define B43_LPTAB_16BIT			0x20000000
+#define B43_LPTAB_32BIT			0x30000000
+#define B43_LPTAB8(table, offset)	(((table) << 10) | (offset) | B43_LPTAB_8BIT)
+#define B43_LPTAB16(table, offset)	(((table) << 10) | (offset) | B43_LPTAB_16BIT)
+#define B43_LPTAB32(table, offset)	(((table) << 10) | (offset) | B43_LPTAB_32BIT)
+
+/* Table definitions */
+#define B43_LPTAB_TXPWR_R2PLUS		B43_LPTAB32(0x07, 0) /* TX power lookup table (rev >= 2) */
+#define B43_LPTAB_TXPWR_R0_1		B43_LPTAB32(0xA0, 0) /* TX power lookup table (rev < 2) */
+
+u32 b43_lptab_read(struct b43_wldev *dev, u32 offset);
+void b43_lptab_write(struct b43_wldev *dev, u32 offset, u32 value);
+
+
+#endif /* B43_TABLES_LPPHY_H_ */

-- 
Greetings, Michael.

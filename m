Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55168 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761329AbZBDS5F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 13:57:05 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Add parts of LP-PHY TX power control
Date: Wed, 4 Feb 2009 19:55:22 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200902041955.22517.mb@bu3sch.de> (sfid-20090204_195714_022159_4A1ADFB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the initial parts of the LP-PHY TX power control.
This also adds helper functions for bulk access of LP tables.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-02-04 19:45:13.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-02-04 19:47:39.000000000 +0100
@@ -120,6 +120,9 @@
 #define B43_MMIO_IFSCTL			0x688 /* Interframe space control */
 #define  B43_MMIO_IFSCTL_USE_EDCF	0x0004
 #define B43_MMIO_POWERUP_DELAY		0x6A8
+#define B43_MMIO_BTCOEX_CTL		0x6B4 /* Bluetooth Coexistence Control */
+#define B43_MMIO_BTCOEX_STAT		0x6B6 /* Bluetooth Coexistence Status */
+#define B43_MMIO_BTCOEX_TXCTL		0x6B8 /* Bluetooth Coexistence Transmit Control */
 
 /* SPROM boardflags_lo values */
 #define B43_BFL_BTCOEXIST		0x0001	/* implements Bluetooth coexistance */
Index: wireless-testing/drivers/net/wireless/b43/phy_lp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_lp.c	2009-02-04 19:45:13.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.c	2009-02-04 19:47:39.000000000 +0100
@@ -23,6 +23,7 @@
 */
 
 #include "b43.h"
+#include "main.h"
 #include "phy_lp.h"
 #include "phy_common.h"
 #include "tables_lpphy.h"
@@ -267,13 +268,185 @@ static void lpphy_radio_init(struct b43_
 	}
 }
 
+/* Read the TX power control mode from hardware. */
+static void lpphy_read_tx_pctl_mode_from_hardware(struct b43_wldev *dev)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+	u16 ctl;
+
+	ctl = b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_CMD);
+	switch (ctl & B43_LPPHY_TX_PWR_CTL_CMD_MODE) {
+	case B43_LPPHY_TX_PWR_CTL_CMD_MODE_OFF:
+		lpphy->txpctl_mode = B43_LPPHY_TXPCTL_OFF;
+		break;
+	case B43_LPPHY_TX_PWR_CTL_CMD_MODE_SW:
+		lpphy->txpctl_mode = B43_LPPHY_TXPCTL_SW;
+		break;
+	case B43_LPPHY_TX_PWR_CTL_CMD_MODE_HW:
+		lpphy->txpctl_mode = B43_LPPHY_TXPCTL_HW;
+		break;
+	default:
+		lpphy->txpctl_mode = B43_LPPHY_TXPCTL_UNKNOWN;
+		B43_WARN_ON(1);
+		break;
+	}
+}
+
+/* Set the TX power control mode in hardware. */
+static void lpphy_write_tx_pctl_mode_to_hardware(struct b43_wldev *dev)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+	u16 ctl;
+
+	switch (lpphy->txpctl_mode) {
+	case B43_LPPHY_TXPCTL_OFF:
+		ctl = B43_LPPHY_TX_PWR_CTL_CMD_MODE_OFF;
+		break;
+	case B43_LPPHY_TXPCTL_HW:
+		ctl = B43_LPPHY_TX_PWR_CTL_CMD_MODE_HW;
+		break;
+	case B43_LPPHY_TXPCTL_SW:
+		ctl = B43_LPPHY_TX_PWR_CTL_CMD_MODE_SW;
+		break;
+	default:
+		ctl = 0;
+		B43_WARN_ON(1);
+	}
+	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_CMD,
+			(u16)~B43_LPPHY_TX_PWR_CTL_CMD_MODE, ctl);
+}
+
+static void lpphy_set_tx_power_control(struct b43_wldev *dev,
+				       enum b43_lpphy_txpctl_mode mode)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+	enum b43_lpphy_txpctl_mode oldmode;
+
+	oldmode = lpphy->txpctl_mode;
+	lpphy_read_tx_pctl_mode_from_hardware(dev);
+	if (lpphy->txpctl_mode == mode)
+		return;
+	lpphy->txpctl_mode = mode;
+
+	if (oldmode == B43_LPPHY_TXPCTL_HW) {
+		//TODO Update TX Power NPT
+		//TODO Clear all TX Power offsets
+	} else {
+		if (mode == B43_LPPHY_TXPCTL_HW) {
+			//TODO Recalculate target TX power
+			b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_CMD,
+					0xFF80, lpphy->tssi_idx);
+			b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_NNUM,
+					0x8FFF, ((u16)lpphy->tssi_npt << 16));
+			//TODO Set "TSSI Transmit Count" variable to total transmitted frame count
+			//TODO Disable TX gain override
+			lpphy->tx_pwr_idx_over = -1;
+		}
+	}
+	if (dev->phy.rev >= 2) {
+		if (mode == B43_LPPHY_TXPCTL_HW)
+			b43_phy_maskset(dev, B43_PHY_OFDM(0xD0), 0xFD, 0x2);
+		else
+			b43_phy_maskset(dev, B43_PHY_OFDM(0xD0), 0xFD, 0);
+	}
+	lpphy_write_tx_pctl_mode_to_hardware(dev);
+}
+
+static void lpphy_set_tx_power_by_index(struct b43_wldev *dev, u8 index)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+
+	lpphy->tx_pwr_idx_over = index;
+	if (lpphy->txpctl_mode != B43_LPPHY_TXPCTL_OFF)
+		lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_SW);
+
+	//TODO
+}
+
+static void lpphy_btcoex_override(struct b43_wldev *dev)
+{
+	b43_write16(dev, B43_MMIO_BTCOEX_CTL, 0x3);
+	b43_write16(dev, B43_MMIO_BTCOEX_TXCTL, 0xFF);
+}
+
+static void lpphy_pr41573_workaround(struct b43_wldev *dev)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+	u32 *saved_tab;
+	const unsigned int saved_tab_size = 256;
+	enum b43_lpphy_txpctl_mode txpctl_mode;
+	s8 tx_pwr_idx_over;
+	u16 tssi_npt, tssi_idx;
+
+	saved_tab = kcalloc(saved_tab_size, sizeof(saved_tab[0]), GFP_KERNEL);
+	if (!saved_tab) {
+		b43err(dev->wl, "PR41573 failed. Out of memory!\n");
+		return;
+	}
+
+	lpphy_read_tx_pctl_mode_from_hardware(dev);
+	txpctl_mode = lpphy->txpctl_mode;
+	tx_pwr_idx_over = lpphy->tx_pwr_idx_over;
+	tssi_npt = lpphy->tssi_npt;
+	tssi_idx = lpphy->tssi_idx;
+
+	if (dev->phy.rev < 2) {
+		b43_lptab_read_bulk(dev, B43_LPTAB32(10, 0x140),
+				    saved_tab_size, saved_tab);
+	} else {
+		b43_lptab_read_bulk(dev, B43_LPTAB32(7, 0x140),
+				    saved_tab_size, saved_tab);
+	}
+	//TODO
+
+	kfree(saved_tab);
+}
+
+static void lpphy_calibration(struct b43_wldev *dev)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+	enum b43_lpphy_txpctl_mode saved_pctl_mode;
+
+	b43_mac_suspend(dev);
+
+	lpphy_btcoex_override(dev);
+	lpphy_read_tx_pctl_mode_from_hardware(dev);
+	saved_pctl_mode = lpphy->txpctl_mode;
+	lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
+	//TODO Perform transmit power table I/Q LO calibration
+	if ((dev->phy.rev == 0) && (saved_pctl_mode != B43_LPPHY_TXPCTL_OFF))
+		lpphy_pr41573_workaround(dev);
+	//TODO If a full calibration has not been performed on this channel yet, perform PAPD TX-power calibration
+	lpphy_set_tx_power_control(dev, saved_pctl_mode);
+	//TODO Perform I/Q calibration with a single control value set
+
+	b43_mac_enable(dev);
+}
+
+/* Initialize TX power control */
+static void lpphy_tx_pctl_init(struct b43_wldev *dev)
+{
+	if (0/*FIXME HWPCTL capable */) {
+		//TODO
+	} else { /* This device is only software TX power control capable. */
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			//TODO
+		} else {
+			//TODO
+		}
+		//TODO set BB multiplier to 0x0096
+	}
+}
+
 static int b43_lpphy_op_init(struct b43_wldev *dev)
 {
 	/* TODO: band SPROM */
 	lpphy_baseband_init(dev);
 	lpphy_radio_init(dev);
-
-	//TODO
+	//TODO calibrate RC
+	//TODO set channel
+	lpphy_tx_pctl_init(dev);
+	//TODO full calib
 
 	return 0;
 }
Index: wireless-testing/drivers/net/wireless/b43/phy_lp.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_lp.h	2009-02-04 19:45:13.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.h	2009-02-04 19:47:39.000000000 +0100
@@ -247,6 +247,10 @@
 #define B43_LPPHY_FOURWIRE_CTL			B43_PHY_OFDM(0xA2) /* fourwire Control */
 #define B43_LPPHY_CPA_TAILCOUNT_VAL		B43_PHY_OFDM(0xA3) /* CPA TailCount Value */
 #define B43_LPPHY_TX_PWR_CTL_CMD		B43_PHY_OFDM(0xA4) /* TX Power Control Cmd */
+#define  B43_LPPHY_TX_PWR_CTL_CMD_MODE		0xE000 /* TX power control mode mask */
+#define   B43_LPPHY_TX_PWR_CTL_CMD_MODE_OFF	0x0000 /* TX power control is OFF */
+#define   B43_LPPHY_TX_PWR_CTL_CMD_MODE_SW	0x8000 /* TX power control is SOFTWARE */
+#define   B43_LPPHY_TX_PWR_CTL_CMD_MODE_HW	0xE000 /* TX power control is HARDWARE */
 #define B43_LPPHY_TX_PWR_CTL_NNUM		B43_PHY_OFDM(0xA5) /* TX Power Control Nnum */
 #define B43_LPPHY_TX_PWR_CTL_IDLETSSI		B43_PHY_OFDM(0xA6) /* TX Power Control IdleTssi */
 #define B43_LPPHY_TX_PWR_CTL_TARGETPWR		B43_PHY_OFDM(0xA7) /* TX Power Control TargetPower */
@@ -802,7 +806,17 @@
 
 
 
+enum b43_lpphy_txpctl_mode {
+	B43_LPPHY_TXPCTL_UNKNOWN = 0,
+	B43_LPPHY_TXPCTL_OFF,	/* TX power control is OFF */
+	B43_LPPHY_TXPCTL_SW,	/* TX power control is set to Software */
+	B43_LPPHY_TXPCTL_HW,	/* TX power control is set to Hardware */
+};
+
 struct b43_phy_lp {
+	/* Current TX power control mode. */
+	enum b43_lpphy_txpctl_mode txpctl_mode;
+
 	/* Transmit isolation medium band */
 	u8 tx_isolation_med_band; /* FIXME initial value? */
 	/* Transmit isolation low band */
@@ -814,7 +828,7 @@ struct b43_phy_lp {
 	u8 rx_pwr_offset; /* FIXME initial value? */
 
 	/* TSSI transmit count */
-	u16 tssi_tx_count; /* FIXME initial value? */
+	u16 tssi_tx_count;
 	/* TSSI index */
 	u16 tssi_idx; /* FIXME initial value? */
 	/* TSSI npt */
Index: wireless-testing/drivers/net/wireless/b43/tables_lpphy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/tables_lpphy.c	2009-02-04 19:45:13.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/tables_lpphy.c	2009-02-04 19:47:39.000000000 +0100
@@ -303,6 +303,36 @@ u32 b43_lptab_read(struct b43_wldev *dev
 	return value;
 }
 
+void b43_lptab_read_bulk(struct b43_wldev *dev, u32 offset,
+			 unsigned int nr_elements, void *_data)
+{
+	u32 type, value;
+	u8 *data = _data;
+	unsigned int i;
+
+	type = offset & B43_LPTAB_TYPEMASK;
+	for (i = 0; i < nr_elements; i++) {
+		value = b43_lptab_read(dev, offset);
+		switch (type) {
+		case B43_LPTAB_8BIT:
+			*data = value;
+			data++;
+			break;
+		case B43_LPTAB_16BIT:
+			*((u16 *)data) = value;
+			data += 2;
+			break;
+		case B43_LPTAB_32BIT:
+			*((u32 *)data) = value;
+			data += 4;
+			break;
+		default:
+			B43_WARN_ON(1);
+		}
+		offset++;
+	}
+}
+
 void b43_lptab_write(struct b43_wldev *dev, u32 offset, u32 value)
 {
 	u32 type;
@@ -331,3 +361,34 @@ void b43_lptab_write(struct b43_wldev *d
 		B43_WARN_ON(1);
 	}
 }
+
+void b43_lptab_write_bulk(struct b43_wldev *dev, u32 offset,
+			  unsigned int nr_elements, const void *_data)
+{
+	u32 type, value;
+	const u8 *data = _data;
+	unsigned int i;
+
+	type = offset & B43_LPTAB_TYPEMASK;
+	for (i = 0; i < nr_elements; i++) {
+		switch (type) {
+		case B43_LPTAB_8BIT:
+			value = *data;
+			data++;
+			break;
+		case B43_LPTAB_16BIT:
+			value = *((u16 *)data);
+			data += 2;
+			break;
+		case B43_LPTAB_32BIT:
+			value = *((u32 *)data);
+			data += 4;
+			break;
+		default:
+			B43_WARN_ON(1);
+			value = 0;
+		}
+		b43_lptab_write(dev, offset, value);
+		offset++;
+	}
+}
Index: wireless-testing/drivers/net/wireless/b43/tables_lpphy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/tables_lpphy.h	2009-02-04 19:45:13.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/tables_lpphy.h	2009-02-04 19:47:39.000000000 +0100
@@ -17,6 +17,14 @@
 u32 b43_lptab_read(struct b43_wldev *dev, u32 offset);
 void b43_lptab_write(struct b43_wldev *dev, u32 offset, u32 value);
 
+/* Bulk table access. Note that these functions return the bulk data in
+ * host endianness! The returned data is _not_ a bytearray, but an array
+ * consisting of nr_elements of the data type. */
+void b43_lptab_read_bulk(struct b43_wldev *dev, u32 offset,
+			 unsigned int nr_elements, void *data);
+void b43_lptab_write_bulk(struct b43_wldev *dev, u32 offset,
+			  unsigned int nr_elements, const void *data);
+
 void b2062_upload_init_table(struct b43_wldev *dev);
 
 

-- 
Greetings, Michael.

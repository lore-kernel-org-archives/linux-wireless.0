Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:36224 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbYAISM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 13:12:59 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Remove the PHY spinlock
Date: Wed, 9 Jan 2008 19:08:49 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801091908.49491.mb@bu3sch.de> (sfid-20080109_181306_746963_157D390F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a sparse warning about weird locking.
The spinlock is not needed, so simply remove it.
This also adds some sanity checks to the PHY and radio locking
to protect against recursive locking.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.25


Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2008-01-09 17:06:34.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2008-01-09 18:56:51.000000000 +0100
@@ -477,13 +477,12 @@ struct b43_phy {
 
 	/* Radio versioning */
 	u16 radio_manuf;	/* Radio manufacturer */
 	u16 radio_ver;		/* Radio version */
 	u8 radio_rev;		/* Radio revision */
 
-	bool locked;		/* Only used in b43_phy_{un}lock() */
 	bool dyn_tssi_tbl;	/* tssi2dbm is kmalloc()ed. */
 
 	/* ACI (adjacent channel interference) flags. */
 	bool aci_enable;
 	bool aci_wlan_automatic;
 	bool aci_hw_rssi;
@@ -514,30 +513,23 @@ struct b43_phy {
 	s16 max_lb_gain;	/* Maximum Loopback gain in hdB */
 	s16 trsw_rx_gain;	/* TRSW RX gain in hdB */
 	s16 lna_lod_gain;	/* LNA lod */
 	s16 lna_gain;		/* LNA */
 	s16 pga_gain;		/* PGA */
 
-	/* PHY lock for core.rev < 3
-	 * This lock is only used by b43_phy_{un}lock()
-	 */
-	spinlock_t lock;
-
 	/* Desired TX power level (in dBm).
 	 * This is set by the user and adjusted in b43_phy_xmitpower(). */
 	u8 power_level;
 	/* A-PHY TX Power control value. */
 	u16 txpwr_offset;
 
 	/* Current TX power level attenuation control values */
 	struct b43_bbatt bbatt;
 	struct b43_rfatt rfatt;
 	u8 tx_control;		/* B43_TXCTL_XXX */
-#ifdef CONFIG_B43_DEBUG
-	bool manual_txpower_control;	/* Manual TX-power control enabled? */
-#endif
+
 	/* Hardware Power Control enabled? */
 	bool hardware_power_control;
 
 	/* Current Interference Mitigation mode */
 	int interfmode;
 	/* Stack of saved values from the Interference Mitigation code.
@@ -572,12 +564,19 @@ struct b43_phy {
 	u16 ofdmtab_addr; /* The address currently set in hardware. */
 	enum { /* The last data flow direction. */
 		B43_OFDMTAB_DIRECTION_UNKNOWN = 0,
 		B43_OFDMTAB_DIRECTION_READ,
 		B43_OFDMTAB_DIRECTION_WRITE,
 	} ofdmtab_addr_direction;
+
+#if B43_DEBUG
+	/* Manual TX-power control enabled? */
+	bool manual_txpower_control;
+	/* PHY registers locked by b43_phy_lock()? */
+	bool phy_locked;
+#endif /* B43_DEBUG */
 };
 
 /* Data structures for DMA transmission, per 80211 core. */
 struct b43_dma {
 	struct b43_dmaring *tx_ring0;
 	struct b43_dmaring *tx_ring1;
Index: wireless-2.6/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/debugfs.c	2008-01-09 16:59:33.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/debugfs.c	2008-01-09 18:58:43.000000000 +0100
@@ -219,14 +219,12 @@ out:
 	return count;
 }
 
 static int txpower_g_write_file(struct b43_wldev *dev,
 				const char *buf, size_t count)
 {
-	unsigned long phy_flags;
-
 	if (dev->phy.type != B43_PHYTYPE_G)
 		return -ENODEV;
 	if ((count >= 4) && (memcmp(buf, "auto", 4) == 0)) {
 		/* Automatic control */
 		dev->phy.manual_txpower_control = 0;
 		b43_phy_xmitpower(dev);
@@ -244,18 +242,18 @@ static int txpower_g_write_file(struct b
 		if (txmix)
 			dev->phy.tx_control |= B43_TXCTL_TXMIX;
 		if (pa2db)
 			dev->phy.tx_control |= B43_TXCTL_PA2DB;
 		if (pa3db)
 			dev->phy.tx_control |= B43_TXCTL_PA3DB;
-		b43_phy_lock(dev, phy_flags);
+		b43_phy_lock(dev);
 		b43_radio_lock(dev);
 		b43_set_txpower_g(dev, &dev->phy.bbatt,
 				  &dev->phy.rfatt, dev->phy.tx_control);
 		b43_radio_unlock(dev);
-		b43_phy_unlock(dev, phy_flags);
+		b43_phy_unlock(dev);
 	}
 
 	return 0;
 }
 
 /* wl->irq_lock is locked */
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2008-01-09 17:06:34.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2008-01-09 18:59:36.000000000 +0100
@@ -3199,15 +3199,12 @@ static void setup_struct_phy_for_init(st
 	struct b43_txpower_lo_control *lo;
 	int i;
 
 	memset(phy->minlowsig, 0xFF, sizeof(phy->minlowsig));
 	memset(phy->minlowsigpos, 0, sizeof(phy->minlowsigpos));
 
-	/* Flags */
-	phy->locked = 0;
-
 	phy->aci_enable = 0;
 	phy->aci_wlan_automatic = 0;
 	phy->aci_hw_rssi = 0;
 
 	phy->radio_off_context.valid = 0;
 
@@ -3228,13 +3225,12 @@ static void setup_struct_phy_for_init(st
 	for (i = 0; i < ARRAY_SIZE(phy->nrssi_lt); i++)
 		phy->nrssi_lt[i] = i;
 
 	phy->lofcal = 0xFFFF;
 	phy->initval = 0xFFFF;
 
-	spin_lock_init(&phy->lock);
 	phy->interfmode = B43_INTERFMODE_NONE;
 	phy->channel = 0xFF;
 
 	phy->hardware_power_control = !!modparam_hwpctl;
 
 	/* PHY TX errors counter. */
Index: wireless-2.6/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/phy.c	2008-01-09 18:30:13.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/phy.c	2008-01-09 19:02:54.000000000 +0100
@@ -225,48 +225,36 @@ static void b43_shm_clear_tssi(struct b4
 		b43_shm_write16(dev, B43_SHM_SHARED, 0x0070, 0x7F7F);
 		b43_shm_write16(dev, B43_SHM_SHARED, 0x0072, 0x7F7F);
 		break;
 	}
 }
 
-void b43_raw_phy_lock(struct b43_wldev *dev)
+/* Lock the PHY registers against concurrent access from the microcode.
+ * This lock is nonrecursive. */
+void b43_phy_lock(struct b43_wldev *dev)
 {
-	struct b43_phy *phy = &dev->phy;
-
-	B43_WARN_ON(!irqs_disabled());
-
-	/* We had a check for MACCTL==0 here, but I think that doesn't
-	 * make sense, as MACCTL is never 0 when this is called.
-	 *      --mb */
-	B43_WARN_ON(b43_read32(dev, B43_MMIO_MACCTL) == 0);
+#if B43_DEBUG
+	B43_WARN_ON(dev->phy.phy_locked);
+	dev->phy.phy_locked = 1;
+#endif
+	B43_WARN_ON(dev->dev->id.revision < 3);
 
-	if (dev->dev->id.revision < 3) {
-		b43_mac_suspend(dev);
-		spin_lock(&phy->lock);
-	} else {
-		if (!b43_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
-			b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
-	}
-	phy->locked = 1;
+	if (!b43_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
+		b43_power_saving_ctl_bits(dev, B43_PS_AWAKE);
 }
 
-void b43_raw_phy_unlock(struct b43_wldev *dev)
+void b43_phy_unlock(struct b43_wldev *dev)
 {
-	struct b43_phy *phy = &dev->phy;
+#if B43_DEBUG
+	B43_WARN_ON(!dev->phy.phy_locked);
+	dev->phy.phy_locked = 0;
+#endif
+	B43_WARN_ON(dev->dev->id.revision < 3);
 
-	B43_WARN_ON(!irqs_disabled());
-	if (dev->dev->id.revision < 3) {
-		if (phy->locked) {
-			spin_unlock(&phy->lock);
-			b43_mac_enable(dev);
-		}
-	} else {
-		if (!b43_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
-			b43_power_saving_ctl_bits(dev, 0);
-	}
-	phy->locked = 0;
+	if (!b43_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
+		b43_power_saving_ctl_bits(dev, 0);
 }
 
 /* Different PHYs require different register routing flags.
  * This adjusts (and does sanity checks on) the routing flags.
  */
 static inline u16 adjust_phyreg_for_phytype(struct b43_phy *phy,
@@ -1727,13 +1715,12 @@ void b43_phy_xmitpower(struct b43_wldev 
 			s8 average;
 			int max_pwr;
 			int desired_pwr, estimated_pwr, pwr_adjust;
 			int rfatt_delta, bbatt_delta;
 			int rfatt, bbatt;
 			u8 tx_control;
-			unsigned long phylock_flags;
 
 			tmp = b43_shm_read16(dev, B43_SHM_SHARED, 0x0058);
 			v0 = (s8) (tmp & 0x00FF);
 			v1 = (s8) ((tmp & 0xFF00) >> 8);
 			tmp = b43_shm_read16(dev, B43_SHM_SHARED, 0x005A);
 			v2 = (s8) (tmp & 0x00FF);
@@ -1858,19 +1845,19 @@ void b43_phy_xmitpower(struct b43_wldev 
 			phy->tx_control = tx_control;
 			b43_put_attenuation_into_ranges(dev, &bbatt, &rfatt);
 			phy->rfatt.att = rfatt;
 			phy->bbatt.att = bbatt;
 
 			/* Adjust the hardware */
-			b43_phy_lock(dev, phylock_flags);
+			b43_phy_lock(dev);
 			b43_radio_lock(dev);
 			b43_set_txpower_g(dev, &phy->bbatt, &phy->rfatt,
 					  phy->tx_control);
 			b43_lo_g_ctl_mark_cur_used(dev);
 			b43_radio_unlock(dev);
-			b43_phy_unlock(dev, phylock_flags);
+			b43_phy_unlock(dev);
 			break;
 		}
 	default:
 		B43_WARN_ON(1);
 	}
 }
@@ -2155,12 +2142,13 @@ static inline u16 channel2freq_a(u8 chan
 
 void b43_radio_lock(struct b43_wldev *dev)
 {
 	u32 macctl;
 
 	macctl = b43_read32(dev, B43_MMIO_MACCTL);
+	B43_WARN_ON(macctl & B43_MACCTL_RADIOLOCK);
 	macctl |= B43_MACCTL_RADIOLOCK;
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 	/* Commit the write and wait for the device
 	 * to exit any radio register access. */
 	b43_read32(dev, B43_MMIO_MACCTL);
 	udelay(10);
@@ -2171,12 +2159,13 @@ void b43_radio_unlock(struct b43_wldev *
 	u32 macctl;
 
 	/* Commit any write */
 	b43_read16(dev, B43_MMIO_PHY_VER);
 	/* unlock */
 	macctl = b43_read32(dev, B43_MMIO_MACCTL);
+	B43_WARN_ON(!(macctl & B43_MACCTL_RADIOLOCK));
 	macctl &= ~B43_MACCTL_RADIOLOCK;
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 }
 
 u16 b43_radio_read16(struct b43_wldev *dev, u16 offset)
 {
@@ -2352,18 +2341,17 @@ u8 b43_radio_aci_detect(struct b43_wldev
 u8 b43_radio_aci_scan(struct b43_wldev * dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	u8 ret[13];
 	unsigned int channel = phy->channel;
 	unsigned int i, j, start, end;
-	unsigned long phylock_flags;
 
 	if (!((phy->type == B43_PHYTYPE_G) && (phy->rev > 0)))
 		return 0;
 
-	b43_phy_lock(dev, phylock_flags);
+	b43_phy_lock(dev);
 	b43_radio_lock(dev);
 	b43_phy_write(dev, 0x0802, b43_phy_read(dev, 0x0802) & 0xFFFC);
 	b43_phy_write(dev, B43_PHY_G_CRS,
 		      b43_phy_read(dev, B43_PHY_G_CRS) & 0x7FFF);
 	b43_set_all_gains(dev, 3, 8, 1);
 
@@ -2386,13 +2374,13 @@ u8 b43_radio_aci_scan(struct b43_wldev *
 			continue;
 		end = (i + 5 < 13) ? i + 5 : 13;
 		for (j = i; j < end; j++)
 			ret[j] = 1;
 	}
 	b43_radio_unlock(dev);
-	b43_phy_unlock(dev, phylock_flags);
+	b43_phy_unlock(dev);
 
 	return ret[channel - 1];
 }
 
 /* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
 void b43_nrssi_hw_write(struct b43_wldev *dev, u16 offset, s16 val)
Index: wireless-2.6/drivers/net/wireless/b43/phy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/phy.h	2008-01-09 17:59:17.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/phy.h	2008-01-09 18:48:42.000000000 +0100
@@ -196,24 +196,14 @@ enum {
 #define B43_PHYVER_ANALOG		0xF000
 #define B43_PHYVER_ANALOG_SHIFT		12
 #define B43_PHYVER_TYPE			0x0F00
 #define B43_PHYVER_TYPE_SHIFT		8
 #define B43_PHYVER_VERSION		0x00FF
 
-void b43_raw_phy_lock(struct b43_wldev *dev);
-#define b43_phy_lock(dev, flags) \
-	do {					\
-		local_irq_save(flags);		\
-		b43_raw_phy_lock(dev);	\
-	} while (0)
-void b43_raw_phy_unlock(struct b43_wldev *dev);
-#define b43_phy_unlock(dev, flags) \
-	do {					\
-		b43_raw_phy_unlock(dev);	\
-		local_irq_restore(flags);	\
-	} while (0)
+void b43_phy_lock(struct b43_wldev *dev);
+void b43_phy_unlock(struct b43_wldev *dev);
 
 u16 b43_phy_read(struct b43_wldev *dev, u16 offset);
 void b43_phy_write(struct b43_wldev *dev, u16 offset, u16 val);
 
 int b43_phy_init_tssi2dbm_table(struct b43_wldev *dev);
 

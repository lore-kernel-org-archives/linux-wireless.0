Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:53615 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbYAITRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 14:17:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: [PATCH RFT] b43legacy: Remove the PHY spinlock
Date: Wed, 9 Jan 2008 20:15:31 +0100
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801092015.32042.mb@bu3sch.de> (sfid-20080109_191746_849486_E95D4819)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a sparse warning about weird locking.
The spinlock is not needed, so simply remove it.
This also adds some sanity checks to the PHY and radio locking
to protect against recursive locking.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch is only compiletime tested.


Index: wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/b43legacy.h	2007-12-20 18:53:57.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h	2008-01-09 19:56:43.000000000 +0100
@@ -412,13 +412,12 @@ struct b43legacy_phy {
 	/* Radio versioning */
 	u16 radio_manuf;	/* Radio manufacturer */
 	u16 radio_ver;		/* Radio version */
 	u8 calibrated:1;
 	u8 radio_rev;		/* Radio revision */
 
-	bool locked;		/* Only used in b43legacy_phy_{un}lock() */
 	bool dyn_tssi_tbl;	/* tssi2dbm is kmalloc()ed. */
 
 	/* ACI (adjacent channel interference) flags. */
 	bool aci_enable;
 	bool aci_wlan_automatic;
 	bool aci_hw_rssi;
@@ -455,17 +454,12 @@ struct b43legacy_phy {
 	s16 max_lb_gain;	/* Maximum Loopback gain in hdB */
 	s16 trsw_rx_gain;	/* TRSW RX gain in hdB */
 	s16 lna_lod_gain;	/* LNA lod */
 	s16 lna_gain;		/* LNA */
 	s16 pga_gain;		/* PGA */
 
-	/* PHY lock for core.rev < 3
-	 * This lock is only used by b43legacy_phy_{un}lock()
-	 */
-	spinlock_t lock;
-
 	/* Desired TX power level (in dBm). This is set by the user and
 	 * adjusted in b43legacy_phy_xmitpower(). */
 	u8 power_level;
 
 	/* Values from b43legacy_calc_loopback_gain() */
 	u16 loopback_gain[2];
@@ -483,15 +477,12 @@ struct b43legacy_phy {
 	};
 	/* A PHY */
 	struct {
 		u16 txpwr_offset;
 	};
 
-#ifdef CONFIG_B43LEGACY_DEBUG
-	bool manual_txpower_control; /* Manual TX-power control enabled? */
-#endif
 	/* Current Interference Mitigation mode */
 	int interfmode;
 	/* Stack of saved values from the Interference Mitigation code.
 	 * Each value in the stack is layed out as follows:
 	 * bit 0-11:  offset
 	 * bit 12-15: register ID
@@ -513,12 +504,19 @@ struct b43legacy_phy {
 	u16 lofcal;
 
 	u16 initval;
 
 	/* PHY TX errors counter. */
 	atomic_t txerr_cnt;
+
+#if B43legacy_DEBUG
+	/* Manual TX-power control enabled? */
+	bool manual_txpower_control;
+	/* PHY registers locked by b43legacy_phy_lock()? */
+	bool phy_locked;
+#endif /* B43legacy_DEBUG */
 };
 
 /* Data structures for DMA transmission, per 80211 core. */
 struct b43legacy_dma {
 	struct b43legacy_dmaring *tx_ring0;
 	struct b43legacy_dmaring *tx_ring1;
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c	2008-01-09 16:59:33.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c	2008-01-09 20:03:16.000000000 +0100
@@ -2844,14 +2844,12 @@ static void setup_struct_phy_for_init(st
 	struct b43legacy_lopair *lo;
 	int i;
 
 	memset(phy->minlowsig, 0xFF, sizeof(phy->minlowsig));
 	memset(phy->minlowsigpos, 0, sizeof(phy->minlowsigpos));
 
-	/* Flags */
-	phy->locked = 0;
 	/* Assume the radio is enabled. If it's not enabled, the state will
 	 * immediately get fixed on the first periodic work run. */
 	dev->radio_hw_enable = 1;
 
 	phy->savedpctlreg = 0xFFFF;
 	phy->aci_enable = 0;
@@ -2878,13 +2876,12 @@ static void setup_struct_phy_for_init(st
 	for (i = 0; i < ARRAY_SIZE(phy->nrssi_lt); i++)
 		phy->nrssi_lt[i] = i;
 
 	phy->lofcal = 0xFFFF;
 	phy->initval = 0xFFFF;
 
-	spin_lock_init(&phy->lock);
 	phy->interfmode = B43legacy_INTERFMODE_NONE;
 	phy->channel = 0xFF;
 }
 
 static void setup_struct_wldev_for_init(struct b43legacy_wldev *dev)
 {
@@ -3010,13 +3007,12 @@ static void prepare_phy_data_for_init(st
 	phy->antenna_diversity = 0xFFFF;
 	memset(phy->minlowsig, 0xFF, sizeof(phy->minlowsig));
 	memset(phy->minlowsigpos, 0, sizeof(phy->minlowsigpos));
 
 	/* Flags */
 	phy->calibrated = 0;
-	phy->locked = 0;
 
 	if (phy->_lo_pairs)
 		memset(phy->_lo_pairs, 0,
 		       sizeof(struct b43legacy_lopair) * B43legacy_LO_COUNT);
 	memset(phy->loopback_gain, 0, sizeof(phy->loopback_gain));
 }
Index: wireless-2.6/drivers/net/wireless/b43legacy/phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/phy.c	2008-01-09 16:59:33.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43legacy/phy.c	2008-01-09 20:12:58.000000000 +0100
@@ -88,46 +88,42 @@ void b43legacy_voluntary_preempt(void)
 			  !in_interrupt() && !irqs_disabled()));
 #ifndef CONFIG_PREEMPT
 	cond_resched();
 #endif /* CONFIG_PREEMPT */
 }
 
-void b43legacy_raw_phy_lock(struct b43legacy_wldev *dev)
-{
-	struct b43legacy_phy *phy = &dev->phy;
+/* Lock the PHY registers against concurrent access from the microcode.
+ * This lock is nonrecursive. */
+void b43legacy_phy_lock(struct b43legacy_wldev *dev)
+{
+#if B43legacy_DEBUG
+	B43legacy_WARN_ON(dev->phy.phy_locked);
+	dev->phy.phy_locked = 1;
+#endif
 
-	B43legacy_WARN_ON(!irqs_disabled());
-	if (b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD) == 0) {
-		phy->locked = 0;
-		return;
-	}
 	if (dev->dev->id.revision < 3) {
 		b43legacy_mac_suspend(dev);
-		spin_lock(&phy->lock);
 	} else {
 		if (!b43legacy_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
 			b43legacy_power_saving_ctl_bits(dev, -1, 1);
 	}
-	phy->locked = 1;
 }
 
-void b43legacy_raw_phy_unlock(struct b43legacy_wldev *dev)
+void b43legacy_phy_unlock(struct b43legacy_wldev *dev)
 {
-	struct b43legacy_phy *phy = &dev->phy;
+#if B43legacy_DEBUG
+	B43legacy_WARN_ON(!dev->phy.phy_locked);
+	dev->phy.phy_locked = 0;
+#endif
 
-	B43legacy_WARN_ON(!irqs_disabled());
 	if (dev->dev->id.revision < 3) {
-		if (phy->locked) {
-			spin_unlock(&phy->lock);
-			b43legacy_mac_enable(dev);
-		}
+		b43legacy_mac_enable(dev);
 	} else {
 		if (!b43legacy_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
 			b43legacy_power_saving_ctl_bits(dev, -1, -1);
 	}
-	phy->locked = 0;
 }
 
 u16 b43legacy_phy_read(struct b43legacy_wldev *dev, u16 offset)
 {
 	b43legacy_write16(dev, B43legacy_MMIO_PHY_CONTROL, offset);
 	return b43legacy_read16(dev, B43legacy_MMIO_PHY_DATA);
@@ -1786,13 +1782,12 @@ void b43legacy_phy_xmitpower(struct b43l
 	s16 estimated_pwr;
 	s16 pwr_adjust;
 	s16 radio_att_delta;
 	s16 baseband_att_delta;
 	s16 radio_attenuation;
 	s16 baseband_attenuation;
-	unsigned long phylock_flags;
 
 	if (phy->savedpctlreg == 0xFFFF)
 		return;
 	if ((dev->dev->bus->boardinfo.type == 0x0416) &&
 	    is_bcm_board_vendor(dev))
 		return;
@@ -1941,19 +1936,19 @@ void b43legacy_phy_xmitpower(struct b43l
 	baseband_attenuation = limit_value(baseband_attenuation, 0, 11);
 	radio_attenuation = limit_value(radio_attenuation, 0, 9);
 	phy->rfatt = radio_attenuation;
 	phy->bbatt = baseband_attenuation;
 
 	/* Adjust the hardware */
-	b43legacy_phy_lock(dev, phylock_flags);
+	b43legacy_phy_lock(dev);
 	b43legacy_radio_lock(dev);
 	b43legacy_radio_set_txpower_bg(dev, baseband_attenuation,
 				       radio_attenuation, txpower);
 	b43legacy_phy_lo_mark_current_used(dev);
 	b43legacy_radio_unlock(dev);
-	b43legacy_phy_unlock(dev, phylock_flags);
+	b43legacy_phy_unlock(dev);
 }
 
 static inline
 s32 b43legacy_tssi2dbm_ad(s32 num, s32 den)
 {
 	if (num < 0)
Index: wireless-2.6/drivers/net/wireless/b43legacy/phy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/phy.h	2007-12-11 01:08:40.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43legacy/phy.h	2008-01-09 19:57:56.000000000 +0100
@@ -168,24 +168,14 @@ void b43legacy_put_attenuation_into_rang
 #define B43legacy_PHYVER_TYPE		0x0F00
 #define B43legacy_PHYVER_TYPE_SHIFT	8
 #define B43legacy_PHYVER_VERSION	0x00FF
 
 struct b43legacy_wldev;
 
-void b43legacy_raw_phy_lock(struct b43legacy_wldev *dev);
-#define b43legacy_phy_lock(bcm, flags) 		\
-	do {					\
-		local_irq_save(flags);		\
-		b43legacy_raw_phy_lock(bcm);	\
-	} while (0)
-void b43legacy_raw_phy_unlock(struct b43legacy_wldev *dev);
-#define b43legacy_phy_unlock(bcm, flags)	\
-	do {					\
-		b43legacy_raw_phy_unlock(bcm);	\
-		local_irq_restore(flags);	\
-	} while (0)
+void b43legacy_phy_lock(struct b43legacy_wldev *dev);
+void b43legacy_phy_unlock(struct b43legacy_wldev *dev);
 
 /* Card uses the loopback gain stuff */
 #define has_loopback_gain(phy)			 \
 	(((phy)->rev > 1) || ((phy)->gmode))
 
 u16 b43legacy_phy_read(struct b43legacy_wldev *dev, u16 offset);
Index: wireless-2.6/drivers/net/wireless/b43legacy/radio.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/radio.c	2007-12-11 01:08:40.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43legacy/radio.c	2008-01-09 20:11:46.000000000 +0100
@@ -89,24 +89,26 @@ u16 channel2freq_bg(u8 channel)
 
 void b43legacy_radio_lock(struct b43legacy_wldev *dev)
 {
 	u32 status;
 
 	status = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
+	B43legacy_WARN_ON(status & B43legacy_SBF_RADIOREG_LOCK);
 	status |= B43legacy_SBF_RADIOREG_LOCK;
 	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, status);
 	mmiowb();
 	udelay(10);
 }
 
 void b43legacy_radio_unlock(struct b43legacy_wldev *dev)
 {
 	u32 status;
 
 	b43legacy_read16(dev, B43legacy_MMIO_PHY_VER); /* dummy read */
 	status = b43legacy_read32(dev, B43legacy_MMIO_STATUS_BITFIELD);
+	B43legacy_WARN_ON(!(status & B43legacy_SBF_RADIOREG_LOCK));
 	status &= ~B43legacy_SBF_RADIOREG_LOCK;
 	b43legacy_write32(dev, B43legacy_MMIO_STATUS_BITFIELD, status);
 	mmiowb();
 }
 
 u16 b43legacy_radio_read16(struct b43legacy_wldev *dev, u16 offset)
@@ -281,18 +283,17 @@ u8 b43legacy_radio_aci_scan(struct b43le
 	u8 ret[13];
 	unsigned int channel = phy->channel;
 	unsigned int i;
 	unsigned int j;
 	unsigned int start;
 	unsigned int end;
-	unsigned long phylock_flags;
 
 	if (!((phy->type == B43legacy_PHYTYPE_G) && (phy->rev > 0)))
 		return 0;
 
-	b43legacy_phy_lock(dev, phylock_flags);
+	b43legacy_phy_lock(dev);
 	b43legacy_radio_lock(dev);
 	b43legacy_phy_write(dev, 0x0802,
 			    b43legacy_phy_read(dev, 0x0802) & 0xFFFC);
 	b43legacy_phy_write(dev, B43legacy_PHY_G_CRS,
 			    b43legacy_phy_read(dev, B43legacy_PHY_G_CRS)
 			    & 0x7FFF);
@@ -320,13 +321,13 @@ u8 b43legacy_radio_aci_scan(struct b43le
 			continue;
 		end = (i + 5 < 13) ? i + 5 : 13;
 		for (j = i; j < end; j++)
 			ret[j] = 1;
 	}
 	b43legacy_radio_unlock(dev);
-	b43legacy_phy_unlock(dev, phylock_flags);
+	b43legacy_phy_unlock(dev);
 
 	return ret[channel - 1];
 }
 
 /* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
 void b43legacy_nrssi_hw_write(struct b43legacy_wldev *dev, u16 offset, s16 val)

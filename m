Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44421 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbYGZP3x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 11:29:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: [PATCH RFC/RFT] b43: Rewrite TX power adjustment
Date: Sat, 26 Jul 2008 17:26:52 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200807261726.53279.mb@bu3sch.de> (sfid-20080726_173000_739729_83FCDB47)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an experimental attempt for fixing the currently-not-so-good
TX power adjustment.

This patch rewrites the algorithms to scale better. If there's no
TX traffic, the power will be checked against the desired values
every 15 seconds (can probably be lowered to 30 or 60 seconds now).
If there is TX traffic, the check is redone every 2 seconds. This improves
the reaction times a lot and confuses the rate control less.

If you want to test this, please apply to latest wireless-testing.git
and compile b43 with debugging support.
After loading the driver, mount debugfs and do
	echo 1 >/debug/b43/phy*/debug_xmitpower
to enable TX power calculation debugging. This will print a lot of useful messages
in the kernel log.

This patch is only tested on a 4306 card.
Have fun.


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-07-24 12:10:45.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-07-26 01:04:26.000000000 +0200
@@ -170,12 +170,17 @@ enum {
 #define B43_SHM_SH_RADAR		0x0066	/* Radar register */
 #define B43_SHM_SH_PHYTXNOI		0x006E	/* PHY noise directly after TX (lower 8bit only) */
 #define B43_SHM_SH_RFRXSP1		0x0072	/* RF RX SP Register 1 */
 #define B43_SHM_SH_CHAN			0x00A0	/* Current channel (low 8bit only) */
 #define  B43_SHM_SH_CHAN_5GHZ		0x0100	/* Bit set, if 5Ghz channel */
 #define B43_SHM_SH_BCMCFIFOID		0x0108	/* Last posted cookie to the bcast/mcast FIFO */
+/* TSSI information */
+#define B43_SHM_SH_TSSI_CCK		0x0058	/* TSSI for last 4 CCK frames (32bit) */
+#define B43_SHM_SH_TSSI_OFDM_A		0x0068	/* TSSI for last 4 OFDM frames (32bit) */
+#define B43_SHM_SH_TSSI_OFDM_G		0x0070	/* TSSI for last 4 OFDM frames (32bit) */
+#define  B43_TSSI_MAX			0x7F	/* Max value for one TSSI value */
 /* SHM_SHARED TX FIFO variables */
 #define B43_SHM_SH_SIZE01		0x0098	/* TX FIFO size for FIFO 0 (low) and 1 (high) */
 #define B43_SHM_SH_SIZE23		0x009A	/* TX FIFO size for FIFO 2 and 3 */
 #define B43_SHM_SH_SIZE45		0x009C	/* TX FIFO size for FIFO 4 and 5 */
 #define B43_SHM_SH_SIZE67		0x009E	/* TX FIFO size for FIFO 6 and 7 */
 /* SHM_SHARED background noise */
@@ -505,12 +510,51 @@ struct b43_iv {
 		__be16 d16;
 		__be32 d32;
 	} data __attribute__((__packed__));
 } __attribute__((__packed__));
 
 
+/* Transmission Power values.
+ * (Almost) everything related to and required for TX-power adjustment
+ * is stored in this structure. */
+struct b43_txpower_context {
+	/* Pointer to the table used to convert a
+	 * TSSI value to dBm-Q5.2 */
+	const s8 *tssi2dbm;
+	/* tssi2dbm is kmalloc()ed. Only used for free()ing. */
+	bool dyn_tssi_tbl;
+	/* Target idle TSSI */
+	int tgt_idle_tssi;
+	/* Current idle TSSI */
+	int cur_idle_tssi;
+	/* The current average TSSI.
+	 * Needs irq_lock, as it's updated in the IRQ path. */
+	u8 average_tssi;
+	/* jiffies when the next TSSI read (from SHM) is required.
+	 * Needs irq_lock, as it's updated in the IRQ path. */
+	unsigned long next_tssi_average;
+	/* User-desired TX power level (in dBm). */
+	u8 desired_power;
+
+	/* A-PHY TX Power control value. */
+	u16 txpwr_offset;
+
+	/* Current TX power level attenuation control values */
+	struct b43_bbatt bbatt;
+	struct b43_rfatt rfatt;
+	u8 tx_control;		/* B43_TXCTL_XXX */
+
+	/* The calculated attenuation deltas that are used later
+	 * when adjusting the actual power output. */
+	int bbatt_delta;
+	int rfatt_delta;
+
+	/* Hardware Power Control enabled? */
+	bool hardware_power_control;
+};
+
 struct b43_phy {
 	/* Band support flags. */
 	bool supports_2ghz;
 	bool supports_5ghz;
 
 	/* GMODE bit enabled? */
@@ -525,14 +569,12 @@ struct b43_phy {
 
 	/* Radio versioning */
 	u16 radio_manuf;	/* Radio manufacturer */
 	u16 radio_ver;		/* Radio version */
 	u8 radio_rev;		/* Radio revision */
 
-	bool dyn_tssi_tbl;	/* tssi2dbm is kmalloc()ed. */
-
 	/* ACI (adjacent channel interference) flags. */
 	bool aci_enable;
 	bool aci_wlan_automatic;
 	bool aci_hw_rssi;
 
 	/* Radio switched on/off */
@@ -545,41 +587,23 @@ struct b43_phy {
 		u16 rfoverval;
 	} radio_off_context;
 
 	u16 minlowsig[2];
 	u16 minlowsigpos[2];
 
-	/* TSSI to dBm table in use */
-	const s8 *tssi2dbm;
-	/* Target idle TSSI */
-	int tgt_idle_tssi;
-	/* Current idle TSSI */
-	int cur_idle_tssi;
-
 	/* LocalOscillator control values. */
 	struct b43_txpower_lo_control *lo_control;
 	/* Values from b43_calc_loopback_gain() */
 	s16 max_lb_gain;	/* Maximum Loopback gain in hdB */
 	s16 trsw_rx_gain;	/* TRSW RX gain in hdB */
 	s16 lna_lod_gain;	/* LNA lod */
 	s16 lna_gain;		/* LNA */
 	s16 pga_gain;		/* PGA */
 
-	/* Desired TX power level (in dBm).
-	 * This is set by the user and adjusted in b43_phy_xmitpower(). */
-	u8 power_level;
-	/* A-PHY TX Power control value. */
-	u16 txpwr_offset;
-
-	/* Current TX power level attenuation control values */
-	struct b43_bbatt bbatt;
-	struct b43_rfatt rfatt;
-	u8 tx_control;		/* B43_TXCTL_XXX */
-
-	/* Hardware Power Control enabled? */
-	bool hardware_power_control;
+	/* (Almost) everything related to TX power is stored here. */
+	struct b43_txpower_context txpwr;
 
 	/* Current Interference Mitigation mode */
 	int interfmode;
 	/* Stack of saved values from the Interference Mitigation code.
 	 * Each value in the stack is layed out as follows:
 	 * bit 0-11:  offset
@@ -761,12 +785,17 @@ struct b43_wl {
 
 	/* The current QOS parameters for the 4 queues.
 	 * This is protected by the irq_lock. */
 	struct b43_qos_params qos_params[4];
 	/* Workqueue for updating QOS parameters in hardware. */
 	struct work_struct qos_update_work;
+
+	/* Work for adjustment of the transmission power.
+	 * This is scheduled when we determine that the actual TX output
+	 * power doesn't match what we want. */
+	struct work_struct txpower_adjust_work;
 };
 
 /* In-memory representation of a cached microcode file. */
 struct b43_firmware_file {
 	const char *filename;
 	const struct firmware *data;
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-07-26 01:03:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-07-26 17:06:17.000000000 +0200
@@ -2866,13 +2866,15 @@ static void b43_periodic_every15sec(stru
 			b43_mac_enable(dev);
 		} else if (phy->interfmode == B43_INTERFMODE_NONWLAN &&
 			   phy->rev == 1) {
 			//TODO: implement rev1 workaround
 		}
 	}
-	b43_phy_xmitpower(dev);	//FIXME: unless scanning?
+	spin_lock_irq(&dev->wl->irq_lock);
+	b43_phy_txpower_check(dev, B43_TXPWR_IGNORE_TIME);
+	spin_unlock_irq(&dev->wl->irq_lock);
 	b43_lo_g_maintanance_work(dev);
 	//TODO for APHY (temperature?)
 
 	atomic_set(&phy->txerr_cnt, B43_PHY_TX_BADNESS_LIMIT);
 	wmb();
 }
@@ -3448,16 +3450,19 @@ static int b43_op_config(struct ieee8021
 	}
 
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
 
 	/* Adjust the desired TX power level. */
 	if (conf->power_level != 0) {
-		if (conf->power_level != phy->power_level) {
-			phy->power_level = conf->power_level;
-			b43_phy_xmitpower(dev);
+		spin_lock_irqsave(&wl->irq_lock, flags);
+		if (conf->power_level != phy->txpwr.desired_power) {
+			phy->txpwr.desired_power = conf->power_level;
+			b43_phy_txpower_check(dev, B43_TXPWR_IGNORE_TIME |
+						   B43_TXPWR_IGNORE_TSSI);
 		}
+		spin_unlock_irqrestore(&wl->irq_lock, flags);
 	}
 
 	/* Antennas for RX and management frame TX. */
 	antenna = b43_antenna_from_ieee80211(dev, conf->antenna_sel_tx);
 	b43_mgmtframe_txantenna(dev, antenna);
 	antenna = b43_antenna_from_ieee80211(dev, conf->antenna_sel_rx);
@@ -3861,21 +3866,24 @@ static void setup_struct_phy_for_init(st
 	phy->aci_enable = 0;
 	phy->aci_wlan_automatic = 0;
 	phy->aci_hw_rssi = 0;
 
 	phy->radio_off_context.valid = 0;
 
+	memset(&phy->txpwr, 0, sizeof(phy->txpwr));
+	phy->txpwr.next_tssi_average = jiffies;
+	phy->txpwr.hardware_power_control = !!modparam_hwpctl;
+
 	lo = phy->lo_control;
 	if (lo) {
 		memset(lo, 0, sizeof(*(phy->lo_control)));
 		lo->tx_bias = 0xFF;
 		INIT_LIST_HEAD(&lo->calib_list);
 	}
 	phy->max_lb_gain = 0;
 	phy->trsw_rx_gain = 0;
-	phy->txpwr_offset = 0;
 
 	/* NRSSI */
 	phy->nrssislope = 0;
 	for (i = 0; i < ARRAY_SIZE(phy->nrssi); i++)
 		phy->nrssi[i] = -1000;
 	for (i = 0; i < ARRAY_SIZE(phy->nrssi_lt); i++)
@@ -3884,14 +3892,12 @@ static void setup_struct_phy_for_init(st
 	phy->lofcal = 0xFFFF;
 	phy->initval = 0xFFFF;
 
 	phy->interfmode = B43_INTERFMODE_NONE;
 	phy->channel = 0xFF;
 
-	phy->hardware_power_control = !!modparam_hwpctl;
-
 	/* PHY TX errors counter. */
 	atomic_set(&phy->txerr_cnt, B43_PHY_TX_BADNESS_LIMIT);
 
 	/* OFDM-table address caching. */
 	phy->ofdmtab_addr_direction = B43_OFDMTAB_DIRECTION_UNKNOWN;
 }
@@ -4049,14 +4055,14 @@ static void b43_wireless_core_exit(struc
 	}
 	b43_dma_free(dev);
 	b43_pio_free(dev);
 	b43_chip_exit(dev);
 	b43_radio_turn_off(dev, 1);
 	b43_switch_analog(dev, 0);
-	if (phy->dyn_tssi_tbl)
-		kfree(phy->tssi2dbm);
+	if (phy->txpwr.dyn_tssi_tbl)
+		kfree(phy->txpwr.tssi2dbm);
 	kfree(phy->lo_control);
 	phy->lo_control = NULL;
 	if (dev->wl->current_beacon) {
 		dev_kfree_skb_any(dev->wl->current_beacon);
 		dev->wl->current_beacon = NULL;
 	}
@@ -4174,14 +4180,14 @@ static int b43_wireless_core_init(struct
 out:
 	return err;
 
       err_chip_exit:
 	b43_chip_exit(dev);
       err_kfree_tssitbl:
-	if (phy->dyn_tssi_tbl)
-		kfree(phy->tssi2dbm);
+	if (phy->txpwr.dyn_tssi_tbl)
+		kfree(phy->txpwr.tssi2dbm);
       err_kfree_lo_control:
 	kfree(phy->lo_control);
 	phy->lo_control = NULL;
       err_busdown:
 	ssb_bus_may_powerdown(bus);
 	B43_WARN_ON(b43_status(dev) != B43_STAT_UNINIT);
@@ -4322,12 +4328,14 @@ static void b43_op_stop(struct ieee80211
 
 	mutex_lock(&wl->mutex);
 	if (b43_status(dev) >= B43_STAT_STARTED)
 		b43_wireless_core_stop(dev);
 	b43_wireless_core_exit(dev);
 	mutex_unlock(&wl->mutex);
+
+	cancel_work_sync(&(wl->txpower_adjust_work));
 }
 
 static int b43_op_set_retry_limit(struct ieee80211_hw *hw,
 				  u32 short_retry_limit, u32 long_retry_limit)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
@@ -4699,12 +4707,13 @@ static int b43_wireless_init(struct ssb_
 	spin_lock_init(&wl->leds_lock);
 	spin_lock_init(&wl->shm_lock);
 	mutex_init(&wl->mutex);
 	INIT_LIST_HEAD(&wl->devlist);
 	INIT_WORK(&wl->qos_update_work, b43_qos_update_work);
 	INIT_WORK(&wl->beacon_update_trigger, b43_beacon_update_trigger_work);
+	INIT_WORK(&wl->txpower_adjust_work, b43_phy_txpower_adjust_work);
 
 	ssb_set_devtypedata(dev, wl);
 	b43info(wl, "Broadcom %04X WLAN found\n", dev->bus->chip_id);
 	err = 0;
       out:
 	return err;
Index: wireless-testing/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy.c	2008-06-12 11:42:15.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy.c	2008-07-26 17:10:47.000000000 +0200
@@ -173,13 +173,13 @@ static void generate_bbatt_list(struct b
 	list->min_val = 0;
 	list->max_val = 8;
 }
 
 bool b43_has_hardware_pctl(struct b43_phy *phy)
 {
-	if (!phy->hardware_power_control)
+	if (!phy->txpwr.hardware_power_control)
 		return 0;
 	switch (phy->type) {
 	case B43_PHYTYPE_A:
 		if (phy->rev >= 5)
 			return 1;
 		break;
@@ -325,16 +325,16 @@ void b43_set_txpower_g(struct b43_wldev 
 	tx_bias = lo->tx_bias;
 	tx_magn = lo->tx_magn;
 	if (unlikely(tx_bias == 0xFF))
 		tx_bias = 0;
 
 	/* Save the values for later */
-	phy->tx_control = tx_control;
-	memcpy(&phy->rfatt, rfatt, sizeof(*rfatt));
-	phy->rfatt.with_padmix = !!(tx_control & B43_TXCTL_TXMIX);
-	memcpy(&phy->bbatt, bbatt, sizeof(*bbatt));
+	phy->txpwr.tx_control = tx_control;
+	memcpy(&phy->txpwr.rfatt, rfatt, sizeof(*rfatt));
+	phy->txpwr.rfatt.with_padmix = !!(tx_control & B43_TXCTL_TXMIX);
+	memcpy(&phy->txpwr.bbatt, bbatt, sizeof(*bbatt));
 
 	if (b43_debug(dev, B43_DBG_XMITPOWER)) {
 		b43dbg(dev->wl, "Tuning TX-power to bbatt(%u), "
 		       "rfatt(%u), tx_control(0x%02X), "
 		       "tx_bias(0x%02X), tx_magn(0x%02X)\n",
 		       bb, rf, tx_control, tx_bias, tx_magn);
@@ -492,15 +492,15 @@ static u16 default_tx_control(struct b43
 /* This func is called "PHY calibrate" in the specs... */
 void b43_phy_early_init(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_txpower_lo_control *lo = phy->lo_control;
 
-	default_baseband_attenuation(dev, &phy->bbatt);
-	default_radio_attenuation(dev, &phy->rfatt);
-	phy->tx_control = (default_tx_control(dev) << 4);
+	default_baseband_attenuation(dev, &phy->txpwr.bbatt);
+	default_radio_attenuation(dev, &phy->txpwr.rfatt);
+	phy->txpwr.tx_control = (default_tx_control(dev) << 4);
 
 	/* Commit previous writes */
 	b43_read32(dev, B43_MMIO_MACCTL);
 
 	if (phy->type == B43_PHYTYPE_B || phy->type == B43_PHYTYPE_G) {
 		generate_rfatt_list(dev, &lo->rfatt_list);
@@ -521,19 +521,23 @@ void b43_phy_early_init(struct b43_wldev
 static void b43_gphy_tssi_power_lt_init(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	int i;
 	u16 value;
 
-	for (i = 0; i < 32; i++)
-		b43_ofdmtab_write16(dev, 0x3C20, i, phy->tssi2dbm[i]);
-	for (i = 32; i < 64; i++)
-		b43_ofdmtab_write16(dev, 0x3C00, i - 32, phy->tssi2dbm[i]);
+	for (i = 0; i < 32; i++) {
+		b43_ofdmtab_write16(dev, 0x3C20, i,
+				    phy->txpwr.tssi2dbm[i]);
+	}
+	for (i = 32; i < 64; i++) {
+		b43_ofdmtab_write16(dev, 0x3C00, i - 32,
+				    phy->txpwr.tssi2dbm[i]);
+	}
 	for (i = 0; i < 64; i += 2) {
-		value = (u16) phy->tssi2dbm[i];
-		value |= ((u16) phy->tssi2dbm[i + 1]) << 8;
+		value = (u16) phy->txpwr.tssi2dbm[i];
+		value |= ((u16) phy->txpwr.tssi2dbm[i + 1]) << 8;
 		b43_phy_write(dev, 0x380 + (i / 2), value);
 	}
 }
 
 /* GPHY_Gain_Lookup_Table_Init */
 static void b43_gphy_gain_lt_init(struct b43_wldev *dev)
@@ -568,15 +572,15 @@ static void hardware_pctl_init_aphy(stru
 
 static void hardware_pctl_init_gphy(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 
 	b43_phy_write(dev, 0x0036, (b43_phy_read(dev, 0x0036) & 0xFFC0)
-		      | (phy->tgt_idle_tssi - phy->cur_idle_tssi));
+		      | (phy->txpwr.tgt_idle_tssi - phy->txpwr.cur_idle_tssi));
 	b43_phy_write(dev, 0x0478, (b43_phy_read(dev, 0x0478) & 0xFF00)
-		      | (phy->tgt_idle_tssi - phy->cur_idle_tssi));
+		      | (phy->txpwr.tgt_idle_tssi - phy->txpwr.cur_idle_tssi));
 	b43_gphy_tssi_power_lt_init(dev);
 	b43_gphy_gain_lt_init(dev);
 	b43_phy_write(dev, 0x0060, b43_phy_read(dev, 0x0060) & 0xFFBF);
 	b43_phy_write(dev, 0x0014, 0x0000);
 
 	B43_WARN_ON(phy->rev < 6);
@@ -676,47 +680,44 @@ static void b43_phy_init_pctl(struct b43
 	b43_write16(dev, B43_MMIO_PHY0, b43_read16(dev, B43_MMIO_PHY0)
 		    & 0xFFDF);
 
 	if (phy->type == B43_PHYTYPE_G && !phy->gmode)
 		return;
 	b43_hardware_pctl_early_init(dev);
-	if (phy->cur_idle_tssi == 0) {
+	if (phy->txpwr.cur_idle_tssi == 0) {
 		if (phy->radio_ver == 0x2050 && phy->analog == 0) {
 			b43_radio_write16(dev, 0x0076,
 					  (b43_radio_read16(dev, 0x0076)
 					   & 0x00F7) | 0x0084);
 		} else {
 			struct b43_rfatt rfatt;
 			struct b43_bbatt bbatt;
 
-			memcpy(&old_rfatt, &phy->rfatt, sizeof(old_rfatt));
-			memcpy(&old_bbatt, &phy->bbatt, sizeof(old_bbatt));
-			old_tx_control = phy->tx_control;
+			memcpy(&old_rfatt, &phy->txpwr.rfatt, sizeof(old_rfatt));
+			memcpy(&old_bbatt, &phy->txpwr.bbatt, sizeof(old_bbatt));
+			old_tx_control = phy->txpwr.tx_control;
 
 			bbatt.att = 11;
 			if (phy->radio_rev == 8) {
 				rfatt.att = 15;
 				rfatt.with_padmix = 1;
 			} else {
 				rfatt.att = 9;
 				rfatt.with_padmix = 0;
 			}
 			b43_set_txpower_g(dev, &bbatt, &rfatt, 0);
 		}
 		b43_dummy_transmission(dev);
-		phy->cur_idle_tssi = b43_phy_read(dev, B43_PHY_ITSSI);
-		if (B43_DEBUG) {
-			/* Current-Idle-TSSI sanity check. */
-			if (abs(phy->cur_idle_tssi - phy->tgt_idle_tssi) >= 20) {
-				b43dbg(dev->wl,
-				       "!WARNING! Idle-TSSI phy->cur_idle_tssi "
-				       "measuring failed. (cur=%d, tgt=%d). Disabling TX power "
-				       "adjustment.\n", phy->cur_idle_tssi,
-				       phy->tgt_idle_tssi);
-				phy->cur_idle_tssi = 0;
-			}
+		phy->txpwr.cur_idle_tssi = b43_phy_read(dev, B43_PHY_ITSSI);
+		/* Current-Idle-TSSI sanity check. */
+		if (abs(phy->txpwr.cur_idle_tssi - phy->txpwr.tgt_idle_tssi) >= 30) {
+			b43dbg(dev->wl,
+			       "!WARNING! Idle-TSSI phy->cur_idle_tssi "
+			       "measuring failed. (cur=%d, tgt=%d).\n",
+			       phy->txpwr.cur_idle_tssi,
+			       phy->txpwr.tgt_idle_tssi);
 		}
 		if (phy->radio_ver == 0x2050 && phy->analog == 0) {
 			b43_radio_write16(dev, 0x0076,
 					  b43_radio_read16(dev, 0x0076)
 					  & 0xFF7B);
 		} else {
@@ -973,13 +974,14 @@ static void b43_phy_initb5(struct b43_wl
 	b43_radio_selectchannel(dev, old_channel, 0);
 
 	b43_phy_write(dev, 0x0014, 0x0080);
 	b43_phy_write(dev, 0x0032, 0x00CA);
 	b43_phy_write(dev, 0x002A, 0x88A3);
 
-	b43_set_txpower_g(dev, &phy->bbatt, &phy->rfatt, phy->tx_control);
+	b43_set_txpower_g(dev, &phy->txpwr.bbatt,
+			  &phy->txpwr.rfatt, phy->txpwr.tx_control);
 
 	if (phy->radio_ver == 0x2050)
 		b43_radio_write16(dev, 0x005D, 0x000D);
 
 	b43_write16(dev, 0x03E4, (b43_read16(dev, 0x03E4) & 0xFFC0) | 0x0004);
 }
@@ -1081,13 +1083,14 @@ static void b43_phy_initb6(struct b43_wl
 	b43_phy_write(dev, 0x0014, 0x0200);
 	if (phy->radio_rev >= 6)
 		b43_phy_write(dev, 0x2A, 0x88C2);
 	else
 		b43_phy_write(dev, 0x2A, 0x8AC0);
 	b43_phy_write(dev, 0x0038, 0x0668);
-	b43_set_txpower_g(dev, &phy->bbatt, &phy->rfatt, phy->tx_control);
+	b43_set_txpower_g(dev, &phy->txpwr.bbatt,
+			  &phy->txpwr.rfatt, phy->txpwr.tx_control);
 	if (phy->radio_rev <= 5) {
 		b43_phy_write(dev, 0x5D, (b43_phy_read(dev, 0x5D)
 					  & 0xFF80) | 0x0003);
 	}
 	if (phy->radio_rev <= 2)
 		b43_radio_write16(dev, 0x005D, 0x000D);
@@ -1131,13 +1134,13 @@ static void b43_calc_loopback_gain(struc
 	backup_phy[10] = b43_phy_read(dev, B43_PHY_CCK(0x03));
 	backup_phy[11] = b43_phy_read(dev, B43_PHY_LO_MASK);
 	backup_phy[12] = b43_phy_read(dev, B43_PHY_LO_CTL);
 	backup_phy[13] = b43_phy_read(dev, B43_PHY_CCK(0x2B));
 	backup_phy[14] = b43_phy_read(dev, B43_PHY_PGACTL);
 	backup_phy[15] = b43_phy_read(dev, B43_PHY_LO_LEAKAGE);
-	backup_bband = phy->bbatt.att;
+	backup_bband = phy->txpwr.bbatt.att;
 	backup_radio[0] = b43_radio_read16(dev, 0x52);
 	backup_radio[1] = b43_radio_read16(dev, 0x43);
 	backup_radio[2] = b43_radio_read16(dev, 0x7A);
 
 	b43_phy_write(dev, B43_PHY_CRS0,
 		      b43_phy_read(dev, B43_PHY_CRS0) & 0x3FFF);
@@ -1454,25 +1457,25 @@ void b43_phy_set_baseband_attenuation(st
 static s8 b43_phy_estimate_power_out(struct b43_wldev *dev, s8 tssi)
 {
 	struct b43_phy *phy = &dev->phy;
 	s8 dbm = 0;
 	s32 tmp;
 
-	tmp = (phy->tgt_idle_tssi - phy->cur_idle_tssi + tssi);
+	tmp = (phy->txpwr.tgt_idle_tssi - phy->txpwr.cur_idle_tssi + tssi);
 
 	switch (phy->type) {
 	case B43_PHYTYPE_A:
 		tmp += 0x80;
 		tmp = clamp_val(tmp, 0x00, 0xFF);
-		dbm = phy->tssi2dbm[tmp];
+		dbm = phy->txpwr.tssi2dbm[tmp];
 		//TODO: There's a FIXME on the specs
 		break;
 	case B43_PHYTYPE_B:
 	case B43_PHYTYPE_G:
 		tmp = clamp_val(tmp, 0x00, 0x3F);
-		dbm = phy->tssi2dbm[tmp];
+		dbm = phy->txpwr.tssi2dbm[tmp];
 		break;
 	default:
 		B43_WARN_ON(1);
 	}
 
 	return dbm;
@@ -1528,187 +1531,363 @@ void b43_put_attenuation_into_ranges(str
 	}
 
 	*_rfatt = clamp_val(rfatt, rf_min, rf_max);
 	*_bbatt = clamp_val(bbatt, bb_min, bb_max);
 }
 
-/* http://bcm-specs.sipsolutions.net/RecalculateTransmissionPower */
-void b43_phy_xmitpower(struct b43_wldev *dev)
+static void b43_adjust_txpwr_aphy(struct b43_wldev *dev,
+				  const struct b43_txpower_context *ctx)
+{//TODO
+	B43_WARN_ON(1);
+}
+
+static void b43_adjust_txpwr_bgphy(struct b43_wldev *dev,
+				   const struct b43_txpower_context *ctx)
+{//TODO
+	struct b43_phy *phy = &dev->phy;
+	int rfatt, bbatt;
+	u8 tx_control;
+
+	/* Calculate the new attenuation values. */
+	bbatt = ctx->bbatt.att;
+	bbatt += ctx->bbatt_delta;
+	rfatt = ctx->rfatt.att;
+	rfatt += ctx->rfatt_delta;
+
+	b43_put_attenuation_into_ranges(dev, &bbatt, &rfatt);
+	tx_control = ctx->tx_control;
+	if ((phy->radio_ver == 0x2050) && (phy->radio_rev == 2)) {
+		if (rfatt <= 1) {
+			if (tx_control == 0) {
+				tx_control =
+				    B43_TXCTL_PA2DB |
+				    B43_TXCTL_TXMIX;
+				rfatt += 2;
+				bbatt += 2;
+			} else if (dev->dev->bus->sprom.
+				   boardflags_lo &
+				   B43_BFL_PACTRL) {
+				bbatt += 4 * (rfatt - 2);
+				rfatt = 2;
+			}
+		} else if (rfatt > 4 && tx_control) {
+			tx_control = 0;
+			if (bbatt < 3) {
+				rfatt -= 3;
+				bbatt += 2;
+			} else {
+				rfatt -= 2;
+				bbatt -= 2;
+			}
+		}
+	}
+	/* Save the control values */
+	//FIXME lock?
+	phy->txpwr.tx_control = tx_control;
+	b43_put_attenuation_into_ranges(dev, &bbatt, &rfatt);
+	phy->txpwr.rfatt.att = rfatt;
+	phy->txpwr.bbatt.att = bbatt;
+
+	/* Adjust the hardware */
+	b43_phy_lock(dev);
+	b43_radio_lock(dev);
+	b43_set_txpower_g(dev, &phy->txpwr.bbatt, &phy->txpwr.rfatt,
+			  phy->txpwr.tx_control);
+	b43_radio_unlock(dev);
+	b43_phy_unlock(dev);
+printk("Adjusted power\n");
+}
+
+/* Adjust the power output, if needed. */
+static void b43_adjust_tx_output_power(struct b43_wldev *dev,
+				       const struct b43_txpower_context *ctx)
 {
-	struct ssb_bus *bus = dev->dev->bus;
 	struct b43_phy *phy = &dev->phy;
 
-	if (phy->cur_idle_tssi == 0)
-		return;
+	switch (phy->type) {
+	case B43_PHYTYPE_A:
+		b43_adjust_txpwr_aphy(dev, ctx);
+		break;
+	case B43_PHYTYPE_B:
+	case B43_PHYTYPE_G:
+		b43_adjust_txpwr_bgphy(dev, ctx);
+		break;
+	case B43_PHYTYPE_N:
+//TODO		b43_adjust_txpwr_nphy(dev, ctx);
+		B43_WARN_ON(1);
+		break;
+	default:
+		B43_WARN_ON(1);
+	}
+}
+
+static bool b43_recalculate_txpower_aphy(struct b43_wldev *dev,
+					 u8 average_tssi)
+{/* TODO */
+	B43_WARN_ON(1);
+	return 0;
+}
+
+static bool b43_recalculate_txpower_bgphy(struct b43_wldev *dev,
+					  u8 average_tssi)
+{
+	struct b43_phy *phy = &dev->phy;
+	int estimated_pwr, desired_pwr, pwr_adjust;
+	int rfatt_delta, bbatt_delta;
+	unsigned int max_pwr;
+
+	estimated_pwr = b43_phy_estimate_power_out(dev, average_tssi);
+
+	B43_WARN_ON(phy->type != B43_PHYTYPE_G);
+	max_pwr = dev->dev->bus->sprom.maxpwr_bg;
+	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
+		max_pwr -= 3; /* minus 0.75 */
+	if (unlikely(max_pwr >= INT_TO_Q52(30/*dBm*/))) {
+		b43warn(dev->wl,
+			"Invalid max-TX-power value in SPROM.\n");
+		max_pwr = INT_TO_Q52(15); /* fake it */
+		dev->dev->bus->sprom.maxpwr_bg = max_pwr;
+	}
+
+	/* Get desired power (in Q5.2) */
+	desired_pwr = INT_TO_Q52(phy->txpwr.desired_power);
+	/* And limit it. max_pwr already is Q5.2 */
+	desired_pwr = clamp_val(desired_pwr, 0, max_pwr);
+	if (b43_debug(dev, B43_DBG_XMITPOWER)) {
+		b43dbg(dev->wl,
+		       "[TX power]  current = " Q52_FMT
+		       " dBm,  desired = " Q52_FMT
+		       " dBm,  max = " Q52_FMT "\n",
+		       Q52_ARG(estimated_pwr),
+		       Q52_ARG(desired_pwr),
+		       Q52_ARG(max_pwr));
+	}
+
+	/* Calculate the adjustment delta. */
+	pwr_adjust = desired_pwr - estimated_pwr;
+	if (pwr_adjust == 0)
+		goto no_adjustment_needed;
+/*	if (pwr_adjust == -1) {
+XXX b43info(dev->wl, "Ignoring power adjust of minus 0.25 dBm\n");
+		goto no_adjustment_needed;
+	}*/
+
+	/* RF attenuation delta. */
+	rfatt_delta = ((pwr_adjust + 7) / 8);
+	/* Lower attenuation => Bigger power output. Negate it. */
+	rfatt_delta = -rfatt_delta;
+
+	/* Baseband attenuation delta. */
+	bbatt_delta = pwr_adjust / 2;
+	/* Lower attenuation => Bigger power output. Negate it. */
+	bbatt_delta = -bbatt_delta;
+	/* RF att affects power level 4 times as much as
+	 * Baseband attennuation. Subtract it. */
+	bbatt_delta -= 4 * rfatt_delta;
+
+	if (b43_debug(dev, B43_DBG_XMITPOWER)) {
+		int dbm = pwr_adjust < 0 ? -pwr_adjust : pwr_adjust;
+		b43dbg(dev->wl,
+		       "[TX power deltas]  %s" Q52_FMT " dBm   =>   "
+		       "bbatt-delta = %d,  rfatt-delta = %d\n",
+		       (pwr_adjust < 0 ? "-" : ""), Q52_ARG(dbm),
+		       bbatt_delta, rfatt_delta);
+	}
+	/* So do we finally need to adjust something in hardware? */
+	if ((rfatt_delta == 0) && (bbatt_delta == 0))
+		goto no_adjustment_needed;
+
+	/* Save the deltas for later when we adjust the power. */
+	phy->txpwr.bbatt_delta = bbatt_delta;
+	phy->txpwr.rfatt_delta = rfatt_delta;
+
+	/* We need to adjust the TX power on the device. */
+	return 1;
+
+no_adjustment_needed:
+	return 0;
+}
+
+/**
+ * b43_recalculate_txpower - Recalculate the hardware attenuation settings.
+ *
+ * This recalculates the hardware attenuation settings based on the
+ * passed average_tssi value.
+ * Returns 1, if the hardware needs adjustment. Returns 0, if no hardware
+ * adjustment is needed.
+ *
+ * Requires wl->irq_lock
+ */
+static bool b43_recalculate_txpower(struct b43_wldev *dev,
+				    u8 average_tssi)
+{
+	struct ssb_bus *bus = dev->dev->bus;
+
 	if ((bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM) &&
 	    (bus->boardinfo.type == SSB_BOARD_BU4306))
-		return;
+		return 0;
 #ifdef CONFIG_B43_DEBUG
-	if (phy->manual_txpower_control)
-		return;
+	if (dev->phy.manual_txpower_control)
+		return 0;
 #endif
 
-	switch (phy->type) {
-	case B43_PHYTYPE_A:{
-
-			//TODO: Nothing for A PHYs yet :-/
-
-			break;
-		}
+	switch (dev->phy.type) {
+	case B43_PHYTYPE_A:
+		return b43_recalculate_txpower_aphy(dev, average_tssi);
 	case B43_PHYTYPE_B:
-	case B43_PHYTYPE_G:{
-			u16 tmp;
-			s8 v0, v1, v2, v3;
-			s8 average;
-			int max_pwr;
-			int desired_pwr, estimated_pwr, pwr_adjust;
-			int rfatt_delta, bbatt_delta;
-			int rfatt, bbatt;
-			u8 tx_control;
-
-			tmp = b43_shm_read16(dev, B43_SHM_SHARED, 0x0058);
-			v0 = (s8) (tmp & 0x00FF);
-			v1 = (s8) ((tmp & 0xFF00) >> 8);
-			tmp = b43_shm_read16(dev, B43_SHM_SHARED, 0x005A);
-			v2 = (s8) (tmp & 0x00FF);
-			v3 = (s8) ((tmp & 0xFF00) >> 8);
-			tmp = 0;
-
-			if (v0 == 0x7F || v1 == 0x7F || v2 == 0x7F
-			    || v3 == 0x7F) {
-				tmp =
-				    b43_shm_read16(dev, B43_SHM_SHARED, 0x0070);
-				v0 = (s8) (tmp & 0x00FF);
-				v1 = (s8) ((tmp & 0xFF00) >> 8);
-				tmp =
-				    b43_shm_read16(dev, B43_SHM_SHARED, 0x0072);
-				v2 = (s8) (tmp & 0x00FF);
-				v3 = (s8) ((tmp & 0xFF00) >> 8);
-				if (v0 == 0x7F || v1 == 0x7F || v2 == 0x7F
-				    || v3 == 0x7F)
-					return;
-				v0 = (v0 + 0x20) & 0x3F;
-				v1 = (v1 + 0x20) & 0x3F;
-				v2 = (v2 + 0x20) & 0x3F;
-				v3 = (v3 + 0x20) & 0x3F;
-				tmp = 1;
-			}
-			b43_shm_clear_tssi(dev);
-
-			average = (v0 + v1 + v2 + v3 + 2) / 4;
-
-			if (tmp
-			    && (b43_shm_read16(dev, B43_SHM_SHARED, 0x005E) &
-				0x8))
-				average -= 13;
-
-			estimated_pwr =
-			    b43_phy_estimate_power_out(dev, average);
-
-			max_pwr = dev->dev->bus->sprom.maxpwr_bg;
-			if ((dev->dev->bus->sprom.boardflags_lo
-			    & B43_BFL_PACTRL) && (phy->type == B43_PHYTYPE_G))
-				max_pwr -= 0x3;
-			if (unlikely(max_pwr <= 0)) {
-				b43warn(dev->wl,
-					"Invalid max-TX-power value in SPROM.\n");
-				max_pwr = 60;	/* fake it */
-				dev->dev->bus->sprom.maxpwr_bg = max_pwr;
-			}
-
-			/*TODO:
-			   max_pwr = min(REG - dev->dev->bus->sprom.antennagain_bgphy - 0x6, max_pwr)
-			   where REG is the max power as per the regulatory domain
-			 */
+	case B43_PHYTYPE_G:
+		return b43_recalculate_txpower_bgphy(dev, average_tssi);
+	case B43_PHYTYPE_N:
+break;//TODO		return b43_recalculate_txpower_nphy(dev, average_tssi);
+	}
+	B43_WARN_ON(1);
+	return 0;
+}
 
-			/* Get desired power (in Q5.2) */
-			desired_pwr = INT_TO_Q52(phy->power_level);
-			/* And limit it. max_pwr already is Q5.2 */
-			desired_pwr = clamp_val(desired_pwr, 0, max_pwr);
-			if (b43_debug(dev, B43_DBG_XMITPOWER)) {
-				b43dbg(dev->wl,
-				       "Current TX power output: " Q52_FMT
-				       " dBm, " "Desired TX power output: "
-				       Q52_FMT " dBm\n", Q52_ARG(estimated_pwr),
-				       Q52_ARG(desired_pwr));
-			}
-
-			/* Calculate the adjustment delta. */
-			pwr_adjust = desired_pwr - estimated_pwr;
-
-			/* RF attenuation delta. */
-			rfatt_delta = ((pwr_adjust + 7) / 8);
-			/* Lower attenuation => Bigger power output. Negate it. */
-			rfatt_delta = -rfatt_delta;
-
-			/* Baseband attenuation delta. */
-			bbatt_delta = pwr_adjust / 2;
-			/* Lower attenuation => Bigger power output. Negate it. */
-			bbatt_delta = -bbatt_delta;
-			/* RF att affects power level 4 times as much as
-			 * Baseband attennuation. Subtract it. */
-			bbatt_delta -= 4 * rfatt_delta;
+/**
+ * b43_tssi_average_add - Read the 4 TSSI values at the SHM offset.
+ *
+ * Read the 4 TSSI values and store the average in the TX power
+ * context data structure.
+ * Returns 1, if the average value was changed (0 otherwise).
+ *
+ * Requires wl->irq_lock
+ */
+static bool b43_tssi_average_add(struct b43_wldev *dev, u16 shm_offset)
+{
+	const bool is_ofdm = (shm_offset != B43_SHM_SH_TSSI_CCK);
+	unsigned int a, b, c, d;
+	unsigned int average;
+	u32 tmp;
+
+	tmp = b43_shm_read32(dev, B43_SHM_SHARED, shm_offset);
+//printk("Reading TSSI for SHM 0x%04X  0x%08X\n", shm_offset, tmp);
+	a = tmp & 0xFF;
+	b = (tmp >> 8) & 0xFF;
+	c = (tmp >> 16) & 0xFF;
+	d = (tmp >> 24) & 0xFF;
+	if (a == 0 || a == B43_TSSI_MAX ||
+	    b == 0 || b == B43_TSSI_MAX ||
+	    c == 0 || c == B43_TSSI_MAX ||
+	    d == 0 || d == B43_TSSI_MAX)
+		return 0;
+	/* The values are OK. Clear them. */
+	tmp = B43_TSSI_MAX | (B43_TSSI_MAX << 8) |
+	      (B43_TSSI_MAX << 16) | (B43_TSSI_MAX << 24);
+	b43_shm_write32(dev, B43_SHM_SHARED, shm_offset, tmp);
+
+	if (is_ofdm) {//FIXME min?
+		a = (a + 32) & 0x3F;
+		b = (b + 32) & 0x3F;
+		c = (c + 32) & 0x3F;
+		d = (d + 32) & 0x3F;
+	}
+
+	/* Get the average of the values with 0.5 added to each value. */
+	average = (a + b + c + d + 2) / 4;
+printk("Average is %u\n", average);
+	if (is_ofdm) {
+		/* Adjust for CCK-boost */
+		if (b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFLO)
+		    & B43_HF_CCKBOOST) //FIXME
+			average = (average >= 13) ? (average - 13) : 0;
+	}
+	/* And finally add it to the stored average value for later
+	 * use by the hardware adjustment routines. */
+	if (likely(dev->phy.txpwr.average_tssi))
+		average = (average + dev->phy.txpwr.average_tssi) / 2;
+	dev->phy.txpwr.average_tssi = average;
+	B43_WARN_ON(average >= B43_TSSI_MAX);
+
+	return 1;
+}
+
+/**
+ * b43_phy_txpower_check - Check if a TX power adjustment is needed.
+ *
+ * This function will check if a TX power adjustment is needed and
+ * recalculate the attenuation values, if it's the case.
+ * The TX power adjust workqueue is scheduled afterwards to do the
+ * adjustment in hardware.
+ *
+ * Requires wl->irq_lock
+ */
+void b43_phy_txpower_check(struct b43_wldev *dev, unsigned int flags)
+{
+	struct b43_phy *phy = &dev->phy;
+	unsigned long now = jiffies;
+	bool avg_changed = 0, need_hw_adjust;
 
-			/* So do we finally need to adjust something? */
-			if ((rfatt_delta == 0) && (bbatt_delta == 0))
-				return;
+	if (!(flags & B43_TXPWR_IGNORE_TIME)) {
+		/* Check if it's time for a TXpower check. */
+		if (time_before(now, phy->txpwr.next_tssi_average))
+			return; /* Not yet */
+	}
+	/* The next check will be needed in two seconds, or later. */
+	phy->txpwr.next_tssi_average = round_jiffies(now + (HZ * 2));
 
-			/* Calculate the new attenuation values. */
-			bbatt = phy->bbatt.att;
-			bbatt += bbatt_delta;
-			rfatt = phy->rfatt.att;
-			rfatt += rfatt_delta;
-
-			b43_put_attenuation_into_ranges(dev, &bbatt, &rfatt);
-			tx_control = phy->tx_control;
-			if ((phy->radio_ver == 0x2050) && (phy->radio_rev == 2)) {
-				if (rfatt <= 1) {
-					if (tx_control == 0) {
-						tx_control =
-						    B43_TXCTL_PA2DB |
-						    B43_TXCTL_TXMIX;
-						rfatt += 2;
-						bbatt += 2;
-					} else if (dev->dev->bus->sprom.
-						   boardflags_lo &
-						   B43_BFL_PACTRL) {
-						bbatt += 4 * (rfatt - 2);
-						rfatt = 2;
-					}
-				} else if (rfatt > 4 && tx_control) {
-					tx_control = 0;
-					if (bbatt < 3) {
-						rfatt -= 3;
-						bbatt += 2;
-					} else {
-						rfatt -= 2;
-						bbatt -= 2;
-					}
-				}
-			}
-			/* Save the control values */
-			phy->tx_control = tx_control;
-			b43_put_attenuation_into_ranges(dev, &bbatt, &rfatt);
-			phy->rfatt.att = rfatt;
-			phy->bbatt.att = bbatt;
-
-			/* Adjust the hardware */
-			b43_phy_lock(dev);
-			b43_radio_lock(dev);
-			b43_set_txpower_g(dev, &phy->bbatt, &phy->rfatt,
-					  phy->tx_control);
-			b43_radio_unlock(dev);
-			b43_phy_unlock(dev);
-			break;
-		}
+	switch (phy->type) {
+	case B43_PHYTYPE_A:
 	case B43_PHYTYPE_N:
-		b43_nphy_xmitpower(dev);
+		avg_changed |= b43_tssi_average_add(dev,
+					B43_SHM_SH_TSSI_OFDM_A);
+		if (phy->type == B43_PHYTYPE_A)
+			break;
+		/* Fallthrough */
+	case B43_PHYTYPE_G:
+		avg_changed |= b43_tssi_average_add(dev,
+					B43_SHM_SH_TSSI_CCK);
+		avg_changed |= b43_tssi_average_add(dev,
+					B43_SHM_SH_TSSI_OFDM_G);
 		break;
 	default:
 		B43_WARN_ON(1);
 	}
+	if (!(flags & B43_TXPWR_IGNORE_TSSI)) {
+		if (!avg_changed)
+			return; /* No adjustment needed */
+	}
+	need_hw_adjust = b43_recalculate_txpower(dev, phy->txpwr.average_tssi);
+	if (!need_hw_adjust)
+		return; /* No adjustment needed */
+
+	/* We must adjust the transmission power in hardware.
+	 * Schedule the work. */
+	queue_work(dev->wl->hw->workqueue, &dev->wl->txpower_adjust_work);
+}
+
+/**
+ * b43_phy_txpower_adjust_work - TX power workqueue.
+ *
+ * Workqueue for updating the TX power parameters in hardware.
+ */
+void b43_phy_txpower_adjust_work(struct work_struct *work)
+{
+	struct b43_wl *wl = container_of(work, struct b43_wl,
+					 txpower_adjust_work);
+	struct b43_wldev *dev;
+	struct b43_txpower_context ctx;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (unlikely(!dev || b43_status(dev) < B43_STAT_STARTED))
+		goto out_unlock;
+
+	/* We make a local copy of the TX power parameters, so we
+	 * can drop the spinlock and sleep while adjusting the
+	 * hardware. Possible races with b43_phy_txpower_check()
+	 * are harmless, because we will be called again and redo the
+	 * work if a race happened. */
+	spin_lock_irq(&wl->irq_lock);
+	memcpy(&ctx, &dev->phy.txpwr, sizeof(ctx));
+	spin_unlock_irq(&wl->irq_lock);
+
+	b43_adjust_tx_output_power(dev, &ctx);
+
+out_unlock:
+	mutex_unlock(&wl->mutex);
 }
 
 static inline s32 b43_tssi2dbm_ad(s32 num, s32 den)
 {
 	if (num < 0)
 		return num / den;
@@ -1753,68 +1932,68 @@ int b43_phy_init_tssi2dbm_table(struct b
 		pab0 = (s16) (dev->dev->bus->sprom.pa0b0);
 		pab1 = (s16) (dev->dev->bus->sprom.pa0b1);
 		pab2 = (s16) (dev->dev->bus->sprom.pa0b2);
 	}
 
 	if ((dev->dev->bus->chip_id == 0x4301) && (phy->radio_ver != 0x2050)) {
-		phy->tgt_idle_tssi = 0x34;
-		phy->tssi2dbm = b43_tssi2dbm_b_table;
+		phy->txpwr.tgt_idle_tssi = 0x34;
+		phy->txpwr.tssi2dbm = b43_tssi2dbm_b_table;
 		return 0;
 	}
 
 	if (pab0 != 0 && pab1 != 0 && pab2 != 0 &&
 	    pab0 != -1 && pab1 != -1 && pab2 != -1) {
 		/* The pabX values are set in SPROM. Use them. */
 		if (phy->type == B43_PHYTYPE_A) {
 			if ((s8) dev->dev->bus->sprom.itssi_a != 0 &&
 			    (s8) dev->dev->bus->sprom.itssi_a != -1)
-				phy->tgt_idle_tssi =
+				phy->txpwr.tgt_idle_tssi =
 				    (s8) (dev->dev->bus->sprom.itssi_a);
 			else
-				phy->tgt_idle_tssi = 62;
+				phy->txpwr.tgt_idle_tssi = 62;
 		} else {
 			if ((s8) dev->dev->bus->sprom.itssi_bg != 0 &&
 			    (s8) dev->dev->bus->sprom.itssi_bg != -1)
-				phy->tgt_idle_tssi =
+				phy->txpwr.tgt_idle_tssi =
 				    (s8) (dev->dev->bus->sprom.itssi_bg);
 			else
-				phy->tgt_idle_tssi = 62;
+				phy->txpwr.tgt_idle_tssi = 62;
 		}
 		dyn_tssi2dbm = kmalloc(64, GFP_KERNEL);
 		if (dyn_tssi2dbm == NULL) {
 			b43err(dev->wl, "Could not allocate memory "
 			       "for tssi2dbm table\n");
 			return -ENOMEM;
 		}
 		for (idx = 0; idx < 64; idx++)
 			if (b43_tssi2dbm_entry
 			    (dyn_tssi2dbm, idx, pab0, pab1, pab2)) {
-				phy->tssi2dbm = NULL;
+				phy->txpwr.tssi2dbm = NULL;
 				b43err(dev->wl, "Could not generate "
 				       "tssi2dBm table\n");
 				kfree(dyn_tssi2dbm);
 				return -ENODEV;
 			}
-		phy->tssi2dbm = dyn_tssi2dbm;
-		phy->dyn_tssi_tbl = 1;
+		phy->txpwr.tssi2dbm = dyn_tssi2dbm;
+		phy->txpwr.dyn_tssi_tbl = 1;
 	} else {
 		/* pabX values not set in SPROM. */
 		switch (phy->type) {
 		case B43_PHYTYPE_A:
 			/* APHY needs a generated table. */
-			phy->tssi2dbm = NULL;
+			phy->txpwr.tssi2dbm = NULL;
 			b43err(dev->wl, "Could not generate tssi2dBm "
 			       "table (wrong SPROM info)!\n");
 			return -ENODEV;
 		case B43_PHYTYPE_B:
-			phy->tgt_idle_tssi = 0x34;
-			phy->tssi2dbm = b43_tssi2dbm_b_table;
+			phy->txpwr.tgt_idle_tssi = 0x34;
+			phy->txpwr.tssi2dbm = b43_tssi2dbm_b_table;
 			break;
 		case B43_PHYTYPE_G:
-			phy->tgt_idle_tssi = 0x34;
-			phy->tssi2dbm = b43_tssi2dbm_g_table;
+			phy->txpwr.tgt_idle_tssi = 0x34;
+			phy->txpwr.tssi2dbm = b43_tssi2dbm_g_table;
 			break;
 		}
 	}
 
 	return 0;
 }
@@ -3684,13 +3863,15 @@ void b43_radio_set_tx_iq(struct b43_wlde
 	}
 }
 
 int b43_radio_selectchannel(struct b43_wldev *dev,
 			    u8 channel, int synthetic_pu_workaround)
 {
+	struct b43_wl *wl = dev->wl;
 	struct b43_phy *phy = &dev->phy;
+	unsigned long flags;
 	u16 r8, tmp;
 	u16 freq;
 	u16 channelcookie, savedcookie;
 	int err = 0;
 
 	if (channel == 0xFF) {
@@ -3769,13 +3950,16 @@ int b43_radio_selectchannel(struct b43_w
 		b43_radio_write16(dev, 0x0035,
 				  b43_radio_read16(dev, 0x0035) & 0xFFEF);
 		b43_radio_write16(dev, 0x0035, (b43_radio_read16(dev, 0x0035)
 						& 0xFFEF) | 0x0010);
 		b43_radio_set_tx_iq(dev);
 		//TODO: TSSI2dbm workaround
-		b43_phy_xmitpower(dev);	//FIXME correct?
+		spin_lock_irqsave(&wl->irq_lock, flags);
+		b43_phy_txpower_check(dev, B43_TXPWR_IGNORE_TIME |
+					   B43_TXPWR_IGNORE_TSSI); //FIXME correct?
+		spin_unlock_irqrestore(&wl->irq_lock, flags);
 		break;
 	case B43_PHYTYPE_G:
 		if ((channel < 1) || (channel > 14)) {
 			err = -EINVAL;
 			goto out;
 		}
Index: wireless-testing/drivers/net/wireless/b43/phy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy.h	2008-05-02 12:19:03.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy.h	2008-07-26 17:04:20.000000000 +0200
@@ -221,13 +221,12 @@ int b43_phy_init_tssi2dbm_table(struct b
 
 void b43_phy_early_init(struct b43_wldev *dev);
 int b43_phy_init(struct b43_wldev *dev);
 
 void b43_set_rx_antenna(struct b43_wldev *dev, int antenna);
 
-void b43_phy_xmitpower(struct b43_wldev *dev);
 
 /* Returns the boolean whether the board has HardwarePowerControl */
 bool b43_has_hardware_pctl(struct b43_phy *phy);
 /* Returns the boolean whether "TX Magnification" is enabled. */
 #define has_tx_magnification(phy) \
 	(((phy)->rev >= 2) &&			\
@@ -334,7 +333,23 @@ void b43_put_attenuation_into_ranges(str
 				     int *_bbatt, int *_rfatt);
 
 void b43_set_txpower_g(struct b43_wldev *dev,
 		       const struct b43_bbatt *bbatt,
 		       const struct b43_rfatt *rfatt, u8 tx_control);
 
+void b43_phy_txpower_check(struct b43_wldev *dev, unsigned int flags);
+/**
+ * enum b43_phy_txpower_check_flags - Flags for b43_phy_txpower_check()
+ *
+ * @B43_TXPWR_IGNORE_TIME: Ignore the schedule time and force-redo
+ *                         the check now.
+ * @B43_TXPWR_IGNORE_TSSI: Redo the recalculation, even if the average
+ *                         TSSI did not change.
+ */
+enum b43_phy_txpower_check_flags {
+	B43_TXPWR_IGNORE_TIME		= (1 << 0),
+	B43_TXPWR_IGNORE_TSSI		= (1 << 1),
+};
+
+void b43_phy_txpower_adjust_work(struct work_struct *work);
+
 #endif /* B43_PHY_H_ */
Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2008-07-24 12:10:44.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2008-07-26 17:07:30.000000000 +0200
@@ -451,20 +451,20 @@ static ssize_t txpower_g_read_file(struc
 	if (dev->phy.type != B43_PHYTYPE_G) {
 		fappend("Device is not a G-PHY\n");
 		goto out;
 	}
 	fappend("Control:               %s\n", dev->phy.manual_txpower_control ?
 		"MANUAL" : "AUTOMATIC");
-	fappend("Baseband attenuation:  %u\n", dev->phy.bbatt.att);
-	fappend("Radio attenuation:     %u\n", dev->phy.rfatt.att);
+	fappend("Baseband attenuation:  %u\n", dev->phy.txpwr.bbatt.att);
+	fappend("Radio attenuation:     %u\n", dev->phy.txpwr.rfatt.att);
 	fappend("TX Mixer Gain:         %s\n",
-		(dev->phy.tx_control & B43_TXCTL_TXMIX) ? "ON" : "OFF");
+		(dev->phy.txpwr.tx_control & B43_TXCTL_TXMIX) ? "ON" : "OFF");
 	fappend("PA Gain 2dB:           %s\n",
-		(dev->phy.tx_control & B43_TXCTL_PA2DB) ? "ON" : "OFF");
+		(dev->phy.txpwr.tx_control & B43_TXCTL_PA2DB) ? "ON" : "OFF");
 	fappend("PA Gain 3dB:           %s\n",
-		(dev->phy.tx_control & B43_TXCTL_PA3DB) ? "ON" : "OFF");
+		(dev->phy.txpwr.tx_control & B43_TXCTL_PA3DB) ? "ON" : "OFF");
 	fappend("\n\n");
 	fappend("You can write to this file:\n");
 	fappend("Writing \"auto\" enables automatic txpower control.\n");
 	fappend
 	    ("Writing the attenuation values as \"bbatt rfatt txmix pa2db pa3db\" "
 	     "enables manual txpower control.\n");
@@ -480,35 +480,39 @@ static int txpower_g_write_file(struct b
 				const char *buf, size_t count)
 {
 	if (dev->phy.type != B43_PHYTYPE_G)
 		return -ENODEV;
 	if ((count >= 4) && (memcmp(buf, "auto", 4) == 0)) {
 		/* Automatic control */
+		spin_lock_irq(&dev->wl->irq_lock);
 		dev->phy.manual_txpower_control = 0;
-		b43_phy_xmitpower(dev);
+		b43_phy_txpower_check(dev, B43_TXPWR_IGNORE_TIME |
+					   B43_TXPWR_IGNORE_TSSI);
+		spin_unlock_irq(&dev->wl->irq_lock);
 	} else {
 		int bbatt = 0, rfatt = 0, txmix = 0, pa2db = 0, pa3db = 0;
 		/* Manual control */
 		if (sscanf(buf, "%d %d %d %d %d", &bbatt, &rfatt,
 			   &txmix, &pa2db, &pa3db) != 5)
 			return -EINVAL;
 		b43_put_attenuation_into_ranges(dev, &bbatt, &rfatt);
 		dev->phy.manual_txpower_control = 1;
-		dev->phy.bbatt.att = bbatt;
-		dev->phy.rfatt.att = rfatt;
-		dev->phy.tx_control = 0;
+		dev->phy.txpwr.bbatt.att = bbatt;
+		dev->phy.txpwr.rfatt.att = rfatt;
+		dev->phy.txpwr.tx_control = 0;
 		if (txmix)
-			dev->phy.tx_control |= B43_TXCTL_TXMIX;
+			dev->phy.txpwr.tx_control |= B43_TXCTL_TXMIX;
 		if (pa2db)
-			dev->phy.tx_control |= B43_TXCTL_PA2DB;
+			dev->phy.txpwr.tx_control |= B43_TXCTL_PA2DB;
 		if (pa3db)
-			dev->phy.tx_control |= B43_TXCTL_PA3DB;
+			dev->phy.txpwr.tx_control |= B43_TXCTL_PA3DB;
 		b43_phy_lock(dev);
 		b43_radio_lock(dev);
-		b43_set_txpower_g(dev, &dev->phy.bbatt,
-				  &dev->phy.rfatt, dev->phy.tx_control);
+		b43_set_txpower_g(dev, &dev->phy.txpwr.bbatt,
+				  &dev->phy.txpwr.rfatt,
+				  dev->phy.txpwr.tx_control);
 		b43_radio_unlock(dev);
 		b43_phy_unlock(dev);
 	}
 
 	return 0;
 }
@@ -560,13 +564,13 @@ static ssize_t loctls_read_file(struct b
 		err = -ENODEV;
 		goto out;
 	}
 	lo = phy->lo_control;
 	fappend("-- Local Oscillator calibration data --\n\n");
 	fappend("HW-power-control enabled: %d\n",
-		dev->phy.hardware_power_control);
+		dev->phy.txpwr.hardware_power_control);
 	fappend("TX Bias: 0x%02X,  TX Magn: 0x%02X  (expire in %lu sec)\n",
 		lo->tx_bias, lo->tx_magn,
 		calc_expire_secs(now, lo->txctl_measured_time,
 				 B43_LO_TXCTL_EXPIRE));
 	fappend("Power Vector: 0x%08X%08X  (expires in %lu sec)\n",
 		(unsigned int)((lo->power_vector & 0xFFFFFFFF00000000ULL) >> 32),
@@ -575,14 +579,14 @@ static ssize_t loctls_read_file(struct b
 				 B43_LO_PWRVEC_EXPIRE));
 
 	fappend("\nCalibrated settings:\n");
 	list_for_each_entry(cal, &lo->calib_list, list) {
 		bool active;
 
-		active = (b43_compare_bbatt(&cal->bbatt, &phy->bbatt) &&
-			  b43_compare_rfatt(&cal->rfatt, &phy->rfatt));
+		active = (b43_compare_bbatt(&cal->bbatt, &phy->txpwr.bbatt) &&
+			  b43_compare_rfatt(&cal->rfatt, &phy->txpwr.rfatt));
 		fappend("BB(%d), RF(%d,%d)  ->  I=%d, Q=%d  "
 			"(expires in %lu sec)%s\n",
 			cal->bbatt.att,
 			cal->rfatt.att, cal->rfatt.with_padmix,
 			cal->ctl.i, cal->ctl.q,
 			calc_expire_secs(now, cal->calib_time,
Index: wireless-testing/drivers/net/wireless/b43/lo.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/lo.c	2008-06-14 22:50:12.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/lo.c	2008-07-26 01:25:07.000000000 +0200
@@ -918,16 +918,16 @@ static inline void b43_lo_fixup_rfatt(st
 void b43_lo_g_adjust(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_lo_calib *cal;
 	struct b43_rfatt rf;
 
-	memcpy(&rf, &phy->rfatt, sizeof(rf));
+	memcpy(&rf, &phy->txpwr.rfatt, sizeof(rf));
 	b43_lo_fixup_rfatt(&rf);
 
-	cal = b43_get_calib_lo_settings(dev, &phy->bbatt, &rf);
+	cal = b43_get_calib_lo_settings(dev, &phy->txpwr.bbatt, &rf);
 	if (!cal)
 		return;
 	b43_lo_write(dev, &cal->ctl);
 }
 
 void b43_lo_g_adjust_to(struct b43_wldev *dev,
@@ -980,14 +980,14 @@ void b43_lo_g_maintanance_work(struct b4
 	 * Recalibrate the current setting, if expired. */
 	expire = now - B43_LO_CALIB_EXPIRE;
 	list_for_each_entry_safe(cal, tmp, &lo->calib_list, list) {
 		if (!time_before(cal->calib_time, expire))
 			continue;
 		/* This item expired. */
-		if (b43_compare_bbatt(&cal->bbatt, &phy->bbatt) &&
-		    b43_compare_rfatt(&cal->rfatt, &phy->rfatt)) {
+		if (b43_compare_bbatt(&cal->bbatt, &phy->txpwr.bbatt) &&
+		    b43_compare_rfatt(&cal->rfatt, &phy->txpwr.rfatt)) {
 			B43_WARN_ON(current_item_expired);
 			current_item_expired = 1;
 		}
 		if (b43_debug(dev, B43_DBG_LO)) {
 			b43dbg(dev->wl, "LO: Item BB(%u), RF(%u,%u), "
 			       "I=%d, Q=%d expired\n",
@@ -999,13 +999,14 @@ void b43_lo_g_maintanance_work(struct b4
 		kfree(cal);
 	}
 	if (current_item_expired || unlikely(list_empty(&lo->calib_list))) {
 		/* Recalibrate currently used LO setting. */
 		if (b43_debug(dev, B43_DBG_LO))
 			b43dbg(dev->wl, "LO: Recalibrating current LO setting\n");
-		cal = b43_calibrate_lo_setting(dev, &phy->bbatt, &phy->rfatt);
+		cal = b43_calibrate_lo_setting(dev, &phy->txpwr.bbatt,
+					       &phy->txpwr.rfatt);
 		if (cal) {
 			list_add(&cal->list, &lo->calib_list);
 			b43_lo_write(dev, &cal->ctl);
 		} else
 			b43warn(dev->wl, "Failed to recalibrate current LO setting\n");
 	}
Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2008-07-26 01:03:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2008-07-26 17:06:33.000000000 +0200
@@ -675,12 +675,14 @@ void b43_handle_txstatus(struct b43_wlde
 	}
 
 	if (b43_using_pio_transfers(dev))
 		b43_pio_handle_txstatus(dev, status);
 	else
 		b43_dma_handle_txstatus(dev, status);
+
+	b43_phy_txpower_check(dev, 0);
 }
 
 /* Fill out the mac80211 TXstatus report based on the b43-specific
  * txstatus report data. This returns a boolean whether the frame was
  * successfully transmitted. */
 bool b43_fill_txstatus_report(struct ieee80211_tx_info *report,

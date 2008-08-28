Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37161 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbYH1Reo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 13:34:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Rewrite TX power adjustment
Date: Thu, 28 Aug 2008 19:33:40 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200808281933.41136.mb@bu3sch.de> (sfid-20080828_193451_718777_AD8E9367)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch rewrites the TX power recalculation algorithms to scale better
with changed enviromnent. If there's low
TX traffic, the power will be checked against the desired values
every 60 seconds.
If there is high TX traffic, the check is redone every 2 seconds. This improves
the reaction times a lot and confuses the rate control less.
It will also reduce the time it initially takes to tune to a new TX power
value. With the old algorithm it could take about 30 to 45 seconds to settle to
a new power value. This will happen in about two to four seconds now.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next merge window.


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-08-28 18:38:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-08-28 18:38:22.000000000 +0200
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
@@ -645,12 +650,17 @@ struct b43_wl {
 
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
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-08-28 18:38:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-08-28 18:41:27.000000000 +0200
@@ -2802,12 +2802,15 @@ err_gpio_clean:
 static void b43_periodic_every60sec(struct b43_wldev *dev)
 {
 	const struct b43_phy_operations *ops = dev->phy.ops;
 
 	if (ops->pwork_60sec)
 		ops->pwork_60sec(dev);
+
+	/* Force check the TX power emission now. */
+	b43_phy_txpower_check(dev, B43_TXPWR_IGNORE_TIME);
 }
 
 static void b43_periodic_every30sec(struct b43_wldev *dev)
 {
 	/* Update device statistics. */
 	b43_calculate_link_quality(dev);
@@ -2832,14 +2835,12 @@ static void b43_periodic_every15sec(stru
 		}
 	}
 
 	if (phy->ops->pwork_15sec)
 		phy->ops->pwork_15sec(dev);
 
-	phy->ops->xmitpower(dev);
-
 	atomic_set(&phy->txerr_cnt, B43_PHY_TX_BADNESS_LIMIT);
 	wmb();
 }
 
 static void do_periodic_work(struct b43_wldev *dev)
 {
@@ -3379,16 +3380,19 @@ static int b43_op_config(struct ieee8021
 	}
 
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
 
 	/* Adjust the desired TX power level. */
 	if (conf->power_level != 0) {
-		if (conf->power_level != phy->power_level) {
-			phy->power_level = conf->power_level;
-			phy->ops->xmitpower(dev);
+		spin_lock_irqsave(&wl->irq_lock, flags);
+		if (conf->power_level != phy->desired_txpower) {
+			phy->desired_txpower = conf->power_level;
+			b43_phy_txpower_check(dev, B43_TXPWR_IGNORE_TIME |
+						   B43_TXPWR_IGNORE_TSSI);
 		}
+		spin_unlock_irqrestore(&wl->irq_lock, flags);
 	}
 
 	/* Antennas for RX and management frame TX. */
 	antenna = b43_antenna_from_ieee80211(dev, conf->antenna_sel_tx);
 	b43_mgmtframe_txantenna(dev, antenna);
 	antenna = b43_antenna_from_ieee80211(dev, conf->antenna_sel_rx);
@@ -3782,12 +3786,13 @@ static int b43_phy_versioning(struct b43
 }
 
 static void setup_struct_phy_for_init(struct b43_wldev *dev,
 				      struct b43_phy *phy)
 {
 	phy->hardware_power_control = !!modparam_hwpctl;
+	phy->next_txpwr_check_time = jiffies;
 	/* PHY TX errors counter. */
 	atomic_set(&phy->txerr_cnt, B43_PHY_TX_BADNESS_LIMIT);
 }
 
 static void setup_struct_wldev_for_init(struct b43_wldev *dev)
 {
@@ -4201,12 +4206,14 @@ static void b43_op_stop(struct ieee80211
 
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
@@ -4578,12 +4585,13 @@ static int b43_wireless_init(struct ssb_
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
Index: wireless-testing/drivers/net/wireless/b43/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.c	2008-08-28 18:38:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.c	2008-08-28 18:53:16.000000000 +0200
@@ -271,6 +271,97 @@ void b43_software_rfkill(struct b43_wlde
 		state = RFKILL_STATE_SOFT_BLOCKED;
 	}
 
 	phy->ops->software_rfkill(dev, state);
 	phy->radio_on = (state == RFKILL_STATE_UNBLOCKED);
 }
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
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+
+	if (likely(dev && (b43_status(dev) >= B43_STAT_STARTED)))
+		dev->phy.ops->adjust_txpower(dev);
+
+	mutex_unlock(&wl->mutex);
+}
+
+/* Called with wl->irq_lock locked */
+void b43_phy_txpower_check(struct b43_wldev *dev, unsigned int flags)
+{
+	struct b43_phy *phy = &dev->phy;
+	unsigned long now = jiffies;
+	enum b43_txpwr_result result;
+
+	if (!(flags & B43_TXPWR_IGNORE_TIME)) {
+		/* Check if it's time for a TXpower check. */
+		if (time_before(now, phy->next_txpwr_check_time))
+			return; /* Not yet */
+	}
+	/* The next check will be needed in two seconds, or later. */
+	phy->next_txpwr_check_time = round_jiffies(now + (HZ * 2));
+
+	if ((dev->dev->bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM) &&
+	    (dev->dev->bus->boardinfo.type == SSB_BOARD_BU4306))
+		return; /* No software txpower adjustment needed */
+
+ 	result = phy->ops->recalc_txpower(dev, !!(flags & B43_TXPWR_IGNORE_TSSI));
+	if (result == B43_TXPWR_RES_DONE)
+		return; /* We are done. */
+	B43_WARN_ON(result != B43_TXPWR_RES_NEED_ADJUST);
+	B43_WARN_ON(phy->ops->adjust_txpower == NULL);
+
+	/* We must adjust the transmission power in hardware.
+	 * Schedule b43_phy_txpower_adjust_work(). */
+	queue_work(dev->wl->hw->workqueue, &dev->wl->txpower_adjust_work);
+}
+
+int b43_phy_shm_tssi_read(struct b43_wldev *dev, u16 shm_offset)
+{
+	const bool is_ofdm = (shm_offset != B43_SHM_SH_TSSI_CCK);
+	unsigned int a, b, c, d;
+	unsigned int average;
+	u32 tmp;
+
+	tmp = b43_shm_read32(dev, B43_SHM_SHARED, shm_offset);
+	a = tmp & 0xFF;
+	b = (tmp >> 8) & 0xFF;
+	c = (tmp >> 16) & 0xFF;
+	d = (tmp >> 24) & 0xFF;
+	if (a == 0 || a == B43_TSSI_MAX ||
+	    b == 0 || b == B43_TSSI_MAX ||
+	    c == 0 || c == B43_TSSI_MAX ||
+	    d == 0 || d == B43_TSSI_MAX)
+		return -ENOENT;
+	/* The values are OK. Clear them. */
+	tmp = B43_TSSI_MAX | (B43_TSSI_MAX << 8) |
+	      (B43_TSSI_MAX << 16) | (B43_TSSI_MAX << 24);
+	b43_shm_write32(dev, B43_SHM_SHARED, shm_offset, tmp);
+
+	if (is_ofdm) {
+		a = (a + 32) & 0x3F;
+		b = (b + 32) & 0x3F;
+		c = (c + 32) & 0x3F;
+		d = (d + 32) & 0x3F;
+	}
+
+	/* Get the average of the values with 0.5 added to each value. */
+	average = (a + b + c + d + 2) / 4;
+	if (is_ofdm) {
+		/* Adjust for CCK-boost */
+		if (b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFLO)
+		    & B43_HF_CCKBOOST)
+			average = (average >= 13) ? (average - 13) : 0;
+	}
+
+	return average;
+}
Index: wireless-testing/drivers/net/wireless/b43/phy_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.h	2008-08-28 18:38:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.h	2008-08-28 18:38:22.000000000 +0200
@@ -58,12 +58,23 @@ enum {
 
 	B43_ANTENNA_AUTO = B43_ANTENNA_AUTO0,
 	B43_ANTENNA_DEFAULT = B43_ANTENNA_AUTO,
 };
 
 /**
+ * enum b43_txpwr_result - Return value for the recalc_txpower PHY op.
+ *
+ * @B43_TXPWR_RES_NEED_ADJUST:	Values changed. Hardware adjustment is needed.
+ * @B43_TXPWR_RES_DONE:		No more work to do. Everything is done.
+ */
+enum b43_txpwr_result {
+	B43_TXPWR_RES_NEED_ADJUST,
+	B43_TXPWR_RES_DONE,
+};
+
+/**
  * struct b43_phy_operations - Function pointers for PHY ops.
  *
  * @prepare:		Prepare the PHY. This is called before @init.
  * 			Can be NULL, if not required.
  * @init:		Initialize the PHY.
  * 			Must not be NULL.
@@ -93,14 +104,29 @@ enum {
  * 			Must not be NULL.
  * @set_rx_antenna:	Set the antenna used for RX.
  * 			Can be NULL, if not supported.
  * @interf_mitigation:	Switch the Interference Mitigation mode.
  * 			Can be NULL, if not supported.
  *
- * @xmitpower:		FIXME REMOVEME
+ * @recalc_txpower:	Recalculate the transmission power parameters.
+ * 			This callback has to recalculate the TX power settings,
+ * 			but does not need to write them to the hardware, yet.
+ * 			Returns enum b43_txpwr_result to indicate whether the hardware
+ * 			needs to be adjusted.
+ * 			If B43_TXPWR_NEED_ADJUST is returned, @adjust_txpower
+ * 			will be called later.
+ * 			If the parameter "ignore_tssi" is true, the TSSI values should
+ * 			be ignored and a recalculation of the power settings should be
+ * 			done even if the TSSI values did not change.
+ * 			This callback is called with wl->irq_lock held and must not sleep.
  * 			Must not be NULL.
+ * @adjust_txpower:	Write the previously calculated TX power settings
+ * 			(from @recalc_txpower) to the hardware.
+ * 			This function may sleep.
+ * 			Can be NULL, if (and ONLY if) @recalc_txpower _always_
+ * 			returns B43_TXPWR_RES_DONE.
  *
  * @pwork_15sec:	Periodic work. Called every 15 seconds.
  * 			Can be NULL, if not required.
  * @pwork_60sec:	Periodic work. Called every 60 seconds.
  * 			Can be NULL, if not required.
  */
@@ -124,13 +150,15 @@ struct b43_phy_operations {
 	unsigned int (*get_default_chan)(struct b43_wldev *dev);
 	void (*set_rx_antenna)(struct b43_wldev *dev, int antenna);
 	int (*interf_mitigation)(struct b43_wldev *dev,
 				 enum b43_interference_mitigation new_mode);
 
 	/* Transmission power adjustment */
-	void (*xmitpower)(struct b43_wldev *dev);
+	enum b43_txpwr_result (*recalc_txpower)(struct b43_wldev *dev,
+						bool ignore_tssi);
+	void (*adjust_txpower)(struct b43_wldev *dev);
 
 	/* Misc */
 	void (*pwork_15sec)(struct b43_wldev *dev);
 	void (*pwork_60sec)(struct b43_wldev *dev);
 };
 
@@ -180,17 +208,21 @@ struct b43_phy {
 
 	/* Software state of the radio */
 	bool radio_on;
 
 	/* Desired TX power level (in dBm).
 	 * This is set by the user and adjusted in b43_phy_xmitpower(). */
-	u8 power_level;
+	int desired_txpower;
 
 	/* Hardware Power Control enabled? */
 	bool hardware_power_control;
 
+	/* The time (in absolute jiffies) when the next TX power output
+	 * check is needed. */
+	unsigned long next_txpwr_check_time;
+
 	/* current channel */
 	unsigned int channel;
 
 	/* PHY TX errors counter. */
 	atomic_t txerr_cnt;
 
@@ -306,7 +338,44 @@ int b43_switch_channel(struct b43_wldev 
 
 /**
  * b43_software_rfkill - Turn the radio ON or OFF in software.
  */
 void b43_software_rfkill(struct b43_wldev *dev, enum rfkill_state state);
 
+/**
+ * b43_phy_txpower_check - Check TX power output.
+ *
+ * Compare the current TX power output to the desired power emission
+ * and schedule an adjustment in case it mismatches.
+ * Requires wl->irq_lock locked.
+ *
+ * @flags:	OR'ed enum b43_phy_txpower_check_flags flags.
+ * 		See the docs below.
+ */
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
+struct work_struct;
+void b43_phy_txpower_adjust_work(struct work_struct *work);
+
+/**
+ * b43_phy_shm_tssi_read - Read the average of the last 4 TSSI from SHM.
+ *
+ * @shm_offset:		The SHM address to read the values from.
+ *
+ * Returns the average of the 4 TSSI values, or a negative error code.
+ */
+int b43_phy_shm_tssi_read(struct b43_wldev *dev, u16 shm_offset);
+
+
 #endif /* LINUX_B43_PHY_COMMON_H_ */
Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c	2008-08-28 18:38:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_g.c	2008-08-28 19:03:11.000000000 +0200
@@ -2656,12 +2656,13 @@ static int b43_gphy_op_allocate(struct b
 
 	gphy->interfmode = B43_INTERFMODE_NONE;
 
 	/* OFDM-table address caching. */
 	gphy->ofdmtab_addr_direction = B43_OFDMTAB_DIRECTION_UNKNOWN;
 
+	gphy->average_tssi = 0xFF;
 
 	lo = kzalloc(sizeof(*lo), GFP_KERNEL);
 	if (!lo) {
 		err = -ENOMEM;
 		goto err_free_gphy;
 	}
@@ -3008,119 +3009,26 @@ static void b43_put_attenuation_into_ran
 	}
 
 	*_rfatt = clamp_val(rfatt, rf_min, rf_max);
 	*_bbatt = clamp_val(bbatt, bb_min, bb_max);
 }
 
-static void b43_gphy_op_xmitpower(struct b43_wldev *dev)
+static void b43_gphy_op_adjust_txpower(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->dev->bus;
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
-	u16 tmp;
-	s8 v0, v1, v2, v3;
-	s8 average;
-	int max_pwr;
-	int desired_pwr, estimated_pwr, pwr_adjust;
-	int rfatt_delta, bbatt_delta;
 	int rfatt, bbatt;
 	u8 tx_control;
 
-	if (gphy->cur_idle_tssi == 0)
-		return;
-	if ((bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM) &&
-	    (bus->boardinfo.type == SSB_BOARD_BU4306))
-		return;
-
-	tmp = b43_shm_read16(dev, B43_SHM_SHARED, 0x0058);
-	v0 = (s8) (tmp & 0x00FF);
-	v1 = (s8) ((tmp & 0xFF00) >> 8);
-	tmp = b43_shm_read16(dev, B43_SHM_SHARED, 0x005A);
-	v2 = (s8) (tmp & 0x00FF);
-	v3 = (s8) ((tmp & 0xFF00) >> 8);
-	tmp = 0;
-
-	if (v0 == 0x7F || v1 == 0x7F || v2 == 0x7F
-	    || v3 == 0x7F) {
-		tmp = b43_shm_read16(dev, B43_SHM_SHARED, 0x0070);
-		v0 = (s8) (tmp & 0x00FF);
-		v1 = (s8) ((tmp & 0xFF00) >> 8);
-		tmp = b43_shm_read16(dev, B43_SHM_SHARED, 0x0072);
-		v2 = (s8) (tmp & 0x00FF);
-		v3 = (s8) ((tmp & 0xFF00) >> 8);
-		if (v0 == 0x7F || v1 == 0x7F || v2 == 0x7F
-		    || v3 == 0x7F)
-			return;
-		v0 = (v0 + 0x20) & 0x3F;
-		v1 = (v1 + 0x20) & 0x3F;
-		v2 = (v2 + 0x20) & 0x3F;
-		v3 = (v3 + 0x20) & 0x3F;
-		tmp = 1;
-	}
-	b43_shm_clear_tssi(dev);
-
-	average = (v0 + v1 + v2 + v3 + 2) / 4;
-
-	if (tmp && (b43_shm_read16(dev, B43_SHM_SHARED, 0x005E) & 0x8))
-		average -= 13;
-
-	estimated_pwr = b43_gphy_estimate_power_out(dev, average);
-
-	max_pwr = dev->dev->bus->sprom.maxpwr_bg;
-	if ((dev->dev->bus->sprom.boardflags_lo
-	    & B43_BFL_PACTRL) && (phy->type == B43_PHYTYPE_G))
-		max_pwr -= 0x3;
-	if (unlikely(max_pwr <= 0)) {
-		b43warn(dev->wl,
-			"Invalid max-TX-power value in SPROM.\n");
-		max_pwr = 60;	/* fake it */
-		dev->dev->bus->sprom.maxpwr_bg = max_pwr;
-	}
-
-	/*TODO:
-	   max_pwr = min(REG - dev->dev->bus->sprom.antennagain_bgphy - 0x6, max_pwr)
-	   where REG is the max power as per the regulatory domain
-	 */
-
-	/* Get desired power (in Q5.2) */
-	desired_pwr = INT_TO_Q52(phy->power_level);
-	/* And limit it. max_pwr already is Q5.2 */
-	desired_pwr = clamp_val(desired_pwr, 0, max_pwr);
-	if (b43_debug(dev, B43_DBG_XMITPOWER)) {
-		b43dbg(dev->wl,
-		       "Current TX power output: " Q52_FMT
-		       " dBm, " "Desired TX power output: "
-		       Q52_FMT " dBm\n", Q52_ARG(estimated_pwr),
-		       Q52_ARG(desired_pwr));
-	}
-
-	/* Calculate the adjustment delta. */
-	pwr_adjust = desired_pwr - estimated_pwr;
-
-	/* RF attenuation delta. */
-	rfatt_delta = ((pwr_adjust + 7) / 8);
-	/* Lower attenuation => Bigger power output. Negate it. */
-	rfatt_delta = -rfatt_delta;
-
-	/* Baseband attenuation delta. */
-	bbatt_delta = pwr_adjust / 2;
-	/* Lower attenuation => Bigger power output. Negate it. */
-	bbatt_delta = -bbatt_delta;
-	/* RF att affects power level 4 times as much as
-	 * Baseband attennuation. Subtract it. */
-	bbatt_delta -= 4 * rfatt_delta;
-
-	/* So do we finally need to adjust something? */
-	if ((rfatt_delta == 0) && (bbatt_delta == 0))
-		return;
+	spin_lock_irq(&dev->wl->irq_lock);
 
 	/* Calculate the new attenuation values. */
 	bbatt = gphy->bbatt.att;
-	bbatt += bbatt_delta;
+	bbatt += gphy->bbatt_delta;
 	rfatt = gphy->rfatt.att;
-	rfatt += rfatt_delta;
+	rfatt += gphy->rfatt_delta;
 
 	b43_put_attenuation_into_ranges(dev, &bbatt, &rfatt);
 	tx_control = gphy->tx_control;
 	if ((phy->radio_ver == 0x2050) && (phy->radio_rev == 2)) {
 		if (rfatt <= 1) {
 			if (tx_control == 0) {
@@ -3149,21 +3057,134 @@ static void b43_gphy_op_xmitpower(struct
 	/* Save the control values */
 	gphy->tx_control = tx_control;
 	b43_put_attenuation_into_ranges(dev, &bbatt, &rfatt);
 	gphy->rfatt.att = rfatt;
 	gphy->bbatt.att = bbatt;
 
+	/* We drop the lock early, so we can sleep during hardware
+	 * adjustment. Possible races with op_recalc_txpower are harmless,
+	 * as we will be called once again in case we raced. */
+	spin_unlock_irq(&dev->wl->irq_lock);
+
+	if (b43_debug(dev, B43_DBG_XMITPOWER))
+		b43dbg(dev->wl, "Adjusting TX power\n");
+
 	/* Adjust the hardware */
 	b43_phy_lock(dev);
 	b43_radio_lock(dev);
 	b43_set_txpower_g(dev, &gphy->bbatt, &gphy->rfatt,
 			  gphy->tx_control);
 	b43_radio_unlock(dev);
 	b43_phy_unlock(dev);
 }
 
+static enum b43_txpwr_result b43_gphy_op_recalc_txpower(struct b43_wldev *dev,
+							bool ignore_tssi)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_g *gphy = phy->g;
+	unsigned int average_tssi;
+	int cck_result, ofdm_result;
+	int estimated_pwr, desired_pwr, pwr_adjust;
+	int rfatt_delta, bbatt_delta;
+	unsigned int max_pwr;
+
+	/* First get the average TSSI */
+	cck_result = b43_phy_shm_tssi_read(dev, B43_SHM_SH_TSSI_CCK);
+	ofdm_result = b43_phy_shm_tssi_read(dev, B43_SHM_SH_TSSI_OFDM_G);
+	if ((cck_result < 0) && (ofdm_result < 0)) {
+		/* No TSSI information available */
+		if (!ignore_tssi)
+			goto no_adjustment_needed;
+		cck_result = 0;
+		ofdm_result = 0;
+	}
+	if (cck_result < 0)
+		average_tssi = ofdm_result;
+	else if (ofdm_result < 0)
+		average_tssi = cck_result;
+	else
+		average_tssi = (cck_result + ofdm_result) / 2;
+	/* Merge the average with the stored value. */
+	if (likely(gphy->average_tssi != 0xFF))
+		average_tssi = (average_tssi + gphy->average_tssi) / 2;
+	gphy->average_tssi = average_tssi;
+	B43_WARN_ON(average_tssi >= B43_TSSI_MAX);
+
+	/* Estimate the TX power emission based on the TSSI */
+	estimated_pwr = b43_gphy_estimate_power_out(dev, average_tssi);
+
+	B43_WARN_ON(phy->type != B43_PHYTYPE_G);
+	max_pwr = dev->dev->bus->sprom.maxpwr_bg;
+	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_PACTRL)
+		max_pwr -= 3; /* minus 0.75 */
+	if (unlikely(max_pwr >= INT_TO_Q52(30/*dBm*/))) {
+		b43warn(dev->wl,
+			"Invalid max-TX-power value in SPROM.\n");
+		max_pwr = INT_TO_Q52(20); /* fake it */
+		dev->dev->bus->sprom.maxpwr_bg = max_pwr;
+	}
+
+	/* Get desired power (in Q5.2) */
+	if (phy->desired_txpower < 0)
+		desired_pwr = INT_TO_Q52(0);
+	else
+		desired_pwr = INT_TO_Q52(phy->desired_txpower);
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
+	gphy->bbatt_delta = bbatt_delta;
+	gphy->rfatt_delta = rfatt_delta;
+
+	/* We need to adjust the TX power on the device. */
+	return B43_TXPWR_RES_NEED_ADJUST;
+
+no_adjustment_needed:
+	return B43_TXPWR_RES_DONE;
+}
+
 static void b43_gphy_op_pwork_15sec(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 
 	//TODO: update_aci_moving_average
@@ -3220,10 +3241,11 @@ const struct b43_phy_operations b43_phyo
 	.supports_hwpctl	= b43_gphy_op_supports_hwpctl,
 	.software_rfkill	= b43_gphy_op_software_rfkill,
 	.switch_channel		= b43_gphy_op_switch_channel,
 	.get_default_chan	= b43_gphy_op_get_default_chan,
 	.set_rx_antenna		= b43_gphy_op_set_rx_antenna,
 	.interf_mitigation	= b43_gphy_op_interf_mitigation,
-	.xmitpower		= b43_gphy_op_xmitpower,
+	.recalc_txpower		= b43_gphy_op_recalc_txpower,
+	.adjust_txpower		= b43_gphy_op_adjust_txpower,
 	.pwork_15sec		= b43_gphy_op_pwork_15sec,
 	.pwork_60sec		= b43_gphy_op_pwork_60sec,
 };
Index: wireless-testing/drivers/net/wireless/b43/phy_g.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.h	2008-08-28 18:38:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_g.h	2008-08-28 18:38:22.000000000 +0200
@@ -112,13 +112,12 @@ static inline bool b43_compare_bbatt(con
 #define B43_TXCTL_TXMIX		0x10	/* TX Mixer Gain */
 
 struct b43_txpower_lo_control;
 
 struct b43_phy_g {
 	bool initialised;
-	bool dyn_tssi_tbl;	/* tssi2dbm is kmalloc()ed. */
 
 	/* ACI (adjacent channel interference) flags. */
 	bool aci_enable;
 	bool aci_wlan_automatic;
 	bool aci_hw_rssi;
 
@@ -132,33 +131,42 @@ struct b43_phy_g {
 		u16 rfoverval;
 	} radio_off_context;
 
 	u16 minlowsig[2];
 	u16 minlowsigpos[2];
 
-	/* TSSI to dBm table in use */
+	/* Pointer to the table used to convert a
+	 * TSSI value to dBm-Q5.2 */
 	const s8 *tssi2dbm;
+	/* tssi2dbm is kmalloc()ed. Only used for free()ing. */
+	bool dyn_tssi_tbl;
 	/* Target idle TSSI */
 	int tgt_idle_tssi;
 	/* Current idle TSSI */
 	int cur_idle_tssi;
+	/* The current average TSSI.
+	 * Needs irq_lock, as it's updated in the IRQ path. */
+	u8 average_tssi;
+	/* Current TX power level attenuation control values */
+	struct b43_bbatt bbatt;
+	struct b43_rfatt rfatt;
+	u8 tx_control;		/* B43_TXCTL_XXX */
+	/* The calculated attenuation deltas that are used later
+	 * when adjusting the actual power output. */
+	int bbatt_delta;
+	int rfatt_delta;
 
 	/* LocalOscillator control values. */
 	struct b43_txpower_lo_control *lo_control;
 	/* Values from b43_calc_loopback_gain() */
 	s16 max_lb_gain;	/* Maximum Loopback gain in hdB */
 	s16 trsw_rx_gain;	/* TRSW RX gain in hdB */
 	s16 lna_lod_gain;	/* LNA lod */
 	s16 lna_gain;		/* LNA */
 	s16 pga_gain;		/* PGA */
 
-	/* Current TX power level attenuation control values */
-	struct b43_bbatt bbatt;
-	struct b43_rfatt rfatt;
-	u8 tx_control;		/* B43_TXCTL_XXX */
-
 	/* Current Interference Mitigation mode */
 	int interfmode;
 	/* Stack of saved values from the Interference Mitigation code.
 	 * Each value in the stack is layed out as follows:
 	 * bit 0-11:  offset
 	 * bit 12-15: register ID
Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2008-08-28 18:38:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2008-08-28 18:58:20.000000000 +0200
@@ -677,12 +677,14 @@ void b43_handle_txstatus(struct b43_wlde
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
Index: wireless-testing/drivers/net/wireless/b43/nphy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/nphy.c	2008-08-28 18:38:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/nphy.c	2008-08-28 18:38:22.000000000 +0200
@@ -31,16 +31,22 @@
 
 
 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
 {//TODO
 }
 
-void b43_nphy_xmitpower(struct b43_wldev *dev)
+static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
 {//TODO
 }
 
+static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
+							bool ignore_tssi)
+{//TODO
+	return B43_TXPWR_RES_DONE;
+}
+
 static void b43_chantab_radio_upload(struct b43_wldev *dev,
 				     const struct b43_nphy_channeltab_entry *e)
 {
 	b43_radio_write16(dev, B2055_PLL_REF, e->radio_pll_ref);
 	b43_radio_write16(dev, B2055_RF_PLLMOD0, e->radio_rf_pllmod0);
 	b43_radio_write16(dev, B2055_RF_PLLMOD1, e->radio_rf_pllmod1);
@@ -599,23 +605,20 @@ static unsigned int b43_nphy_op_get_defa
 {
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
 		return 1;
 	return 36;
 }
 
-static void b43_nphy_op_xmitpower(struct b43_wldev *dev)
-{//TODO
-}
-
 const struct b43_phy_operations b43_phyops_n = {
 	.allocate		= b43_nphy_op_allocate,
 	.init			= b43_nphy_op_init,
 	.exit			= b43_nphy_op_exit,
 	.phy_read		= b43_nphy_op_read,
 	.phy_write		= b43_nphy_op_write,
 	.radio_read		= b43_nphy_op_radio_read,
 	.radio_write		= b43_nphy_op_radio_write,
 	.software_rfkill	= b43_nphy_op_software_rfkill,
 	.switch_channel		= b43_nphy_op_switch_channel,
 	.get_default_chan	= b43_nphy_op_get_default_chan,
-	.xmitpower		= b43_nphy_op_xmitpower,
+	.recalc_txpower		= b43_nphy_op_recalc_txpower,
+	.adjust_txpower		= b43_nphy_op_adjust_txpower,
 };
Index: wireless-testing/drivers/net/wireless/b43/phy_a.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_a.c	2008-08-28 18:38:21.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_a.c	2008-08-28 18:38:22.000000000 +0200
@@ -502,16 +502,22 @@ static void b43_aphy_op_set_rx_antenna(s
 	}
 
 	hf |= B43_HF_ANTDIVHELP;
 	b43_hf_write(dev, hf);
 }
 
-static void b43_aphy_op_xmitpower(struct b43_wldev *dev)
+static void b43_aphy_op_adjust_txpower(struct b43_wldev *dev)
 {//TODO
 }
 
+static enum b43_txpwr_result b43_aphy_op_recalc_txpower(struct b43_wldev *dev,
+							bool ignore_tssi)
+{//TODO
+	return B43_TXPWR_RES_DONE;
+}
+
 static void b43_aphy_op_pwork_15sec(struct b43_wldev *dev)
 {//TODO
 }
 
 static void b43_aphy_op_pwork_60sec(struct b43_wldev *dev)
 {//TODO
@@ -527,10 +533,11 @@ const struct b43_phy_operations b43_phyo
 	.radio_write		= b43_aphy_op_radio_write,
 	.supports_hwpctl	= b43_aphy_op_supports_hwpctl,
 	.software_rfkill	= b43_aphy_op_software_rfkill,
 	.switch_channel		= b43_aphy_op_switch_channel,
 	.get_default_chan	= b43_aphy_op_get_default_chan,
 	.set_rx_antenna		= b43_aphy_op_set_rx_antenna,
-	.xmitpower		= b43_aphy_op_xmitpower,
+	.recalc_txpower		= b43_aphy_op_recalc_txpower,
+	.adjust_txpower		= b43_aphy_op_adjust_txpower,
 	.pwork_15sec		= b43_aphy_op_pwork_15sec,
 	.pwork_60sec		= b43_aphy_op_pwork_60sec,
 };

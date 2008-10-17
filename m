Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:23643 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbYJQTQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 15:16:14 -0400
Received: by rv-out-0506.google.com with SMTP id k40so710592rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Oct 2008 12:16:13 -0700 (PDT)
Message-ID: <48F8E479.30304@gmail.com> (sfid-20081017_211621_765007_E42D9FD2)
Date: Fri, 17 Oct 2008 12:16:09 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: mb@bu3sch.de, stefano.brivio@polimi.it
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] b43: reduce checkpatch.pl errors
Content-Type: multipart/mixed;
 boundary="------------000002050800070402040505"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000002050800070402040505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

A few changes to reduce checkpatch.pl errors in the b43 driver.  For the 
most part, I only fixed cosmetic things, and left the actual 'code flow' 
untouched (hopefully)!

Diff is against wireless-testing HEAD.

Signed-off-by: John Daiker <daikerjohn@gmail.com>

---



--------------000002050800070402040505
Content-Type: text/x-diff;
 name="b43.checkpatch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="b43.checkpatch.diff"

diff --git a/drivers/net/wireless/b43/debugfs.c b/drivers/net/wireless/b43/debugfs.c
index 06a01da..af5eec7 100644
--- a/drivers/net/wireless/b43/debugfs.c
+++ b/drivers/net/wireless/b43/debugfs.c
@@ -51,8 +51,8 @@ struct b43_debugfs_fops {
 };
 
 static inline
-struct b43_dfs_file * fops_to_dfs_file(struct b43_wldev *dev,
-				       const struct b43_debugfs_fops *dfops)
+struct b43_dfs_file *fops_to_dfs_file(struct b43_wldev *dev,
+				      const struct b43_debugfs_fops *dfops)
 {
 	void *p;
 
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 098f886..e399fe5 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1254,8 +1254,8 @@ static inline int should_inject_overflow(struct b43_dmaring *ring)
 }
 
 /* Static mapping of mac80211's queues (priorities) to b43 DMA rings. */
-static struct b43_dmaring * select_ring_by_priority(struct b43_wldev *dev,
-						    u8 queue_prio)
+static struct b43_dmaring *select_ring_by_priority(struct b43_wldev *dev,
+						   u8 queue_prio)
 {
 	struct b43_dmaring *ring;
 
diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index 6a18a14..7c7cff4 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -36,9 +36,9 @@
 #include <linux/sched.h>
 
 
-static struct b43_lo_calib * b43_find_lo_calib(struct b43_txpower_lo_control *lo,
-					       const struct b43_bbatt *bbatt,
-					       const struct b43_rfatt *rfatt)
+static struct b43_lo_calib *b43_find_lo_calib(struct b43_txpower_lo_control *lo,
+					      const struct b43_bbatt *bbatt,
+					      const struct b43_rfatt *rfatt)
 {
 	struct b43_lo_calib *c;
 
@@ -138,7 +138,7 @@ static u16 lo_measure_feedthrough(struct b43_wldev *dev,
  * "pad_mix_gain" is the PAD Mixer Gain.
  */
 static u16 lo_txctl_register_table(struct b43_wldev *dev,
-				   u16 * value, u16 * pad_mix_gain)
+				   u16 *value, u16 *pad_mix_gain)
 {
 	struct b43_phy *phy = &dev->phy;
 	u16 reg, v, padmix;
@@ -615,14 +615,14 @@ static int lo_probe_possible_loctls(struct b43_wldev *dev,
 	u16 feedth;
 
 	static const struct b43_loctl modifiers[] = {
-		{.i = 1,.q = 1,},
-		{.i = 1,.q = 0,},
-		{.i = 1,.q = -1,},
-		{.i = 0,.q = -1,},
-		{.i = -1,.q = -1,},
-		{.i = -1,.q = 0,},
-		{.i = -1,.q = 1,},
-		{.i = 0,.q = 1,},
+		{.i = 1, .q = 1,},
+		{.i = 1, .q = 0,},
+		{.i = 1, .q = -1,},
+		{.i = 0, .q = -1,},
+		{.i = -1, .q = -1,},
+		{.i = -1, .q = 0,},
+		{.i = -1, .q = 1,},
+		{.i = 0, .q = 1,},
 	};
 
 	if (d->current_state == 0) {
@@ -754,9 +754,9 @@ static void lo_probe_loctls_statemachine(struct b43_wldev *dev,
 }
 
 static
-struct b43_lo_calib * b43_calibrate_lo_setting(struct b43_wldev *dev,
-					       const struct b43_bbatt *bbatt,
-					       const struct b43_rfatt *rfatt)
+struct b43_lo_calib *b43_calibrate_lo_setting(struct b43_wldev *dev,
+					      const struct b43_bbatt *bbatt,
+					      const struct b43_rfatt *rfatt)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
@@ -824,9 +824,9 @@ struct b43_lo_calib * b43_calibrate_lo_setting(struct b43_wldev *dev,
 /* Get a calibrated LO setting for the given attenuation values.
  * Might return a NULL pointer under OOM! */
 static
-struct b43_lo_calib * b43_get_calib_lo_settings(struct b43_wldev *dev,
-						const struct b43_bbatt *bbatt,
-						const struct b43_rfatt *rfatt)
+struct b43_lo_calib *b43_get_calib_lo_settings(struct b43_wldev *dev,
+					       const struct b43_bbatt *bbatt,
+					       const struct b43_rfatt *rfatt)
 {
 	struct b43_txpower_lo_control *lo = dev->phy.g->lo_control;
 	struct b43_lo_calib *c;
@@ -981,7 +981,7 @@ void b43_lo_g_maintanance_work(struct b43_wldev *dev)
 			lo_read_power_vector(dev);
 			b43_gphy_dc_lt_init(dev, 0);
 		}
-		//FIXME Recalc the whole DC table from time to time?
+		/* FIXME Recalc the whole DC table from time to time? */
 	}
 
 	if (hwpctl)
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 86317c1..282f902 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -500,7 +500,7 @@ void b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value)
 }
 
 /* Read HostFlags */
-u64 b43_hf_read(struct b43_wldev * dev)
+u64 b43_hf_read(struct b43_wldev *dev)
 {
 	u64 ret;
 
@@ -526,7 +526,7 @@ void b43_hf_write(struct b43_wldev *dev, u64 value)
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFHI, hi);
 }
 
-void b43_tsf_read(struct b43_wldev *dev, u64 * tsf)
+void b43_tsf_read(struct b43_wldev *dev, u64 *tsf)
 {
 	/* We need to be careful. As we read the TSF from multiple
 	 * registers, we should take care of register overflows.
@@ -637,7 +637,7 @@ void b43_tsf_write(struct b43_wldev *dev, u64 tsf)
 }
 
 static
-void b43_macfilter_set(struct b43_wldev *dev, u16 offset, const u8 * mac)
+void b43_macfilter_set(struct b43_wldev *dev, u16 offset, const u8 *mac)
 {
 	static const u8 zero_addr[ETH_ALEN] = { 0 };
 	u16 data;
@@ -829,7 +829,7 @@ void b43_dummy_transmission(struct b43_wldev *dev)
 }
 
 static void key_write(struct b43_wldev *dev,
-		      u8 index, u8 algorithm, const u8 * key)
+		      u8 index, u8 algorithm, const u8 *key)
 {
 	unsigned int i;
 	u32 offset;
@@ -851,7 +851,7 @@ static void key_write(struct b43_wldev *dev,
 	}
 }
 
-static void keymac_write(struct b43_wldev *dev, u8 index, const u8 * addr)
+static void keymac_write(struct b43_wldev *dev, u8 index, const u8 *addr)
 {
 	u32 addrtmp[2] = { 0, 0, };
 	u8 per_sta_keys_start = 8;
@@ -901,7 +901,7 @@ static void keymac_write(struct b43_wldev *dev, u8 index, const u8 * addr)
 
 static void do_key_write(struct b43_wldev *dev,
 			 u8 index, u8 algorithm,
-			 const u8 * key, size_t key_len, const u8 * mac_addr)
+			 const u8 *key, size_t key_len, const u8 *mac_addr)
 {
 	u8 buf[B43_SEC_KEYSIZE] = { 0, };
 	u8 per_sta_keys_start = 8;
@@ -925,8 +925,8 @@ static void do_key_write(struct b43_wldev *dev,
 
 static int b43_key_write(struct b43_wldev *dev,
 			 int index, u8 algorithm,
-			 const u8 * key, size_t key_len,
-			 const u8 * mac_addr,
+			 const u8 *key, size_t key_len,
+			 const u8 *mac_addr,
 			 struct ieee80211_key_conf *keyconf)
 {
 	int i;
@@ -1011,17 +1011,22 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
 	} else if (ps_flags & B43_PS_DISABLED) {
 		hwps = 0;
 	} else {
-		//TODO: If powersave is not off and FIXME is not set and we are not in adhoc
-		//      and thus is not an AP and we are associated, set bit 25
+		/*
+		 * TODO: If powersave is not off and FIXME is not set and we
+		 * are not in adhoc and thus is not an AP and we are
+		 * associated, set bit 25
+		 */
 	}
 	if (ps_flags & B43_PS_AWAKE) {
 		awake = 1;
 	} else if (ps_flags & B43_PS_ASLEEP) {
 		awake = 0;
 	} else {
-		//TODO: If the device is awake or this is an AP, or we are scanning, or FIXME,
-		//      or we are associated, or FIXME, or the latest PS-Poll packet sent was
-		//      successful, set bit26
+		/*
+		 * TODO: If the device is awake or this is an AP, or we are
+		 * scanning, or FIXME, or we are associated, or FIXME, or the
+		 * latest PS-Poll packet sent was successful, set bit26
+		 */
 	}
 
 /* FIXME: For now we force awake-on and hwps-off */
@@ -1245,10 +1250,12 @@ generate_new:
 static void handle_irq_tbtt_indication(struct b43_wldev *dev)
 {
 	if (b43_is_mode(dev->wl, NL80211_IFTYPE_AP)) {
-		///TODO: PS TBTT
+		/* TODO: PS TBTT */
 	} else {
-		if (1 /*FIXME: the last PSpoll frame was sent successfully */ )
+		if (1) {
+			/*FIXME: the last PSpoll frame was sent successfully */
 			b43_power_saving_ctl_bits(dev, 0);
+		}
 	}
 	if (b43_is_mode(dev->wl, NL80211_IFTYPE_ADHOC))
 		dev->dfq_valid = 1;
@@ -1268,7 +1275,7 @@ static void handle_irq_pmq(struct b43_wldev *dev)
 {
 	u32 tmp;
 
-	//TODO: AP mode.
+	/* TODO: AP mode. */
 
 	while (1) {
 		tmp = b43_read32(dev, B43_MMIO_PS_STATUS);
@@ -1280,7 +1287,7 @@ static void handle_irq_pmq(struct b43_wldev *dev)
 }
 
 static void b43_write_template_common(struct b43_wldev *dev,
-				      const u8 * data, u16 size,
+				      const u8 *data, u16 size,
 				      u16 ram_offset,
 				      u16 shm_size_offset, u8 rate)
 {
@@ -1470,9 +1477,9 @@ static void b43_write_probe_resp_plcp(struct b43_wldev *dev,
  * 2) Patching duration field
  * 3) Stripping TIM
  */
-static const u8 * b43_generate_probe_resp(struct b43_wldev *dev,
-					  u16 *dest_size,
-					  struct ieee80211_rate *rate)
+static const u8 *b43_generate_probe_resp(struct b43_wldev *dev,
+					 u16 *dest_size,
+					 struct ieee80211_rate *rate)
 {
 	const u8 *src_data;
 	u8 *dest_data;
@@ -1674,7 +1681,7 @@ static void b43_update_templates(struct b43_wl *wl)
 	queue_work(wl->hw->workqueue, &wl->beacon_update_trigger);
 }
 
-static void b43_set_ssid(struct b43_wldev *dev, const u8 * ssid, u8 ssid_len)
+static void b43_set_ssid(struct b43_wldev *dev, const u8 *ssid, u8 ssid_len)
 {
 	u32 tmp;
 	u16 i, len;
@@ -2422,7 +2429,8 @@ static int b43_gpio_init(struct b43_wldev *dev)
 		mask |= 0x0060;
 		set |= 0x0060;
 	}
-	if (0 /* FIXME: conditional unknown */ ) {
+	if (0) {
+		/* FIXME: conditional unknown */
 		b43_write16(dev, B43_MMIO_GPIO_MASK,
 			    b43_read16(dev, B43_MMIO_GPIO_MASK)
 			    | 0x0100);
@@ -2921,7 +2929,7 @@ static void b43_security_init(struct b43_wldev *dev)
 	b43_clear_keys(dev);
 }
 
-static int b43_rng_read(struct hwrng *rng, u32 * data)
+static int b43_rng_read(struct hwrng *rng, u32 *data)
 {
 	struct b43_wl *wl = (struct b43_wl *)rng->priv;
 	unsigned long flags;
@@ -3215,7 +3223,7 @@ static void b43_put_phy_into_reset(struct b43_wldev *dev)
 	msleep(1);
 }
 
-static const char * band_to_string(enum ieee80211_band band)
+static const char *band_to_string(enum ieee80211_band band)
 {
 	switch (band) {
 	case IEEE80211_BAND_5GHZ:
@@ -3830,7 +3838,7 @@ static void b43_bluetooth_coext_disable(struct b43_wldev *dev)
 {
 	if (!modparam_btcoex)
 		return;
-	//TODO
+	/* TODO */
 }
 
 static void b43_imcfglo_timeouts_workaround(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
index 0f1a84c..0d0d4a4 100644
--- a/drivers/net/wireless/b43/phy_a.c
+++ b/drivers/net/wireless/b43/phy_a.c
@@ -71,7 +71,7 @@ static s8 b43_aphy_estimate_power_out(struct b43_wldev *dev, s8 tssi)
 	tmp += 0x80;
 	tmp = clamp_val(tmp, 0x00, 0xFF);
 	dbm = aphy->tssi2dbm[tmp];
-	//TODO: There's a FIXME on the specs
+	/* TODO: There's a FIXME on the specs */
 
 	return dbm;
 }
@@ -105,10 +105,10 @@ static void aphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
 	b43_write16(dev, 0x03F0, freq);
 	b43_radio_write16(dev, 0x0008, r8);
 
-	//TODO: write max channel TX power? to Radio 0x2D
+	/* TODO: write max channel TX power? to Radio 0x2D */
 	tmp = b43_radio_read16(dev, 0x002E);
 	tmp &= 0x0080;
-	//TODO: OR tmp with the Power out estimation for this channel?
+	/* TODO: OR tmp with the Power out estimation for this channel? */
 	b43_radio_write16(dev, 0x002E, tmp);
 
 	if (freq >= 4920 && freq <= 5500) {
@@ -143,8 +143,8 @@ static void aphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
 	b43_radio_write16(dev, 0x0035, (b43_radio_read16(dev, 0x0035)
 					& 0xFFEF) | 0x0010);
 	b43_radio_set_tx_iq(dev);
-	//TODO: TSSI2dbm workaround
-//FIXME	b43_phy_xmitpower(dev);
+	/* TODO: TSSI2dbm workaround */
+	/* FIXME b43_phy_xmitpower(dev); */
 }
 
 void b43_radio_init2060(struct b43_wldev *dev)
@@ -282,7 +282,7 @@ static void b43_phy_ww(struct b43_wldev *dev)
 
 static void hardware_pctl_init_aphy(struct b43_wldev *dev)
 {
-	//TODO
+	/* TODO */
 }
 
 void b43_phy_inita(struct b43_wldev *dev)
@@ -326,7 +326,7 @@ void b43_phy_inita(struct b43_wldev *dev)
 		if ((bus->boardinfo.vendor == SSB_BOARDVENDOR_BCM) &&
 		    ((bus->boardinfo.type == SSB_BOARD_BU4306) ||
 		     (bus->boardinfo.type == SSB_BOARD_BU4309))) {
-			; //TODO: A PHY LO
+			; /* TODO: A PHY LO */
 		}
 
 		if (phy->rev >= 3)
@@ -334,7 +334,7 @@ void b43_phy_inita(struct b43_wldev *dev)
 
 		hardware_pctl_init_aphy(dev);
 
-		//TODO: radar detection
+		/* TODO: radar detection */
 	}
 
 	if ((phy->type == B43_PHYTYPE_G) &&
@@ -422,7 +422,7 @@ static void b43_aphy_op_prepare_structs(struct b43_wldev *dev)
 	aphy->tssi2dbm = tssi2dbm;
 	aphy->tgt_idle_tssi = tgt_idle_tssi;
 
-	//TODO init struct b43_phy_a
+	/* TODO init struct b43_phy_a */
 
 }
 
@@ -547,7 +547,8 @@ static unsigned int b43_aphy_op_get_default_chan(struct b43_wldev *dev)
 }
 
 static void b43_aphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
-{//TODO
+{
+	/* TODO */
 	struct b43_phy *phy = &dev->phy;
 	u64 hf;
 	u16 tmp;
@@ -604,21 +605,25 @@ static void b43_aphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
 }
 
 static void b43_aphy_op_adjust_txpower(struct b43_wldev *dev)
-{//TODO
+{
+	/* TODO */
 }
 
 static enum b43_txpwr_result b43_aphy_op_recalc_txpower(struct b43_wldev *dev,
 							bool ignore_tssi)
-{//TODO
+{
+	/* TODO */
 	return B43_TXPWR_RES_DONE;
 }
 
 static void b43_aphy_op_pwork_15sec(struct b43_wldev *dev)
-{//TODO
+{
+	/* TODO */
 }
 
 static void b43_aphy_op_pwork_60sec(struct b43_wldev *dev)
-{//TODO
+{
+	/* TODO */
 }
 
 const struct b43_phy_operations b43_phyops_a = {
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index af37abc..decddcf 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -249,7 +249,7 @@ int b43_switch_channel(struct b43_wldev *dev, unsigned int new_channel)
 	channelcookie = new_channel;
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
 		channelcookie |= 0x100;
-	//FIXME set 40Mhz flag if required
+	/* FIXME set 40Mhz flag if required */
 	savedcookie = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_CHAN);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_CHAN, channelcookie);
 
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 232181f..6c6a054 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -83,40 +83,40 @@ static void generate_rfatt_list(struct b43_wldev *dev,
 
 	/* APHY.rev < 5 || GPHY.rev < 6 */
 	static const struct b43_rfatt rfatt_0[] = {
-		{.att = 3,.with_padmix = 0,},
-		{.att = 1,.with_padmix = 0,},
-		{.att = 5,.with_padmix = 0,},
-		{.att = 7,.with_padmix = 0,},
-		{.att = 9,.with_padmix = 0,},
-		{.att = 2,.with_padmix = 0,},
-		{.att = 0,.with_padmix = 0,},
-		{.att = 4,.with_padmix = 0,},
-		{.att = 6,.with_padmix = 0,},
-		{.att = 8,.with_padmix = 0,},
-		{.att = 1,.with_padmix = 1,},
-		{.att = 2,.with_padmix = 1,},
-		{.att = 3,.with_padmix = 1,},
-		{.att = 4,.with_padmix = 1,},
+		{.att = 3, .with_padmix = 0,},
+		{.att = 1, .with_padmix = 0,},
+		{.att = 5, .with_padmix = 0,},
+		{.att = 7, .with_padmix = 0,},
+		{.att = 9, .with_padmix = 0,},
+		{.att = 2, .with_padmix = 0,},
+		{.att = 0, .with_padmix = 0,},
+		{.att = 4, .with_padmix = 0,},
+		{.att = 6, .with_padmix = 0,},
+		{.att = 8, .with_padmix = 0,},
+		{.att = 1, .with_padmix = 1,},
+		{.att = 2, .with_padmix = 1,},
+		{.att = 3, .with_padmix = 1,},
+		{.att = 4, .with_padmix = 1,},
 	};
 	/* Radio.rev == 8 && Radio.version == 0x2050 */
 	static const struct b43_rfatt rfatt_1[] = {
-		{.att = 2,.with_padmix = 1,},
-		{.att = 4,.with_padmix = 1,},
-		{.att = 6,.with_padmix = 1,},
-		{.att = 8,.with_padmix = 1,},
-		{.att = 10,.with_padmix = 1,},
-		{.att = 12,.with_padmix = 1,},
-		{.att = 14,.with_padmix = 1,},
+		{.att = 2, .with_padmix = 1,},
+		{.att = 4, .with_padmix = 1,},
+		{.att = 6, .with_padmix = 1,},
+		{.att = 8, .with_padmix = 1,},
+		{.att = 10, .with_padmix = 1,},
+		{.att = 12, .with_padmix = 1,},
+		{.att = 14, .with_padmix = 1,},
 	};
 	/* Otherwise */
 	static const struct b43_rfatt rfatt_2[] = {
-		{.att = 0,.with_padmix = 1,},
-		{.att = 2,.with_padmix = 1,},
-		{.att = 4,.with_padmix = 1,},
-		{.att = 6,.with_padmix = 1,},
-		{.att = 8,.with_padmix = 1,},
-		{.att = 9,.with_padmix = 1,},
-		{.att = 9,.with_padmix = 1,},
+		{.att = 0, .with_padmix = 1,},
+		{.att = 2, .with_padmix = 1,},
+		{.att = 4, .with_padmix = 1,},
+		{.att = 6, .with_padmix = 1,},
+		{.att = 8, .with_padmix = 1,},
+		{.att = 9, .with_padmix = 1,},
+		{.att = 9, .with_padmix = 1,},
 	};
 
 	if (!b43_has_hardware_pctl(dev)) {
@@ -823,7 +823,7 @@ static void b43_calc_nrssi_threshold(struct b43_wldev *dev)
  * interference mitigation code.
  * It is save to restore values in random order.
  */
-static void _stack_save(u32 * _stackptr, size_t * stackidx,
+static void _stack_save(u32 *_stackptr, size_t *stackidx,
 			u8 id, u16 offset, u16 value)
 {
 	u32 *stackptr = &(_stackptr[*stackidx]);
@@ -837,7 +837,7 @@ static void _stack_save(u32 * _stackptr, size_t * stackidx,
 	B43_WARN_ON(*stackidx >= B43_INTERFSTACK_SIZE);
 }
 
-static u16 _stack_restore(u32 * stackptr, u8 id, u16 offset)
+static u16 _stack_restore(u32 *stackptr, u8 id, u16 offset)
 {
 	size_t i;
 
@@ -2281,7 +2281,7 @@ static void b43_phy_initg(struct b43_wldev *dev)
 		 * Essentially, what we do here is resetting all NRSSI LT
 		 * entries to -32 (see the clamp_val() in nrssi_hw_update())
 		 */
-		b43_nrssi_hw_update(dev, 0xFFFF);	//FIXME?
+		b43_nrssi_hw_update(dev, 0xFFFF);	/* FIXME? */
 		b43_calc_nrssi_threshold(dev);
 	} else if (phy->gmode || phy->rev >= 2) {
 		if (gphy->nrssi[0] == -1000) {
@@ -2565,8 +2565,8 @@ static s8 b43_tssi2dbm_entry(s8 entry[], u8 index,
 	return 0;
 }
 
-u8 * b43_generate_dyn_tssi2dbm_tab(struct b43_wldev *dev,
-				   s16 pab0, s16 pab1, s16 pab2)
+u8 *b43_generate_dyn_tssi2dbm_tab(struct b43_wldev *dev,
+				  s16 pab0, s16 pab1, s16 pab2)
 {
 	unsigned int i;
 	u8 *tab;
@@ -3215,11 +3215,13 @@ static void b43_gphy_op_pwork_15sec(struct b43_wldev *dev)
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_g *gphy = phy->g;
 
-	//TODO: update_aci_moving_average
+	/* TODO: update_aci_moving_average */
 	if (gphy->aci_enable && gphy->aci_wlan_automatic) {
 		b43_mac_suspend(dev);
-		if (!gphy->aci_enable && 1 /*TODO: not scanning? */ ) {
-			if (0 /*TODO: bunch of conditions */ ) {
+		if (!gphy->aci_enable && 1) {
+			/* TODO: not scanning? */
+			if (0) {
+				/*TODO: bunch of conditions */
 				phy->ops->interf_mitigation(dev,
 					B43_INTERFMODE_MANUALWLAN);
 			}
@@ -3230,7 +3232,7 @@ static void b43_gphy_op_pwork_15sec(struct b43_wldev *dev)
 		b43_mac_enable(dev);
 	} else if (gphy->interfmode == B43_INTERFMODE_NONWLAN &&
 		   phy->rev == 1) {
-		//TODO: implement rev1 workaround
+		/* TODO: implement rev1 workaround */
 	}
 	b43_lo_g_maintanance_work(dev);
 }
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index c5d9dc3..ffcc39a 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -46,7 +46,7 @@ static void b43_lpphy_op_prepare_structs(struct b43_wldev *dev)
 
 	memset(lpphy, 0, sizeof(*lpphy));
 
-	//TODO
+	/* TODO */
 }
 
 static void b43_lpphy_op_free(struct b43_wldev *dev)
@@ -59,7 +59,7 @@ static void b43_lpphy_op_free(struct b43_wldev *dev)
 
 static int b43_lpphy_op_init(struct b43_wldev *dev)
 {
-	//TODO
+	/* TODO */
 
 	return 0;
 }
@@ -103,13 +103,13 @@ static void b43_lpphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 static void b43_lpphy_op_software_rfkill(struct b43_wldev *dev,
 					 enum rfkill_state state)
 {
-	//TODO
+	/* TODO */
 }
 
 static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
 				       unsigned int new_channel)
 {
-	//TODO
+	/* TODO */
 	return 0;
 }
 
@@ -120,18 +120,18 @@ static unsigned int b43_lpphy_op_get_default_chan(struct b43_wldev *dev)
 
 static void b43_lpphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
 {
-	//TODO
+	/* TODO */
 }
 
 static void b43_lpphy_op_adjust_txpower(struct b43_wldev *dev)
 {
-	//TODO
+	/* TODO */
 }
 
 static enum b43_txpwr_result b43_lpphy_op_recalc_txpower(struct b43_wldev *dev,
 							 bool ignore_tssi)
 {
-	//TODO
+	/* TODO */
 	return B43_TXPWR_RES_DONE;
 }
 
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 8bcfda5..d36e600 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -31,16 +31,19 @@
 
 
 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
-{//TODO
+{
+	/* TODO */
 }
 
 static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
-{//TODO
+{
+	/* TODO */
 }
 
 static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 							bool ignore_tssi)
-{//TODO
+{
+	/* TODO */
 	return B43_TXPWR_RES_DONE;
 }
 
@@ -84,7 +87,7 @@ static void b43_chantab_phy_upload(struct b43_wldev *dev,
 
 static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 {
-	//TODO
+	/* TODO */
 }
 
 /* Tune the hardware to a new channel. */
@@ -96,7 +99,7 @@ static int nphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
 	if (!tabent)
 		return -ESRCH;
 
-	//FIXME enable/disable band select upper20 in RXCTL
+	/* FIXME enable/disable band select upper20 in RXCTL */
 	if (0 /*FIXME 5Ghz*/)
 		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, 0x20);
 	else
@@ -270,7 +273,7 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
 	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
 
-	//TODO set RF sequence
+	/TODO set RF sequence
 
 	/* Set narrowband clip threshold */
 	b43_phy_write(dev, B43_NPHY_C1_NBCLIPTHRES, 66);
@@ -313,7 +316,10 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 				~B43_NPHY_C2_INITGAIN_HPVGA2,
 				6 << B43_NPHY_C2_INITGAIN_HPVGA2_SHIFT);
 
-		//FIXME verify that the specs really mean to use autoinc here.
+		/*
+		 * FIXME verify that the specs really mean to use autoinc
+		 * here.
+		 */
 		for (i = 0; i < 3; i++)
 			b43_ntab_write(dev, B43_NTAB16(7, 0x106) + i, 0x673);
 	}
@@ -413,7 +419,7 @@ static void b43_nphy_bphy_init(struct b43_wldev *dev)
 /* RSSI Calibration */
 static void b43_nphy_rssi_cal(struct b43_wldev *dev, u8 type)
 {
-	//TODO
+	/* TODO */
 }
 
 int b43_phy_initn(struct b43_wldev *dev)
@@ -421,7 +427,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	struct b43_phy *phy = &dev->phy;
 	u16 tmp;
 
-	//TODO: Spectral management
+	/* TODO: Spectral management */
 	b43_nphy_tables_init(dev);
 
 	/* Clear all overrides */
@@ -448,8 +454,8 @@ int b43_phy_initn(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_PLOAD_CSENSE_EXTLEN, 80);
 	b43_phy_write(dev, B43_NPHY_C2_BCLIPBKOFF, 511);
 
-	//TODO MIMO-Config
-	//TODO Update TX/RX chain
+	/* TODO MIMO-Config */
+	/* TODO Update TX/RX chain */
 
 	if (phy->rev < 2) {
 		b43_phy_write(dev, B43_NPHY_DUP40_GFBL, 0xAA8);
@@ -464,27 +470,27 @@ int b43_phy_initn(struct b43_wldev *dev)
 	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
 
 	b43_phy_read(dev, B43_NPHY_CLASSCTL); /* dummy read */
-	//TODO read core1/2 clip1 thres regs
+	/* TODO read core1/2 clip1 thres regs */
 
 	if (1 /* FIXME Band is 2.4GHz */)
 		b43_nphy_bphy_init(dev);
-	//TODO disable TX power control
-	//TODO Fix the TX power settings
-	//TODO Init periodic calibration with reason 3
+	/* TODO disable TX power control */
+	/* TODO Fix the TX power settings */
+	/* TODO Init periodic calibration with reason 3 */
 	b43_nphy_rssi_cal(dev, 2);
 	b43_nphy_rssi_cal(dev, 0);
 	b43_nphy_rssi_cal(dev, 1);
-	//TODO get TX gain
-	//TODO init superswitch
-	//TODO calibrate LO
-	//TODO idle TSSI TX pctl
-	//TODO TX power control power setup
-	//TODO table writes
-	//TODO TX power control coefficients
-	//TODO enable TX power control
-	//TODO control antenna selection
-	//TODO init radar detection
-	//TODO reset channel if changed
+	/* TODO get TX gain */
+	/* TODO init superswitch */
+	/* TODO calibrate LO */
+	/* TODO idle TSSI TX pctl */
+	/* TODO TX power control power setup */
+	/* TODO table writes */
+	/* TODO TX power control coefficients */
+	/* TODO enable TX power control */
+	/* TODO control antenna selection */
+	/* TODO init radar detection */
+	/* TODO reset channel if changed */
 
 	b43err(dev->wl, "IEEE 802.11n devices are not supported, yet.\n");
 	return 0;
@@ -509,7 +515,7 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 
 	memset(nphy, 0, sizeof(*nphy));
 
-	//TODO init struct b43_phy_n
+	/* TODO init struct b43_phy_n */
 }
 
 static void b43_nphy_op_free(struct b43_wldev *dev)
@@ -580,7 +586,8 @@ static void b43_nphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 
 static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 					enum rfkill_state state)
-{//TODO
+{
+	/* TODO */
 }
 
 static void b43_nphy_op_switch_analog(struct b43_wldev *dev, bool on)
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index 4015912..578823c 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -55,9 +55,9 @@ static u16 generate_cookie(struct b43_pio_txqueue *q,
 }
 
 static
-struct b43_pio_txqueue * parse_cookie(struct b43_wldev *dev,
-				      u16 cookie,
-				      struct b43_pio_txpacket **pack)
+struct b43_pio_txqueue *parse_cookie(struct b43_wldev *dev,
+				     u16 cookie,
+				     struct b43_pio_txpacket **pack)
 {
 	struct b43_pio *pio = &dev->pio;
 	struct b43_pio_txqueue *q = NULL;
@@ -134,8 +134,8 @@ static u16 pio_rxqueue_offset(struct b43_wldev *dev)
 	return 8;
 }
 
-static struct b43_pio_txqueue * b43_setup_pioqueue_tx(struct b43_wldev *dev,
-						      unsigned int index)
+static struct b43_pio_txqueue *b43_setup_pioqueue_tx(struct b43_wldev *dev,
+						     unsigned int index)
 {
 	struct b43_pio_txqueue *q;
 	struct b43_pio_txpacket *p;
@@ -153,7 +153,7 @@ static struct b43_pio_txqueue * b43_setup_pioqueue_tx(struct b43_wldev *dev,
 
 	q->free_packet_slots = B43_PIO_MAX_NR_TXPACKETS;
 	if (q->rev >= 8) {
-		q->buffer_size = 1920; //FIXME this constant is wrong.
+		q->buffer_size = 1920; /* FIXME this constant is wrong. */
 	} else {
 		q->buffer_size = b43_piotx_read16(q, B43_PIO_TXQBUFSIZE);
 		q->buffer_size -= 80;
@@ -171,8 +171,8 @@ static struct b43_pio_txqueue * b43_setup_pioqueue_tx(struct b43_wldev *dev,
 	return q;
 }
 
-static struct b43_pio_rxqueue * b43_setup_pioqueue_rx(struct b43_wldev *dev,
-						      unsigned int index)
+static struct b43_pio_rxqueue *b43_setup_pioqueue_rx(struct b43_wldev *dev,
+						     unsigned int index)
 {
 	struct b43_pio_rxqueue *q;
 
@@ -308,8 +308,8 @@ err_destroy_bk:
 }
 
 /* Static mapping of mac80211's queues (priorities) to b43 PIO queues. */
-static struct b43_pio_txqueue * select_queue_by_priority(struct b43_wldev *dev,
-							 u8 queue_prio)
+static struct b43_pio_txqueue *select_queue_by_priority(struct b43_wldev *dev,
+							u8 queue_prio)
 {
 	struct b43_pio_txqueue *q;
 
diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
index 7137537..afad423 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -113,7 +113,7 @@ out_unlock:
 	return err;
 }
 
-char * b43_rfkill_led_name(struct b43_wldev *dev)
+char *b43_rfkill_led_name(struct b43_wldev *dev)
 {
 	struct b43_rfkill *rfk = &(dev->wl->rfkill);
 
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 4e23363..6d8f25b 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -38,10 +38,10 @@ struct b2055_inittab_entry {
 #define B2055_INITTAB_ENTRY_OK	0x01
 #define B2055_INITTAB_UPLOAD	0x02
 };
-#define UPLOAD		.flags = B2055_INITTAB_ENTRY_OK | B2055_INITTAB_UPLOAD
+#define UPLOAD		.flags = (B2055_INITTAB_ENTRY_OK | B2055_INITTAB_UPLOAD)
 #define NOUPLOAD	.flags = B2055_INITTAB_ENTRY_OK
 
-static const struct b2055_inittab_entry b2055_inittab [] = {
+static const struct b2055_inittab_entry b2055_inittab[] = {
   [B2055_SP_PINPD]		= { .ghz5 = 0x0080, .ghz2 = 0x0080, NOUPLOAD, },
   [B2055_C1_SP_RSSI]		= { .ghz5 = 0x0000, .ghz2 = 0x0000, NOUPLOAD, },
   [B2055_C1_SP_PDMISC]		= { .ghz5 = 0x0027, .ghz2 = 0x0027, NOUPLOAD, },
diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index 0c0fb15..be15a29 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -634,7 +634,7 @@ void b43_wa_all(struct b43_wldev *dev)
 		b43_wa_boards_a(dev);
 	} else if (phy->type == B43_PHYTYPE_G) {
 		switch (phy->rev) {
-		case 1://XXX review rev1
+		case 1:	/* XXX review rev1 */
 			b43_wa_crs_ed(dev);
 			b43_wa_crs_thr(dev);
 			b43_wa_crs_blank(dev);
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 2fabcf8..c8b5145 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -488,7 +488,7 @@ static s8 b43_rssi_postprocess(struct b43_wldev *dev,
 	return (s8) tmp;
 }
 
-//TODO
+/* TODO */
 #if 0
 static s8 b43_rssinoise_postprocess(struct b43_wldev *dev, u8 in_rssi)
 {
@@ -496,7 +496,7 @@ static s8 b43_rssinoise_postprocess(struct b43_wldev *dev, u8 in_rssi)
 	s8 ret;
 
 	if (phy->type == B43_PHYTYPE_A) {
-		//TODO: Incomplete specs.
+		/* TODO: Incomplete specs. */
 		ret = 0;
 	} else
 		ret = b43_rssi_postprocess(dev, in_rssi, 0, 1, 1);
@@ -579,10 +579,12 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	/* Link quality statistics */
 	status.noise = dev->stats.link_noise;
 	if ((chanstat & B43_RX_CHAN_PHYTYPE) == B43_PHYTYPE_N) {
-//		s8 rssi = max(rxhdr->power0, rxhdr->power1);
-		//TODO: Find out what the rssi value is (dBm or percentage?)
-		//      and also find out what the maximum possible value is.
-		//      Fill status.ssi and status.signal fields.
+/*		s8 rssi = max(rxhdr->power0, rxhdr->power1); */
+		/*
+		 * TODO: Find out what the rssi value is (dBm or percentage?)
+		 * 	and also find out what the maximum possible value is.
+		 * 	Fill status.ssi and status.signal fields.
+		 */
 	} else {
 		status.signal = b43_rssi_postprocess(dev, rxhdr->jssi,
 						  (phystat0 & B43_RX_PHYST0_OFDM),
@@ -670,7 +672,7 @@ void b43_handle_txstatus(struct b43_wldev *dev,
 	if (!status->acked)
 		dev->wl->ieee_stats.dot11ACKFailureCount++;
 	if (status->rts_count) {
-		if (status->rts_count == 0xF)	//FIXME
+		if (status->rts_count == 0xF)	/* FIXME */
 			dev->wl->ieee_stats.dot11RTSFailureCount++;
 		else
 			dev->wl->ieee_stats.dot11RTSSuccessCount++;

--------------000002050800070402040505--

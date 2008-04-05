Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60663 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbYDENFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 09:05:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH v2] b43: Fix PHY TX control words in SHM
Date: Sat, 5 Apr 2008 15:05:00 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804051505.01027.mb@bu3sch.de> (sfid-20080405_140554_707506_1186E376)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the initialization of the PHY TX control words in
shared memory. These control words are used for management frames
like beacons.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is for 2.6.26.
This is a replacement patch for the one I sent yesterday.


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-04-05 14:45:06.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-04-05 14:48:56.000000000 +0200
@@ -727,12 +727,13 @@ struct b43_wl {
 
 	bool radiotap_enabled;
 
 	/* The beacon we are currently using (AP or IBSS mode).
 	 * This beacon stuff is protected by the irq_lock. */
 	struct sk_buff *current_beacon;
+	struct ieee80211_tx_control beacon_txctl;
 	bool beacon0_uploaded;
 	bool beacon1_uploaded;
 	struct work_struct beacon_update_trigger;
 
 	/* The current QOS parameters for the 4 queues.
 	 * This is protected by the irq_lock. */
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-05 14:48:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-05 14:48:56.000000000 +0200
@@ -1278,28 +1278,113 @@ static void b43_write_template_common(st
 		b43_ram_write(dev, ram_offset + i - 2, tmp);
 	}
 	b43_shm_write16(dev, B43_SHM_SHARED, shm_size_offset,
 			size + sizeof(struct b43_plcp_hdr6));
 }
 
+/* Check if the use of the antenna that ieee80211 told us to
+ * use is possible. This will fall back to DEFAULT.
+ * "antenna_nr" is the antenna identifier we got from ieee80211. */
+u8 b43_ieee80211_antenna_sanitize(struct b43_wldev *dev,
+				  u8 antenna_nr)
+{
+	u8 antenna_mask;
+
+	if (antenna_nr == 0) {
+		/* Zero means "use default antenna". That's always OK. */
+		return 0;
+	}
+
+	/* Get the mask of available antennas. */
+	if (dev->phy.gmode)
+		antenna_mask = dev->dev->bus->sprom.ant_available_bg;
+	else
+		antenna_mask = dev->dev->bus->sprom.ant_available_a;
+
+	if (!(antenna_mask & (1 << (antenna_nr - 1)))) {
+		/* This antenna is not available. Fall back to default. */
+		return 0;
+	}
+
+	return antenna_nr;
+}
+
+static int b43_antenna_from_ieee80211(struct b43_wldev *dev, u8 antenna)
+{
+	antenna = b43_ieee80211_antenna_sanitize(dev, antenna);
+	switch (antenna) {
+	case 0:		/* default/diversity */
+		return B43_ANTENNA_DEFAULT;
+	case 1:		/* Antenna 0 */
+		return B43_ANTENNA0;
+	case 2:		/* Antenna 1 */
+		return B43_ANTENNA1;
+	case 3:		/* Antenna 2 */
+		return B43_ANTENNA2;
+	case 4:		/* Antenna 3 */
+		return B43_ANTENNA3;
+	default:
+		return B43_ANTENNA_DEFAULT;
+	}
+}
+
+/* Convert a b43 antenna number value to the PHY TX control value. */
+static u16 b43_antenna_to_phyctl(int antenna)
+{
+	switch (antenna) {
+	case B43_ANTENNA0:
+		return B43_TXH_PHY_ANT0;
+	case B43_ANTENNA1:
+		return B43_TXH_PHY_ANT1;
+	case B43_ANTENNA2:
+		return B43_TXH_PHY_ANT2;
+	case B43_ANTENNA3:
+		return B43_TXH_PHY_ANT3;
+	case B43_ANTENNA_AUTO:
+		return B43_TXH_PHY_ANT01AUTO;
+	}
+	B43_WARN_ON(1);
+	return 0;
+}
+
 static void b43_write_beacon_template(struct b43_wldev *dev,
 				      u16 ram_offset,
-				      u16 shm_size_offset, u8 rate)
+				      u16 shm_size_offset)
 {
 	unsigned int i, len, variable_len;
 	const struct ieee80211_mgmt *bcn;
 	const u8 *ie;
 	bool tim_found = 0;
+	unsigned int rate;
+	u16 ctl;
+	int antenna;
 
 	bcn = (const struct ieee80211_mgmt *)(dev->wl->current_beacon->data);
 	len = min((size_t) dev->wl->current_beacon->len,
 		  0x200 - sizeof(struct b43_plcp_hdr6));
+	rate = dev->wl->beacon_txctl.tx_rate->hw_value;
 
 	b43_write_template_common(dev, (const u8 *)bcn,
 				  len, ram_offset, shm_size_offset, rate);
 
+	/* Write the PHY TX control parameters. */
+	antenna = b43_antenna_from_ieee80211(dev,
+			dev->wl->beacon_txctl.antenna_sel_tx);
+	antenna = b43_antenna_to_phyctl(antenna);
+	ctl = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_BEACPHYCTL);
+	/* We can't send beacons with short preamble. Would get PHY errors. */
+	ctl &= ~B43_TXH_PHY_SHORTPRMBL;
+	ctl &= ~B43_TXH_PHY_ANT;
+	ctl &= ~B43_TXH_PHY_ENC;
+	ctl |= antenna;
+	if (b43_is_cck_rate(rate))
+		ctl |= B43_TXH_PHY_ENC_CCK;
+	else
+		ctl |= B43_TXH_PHY_ENC_OFDM;
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_BEACPHYCTL, ctl);
+
 	/* Find the position of the TIM and the DTIM_period value
 	 * and write them to SHM. */
 	ie = bcn->u.beacon.variable;
 	variable_len = len - offsetof(struct ieee80211_mgmt, u.beacon.variable);
 	for (i = 0; i < variable_len - 2; ) {
 		uint8_t ie_id, ie_len;
@@ -1471,25 +1556,23 @@ static void handle_irq_beacon(struct b43
 		dev->irq_savedstate |= B43_IRQ_BEACON;
 		return;
 	}
 
 	if (!beacon0_valid) {
 		if (!wl->beacon0_uploaded) {
-			b43_write_beacon_template(dev, 0x68, 0x18,
-						  B43_CCK_RATE_1MB);
+			b43_write_beacon_template(dev, 0x68, 0x18);
 			b43_write_probe_resp_template(dev, 0x268, 0x4A,
 						      &__b43_ratetable[3]);
 			wl->beacon0_uploaded = 1;
 		}
 		cmd = b43_read32(dev, B43_MMIO_MACCMD);
 		cmd |= B43_MACCMD_BEACON0_VALID;
 		b43_write32(dev, B43_MMIO_MACCMD, cmd);
 	} else if (!beacon1_valid) {
 		if (!wl->beacon1_uploaded) {
-			b43_write_beacon_template(dev, 0x468, 0x1A,
-						  B43_CCK_RATE_1MB);
+			b43_write_beacon_template(dev, 0x468, 0x1A);
 			wl->beacon1_uploaded = 1;
 		}
 		cmd = b43_read32(dev, B43_MMIO_MACCMD);
 		cmd |= B43_MACCMD_BEACON1_VALID;
 		b43_write32(dev, B43_MMIO_MACCMD, cmd);
 	}
@@ -1516,23 +1599,25 @@ static void b43_beacon_update_trigger_wo
 	}
 	mutex_unlock(&wl->mutex);
 }
 
 /* Asynchronously update the packet templates in template RAM.
  * Locking: Requires wl->irq_lock to be locked. */
-static void b43_update_templates(struct b43_wl *wl, struct sk_buff *beacon)
+static void b43_update_templates(struct b43_wl *wl, struct sk_buff *beacon,
+				 const struct ieee80211_tx_control *txctl)
 {
 	/* This is the top half of the ansynchronous beacon update.
 	 * The bottom half is the beacon IRQ.
 	 * Beacon update must be asynchronous to avoid sending an
 	 * invalid beacon. This can happen for example, if the firmware
 	 * transmits a beacon while we are updating it. */
 
 	if (wl->current_beacon)
 		dev_kfree_skb_any(wl->current_beacon);
 	wl->current_beacon = beacon;
+	memcpy(&wl->beacon_txctl, txctl, sizeof(wl->beacon_txctl));
 	wl->beacon0_uploaded = 0;
 	wl->beacon1_uploaded = 0;
 	queue_work(wl->hw->workqueue, &wl->beacon_update_trigger);
 }
 
 static void b43_set_ssid(struct b43_wldev *dev, const u8 * ssid, u8 ssid_len)
@@ -2360,44 +2445,34 @@ static void b43_rate_memory_init(struct 
 		break;
 	default:
 		B43_WARN_ON(1);
 	}
 }
 
+/* Set the default values for the PHY TX Control Words. */
+static void b43_set_phytxctl_defaults(struct b43_wldev *dev)
+{
+	u16 ctl = 0;
+
+	ctl |= B43_TXH_PHY_ENC_CCK;
+	ctl |= B43_TXH_PHY_ANT01AUTO;
+	ctl |= B43_TXH_PHY_TXPWR;
+
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_BEACPHYCTL, ctl);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_ACKCTSPHYCTL, ctl);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PRPHYCTL, ctl);
+}
+
 /* Set the TX-Antenna for management frames sent by firmware. */
 static void b43_mgmtframe_txantenna(struct b43_wldev *dev, int antenna)
 {
-	u16 ant = 0;
+	u16 ant;
 	u16 tmp;
 
-	switch (antenna) {
-	case B43_ANTENNA0:
-		ant |= B43_TXH_PHY_ANT0;
-		break;
-	case B43_ANTENNA1:
-		ant |= B43_TXH_PHY_ANT1;
-		break;
-	case B43_ANTENNA2:
-		ant |= B43_TXH_PHY_ANT2;
-		break;
-	case B43_ANTENNA3:
-		ant |= B43_TXH_PHY_ANT3;
-		break;
-	case B43_ANTENNA_AUTO:
-		ant |= B43_TXH_PHY_ANT01AUTO;
-		break;
-	default:
-		B43_WARN_ON(1);
-	}
-
-	/* FIXME We also need to set the other flags of the PHY control field somewhere. */
+	ant = b43_antenna_to_phyctl(antenna);
 
-	/* For Beacons */
-	tmp = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_BEACPHYCTL);
-	tmp = (tmp & ~B43_TXH_PHY_ANT) | ant;
-	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_BEACPHYCTL, tmp);
 	/* For ACK/CTS */
 	tmp = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_ACKCTSPHYCTL);
 	tmp = (tmp & ~B43_TXH_PHY_ANT) | ant;
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_ACKCTSPHYCTL, tmp);
 	/* For Probe Resposes */
 	tmp = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_PRPHYCTL);
@@ -3109,58 +3184,12 @@ static int b43_switch_band(struct b43_wl
 init_failure:
 	/* Whoops, failed to init the new core. No core is operating now. */
 	wl->current_dev = NULL;
 	return err;
 }
 
-/* Check if the use of the antenna that ieee80211 told us to
- * use is possible. This will fall back to DEFAULT.
- * "antenna_nr" is the antenna identifier we got from ieee80211. */
-u8 b43_ieee80211_antenna_sanitize(struct b43_wldev *dev,
-				  u8 antenna_nr)
-{
-	u8 antenna_mask;
-
-	if (antenna_nr == 0) {
-		/* Zero means "use default antenna". That's always OK. */
-		return 0;
-	}
-
-	/* Get the mask of available antennas. */
-	if (dev->phy.gmode)
-		antenna_mask = dev->dev->bus->sprom.ant_available_bg;
-	else
-		antenna_mask = dev->dev->bus->sprom.ant_available_a;
-
-	if (!(antenna_mask & (1 << (antenna_nr - 1)))) {
-		/* This antenna is not available. Fall back to default. */
-		return 0;
-	}
-
-	return antenna_nr;
-}
-
-static int b43_antenna_from_ieee80211(struct b43_wldev *dev, u8 antenna)
-{
-	antenna = b43_ieee80211_antenna_sanitize(dev, antenna);
-	switch (antenna) {
-	case 0:		/* default/diversity */
-		return B43_ANTENNA_DEFAULT;
-	case 1:		/* Antenna 0 */
-		return B43_ANTENNA0;
-	case 2:		/* Antenna 1 */
-		return B43_ANTENNA1;
-	case 3:		/* Antenna 2 */
-		return B43_ANTENNA2;
-	case 4:		/* Antenna 3 */
-		return B43_ANTENNA3;
-	default:
-		return B43_ANTENNA_DEFAULT;
-	}
-}
-
 static int b43_op_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev;
 	struct b43_phy *phy;
 	unsigned long flags;
@@ -3402,14 +3431,16 @@ static int b43_op_config_interface(struc
 	else
 		memset(wl->bssid, 0, ETH_ALEN);
 	if (b43_status(dev) >= B43_STAT_INITIALIZED) {
 		if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
 			B43_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
 			b43_set_ssid(dev, conf->ssid, conf->ssid_len);
-			if (conf->beacon)
-				b43_update_templates(wl, conf->beacon);
+			if (conf->beacon) {
+				b43_update_templates(wl, conf->beacon,
+						     conf->beacon_control);
+			}
 		}
 		b43_write_mac_bssid_templates(dev);
 	}
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 	mutex_unlock(&wl->mutex);
 
@@ -3874,12 +3905,13 @@ static int b43_wireless_core_init(struct
 	 * Setting the MaxTime to one usec will always trigger
 	 * a timeout, so we never send any probe resp.
 	 * A timeout of zero is infinite. */
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_PRMAXTIME, 1);
 
 	b43_rate_memory_init(dev);
+	b43_set_phytxctl_defaults(dev);
 
 	/* Minimum Contention Window */
 	if (phy->type == B43_PHYTYPE_B) {
 		b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MINCONT, 0x1F);
 	} else {
 		b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MINCONT, 0xF);
@@ -4084,22 +4116,23 @@ out_unlock:
 
 static int b43_op_beacon_set_tim(struct ieee80211_hw *hw, int aid, int set)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct sk_buff *beacon;
 	unsigned long flags;
+	struct ieee80211_tx_control txctl;
 
 	/* We could modify the existing beacon and set the aid bit in
 	 * the TIM field, but that would probably require resizing and
 	 * moving of data within the beacon template.
 	 * Simply request a new beacon and let mac80211 do the hard work. */
-	beacon = ieee80211_beacon_get(hw, wl->vif, NULL);
+	beacon = ieee80211_beacon_get(hw, wl->vif, &txctl);
 	if (unlikely(!beacon))
 		return -ENOMEM;
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43_update_templates(wl, beacon);
+	b43_update_templates(wl, beacon, &txctl);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	return 0;
 }
 
 static int b43_op_ibss_beacon_update(struct ieee80211_hw *hw,
@@ -4107,13 +4140,13 @@ static int b43_op_ibss_beacon_update(str
 				     struct ieee80211_tx_control *ctl)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	unsigned long flags;
 
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	b43_update_templates(wl, beacon);
+	b43_update_templates(wl, beacon, ctl);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	return 0;
 }
 
 static void b43_op_sta_notify(struct ieee80211_hw *hw,

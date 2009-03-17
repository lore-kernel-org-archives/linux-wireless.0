Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50342 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZCQES3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 00:18:29 -0400
Date: Mon, 16 Mar 2009 23:18:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: david@identd.dyndns.org
Cc: linux-wireless@vger.kernel.org
Subject: [RFT/RFC 2/2] b43legacy: Beacon IRQ changes
Message-ID: <49bf248f.XzFFJoNYeRJgRKi6%Larry.Finger@lwfinger.net> (sfid-20090317_051846_502856_60203B43)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch ports commit c97a4ccc1fad35d3 "b43: Fix beacon BH update" to
b43legacy. It fixes beacon updating in the bottomhalf. In case the device
is busy, we will defer to later in the IRQ handler.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
@@ -259,7 +259,6 @@
 
 #define B43legacy_IRQ_ALL		0xFFFFFFFF
 #define B43legacy_IRQ_MASKTEMPLATE	(B43legacy_IRQ_MAC_SUSPENDED |	\
-					 B43legacy_IRQ_BEACON |		\
 					 B43legacy_IRQ_TBTT_INDI |	\
 					 B43legacy_IRQ_ATIM_END |	\
 					 B43legacy_IRQ_PMQ |		\
@@ -615,6 +614,7 @@ struct b43legacy_wl {
 	struct sk_buff *current_beacon;
 	bool beacon0_uploaded;
 	bool beacon1_uploaded;
+	bool beacon_templates_virgin; /* Never wrote the templates? */
 	struct work_struct beacon_update_trigger;
 };
 
Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -955,23 +955,54 @@ static void b43legacy_write_template_com
 			      size + sizeof(struct b43legacy_plcp_hdr6));
 }
 
+/* Convert a b43legacy antenna number value to the PHY TX control value. */
+static u16 b43legacy_antenna_to_phyctl(int antenna)
+{
+	switch (antenna) {
+	case B43legacy_ANTENNA0:
+		return B43legacy_TX4_PHY_ANT0;
+	case B43legacy_ANTENNA1:
+		return B43legacy_TX4_PHY_ANT1;
+	}
+	return B43legacy_TX4_PHY_ANTLAST;
+}
+
 static void b43legacy_write_beacon_template(struct b43legacy_wldev *dev,
 					    u16 ram_offset,
-					    u16 shm_size_offset, u8 rate)
+					    u16 shm_size_offset)
 {
 
 	unsigned int i, len, variable_len;
 	const struct ieee80211_mgmt *bcn;
 	const u8 *ie;
 	bool tim_found = 0;
+	unsigned int rate;
+	u16 ctl;
+	int antenna;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(dev->wl->current_beacon);
 
 	bcn = (const struct ieee80211_mgmt *)(dev->wl->current_beacon->data);
 	len = min((size_t)dev->wl->current_beacon->len,
 		  0x200 - sizeof(struct b43legacy_plcp_hdr6));
+	rate = ieee80211_get_tx_rate(dev->wl->hw, info)->hw_value;
 
 	b43legacy_write_template_common(dev, (const u8 *)bcn, len, ram_offset,
 					shm_size_offset, rate);
 
+	/* Write the PHY TX control parameters. */
+	antenna = B43legacy_ANTENNA_DEFAULT;
+	antenna = b43legacy_antenna_to_phyctl(antenna);
+	ctl = b43legacy_shm_read16(dev, B43legacy_SHM_SHARED,
+				   B43legacy_SHM_SH_BEACPHYCTL);
+	/* We can't send beacons with short preamble. Would get PHY errors. */
+	ctl &= ~B43legacy_TX4_PHY_SHORTPRMBL;
+	ctl &= ~B43legacy_TX4_PHY_ANT;
+	ctl &= ~B43legacy_TX4_PHY_ENC;
+	ctl |= antenna;
+	ctl |= B43legacy_TX4_PHY_ENC_CCK;
+	b43legacy_shm_write16(dev, B43legacy_SHM_SHARED,
+			      B43legacy_SHM_SH_BEACPHYCTL, ctl);
+
 	/* Find the position of the TIM and the DTIM_period value
 	 * and write them to SHM. */
 	ie = bcn->u.beacon.variable;
@@ -1026,7 +1057,7 @@ static void b43legacy_write_probe_resp_p
 	__le16 dur;
 
 	plcp.data = 0;
-	b43legacy_generate_plcp_hdr(&plcp, size + FCS_LEN, rate->bitrate);
+	b43legacy_generate_plcp_hdr(&plcp, size + FCS_LEN, rate->hw_value);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
 					       dev->wl->vif,
 					       size,
@@ -1130,10 +1161,82 @@ static void b43legacy_write_probe_resp_t
 		   0x200 - sizeof(struct b43legacy_plcp_hdr6));
 	b43legacy_write_template_common(dev, probe_resp_data,
 					size, ram_offset,
-					shm_size_offset, rate->bitrate);
+					shm_size_offset, rate->hw_value);
 	kfree(probe_resp_data);
 }
 
+static void b43legacy_upload_beacon0(struct b43legacy_wldev *dev)
+{
+	struct b43legacy_wl *wl = dev->wl;
+
+	if (wl->beacon0_uploaded)
+		return;
+	b43legacy_write_beacon_template(dev, 0x68, 0x18);
+	/* FIXME: Probe resp upload doesn't really belong here,
+	 *        but we don't use that feature anyway. */
+	b43legacy_write_probe_resp_template(dev, 0x268, 0x4A,
+				      &__b43legacy_ratetable[3]);
+	wl->beacon0_uploaded = 1;
+}
+
+static void b43legacy_upload_beacon1(struct b43legacy_wldev *dev)
+{
+	struct b43legacy_wl *wl = dev->wl;
+
+	if (wl->beacon1_uploaded)
+		return;
+	b43legacy_write_beacon_template(dev, 0x468, 0x1A);
+	wl->beacon1_uploaded = 1;
+}
+
+static void handle_irq_beacon(struct b43legacy_wldev *dev)
+{
+	struct b43legacy_wl *wl = dev->wl;
+	u32 cmd, beacon0_valid, beacon1_valid;
+
+	if (!b43legacy_is_mode(wl, NL80211_IFTYPE_AP))
+		return;
+
+	/* This is the bottom half of the asynchronous beacon update. */
+
+	/* Ignore interrupt in the future. */
+	dev->irq_savedstate &= ~B43legacy_IRQ_BEACON;
+
+	cmd = b43legacy_read32(dev, B43legacy_MMIO_MACCMD);
+	beacon0_valid = (cmd & B43legacy_MACCMD_BEACON0_VALID);
+	beacon1_valid = (cmd & B43legacy_MACCMD_BEACON1_VALID);
+
+	/* Schedule interrupt manually, if busy. */
+	if (beacon0_valid && beacon1_valid) {
+		b43legacy_write32(dev, B43legacy_MMIO_GEN_IRQ_REASON, B43legacy_IRQ_BEACON);
+		dev->irq_savedstate |= B43legacy_IRQ_BEACON;
+		return;
+	}
+
+	if (unlikely(wl->beacon_templates_virgin)) {
+		/* We never uploaded a beacon before.
+		 * Upload both templates now, but only mark one valid. */
+		wl->beacon_templates_virgin = 0;
+		b43legacy_upload_beacon0(dev);
+		b43legacy_upload_beacon1(dev);
+		cmd = b43legacy_read32(dev, B43legacy_MMIO_MACCMD);
+		cmd |= B43legacy_MACCMD_BEACON0_VALID;
+		b43legacy_write32(dev, B43legacy_MMIO_MACCMD, cmd);
+	} else {
+		if (!beacon0_valid) {
+			b43legacy_upload_beacon0(dev);
+			cmd = b43legacy_read32(dev, B43legacy_MMIO_MACCMD);
+			cmd |= B43legacy_MACCMD_BEACON0_VALID;
+			b43legacy_write32(dev, B43legacy_MMIO_MACCMD, cmd);
+		} else if (!beacon1_valid) {
+			b43legacy_upload_beacon1(dev);
+			cmd = b43legacy_read32(dev, B43legacy_MMIO_MACCMD);
+			cmd |= B43legacy_MACCMD_BEACON1_VALID;
+			b43legacy_write32(dev, B43legacy_MMIO_MACCMD, cmd);
+		}
+	}
+}
+
 static void b43legacy_beacon_update_trigger_work(struct work_struct *work)
 {
 	struct b43legacy_wl *wl = container_of(work, struct b43legacy_wl,
@@ -1143,13 +1246,14 @@ static void b43legacy_beacon_update_trig
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
 	if (likely(dev && (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED))) {
-		/* Force the microcode to trigger the
-		 * beacon update bottom-half IRQ. */
 		spin_lock_irq(&wl->irq_lock);
-		b43legacy_write32(dev, B43legacy_MMIO_MACCMD,
-			    b43legacy_read32(dev, B43legacy_MMIO_MACCMD)
-			    | B43legacy_MACCMD_BEACON0_VALID
-			    | B43legacy_MACCMD_BEACON1_VALID);
+		/* update beacon right away or defer to irq */
+		dev->irq_savedstate = b43legacy_read32(dev, B43legacy_MMIO_GEN_IRQ_MASK);
+		handle_irq_beacon(dev);
+		/* The handler might have updated the IRQ mask. */
+		b43legacy_write32(dev, B43legacy_MMIO_GEN_IRQ_MASK,
+			    dev->irq_savedstate);
+		mmiowb();
 		spin_unlock_irq(&wl->irq_lock);
 	}
 	mutex_unlock(&wl->mutex);
@@ -1198,45 +1302,6 @@ static void b43legacy_set_beacon_int(str
 	b43legacydbg(dev->wl, "Set beacon interval to %u\n", beacon_int);
 }
 
-static void handle_irq_beacon(struct b43legacy_wldev *dev)
-{
-	struct b43legacy_wl *wl = dev->wl;
-	u32 cmd;
-	u32 beacon0_valid, beacon1_valid;
-
-	if (!b43legacy_is_mode(wl, NL80211_IFTYPE_AP))
-		return;
-
-	/* This is the bottom half of the asynchronous beacon update. */
-
-	cmd = b43legacy_read32(dev, B43legacy_MMIO_MACCMD);
-	beacon0_valid = (cmd & B43legacy_MACCMD_BEACON0_VALID);
-	beacon1_valid = (cmd & B43legacy_MACCMD_BEACON1_VALID);
-	cmd &= ~(B43legacy_MACCMD_BEACON0_VALID | B43legacy_MACCMD_BEACON1_VALID);
-
-	if (!beacon0_valid) {
-		if (!wl->beacon0_uploaded) {
-			b43legacy_write_beacon_template(dev, 0x68,
-							B43legacy_SHM_SH_BTL0,
-							B43legacy_CCK_RATE_1MB);
-			b43legacy_write_probe_resp_template(dev, 0x268,
-							    B43legacy_SHM_SH_PRTLEN,
-							    &__b43legacy_ratetable[3]);
-			wl->beacon0_uploaded = 1;
-		}
-		cmd |= B43legacy_MACCMD_BEACON0_VALID;
-	} else if (!beacon1_valid) {
-		if (!wl->beacon1_uploaded) {
-			b43legacy_write_beacon_template(dev, 0x468,
-							B43legacy_SHM_SH_BTL1,
-							B43legacy_CCK_RATE_1MB);
-			wl->beacon1_uploaded = 1;
-		}
-		cmd |= B43legacy_MACCMD_BEACON1_VALID;
-	}
-	b43legacy_write32(dev, B43legacy_MMIO_MACCMD, cmd);
-}
-
 static void handle_irq_ucode_debug(struct b43legacy_wldev *dev)
 {
 }
@@ -3423,6 +3488,9 @@ static int b43legacy_op_start(struct iee
 	memset(wl->bssid, 0, ETH_ALEN);
 	memset(wl->mac_addr, 0, ETH_ALEN);
 	wl->filter_flags = 0;
+	wl->beacon0_uploaded = 0;
+	wl->beacon1_uploaded = 0;
+	wl->beacon_templates_virgin = 1;
 
 	mutex_lock(&wl->mutex);
 
Index: wireless-testing/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/xmit.c
+++ wireless-testing/drivers/net/wireless/b43legacy/xmit.c
@@ -274,7 +274,7 @@ static int generate_txhdr_fw3(struct b43
 
 	/* PHY TX Control word */
 	if (rate_ofdm)
-		phy_ctl |= B43legacy_TX4_PHY_OFDM;
+		phy_ctl |= B43legacy_TX4_PHY_ENC_OFDM;
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
 		phy_ctl |= B43legacy_TX4_PHY_SHORTPRMBL;
 	switch (info->antenna_sel_tx) {
Index: wireless-testing/drivers/net/wireless/b43legacy/xmit.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/xmit.h
+++ wireless-testing/drivers/net/wireless/b43legacy/xmit.h
@@ -67,7 +67,9 @@ struct b43legacy_txhdr_fw3 {
 #define B43legacy_TX4_EFT_RTSFBOFDM	0x0010 /* RTS/CTS fallback rate type */
 
 /* PHY TX control word */
-#define B43legacy_TX4_PHY_OFDM		0x0001 /* Data frame rate type */
+#define B43legacy_TX4_PHY_ENC		0x0003 /* Data frame encoding */
+#define B43legacy_TX4_PHY_ENC_CCK	0x0000 /* CCK */
+#define B43legacy_TX4_PHY_ENC_OFDM	0x0001 /* Data frame rate type */
 #define B43legacy_TX4_PHY_SHORTPRMBL	0x0010 /* Use short preamble */
 #define B43legacy_TX4_PHY_ANT		0x03C0 /* Antenna selection */
 #define  B43legacy_TX4_PHY_ANT0		0x0000 /* Use antenna 0 */

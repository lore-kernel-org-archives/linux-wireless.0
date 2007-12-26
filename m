Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45381 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbXLZQwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2007 11:52:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix upload of beacon packets to the hardware
Date: Wed, 26 Dec 2007 17:47:10 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Message-Id: <200712261747.10682.mb@bu3sch.de> (sfid-20071226_165250_133215_D5E90DB6)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes uploading of the beacon data and writing of the
TIM and DTIM offsets.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is 2.6.25 stuff.

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-12-26 16:57:01.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-12-26 17:40:07.000000000 +0100
@@ -1146,15 +1146,58 @@ static void b43_write_beacon_template(st
 				      u16 ram_offset,
 				      u16 shm_size_offset, u8 rate)
 {
-	int len;
-	const u8 *data;
+	int i, len;
+	const struct ieee80211_mgmt *bcn;
+	const u8 *ie;
+	bool tim_found = 0;
 
-	B43_WARN_ON(!dev->cached_beacon);
-	len = min((size_t) dev->cached_beacon->len,
+	bcn = (const struct ieee80211_mgmt *)(dev->wl->current_beacon->data);
+	len = min((size_t) dev->wl->current_beacon->len,
 		  0x200 - sizeof(struct b43_plcp_hdr6));
-	data = (const u8 *)(dev->cached_beacon->data);
-	b43_write_template_common(dev, data,
+
+	b43_write_template_common(dev, (const u8 *)bcn,
 				  len, ram_offset, shm_size_offset, rate);
+
+	/* Find the position of the TIM and the DTIM_period value
+	 * and write them to SHM. */
+	ie = bcn->u.beacon.variable;
+	for (i = 0; i < len - 2; ) {
+		uint8_t ie_id, ie_len;
+
+		ie_id = ie[i];
+		ie_len = ie[i + 1];
+		if (ie_id == 5) {
+			u16 tim_position;
+			u16 dtim_period;
+			/* This is the TIM Information Element */
+
+			/* Check whether the ie_len is in the beacon data range. */
+			if (len < ie_len + 2 + i)
+				break;
+			/* A valid TIM is at least 4 bytes long. */
+			if (ie_len < 4)
+				break;
+			tim_found = 1;
+
+			tim_position = sizeof(struct b43_plcp_hdr6);
+			tim_position += offsetof(struct ieee80211_mgmt, u.beacon.variable);
+			tim_position += i;
+
+			dtim_period = ie[i + 3];
+
+			b43_shm_write16(dev, B43_SHM_SHARED,
+					B43_SHM_SH_TIMBPOS, tim_position);
+			b43_shm_write16(dev, B43_SHM_SHARED,
+					B43_SHM_SH_DTIMPER, dtim_period);
+			break;
+		}
+		i += ie_len + 2;
+	}
+	if (!tim_found) {
+		b43warn(dev->wl, "Did not find a valid TIM IE in "
+			"the beacon template packet. AP or IBSS operation "
+			"may be broken.\n");
+	}
 }
 
 static void b43_write_probe_resp_plcp(struct b43_wldev *dev,
@@ -1182,40 +1225,43 @@ static void b43_write_probe_resp_plcp(st
  * 2) Patching duration field
  * 3) Stripping TIM
  */
-static u8 *b43_generate_probe_resp(struct b43_wldev *dev,
-				   u16 * dest_size, u8 rate)
+static const u8 * b43_generate_probe_resp(struct b43_wldev *dev,
+					  u16 *dest_size, u8 rate)
 {
 	const u8 *src_data;
 	u8 *dest_data;
 	u16 src_size, elem_size, src_pos, dest_pos;
 	__le16 dur;
 	struct ieee80211_hdr *hdr;
+	size_t ie_start;
+
+	src_size = dev->wl->current_beacon->len;
+	src_data = (const u8 *)dev->wl->current_beacon->data;
 
-	B43_WARN_ON(!dev->cached_beacon);
-	src_size = dev->cached_beacon->len;
-	src_data = (const u8 *)dev->cached_beacon->data;
+	/* Get the start offset of the variable IEs in the packet. */
+	ie_start = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
+	B43_WARN_ON(ie_start != offsetof(struct ieee80211_mgmt, u.beacon.variable));
 
-	if (unlikely(src_size < 0x24)) {
-		b43dbg(dev->wl, "b43_generate_probe_resp: " "invalid beacon\n");
+	if (B43_WARN_ON(src_size < ie_start))
 		return NULL;
-	}
 
 	dest_data = kmalloc(src_size, GFP_ATOMIC);
 	if (unlikely(!dest_data))
 		return NULL;
 
-	/* 0x24 is offset of first variable-len Information-Element
-	 * in beacon frame.
-	 */
-	memcpy(dest_data, src_data, 0x24);
-	src_pos = dest_pos = 0x24;
-	for (; src_pos < src_size - 2; src_pos += elem_size) {
+	/* Copy the static data and all Information Elements, except the TIM. */
+	memcpy(dest_data, src_data, ie_start);
+	src_pos = ie_start;
+	dest_pos = ie_start;
+	for ( ; src_pos < src_size - 2; src_pos += elem_size) {
 		elem_size = src_data[src_pos + 1] + 2;
-		if (src_data[src_pos] != 0x05) {	/* TIM */
-			memcpy(dest_data + dest_pos, src_data + src_pos,
-			       elem_size);
-			dest_pos += elem_size;
+		if (src_data[src_pos] == 5) {
+			/* This is the TIM. */
+			continue;
 		}
+		memcpy(dest_data + dest_pos, src_data + src_pos,
+		       elem_size);
+		dest_pos += elem_size;
 	}
 	*dest_size = dest_pos;
 	hdr = (struct ieee80211_hdr *)dest_data;
@@ -1235,11 +1281,10 @@ static void b43_write_probe_resp_templat
 					  u16 ram_offset,
 					  u16 shm_size_offset, u8 rate)
 {
-	u8 *probe_resp_data;
+	const u8 *probe_resp_data;
 	u16 size;
 
-	B43_WARN_ON(!dev->cached_beacon);
-	size = dev->cached_beacon->len;
+	size = dev->wl->current_beacon->len;
 	probe_resp_data = b43_generate_probe_resp(dev, &size, rate);
 	if (unlikely(!probe_resp_data))
 		return;
@@ -1258,39 +1303,26 @@ static void b43_write_probe_resp_templat
 	kfree(probe_resp_data);
 }
 
-static int b43_refresh_cached_beacon(struct b43_wldev *dev,
-				     struct sk_buff *beacon)
+/* Asynchronously update the packet templates in template RAM. */
+static void b43_update_templates(struct b43_wl *wl, struct sk_buff *beacon)
 {
-	if (dev->cached_beacon)
-		kfree_skb(dev->cached_beacon);
-	dev->cached_beacon = beacon;
-
-	return 0;
-}
-
-static void b43_update_templates(struct b43_wldev *dev)
-{
-	u32 cmd;
-
-	B43_WARN_ON(!dev->cached_beacon);
+	unsigned long flags;
 
-	b43_write_beacon_template(dev, 0x68, 0x18, B43_CCK_RATE_1MB);
-	b43_write_beacon_template(dev, 0x468, 0x1A, B43_CCK_RATE_1MB);
-	b43_write_probe_resp_template(dev, 0x268, 0x4A, B43_CCK_RATE_11MB);
+	/* This is the top half of the ansynchronous beacon update.
+	 * The bottom half is the beacon IRQ.
+	 * Beacon update must be asynchronous to avoid sending an
+	 * invalid beacon. This can happen for example, if the firmware
+	 * transmits a beacon while we are updating it. */
 
-	cmd = b43_read32(dev, B43_MMIO_MACCMD);
-	cmd |= B43_MACCMD_BEACON0_VALID | B43_MACCMD_BEACON1_VALID;
-	b43_write32(dev, B43_MMIO_MACCMD, cmd);
-}
+	spin_lock_irqsave(&wl->irq_lock, flags);
 
-static void b43_refresh_templates(struct b43_wldev *dev, struct sk_buff *beacon)
-{
-	int err;
+	if (wl->current_beacon)
+		dev_kfree_skb_any(wl->current_beacon);
+	wl->current_beacon = beacon;
+	wl->beacon0_uploaded = 0;
+	wl->beacon1_uploaded = 0;
 
-	err = b43_refresh_cached_beacon(dev, beacon);
-	if (unlikely(err))
-		return;
-	b43_update_templates(dev);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
 }
 
 static void b43_set_ssid(struct b43_wldev *dev, const u8 * ssid, u8 ssid_len)
@@ -1326,33 +1358,34 @@ static void b43_set_beacon_int(struct b4
 
 static void handle_irq_beacon(struct b43_wldev *dev)
 {
-	u32 status;
+	struct b43_wl *wl = dev->wl;
+	u32 cmd;
 
-	if (!b43_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
+	if (!b43_is_mode(wl, IEEE80211_IF_TYPE_AP))
 		return;
 
-	dev->irq_savedstate &= ~B43_IRQ_BEACON;
-	status = b43_read32(dev, B43_MMIO_MACCMD);
+	/* This is the bottom half of the asynchronous beacon update. */
 
-	if (!dev->cached_beacon || ((status & 0x1) && (status & 0x2))) {
-		/* ACK beacon IRQ. */
-		b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, B43_IRQ_BEACON);
-		dev->irq_savedstate |= B43_IRQ_BEACON;
-		if (dev->cached_beacon)
-			kfree_skb(dev->cached_beacon);
-		dev->cached_beacon = NULL;
-		return;
-	}
-	if (!(status & 0x1)) {
-		b43_write_beacon_template(dev, 0x68, 0x18, B43_CCK_RATE_1MB);
-		status |= 0x1;
-		b43_write32(dev, B43_MMIO_MACCMD, status);
-	}
-	if (!(status & 0x2)) {
-		b43_write_beacon_template(dev, 0x468, 0x1A, B43_CCK_RATE_1MB);
-		status |= 0x2;
-		b43_write32(dev, B43_MMIO_MACCMD, status);
+	cmd = b43_read32(dev, B43_MMIO_MACCMD);
+	if (!(cmd & B43_MACCMD_BEACON0_VALID)) {
+		if (!wl->beacon0_uploaded) {
+			b43_write_beacon_template(dev, 0x68, 0x18,
+						  B43_CCK_RATE_1MB);
+			b43_write_probe_resp_template(dev, 0x268, 0x4A,
+						      B43_CCK_RATE_11MB);
+			wl->beacon0_uploaded = 1;
+		}
+		cmd |= B43_MACCMD_BEACON0_VALID;
+	}
+	if (!(cmd & B43_MACCMD_BEACON1_VALID)) {
+		if (!wl->beacon1_uploaded) {
+			b43_write_beacon_template(dev, 0x468, 0x1A,
+						  B43_CCK_RATE_1MB);
+			wl->beacon1_uploaded = 1;
+		}
+		cmd |= B43_MACCMD_BEACON1_VALID;
 	}
+	b43_write32(dev, B43_MMIO_MACCMD, cmd);
 }
 
 static void handle_irq_ucode_debug(struct b43_wldev *dev)
@@ -2947,7 +2980,7 @@ static int b43_op_config_interface(struc
 			B43_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
 			b43_set_ssid(dev, conf->ssid, conf->ssid_len);
 			if (conf->beacon)
-				b43_refresh_templates(dev, conf->beacon);
+				b43_update_templates(wl, conf->beacon);
 		}
 		b43_write_mac_bssid_templates(dev);
 	}
@@ -3285,6 +3318,11 @@ static void b43_wireless_core_exit(struc
 		kfree(phy->tssi2dbm);
 	kfree(phy->lo_control);
 	phy->lo_control = NULL;
+	if (dev->wl->current_beacon) {
+		dev_kfree_skb_any(dev->wl->current_beacon);
+		dev->wl->current_beacon = NULL;
+	}
+
 	ssb_device_disable(dev->dev, 0);
 	ssb_bus_may_powerdown(dev->dev->bus);
 }
@@ -3545,6 +3583,34 @@ out_unlock:
 	return err;
 }
 
+static int b43_op_beacon_set_tim(struct ieee80211_hw *hw, int aid, int set)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	struct sk_buff *beacon;
+
+	/* We could modify the existing beacon and set the aid bit in
+	 * the TIM field, but that would probably require resizing and
+	 * moving of data within the beacon template.
+	 * Simply request a new beacon and let mac80211 do the hard work. */
+	beacon = ieee80211_beacon_get(hw, wl->vif, NULL);
+	if (unlikely(!beacon))
+		return -ENOMEM;
+	b43_update_templates(wl, beacon);
+
+	return 0;
+}
+
+static int b43_op_ibss_beacon_update(struct ieee80211_hw *hw,
+				     struct sk_buff *beacon,
+				     struct ieee80211_tx_control *ctl)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+
+	b43_update_templates(wl, beacon);
+
+	return 0;
+}
+
 static const struct ieee80211_ops b43_hw_ops = {
 	.tx			= b43_op_tx,
 	.conf_tx		= b43_op_conf_tx,
@@ -3559,6 +3625,8 @@ static const struct ieee80211_ops b43_hw
 	.start			= b43_op_start,
 	.stop			= b43_op_stop,
 	.set_retry_limit	= b43_op_set_retry_limit,
+	.set_tim		= b43_op_beacon_set_tim,
+	.beacon_update		= b43_op_ibss_beacon_update,
 };
 
 /* Hard-reset the chip. Do not call this directly.
Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2007-12-26 16:57:01.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2007-12-26 17:40:07.000000000 +0100
@@ -646,6 +646,12 @@ struct b43_wl {
 	u8 nr_devs;
 
 	bool radiotap_enabled;
+
+	/* The beacon we are currently using (AP or IBSS mode).
+	 * This beacon stuff is protected by the irq_lock. */
+	struct sk_buff *current_beacon;
+	bool beacon0_uploaded;
+	bool beacon1_uploaded;
 };
 
 /* Pointers to the firmware data and meta information about it. */
@@ -740,9 +746,6 @@ struct b43_wldev {
 	u8 max_nr_keys;
 	struct b43_key key[58];
 
-	/* Cached beacon template while uploading the template. */
-	struct sk_buff *cached_beacon;
-
 	/* Firmware data */
 	struct b43_firmware fw;
 

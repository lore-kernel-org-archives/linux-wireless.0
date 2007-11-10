Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbXKJBTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 20:19:10 -0500
Subject: [RFC v2] b43: multiple MAC addresses support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1194572631.4793.64.camel@johannes.berg> (sfid-20071109_120958_259609_BC4A521E)
References: <1194572631.4793.64.camel@johannes.berg>
	 (sfid-20071109_120958_259609_BC4A521E)
Content-Type: text/plain
Date: Sat, 10 Nov 2007 02:20:26 +0100
Message-Id: <1194657626.7258.3.camel@johannes.berg> (sfid-20071110_011915_478840_95FB8B97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for multiple virtual interfaces (up to 65536)
to b43. This requires modified firmware which is detected by an invalid
day in the firmware timestamp (254), and then the firmware time and the
rest of the date is used for feature bits.

The multi-MAC support works by having a mask of ignored bits, the
modified firmware will mask off these bits before comparing the address
on incoming frames with the address. This, however, means that when you
add three MAC virtual interfaces, the firmware will at least also ACK
frames on a fourth address. The required mask is calculated dynamically
to be the least restrictive mask possible, but you should take care to
allocate your MAC addresses in a way that minimises the mask to avoid
strange behaviour. For example, avoid using addresses 02:00:00:00:00:02
and 02:00:00:00:00:10 together because these two have only 46 bits in
common, use 02:00:00:00:00:12 and 02:00:00:00:00:10 instead as those
have 47 bits in common.

Note that the mask applies only to the lower 16 bits, so the first four
bytes of all addresses need to be identical.

The required tool to patch the firmware will be published separately.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: Ben Greear <greearb@candelatech.com>
---
Ok, it works now. This uses registers instead of shm to set the MAC
address. Not that it matters much. Also fixes a few small bugs I think.
But that may have been only in the security fix patch. You can do the
interdiff to find out...

 drivers/net/wireless/b43/b43.h  |   19 ++-
 drivers/net/wireless/b43/main.c |  199 +++++++++++++++++++++++++++++++++-------
 drivers/net/wireless/b43/xmit.c |    6 -
 3 files changed, 179 insertions(+), 45 deletions(-)

--- everything.orig/drivers/net/wireless/b43/main.c	2007-11-09 03:22:39.028987631 +0100
+++ everything/drivers/net/wireless/b43/main.c	2007-11-10 02:12:20.959959690 +0100
@@ -543,7 +543,20 @@ static void b43_write_mac_bssid_template
 static void b43_upload_card_macaddress(struct b43_wldev *dev)
 {
 	b43_write_mac_bssid_templates(dev);
-	b43_macfilter_set(dev, B43_MACFILTER_SELF, dev->wl->mac_addr);
+
+	if (dev->fw.features & B43_FW_FEATURE_MULTI_MAC_STA) {
+		u16 tmp;
+
+		tmp = ((u16 *)dev->wl->mac_addr)[0];
+		b43_shm_write16(dev, B43_SHM_SCRATCH, 60, cpu_to_le16(tmp));
+		tmp = ((u16 *)dev->wl->mac_addr)[1];
+		b43_shm_write16(dev, B43_SHM_SCRATCH, 61, cpu_to_le16(tmp));
+		tmp = ((u16 *)dev->wl->mac_addr)[2];
+		b43_shm_write16(dev, B43_SHM_SCRATCH, 62, cpu_to_le16(tmp));
+		/* swap here because we always treat the mask as big endian */
+		b43_shm_write16(dev, B43_SHM_SCRATCH, 63, swab16(~dev->wl->mac_mask));
+	} else
+		b43_macfilter_set(dev, B43_MACFILTER_SELF, dev->wl->mac_addr);
 }
 
 static void b43_set_slot_time(struct b43_wldev *dev, u16 slot_time)
@@ -1174,18 +1187,18 @@ static void b43_write_probe_resp_plcp(st
 {
 	struct b43_plcp_hdr4 plcp;
 	u32 tmp;
-	__le16 dur;
 
 	plcp.data = 0;
 	b43_generate_plcp_hdr(&plcp, size + FCS_LEN, rate);
-	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id, size,
-					       B43_RATE_TO_BASE100KBPS(rate));
 	/* Write PLCP in two parts and timing for packet transfer */
 	tmp = le32_to_cpu(plcp.data);
 	b43_shm_write16(dev, B43_SHM_SHARED, shm_offset, tmp & 0xFFFF);
 	b43_shm_write16(dev, B43_SHM_SHARED, shm_offset + 2, tmp >> 16);
-	b43_shm_write16(dev, B43_SHM_SHARED, shm_offset + 6, le16_to_cpu(dur));
+	/*
+	 * XXX: currently, the duration here doesn't matter, but
+	 * when we implement offload it needs to be fixed!
+	 */
+	b43_shm_write16(dev, B43_SHM_SHARED, shm_offset + 6, 0);
 }
 
 /* Instead of using custom probe response template, this function
@@ -1200,7 +1213,6 @@ static u8 *b43_generate_probe_resp(struc
 	const u8 *src_data;
 	u8 *dest_data;
 	u16 src_size, elem_size, src_pos, dest_pos;
-	__le16 dur;
 	struct ieee80211_hdr *hdr;
 
 	B43_WARN_ON(!dev->cached_beacon);
@@ -1235,10 +1247,11 @@ static u8 *b43_generate_probe_resp(struc
 	/* Set the frame control. */
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					 IEEE80211_STYPE_PROBE_RESP);
-	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id, *dest_size,
-					       B43_RATE_TO_BASE100KBPS(rate));
-	hdr->duration_id = dur;
+	/*
+	 * XXX: currently, the duration here doesn't matter, but
+	 * when we implement offload it needs to be fixed!
+	 */
+	hdr->duration_id = 0;
 
 	return dest_data;
 }
@@ -1792,11 +1805,23 @@ static int b43_upload_microcode(struct b
 		err = -EOPNOTSUPP;
 		goto out;
 	}
-	b43dbg(dev->wl, "Loading firmware version %u.%u "
-	       "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
-	       fwrev, fwpatch,
-	       (fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
-	       (fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F, fwtime & 0x1F);
+	/* special day 254: modified firmware with feature bits */
+	if ((fwdate & 0xFF) == 0xFE) {
+		b43dbg(dev->wl, "Loading firmware version %u.%u\n",
+		       fwrev, fwpatch);
+		dev->fw.features = fwtime | ((fwdate & 0xFF00) << 8);
+		b43dbg(dev->wl, "This firmware was modified and has the"
+				" added features 0x%06x\n", dev->fw.features);
+		if (dev->fw.features & B43_FW_FEATURE_MULTI_MAC_STA)
+			b43dbg(dev->wl, " * station multi MAC addr support\n");
+	} else
+		b43dbg(dev->wl, "Loading firmware version %u.%u "
+		       "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
+		       fwrev, fwpatch,
+		       (fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF,
+		       fwdate & 0xFF,
+		       (fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F,
+		       fwtime & 0x1F);
 
 	dev->fw.rev = fwrev;
 	dev->fw.patch = fwpatch;
@@ -2948,11 +2973,18 @@ static int b43_op_config_interface(struc
 		return -ENODEV;
 	mutex_lock(&wl->mutex);
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	B43_WARN_ON(wl->if_id != if_id);
-	if (conf->bssid)
-		memcpy(wl->bssid, conf->bssid, ETH_ALEN);
-	else
-		memset(wl->bssid, 0, ETH_ALEN);
+
+	/*
+	 * Only take bssid of first iface, we can only adopt time from
+	 * one BSS so arbitrarily choose the first.
+	 */
+	if (wl->if_id == if_id) {
+		if (conf->bssid)
+			memcpy(wl->bssid, conf->bssid, ETH_ALEN);
+		else
+			memset(wl->bssid, 0, ETH_ALEN);
+	}
+
 	if (b43_status(dev) >= B43_STAT_INITIALIZED) {
 		if (b43_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
 			B43_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
@@ -3424,6 +3456,71 @@ static int b43_wireless_core_init(struct
 	return err;
 }
 
+struct mac_iter {
+	struct b43_wl *wl;
+	u16 mac_val;
+	bool add;
+	int count;
+};
+
+static void b43_mac_iter(void *data, u8 *mac, int if_id)
+{
+	struct mac_iter *iter = data;
+	u16 val = (mac[4] << 8) | mac[5];
+	u16 cur = (iter->wl->mac_addr[4] << 8) | iter->wl->mac_addr[5];
+
+	/* skip the one that's being removed */
+	if (!iter->add && val == iter->mac_val)
+		return;
+
+	/* take first address we find as base */
+	if (iter->count == 0) {
+		cur = val;
+		iter->wl->mac_addr[4] = cur >> 8;
+		iter->wl->mac_addr[5] = cur;
+	}
+
+	iter->wl->mac_mask |= cur ^ val;
+
+	iter->count++;
+}
+
+static void b43_adjust_mac_addr_mask(struct b43_wl *wl, bool add, u8 *addr)
+{
+	struct mac_iter iter;
+	DECLARE_MAC_BUF(mbuf);
+	u16 cur;
+	u16 val = (addr[4] << 8) | addr[5];
+
+	/*
+	 * Because this is not invoked on adding the first address,
+	 * we do not need to have any special code for that case.
+	 * If it was invoked, we'd have to set cur to val here etc.
+	 * like above in the iter->count == 0 case (because we don't
+	 * see the interface that's being added in the iteration.)
+	 */
+
+	wl->mac_mask = 0;
+
+	iter.wl = wl;
+	iter.add = add;
+	iter.mac_val = val;
+	iter.count = 0;
+	ieee80211_iterate_active_interfaces(wl->hw, b43_mac_iter, &iter);
+
+	/* add the one that's being added */
+	cur = (wl->mac_addr[4] << 8) | wl->mac_addr[5];
+	if (add)
+		wl->mac_mask |= cur ^ val;
+
+	cur = cur & ~wl->mac_mask;
+	wl->mac_addr[4] = cur >> 8;
+	wl->mac_addr[5] = cur;
+
+	b43dbg(wl, "MAC address is %s, mask is 0x%.4x\n",
+	       print_mac(mbuf, wl->mac_addr), wl->mac_mask);
+}
+
 static int b43_op_add_interface(struct ieee80211_hw *hw,
 				struct ieee80211_if_init_conf *conf)
 {
@@ -3441,16 +3538,36 @@ static int b43_op_add_interface(struct i
 		return -EOPNOTSUPP;
 
 	mutex_lock(&wl->mutex);
-	if (wl->operating)
-		goto out_mutex_unlock;
+	dev = wl->current_dev;
 
-	b43dbg(wl, "Adding Interface type %d\n", conf->type);
+	if (dev->fw.features & B43_FW_FEATURE_MULTI_MAC_STA) {
+		if (wl->if_count && conf->type != IEEE80211_IF_TYPE_STA)
+			goto out_mutex_unlock;
+		if (wl->if_count > 0) {
+			if (((u8 *)conf->mac_addr)[0] != wl->mac_addr[0])
+				goto out_mutex_unlock;
+			if (((u8 *)conf->mac_addr)[1] != wl->mac_addr[1])
+				goto out_mutex_unlock;
+			if (((u8 *)conf->mac_addr)[2] != wl->mac_addr[2])
+				goto out_mutex_unlock;
+			if (((u8 *)conf->mac_addr)[3] != wl->mac_addr[3])
+				goto out_mutex_unlock;
+			b43_adjust_mac_addr_mask(wl, 1, conf->mac_addr);
+		}
+	} else {
+		if (wl->if_count)
+			goto out_mutex_unlock;
+	}
 
-	dev = wl->current_dev;
-	wl->operating = 1;
-	wl->if_id = conf->if_id;
-	wl->if_type = conf->type;
-	memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
+	wl->if_count++;
+
+	if (wl->if_count == 1) {
+		wl->if_id = conf->if_id;
+		wl->if_type = conf->type;
+		memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
+	}
+
+	b43dbg(wl, "Adding Interface type %d\n", conf->type);
 
 	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43_adjust_opmode(dev);
@@ -3464,6 +3581,14 @@ static int b43_op_add_interface(struct i
 	return err;
 }
 
+static void b43_ifid_iter(void *data, u8 *mac, int if_id)
+{
+	struct b43_wl *wl = data;
+
+	if (wl->if_id != if_id)
+		wl->if_id = if_id;
+}
+
 static void b43_op_remove_interface(struct ieee80211_hw *hw,
 				    struct ieee80211_if_init_conf *conf)
 {
@@ -3475,14 +3600,22 @@ static void b43_op_remove_interface(stru
 
 	mutex_lock(&wl->mutex);
 
-	B43_WARN_ON(!wl->operating);
-	B43_WARN_ON(wl->if_id != conf->if_id);
+	B43_WARN_ON(!wl->if_count);
+
+	wl->if_count--;
+	if (wl->if_count == 0) {
+		wl->if_type = IEEE80211_IF_TYPE_INVALID;
+		memset(wl->mac_addr, 0, ETH_ALEN);
+	}
+
+	/* arbitrarily adopt another if_id as main if_id */
+	if (conf->if_id == wl->if_id)
+		ieee80211_iterate_active_interfaces(wl->hw, b43_ifid_iter, wl);
 
-	wl->operating = 0;
+	b43_adjust_mac_addr_mask(wl, 0, conf->mac_addr);
 
 	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43_adjust_opmode(dev);
-	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43_upload_card_macaddress(dev);
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
--- everything.orig/drivers/net/wireless/b43/b43.h	2007-11-09 03:22:39.098988498 +0100
+++ everything/drivers/net/wireless/b43/b43.h	2007-11-09 22:54:31.489965385 +0100
@@ -601,22 +601,20 @@ struct b43_wl {
 	struct mutex mutex;
 	spinlock_t leds_lock;
 
-	/* We can only have one operating interface (802.11 core)
-	 * at a time. General information about this interface follows.
-	 */
-
-	/* Opaque ID of the operating interface from the ieee80211
+	/*
+	 * Opaque ID of the first operating interface from the ieee80211
 	 * subsystem. Do not modify.
 	 */
 	int if_id;
-	/* The MAC address of the operating interface. */
+	/* The MAC address */
 	u8 mac_addr[ETH_ALEN];
+	u16 mac_mask;
 	/* Current BSSID */
 	u8 bssid[ETH_ALEN];
 	/* Interface type. (IEEE80211_IF_TYPE_XXX) */
 	int if_type;
-	/* Is the card operating in AP, STA or IBSS mode? */
-	bool operating;
+	/* number of open interfaces */
+	int if_count;
 	/* filter flags */
 	unsigned int filter_flags;
 	/* Stats about the wireless interface */
@@ -648,6 +646,9 @@ struct b43_firmware {
 	u16 rev;
 	/* Firmware patchlevel */
 	u16 patch;
+	/* Firmware features (24 bits) */
+#define B43_FW_FEATURE_MULTI_MAC_STA	0x000001
+	u32 features;
 };
 
 /* Device (802.11 core) initialization status. */
@@ -781,7 +782,7 @@ static inline struct b43_wldev *dev_to_b
 /* Is the device operating in a specified mode (IEEE80211_IF_TYPE_XXX). */
 static inline int b43_is_mode(struct b43_wl *wl, int type)
 {
-	return (wl->operating && wl->if_type == type);
+	return (wl->if_count && wl->if_type == type);
 }
 
 static inline u16 b43_read16(struct b43_wldev *dev, u16 offset)
--- everything.orig/drivers/net/wireless/b43/xmit.c	2007-11-09 03:22:39.238983995 +0100
+++ everything/drivers/net/wireless/b43/xmit.c	2007-11-09 22:38:21.219963866 +0100
@@ -221,7 +221,7 @@ static void generate_txhdr_fw4(struct b4
 	} else {
 		int fbrate_base100kbps = B43_RATE_TO_BASE100KBPS(rate_fb);
 		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
-								 dev->wl->if_id,
+								 txctl->ifindex,
 								 fragment_len,
 								 fbrate_base100kbps);
 	}
@@ -311,7 +311,7 @@ static void generate_txhdr_fw4(struct b4
 		rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);
 
 		if (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
-			ieee80211_ctstoself_get(dev->wl->hw, dev->wl->if_id,
+			ieee80211_ctstoself_get(dev->wl->hw, txctl->ifindex,
 						fragment_data, fragment_len,
 						txctl,
 						(struct ieee80211_cts *)(txhdr->
@@ -319,7 +319,7 @@ static void generate_txhdr_fw4(struct b4
 			mac_ctl |= B43_TX4_MAC_SENDCTS;
 			len = sizeof(struct ieee80211_cts);
 		} else {
-			ieee80211_rts_get(dev->wl->hw, dev->wl->if_id,
+			ieee80211_rts_get(dev->wl->hw, txctl->ifindex,
 					  fragment_data, fragment_len, txctl,
 					  (struct ieee80211_rts *)(txhdr->
 								   rts_frame));



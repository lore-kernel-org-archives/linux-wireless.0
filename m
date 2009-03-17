Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50138 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZCQERn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 00:17:43 -0400
Date: Mon, 16 Mar 2009 23:17:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: david@identd.dyndns.org
Cc: linux-wireless@vger.kernel.org
Subject: [RFT/RFC 1/2] b43legacy: Fixes for beacons
Message-ID: <49bf2461.kW+fFdg/HxheYVDo%Larry.Finger@lwfinger.net> (sfid-20090317_051748_741548_90B79838)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch ports the beaconing fixes from commit a82d992261f "b43: Beaconing
fixes" to b43legacy. Basically it prevents the card from triggering the beacon
IRQ over and over again.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
@@ -59,7 +59,8 @@
 #define B43legacy_MMIO_XMITSTAT_1		0x174
 #define B43legacy_MMIO_REV3PLUS_TSF_LOW	0x180 /* core rev >= 3 only */
 #define B43legacy_MMIO_REV3PLUS_TSF_HIGH	0x184 /* core rev >= 3 only */
-
+#define B43legacy_MMIO_TSF_CFP_REP	0x188
+#define B43legacy_MMIO_TSF_CFP_START	0x18C
 /* 32-bit DMA */
 #define B43legacy_MMIO_DMA32_BASE0	0x200
 #define B43legacy_MMIO_DMA32_BASE1	0x220
@@ -614,6 +615,7 @@ struct b43legacy_wl {
 	struct sk_buff *current_beacon;
 	bool beacon0_uploaded;
 	bool beacon1_uploaded;
+	struct work_struct beacon_update_trigger;
 };
 
 /* Pointers to the firmware data and meta information about it. */
Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -1013,7 +1013,8 @@ static void b43legacy_write_beacon_templ
 		b43legacywarn(dev->wl, "Did not find a valid TIM IE in the "
 			      "beacon template packet. AP or IBSS operation "
 			      "may be broken.\n");
-	}
+	} else
+		b43legacydbg(dev->wl, "Updated beacon template\n");
 }
 
 static void b43legacy_write_probe_resp_plcp(struct b43legacy_wldev *dev,
@@ -1133,6 +1134,27 @@ static void b43legacy_write_probe_resp_t
 	kfree(probe_resp_data);
 }
 
+static void b43legacy_beacon_update_trigger_work(struct work_struct *work)
+{
+	struct b43legacy_wl *wl = container_of(work, struct b43legacy_wl,
+					 beacon_update_trigger);
+	struct b43legacy_wldev *dev;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (likely(dev && (b43legacy_status(dev) >= B43legacy_STAT_INITIALIZED))) {
+		/* Force the microcode to trigger the
+		 * beacon update bottom-half IRQ. */
+		spin_lock_irq(&wl->irq_lock);
+		b43legacy_write32(dev, B43legacy_MMIO_MACCMD,
+			    b43legacy_read32(dev, B43legacy_MMIO_MACCMD)
+			    | B43legacy_MACCMD_BEACON0_VALID
+			    | B43legacy_MACCMD_BEACON1_VALID);
+		spin_unlock_irq(&wl->irq_lock);
+	}
+	mutex_unlock(&wl->mutex);
+}
+
 /* Asynchronously update the packet templates in template RAM.
  * Locking: Requires wl->irq_lock to be locked. */
 static void b43legacy_update_templates(struct b43legacy_wl *wl)
@@ -1156,25 +1178,31 @@ static void b43legacy_update_templates(s
 	wl->current_beacon = beacon;
 	wl->beacon0_uploaded = 0;
 	wl->beacon1_uploaded = 0;
+	queue_work(wl->hw->workqueue, &wl->beacon_update_trigger);
 }
 
 static void b43legacy_set_beacon_int(struct b43legacy_wldev *dev,
 				     u16 beacon_int)
 {
 	b43legacy_time_lock(dev);
-	if (dev->dev->id.revision >= 3)
-		b43legacy_write32(dev, 0x188, (beacon_int << 16));
-	else {
+	if (dev->dev->id.revision >= 3) {
+		b43legacy_write32(dev, B43legacy_MMIO_TSF_CFP_REP,
+				 (beacon_int << 16));
+		b43legacy_write32(dev, B43legacy_MMIO_TSF_CFP_START,
+				 (beacon_int << 10));
+	} else {
 		b43legacy_write16(dev, 0x606, (beacon_int >> 6));
 		b43legacy_write16(dev, 0x610, beacon_int);
 	}
 	b43legacy_time_unlock(dev);
+	b43legacydbg(dev->wl, "Set beacon interval to %u\n", beacon_int);
 }
 
 static void handle_irq_beacon(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_wl *wl = dev->wl;
 	u32 cmd;
+	u32 beacon0_valid, beacon1_valid;
 
 	if (!b43legacy_is_mode(wl, NL80211_IFTYPE_AP))
 		return;
@@ -1182,7 +1210,11 @@ static void handle_irq_beacon(struct b43
 	/* This is the bottom half of the asynchronous beacon update. */
 
 	cmd = b43legacy_read32(dev, B43legacy_MMIO_MACCMD);
-	if (!(cmd & B43legacy_MACCMD_BEACON0_VALID)) {
+	beacon0_valid = (cmd & B43legacy_MACCMD_BEACON0_VALID);
+	beacon1_valid = (cmd & B43legacy_MACCMD_BEACON1_VALID);
+	cmd &= ~(B43legacy_MACCMD_BEACON0_VALID | B43legacy_MACCMD_BEACON1_VALID);
+
+	if (!beacon0_valid) {
 		if (!wl->beacon0_uploaded) {
 			b43legacy_write_beacon_template(dev, 0x68,
 							B43legacy_SHM_SH_BTL0,
@@ -1193,8 +1225,7 @@ static void handle_irq_beacon(struct b43
 			wl->beacon0_uploaded = 1;
 		}
 		cmd |= B43legacy_MACCMD_BEACON0_VALID;
-	}
-	if (!(cmd & B43legacy_MACCMD_BEACON1_VALID)) {
+	} else if (!beacon1_valid) {
 		if (!wl->beacon1_uploaded) {
 			b43legacy_write_beacon_template(dev, 0x468,
 							B43legacy_SHM_SH_BTL1,
@@ -3429,6 +3460,7 @@ static void b43legacy_op_stop(struct iee
 	struct b43legacy_wldev *dev = wl->current_dev;
 
 	b43legacy_rfkill_exit(dev);
+	cancel_work_sync(&(wl->beacon_update_trigger));
 
 	mutex_lock(&wl->mutex);
 	if (b43legacy_status(dev) >= B43legacy_STAT_STARTED)
@@ -3760,6 +3792,7 @@ static int b43legacy_wireless_init(struc
 	spin_lock_init(&wl->leds_lock);
 	mutex_init(&wl->mutex);
 	INIT_LIST_HEAD(&wl->devlist);
+	INIT_WORK(&wl->beacon_update_trigger, b43legacy_beacon_update_trigger_work);
 
 	ssb_set_devtypedata(dev, wl);
 	b43legacyinfo(wl, "Broadcom %04X WLAN found\n", dev->bus->chip_id);

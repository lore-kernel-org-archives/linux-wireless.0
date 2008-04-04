Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41710 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYDDTmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 15:42:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Beaconing fixes
Date: Fri, 4 Apr 2008 21:40:06 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804042140.06678.mb@bu3sch.de> (sfid-20080404_204219_443049_95775C41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are some beaconing related fixes. Basically it prevents
the card from triggering the beacon IRQ over and over again.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply to 2.6.26.
The fix doesn't apply to 2.6.25, as AP mode is disabled there anyway.


Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-04-03 18:04:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-04-03 22:38:46.000000000 +0200
@@ -730,12 +730,13 @@ struct b43_wl {
 
 	/* The beacon we are currently using (AP or IBSS mode).
 	 * This beacon stuff is protected by the irq_lock. */
 	struct sk_buff *current_beacon;
 	bool beacon0_uploaded;
 	bool beacon1_uploaded;
+	struct work_struct beacon_update_trigger;
 
 	/* The current QOS parameters for the 4 queues.
 	 * This is protected by the irq_lock. */
 	struct b43_qos_params qos_params[4];
 	/* Workqueue for updating QOS parameters in hardware. */
 	struct work_struct qos_update_work;
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-03 22:38:36.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-03 22:38:46.000000000 +0200
@@ -1334,13 +1334,14 @@ static void b43_write_beacon_template(st
 		i += ie_len + 2;
 	}
 	if (!tim_found) {
 		b43warn(dev->wl, "Did not find a valid TIM IE in "
 			"the beacon template packet. AP or IBSS operation "
 			"may be broken.\n");
-	}
+	} else
+		b43dbg(dev->wl, "Updated beacon template\n");
 }
 
 static void b43_write_probe_resp_plcp(struct b43_wldev *dev,
 				      u16 shm_offset, u16 size,
 				      struct ieee80211_rate *rate)
 {
@@ -1444,12 +1445,33 @@ static void b43_write_probe_resp_templat
 	b43_write_template_common(dev, probe_resp_data,
 				  size, ram_offset, shm_size_offset,
 				  rate->hw_value);
 	kfree(probe_resp_data);
 }
 
+static void b43_beacon_update_trigger_work(struct work_struct *work)
+{
+	struct b43_wl *wl = container_of(work, struct b43_wl,
+					 beacon_update_trigger);
+	struct b43_wldev *dev;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (likely(dev && (b43_status(dev) >= B43_STAT_INITIALIZED))) {
+		/* Force the microcode to trigger the
+		 * beacon update bottom-half IRQ. */
+		spin_lock_irq(&wl->irq_lock);
+		b43_write32(dev, B43_MMIO_MACCMD,
+			    b43_read32(dev, B43_MMIO_MACCMD)
+			    | B43_MACCMD_BEACON0_VALID
+			    | B43_MACCMD_BEACON1_VALID);
+		spin_unlock_irq(&wl->irq_lock);
+	}
+	mutex_unlock(&wl->mutex);
+}
+
 /* Asynchronously update the packet templates in template RAM.
  * Locking: Requires wl->irq_lock to be locked. */
 static void b43_update_templates(struct b43_wl *wl, struct sk_buff *beacon)
 {
 	/* This is the top half of the ansynchronous beacon update.
 	 * The bottom half is the beacon IRQ.
@@ -1459,12 +1481,13 @@ static void b43_update_templates(struct 
 
 	if (wl->current_beacon)
 		dev_kfree_skb_any(wl->current_beacon);
 	wl->current_beacon = beacon;
 	wl->beacon0_uploaded = 0;
 	wl->beacon1_uploaded = 0;
+	queue_work(wl->hw->workqueue, &wl->beacon_update_trigger);
 }
 
 static void b43_set_ssid(struct b43_wldev *dev, const u8 * ssid, u8 ssid_len)
 {
 	u32 tmp;
 	u16 i, len;
@@ -1484,42 +1507,47 @@ static void b43_set_ssid(struct b43_wlde
 }
 
 static void b43_set_beacon_int(struct b43_wldev *dev, u16 beacon_int)
 {
 	b43_time_lock(dev);
 	if (dev->dev->id.revision >= 3) {
-		b43_write32(dev, 0x188, (beacon_int << 16));
+		b43_write32(dev, B43_MMIO_TSF_CFP_REP, (beacon_int << 16));
+		b43_write32(dev, B43_MMIO_TSF_CFP_START, (beacon_int << 10));
 	} else {
 		b43_write16(dev, 0x606, (beacon_int >> 6));
 		b43_write16(dev, 0x610, beacon_int);
 	}
 	b43_time_unlock(dev);
+	b43dbg(dev->wl, "Set beacon interval to %u\n", beacon_int);
 }
 
 static void handle_irq_beacon(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
-	u32 cmd;
+	u32 cmd, beacon0_valid, beacon1_valid;
 
 	if (!b43_is_mode(wl, IEEE80211_IF_TYPE_AP))
 		return;
 
 	/* This is the bottom half of the asynchronous beacon update. */
 
 	cmd = b43_read32(dev, B43_MMIO_MACCMD);
-	if (!(cmd & B43_MACCMD_BEACON0_VALID)) {
+	beacon0_valid = (cmd & B43_MACCMD_BEACON0_VALID);
+	beacon1_valid = (cmd & B43_MACCMD_BEACON1_VALID);
+	cmd &= ~(B43_MACCMD_BEACON0_VALID | B43_MACCMD_BEACON1_VALID);
+
+	if (!beacon0_valid) {
 		if (!wl->beacon0_uploaded) {
 			b43_write_beacon_template(dev, 0x68, 0x18,
 						  B43_CCK_RATE_1MB);
 			b43_write_probe_resp_template(dev, 0x268, 0x4A,
 						      &__b43_ratetable[3]);
 			wl->beacon0_uploaded = 1;
 		}
 		cmd |= B43_MACCMD_BEACON0_VALID;
-	}
-	if (!(cmd & B43_MACCMD_BEACON1_VALID)) {
+	} else if (!beacon1_valid) {
 		if (!wl->beacon1_uploaded) {
 			b43_write_beacon_template(dev, 0x468, 0x1A,
 						  B43_CCK_RATE_1MB);
 			wl->beacon1_uploaded = 1;
 		}
 		cmd |= B43_MACCMD_BEACON1_VALID;
@@ -4009,12 +4037,13 @@ static void b43_op_stop(struct ieee80211
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 
 	b43_rfkill_exit(dev);
 	cancel_work_sync(&(wl->qos_update_work));
+	cancel_work_sync(&(wl->beacon_update_trigger));
 
 	mutex_lock(&wl->mutex);
 	if (b43_status(dev) >= B43_STAT_STARTED)
 		b43_wireless_core_stop(dev);
 	b43_wireless_core_exit(dev);
 	mutex_unlock(&wl->mutex);
@@ -4386,12 +4415,13 @@ static int b43_wireless_init(struct ssb_
 	spin_lock_init(&wl->irq_lock);
 	spin_lock_init(&wl->leds_lock);
 	spin_lock_init(&wl->shm_lock);
 	mutex_init(&wl->mutex);
 	INIT_LIST_HEAD(&wl->devlist);
 	INIT_WORK(&wl->qos_update_work, b43_qos_update_work);
+	INIT_WORK(&wl->beacon_update_trigger, b43_beacon_update_trigger_work);
 
 	ssb_set_devtypedata(dev, wl);
 	b43info(wl, "Broadcom %04X WLAN found\n", dev->bus->chip_id);
 	err = 0;
       out:
 	return err;

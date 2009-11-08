Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:2722 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZKHNoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:44:18 -0500
Received: by ey-out-2122.google.com with SMTP id 25so4304eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:44:23 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] rt2500usb: remove dead link tuning code
Date: Sun, 8 Nov 2009 14:43:35 +0100
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200911081443.35448.bzolnier@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Link tuning code from the legacy rt2570 driver turned out to be
harmful and got disabled by the commit d06193f ("rt2x00: Disable
link tuning in rt2500usb") in August 2008.

There is no reason to keep this dead code any longer so remove it
(it can still be retrieved from the git history if necessary).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |  134 --------------------------------
 1 file changed, 134 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2500usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -716,139 +716,6 @@ static void rt2500usb_reset_tuner(struct
 }
 
 /*
- * NOTE: This function is directly ported from legacy driver, but
- * despite it being declared it was never called. Although link tuning
- * sounds like a good idea, and usually works well for the other drivers,
- * it does _not_ work with rt2500usb. Enabling this function will result
- * in TX capabilities only until association kicks in. Immediately
- * after the successful association all TX frames will be kept in the
- * hardware queue and never transmitted.
- */
-#if 0
-static void rt2500usb_link_tuner(struct rt2x00_dev *rt2x00dev)
-{
-	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
-	u16 bbp_thresh;
-	u16 vgc_bound;
-	u16 sens;
-	u16 r24;
-	u16 r25;
-	u16 r61;
-	u16 r17_sens;
-	u8 r17;
-	u8 up_bound;
-	u8 low_bound;
-
-	/*
-	 * Read current r17 value, as well as the sensitivity values
-	 * for the r17 register.
-	 */
-	rt2500usb_bbp_read(rt2x00dev, 17, &r17);
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R17, &r17_sens);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_VGC, &vgc_bound);
-	up_bound = rt2x00_get_field16(vgc_bound, EEPROM_BBPTUNE_VGCUPPER);
-	low_bound = rt2x00_get_field16(vgc_bound, EEPROM_BBPTUNE_VGCLOWER);
-
-	/*
-	 * If we are not associated, we should go straight to the
-	 * dynamic CCA tuning.
-	 */
-	if (!rt2x00dev->intf_associated)
-		goto dynamic_cca_tune;
-
-	/*
-	 * Determine the BBP tuning threshold and correctly
-	 * set BBP 24, 25 and 61.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE, &bbp_thresh);
-	bbp_thresh = rt2x00_get_field16(bbp_thresh, EEPROM_BBPTUNE_THRESHOLD);
-
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R24, &r24);
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R25, &r25);
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_BBPTUNE_R61, &r61);
-
-	if ((rssi + bbp_thresh) > 0) {
-		r24 = rt2x00_get_field16(r24, EEPROM_BBPTUNE_R24_HIGH);
-		r25 = rt2x00_get_field16(r25, EEPROM_BBPTUNE_R25_HIGH);
-		r61 = rt2x00_get_field16(r61, EEPROM_BBPTUNE_R61_HIGH);
-	} else {
-		r24 = rt2x00_get_field16(r24, EEPROM_BBPTUNE_R24_LOW);
-		r25 = rt2x00_get_field16(r25, EEPROM_BBPTUNE_R25_LOW);
-		r61 = rt2x00_get_field16(r61, EEPROM_BBPTUNE_R61_LOW);
-	}
-
-	rt2500usb_bbp_write(rt2x00dev, 24, r24);
-	rt2500usb_bbp_write(rt2x00dev, 25, r25);
-	rt2500usb_bbp_write(rt2x00dev, 61, r61);
-
-	/*
-	 * A too low RSSI will cause too much false CCA which will
-	 * then corrupt the R17 tuning. To remidy this the tuning should
-	 * be stopped (While making sure the R17 value will not exceed limits)
-	 */
-	if (rssi >= -40) {
-		if (r17 != 0x60)
-			rt2500usb_bbp_write(rt2x00dev, 17, 0x60);
-		return;
-	}
-
-	/*
-	 * Special big-R17 for short distance
-	 */
-	if (rssi >= -58) {
-		sens = rt2x00_get_field16(r17_sens, EEPROM_BBPTUNE_R17_LOW);
-		if (r17 != sens)
-			rt2500usb_bbp_write(rt2x00dev, 17, sens);
-		return;
-	}
-
-	/*
-	 * Special mid-R17 for middle distance
-	 */
-	if (rssi >= -74) {
-		sens = rt2x00_get_field16(r17_sens, EEPROM_BBPTUNE_R17_HIGH);
-		if (r17 != sens)
-			rt2500usb_bbp_write(rt2x00dev, 17, sens);
-		return;
-	}
-
-	/*
-	 * Leave short or middle distance condition, restore r17
-	 * to the dynamic tuning range.
-	 */
-	low_bound = 0x32;
-	if (rssi < -77)
-		up_bound -= (-77 - rssi);
-
-	if (up_bound < low_bound)
-		up_bound = low_bound;
-
-	if (r17 > up_bound) {
-		rt2500usb_bbp_write(rt2x00dev, 17, up_bound);
-		rt2x00dev->link.vgc_level = up_bound;
-		return;
-	}
-
-dynamic_cca_tune:
-
-	/*
-	 * R17 is inside the dynamic tuning range,
-	 * start tuning the link based on the false cca counter.
-	 */
-	if (rt2x00dev->link.qual.false_cca > 512 && r17 < up_bound) {
-		rt2500usb_bbp_write(rt2x00dev, 17, ++r17);
-		rt2x00dev->link.vgc_level = r17;
-	} else if (rt2x00dev->link.qual.false_cca < 100 && r17 > low_bound) {
-		rt2500usb_bbp_write(rt2x00dev, 17, --r17);
-		rt2x00dev->link.vgc_level = r17;
-	}
-}
-#else
-#define rt2500usb_link_tuner	NULL
-#endif
-
-/*
  * Initialization functions.
  */
 static int rt2500usb_init_registers(struct rt2x00_dev *rt2x00dev)
@@ -1910,7 +1777,6 @@ static const struct rt2x00lib_ops rt2500
 	.rfkill_poll		= rt2500usb_rfkill_poll,
 	.link_stats		= rt2500usb_link_stats,
 	.reset_tuner		= rt2500usb_reset_tuner,
-	.link_tuner		= rt2500usb_link_tuner,
 	.write_tx_desc		= rt2500usb_write_tx_desc,
 	.write_tx_data		= rt2x00usb_write_tx_data,
 	.write_beacon		= rt2500usb_write_beacon,

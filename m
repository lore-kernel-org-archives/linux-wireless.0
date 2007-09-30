Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8532 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbXI3Skg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:40:36 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 18/26] at76_usb: Avoid dealing with milliseconds when possible,  use jiffies
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:40:34 -0400
Message-ID: <20070930184034.23921.13756.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   36 +++++++++++++++++-------------------
 drivers/net/wireless/at76_usb.h |    2 +-
 2 files changed, 18 insertions(+), 20 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index fc1b331..1c181bb 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -335,16 +335,16 @@ static u8 at76_dfu_get_state(struct usb_device *udev, u8 *state)
 	return ret;
 }
 
-static inline u32 at76_get_timeout(struct dfu_status *s)
+/* Convert timeout from the DFU status to jiffies */
+static inline unsigned long at76_get_timeout(struct dfu_status *s)
 {
-	u32 ret = (s->poll_timeout[2] << 16) | (s->poll_timeout[1] << 8) |
-	    (s->poll_timeout[0]);
-
-	return ret;
+	return msecs_to_jiffies((s->poll_timeout[2] << 16)
+				| (s->poll_timeout[1] << 8)
+				| (s->poll_timeout[0]));
 }
 
 /* Load internal firmware from the buffer.  If manifest_sync_timeout > 0, use
- * its value in msec in the MANIFEST_SYNC state.  */
+ * its value in jiffies in the MANIFEST_SYNC state.  */
 static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 				int manifest_sync_timeout)
 {
@@ -400,8 +400,7 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 			need_dfu_state = 1;
 
 			at76_dbg(DBG_DFU, "DFU: Resetting device");
-			schedule_timeout_interruptible(msecs_to_jiffies
-						       (dfu_timeout));
+			schedule_timeout_interruptible(dfu_timeout);
 			break;
 
 		case STATE_DFU_DOWNLOAD_IDLE:
@@ -445,8 +444,7 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *buf, u32 size,
 				dfu_timeout = manifest_sync_timeout;
 
 			at76_dbg(DBG_DFU, "DFU: Waiting for manifest phase");
-			schedule_timeout_interruptible(msecs_to_jiffies
-						       (dfu_timeout));
+			schedule_timeout_interruptible(dfu_timeout);
 			break;
 
 		case STATE_DFU_MANIFEST:
@@ -577,7 +575,7 @@ static void at76_ledtrig_tx_timerfunc(unsigned long data)
 	if (tx_lastactivity != tx_activity) {
 		tx_lastactivity = tx_activity;
 		led_trigger_event(ledtrig_tx, LED_FULL);
-		mod_timer(&ledtrig_tx_timer, jiffies + msecs_to_jiffies(250));
+		mod_timer(&ledtrig_tx_timer, jiffies + HZ / 4);
 	} else
 		led_trigger_event(ledtrig_tx, LED_OFF);
 }
@@ -586,7 +584,7 @@ static void at76_ledtrig_tx_activity(void)
 {
 	tx_activity++;
 	if (!timer_pending(&ledtrig_tx_timer))
-		mod_timer(&ledtrig_tx_timer, jiffies + msecs_to_jiffies(250));
+		mod_timer(&ledtrig_tx_timer, jiffies + HZ / 4);
 }
 
 /* Check if the given ssid is hidden */
@@ -3447,7 +3445,7 @@ static int at76_load_internal_fw(struct usb_device *udev, struct fwentry *fwe)
 	int need_remap = !at76_is_505a(fwe->board_type);
 
 	ret = at76_usbdfu_download(udev, fwe->intfw, fwe->intfw_size,
-				   need_remap ? 0 : 2000);
+				   need_remap ? 0 : 2 * HZ);
 
 	if (ret < 0) {
 		printk(KERN_ERR DRIVER_NAME
@@ -4471,17 +4469,17 @@ static void at76_calc_qual(struct at76_priv *priv, struct at76_rx_buffer *buf,
 	if (at76_is_intersil(priv->board_type))
 		qual->qual = buf->link_quality;
 	else {
-		unsigned long msec;
+		unsigned long elapsed;
 
 		/* Update qual at most once a second */
-		msec = jiffies_to_msecs(jiffies) - priv->beacons_last_qual;
-		if (msec < 1000)
+		elapsed = jiffies - priv->beacons_last_qual;
+		if (elapsed < 1 * HZ)
 			return;
 
 		qual->qual = qual->level * priv->beacons_received *
-		    priv->beacon_period / msec;
+		    msecs_to_jiffies(priv->beacon_period) / elapsed;
 
-		priv->beacons_last_qual = jiffies_to_msecs(jiffies);
+		priv->beacons_last_qual = jiffies;
 		priv->beacons_received = 0;
 	}
 	qual->qual = (qual->qual > 100) ? 100 : qual->qual;
@@ -5270,7 +5268,7 @@ static int at76_init_new_device(struct at76_priv *priv,
 	priv->txrate = TX_RATE_AUTO;
 	priv->preamble_type = PREAMBLE_TYPE_LONG;
 	priv->beacon_period = 100;
-	priv->beacons_last_qual = jiffies_to_msecs(jiffies);
+	priv->beacons_last_qual = jiffies;
 	priv->auth_mode = WLAN_AUTH_OPEN;
 	priv->scan_min_time = DEF_SCAN_MIN_TIME;
 	priv->scan_max_time = DEF_SCAN_MAX_TIME;
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 6c3b76b..b20be9d 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -551,7 +551,7 @@ struct at76_priv {
 	struct set_mib_buffer mib_buf;	/* global buffer for set_mib calls */
 
 	/* beacon counting */
-	int beacon_period;	/* period of mgmt beacons */
+	int beacon_period;	/* period of mgmt beacons, Kus */
 	int beacons_received;
 	unsigned long beacons_last_qual;	/* time we restarted counting
 						   beacons */

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44731 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754045AbXKFWNI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 17:13:08 -0500
Date: Tue, 6 Nov 2007 22:48:12 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: John Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
Subject: [PATCH 1/7] b43legacy: use the retry limits provided by mac80211
Message-ID: <20071106224812.6d144692@morte> (sfid-20071106_221314_023276_50EAC630)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the retry limits provided by mac80211.

The patch to b43 by Michael Buesch <mb@bu3sch.de> has been ported to
b43legacy.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

----

Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -75,14 +75,6 @@ module_param_named(bad_frames_preempt, m
 MODULE_PARM_DESC(bad_frames_preempt, "enable(1) / disable(0) Bad Frames"
 		 " Preemption");
 
-static int modparam_short_retry = B43legacy_DEFAULT_SHORT_RETRY_LIMIT;
-module_param_named(short_retry, modparam_short_retry, int, 0444);
-MODULE_PARM_DESC(short_retry, "Short-Retry-Limit (0 - 15)");
-
-static int modparam_long_retry = B43legacy_DEFAULT_LONG_RETRY_LIMIT;
-module_param_named(long_retry, modparam_long_retry, int, 0444);
-MODULE_PARM_DESC(long_retry, "Long-Retry-Limit (0 - 15)");
-
 static char modparam_fwpostfix[16];
 module_param_string(fwpostfix, modparam_fwpostfix, 16, 0444);
 MODULE_PARM_DESC(fwpostfix, "Postfix for the firmware files to load.");
@@ -2927,6 +2919,20 @@ static void b43legacy_imcfglo_timeouts_w
 #endif /* CONFIG_SSB_DRIVER_PCICORE */
 }
 
+/* Write the short and long frame retry limit values. */
+static void b43legacy_set_retry_limits(struct b43legacy_wldev *dev,
+				       unsigned int short_retry,
+				       unsigned int long_retry)
+{
+	/* The retry limit is a 4-bit counter. Enforce this to avoid overflowing
+	 * the chip-internal counter. */
+	short_retry = min(short_retry, (unsigned int)0xF);
+	long_retry = min(long_retry, (unsigned int)0xF);
+
+	b43legacy_shm_write16(dev, B43legacy_SHM_WIRELESS, 0x0006, short_retry);
+	b43legacy_shm_write16(dev, B43legacy_SHM_WIRELESS, 0x0007, long_retry);
+}
+
 /* Shutdown a wireless core */
 /* Locking: wl->mutex */
 static void b43legacy_wireless_core_exit(struct b43legacy_wldev *dev)
@@ -3064,16 +3070,9 @@ static int b43legacy_wireless_core_init(
 	}
 	b43legacy_hf_write(dev, hf);
 
-	/* Short/Long Retry Limit.
-	 * The retry-limit is a 4-bit counter. Enforce this to avoid overflowing
-	 * the chip-internal counter.
-	 */
-	tmp = limit_value(modparam_short_retry, 0, 0xF);
-	b43legacy_shm_write16(dev, B43legacy_SHM_WIRELESS,
-			      0x0006, tmp);
-	tmp = limit_value(modparam_long_retry, 0, 0xF);
-	b43legacy_shm_write16(dev, B43legacy_SHM_WIRELESS,
-			      0x0007, tmp);
+	b43legacy_set_retry_limits(dev,
+				   B43legacy_DEFAULT_SHORT_RETRY_LIMIT,
+				   B43legacy_DEFAULT_LONG_RETRY_LIMIT);
 
 	b43legacy_shm_write16(dev, B43legacy_SHM_SHARED,
 			      0x0044, 3);
@@ -3250,19 +3249,41 @@ static void b43legacy_stop(struct ieee80
 	mutex_unlock(&wl->mutex);
 }
 
+static int b43legacy_op_set_retry_limit(struct ieee80211_hw *hw,
+					u32 short_retry_limit,
+					u32 long_retry_limit)
+{
+	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
+	struct b43legacy_wldev *dev;
+	int err = 0;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (unlikely(!dev ||
+		     (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED))) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
+	b43legacy_set_retry_limits(dev, short_retry_limit, long_retry_limit);
+out_unlock:
+	mutex_unlock(&wl->mutex);
+
+	return err;
+}
 
 static const struct ieee80211_ops b43legacy_hw_ops = {
-	.tx = b43legacy_tx,
-	.conf_tx = b43legacy_conf_tx,
-	.add_interface = b43legacy_add_interface,
-	.remove_interface = b43legacy_remove_interface,
-	.config = b43legacy_dev_config,
-	.config_interface = b43legacy_config_interface,
-	.configure_filter = b43legacy_configure_filter,
-	.get_stats = b43legacy_get_stats,
-	.get_tx_stats = b43legacy_get_tx_stats,
-	.start = b43legacy_start,
-	.stop = b43legacy_stop,
+	.tx			= b43legacy_tx,
+	.conf_tx		= b43legacy_conf_tx,
+	.add_interface		= b43legacy_add_interface,
+	.remove_interface	= b43legacy_remove_interface,
+	.config			= b43legacy_dev_config,
+	.config_interface	= b43legacy_config_interface,
+	.configure_filter	= b43legacy_configure_filter,
+	.get_stats		= b43legacy_get_stats,
+	.get_tx_stats		= b43legacy_get_tx_stats,
+	.start			= b43legacy_start,
+	.stop			= b43legacy_stop,
+	.set_retry_limit	= b43legacy_op_set_retry_limit,
 };
 
 /* Hard-reset the chip. Do not call this directly.
Index: wireless-2.6/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/xmit.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/xmit.c
@@ -290,6 +290,8 @@ static void generate_txhdr_fw3(struct b4
 		mac_ctl |= B43legacy_TX4_MAC_STMSDU;
 	if (rate_fb_ofdm)
 		mac_ctl |= B43legacy_TX4_MAC_FALLBACKOFDM;
+	if (txctl->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT)
+		mac_ctl |= B43legacy_TX4_MAC_LONGFRAME;
 
 	/* Generate the RTS or CTS-to-self frame */
 	if ((txctl->flags & IEEE80211_TXCTL_USE_RTS_CTS) ||
@@ -335,7 +337,6 @@ static void generate_txhdr_fw3(struct b4
 					    len, rts_rate_fb);
 		hdr = (struct ieee80211_hdr *)(&txhdr->rts_frame);
 		txhdr->rts_dur_fb = hdr->duration_id;
-		mac_ctl |= B43legacy_TX4_MAC_LONGFRAME;
 	}
 
 	/* Magic cookie */



-- 
Ciao
Stefano

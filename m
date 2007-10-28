Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40229
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbXJ1PUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 11:20:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Use the retry limit parameters from mac80211
Date: Sun, 28 Oct 2007 16:19:44 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710281619.45073.mb@bu3sch.de> (sfid-20071028_152021_322901_48F846E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the limits provided by mac80211.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>


Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-10-28 16:09:00.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-10-28 16:12:51.000000000 +0100
@@ -75,14 +75,6 @@ module_param_named(bad_frames_preempt, m
 MODULE_PARM_DESC(bad_frames_preempt,
 		 "enable(1) / disable(0) Bad Frames Preemption");
 
-static int modparam_short_retry = B43_DEFAULT_SHORT_RETRY_LIMIT;
-module_param_named(short_retry, modparam_short_retry, int, 0444);
-MODULE_PARM_DESC(short_retry, "Short-Retry-Limit (0 - 15)");
-
-static int modparam_long_retry = B43_DEFAULT_LONG_RETRY_LIMIT;
-module_param_named(long_retry, modparam_long_retry, int, 0444);
-MODULE_PARM_DESC(long_retry, "Long-Retry-Limit (0 - 15)");
-
 static char modparam_fwpostfix[16];
 module_param_string(fwpostfix, modparam_fwpostfix, 16, 0444);
 MODULE_PARM_DESC(fwpostfix, "Postfix for the .fw files to load.");
@@ -3261,6 +3253,22 @@ static void b43_imcfglo_timeouts_workaro
 #endif /* CONFIG_SSB_DRIVER_PCICORE */
 }
 
+/* Write the short and long frame retry limit values. */
+static void b43_set_retry_limits(struct b43_wldev *dev,
+				 unsigned int short_retry,
+				 unsigned int long_retry)
+{
+	/* The retry limit is a 4-bit counter. Enforce this to avoid overflowing
+	 * the chip-internal counter. */
+	short_retry = min(short_retry, (unsigned int)0xF);
+	long_retry = min(long_retry, (unsigned int)0xF);
+
+	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_SRLIMIT,
+			short_retry);
+	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_LRLIMIT,
+			long_retry);
+}
+
 /* Shutdown a wireless core */
 /* Locking: wl->mutex */
 static void b43_wireless_core_exit(struct b43_wldev *dev)
@@ -3349,15 +3357,8 @@ static int b43_wireless_core_init(struct
 	}
 	b43_hf_write(dev, hf);
 
-	/* Short/Long Retry Limit.
-	 * The retry-limit is a 4-bit counter. Enforce this to avoid overflowing
-	 * the chip-internal counter.
-	 */
-	tmp = limit_value(modparam_short_retry, 0, 0xF);
-	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_SRLIMIT, tmp);
-	tmp = limit_value(modparam_long_retry, 0, 0xF);
-	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_LRLIMIT, tmp);
-
+	b43_set_retry_limits(dev, B43_DEFAULT_SHORT_RETRY_LIMIT,
+			     B43_DEFAULT_LONG_RETRY_LIMIT);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SFFBLIM, 3);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_LFFBLIM, 2);
 
@@ -3534,19 +3535,40 @@ static void b43_stop(struct ieee80211_hw
 	mutex_unlock(&wl->mutex);
 }
 
+static int b43_op_set_retry_limit(struct ieee80211_hw *hw,
+				  u32 short_retry_limit, u32 long_retry_limit)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	struct b43_wldev *dev;
+	int err = 0;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (unlikely(!dev || (b43_status(dev) < B43_STAT_INITIALIZED))) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
+	b43_set_retry_limits(dev, short_retry_limit, long_retry_limit);
+out_unlock:
+	mutex_unlock(&wl->mutex);
+
+	return err;
+}
+
 static const struct ieee80211_ops b43_hw_ops = {
-	.tx = b43_tx,
-	.conf_tx = b43_conf_tx,
-	.add_interface = b43_add_interface,
-	.remove_interface = b43_remove_interface,
-	.config = b43_dev_config,
-	.config_interface = b43_config_interface,
-	.configure_filter = b43_configure_filter,
-	.set_key = b43_dev_set_key,
-	.get_stats = b43_get_stats,
-	.get_tx_stats = b43_get_tx_stats,
-	.start = b43_start,
-	.stop = b43_stop,
+	.tx			= b43_tx,
+	.conf_tx		= b43_conf_tx,
+	.add_interface		= b43_add_interface,
+	.remove_interface	= b43_remove_interface,
+	.config			= b43_dev_config,
+	.config_interface	= b43_config_interface,
+	.configure_filter	= b43_configure_filter,
+	.set_key		= b43_dev_set_key,
+	.get_stats		= b43_get_stats,
+	.get_tx_stats		= b43_get_tx_stats,
+	.start			= b43_start,
+	.stop			= b43_stop,
+	.set_retry_limit	= b43_op_set_retry_limit,
 };
 
 /* Hard-reset the chip. Do not call this directly.
Index: wireless-2.6/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/xmit.c	2007-10-28 16:08:36.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/xmit.c	2007-10-28 16:11:27.000000000 +0100
@@ -294,6 +294,8 @@ static void generate_txhdr_fw4(struct b4
 		mac_ctl |= B43_TX4_MAC_STMSDU;
 	if (phy->type == B43_PHYTYPE_A)
 		mac_ctl |= B43_TX4_MAC_5GHZ;
+	if (txctl->flags & IEEE80211_TXCTL_LONG_RETRY_LIMIT)
+		mac_ctl |= B43_TX4_MAC_LONGFRAME;
 
 	/* Generate the RTS or CTS-to-self frame */
 	if ((txctl->flags & IEEE80211_TXCTL_USE_RTS_CTS) ||
@@ -342,7 +344,6 @@ static void generate_txhdr_fw4(struct b4
 			    b43_plcp_get_ratecode_cck(rts_rate);
 		if (rts_rate_fb_ofdm)
 			extra_ft |= B43_TX4_EFT_RTSFBOFDM;
-		mac_ctl |= B43_TX4_MAC_LONGFRAME;
 	}
 
 	/* Magic cookie */

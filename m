Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39895 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbZBTOln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 09:41:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Implement sw scan callbacks
Date: Fri, 20 Feb 2009 15:39:21 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200902201539.21888.mb@bu3sch.de> (sfid-20090220_154149_389565_C3555EA5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements the new sw scan callbacks in b43.
They are currently used to turn CFP update in the microcode off while scanning.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please put on top of the mac80211 sw scan notifier patch.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-02-20 14:53:23.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-02-20 15:34:41.000000000 +0100
@@ -4190,12 +4190,13 @@ static int b43_wireless_core_init(struct
 	}
 	if (sprom->boardflags_lo & B43_BFL_XTAL_NOSLOW)
 		hf |= B43_HF_DSCRQ; /* Disable slowclock requests from ucode. */
 	if ((bus->bustype == SSB_BUSTYPE_PCI) &&
 	    (bus->pcicore.dev->id.revision <= 10))
 		hf |= B43_HF_PCISCW; /* PCI slow clock workaround. */
+	hf &= ~B43_HF_SKCFPUP;
 	b43_hf_write(dev, hf);
 
 	b43_set_retry_limits(dev, B43_DEFAULT_SHORT_RETRY_LIMIT,
 			     B43_DEFAULT_LONG_RETRY_LIMIT);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SFFBLIM, 3);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_LFFBLIM, 2);
@@ -4412,12 +4413,40 @@ static void b43_op_sta_notify(struct iee
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 
 	B43_WARN_ON(!vif || wl->vif != vif);
 }
 
+static void b43_op_sw_scan_start_notifier(struct ieee80211_hw *hw)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	struct b43_wldev *dev;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (dev && (b43_status(dev) >= B43_STAT_INITIALIZED)) {
+		/* Disable CFP update during scan on other channels. */
+		b43_hf_write(dev, b43_hf_read(dev) | B43_HF_SKCFPUP);
+	}
+	mutex_unlock(&wl->mutex);
+}
+
+static void b43_op_sw_scan_complete_notifier(struct ieee80211_hw *hw)
+{
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	struct b43_wldev *dev;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (dev && (b43_status(dev) >= B43_STAT_INITIALIZED)) {
+		/* Re-enable CFP update. */
+		b43_hf_write(dev, b43_hf_read(dev) & ~B43_HF_SKCFPUP);
+	}
+	mutex_unlock(&wl->mutex);
+}
+
 static const struct ieee80211_ops b43_hw_ops = {
 	.tx			= b43_op_tx,
 	.conf_tx		= b43_op_conf_tx,
 	.add_interface		= b43_op_add_interface,
 	.remove_interface	= b43_op_remove_interface,
 	.config			= b43_op_config,
@@ -4430,12 +4459,14 @@ static const struct ieee80211_ops b43_hw
 	.get_tsf		= b43_op_get_tsf,
 	.set_tsf		= b43_op_set_tsf,
 	.start			= b43_op_start,
 	.stop			= b43_op_stop,
 	.set_tim		= b43_op_beacon_set_tim,
 	.sta_notify		= b43_op_sta_notify,
+	.sw_scan_start		= b43_op_sw_scan_start_notifier,
+	.sw_scan_complete	= b43_op_sw_scan_complete_notifier,
 };
 
 /* Hard-reset the chip. Do not call this directly.
  * Use b43_controller_restart()
  */
 static void b43_chip_reset(struct work_struct *work)

-- 
Greetings, Michael.

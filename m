Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53358 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020AbYFTQDG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 12:03:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add debugfs firmware debugging knob
Date: Fri, 20 Jun 2008 18:02:08 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200806201802.08440.mb@bu3sch.de> (sfid-20080620_180310_329311_A264668D)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a firmware debugging knob to debugfs.
With this knob it's possible to enable advanced runtime firmware
checks.
For now it only implements one sanity check for the mac-suspend.
In future there'll probably be more.
If CONFIG_B43_DEBUG is disabled, these checks will collapse to nothing.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for 2.6.27



Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2008-06-20 17:38:13.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2008-06-20 17:40:09.000000000 +0200
@@ -798,12 +798,13 @@ static void b43_add_dynamic_debug(struct
 	add_dyn_dbg("debug_xmitpower", B43_DBG_XMITPOWER, 0);
 	add_dyn_dbg("debug_dmaoverflow", B43_DBG_DMAOVERFLOW, 0);
 	add_dyn_dbg("debug_dmaverbose", B43_DBG_DMAVERBOSE, 0);
 	add_dyn_dbg("debug_pwork_fast", B43_DBG_PWORK_FAST, 0);
 	add_dyn_dbg("debug_pwork_stop", B43_DBG_PWORK_STOP, 0);
 	add_dyn_dbg("debug_lo", B43_DBG_LO, 0);
+	add_dyn_dbg("debug_firmware", B43_DBG_FIRMWARE, 0);
 
 #undef add_dyn_dbg
 }
 
 void b43_debugfs_add_device(struct b43_wldev *dev)
 {
Index: wireless-testing/drivers/net/wireless/b43/debugfs.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.h	2008-06-20 17:38:13.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.h	2008-06-20 17:40:09.000000000 +0200
@@ -8,12 +8,13 @@ enum b43_dyndbg {		/* Dynamic debugging 
 	B43_DBG_XMITPOWER,
 	B43_DBG_DMAOVERFLOW,
 	B43_DBG_DMAVERBOSE,
 	B43_DBG_PWORK_FAST,
 	B43_DBG_PWORK_STOP,
 	B43_DBG_LO,
+	B43_DBG_FIRMWARE,
 	__B43_NR_DYNDBG,
 };
 
 #ifdef CONFIG_B43_DEBUG
 
 struct dentry;
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-06-20 17:40:06.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-06-20 17:57:06.000000000 +0200
@@ -2485,12 +2485,25 @@ static void b43_gpio_cleanup(struct b43_
 	ssb_write32(gpiodev, B43_GPIO_CONTROL, 0);
 }
 
 /* http://bcm-specs.sipsolutions.net/EnableMac */
 void b43_mac_enable(struct b43_wldev *dev)
 {
+	if (b43_debug(dev, B43_DBG_FIRMWARE)) {
+		u16 fwstate;
+
+		fwstate = b43_shm_read16(dev, B43_SHM_SHARED,
+					 B43_SHM_SH_UCODESTAT);
+		if ((fwstate != B43_SHM_SH_UCODESTAT_SUSP) &&
+		    (fwstate != B43_SHM_SH_UCODESTAT_SLEEP)) {
+			b43err(dev->wl, "b43_mac_enable(): The firmware "
+			       "should be suspended, but current state is %u\n",
+			       fwstate);
+		}
+	}
+
 	dev->mac_suspended--;
 	B43_WARN_ON(dev->mac_suspended < 0);
 	if (dev->mac_suspended == 0) {
 		b43_write32(dev, B43_MMIO_MACCTL,
 			    b43_read32(dev, B43_MMIO_MACCTL)
 			    | B43_MACCTL_ENABLED);

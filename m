Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:46147 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbXHBPyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 11:54:31 -0400
Date: Thu, 02 Aug 2007 10:53:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [RFC 5/10] Port of bcm43xx from softmac to mac80211
Message-ID: <46b1fe04.IfveQgM5dSl8zU22%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This if file 5 of 10 of the port of the bcm43xx driver from softmac
to mac80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -1,32 +1,33 @@
 /*
-
-  Broadcom BCM43xx wireless driver
-
-  Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-                     Stefano Brivio <st3@riseup.net>
-                     Michael Buesch <mbuesch@freenet.de>
-                     Danny van Dyk <kugelfang@gentoo.org>
-                     Andreas Jaggi <andreas.jaggi@waterwave.ch>
-
-  Some parts of the code in this file are derived from the ipw2200
-  driver  Copyright(c) 2003 - 2004 Intel Corporation.
-
-  This program is free software; you can redistribute it and/or modify
-  it under the terms of the GNU General Public License as published by
-  the Free Software Foundation; either version 2 of the License, or
-  (at your option) any later version.
-
-  This program is distributed in the hope that it will be useful,
-  but WITHOUT ANY WARRANTY; without even the implied warranty of
-  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-  GNU General Public License for more details.
-
-  You should have received a copy of the GNU General Public License
-  along with this program; see the file COPYING.  If not, write to
-  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
-  Boston, MA 02110-1301, USA.
-
-*/
+ *
+ *  Broadcom BCM43xx wireless driver
+ *
+ *  Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>
+ *  Copyright (c) 2005 Stefano Brivio <st3@riseup.net>
+ *  Copyright (c) 2005, 2006 Michael Buesch <mb@bu3sch.de>
+ *  Copyright (c) 2005 Danny van Dyk <kugelfang@gentoo.org>
+ *  Copyright (c) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
+ *  Copyright (c) 2007 Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *  Some parts of the code in this file are derived from the ipw2200
+ *  driver  Copyright(c) 2003 - 2004 Intel Corporation.
+
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
+ *  Boston, MA 02110-1301, USA.
+ *
+ */
 
 #include <linux/delay.h>
 #include <linux/init.h>
@@ -39,20 +40,17 @@
 #include <linux/workqueue.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
-#include <net/iw_handler.h>
+#include <net/dst.h>
 
 #include "bcm43xx.h"
 #include "bcm43xx_main.h"
 #include "bcm43xx_debugfs.h"
-#include "bcm43xx_radio.h"
 #include "bcm43xx_phy.h"
 #include "bcm43xx_dma.h"
 #include "bcm43xx_pio.h"
-#include "bcm43xx_power.h"
-#include "bcm43xx_wx.h"
-#include "bcm43xx_ethtool.h"
-#include "bcm43xx_xmit.h"
 #include "bcm43xx_sysfs.h"
+#include "bcm43xx_xmit.h"
+#include "bcm43xx_radio.h"
 
 
 MODULE_DESCRIPTION("Broadcom BCM43xx wireless driver");
@@ -83,80 +81,177 @@ static int modparam_long_retry = BCM43xx
 module_param_named(long_retry, modparam_long_retry, int, 0444);
 MODULE_PARM_DESC(long_retry, "Long-Retry-Limit (0 - 15)");
 
-static int modparam_locale = -1;
-module_param_named(locale, modparam_locale, int, 0444);
-MODULE_PARM_DESC(country, "Select LocaleCode 0-11 (For travelers)");
-
 static int modparam_noleds;
 module_param_named(noleds, modparam_noleds, int, 0444);
 MODULE_PARM_DESC(noleds, "Turn off all LED activity");
 
-static char modparam_fwpostfix[64];
-module_param_string(fwpostfix, modparam_fwpostfix, 64, 0444);
-MODULE_PARM_DESC(fwpostfix, "Postfix for .fw files. Useful for using multiple firmware image versions.");
+static char modparam_fwpostfix[16] = {".fw3"};
+module_param_string(fwpostfix, modparam_fwpostfix, 16, 0444);
+MODULE_PARM_DESC(fwpostfix, "Postfix for the .fw files to load.");
+
+static int modparam_mon_keep_bad;
+module_param_named(mon_keep_bad, modparam_mon_keep_bad, int, 0444);
+MODULE_PARM_DESC(mon_keep_bad, "Keep bad frames in monitor mode");
+
+static int modparam_mon_keep_badplcp;
+module_param_named(mon_keep_badplcp, modparam_mon_keep_bad, int, 0444);
+MODULE_PARM_DESC(mon_keep_badplcp, "Keep frames with bad PLCP in monitor mode");
+
+
+static const struct ssb_device_id bcm43xx_ssb_tbl[] = {
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, SSB_ANY_REV),
+	SSB_DEVTABLE_END
+};
+MODULE_DEVICE_TABLE(ssb, bcm43xx_ssb_tbl);
 
 
-/* If you want to debug with just a single device, enable this,
- * where the string is the pci device ID (as given by the kernel's
- * pci_name function) of the device to be used.
- */
-//#define DEBUG_SINGLE_DEVICE_ONLY	"0001:11:00.0"
+/* Channel and ratetables are shared for all devices.
+ * They can't be const, because ieee80211 puts some precalculated
+ * data in there. This data is the same for all devices, so we don't
+ * get concurrency issues */
+#define RATETAB_ENT(_rateid, _flags) \
+	{							\
+		.rate	= BCM43xx_RATE_TO_100KBPS(_rateid),	\
+		.val	= (_rateid),				\
+		.val2	= (_rateid),				\
+		.flags	= (_flags),				\
+	}
+static struct ieee80211_rate __bcm43xx_ratetable[] = {
+	RATETAB_ENT(BCM43xx_CCK_RATE_1MB, IEEE80211_RATE_CCK),
+	RATETAB_ENT(BCM43xx_CCK_RATE_2MB, IEEE80211_RATE_CCK_2),
+	RATETAB_ENT(BCM43xx_CCK_RATE_5MB, IEEE80211_RATE_CCK_2),
+	RATETAB_ENT(BCM43xx_CCK_RATE_11MB, IEEE80211_RATE_CCK_2),
+	RATETAB_ENT(BCM43xx_OFDM_RATE_6MB, IEEE80211_RATE_OFDM),
+	RATETAB_ENT(BCM43xx_OFDM_RATE_9MB, IEEE80211_RATE_OFDM),
+	RATETAB_ENT(BCM43xx_OFDM_RATE_12MB, IEEE80211_RATE_OFDM),
+	RATETAB_ENT(BCM43xx_OFDM_RATE_18MB, IEEE80211_RATE_OFDM),
+	RATETAB_ENT(BCM43xx_OFDM_RATE_24MB, IEEE80211_RATE_OFDM),
+	RATETAB_ENT(BCM43xx_OFDM_RATE_36MB, IEEE80211_RATE_OFDM),
+	RATETAB_ENT(BCM43xx_OFDM_RATE_48MB, IEEE80211_RATE_OFDM),
+	RATETAB_ENT(BCM43xx_OFDM_RATE_54MB, IEEE80211_RATE_OFDM),
+};
+#define bcm43xx_a_ratetable		(__bcm43xx_ratetable + 4)
+#define bcm43xx_a_ratetable_size	8
+#define bcm43xx_b_ratetable		(__bcm43xx_ratetable + 0)
+#define bcm43xx_b_ratetable_size	4
+#define bcm43xx_g_ratetable		(__bcm43xx_ratetable + 0)
+#define bcm43xx_g_ratetable_size	12
+
+#define CHANTAB_ENT(_chanid, _freq) \
+	{							\
+		.chan	= (_chanid),				\
+		.freq	= (_freq),				\
+		.val	= (_chanid),				\
+		.flag	= IEEE80211_CHAN_W_SCAN |		\
+			  IEEE80211_CHAN_W_ACTIVE_SCAN |	\
+			  IEEE80211_CHAN_W_IBSS,		\
+		.power_level	= 0xFF,				\
+		.antenna_max	= 0xFF,				\
+	}
+static struct ieee80211_channel bcm43xx_bg_chantable[] = {
+	CHANTAB_ENT(1, 2412),
+	CHANTAB_ENT(2, 2417),
+	CHANTAB_ENT(3, 2422),
+	CHANTAB_ENT(4, 2427),
+	CHANTAB_ENT(5, 2432),
+	CHANTAB_ENT(6, 2437),
+	CHANTAB_ENT(7, 2442),
+	CHANTAB_ENT(8, 2447),
+	CHANTAB_ENT(9, 2452),
+	CHANTAB_ENT(10, 2457),
+	CHANTAB_ENT(11, 2462),
+	CHANTAB_ENT(12, 2467),
+	CHANTAB_ENT(13, 2472),
+	CHANTAB_ENT(14, 2484),
+};
+#define bcm43xx_bg_chantable_size	ARRAY_SIZE(bcm43xx_bg_chantable)
 
-/* If you want to enable printing of each MMIO access, enable this. */
-//#define DEBUG_ENABLE_MMIO_PRINT
+static void bcm43xx_wireless_core_exit(struct bcm43xx_wldev *dev);
+static int bcm43xx_wireless_core_init(struct bcm43xx_wldev *dev);
+static void bcm43xx_wireless_core_stop(struct bcm43xx_wldev *dev);
+static int bcm43xx_wireless_core_start(struct bcm43xx_wldev *dev);
 
-/* If you want to enable printing of MMIO access within
- * ucode/pcm upload, initvals write, enable this.
- */
-//#define DEBUG_ENABLE_UCODE_MMIO_PRINT
 
-/* If you want to enable printing of PCI Config Space access, enable this */
-//#define DEBUG_ENABLE_PCILOG
+static int bcm43xx_ratelimit(struct bcm43xx_wl *wl)
+{
+	if (!wl || !wl->current_dev)
+		return 1;
+	if (bcm43xx_status(wl->current_dev) < BCM43xx_STAT_STARTED)
+		return 1;
+	/* We are up and running.
+	 * Ratelimit the messages to avoid DoS over the net. */
+	return net_ratelimit();
+}
+
+void bcminfo(struct bcm43xx_wl *wl, const char *fmt, ...)
+{
+	va_list args;
 
+	if (!bcm43xx_ratelimit(wl))
+		return;
+	va_start(args, fmt);
+	printk(KERN_INFO "bcm43xx-%s: ",
+	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
+	vprintk(fmt, args);
+	va_end(args);
+}
 
-/* Detailed list maintained at:
- * http://openfacts.berlios.de/index-en.phtml?title=Bcm43xxDevices
- */
-	static struct pci_device_id bcm43xx_pci_tbl[] = {
-	/* Broadcom 4303 802.11b */
-	{ PCI_VENDOR_ID_BROADCOM, 0x4301, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	/* Broadcom 4307 802.11b */
-	{ PCI_VENDOR_ID_BROADCOM, 0x4307, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	/* Broadcom 4311 802.11(a)/b/g */
-	{ PCI_VENDOR_ID_BROADCOM, 0x4311, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	/* Broadcom 4312 802.11a/b/g */
-	{ PCI_VENDOR_ID_BROADCOM, 0x4312, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	/* Broadcom 4318 802.11b/g */
-	{ PCI_VENDOR_ID_BROADCOM, 0x4318, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	/* Broadcom 4319 802.11a/b/g */
-	{ PCI_VENDOR_ID_BROADCOM, 0x4319, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	/* Broadcom 4306 802.11b/g */
-	{ PCI_VENDOR_ID_BROADCOM, 0x4320, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	/* Broadcom 4306 802.11a */
-//	{ PCI_VENDOR_ID_BROADCOM, 0x4321, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	/* Broadcom 4309 802.11a/b/g */
-	{ PCI_VENDOR_ID_BROADCOM, 0x4324, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	/* Broadcom 43XG 802.11b/g */
-	{ PCI_VENDOR_ID_BROADCOM, 0x4325, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ 0 },
-};
-MODULE_DEVICE_TABLE(pci, bcm43xx_pci_tbl);
+void bcmerr(struct bcm43xx_wl *wl, const char *fmt, ...)
+{
+	va_list args;
+
+	if (!bcm43xx_ratelimit(wl))
+		return;
+	va_start(args, fmt);
+	printk(KERN_ERR "bcm43xx-%s ERROR: ",
+	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
+	vprintk(fmt, args);
+	va_end(args);
+}
+
+void bcmwarn(struct bcm43xx_wl *wl, const char *fmt, ...)
+{
+	va_list args;
+
+	if (!bcm43xx_ratelimit(wl))
+		return;
+	va_start(args, fmt);
+	printk(KERN_WARNING "bcm43xx-%s warning: ",
+	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
+	vprintk(fmt, args);
+	va_end(args);
+}
+
+#if BCM43xx_DEBUG
+void bcmdbg(struct bcm43xx_wl *wl, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	printk(KERN_DEBUG "bcm43xx-%s debug: ",
+	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
+	vprintk(fmt, args);
+	va_end(args);
+}
+#endif /* DEBUG */
 
-static void bcm43xx_ram_write(struct bcm43xx_private *bcm, u16 offset, u32 val)
+static void bcm43xx_ram_write(struct bcm43xx_wldev *dev, u16 offset, u32 val)
 {
 	u32 status;
 
-	status = bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD);
-	if (!(status & BCM43xx_SBF_XFER_REG_BYTESWAP))
+	BCM43xx_WARN_ON(offset % 4 != 0);
+
+	status = bcm43xx_read32(dev, BCM43xx_MMIO_STATUS_BITFIELD);
+	if (status & BCM43xx_SBF_XFER_REG_BYTESWAP)
 		val = swab32(val);
 
-	bcm43xx_write32(bcm, BCM43xx_MMIO_RAM_CONTROL, offset);
+	bcm43xx_write32(dev, BCM43xx_MMIO_RAM_CONTROL, offset);
 	mmiowb();
-	bcm43xx_write32(bcm, BCM43xx_MMIO_RAM_DATA, val);
+	bcm43xx_write32(dev, BCM43xx_MMIO_RAM_DATA, val);
 }
 
 static inline
-void bcm43xx_shm_control_word(struct bcm43xx_private *bcm,
+void bcm43xx_shm_control_word(struct bcm43xx_wldev *dev,
 			      u16 routing, u16 offset)
 {
 	u32 control;
@@ -166,100 +261,134 @@ void bcm43xx_shm_control_word(struct bcm
 	control = routing;
 	control <<= 16;
 	control |= offset;
-	bcm43xx_write32(bcm, BCM43xx_MMIO_SHM_CONTROL, control);
+	bcm43xx_write32(dev, BCM43xx_MMIO_SHM_CONTROL, control);
 }
 
-u32 bcm43xx_shm_read32(struct bcm43xx_private *bcm,
+u32 bcm43xx_shm_read32(struct bcm43xx_wldev *dev,
 		       u16 routing, u16 offset)
 {
 	u32 ret;
 
 	if (routing == BCM43xx_SHM_SHARED) {
+		BCM43xx_WARN_ON((offset & 0x0001) != 0);
 		if (offset & 0x0003) {
 			/* Unaligned access */
-			bcm43xx_shm_control_word(bcm, routing, offset >> 2);
-			ret = bcm43xx_read16(bcm, BCM43xx_MMIO_SHM_DATA_UNALIGNED);
+			bcm43xx_shm_control_word(dev, routing, offset >> 2);
+			ret = bcm43xx_read16(dev,
+					     BCM43xx_MMIO_SHM_DATA_UNALIGNED);
 			ret <<= 16;
-			bcm43xx_shm_control_word(bcm, routing, (offset >> 2) + 1);
-			ret |= bcm43xx_read16(bcm, BCM43xx_MMIO_SHM_DATA);
+			bcm43xx_shm_control_word(dev, routing,
+						 (offset >> 2) + 1);
+			ret |= bcm43xx_read16(dev,
+					      BCM43xx_MMIO_SHM_DATA);
 
 			return ret;
 		}
 		offset >>= 2;
 	}
-	bcm43xx_shm_control_word(bcm, routing, offset);
-	ret = bcm43xx_read32(bcm, BCM43xx_MMIO_SHM_DATA);
+	bcm43xx_shm_control_word(dev, routing, offset);
+	ret = bcm43xx_read32(dev, BCM43xx_MMIO_SHM_DATA);
 
 	return ret;
 }
 
-u16 bcm43xx_shm_read16(struct bcm43xx_private *bcm,
+u16 bcm43xx_shm_read16(struct bcm43xx_wldev *dev,
 		       u16 routing, u16 offset)
 {
 	u16 ret;
 
 	if (routing == BCM43xx_SHM_SHARED) {
+		BCM43xx_WARN_ON((offset & 0x0001) != 0);
 		if (offset & 0x0003) {
 			/* Unaligned access */
-			bcm43xx_shm_control_word(bcm, routing, offset >> 2);
-			ret = bcm43xx_read16(bcm, BCM43xx_MMIO_SHM_DATA_UNALIGNED);
+			bcm43xx_shm_control_word(dev, routing, offset >> 2);
+			ret = bcm43xx_read16(dev,
+					     BCM43xx_MMIO_SHM_DATA_UNALIGNED);
 
 			return ret;
 		}
 		offset >>= 2;
 	}
-	bcm43xx_shm_control_word(bcm, routing, offset);
-	ret = bcm43xx_read16(bcm, BCM43xx_MMIO_SHM_DATA);
+	bcm43xx_shm_control_word(dev, routing, offset);
+	ret = bcm43xx_read16(dev, BCM43xx_MMIO_SHM_DATA);
 
 	return ret;
 }
 
-void bcm43xx_shm_write32(struct bcm43xx_private *bcm,
+void bcm43xx_shm_write32(struct bcm43xx_wldev *dev,
 			 u16 routing, u16 offset,
 			 u32 value)
 {
 	if (routing == BCM43xx_SHM_SHARED) {
+		BCM43xx_WARN_ON((offset & 0x0001) != 0);
 		if (offset & 0x0003) {
 			/* Unaligned access */
-			bcm43xx_shm_control_word(bcm, routing, offset >> 2);
+			bcm43xx_shm_control_word(dev, routing, offset >> 2);
 			mmiowb();
-			bcm43xx_write16(bcm, BCM43xx_MMIO_SHM_DATA_UNALIGNED,
+			bcm43xx_write16(dev, BCM43xx_MMIO_SHM_DATA_UNALIGNED,
 					(value >> 16) & 0xffff);
 			mmiowb();
-			bcm43xx_shm_control_word(bcm, routing, (offset >> 2) + 1);
+			bcm43xx_shm_control_word(dev, routing,
+						 (offset >> 2) + 1);
 			mmiowb();
-			bcm43xx_write16(bcm, BCM43xx_MMIO_SHM_DATA,
+			bcm43xx_write16(dev, BCM43xx_MMIO_SHM_DATA,
 					value & 0xffff);
 			return;
 		}
 		offset >>= 2;
 	}
-	bcm43xx_shm_control_word(bcm, routing, offset);
+	bcm43xx_shm_control_word(dev, routing, offset);
 	mmiowb();
-	bcm43xx_write32(bcm, BCM43xx_MMIO_SHM_DATA, value);
+	bcm43xx_write32(dev, BCM43xx_MMIO_SHM_DATA, value);
 }
 
-void bcm43xx_shm_write16(struct bcm43xx_private *bcm,
+void bcm43xx_shm_write16(struct bcm43xx_wldev *dev,
 			 u16 routing, u16 offset,
 			 u16 value)
 {
 	if (routing == BCM43xx_SHM_SHARED) {
+		BCM43xx_WARN_ON((offset & 0x0001) != 0);
 		if (offset & 0x0003) {
 			/* Unaligned access */
-			bcm43xx_shm_control_word(bcm, routing, offset >> 2);
+			bcm43xx_shm_control_word(dev, routing, offset >> 2);
 			mmiowb();
-			bcm43xx_write16(bcm, BCM43xx_MMIO_SHM_DATA_UNALIGNED,
+			bcm43xx_write16(dev, BCM43xx_MMIO_SHM_DATA_UNALIGNED,
 					value);
 			return;
 		}
 		offset >>= 2;
 	}
-	bcm43xx_shm_control_word(bcm, routing, offset);
+	bcm43xx_shm_control_word(dev, routing, offset);
 	mmiowb();
-	bcm43xx_write16(bcm, BCM43xx_MMIO_SHM_DATA, value);
+	bcm43xx_write16(dev, BCM43xx_MMIO_SHM_DATA, value);
+}
+
+/* Read HostFlags */
+u32 bcm43xx_hf_read(struct bcm43xx_wldev *dev)
+{
+	u32 ret;
+
+	ret = bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED,
+				 BCM43xx_SHM_SH_HOSTFHI);
+	ret <<= 16;
+	ret |= bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED,
+				  BCM43xx_SHM_SH_HOSTFLO);
+
+	return ret;
+}
+
+/* Write HostFlags */
+void bcm43xx_hf_write(struct bcm43xx_wldev *dev, u32 value)
+{
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
+			    BCM43xx_SHM_SH_HOSTFLO,
+			    (value & 0x0000FFFF));
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
+			    BCM43xx_SHM_SH_HOSTFHI,
+			    ((value & 0xFFFF0000) >> 16));
 }
 
-void bcm43xx_tsf_read(struct bcm43xx_private *bcm, u64 *tsf)
+void bcm43xx_tsf_read(struct bcm43xx_wldev *dev, u64 *tsf)
 {
 	/* We need to be careful. As we read the TSF from multiple
 	 * registers, we should take care of register overflows.
@@ -267,13 +396,16 @@ void bcm43xx_tsf_read(struct bcm43xx_pri
 	 * We try to be atomic here, by restaring the read process,
 	 * if any of the high registers changed (overflew).
 	 */
-	if (bcm->current_core->rev >= 3) {
+	if (dev->dev->id.revision >= 3) {
 		u32 low, high, high2;
 
 		do {
-			high = bcm43xx_read32(bcm, BCM43xx_MMIO_REV3PLUS_TSF_HIGH);
-			low = bcm43xx_read32(bcm, BCM43xx_MMIO_REV3PLUS_TSF_LOW);
-			high2 = bcm43xx_read32(bcm, BCM43xx_MMIO_REV3PLUS_TSF_HIGH);
+			high = bcm43xx_read32(dev,
+					      BCM43xx_MMIO_REV3PLUS_TSF_HIGH);
+			low = bcm43xx_read32(dev,
+					     BCM43xx_MMIO_REV3PLUS_TSF_LOW);
+			high2 = bcm43xx_read32(dev,
+					     BCM43xx_MMIO_REV3PLUS_TSF_HIGH);
 		} while (unlikely(high != high2));
 
 		*tsf = high;
@@ -285,14 +417,14 @@ void bcm43xx_tsf_read(struct bcm43xx_pri
 		u16 test1, test2, test3;
 
 		do {
-			v3 = bcm43xx_read16(bcm, BCM43xx_MMIO_TSF_3);
-			v2 = bcm43xx_read16(bcm, BCM43xx_MMIO_TSF_2);
-			v1 = bcm43xx_read16(bcm, BCM43xx_MMIO_TSF_1);
-			v0 = bcm43xx_read16(bcm, BCM43xx_MMIO_TSF_0);
-
-			test3 = bcm43xx_read16(bcm, BCM43xx_MMIO_TSF_3);
-			test2 = bcm43xx_read16(bcm, BCM43xx_MMIO_TSF_2);
-			test1 = bcm43xx_read16(bcm, BCM43xx_MMIO_TSF_1);
+			v3 = bcm43xx_read16(dev, BCM43xx_MMIO_TSF_3);
+			v2 = bcm43xx_read16(dev, BCM43xx_MMIO_TSF_2);
+			v1 = bcm43xx_read16(dev, BCM43xx_MMIO_TSF_1);
+			v0 = bcm43xx_read16(dev, BCM43xx_MMIO_TSF_0);
+
+			test3 = bcm43xx_read16(dev, BCM43xx_MMIO_TSF_3);
+			test2 = bcm43xx_read16(dev, BCM43xx_MMIO_TSF_2);
+			test1 = bcm43xx_read16(dev, BCM43xx_MMIO_TSF_1);
 		} while (v3 != test3 || v2 != test2 || v1 != test1);
 
 		*tsf = v3;
@@ -307,172 +439,159 @@ void bcm43xx_tsf_read(struct bcm43xx_pri
 	}
 }
 
-void bcm43xx_tsf_write(struct bcm43xx_private *bcm, u64 tsf)
+static void bcm43xx_time_lock(struct bcm43xx_wldev *dev)
 {
 	u32 status;
 
-	status = bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD);
+	status = bcm43xx_read32(dev, BCM43xx_MMIO_STATUS_BITFIELD);
 	status |= BCM43xx_SBF_TIME_UPDATE;
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD, status);
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD, status);
 	mmiowb();
+}
+
+static void bcm43xx_time_unlock(struct bcm43xx_wldev *dev)
+{
+	u32 status;
 
+	status = bcm43xx_read32(dev, BCM43xx_MMIO_STATUS_BITFIELD);
+	status &= ~BCM43xx_SBF_TIME_UPDATE;
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD, status);
+}
+
+static void bcm43xx_tsf_write_locked(struct bcm43xx_wldev *dev, u64 tsf)
+{
 	/* Be careful with the in-progress timer.
 	 * First zero out the low register, so we have a full
 	 * register-overflow duration to complete the operation.
 	 */
-	if (bcm->current_core->rev >= 3) {
+	if (dev->dev->id.revision >= 3) {
 		u32 lo = (tsf & 0x00000000FFFFFFFFULL);
 		u32 hi = (tsf & 0xFFFFFFFF00000000ULL) >> 32;
 
-		bcm43xx_write32(bcm, BCM43xx_MMIO_REV3PLUS_TSF_LOW, 0);
+		bcm43xx_write32(dev, BCM43xx_MMIO_REV3PLUS_TSF_LOW, 0);
 		mmiowb();
-		bcm43xx_write32(bcm, BCM43xx_MMIO_REV3PLUS_TSF_HIGH, hi);
+		bcm43xx_write32(dev, BCM43xx_MMIO_REV3PLUS_TSF_HIGH, hi);
 		mmiowb();
-		bcm43xx_write32(bcm, BCM43xx_MMIO_REV3PLUS_TSF_LOW, lo);
+		bcm43xx_write32(dev, BCM43xx_MMIO_REV3PLUS_TSF_LOW, lo);
 	} else {
 		u16 v0 = (tsf & 0x000000000000FFFFULL);
 		u16 v1 = (tsf & 0x00000000FFFF0000ULL) >> 16;
 		u16 v2 = (tsf & 0x0000FFFF00000000ULL) >> 32;
 		u16 v3 = (tsf & 0xFFFF000000000000ULL) >> 48;
 
-		bcm43xx_write16(bcm, BCM43xx_MMIO_TSF_0, 0);
+		bcm43xx_write16(dev, BCM43xx_MMIO_TSF_0, 0);
 		mmiowb();
-		bcm43xx_write16(bcm, BCM43xx_MMIO_TSF_3, v3);
+		bcm43xx_write16(dev, BCM43xx_MMIO_TSF_3, v3);
 		mmiowb();
-		bcm43xx_write16(bcm, BCM43xx_MMIO_TSF_2, v2);
+		bcm43xx_write16(dev, BCM43xx_MMIO_TSF_2, v2);
 		mmiowb();
-		bcm43xx_write16(bcm, BCM43xx_MMIO_TSF_1, v1);
+		bcm43xx_write16(dev, BCM43xx_MMIO_TSF_1, v1);
 		mmiowb();
-		bcm43xx_write16(bcm, BCM43xx_MMIO_TSF_0, v0);
+		bcm43xx_write16(dev, BCM43xx_MMIO_TSF_0, v0);
 	}
+}
 
-	status = bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD);
-	status &= ~BCM43xx_SBF_TIME_UPDATE;
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD, status);
+void bcm43xx_tsf_write(struct bcm43xx_wldev *dev, u64 tsf)
+{
+	bcm43xx_time_lock(dev);
+	bcm43xx_tsf_write_locked(dev, tsf);
+	bcm43xx_time_unlock(dev);
 }
 
 static
-void bcm43xx_macfilter_set(struct bcm43xx_private *bcm,
+void bcm43xx_macfilter_set(struct bcm43xx_wldev *dev,
 			   u16 offset,
 			   const u8 *mac)
 {
+	static const u8 zero_addr[ETH_ALEN] = { 0 };
 	u16 data;
 
+	if (!mac)
+		mac = zero_addr;
+
 	offset |= 0x0020;
-	bcm43xx_write16(bcm, BCM43xx_MMIO_MACFILTER_CONTROL, offset);
+	bcm43xx_write16(dev, BCM43xx_MMIO_MACFILTER_CONTROL, offset);
 
 	data = mac[0];
 	data |= mac[1] << 8;
-	bcm43xx_write16(bcm, BCM43xx_MMIO_MACFILTER_DATA, data);
+	bcm43xx_write16(dev, BCM43xx_MMIO_MACFILTER_DATA, data);
 	data = mac[2];
 	data |= mac[3] << 8;
-	bcm43xx_write16(bcm, BCM43xx_MMIO_MACFILTER_DATA, data);
+	bcm43xx_write16(dev, BCM43xx_MMIO_MACFILTER_DATA, data);
 	data = mac[4];
 	data |= mac[5] << 8;
-	bcm43xx_write16(bcm, BCM43xx_MMIO_MACFILTER_DATA, data);
-}
-
-static void bcm43xx_macfilter_clear(struct bcm43xx_private *bcm,
-				    u16 offset)
-{
-	const u8 zero_addr[ETH_ALEN] = { 0 };
-
-	bcm43xx_macfilter_set(bcm, offset, zero_addr);
+	bcm43xx_write16(dev, BCM43xx_MMIO_MACFILTER_DATA, data);
 }
 
-static void bcm43xx_write_mac_bssid_templates(struct bcm43xx_private *bcm)
+static void bcm43xx_write_mac_bssid_templates(struct bcm43xx_wldev *dev)
 {
-	const u8 *mac = (const u8 *)(bcm->net_dev->dev_addr);
-	const u8 *bssid = (const u8 *)(bcm->ieee->bssid);
+	static const u8 zero_addr[ETH_ALEN] = { 0 };
+	const u8 *mac = dev->wl->mac_addr;
+	const u8 *bssid = dev->wl->bssid;
 	u8 mac_bssid[ETH_ALEN * 2];
 	int i;
+	u32 tmp;
+
+	if (!bssid)
+		bssid = zero_addr;
+	if (!mac)
+		mac = zero_addr;
+
+	bcm43xx_macfilter_set(dev, BCM43xx_MACFILTER_BSSID, bssid);
 
 	memcpy(mac_bssid, mac, ETH_ALEN);
 	memcpy(mac_bssid + ETH_ALEN, bssid, ETH_ALEN);
 
 	/* Write our MAC address and BSSID to template ram */
-	for (i = 0; i < ARRAY_SIZE(mac_bssid); i += sizeof(u32))
-		bcm43xx_ram_write(bcm, 0x20 + i, *((u32 *)(mac_bssid + i)));
-	for (i = 0; i < ARRAY_SIZE(mac_bssid); i += sizeof(u32))
-		bcm43xx_ram_write(bcm, 0x78 + i, *((u32 *)(mac_bssid + i)));
-	for (i = 0; i < ARRAY_SIZE(mac_bssid); i += sizeof(u32))
-		bcm43xx_ram_write(bcm, 0x478 + i, *((u32 *)(mac_bssid + i)));
-}
-
-//FIXME: Well, we should probably call them from somewhere.
-#if 0
-static void bcm43xx_set_slot_time(struct bcm43xx_private *bcm, u16 slot_time)
-{
-	/* slot_time is in usec. */
-	if (bcm43xx_current_phy(bcm)->type != BCM43xx_PHYTYPE_G)
-		return;
-	bcm43xx_write16(bcm, 0x684, 510 + slot_time);
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x0010, slot_time);
+	for (i = 0; i < ARRAY_SIZE(mac_bssid); i += sizeof(u32)) {
+		tmp =  (u32)(mac_bssid[i + 0]);
+		tmp |= (u32)(mac_bssid[i + 1]) << 8;
+		tmp |= (u32)(mac_bssid[i + 2]) << 16;
+		tmp |= (u32)(mac_bssid[i + 3]) << 24;
+		bcm43xx_ram_write(dev, 0x20 + i, tmp);
+		bcm43xx_ram_write(dev, 0x78 + i, tmp);
+		bcm43xx_ram_write(dev, 0x478 + i, tmp);
+	}
 }
 
-static void bcm43xx_short_slot_timing_enable(struct bcm43xx_private *bcm)
+static void bcm43xx_upload_card_macaddress(struct bcm43xx_wldev *dev,
+					   const u8 *mac_addr)
 {
-	bcm43xx_set_slot_time(bcm, 9);
+	dev->wl->mac_addr = mac_addr;
+	bcm43xx_write_mac_bssid_templates(dev);
+	bcm43xx_macfilter_set(dev, BCM43xx_MACFILTER_SELF, mac_addr);
 }
 
-static void bcm43xx_short_slot_timing_disable(struct bcm43xx_private *bcm)
+static void bcm43xx_set_slot_time(struct bcm43xx_wldev *dev, u16 slot_time)
 {
-	bcm43xx_set_slot_time(bcm, 20);
+	/* slot_time is in usec. */
+	if (dev->phy.type != BCM43xx_PHYTYPE_G)
+		return;
+	bcm43xx_write16(dev, 0x684, 510 + slot_time);
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, 0x0010, slot_time);
 }
-#endif
 
-/* FIXME: To get the MAC-filter working, we need to implement the
- *        following functions (and rename them :)
- */
-#if 0
-static void bcm43xx_disassociate(struct bcm43xx_private *bcm)
+static void bcm43xx_short_slot_timing_enable(struct bcm43xx_wldev *dev)
 {
-	bcm43xx_mac_suspend(bcm);
-	bcm43xx_macfilter_clear(bcm, BCM43xx_MACFILTER_ASSOC);
-
-	bcm43xx_ram_write(bcm, 0x0026, 0x0000);
-	bcm43xx_ram_write(bcm, 0x0028, 0x0000);
-	bcm43xx_ram_write(bcm, 0x007E, 0x0000);
-	bcm43xx_ram_write(bcm, 0x0080, 0x0000);
-	bcm43xx_ram_write(bcm, 0x047E, 0x0000);
-	bcm43xx_ram_write(bcm, 0x0480, 0x0000);
-
-	if (bcm->current_core->rev < 3) {
-		bcm43xx_write16(bcm, 0x0610, 0x8000);
-		bcm43xx_write16(bcm, 0x060E, 0x0000);
-	} else
-		bcm43xx_write32(bcm, 0x0188, 0x80000000);
-
-	bcm43xx_shm_write32(bcm, BCM43xx_SHM_WIRELESS, 0x0004, 0x000003ff);
-
-	if (bcm43xx_current_phy(bcm)->type == BCM43xx_PHYTYPE_G &&
-	    ieee80211_is_ofdm_rate(bcm->softmac->txrates.default_rate))
-		bcm43xx_short_slot_timing_enable(bcm);
-
-	bcm43xx_mac_enable(bcm);
+	bcm43xx_set_slot_time(dev, 9);
+	dev->short_slot = 1;
 }
 
-static void bcm43xx_associate(struct bcm43xx_private *bcm,
-			      const u8 *mac)
+static void bcm43xx_short_slot_timing_disable(struct bcm43xx_wldev *dev)
 {
-	memcpy(bcm->ieee->bssid, mac, ETH_ALEN);
-
-	bcm43xx_mac_suspend(bcm);
-	bcm43xx_macfilter_set(bcm, BCM43xx_MACFILTER_ASSOC, mac);
-	bcm43xx_write_mac_bssid_templates(bcm);
-	bcm43xx_mac_enable(bcm);
+	bcm43xx_set_slot_time(dev, 20);
+	dev->short_slot = 0;
 }
-#endif
 
 /* Enable a Generic IRQ. "mask" is the mask of which IRQs to enable.
  * Returns the _previously_ enabled IRQ mask.
  */
-static inline u32 bcm43xx_interrupt_enable(struct bcm43xx_private *bcm, u32 mask)
+static inline u32 bcm43xx_interrupt_enable(struct bcm43xx_wldev *dev, u32 mask)
 {
 	u32 old_mask;
 
-	old_mask = bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_MASK);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_GEN_IRQ_MASK, old_mask | mask);
+	old_mask = bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_MASK);
+	bcm43xx_write32(dev, BCM43xx_MMIO_GEN_IRQ_MASK, old_mask | mask);
 
 	return old_mask;
 }
@@ -480,12 +599,12 @@ static inline u32 bcm43xx_interrupt_enab
 /* Disable a Generic IRQ. "mask" is the mask of which IRQs to disable.
  * Returns the _previously_ enabled IRQ mask.
  */
-static inline u32 bcm43xx_interrupt_disable(struct bcm43xx_private *bcm, u32 mask)
+static inline u32 bcm43xx_interrupt_disable(struct bcm43xx_wldev *dev, u32 mask)
 {
 	u32 old_mask;
 
-	old_mask = bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_MASK);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_GEN_IRQ_MASK, old_mask & ~mask);
+	old_mask = bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_MASK);
+	bcm43xx_write32(dev, BCM43xx_MMIO_GEN_IRQ_MASK, old_mask & ~mask);
 
 	return old_mask;
 }
@@ -494,982 +613,364 @@ static inline u32 bcm43xx_interrupt_disa
  * IRQs must be masked before calling this.
  * This must not be called with the irq_lock held.
  */
-static void bcm43xx_synchronize_irq(struct bcm43xx_private *bcm)
-{
-	synchronize_irq(bcm->irq);
-	tasklet_disable(&bcm->isr_tasklet);
-}
-
-/* Make sure we don't receive more data from the device. */
-static int bcm43xx_disable_interrupts_sync(struct bcm43xx_private *bcm)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-	if (unlikely(bcm43xx_status(bcm) != BCM43xx_STAT_INITIALIZED)) {
-		spin_unlock_irqrestore(&bcm->irq_lock, flags);
-		return -EBUSY;
-	}
-	bcm43xx_interrupt_disable(bcm, BCM43xx_IRQ_ALL);
-	bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_MASK); /* flush */
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
-	bcm43xx_synchronize_irq(bcm);
-
-	return 0;
-}
-
-static int bcm43xx_read_radioinfo(struct bcm43xx_private *bcm)
-{
-	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	u32 radio_id;
-	u16 manufact;
-	u16 version;
-	u8 revision;
-
-	if (bcm->chip_id == 0x4317) {
-		if (bcm->chip_rev == 0x00)
-			radio_id = 0x3205017F;
-		else if (bcm->chip_rev == 0x01)
-			radio_id = 0x4205017F;
-		else
-			radio_id = 0x5205017F;
-	} else {
-		bcm43xx_write16(bcm, BCM43xx_MMIO_RADIO_CONTROL, BCM43xx_RADIOCTL_ID);
-		radio_id = bcm43xx_read16(bcm, BCM43xx_MMIO_RADIO_DATA_HIGH);
-		radio_id <<= 16;
-		bcm43xx_write16(bcm, BCM43xx_MMIO_RADIO_CONTROL, BCM43xx_RADIOCTL_ID);
-		radio_id |= bcm43xx_read16(bcm, BCM43xx_MMIO_RADIO_DATA_LOW);
-	}
-
-	manufact = (radio_id & 0x00000FFF);
-	version = (radio_id & 0x0FFFF000) >> 12;
-	revision = (radio_id & 0xF0000000) >> 28;
-
-	dprintk(KERN_INFO PFX "Detected Radio: ID: %x (Manuf: %x Ver: %x Rev: %x)\n",
-		radio_id, manufact, version, revision);
-
-	switch (phy->type) {
-	case BCM43xx_PHYTYPE_A:
-		if ((version != 0x2060) || (revision != 1) || (manufact != 0x17f))
-			goto err_unsupported_radio;
-		break;
-	case BCM43xx_PHYTYPE_B:
-		if ((version & 0xFFF0) != 0x2050)
-			goto err_unsupported_radio;
-		break;
-	case BCM43xx_PHYTYPE_G:
-		if (version != 0x2050)
-			goto err_unsupported_radio;
-		break;
-	}
-
-	radio->manufact = manufact;
-	radio->version = version;
-	radio->revision = revision;
-
-	if (phy->type == BCM43xx_PHYTYPE_A)
-		radio->txpower_desired = bcm->sprom.maxpower_aphy;
-	else
-		radio->txpower_desired = bcm->sprom.maxpower_bgphy;
-
-	return 0;
-
-err_unsupported_radio:
-	printk(KERN_ERR PFX "Unsupported Radio connected to the PHY!\n");
-	return -ENODEV;
-}
-
-static const char * bcm43xx_locale_iso(u8 locale)
-{
-	/* ISO 3166-1 country codes.
-	 * Note that there aren't ISO 3166-1 codes for
-	 * all or locales. (Not all locales are countries)
-	 */
-	switch (locale) {
-	case BCM43xx_LOCALE_WORLD:
-	case BCM43xx_LOCALE_ALL:
-		return "XX";
-	case BCM43xx_LOCALE_THAILAND:
-		return "TH";
-	case BCM43xx_LOCALE_ISRAEL:
-		return "IL";
-	case BCM43xx_LOCALE_JORDAN:
-		return "JO";
-	case BCM43xx_LOCALE_CHINA:
-		return "CN";
-	case BCM43xx_LOCALE_JAPAN:
-	case BCM43xx_LOCALE_JAPAN_HIGH:
-		return "JP";
-	case BCM43xx_LOCALE_USA_CANADA_ANZ:
-	case BCM43xx_LOCALE_USA_LOW:
-		return "US";
-	case BCM43xx_LOCALE_EUROPE:
-		return "EU";
-	case BCM43xx_LOCALE_NONE:
-		return "  ";
-	}
-	assert(0);
-	return "  ";
-}
-
-static const char * bcm43xx_locale_string(u8 locale)
-{
-	switch (locale) {
-	case BCM43xx_LOCALE_WORLD:
-		return "World";
-	case BCM43xx_LOCALE_THAILAND:
-		return "Thailand";
-	case BCM43xx_LOCALE_ISRAEL:
-		return "Israel";
-	case BCM43xx_LOCALE_JORDAN:
-		return "Jordan";
-	case BCM43xx_LOCALE_CHINA:
-		return "China";
-	case BCM43xx_LOCALE_JAPAN:
-		return "Japan";
-	case BCM43xx_LOCALE_USA_CANADA_ANZ:
-		return "USA/Canada/ANZ";
-	case BCM43xx_LOCALE_EUROPE:
-		return "Europe";
-	case BCM43xx_LOCALE_USA_LOW:
-		return "USAlow";
-	case BCM43xx_LOCALE_JAPAN_HIGH:
-		return "JapanHigh";
-	case BCM43xx_LOCALE_ALL:
-		return "All";
-	case BCM43xx_LOCALE_NONE:
-		return "None";
-	}
-	assert(0);
-	return "";
-}
-
-static inline u8 bcm43xx_crc8(u8 crc, u8 data)
-{
-	static const u8 t[] = {
-		0x00, 0xF7, 0xB9, 0x4E, 0x25, 0xD2, 0x9C, 0x6B,
-		0x4A, 0xBD, 0xF3, 0x04, 0x6F, 0x98, 0xD6, 0x21,
-		0x94, 0x63, 0x2D, 0xDA, 0xB1, 0x46, 0x08, 0xFF,
-		0xDE, 0x29, 0x67, 0x90, 0xFB, 0x0C, 0x42, 0xB5,
-		0x7F, 0x88, 0xC6, 0x31, 0x5A, 0xAD, 0xE3, 0x14,
-		0x35, 0xC2, 0x8C, 0x7B, 0x10, 0xE7, 0xA9, 0x5E,
-		0xEB, 0x1C, 0x52, 0xA5, 0xCE, 0x39, 0x77, 0x80,
-		0xA1, 0x56, 0x18, 0xEF, 0x84, 0x73, 0x3D, 0xCA,
-		0xFE, 0x09, 0x47, 0xB0, 0xDB, 0x2C, 0x62, 0x95,
-		0xB4, 0x43, 0x0D, 0xFA, 0x91, 0x66, 0x28, 0xDF,
-		0x6A, 0x9D, 0xD3, 0x24, 0x4F, 0xB8, 0xF6, 0x01,
-		0x20, 0xD7, 0x99, 0x6E, 0x05, 0xF2, 0xBC, 0x4B,
-		0x81, 0x76, 0x38, 0xCF, 0xA4, 0x53, 0x1D, 0xEA,
-		0xCB, 0x3C, 0x72, 0x85, 0xEE, 0x19, 0x57, 0xA0,
-		0x15, 0xE2, 0xAC, 0x5B, 0x30, 0xC7, 0x89, 0x7E,
-		0x5F, 0xA8, 0xE6, 0x11, 0x7A, 0x8D, 0xC3, 0x34,
-		0xAB, 0x5C, 0x12, 0xE5, 0x8E, 0x79, 0x37, 0xC0,
-		0xE1, 0x16, 0x58, 0xAF, 0xC4, 0x33, 0x7D, 0x8A,
-		0x3F, 0xC8, 0x86, 0x71, 0x1A, 0xED, 0xA3, 0x54,
-		0x75, 0x82, 0xCC, 0x3B, 0x50, 0xA7, 0xE9, 0x1E,
-		0xD4, 0x23, 0x6D, 0x9A, 0xF1, 0x06, 0x48, 0xBF,
-		0x9E, 0x69, 0x27, 0xD0, 0xBB, 0x4C, 0x02, 0xF5,
-		0x40, 0xB7, 0xF9, 0x0E, 0x65, 0x92, 0xDC, 0x2B,
-		0x0A, 0xFD, 0xB3, 0x44, 0x2F, 0xD8, 0x96, 0x61,
-		0x55, 0xA2, 0xEC, 0x1B, 0x70, 0x87, 0xC9, 0x3E,
-		0x1F, 0xE8, 0xA6, 0x51, 0x3A, 0xCD, 0x83, 0x74,
-		0xC1, 0x36, 0x78, 0x8F, 0xE4, 0x13, 0x5D, 0xAA,
-		0x8B, 0x7C, 0x32, 0xC5, 0xAE, 0x59, 0x17, 0xE0,
-		0x2A, 0xDD, 0x93, 0x64, 0x0F, 0xF8, 0xB6, 0x41,
-		0x60, 0x97, 0xD9, 0x2E, 0x45, 0xB2, 0xFC, 0x0B,
-		0xBE, 0x49, 0x07, 0xF0, 0x9B, 0x6C, 0x22, 0xD5,
-		0xF4, 0x03, 0x4D, 0xBA, 0xD1, 0x26, 0x68, 0x9F,
-	};
-	return t[crc ^ data];
-}
-
-static u8 bcm43xx_sprom_crc(const u16 *sprom)
-{
-	int word;
-	u8 crc = 0xFF;
-
-	for (word = 0; word < BCM43xx_SPROM_SIZE - 1; word++) {
-		crc = bcm43xx_crc8(crc, sprom[word] & 0x00FF);
-		crc = bcm43xx_crc8(crc, (sprom[word] & 0xFF00) >> 8);
-	}
-	crc = bcm43xx_crc8(crc, sprom[BCM43xx_SPROM_VERSION] & 0x00FF);
-	crc ^= 0xFF;
-
-	return crc;
-}
-
-int bcm43xx_sprom_read(struct bcm43xx_private *bcm, u16 *sprom)
-{
-	int i;
-	u8 crc, expected_crc;
-
-	for (i = 0; i < BCM43xx_SPROM_SIZE; i++)
-		sprom[i] = bcm43xx_read16(bcm, BCM43xx_SPROM_BASE + (i * 2));
-	/* CRC-8 check. */
-	crc = bcm43xx_sprom_crc(sprom);
-	expected_crc = (sprom[BCM43xx_SPROM_VERSION] & 0xFF00) >> 8;
-	if (crc != expected_crc) {
-		printk(KERN_WARNING PFX "WARNING: Invalid SPROM checksum "
-					"(0x%02X, expected: 0x%02X)\n",
-		       crc, expected_crc);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-int bcm43xx_sprom_write(struct bcm43xx_private *bcm, const u16 *sprom)
-{
-	int i, err;
-	u8 crc, expected_crc;
-	u32 spromctl;
-
-	/* CRC-8 validation of the input data. */
-	crc = bcm43xx_sprom_crc(sprom);
-	expected_crc = (sprom[BCM43xx_SPROM_VERSION] & 0xFF00) >> 8;
-	if (crc != expected_crc) {
-		printk(KERN_ERR PFX "SPROM input data: Invalid CRC\n");
-		return -EINVAL;
-	}
-
-	printk(KERN_INFO PFX "Writing SPROM. Do NOT turn off the power! Please stand by...\n");
-	err = bcm43xx_pci_read_config32(bcm, BCM43xx_PCICFG_SPROMCTL, &spromctl);
-	if (err)
-		goto err_ctlreg;
-	spromctl |= 0x10; /* SPROM WRITE enable. */
-	err = bcm43xx_pci_write_config32(bcm, BCM43xx_PCICFG_SPROMCTL, spromctl);
-	if (err)
-		goto err_ctlreg;
-	/* We must burn lots of CPU cycles here, but that does not
-	 * really matter as one does not write the SPROM every other minute...
-	 */
-	printk(KERN_INFO PFX "[ 0%%");
-	mdelay(500);
-	for (i = 0; i < BCM43xx_SPROM_SIZE; i++) {
-		if (i == 16)
-			printk("25%%");
-		else if (i == 32)
-			printk("50%%");
-		else if (i == 48)
-			printk("75%%");
-		else if (i % 2)
-			printk(".");
-		bcm43xx_write16(bcm, BCM43xx_SPROM_BASE + (i * 2), sprom[i]);
-		mmiowb();
-		mdelay(20);
-	}
-	spromctl &= ~0x10; /* SPROM WRITE enable. */
-	err = bcm43xx_pci_write_config32(bcm, BCM43xx_PCICFG_SPROMCTL, spromctl);
-	if (err)
-		goto err_ctlreg;
-	mdelay(500);
-	printk("100%% ]\n");
-	printk(KERN_INFO PFX "SPROM written.\n");
-	bcm43xx_controller_restart(bcm, "SPROM update");
-
-	return 0;
-err_ctlreg:
-	printk(KERN_ERR PFX "Could not access SPROM control register.\n");
-	return -ENODEV;
-}
-
-static int bcm43xx_sprom_extract(struct bcm43xx_private *bcm)
-{
-	u16 value;
-	u16 *sprom;
-
-	sprom = kzalloc(BCM43xx_SPROM_SIZE * sizeof(u16),
-			GFP_KERNEL);
-	if (!sprom) {
-		printk(KERN_ERR PFX "sprom_extract OOM\n");
-		return -ENOMEM;
-	}
-	bcm43xx_sprom_read(bcm, sprom);
-
-	/* boardflags2 */
-	value = sprom[BCM43xx_SPROM_BOARDFLAGS2];
-	bcm->sprom.boardflags2 = value;
-
-	/* il0macaddr */
-	value = sprom[BCM43xx_SPROM_IL0MACADDR + 0];
-	*(((u16 *)bcm->sprom.il0macaddr) + 0) = cpu_to_be16(value);
-	value = sprom[BCM43xx_SPROM_IL0MACADDR + 1];
-	*(((u16 *)bcm->sprom.il0macaddr) + 1) = cpu_to_be16(value);
-	value = sprom[BCM43xx_SPROM_IL0MACADDR + 2];
-	*(((u16 *)bcm->sprom.il0macaddr) + 2) = cpu_to_be16(value);
-
-	/* et0macaddr */
-	value = sprom[BCM43xx_SPROM_ET0MACADDR + 0];
-	*(((u16 *)bcm->sprom.et0macaddr) + 0) = cpu_to_be16(value);
-	value = sprom[BCM43xx_SPROM_ET0MACADDR + 1];
-	*(((u16 *)bcm->sprom.et0macaddr) + 1) = cpu_to_be16(value);
-	value = sprom[BCM43xx_SPROM_ET0MACADDR + 2];
-	*(((u16 *)bcm->sprom.et0macaddr) + 2) = cpu_to_be16(value);
-
-	/* et1macaddr */
-	value = sprom[BCM43xx_SPROM_ET1MACADDR + 0];
-	*(((u16 *)bcm->sprom.et1macaddr) + 0) = cpu_to_be16(value);
-	value = sprom[BCM43xx_SPROM_ET1MACADDR + 1];
-	*(((u16 *)bcm->sprom.et1macaddr) + 1) = cpu_to_be16(value);
-	value = sprom[BCM43xx_SPROM_ET1MACADDR + 2];
-	*(((u16 *)bcm->sprom.et1macaddr) + 2) = cpu_to_be16(value);
-
-	/* ethernet phy settings */
-	value = sprom[BCM43xx_SPROM_ETHPHY];
-	bcm->sprom.et0phyaddr = (value & 0x001F);
-	bcm->sprom.et1phyaddr = (value & 0x03E0) >> 5;
-
-	/* boardrev, antennas, locale */
-	value = sprom[BCM43xx_SPROM_BOARDREV];
-	bcm->sprom.boardrev = (value & 0x00FF);
-	bcm->sprom.locale = (value & 0x0F00) >> 8;
-	bcm->sprom.antennas_aphy = (value & 0x3000) >> 12;
-	bcm->sprom.antennas_bgphy = (value & 0xC000) >> 14;
-	if (modparam_locale != -1) {
-		if (modparam_locale >= 0 && modparam_locale <= 11) {
-			bcm->sprom.locale = modparam_locale;
-			printk(KERN_WARNING PFX "Operating with modified "
-						"LocaleCode %u (%s)\n",
-			       bcm->sprom.locale,
-			       bcm43xx_locale_string(bcm->sprom.locale));
-		} else {
-			printk(KERN_WARNING PFX "Module parameter \"locale\" "
-						"invalid value. (0 - 11)\n");
-		}
-	}
-
-	/* pa0b* */
-	value = sprom[BCM43xx_SPROM_PA0B0];
-	bcm->sprom.pa0b0 = value;
-	value = sprom[BCM43xx_SPROM_PA0B1];
-	bcm->sprom.pa0b1 = value;
-	value = sprom[BCM43xx_SPROM_PA0B2];
-	bcm->sprom.pa0b2 = value;
-
-	/* wl0gpio* */
-	value = sprom[BCM43xx_SPROM_WL0GPIO0];
-	if (value == 0x0000)
-		value = 0xFFFF;
-	bcm->sprom.wl0gpio0 = value & 0x00FF;
-	bcm->sprom.wl0gpio1 = (value & 0xFF00) >> 8;
-	value = sprom[BCM43xx_SPROM_WL0GPIO2];
-	if (value == 0x0000)
-		value = 0xFFFF;
-	bcm->sprom.wl0gpio2 = value & 0x00FF;
-	bcm->sprom.wl0gpio3 = (value & 0xFF00) >> 8;
-
-	/* maxpower */
-	value = sprom[BCM43xx_SPROM_MAXPWR];
-	bcm->sprom.maxpower_aphy = (value & 0xFF00) >> 8;
-	bcm->sprom.maxpower_bgphy = value & 0x00FF;
-
-	/* pa1b* */
-	value = sprom[BCM43xx_SPROM_PA1B0];
-	bcm->sprom.pa1b0 = value;
-	value = sprom[BCM43xx_SPROM_PA1B1];
-	bcm->sprom.pa1b1 = value;
-	value = sprom[BCM43xx_SPROM_PA1B2];
-	bcm->sprom.pa1b2 = value;
-
-	/* idle tssi target */
-	value = sprom[BCM43xx_SPROM_IDL_TSSI_TGT];
-	bcm->sprom.idle_tssi_tgt_aphy = value & 0x00FF;
-	bcm->sprom.idle_tssi_tgt_bgphy = (value & 0xFF00) >> 8;
-
-	/* boardflags */
-	value = sprom[BCM43xx_SPROM_BOARDFLAGS];
-	if (value == 0xFFFF)
-		value = 0x0000;
-	bcm->sprom.boardflags = value;
-	/* boardflags workarounds */
-	if (bcm->board_vendor == PCI_VENDOR_ID_DELL &&
-	    bcm->chip_id == 0x4301 &&
-	    bcm->board_revision == 0x74)
-		bcm->sprom.boardflags |= BCM43xx_BFL_BTCOEXIST;
-	if (bcm->board_vendor == PCI_VENDOR_ID_APPLE &&
-	    bcm->board_type == 0x4E &&
-	    bcm->board_revision > 0x40)
-		bcm->sprom.boardflags |= BCM43xx_BFL_PACTRL;
-
-	/* antenna gain */
-	value = sprom[BCM43xx_SPROM_ANTENNA_GAIN];
-	if (value == 0x0000 || value == 0xFFFF)
-		value = 0x0202;
-	/* convert values to Q5.2 */
-	bcm->sprom.antennagain_aphy = ((value & 0xFF00) >> 8) * 4;
-	bcm->sprom.antennagain_bgphy = (value & 0x00FF) * 4;
-
-	kfree(sprom);
-
-	return 0;
-}
-
-static int bcm43xx_geo_init(struct bcm43xx_private *bcm)
+static void bcm43xx_synchronize_irq(struct bcm43xx_wldev *dev)
 {
-	struct ieee80211_geo *geo;
-	struct ieee80211_channel *chan;
-	int have_a = 0, have_bg = 0;
-	int i;
-	u8 channel;
-	struct bcm43xx_phyinfo *phy;
-	const char *iso_country;
-	u8 max_bg_channel;
-
-	geo = kzalloc(sizeof(*geo), GFP_KERNEL);
-	if (!geo)
-		return -ENOMEM;
-
-	for (i = 0; i < bcm->nr_80211_available; i++) {
-		phy = &(bcm->core_80211_ext[i].phy);
-		switch (phy->type) {
-		case BCM43xx_PHYTYPE_B:
-		case BCM43xx_PHYTYPE_G:
-			have_bg = 1;
-			break;
-		case BCM43xx_PHYTYPE_A:
-			have_a = 1;
-			break;
-		default:
-			assert(0);
-		}
-	}
-	iso_country = bcm43xx_locale_iso(bcm->sprom.locale);
-
-/* set the maximum channel based on locale set in sprom or witle locale option */
-	switch (bcm->sprom.locale) {
-	case BCM43xx_LOCALE_THAILAND:
-	case BCM43xx_LOCALE_ISRAEL:
-	case BCM43xx_LOCALE_JORDAN:
-	case BCM43xx_LOCALE_USA_CANADA_ANZ:
-	case BCM43xx_LOCALE_USA_LOW:
-		max_bg_channel = 11;
-		break;
-	case BCM43xx_LOCALE_JAPAN:
-	case BCM43xx_LOCALE_JAPAN_HIGH:
-		max_bg_channel = 14;
-		break;
-	default:
-		max_bg_channel = 13;
-	}
-
- 	if (have_a) {
-		for (i = 0, channel = IEEE80211_52GHZ_MIN_CHANNEL;
-		      channel <= IEEE80211_52GHZ_MAX_CHANNEL; channel++) {
-			chan = &geo->a[i++];
-			chan->freq = bcm43xx_channel_to_freq_a(channel);
-			chan->channel = channel;
-		}
-		geo->a_channels = i;
-	}
-	if (have_bg) {
-		for (i = 0, channel = IEEE80211_24GHZ_MIN_CHANNEL;
-		      channel <= max_bg_channel; channel++) {
-			chan = &geo->bg[i++];
-			chan->freq = bcm43xx_channel_to_freq_bg(channel);
-			chan->channel = channel;
-		}
-		geo->bg_channels = i;
-	}
-	memcpy(geo->name, iso_country, 2);
-	if (0 /*TODO: Outdoor use only */)
-		geo->name[2] = 'O';
-	else if (0 /*TODO: Indoor use only */)
-		geo->name[2] = 'I';
-	else
-		geo->name[2] = ' ';
-	geo->name[3] = '\0';
-
-	ieee80211_set_geo(bcm->ieee, geo);
-	kfree(geo);
-
-	return 0;
+	synchronize_irq(dev->dev->irq);
+	tasklet_kill(&dev->isr_tasklet);
 }
 
-/* DummyTransmission function, as documented on 
+/* DummyTransmission function, as documented on
  * http://bcm-specs.sipsolutions.net/DummyTransmission
  */
-void bcm43xx_dummy_transmission(struct bcm43xx_private *bcm)
+void bcm43xx_dummy_transmission(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
+	struct bcm43xx_phy *phy = &dev->phy;
 	unsigned int i, max_loop;
-	u16 value = 0;
+	u16 value;
 	u32 buffer[5] = {
 		0x00000000,
-		0x0000D400,
+		0x00D40000,
 		0x00000000,
-		0x00000001,
+		0x01000000,
 		0x00000000,
 	};
 
 	switch (phy->type) {
-	case BCM43xx_PHYTYPE_A:
-		max_loop = 0x1E;
-		buffer[0] = 0xCC010200;
-		break;
 	case BCM43xx_PHYTYPE_B:
 	case BCM43xx_PHYTYPE_G:
 		max_loop = 0xFA;
-		buffer[0] = 0x6E840B00; 
+		buffer[0] = 0x000B846E;
 		break;
 	default:
-		assert(0);
+		BCM43xx_BUG_ON(1);
 		return;
 	}
 
 	for (i = 0; i < 5; i++)
-		bcm43xx_ram_write(bcm, i * 4, buffer[i]);
+		bcm43xx_ram_write(dev, i * 4, buffer[i]);
 
-	bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD); /* dummy read */
+	bcm43xx_read32(dev, BCM43xx_MMIO_STATUS_BITFIELD); /* dummy read */
 
-	bcm43xx_write16(bcm, 0x0568, 0x0000);
-	bcm43xx_write16(bcm, 0x07C0, 0x0000);
-	bcm43xx_write16(bcm, 0x050C, ((phy->type == BCM43xx_PHYTYPE_A) ? 1 : 0));
-	bcm43xx_write16(bcm, 0x0508, 0x0000);
-	bcm43xx_write16(bcm, 0x050A, 0x0000);
-	bcm43xx_write16(bcm, 0x054C, 0x0000);
-	bcm43xx_write16(bcm, 0x056A, 0x0014);
-	bcm43xx_write16(bcm, 0x0568, 0x0826);
-	bcm43xx_write16(bcm, 0x0500, 0x0000);
-	bcm43xx_write16(bcm, 0x0502, 0x0030);
+	bcm43xx_write16(dev, 0x0568, 0x0000);
+	bcm43xx_write16(dev, 0x07C0, 0x0000);
+	bcm43xx_write16(dev, 0x050C, 0x0000);
+	bcm43xx_write16(dev, 0x0508, 0x0000);
+	bcm43xx_write16(dev, 0x050A, 0x0000);
+	bcm43xx_write16(dev, 0x054C, 0x0000);
+	bcm43xx_write16(dev, 0x056A, 0x0014);
+	bcm43xx_write16(dev, 0x0568, 0x0826);
+	bcm43xx_write16(dev, 0x0500, 0x0000);
+	bcm43xx_write16(dev, 0x0502, 0x0030);
 
-	if (radio->version == 0x2050 && radio->revision <= 0x5)
-		bcm43xx_radio_write16(bcm, 0x0051, 0x0017);
+	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
+		bcm43xx_radio_write16(dev, 0x0051, 0x0017);
 	for (i = 0x00; i < max_loop; i++) {
-		value = bcm43xx_read16(bcm, 0x050E);
+		value = bcm43xx_read16(dev, 0x050E);
 		if (value & 0x0080)
 			break;
 		udelay(10);
 	}
 	for (i = 0x00; i < 0x0A; i++) {
-		value = bcm43xx_read16(bcm, 0x050E);
+		value = bcm43xx_read16(dev, 0x050E);
 		if (value & 0x0400)
 			break;
 		udelay(10);
 	}
 	for (i = 0x00; i < 0x0A; i++) {
-		value = bcm43xx_read16(bcm, 0x0690);
+		value = bcm43xx_read16(dev, 0x0690);
 		if (!(value & 0x0100))
 			break;
 		udelay(10);
 	}
-	if (radio->version == 0x2050 && radio->revision <= 0x5)
-		bcm43xx_radio_write16(bcm, 0x0051, 0x0037);
+	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
+		bcm43xx_radio_write16(dev, 0x0051, 0x0037);
 }
 
-static void key_write(struct bcm43xx_private *bcm,
-		      u8 index, u8 algorithm, const u16 *key)
+static void key_write(struct bcm43xx_wldev *dev,
+		      u8 index, u8 algorithm, const u8 *key)
 {
-	unsigned int i, basic_wep = 0;
+	unsigned int i;
 	u32 offset;
 	u16 value;
- 
-	/* Write associated key information */
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x100 + (index * 2),
-			    ((index << 4) | (algorithm & 0x0F)));
- 
-	/* The first 4 WEP keys need extra love */
-	if (((algorithm == BCM43xx_SEC_ALGO_WEP) ||
-	    (algorithm == BCM43xx_SEC_ALGO_WEP104)) && (index < 4))
-		basic_wep = 1;
- 
-	/* Write key payload, 8 little endian words */
-	offset = bcm->security_offset + (index * BCM43xx_SEC_KEYSIZE);
-	for (i = 0; i < (BCM43xx_SEC_KEYSIZE / sizeof(u16)); i++) {
-		value = cpu_to_le16(key[i]);
-		bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED,
-				    offset + (i * 2), value);
- 
-		if (!basic_wep)
-			continue;
- 
-		bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED,
-				    offset + (i * 2) + 4 * BCM43xx_SEC_KEYSIZE,
-				    value);
+	u16 kidx;
+
+	/* Key index/algo block */
+	kidx = bcm43xx_kidx_to_fw(dev, index);
+	value = ((kidx << 4) | algorithm);
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
+			    BCM43xx_SHM_SH_KEYIDXBLOCK +
+			    (kidx * 2), value);
+
+	/* Write the key to the Key Table Pointer offset */
+	offset = dev->ktp + (index * BCM43xx_SEC_KEYSIZE);
+	for (i = 0; i < BCM43xx_SEC_KEYSIZE; i += 2) {
+		value = key[i];
+		value |= (u16)(key[i + 1]) << 8;
+		bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
+				    offset + i, value);
 	}
 }
 
-static void keymac_write(struct bcm43xx_private *bcm,
-			 u8 index, const u32 *addr)
+static void keymac_write(struct bcm43xx_wldev *dev,
+			 u8 index, const u8 *addr)
 {
 	/* for keys 0-3 there is no associated mac address */
 	if (index < 4)
 		return;
 
 	index -= 4;
-	if (bcm->current_core->rev >= 5) {
-		bcm43xx_shm_write32(bcm,
-				    BCM43xx_SHM_HWMAC,
+	if (dev->dev->id.revision >= 5) {
+		bcm43xx_shm_write32(dev,
+				    BCM43xx_SHM_HW,
 				    index * 2,
 				    cpu_to_be32(*addr));
-		bcm43xx_shm_write16(bcm,
-				    BCM43xx_SHM_HWMAC,
+		bcm43xx_shm_write16(dev,
+				    BCM43xx_SHM_HW,
 				    (index * 2) + 1,
 				    cpu_to_be16(*((u16 *)(addr + 1))));
 	} else {
-		if (index < 8) {
-			TODO(); /* Put them in the macaddress filter */
+		if (index < 4) {
+			bcm43xx_macfilter_set(dev, BCM43xx_MACFILTER_MAC +
+					      index * 3, addr);
 		} else {
-			TODO();
 			/* Put them BCM43xx_SHM_SHARED, stating index 0x0120.
-			   Keep in mind to update the count of keymacs in 0x003E as well! */
+			   Update the count of keymacs in 0x003E as well */
+			bcm43xx_shm_write32(dev,
+					    BCM43xx_SHM_SHARED,
+					    (index - 4) * 6 + 0x120,
+					    cpu_to_be32(*addr));
+			bcm43xx_shm_write16(dev,
+					    BCM43xx_SHM_SHARED,
+					    (index - 4) * 6 + 0x124,
+					    cpu_to_be16(*((u16 *)(addr + 1))));
+			bcm43xx_shm_write32(dev,	/* update count */
+					    BCM43xx_SHM_SHARED, 0x003E,
+					    bcm43xx_shm_read32(dev,
+					    BCM43xx_SHM_SHARED, 0x003E) + 1);
 		}
 	}
 }
 
-static int bcm43xx_key_write(struct bcm43xx_private *bcm,
-			     u8 index, u8 algorithm,
-			     const u8 *_key, int key_len,
-			     const u8 *mac_addr)
+static void do_key_write(struct bcm43xx_wldev *dev,
+			 u8 index, u8 algorithm,
+			 const u8 *key, size_t key_len,
+			 const u8 *mac_addr)
+{
+	u8 buf[BCM43xx_SEC_KEYSIZE];
+
+	BCM43xx_WARN_ON(index >= dev->max_nr_keys);
+	BCM43xx_WARN_ON(key_len > BCM43xx_SEC_KEYSIZE);
+
+	memset(buf, 0, sizeof(buf));
+	if (index >= 8)
+		keymac_write(dev, index, buf); /* First zero out mac. */
+	memcpy(buf, key, key_len);
+	key_write(dev, index, algorithm, buf);
+	if (index >= 8)
+		keymac_write(dev, index, mac_addr);
+
+	dev->key[index].algorithm = algorithm;
+}
+
+static int bcm43xx_key_write(struct bcm43xx_wldev *dev,
+			     int index, u8 algorithm,
+			     const u8 *key, size_t key_len,
+			     const u8 *mac_addr,
+			     struct ieee80211_key_conf *keyconf)
 {
-	u8 key[BCM43xx_SEC_KEYSIZE] = { 0 };
+	int i;
+	int sta_keys_start;
 
-	if (index >= ARRAY_SIZE(bcm->key))
-		return -EINVAL;
-	if (key_len > ARRAY_SIZE(key))
-		return -EINVAL;
-	if (algorithm < 1 || algorithm > 5)
+	if (key_len > BCM43xx_SEC_KEYSIZE)
 		return -EINVAL;
+	if (index < 0) {
+		/* Per station key with associated MAC address.
+		 * Look if it already exists, if yes update, otherwise
+		 * allocate a new key.
+		 */
+		if (bcm43xx_new_kidx_api(dev))
+			sta_keys_start = 4;
+		else
+			sta_keys_start = 8;
+		for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
+			if (compare_ether_addr(dev->key[i].address, mac_addr)
+			     == 0) {
+				/* found existing */
+				index = i;
+				break;
+			}
+		}
+		if (index < 0) {
+			for (i = sta_keys_start; i < dev->max_nr_keys; i++) {
+				if (!dev->key[i].enabled) {
+					/* found empty */
+					index = i;
+					break;
+				}
+			}
+		}
+		if (index < 0) {
+			bcmerr(dev->wl, "Out of hardware key memory\n");
+			return -ENOBUFS;
+		}
+	} else {
+		BCM43xx_WARN_ON(index > 3);
+	}
 
-	memcpy(key, _key, key_len);
-	key_write(bcm, index, algorithm, (const u16 *)key);
-	keymac_write(bcm, index, (const u32 *)mac_addr);
-
-	bcm->key[index].algorithm = algorithm;
+	do_key_write(dev, index, algorithm, key, key_len, mac_addr);
+	if ((index <= 3) && !bcm43xx_new_kidx_api(dev)) {
+		/* Default RX key */
+		BCM43xx_WARN_ON(mac_addr != NULL);
+		do_key_write(dev, index + 4, algorithm, key, key_len, NULL);
+	}
+	keyconf->hw_key_idx = index;
 
 	return 0;
 }
 
-static void bcm43xx_clear_keys(struct bcm43xx_private *bcm)
+static void bcm43xx_clear_keys(struct bcm43xx_wldev *dev)
 {
-	static const u32 zero_mac[2] = { 0 };
-	unsigned int i,j, nr_keys = 54;
-	u16 offset;
+	static const u8 zero[BCM43xx_SEC_KEYSIZE] = { 0 };
+	unsigned int i;
 
-	if (bcm->current_core->rev < 5)
-		nr_keys = 16;
-	assert(nr_keys <= ARRAY_SIZE(bcm->key));
-
-	for (i = 0; i < nr_keys; i++) {
-		bcm->key[i].enabled = 0;
-		/* returns for i < 4 immediately */
-		keymac_write(bcm, i, zero_mac);
-		bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED,
-				    0x100 + (i * 2), 0x0000);
-		for (j = 0; j < 8; j++) {
-			offset = bcm->security_offset + (j * 4) + (i * BCM43xx_SEC_KEYSIZE);
-			bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED,
-					    offset, 0x0000);
-		}
+	BUILD_BUG_ON(BCM43xx_SEC_KEYSIZE < ETH_ALEN);
+	for (i = 0; i < dev->max_nr_keys; i++) {
+		do_key_write(dev, i, BCM43xx_SEC_ALGO_NONE,
+			     zero, BCM43xx_SEC_KEYSIZE,
+			     zero);
+		dev->key[i].enabled = 0;
 	}
-	dprintk(KERN_INFO PFX "Keys cleared\n");
 }
 
-/* Lowlevel core-switch function. This is only to be used in
- * bcm43xx_switch_core() and bcm43xx_probe_cores()
- */
-static int _switch_core(struct bcm43xx_private *bcm, int core)
+/* Turn the Analog ON/OFF */
+static void bcm43xx_switch_analog(struct bcm43xx_wldev *dev, int on)
 {
-	int err;
-	int attempts = 0;
-	u32 current_core;
+	bcm43xx_write16(dev, BCM43xx_MMIO_PHY0, on ? 0 : 0xF4);
+}
 
-	assert(core >= 0);
-	while (1) {
-		err = bcm43xx_pci_write_config32(bcm, BCM43xx_PCICFG_ACTIVE_CORE,
-						 (core * 0x1000) + 0x18000000);
-		if (unlikely(err))
-			goto error;
-		err = bcm43xx_pci_read_config32(bcm, BCM43xx_PCICFG_ACTIVE_CORE,
-						&current_core);
-		if (unlikely(err))
-			goto error;
-		current_core = (current_core - 0x18000000) / 0x1000;
-		if (current_core == core)
-			break;
+void bcm43xx_wireless_core_reset(struct bcm43xx_wldev *dev, u32 flags)
+{
+	u32 tmslow;
+	u32 macctl;
 
-		if (unlikely(attempts++ > BCM43xx_SWITCH_CORE_MAX_RETRIES))
-			goto error;
-		udelay(10);
-	}
+	flags |= BCM43xx_TMSLOW_PHYCLKEN;
+	flags |= BCM43xx_TMSLOW_PHYRESET;
+	ssb_device_enable(dev->dev, flags);
+	msleep(2); /* Wait for the PLL to turn on. */
 
-	return 0;
-error:
-	printk(KERN_ERR PFX "Failed to switch to core %d\n", core);
-	return -ENODEV;
+	/* Now take the PHY out of Reset again */
+	tmslow = ssb_read32(dev->dev, SSB_TMSLOW);
+	tmslow |= SSB_TMSLOW_FGC;
+	tmslow &= ~BCM43xx_TMSLOW_PHYRESET;
+	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
+	ssb_read32(dev->dev, SSB_TMSLOW); /* flush */
+	msleep(1);
+	tmslow &= ~SSB_TMSLOW_FGC;
+	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
+	ssb_read32(dev->dev, SSB_TMSLOW); /* flush */
+	msleep(1);
+
+	/* Turn Analog ON */
+	bcm43xx_switch_analog(dev, 1);
+
+	macctl = bcm43xx_read32(dev, BCM43xx_MMIO_MACCTL);
+	macctl &= ~BCM43xx_MACCTL_GMODE;
+	if (flags & BCM43xx_TMSLOW_GMODE)
+		macctl |= BCM43xx_MACCTL_GMODE;
+	macctl |= BCM43xx_MACCTL_IHR_ENABLED;
+	bcm43xx_write32(dev, BCM43xx_MMIO_MACCTL, macctl);
 }
 
-int bcm43xx_switch_core(struct bcm43xx_private *bcm, struct bcm43xx_coreinfo *new_core)
+static void handle_irq_transmit_status(struct bcm43xx_wldev *dev)
 {
-	int err;
+	u32 v0;
+	u32 v1;
+	u16 tmp;
+	struct bcm43xx_txstatus stat;
 
-	if (unlikely(!new_core))
-		return 0;
-	if (!new_core->available)
-		return -ENODEV;
-	if (bcm->current_core == new_core)
-		return 0;
-	err = _switch_core(bcm, new_core->index);
-	if (unlikely(err))
-		goto out;
+	while (1) {
+		v0 = bcm43xx_read32(dev, BCM43xx_MMIO_XMITSTAT_0);
+		if (!(v0 & 0x00000001))
+			break;
+		v1 = bcm43xx_read32(dev, BCM43xx_MMIO_XMITSTAT_1);
 
-	bcm->current_core = new_core;
-out:
-	return err;
+		stat.cookie = (v0 >> 16);
+		stat.seq = (v1 & 0x0000FFFF);
+		stat.phy_stat = ((v1 & 0x00FF0000) >> 16);
+		tmp = (v0 & 0x0000FFFF);
+		stat.frame_count = ((tmp & 0xF000) >> 12);
+		stat.rts_count = ((tmp & 0x0F00) >> 8);
+		stat.supp_reason = ((tmp & 0x001C) >> 2);
+		stat.pm_indicated = !!(tmp & 0x0080);
+		stat.intermediate = !!(tmp & 0x0040);
+		stat.for_ampdu = !!(tmp & 0x0020);
+		stat.acked = !!(tmp & 0x0002);
+
+		bcm43xx_handle_txstatus(dev, &stat);
+	}
 }
 
-static int bcm43xx_core_enabled(struct bcm43xx_private *bcm)
+static void drain_txstatus_queue(struct bcm43xx_wldev *dev)
 {
-	u32 value;
-
-	value = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-	value &= BCM43xx_SBTMSTATELOW_CLOCK | BCM43xx_SBTMSTATELOW_RESET
-		 | BCM43xx_SBTMSTATELOW_REJECT;
+	u32 dummy;
 
-	return (value == BCM43xx_SBTMSTATELOW_CLOCK);
+	if (dev->dev->id.revision < 5)
+		return;
+	/* Read all entries from the microcode TXstatus FIFO
+	 * and throw them away.
+	 */
+	while (1) {
+		dummy = bcm43xx_read32(dev, BCM43xx_MMIO_XMITSTAT_0);
+		if (!(dummy & 0x00000001))
+			break;
+		dummy = bcm43xx_read32(dev, BCM43xx_MMIO_XMITSTAT_1);
+	}
 }
 
-/* disable current core */
-static int bcm43xx_core_disable(struct bcm43xx_private *bcm, u32 core_flags)
+static u32 bcm43xx_jssi_read(struct bcm43xx_wldev *dev)
 {
-	u32 sbtmstatelow;
-	u32 sbtmstatehigh;
-	int i;
-
-	/* fetch sbtmstatelow from core information registers */
-	sbtmstatelow = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-
-	/* core is already in reset */
-	if (sbtmstatelow & BCM43xx_SBTMSTATELOW_RESET)
-		goto out;
-
-	if (sbtmstatelow & BCM43xx_SBTMSTATELOW_CLOCK) {
-		sbtmstatelow = BCM43xx_SBTMSTATELOW_CLOCK |
-			       BCM43xx_SBTMSTATELOW_REJECT;
-		bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, sbtmstatelow);
-
-		for (i = 0; i < 1000; i++) {
-			sbtmstatelow = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-			if (sbtmstatelow & BCM43xx_SBTMSTATELOW_REJECT) {
-				i = -1;
-				break;
-			}
-			udelay(10);
-		}
-		if (i != -1) {
-			printk(KERN_ERR PFX "Error: core_disable() REJECT timeout!\n");
-			return -EBUSY;
-		}
-
-		for (i = 0; i < 1000; i++) {
-			sbtmstatehigh = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATEHIGH);
-			if (!(sbtmstatehigh & BCM43xx_SBTMSTATEHIGH_BUSY)) {
-				i = -1;
-				break;
-			}
-			udelay(10);
-		}
-		if (i != -1) {
-			printk(KERN_ERR PFX "Error: core_disable() BUSY timeout!\n");
-			return -EBUSY;
-		}
-
-		sbtmstatelow = BCM43xx_SBTMSTATELOW_FORCE_GATE_CLOCK |
-			       BCM43xx_SBTMSTATELOW_REJECT |
-			       BCM43xx_SBTMSTATELOW_RESET |
-			       BCM43xx_SBTMSTATELOW_CLOCK |
-			       core_flags;
-		bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, sbtmstatelow);
-		udelay(10);
-	}
-
-	sbtmstatelow = BCM43xx_SBTMSTATELOW_RESET |
-		       BCM43xx_SBTMSTATELOW_REJECT |
-		       core_flags;
-	bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, sbtmstatelow);
-
-out:
-	bcm->current_core->enabled = 0;
-
-	return 0;
-}
-
-/* enable (reset) current core */
-static int bcm43xx_core_enable(struct bcm43xx_private *bcm, u32 core_flags)
-{
-	u32 sbtmstatelow;
-	u32 sbtmstatehigh;
-	u32 sbimstate;
-	int err;
-
-	err = bcm43xx_core_disable(bcm, core_flags);
-	if (err)
-		goto out;
-
-	sbtmstatelow = BCM43xx_SBTMSTATELOW_CLOCK |
-		       BCM43xx_SBTMSTATELOW_RESET |
-		       BCM43xx_SBTMSTATELOW_FORCE_GATE_CLOCK |
-		       core_flags;
-	bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, sbtmstatelow);
-	udelay(1);
-
-	sbtmstatehigh = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATEHIGH);
-	if (sbtmstatehigh & BCM43xx_SBTMSTATEHIGH_SERROR) {
-		sbtmstatehigh = 0x00000000;
-		bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATEHIGH, sbtmstatehigh);
-	}
-
-	sbimstate = bcm43xx_read32(bcm, BCM43xx_CIR_SBIMSTATE);
-	if (sbimstate & (BCM43xx_SBIMSTATE_IB_ERROR | BCM43xx_SBIMSTATE_TIMEOUT)) {
-		sbimstate &= ~(BCM43xx_SBIMSTATE_IB_ERROR | BCM43xx_SBIMSTATE_TIMEOUT);
-		bcm43xx_write32(bcm, BCM43xx_CIR_SBIMSTATE, sbimstate);
-	}
-
-	sbtmstatelow = BCM43xx_SBTMSTATELOW_CLOCK |
-		       BCM43xx_SBTMSTATELOW_FORCE_GATE_CLOCK |
-		       core_flags;
-	bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, sbtmstatelow);
-	udelay(1);
-
-	sbtmstatelow = BCM43xx_SBTMSTATELOW_CLOCK | core_flags;
-	bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, sbtmstatelow);
-	udelay(1);
-
-	bcm->current_core->enabled = 1;
-	assert(err == 0);
-out:
-	return err;
-}
-
-/* http://bcm-specs.sipsolutions.net/80211CoreReset */
-void bcm43xx_wireless_core_reset(struct bcm43xx_private *bcm, int connect_phy)
-{
-	u32 flags = 0x00040000;
-
-	if ((bcm43xx_core_enabled(bcm)) &&
-	    !bcm43xx_using_pio(bcm)) {
-	}
-	if (bcm43xx_status(bcm) == BCM43xx_STAT_SHUTTINGDOWN) {
-		bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD,
-		                bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD)
-				& ~(BCM43xx_SBF_MAC_ENABLED | 0x00000002));
-	} else {
-		if (connect_phy)
-			flags |= BCM43xx_SBTMSTATELOW_G_MODE_ENABLE;
-		bcm43xx_phy_connect(bcm, connect_phy);
-		bcm43xx_core_enable(bcm, flags);
-		bcm43xx_write16(bcm, 0x03E6, 0x0000);
-		bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD,
-				bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD)
-				| BCM43xx_SBF_400);
-	}
-}
-
-static void bcm43xx_wireless_core_disable(struct bcm43xx_private *bcm)
-{
-	bcm43xx_radio_turn_off(bcm);
-	bcm43xx_write16(bcm, 0x03E6, 0x00F4);
-	bcm43xx_core_disable(bcm, 0);
-}
-
-/* Mark the current 80211 core inactive. */
-static void bcm43xx_wireless_core_mark_inactive(struct bcm43xx_private *bcm)
-{
-	u32 sbtmstatelow;
-
-	bcm43xx_interrupt_disable(bcm, BCM43xx_IRQ_ALL);
-	bcm43xx_radio_turn_off(bcm);
-	sbtmstatelow = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-	sbtmstatelow &= 0xDFF5FFFF;
-	sbtmstatelow |= 0x000A0000;
-	bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, sbtmstatelow);
-	udelay(1);
-	sbtmstatelow = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-	sbtmstatelow &= 0xFFF5FFFF;
-	sbtmstatelow |= 0x00080000;
-	bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, sbtmstatelow);
-	udelay(1);
-}
+	u32 val = 0;
 
-static void handle_irq_transmit_status(struct bcm43xx_private *bcm)
-{
-	u32 v0, v1;
-	u16 tmp;
-	struct bcm43xx_xmitstatus stat;
-
-	while (1) {
-		v0 = bcm43xx_read32(bcm, BCM43xx_MMIO_XMITSTAT_0);
-		if (!v0)
-			break;
-		v1 = bcm43xx_read32(bcm, BCM43xx_MMIO_XMITSTAT_1);
-
-		stat.cookie = (v0 >> 16) & 0x0000FFFF;
-		tmp = (u16)((v0 & 0xFFF0) | ((v0 & 0xF) >> 1));
-		stat.flags = tmp & 0xFF;
-		stat.cnt1 = (tmp & 0x0F00) >> 8;
-		stat.cnt2 = (tmp & 0xF000) >> 12;
-		stat.seq = (u16)(v1 & 0xFFFF);
-		stat.unknown = (u16)((v1 >> 16) & 0xFF);
-
-		bcm43xx_debugfs_log_txstat(bcm, &stat);
-
-		if (stat.flags & BCM43xx_TXSTAT_FLAG_AMPDU)
-			continue;
-		if (stat.flags & BCM43xx_TXSTAT_FLAG_INTER)
-			continue;
+	val = bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED, 0x40A);
+	val <<= 16;
+	val |= bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED, 0x408);
 
-		if (bcm43xx_using_pio(bcm))
-			bcm43xx_pio_handle_xmitstatus(bcm, &stat);
-		else
-			bcm43xx_dma_handle_xmitstatus(bcm, &stat);
-	}
+	return val;
 }
 
-static void drain_txstatus_queue(struct bcm43xx_private *bcm)
+static void bcm43xx_jssi_write(struct bcm43xx_wldev *dev, u32 jssi)
 {
-	u32 dummy;
-
-	if (bcm->current_core->rev < 5)
-		return;
-	/* Read all entries from the microcode TXstatus FIFO
-	 * and throw them away.
-	 */
-	while (1) {
-		dummy = bcm43xx_read32(bcm, BCM43xx_MMIO_XMITSTAT_0);
-		if (!dummy)
-			break;
-		dummy = bcm43xx_read32(bcm, BCM43xx_MMIO_XMITSTAT_1);
-	}
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, 0x408,
+			    (jssi & 0x0000FFFF));
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, 0x40A,
+			    (jssi & 0xFFFF0000) >> 16);
 }
 
-static void bcm43xx_generate_noise_sample(struct bcm43xx_private *bcm)
+static void bcm43xx_generate_noise_sample(struct bcm43xx_wldev *dev)
 {
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x408, 0x7F7F);
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x40A, 0x7F7F);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS2_BITFIELD,
-			bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS2_BITFIELD) | (1 << 4));
-	assert(bcm->noisecalc.core_at_start == bcm->current_core);
-	assert(bcm->noisecalc.channel_at_start == bcm43xx_current_radio(bcm)->channel);
+	bcm43xx_jssi_write(dev, 0x7F7F7F7F);
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS2_BITFIELD,
+			bcm43xx_read32(dev, BCM43xx_MMIO_STATUS2_BITFIELD)
+			| (1 << 4));
+	BCM43xx_WARN_ON(dev->noisecalc.channel_at_start != dev->phy.channel);
 }
 
-static void bcm43xx_calculate_link_quality(struct bcm43xx_private *bcm)
+static void bcm43xx_calculate_link_quality(struct bcm43xx_wldev *dev)
 {
 	/* Top half of Link Quality calculation. */
 
-	if (bcm->noisecalc.calculation_running)
+	if (dev->noisecalc.calculation_running)
 		return;
-	bcm->noisecalc.core_at_start = bcm->current_core;
-	bcm->noisecalc.channel_at_start = bcm43xx_current_radio(bcm)->channel;
-	bcm->noisecalc.calculation_running = 1;
-	bcm->noisecalc.nr_samples = 0;
+	dev->noisecalc.channel_at_start = dev->phy.channel;
+	dev->noisecalc.calculation_running = 1;
+	dev->noisecalc.nr_samples = 0;
 
-	bcm43xx_generate_noise_sample(bcm);
+	bcm43xx_generate_noise_sample(dev);
 }
 
-static void handle_irq_noise(struct bcm43xx_private *bcm)
+static void handle_irq_noise(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
+	struct bcm43xx_phy *phy = &dev->phy;
 	u16 tmp;
 	u8 noise[4];
 	u8 i, j;
@@ -1477,45 +978,38 @@ static void handle_irq_noise(struct bcm4
 
 	/* Bottom half of Link Quality calculation. */
 
-	assert(bcm->noisecalc.calculation_running);
-	if (bcm->noisecalc.core_at_start != bcm->current_core ||
-	    bcm->noisecalc.channel_at_start != radio->channel)
+	BCM43xx_WARN_ON(!dev->noisecalc.calculation_running);
+	if (dev->noisecalc.channel_at_start != phy->channel)
 		goto drop_calculation;
-	tmp = bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED, 0x408);
-	noise[0] = (tmp & 0x00FF);
-	noise[1] = (tmp & 0xFF00) >> 8;
-	tmp = bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED, 0x40A);
-	noise[2] = (tmp & 0x00FF);
-	noise[3] = (tmp & 0xFF00) >> 8;
+	*((u32 *)noise) = cpu_to_le32(bcm43xx_jssi_read(dev));
 	if (noise[0] == 0x7F || noise[1] == 0x7F ||
 	    noise[2] == 0x7F || noise[3] == 0x7F)
 		goto generate_new;
 
 	/* Get the noise samples. */
-	assert(bcm->noisecalc.nr_samples < 8);
-	i = bcm->noisecalc.nr_samples;
-	noise[0] = limit_value(noise[0], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
-	noise[1] = limit_value(noise[1], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
-	noise[2] = limit_value(noise[2], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
-	noise[3] = limit_value(noise[3], 0, ARRAY_SIZE(radio->nrssi_lt) - 1);
-	bcm->noisecalc.samples[i][0] = radio->nrssi_lt[noise[0]];
-	bcm->noisecalc.samples[i][1] = radio->nrssi_lt[noise[1]];
-	bcm->noisecalc.samples[i][2] = radio->nrssi_lt[noise[2]];
-	bcm->noisecalc.samples[i][3] = radio->nrssi_lt[noise[3]];
-	bcm->noisecalc.nr_samples++;
-	if (bcm->noisecalc.nr_samples == 8) {
+	BCM43xx_WARN_ON(dev->noisecalc.nr_samples >= 8);
+	i = dev->noisecalc.nr_samples;
+	noise[0] = limit_value(noise[0], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	noise[1] = limit_value(noise[1], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	noise[2] = limit_value(noise[2], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	noise[3] = limit_value(noise[3], 0, ARRAY_SIZE(phy->nrssi_lt) - 1);
+	dev->noisecalc.samples[i][0] = phy->nrssi_lt[noise[0]];
+	dev->noisecalc.samples[i][1] = phy->nrssi_lt[noise[1]];
+	dev->noisecalc.samples[i][2] = phy->nrssi_lt[noise[2]];
+	dev->noisecalc.samples[i][3] = phy->nrssi_lt[noise[3]];
+	dev->noisecalc.nr_samples++;
+	if (dev->noisecalc.nr_samples == 8) {
 		/* Calculate the Link Quality by the noise samples. */
 		average = 0;
 		for (i = 0; i < 8; i++) {
 			for (j = 0; j < 4; j++)
-				average += bcm->noisecalc.samples[i][j];
+				average += dev->noisecalc.samples[i][j];
 		}
 		average /= (8 * 4);
 		average *= 125;
 		average += 64;
 		average /= 128;
-
-		tmp = bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED, 0x40C);
+		tmp = bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED, 0x40C);
 		tmp = (tmp / 128) & 0x1F;
 		if (tmp >= 8)
 			average += 2;
@@ -1526,403 +1020,575 @@ static void handle_irq_noise(struct bcm4
 		else
 			average -= 48;
 
-		bcm->stats.noise = average;
+		dev->stats.link_noise = average;
 drop_calculation:
-		bcm->noisecalc.calculation_running = 0;
+		dev->noisecalc.calculation_running = 0;
 		return;
 	}
 generate_new:
-	bcm43xx_generate_noise_sample(bcm);
+	bcm43xx_generate_noise_sample(dev);
 }
 
-static void handle_irq_ps(struct bcm43xx_private *bcm)
+static void handle_irq_tbtt_indication(struct bcm43xx_wldev *dev)
 {
-	if (bcm->ieee->iw_mode == IW_MODE_MASTER) {
-		///TODO: PS TBTT
+	if (bcm43xx_is_mode(dev->wl, IEEE80211_IF_TYPE_AP)) {
+		/* TODO: PS TBTT */
 	} else {
 		if (1/*FIXME: the last PSpoll frame was sent successfully */)
-			bcm43xx_power_saving_ctl_bits(bcm, -1, -1);
+			bcm43xx_power_saving_ctl_bits(dev, -1, -1);
 	}
-	if (bcm->ieee->iw_mode == IW_MODE_ADHOC)
-		bcm->reg124_set_0x4 = 1;
-	//FIXME else set to false?
+	dev->reg124_set_0x4 = 0;
+	if (bcm43xx_is_mode(dev->wl, IEEE80211_IF_TYPE_IBSS))
+		dev->reg124_set_0x4 = 1;
 }
 
-static void handle_irq_reg124(struct bcm43xx_private *bcm)
+static void handle_irq_atim_end(struct bcm43xx_wldev *dev)
 {
-	if (!bcm->reg124_set_0x4)
+	if (!dev->reg124_set_0x4 /*FIXME rename this variable*/)
 		return;
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS2_BITFIELD,
-			bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS2_BITFIELD)
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS2_BITFIELD,
+			bcm43xx_read32(dev, BCM43xx_MMIO_STATUS2_BITFIELD)
 			| 0x4);
-	//FIXME: reset reg124_set_0x4 to false?
 }
 
-static void handle_irq_pmq(struct bcm43xx_private *bcm)
+static void handle_irq_pmq(struct bcm43xx_wldev *dev)
 {
 	u32 tmp;
 
-	//TODO: AP mode.
+	/* TODO: AP mode. */
 
 	while (1) {
-		tmp = bcm43xx_read32(bcm, BCM43xx_MMIO_PS_STATUS);
+		tmp = bcm43xx_read32(dev, BCM43xx_MMIO_PS_STATUS);
 		if (!(tmp & 0x00000008))
 			break;
 	}
 	/* 16bit write is odd, but correct. */
-	bcm43xx_write16(bcm, BCM43xx_MMIO_PS_STATUS, 0x0002);
+	bcm43xx_write16(dev, BCM43xx_MMIO_PS_STATUS, 0x0002);
 }
 
-static void bcm43xx_generate_beacon_template(struct bcm43xx_private *bcm,
-					     u16 ram_offset, u16 shm_size_offset)
+static void bcm43xx_write_template_common(struct bcm43xx_wldev *dev,
+					  const u8 *data, u16 size,
+					  u16 ram_offset,
+					  u16 shm_size_offset, u8 rate)
 {
-	u32 value;
-	u16 size = 0;
+	u32 i;
+	u32 tmp;
+	struct bcm43xx_plcp_hdr4 plcp;
+
+	plcp.data = 0;
+	bcm43xx_generate_plcp_hdr(&plcp, size + FCS_LEN, rate);
+	bcm43xx_ram_write(dev, ram_offset, le32_to_cpu(plcp.data));
+	ram_offset += sizeof(u32);
+	/* The PLCP is 6 bytes long, but we only wrote 4 bytes, yet.
+	 * So leave the first two bytes of the next write blank.
+	 */
+	tmp = (u32)(data[0]) << 16;
+	tmp |= (u32)(data[1]) << 24;
+	bcm43xx_ram_write(dev, ram_offset, tmp);
+	ram_offset += sizeof(u32);
+	for (i = 2; i < size; i += sizeof(u32)) {
+		tmp = (u32)(data[i + 0]);
+		if (i + 1 < size)
+			tmp |= (u32)(data[i + 1]) << 8;
+		if (i + 2 < size)
+			tmp |= (u32)(data[i + 2]) << 16;
+		if (i + 3 < size)
+			tmp |= (u32)(data[i + 3]) << 24;
+		bcm43xx_ram_write(dev, ram_offset + i - 2, tmp);
+	}
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, shm_size_offset,
+			    size + sizeof(struct bcm43xx_plcp_hdr6));
+}
+
+static void bcm43xx_write_beacon_template(struct bcm43xx_wldev *dev,
+					  u16 ram_offset,
+					  u16 shm_size_offset, u8 rate)
+{
+	int len;
+	const u8 *data;
+
+	BCM43xx_WARN_ON(!dev->cached_beacon);
+	len = min((size_t)dev->cached_beacon->len,
+		  0x200 - sizeof(struct bcm43xx_plcp_hdr6));
+	data = (const u8 *)(dev->cached_beacon->data);
+	bcm43xx_write_template_common(dev, data,
+				      len, ram_offset,
+				      shm_size_offset, rate);
+}
+
+static void bcm43xx_write_probe_resp_plcp(struct bcm43xx_wldev *dev,
+					  u16 shm_offset, u16 size, u8 rate)
+{
+	struct bcm43xx_plcp_hdr4 plcp;
+	u32 tmp;
+	__le16 dur;
+
+	plcp.data = 0;
+	bcm43xx_generate_plcp_hdr(&plcp, size + FCS_LEN, rate);
+	dur = ieee80211_generic_frame_duration(dev->wl->hw,
+					       size,
+					       BCM43xx_RATE_TO_100KBPS(rate));
+	/* Write PLCP in two parts and timing for packet transfer */
+	tmp = le32_to_cpu(plcp.data);
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, shm_offset,
+			    tmp & 0xFFFF);
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, shm_offset + 2,
+			    tmp >> 16);
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, shm_offset + 6,
+			    le16_to_cpu(dur));
+}
+
+/* Instead of using custom probe response template, this function
+ * just patches custom beacon template by:
+ * 1) Changing packet type
+ * 2) Patching duration field
+ * 3) Stripping TIM
+ */
+static u8 *bcm43xx_generate_probe_resp(struct bcm43xx_wldev *dev,
+					u16 *dest_size, u8 rate)
+{
+	const u8 *src_data;
+	u8 *dest_data;
+	u16 src_size;
+	u16 elem_size;
+	u16 src_pos;
+	u16 dest_pos;
+	__le16 dur;
+	struct ieee80211_hdr *hdr;
+
+	BCM43xx_WARN_ON(!dev->cached_beacon);
+	src_size = dev->cached_beacon->len;
+	src_data = (const u8 *)dev->cached_beacon->data;
+
+	if (unlikely(src_size < 0x24)) {
+		bcmdbg(dev->wl, "bcm43xx_generate_probe_resp: "
+		       "invalid beacon\n");
+		return NULL;
+	}
+
+	dest_data = kmalloc(src_size, GFP_ATOMIC);
+	if (unlikely(!dest_data))
+		return NULL;
+
+	/* 0x24 is offset of first variable-len Information-Element
+	 * in beacon frame.
+	 */
+	memcpy(dest_data, src_data, 0x24);
+	src_pos = 0x24;
+	dest_pos = 0x24;
+	for ( ; src_pos < src_size - 2; src_pos += elem_size) {
+		elem_size = src_data[src_pos + 1] + 2;
+		if (src_data[src_pos] != 0x05) { /* TIM */
+			memcpy(dest_data + dest_pos, src_data + src_pos,
+			       elem_size);
+			dest_pos += elem_size;
+		}
+	}
+	*dest_size = dest_pos;
+	hdr = (struct ieee80211_hdr *)dest_data;
+
+	/* Set the frame control. */
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					 IEEE80211_STYPE_PROBE_RESP);
+	dur = ieee80211_generic_frame_duration(dev->wl->hw,
+					       *dest_size,
+					       BCM43xx_RATE_TO_100KBPS(rate));
+	hdr->duration_id = dur;
+
+	return dest_data;
+}
+
+static void bcm43xx_write_probe_resp_template(struct bcm43xx_wldev *dev,
+					      u16 ram_offset,
+					      u16 shm_size_offset, u8 rate)
+{
+	u8 *probe_resp_data;
+	u16 size;
+
+	BCM43xx_WARN_ON(!dev->cached_beacon);
+	size = dev->cached_beacon->len;
+	probe_resp_data = bcm43xx_generate_probe_resp(dev, &size, rate);
+	if (unlikely(!probe_resp_data))
+		return;
 
-	/* Timestamp. */
-	//FIXME: assumption: The chip sets the timestamp
-	value = 0;
-	bcm43xx_ram_write(bcm, ram_offset++, value);
-	bcm43xx_ram_write(bcm, ram_offset++, value);
-	size += 8;
+	/* Looks like PLCP headers plus packet timings are stored for
+	 * all possible basic rates
+	 */
+	bcm43xx_write_probe_resp_plcp(dev, 0x31A, size,
+				      BCM43xx_CCK_RATE_1MB);
+	bcm43xx_write_probe_resp_plcp(dev, 0x32C, size,
+				      BCM43xx_CCK_RATE_2MB);
+	bcm43xx_write_probe_resp_plcp(dev, 0x33E, size,
+				      BCM43xx_CCK_RATE_5MB);
+	bcm43xx_write_probe_resp_plcp(dev, 0x350, size,
+				      BCM43xx_CCK_RATE_11MB);
+
+	size = min((size_t)size,
+		   0x200 - sizeof(struct bcm43xx_plcp_hdr6));
+	bcm43xx_write_template_common(dev, probe_resp_data,
+				      size, ram_offset,
+				      shm_size_offset, rate);
+	kfree(probe_resp_data);
+}
+
+static int bcm43xx_refresh_cached_beacon(struct bcm43xx_wldev *dev,
+					 struct sk_buff *beacon)
+{
+	if (dev->cached_beacon)
+		kfree_skb(dev->cached_beacon);
+	dev->cached_beacon = beacon;
+
+	return 0;
+}
 
-	/* Beacon Interval / Capability Information */
-	value = 0x0000;//FIXME: Which interval?
-	value |= (1 << 0) << 16; /* ESS */
-	value |= (1 << 2) << 16; /* CF Pollable */	//FIXME?
-	value |= (1 << 3) << 16; /* CF Poll Request */	//FIXME?
-	if (!bcm->ieee->open_wep)
-		value |= (1 << 4) << 16; /* Privacy */
-	bcm43xx_ram_write(bcm, ram_offset++, value);
-	size += 4;
+static void bcm43xx_update_templates(struct bcm43xx_wldev *dev)
+{
+	u32 status;
 
-	/* SSID */
-	//TODO
+	BCM43xx_WARN_ON(!dev->cached_beacon);
 
-	/* FH Parameter Set */
-	//TODO
+	bcm43xx_write_beacon_template(dev, 0x68, 0x18,
+				      BCM43xx_CCK_RATE_1MB);
+	bcm43xx_write_beacon_template(dev, 0x468, 0x1A,
+				      BCM43xx_CCK_RATE_1MB);
+	bcm43xx_write_probe_resp_template(dev, 0x268, 0x4A,
+					  BCM43xx_CCK_RATE_11MB);
+
+	status = bcm43xx_read32(dev, BCM43xx_MMIO_STATUS2_BITFIELD);
+	status |= 0x03;
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS2_BITFIELD, status);
+}
 
-	/* DS Parameter Set */
-	//TODO
+static void bcm43xx_refresh_templates(struct bcm43xx_wldev *dev,
+				      struct sk_buff *beacon)
+{
+	int err;
 
-	/* CF Parameter Set */
-	//TODO
+	err = bcm43xx_refresh_cached_beacon(dev, beacon);
+	if (unlikely(err))
+		return;
+	bcm43xx_update_templates(dev);
+}
 
-	/* TIM */
-	//TODO
+static void bcm43xx_set_ssid(struct bcm43xx_wldev *dev,
+			     const u8 *ssid, u8 ssid_len)
+{
+	u32 tmp;
+	u16 i;
+	u16 len;
 
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, shm_size_offset, size);
+	len = min((u16)ssid_len, (u16)0x100);
+	for (i = 0; i < len; i += sizeof(u32)) {
+		tmp = (u32)(ssid[i + 0]);
+		if (i + 1 < len)
+			tmp |= (u32)(ssid[i + 1]) << 8;
+		if (i + 2 < len)
+			tmp |= (u32)(ssid[i + 2]) << 16;
+		if (i + 3 < len)
+			tmp |= (u32)(ssid[i + 3]) << 24;
+		bcm43xx_shm_write32(dev, BCM43xx_SHM_SHARED,
+				    0x380 + i, tmp);
+	}
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
+			    0x48, len);
+}
+
+static void bcm43xx_set_beacon_int(struct bcm43xx_wldev *dev, u16 beacon_int)
+{
+	bcm43xx_time_lock(dev);
+	if (dev->dev->id.revision >= 3) {
+		bcm43xx_write32(dev, 0x188, (beacon_int << 16));
+	} else {
+		bcm43xx_write16(dev, 0x606, (beacon_int >> 6));
+		bcm43xx_write16(dev, 0x610, beacon_int);
+	}
+	bcm43xx_time_unlock(dev);
 }
 
-static void handle_irq_beacon(struct bcm43xx_private *bcm)
+static void handle_irq_beacon(struct bcm43xx_wldev *dev)
 {
 	u32 status;
 
-	bcm->irq_savedstate &= ~BCM43xx_IRQ_BEACON;
-	status = bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS2_BITFIELD);
+	if (!bcm43xx_is_mode(dev->wl, IEEE80211_IF_TYPE_AP))
+		return;
+
+	dev->irq_savedstate &= ~BCM43xx_IRQ_BEACON;
+	status = bcm43xx_read32(dev, BCM43xx_MMIO_STATUS2_BITFIELD);
 
-	if ((status & 0x1) && (status & 0x2)) {
+	if (!dev->cached_beacon || ((status & 0x1) && (status & 0x2))) {
 		/* ACK beacon IRQ. */
-		bcm43xx_write32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON,
+		bcm43xx_write32(dev, BCM43xx_MMIO_GEN_IRQ_REASON,
 				BCM43xx_IRQ_BEACON);
-		bcm->irq_savedstate |= BCM43xx_IRQ_BEACON;
+		dev->irq_savedstate |= BCM43xx_IRQ_BEACON;
+		if (dev->cached_beacon)
+			kfree_skb(dev->cached_beacon);
+		dev->cached_beacon = NULL;
 		return;
 	}
 	if (!(status & 0x1)) {
-		bcm43xx_generate_beacon_template(bcm, 0x68, 0x18);
+		bcm43xx_write_beacon_template(dev, 0x68, 0x18,
+					      BCM43xx_CCK_RATE_1MB);
 		status |= 0x1;
-		bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS2_BITFIELD, status);
+		bcm43xx_write32(dev, BCM43xx_MMIO_STATUS2_BITFIELD,
+				status);
 	}
 	if (!(status & 0x2)) {
-		bcm43xx_generate_beacon_template(bcm, 0x468, 0x1A);
+		bcm43xx_write_beacon_template(dev, 0x468, 0x1A,
+					      BCM43xx_CCK_RATE_1MB);
 		status |= 0x2;
-		bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS2_BITFIELD, status);
+		bcm43xx_write32(dev, BCM43xx_MMIO_STATUS2_BITFIELD,
+				status);
 	}
 }
 
+static void handle_irq_ucode_debug(struct bcm43xx_wldev *dev)
+{
+}
+
 /* Interrupt handler bottom-half */
-static void bcm43xx_interrupt_tasklet(struct bcm43xx_private *bcm)
+static void bcm43xx_interrupt_tasklet(struct bcm43xx_wldev *dev)
 {
 	u32 reason;
-	u32 dma_reason[6];
+	u32 dma_reason[ARRAY_SIZE(dev->dma_reason)];
 	u32 merged_dma_reason = 0;
 	int i, activity = 0;
 	unsigned long flags;
 
-#ifdef CONFIG_BCM43XX_DEBUG
-	u32 _handled = 0x00000000;
-# define bcmirq_handled(irq)	do { _handled |= (irq); } while (0)
-#else
-# define bcmirq_handled(irq)	do { /* nothing */ } while (0)
-#endif /* CONFIG_BCM43XX_DEBUG*/
-
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-	reason = bcm->irq_reason;
-	for (i = 5; i >= 0; i--) {
-		dma_reason[i] = bcm->dma_reason[i];
-		merged_dma_reason |= dma_reason[i];
-	}
-
-	if (unlikely(reason & BCM43xx_IRQ_XMIT_ERROR)) {
-		/* TX error. We get this when Template Ram is written in wrong endianess
-		 * in dummy_tx(). We also get this if something is wrong with the TX header
-		 * on DMA or PIO queues.
-		 * Maybe we get this in other error conditions, too.
-		 */
-		printkl(KERN_ERR PFX "FATAL ERROR: BCM43xx_IRQ_XMIT_ERROR\n");
-		bcmirq_handled(BCM43xx_IRQ_XMIT_ERROR);
-	}
-	if (unlikely(merged_dma_reason & BCM43xx_DMAIRQ_FATALMASK)) {
-		printkl(KERN_ERR PFX "FATAL ERROR: Fatal DMA error: "
-				     "0x%08X, 0x%08X, 0x%08X, "
-				     "0x%08X, 0x%08X, 0x%08X\n",
-		        dma_reason[0], dma_reason[1],
-			dma_reason[2], dma_reason[3],
-			dma_reason[4], dma_reason[5]);
-		bcm43xx_controller_restart(bcm, "DMA error");
-		mmiowb();
-		spin_unlock_irqrestore(&bcm->irq_lock, flags);
-		return;
-	}
-	if (unlikely(merged_dma_reason & BCM43xx_DMAIRQ_NONFATALMASK)) {
-		printkl(KERN_ERR PFX "DMA error: "
-				     "0x%08X, 0x%08X, 0x%08X, "
-				     "0x%08X, 0x%08X, 0x%08X\n",
-		        dma_reason[0], dma_reason[1],
-			dma_reason[2], dma_reason[3],
-			dma_reason[4], dma_reason[5]);
-	}
-
-	if (reason & BCM43xx_IRQ_PS) {
-		handle_irq_ps(bcm);
-		bcmirq_handled(BCM43xx_IRQ_PS);
-	}
+	spin_lock_irqsave(&dev->wl->irq_lock, flags);
 
-	if (reason & BCM43xx_IRQ_REG124) {
-		handle_irq_reg124(bcm);
-		bcmirq_handled(BCM43xx_IRQ_REG124);
-	}
+	BCM43xx_WARN_ON(bcm43xx_status(dev) < BCM43xx_STAT_INITIALIZED);
 
-	if (reason & BCM43xx_IRQ_BEACON) {
-		if (bcm->ieee->iw_mode == IW_MODE_MASTER)
-			handle_irq_beacon(bcm);
-		bcmirq_handled(BCM43xx_IRQ_BEACON);
+	reason = dev->irq_reason;
+	for (i = 0; i < ARRAY_SIZE(dma_reason); i++) {
+		dma_reason[i] = dev->dma_reason[i];
+		merged_dma_reason |= dma_reason[i];
 	}
 
-	if (reason & BCM43xx_IRQ_PMQ) {
-		handle_irq_pmq(bcm);
-		bcmirq_handled(BCM43xx_IRQ_PMQ);
-	}
+	if (unlikely(reason & BCM43xx_IRQ_MAC_TXERR))
+		bcmerr(dev->wl, "MAC transmission error\n");
 
-	if (reason & BCM43xx_IRQ_SCAN) {
-		/*TODO*/
-		//bcmirq_handled(BCM43xx_IRQ_SCAN);
-	}
+	if (unlikely(reason & BCM43xx_IRQ_PHY_TXERR))
+		bcmerr(dev->wl, "PHY transmission error\n");
 
-	if (reason & BCM43xx_IRQ_NOISE) {
-		handle_irq_noise(bcm);
-		bcmirq_handled(BCM43xx_IRQ_NOISE);
-	}
+	if (unlikely(merged_dma_reason & (BCM43xx_DMAIRQ_FATALMASK |
+					  BCM43xx_DMAIRQ_NONFATALMASK))) {
+		if (merged_dma_reason & BCM43xx_DMAIRQ_FATALMASK) {
+			bcmerr(dev->wl, "Fatal DMA error: "
+			       "0x%08X, 0x%08X, 0x%08X, "
+			       "0x%08X, 0x%08X, 0x%08X\n",
+			       dma_reason[0], dma_reason[1],
+			       dma_reason[2], dma_reason[3],
+			       dma_reason[4], dma_reason[5]);
+			bcm43xx_controller_restart(dev, "DMA error");
+			mmiowb();
+			spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
+			return;
+		}
+		if (merged_dma_reason & BCM43xx_DMAIRQ_NONFATALMASK)
+			bcmerr(dev->wl, "DMA error: "
+			       "0x%08X, 0x%08X, 0x%08X, "
+			       "0x%08X, 0x%08X, 0x%08X\n",
+			       dma_reason[0], dma_reason[1],
+			       dma_reason[2], dma_reason[3],
+			       dma_reason[4], dma_reason[5]);
+	}
+
+	if (unlikely(reason & BCM43xx_IRQ_UCODE_DEBUG))
+		handle_irq_ucode_debug(dev);
+	if (reason & BCM43xx_IRQ_TBTT_INDI)
+		handle_irq_tbtt_indication(dev);
+	if (reason & BCM43xx_IRQ_ATIM_END)
+		handle_irq_atim_end(dev);
+	if (reason & BCM43xx_IRQ_BEACON)
+		handle_irq_beacon(dev);
+	if (reason & BCM43xx_IRQ_PMQ)
+		handle_irq_pmq(dev);
+	if (reason & BCM43xx_IRQ_TXFIFO_FLUSH_OK)
+		;/*TODO*/
+	if (reason & BCM43xx_IRQ_NOISESAMPLE_OK)
+		handle_irq_noise(dev);
 
 	/* Check the DMA reason registers for received data. */
 	if (dma_reason[0] & BCM43xx_DMAIRQ_RX_DONE) {
-		if (bcm43xx_using_pio(bcm))
-			bcm43xx_pio_rx(bcm43xx_current_pio(bcm)->queue0);
+		if (bcm43xx_using_pio(dev))
+			bcm43xx_pio_rx(dev->pio.queue0);
 		else
-			bcm43xx_dma_rx(bcm43xx_current_dma(bcm)->rx_ring0);
+			bcm43xx_dma_rx(dev->dma.rx_ring0);
 		/* We intentionally don't set "activity" to 1, here. */
 	}
-	assert(!(dma_reason[1] & BCM43xx_DMAIRQ_RX_DONE));
-	assert(!(dma_reason[2] & BCM43xx_DMAIRQ_RX_DONE));
+	BCM43xx_WARN_ON(dma_reason[1] & BCM43xx_DMAIRQ_RX_DONE);
+	BCM43xx_WARN_ON(dma_reason[2] & BCM43xx_DMAIRQ_RX_DONE);
 	if (dma_reason[3] & BCM43xx_DMAIRQ_RX_DONE) {
-		if (bcm43xx_using_pio(bcm))
-			bcm43xx_pio_rx(bcm43xx_current_pio(bcm)->queue3);
+		if (bcm43xx_using_pio(dev))
+			bcm43xx_pio_rx(dev->pio.queue3);
 		else
-			bcm43xx_dma_rx(bcm43xx_current_dma(bcm)->rx_ring3);
+			bcm43xx_dma_rx(dev->dma.rx_ring3);
 		activity = 1;
 	}
-	assert(!(dma_reason[4] & BCM43xx_DMAIRQ_RX_DONE));
-	assert(!(dma_reason[5] & BCM43xx_DMAIRQ_RX_DONE));
-	bcmirq_handled(BCM43xx_IRQ_RX);
+	BCM43xx_WARN_ON(dma_reason[4] & BCM43xx_DMAIRQ_RX_DONE);
+	BCM43xx_WARN_ON(dma_reason[5] & BCM43xx_DMAIRQ_RX_DONE);
 
-	if (reason & BCM43xx_IRQ_XMIT_STATUS) {
-		handle_irq_transmit_status(bcm);
+	if (reason & BCM43xx_IRQ_TX_OK) {
+		handle_irq_transmit_status(dev);
 		activity = 1;
-		//TODO: In AP mode, this also causes sending of powersave responses.
-		bcmirq_handled(BCM43xx_IRQ_XMIT_STATUS);
+		/* TODO: In AP mode, this also causes sending of powersave
+			 responses. */
 	}
 
-	/* IRQ_PIO_WORKAROUND is handled in the top-half. */
-	bcmirq_handled(BCM43xx_IRQ_PIO_WORKAROUND);
-#ifdef CONFIG_BCM43XX_DEBUG
-	if (unlikely(reason & ~_handled)) {
-		printkl(KERN_WARNING PFX
-			"Unhandled IRQ! Reason: 0x%08x,  Unhandled: 0x%08x,  "
-			"DMA: 0x%08x, 0x%08x, 0x%08x, 0x%08x\n",
-			reason, (reason & ~_handled),
-			dma_reason[0], dma_reason[1],
-			dma_reason[2], dma_reason[3]);
-	}
-#endif
-#undef bcmirq_handled
-
 	if (!modparam_noleds)
-		bcm43xx_leds_update(bcm, activity);
-	bcm43xx_interrupt_enable(bcm, bcm->irq_savedstate);
+		bcm43xx_leds_update(dev, activity);
+	bcm43xx_interrupt_enable(dev, dev->irq_savedstate);
 	mmiowb();
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
+	spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
 }
 
-static void pio_irq_workaround(struct bcm43xx_private *bcm,
+static void pio_irq_workaround(struct bcm43xx_wldev *dev,
 			       u16 base, int queueidx)
 {
 	u16 rxctl;
 
-	rxctl = bcm43xx_read16(bcm, base + BCM43xx_PIO_RXCTL);
+	rxctl = bcm43xx_read16(dev, base + BCM43xx_PIO_RXCTL);
 	if (rxctl & BCM43xx_PIO_RXCTL_DATAAVAILABLE)
-		bcm->dma_reason[queueidx] |= BCM43xx_DMAIRQ_RX_DONE;
+		dev->dma_reason[queueidx] |= BCM43xx_DMAIRQ_RX_DONE;
 	else
-		bcm->dma_reason[queueidx] &= ~BCM43xx_DMAIRQ_RX_DONE;
+		dev->dma_reason[queueidx] &= ~BCM43xx_DMAIRQ_RX_DONE;
 }
 
-static void bcm43xx_interrupt_ack(struct bcm43xx_private *bcm, u32 reason)
+static void bcm43xx_interrupt_ack(struct bcm43xx_wldev *dev, u32 reason)
 {
-	if (bcm43xx_using_pio(bcm) &&
-	    (bcm->current_core->rev < 3) &&
+	if (bcm43xx_using_pio(dev) &&
+	    (dev->dev->id.revision < 3) &&
 	    (!(reason & BCM43xx_IRQ_PIO_WORKAROUND))) {
 		/* Apply a PIO specific workaround to the dma_reasons */
-		pio_irq_workaround(bcm, BCM43xx_MMIO_PIO1_BASE, 0);
-		pio_irq_workaround(bcm, BCM43xx_MMIO_PIO2_BASE, 1);
-		pio_irq_workaround(bcm, BCM43xx_MMIO_PIO3_BASE, 2);
-		pio_irq_workaround(bcm, BCM43xx_MMIO_PIO4_BASE, 3);
-	}
-
-	bcm43xx_write32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON, reason);
-
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA0_REASON,
-			bcm->dma_reason[0]);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA1_REASON,
-			bcm->dma_reason[1]);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA2_REASON,
-			bcm->dma_reason[2]);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA3_REASON,
-			bcm->dma_reason[3]);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA4_REASON,
-			bcm->dma_reason[4]);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA5_REASON,
-			bcm->dma_reason[5]);
+		pio_irq_workaround(dev, BCM43xx_MMIO_PIO1_BASE, 0);
+		pio_irq_workaround(dev, BCM43xx_MMIO_PIO2_BASE, 1);
+		pio_irq_workaround(dev, BCM43xx_MMIO_PIO3_BASE, 2);
+		pio_irq_workaround(dev, BCM43xx_MMIO_PIO4_BASE, 3);
+	}
+
+	bcm43xx_write32(dev, BCM43xx_MMIO_GEN_IRQ_REASON, reason);
+
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA0_REASON,
+			dev->dma_reason[0]);
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA1_REASON,
+			dev->dma_reason[1]);
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA2_REASON,
+			dev->dma_reason[2]);
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA3_REASON,
+			dev->dma_reason[3]);
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA4_REASON,
+			dev->dma_reason[4]);
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA5_REASON,
+			dev->dma_reason[5]);
 }
 
 /* Interrupt handler top-half */
 static irqreturn_t bcm43xx_interrupt_handler(int irq, void *dev_id)
 {
 	irqreturn_t ret = IRQ_HANDLED;
-	struct bcm43xx_private *bcm = dev_id;
+	struct bcm43xx_wldev *dev = dev_id;
 	u32 reason;
 
-	if (!bcm)
+	if (!dev)
 		return IRQ_NONE;
 
-	spin_lock(&bcm->irq_lock);
+	spin_lock(&dev->wl->irq_lock);
 
-	reason = bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON);
-	if (reason == 0xffffffff) {
-		/* irq not for us (shared irq) */
-		ret = IRQ_NONE;
+	if (bcm43xx_status(dev) < BCM43xx_STAT_INITIALIZED)
 		goto out;
-	}
-	reason &= bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_MASK);
+	reason = bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_REASON);
+	if (reason == 0xffffffff) /* shared IRQ */
+		goto out;
+	reason &= bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_MASK);
 	if (!reason)
 		goto out;
 
-	assert(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED);
-	assert(bcm->current_core->id == BCM43xx_COREID_80211);
+	BCM43xx_WARN_ON(bcm43xx_status(dev) < BCM43xx_STAT_INITIALIZED);
 
-	bcm->dma_reason[0] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA0_REASON)
+	dev->dma_reason[0] = bcm43xx_read32(dev, BCM43xx_MMIO_DMA0_REASON)
 			     & 0x0001DC00;
-	bcm->dma_reason[1] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA1_REASON)
+	dev->dma_reason[1] = bcm43xx_read32(dev, BCM43xx_MMIO_DMA1_REASON)
 			     & 0x0000DC00;
-	bcm->dma_reason[2] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA2_REASON)
+	dev->dma_reason[2] = bcm43xx_read32(dev, BCM43xx_MMIO_DMA2_REASON)
 			     & 0x0000DC00;
-	bcm->dma_reason[3] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA3_REASON)
+	dev->dma_reason[3] = bcm43xx_read32(dev, BCM43xx_MMIO_DMA3_REASON)
 			     & 0x0001DC00;
-	bcm->dma_reason[4] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA4_REASON)
+	dev->dma_reason[4] = bcm43xx_read32(dev, BCM43xx_MMIO_DMA4_REASON)
 			     & 0x0000DC00;
-	bcm->dma_reason[5] = bcm43xx_read32(bcm, BCM43xx_MMIO_DMA5_REASON)
+	dev->dma_reason[5] = bcm43xx_read32(dev, BCM43xx_MMIO_DMA5_REASON)
 			     & 0x0000DC00;
 
-	bcm43xx_interrupt_ack(bcm, reason);
-
+	bcm43xx_interrupt_ack(dev, reason);
 	/* disable all IRQs. They are enabled again in the bottom half. */
-	bcm->irq_savedstate = bcm43xx_interrupt_disable(bcm, BCM43xx_IRQ_ALL);
+	dev->irq_savedstate = bcm43xx_interrupt_disable(dev, BCM43xx_IRQ_ALL);
 	/* save the reason code and call our bottom half. */
-	bcm->irq_reason = reason;
-	tasklet_schedule(&bcm->isr_tasklet);
-
+	dev->irq_reason = reason;
+	tasklet_schedule(&dev->isr_tasklet);
 out:
 	mmiowb();
-	spin_unlock(&bcm->irq_lock);
+	spin_unlock(&dev->wl->irq_lock);
 
 	return ret;
 }
 
-static void bcm43xx_release_firmware(struct bcm43xx_private *bcm, int force)
+static void bcm43xx_release_firmware(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-
-	if (bcm->firmware_norelease && !force)
-		return; /* Suspending or controller reset. */
-	release_firmware(phy->ucode);
-	phy->ucode = NULL;
-	release_firmware(phy->pcm);
-	phy->pcm = NULL;
-	release_firmware(phy->initvals0);
-	phy->initvals0 = NULL;
-	release_firmware(phy->initvals1);
-	phy->initvals1 = NULL;
+	release_firmware(dev->fw.ucode);
+	dev->fw.ucode = NULL;
+	release_firmware(dev->fw.pcm);
+	dev->fw.pcm = NULL;
+	release_firmware(dev->fw.initvals0);
+	dev->fw.initvals0 = NULL;
+	release_firmware(dev->fw.initvals1);
+	dev->fw.initvals1 = NULL;
 }
 
-static int bcm43xx_request_firmware(struct bcm43xx_private *bcm)
+static int bcm43xx_request_firmware(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	u8 rev = bcm->current_core->rev;
+	u8 rev = dev->dev->id.revision;
 	int err = 0;
 	int nr;
 	char buf[22 + sizeof(modparam_fwpostfix) - 1] = { 0 };
 
-	if (!phy->ucode) {
+	if (!dev->fw.ucode) {
 		snprintf(buf, ARRAY_SIZE(buf), "bcm43xx_microcode%d%s.fw",
 			 (rev >= 5 ? 5 : rev),
 			 modparam_fwpostfix);
-		err = request_firmware(&phy->ucode, buf, &bcm->pci_dev->dev);
+		err = request_firmware(&dev->fw.ucode, buf, dev->dev->dev);
 		if (err) {
-			printk(KERN_ERR PFX 
-			       "Error: Microcode \"%s\" not available or load failed.\n",
-			        buf);
-			goto error;
+			snprintf(buf, ARRAY_SIZE(buf), "bcm43xx_microcode%d.fw",
+				 (rev >= 5 ? 5 : rev));
+			err = request_firmware(&dev->fw.ucode, buf,
+					       dev->dev->dev);
+			if (err) {
+				bcmerr(dev->wl, "Microcode \"%s\" not "
+				       "available or load failed.\n", buf);
+				goto error;
+			}
 		}
+		bcminfo(dev->wl, "bcm43xx: Microcode %s loaded\n", buf);
 	}
 
-	if (!phy->pcm) {
-		snprintf(buf, ARRAY_SIZE(buf),
-			 "bcm43xx_pcm%d%s.fw",
-			 (rev < 5 ? 4 : 5),
-			 modparam_fwpostfix);
-		err = request_firmware(&phy->pcm, buf, &bcm->pci_dev->dev);
+	if (!dev->fw.pcm) {
+		snprintf(buf, ARRAY_SIZE(buf), "bcm43xx_pcm%d%s.fw",
+			 (rev < 5 ? 4 : 5), modparam_fwpostfix);
+		err = request_firmware(&dev->fw.pcm, buf, dev->dev->dev);
 		if (err) {
-			printk(KERN_ERR PFX
-			       "Error: PCM \"%s\" not available or load failed.\n",
-			       buf);
-			goto error;
+			snprintf(buf, ARRAY_SIZE(buf), "bcm43xx_pcm%d.fw",
+				 (rev < 5 ? 4 : 5));
+			err = request_firmware(&dev->fw.pcm, buf,
+					       dev->dev->dev);
+			if (err) {
+				bcmerr(dev->wl, "PCM \"%s\" not available "
+				       "or load failed.\n", buf);
+				goto error;
+			}
 		}
 	}
 
-	if (!phy->initvals0) {
+	if (!dev->fw.initvals0) {
 		if (rev == 2 || rev == 4) {
-			switch (phy->type) {
-			case BCM43xx_PHYTYPE_A:
-				nr = 3;
-				break;
+			switch (dev->phy.type) {
 			case BCM43xx_PHYTYPE_B:
 			case BCM43xx_PHYTYPE_G:
 				nr = 1;
@@ -1930,12 +1596,9 @@ static int bcm43xx_request_firmware(stru
 			default:
 				goto err_noinitval;
 			}
-		
+
 		} else if (rev >= 5) {
-			switch (phy->type) {
-			case BCM43xx_PHYTYPE_A:
-				nr = 7;
-				break;
+			switch (dev->phy.type) {
 			case BCM43xx_PHYTYPE_B:
 			case BCM43xx_PHYTYPE_G:
 				nr = 5;
@@ -1943,36 +1606,34 @@ static int bcm43xx_request_firmware(stru
 			default:
 				goto err_noinitval;
 			}
-		} else
+		} else {
 			goto err_noinitval;
+		}
 		snprintf(buf, ARRAY_SIZE(buf), "bcm43xx_initval%02d%s.fw",
 			 nr, modparam_fwpostfix);
 
-		err = request_firmware(&phy->initvals0, buf, &bcm->pci_dev->dev);
+		err = request_firmware(&dev->fw.initvals0, buf, dev->dev->dev);
 		if (err) {
-			printk(KERN_ERR PFX 
-			       "Error: InitVals \"%s\" not available or load failed.\n",
-			        buf);
-			goto error;
+			snprintf(buf, ARRAY_SIZE(buf), "bcm43xx_initval%02d.fw",
+				 nr);
+
+			err = request_firmware(&dev->fw.initvals0, buf,
+					       dev->dev->dev);
+			if (err) {
+				bcmerr(dev->wl, "InitVals \"%s\" not available "
+				       "or load failed.\n", buf);
+				goto error;
+			}
 		}
-		if (phy->initvals0->size % sizeof(struct bcm43xx_initval)) {
-			printk(KERN_ERR PFX "InitVals fileformat error.\n");
+		if (dev->fw.initvals0->size % sizeof(struct bcm43xx_initval)) {
+			bcmerr(dev->wl, "InitVals fileformat error.\n");
 			goto error;
 		}
 	}
 
-	if (!phy->initvals1) {
+	if (!dev->fw.initvals1) {
 		if (rev >= 5) {
-			u32 sbtmstatehigh;
-
-			switch (phy->type) {
-			case BCM43xx_PHYTYPE_A:
-				sbtmstatehigh = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATEHIGH);
-				if (sbtmstatehigh & 0x00010000)
-					nr = 9;
-				else
-					nr = 10;
-				break;
+			switch (dev->phy.type) {
 			case BCM43xx_PHYTYPE_B:
 			case BCM43xx_PHYTYPE_G:
 					nr = 6;
@@ -1980,18 +1641,28 @@ static int bcm43xx_request_firmware(stru
 			default:
 				goto err_noinitval;
 			}
-			snprintf(buf, ARRAY_SIZE(buf), "bcm43xx_initval%02d%s.fw",
+			snprintf(buf, ARRAY_SIZE(buf),
+				 "bcm43xx_initval%02d%s.fw",
 				 nr, modparam_fwpostfix);
 
-			err = request_firmware(&phy->initvals1, buf, &bcm->pci_dev->dev);
+			err = request_firmware(&dev->fw.initvals1, buf,
+					       dev->dev->dev);
 			if (err) {
-				printk(KERN_ERR PFX 
-				       "Error: InitVals \"%s\" not available or load failed.\n",
-			        	buf);
-				goto error;
+				snprintf(buf, ARRAY_SIZE(buf),
+					 "bcm43xx_initval%02d.fw", nr);
+
+				err = request_firmware(&dev->fw.initvals1, buf,
+						       dev->dev->dev);
+				if (err) {
+					bcmerr(dev->wl, "InitVals \"%s\" not "
+					       "available or load failed.\n",
+					       buf);
+					goto error;
+				}
 			}
-			if (phy->initvals1->size % sizeof(struct bcm43xx_initval)) {
-				printk(KERN_ERR PFX "InitVals fileformat error.\n");
+			if (dev->fw.initvals1->size
+				% sizeof(struct bcm43xx_initval)) {
+				bcmerr(dev->wl, "InitVals format error.\n");
 				goto error;
 			}
 		}
@@ -2000,44 +1671,102 @@ static int bcm43xx_request_firmware(stru
 out:
 	return err;
 error:
-	bcm43xx_release_firmware(bcm, 1);
+	bcm43xx_release_firmware(dev);
 	goto out;
 err_noinitval:
-	printk(KERN_ERR PFX "Error: No InitVals available!\n");
+	bcmerr(dev->wl, "No InitVals available\n");
 	err = -ENOENT;
 	goto error;
 }
 
-static void bcm43xx_upload_microcode(struct bcm43xx_private *bcm)
+static int bcm43xx_upload_microcode(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	const u32 *data;
-	unsigned int i, len;
+	const __be32 *data;
+	unsigned int i;
+	unsigned int len;
+	u16 fwrev;
+	u16 fwpatch;
+	u16 fwdate;
+	u16 fwtime;
+	u32 tmp;
+	int err = 0;
 
 	/* Upload Microcode. */
-	data = (u32 *)(phy->ucode->data);
-	len = phy->ucode->size / sizeof(u32);
-	bcm43xx_shm_control_word(bcm, BCM43xx_SHM_UCODE, 0x0000);
+	data = (__be32 *)(dev->fw.ucode->data);
+	len = dev->fw.ucode->size / sizeof(__be32);
+	bcm43xx_shm_control_word(dev,
+				 BCM43xx_SHM_UCODE | BCM43xx_SHM_AUTOINC_W,
+				 0x0000);
 	for (i = 0; i < len; i++) {
-		bcm43xx_write32(bcm, BCM43xx_MMIO_SHM_DATA,
+		bcm43xx_write32(dev, BCM43xx_MMIO_SHM_DATA,
 				be32_to_cpu(data[i]));
 		udelay(10);
 	}
 
 	/* Upload PCM data. */
-	data = (u32 *)(phy->pcm->data);
-	len = phy->pcm->size / sizeof(u32);
-	bcm43xx_shm_control_word(bcm, BCM43xx_SHM_PCM, 0x01ea);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_SHM_DATA, 0x00004000);
-	bcm43xx_shm_control_word(bcm, BCM43xx_SHM_PCM, 0x01eb);
+	data = (__be32 *)(dev->fw.pcm->data);
+	len = dev->fw.pcm->size / sizeof(__be32);
+	bcm43xx_shm_control_word(dev, BCM43xx_SHM_HW, 0x01EA);
+	bcm43xx_write32(dev, BCM43xx_MMIO_SHM_DATA, 0x00004000);
+	/* No need for autoinc bit in SHM_HW */
+	bcm43xx_shm_control_word(dev, BCM43xx_SHM_HW, 0x01EB);
 	for (i = 0; i < len; i++) {
-		bcm43xx_write32(bcm, BCM43xx_MMIO_SHM_DATA,
+		bcm43xx_write32(dev, BCM43xx_MMIO_SHM_DATA,
 				be32_to_cpu(data[i]));
 		udelay(10);
 	}
+
+	bcm43xx_write32(dev, BCM43xx_MMIO_GEN_IRQ_REASON, BCM43xx_IRQ_ALL);
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD, 0x00020402);
+
+	/* Wait for the microcode to load and respond */
+	i = 0;
+	while (1) {
+		tmp = bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_REASON);
+		if (tmp == BCM43xx_IRQ_MAC_SUSPENDED)
+			break;
+		i++;
+		if (i >= BCM43xx_IRQWAIT_MAX_RETRIES) {
+			bcmerr(dev->wl, "Microcode not responding\n");
+			err = -ENODEV;
+			goto out;
+		}
+		udelay(10);
+	}
+	bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_REASON); /* dummy read */
+
+	/* Get and check the revisions. */
+	fwrev = bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED,
+				   BCM43xx_SHM_SH_UCODEREV);
+	fwpatch = bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED,
+				     BCM43xx_SHM_SH_UCODEPATCH);
+	fwdate = bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED,
+				    BCM43xx_SHM_SH_UCODEDATE);
+	fwtime = bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED,
+				    BCM43xx_SHM_SH_UCODETIME);
+
+	if (fwrev > 0x128) {
+		bcmerr(dev->wl, "YOUR FIRMWARE IS TOO NEW. Only firmware "
+		       "from binary drivers version 3.x is supported. "
+		       "You must change your firmware files.\n");
+		bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD, 0);
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+	bcmdbg(dev->wl, "Loading firmware version 0x%X, patch level %u "
+			      "(20%.2i-%.2i-%.2i %.2i:%.2i:%.2i)\n",
+	       fwrev, fwpatch,
+	       (fwdate >> 12) & 0xF, (fwdate >> 8) & 0xF, fwdate & 0xFF,
+	       (fwtime >> 11) & 0x1F, (fwtime >> 5) & 0x3F, fwtime & 0x1F);
+
+	dev->fw.rev = fwrev;
+	dev->fw.patch = fwpatch;
+
+out:
+	return err;
 }
 
-static int bcm43xx_write_initvals(struct bcm43xx_private *bcm,
+static int bcm43xx_write_initvals(struct bcm43xx_wldev *dev,
 				  const struct bcm43xx_initval *data,
 				  const unsigned int len)
 {
@@ -2055,33 +1784,37 @@ static int bcm43xx_write_initvals(struct
 		if (size == 2) {
 			if (unlikely(value & 0xFFFF0000))
 				goto err_format;
-			bcm43xx_write16(bcm, offset, (u16)value);
+			bcm43xx_write16(dev, offset, (u16)value);
 		} else if (size == 4) {
-			bcm43xx_write32(bcm, offset, value);
-		} else
+			bcm43xx_write32(dev, offset, value);
+		} else {
 			goto err_format;
+		}
 	}
 
 	return 0;
 
 err_format:
-	printk(KERN_ERR PFX "InitVals (bcm43xx_initvalXX.fw) file-format error. "
-			    "Please fix your bcm43xx firmware files.\n");
+	bcmerr(dev->wl, "InitVals (bcm43xx_initvalXX.fw) file-format error. "
+	       "Please fix your bcm43xx firmware files.\n");
 	return -EPROTO;
 }
 
-static int bcm43xx_upload_initvals(struct bcm43xx_private *bcm)
+static int bcm43xx_upload_initvals(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
 	int err;
 
-	err = bcm43xx_write_initvals(bcm, (struct bcm43xx_initval *)phy->initvals0->data,
-				     phy->initvals0->size / sizeof(struct bcm43xx_initval));
+	err = bcm43xx_write_initvals(dev,
+			     (struct bcm43xx_initval *)dev->fw.initvals0->data,
+			     dev->fw.initvals0->size /
+			     sizeof(struct bcm43xx_initval));
 	if (err)
 		goto out;
-	if (phy->initvals1) {
-		err = bcm43xx_write_initvals(bcm, (struct bcm43xx_initval *)phy->initvals1->data,
-					     phy->initvals1->size / sizeof(struct bcm43xx_initval));
+	if (dev->fw.initvals1) {
+		err = bcm43xx_write_initvals(dev,
+			     (struct bcm43xx_initval *)dev->fw.initvals1->data,
+			     dev->fw.initvals1->size /
+			     sizeof(struct bcm43xx_initval));
 		if (err)
 			goto out;
 	}
@@ -2089,2180 +1822,2164 @@ out:
 	return err;
 }
 
-static int bcm43xx_initialize_irq(struct bcm43xx_private *bcm)
-{
-	int err;
-
-	bcm->irq = bcm->pci_dev->irq;
-	err = request_irq(bcm->irq, bcm43xx_interrupt_handler,
-			  IRQF_SHARED, KBUILD_MODNAME, bcm);
-	if (err)
-		printk(KERN_ERR PFX "Cannot register IRQ%d\n", bcm->irq);
-
-	return err;
-}
-
-/* Switch to the core used to write the GPIO register.
- * This is either the ChipCommon, or the PCI core.
- */
-static int switch_to_gpio_core(struct bcm43xx_private *bcm)
-{
-	int err;
-
-	/* Where to find the GPIO register depends on the chipset.
-	 * If it has a ChipCommon, its register at offset 0x6c is the GPIO
-	 * control register. Otherwise the register at offset 0x6c in the
-	 * PCI core is the GPIO control register.
-	 */
-	err = bcm43xx_switch_core(bcm, &bcm->core_chipcommon);
-	if (err == -ENODEV) {
-		err = bcm43xx_switch_core(bcm, &bcm->core_pci);
-		if (unlikely(err == -ENODEV)) {
-			printk(KERN_ERR PFX "gpio error: "
-			       "Neither ChipCommon nor PCI core available!\n");
-		}
-	}
-
-	return err;
-}
-
 /* Initialize the GPIOs
  * http://bcm-specs.sipsolutions.net/GPIO
  */
-static int bcm43xx_gpio_init(struct bcm43xx_private *bcm)
+static int bcm43xx_gpio_init(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_coreinfo *old_core;
-	int err;
+	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_device *gpiodev, *pcidev = NULL;
 	u32 mask, set;
 
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD,
-			bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD)
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD,
+			bcm43xx_read32(dev, BCM43xx_MMIO_STATUS_BITFIELD)
 			& 0xFFFF3FFF);
 
-	bcm43xx_leds_switch_all(bcm, 0);
-	bcm43xx_write16(bcm, BCM43xx_MMIO_GPIO_MASK,
-			bcm43xx_read16(bcm, BCM43xx_MMIO_GPIO_MASK) | 0x000F);
+	bcm43xx_leds_switch_all(dev, 0);
+	bcm43xx_write16(dev, BCM43xx_MMIO_GPIO_MASK,
+			bcm43xx_read16(dev, BCM43xx_MMIO_GPIO_MASK)
+			| 0x000F);
 
 	mask = 0x0000001F;
 	set = 0x0000000F;
-	if (bcm->chip_id == 0x4301) {
+	if (dev->dev->bus->chip_id == 0x4301) {
 		mask |= 0x0060;
 		set |= 0x0060;
 	}
 	if (0 /* FIXME: conditional unknown */) {
-		bcm43xx_write16(bcm, BCM43xx_MMIO_GPIO_MASK,
-				bcm43xx_read16(bcm, BCM43xx_MMIO_GPIO_MASK)
+		bcm43xx_write16(dev, BCM43xx_MMIO_GPIO_MASK,
+				bcm43xx_read16(dev, BCM43xx_MMIO_GPIO_MASK)
 				| 0x0100);
 		mask |= 0x0180;
 		set |= 0x0180;
 	}
-	if (bcm->sprom.boardflags & BCM43xx_BFL_PACTRL) {
-		bcm43xx_write16(bcm, BCM43xx_MMIO_GPIO_MASK,
-				bcm43xx_read16(bcm, BCM43xx_MMIO_GPIO_MASK)
+	if (dev->dev->bus->sprom.r1.boardflags_lo & BCM43xx_BFL_PACTRL) {
+		bcm43xx_write16(dev, BCM43xx_MMIO_GPIO_MASK,
+				bcm43xx_read16(dev, BCM43xx_MMIO_GPIO_MASK)
 				| 0x0200);
 		mask |= 0x0200;
 		set |= 0x0200;
 	}
-	if (bcm->current_core->rev >= 2)
+	if (dev->dev->id.revision >= 2)
 		mask  |= 0x0010; /* FIXME: This is redundant. */
 
-	old_core = bcm->current_core;
-	err = switch_to_gpio_core(bcm);
-	if (err)
-		goto out;
-	bcm43xx_write32(bcm, BCM43xx_GPIO_CONTROL,
-	                (bcm43xx_read32(bcm, BCM43xx_GPIO_CONTROL) & mask) | set);
-	err = bcm43xx_switch_core(bcm, old_core);
-out:
-	return err;
+#ifdef CONFIG_SSB_DRIVER_PCICORE
+	pcidev = bus->pcicore.dev;
+#endif
+	gpiodev = bus->chipco.dev ? : pcidev;
+	if (!gpiodev)
+		return 0;
+	ssb_write32(gpiodev, BCM43xx_GPIO_CONTROL,
+		    (ssb_read32(gpiodev, BCM43xx_GPIO_CONTROL)
+		     & mask) | set);
+
+	return 0;
 }
 
 /* Turn off all GPIO stuff. Call this on module unload, for example. */
-static int bcm43xx_gpio_cleanup(struct bcm43xx_private *bcm)
+static void bcm43xx_gpio_cleanup(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_coreinfo *old_core;
-	int err;
-
-	old_core = bcm->current_core;
-	err = switch_to_gpio_core(bcm);
-	if (err)
-		return err;
-	bcm43xx_write32(bcm, BCM43xx_GPIO_CONTROL, 0x00000000);
-	err = bcm43xx_switch_core(bcm, old_core);
-	assert(err == 0);
+	struct ssb_bus *bus = dev->dev->bus;
+	struct ssb_device *gpiodev, *pcidev = NULL;
 
-	return 0;
+#ifdef CONFIG_SSB_DRIVER_PCICORE
+	pcidev = bus->pcicore.dev;
+#endif
+	gpiodev = bus->chipco.dev ? : pcidev;
+	if (!gpiodev)
+		return;
+	ssb_write32(gpiodev, BCM43xx_GPIO_CONTROL, 0);
 }
 
 /* http://bcm-specs.sipsolutions.net/EnableMac */
-void bcm43xx_mac_enable(struct bcm43xx_private *bcm)
+void bcm43xx_mac_enable(struct bcm43xx_wldev *dev)
 {
-	bcm->mac_suspended--;
-	assert(bcm->mac_suspended >= 0);
-	if (bcm->mac_suspended == 0) {
-		bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD,
-		                bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD)
+	dev->mac_suspended--;
+	BCM43xx_WARN_ON(dev->mac_suspended < 0);
+	if (dev->mac_suspended == 0) {
+		bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD,
+				bcm43xx_read32(dev,
+				BCM43xx_MMIO_STATUS_BITFIELD)
 				| BCM43xx_SBF_MAC_ENABLED);
-		bcm43xx_write32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON, BCM43xx_IRQ_READY);
-		bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD); /* dummy read */
-		bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON); /* dummy read */
-		bcm43xx_power_saving_ctl_bits(bcm, -1, -1);
+		bcm43xx_write32(dev, BCM43xx_MMIO_GEN_IRQ_REASON,
+				BCM43xx_IRQ_MAC_SUSPENDED);
+		/* the next two are dummy reads */
+		bcm43xx_read32(dev, BCM43xx_MMIO_STATUS_BITFIELD);
+		bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_REASON);
+		bcm43xx_power_saving_ctl_bits(dev, -1, -1);
 	}
 }
 
 /* http://bcm-specs.sipsolutions.net/SuspendMAC */
-void bcm43xx_mac_suspend(struct bcm43xx_private *bcm)
+void bcm43xx_mac_suspend(struct bcm43xx_wldev *dev)
 {
 	int i;
 	u32 tmp;
 
-	assert(bcm->mac_suspended >= 0);
-	if (bcm->mac_suspended == 0) {
-		bcm43xx_power_saving_ctl_bits(bcm, -1, 1);
-		bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD,
-		                bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD)
+	BCM43xx_WARN_ON(dev->mac_suspended < 0);
+	if (dev->mac_suspended == 0) {
+		bcm43xx_power_saving_ctl_bits(dev, -1, 1);
+		bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD,
+				bcm43xx_read32(dev,
+				BCM43xx_MMIO_STATUS_BITFIELD)
 				& ~BCM43xx_SBF_MAC_ENABLED);
-		bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON); /* dummy read */
+		bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_REASON);
 		for (i = 10000; i; i--) {
-			tmp = bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON);
-			if (tmp & BCM43xx_IRQ_READY)
+			tmp = bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_REASON);
+			if (tmp & BCM43xx_IRQ_MAC_SUSPENDED)
 				goto out;
 			udelay(1);
 		}
-		printkl(KERN_ERR PFX "MAC suspend failed\n");
+		bcmerr(dev->wl, "MAC suspend failed\n");
 	}
 out:
-	bcm->mac_suspended++;
+	dev->mac_suspended++;
 }
 
-void bcm43xx_set_iwmode(struct bcm43xx_private *bcm,
-			int iw_mode)
+static void bcm43xx_adjust_opmode(struct bcm43xx_wldev *dev)
 {
-	unsigned long flags;
-	struct net_device *net_dev = bcm->net_dev;
-	u32 status;
-	u16 value;
-
-	spin_lock_irqsave(&bcm->ieee->lock, flags);
-	bcm->ieee->iw_mode = iw_mode;
-	spin_unlock_irqrestore(&bcm->ieee->lock, flags);
-	if (iw_mode == IW_MODE_MONITOR)
-		net_dev->type = ARPHRD_IEEE80211;
-	else
-		net_dev->type = ARPHRD_ETHER;
-
-	status = bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD);
-	/* Reset status to infrastructured mode */
-	status &= ~(BCM43xx_SBF_MODE_AP | BCM43xx_SBF_MODE_MONITOR);
-	status &= ~BCM43xx_SBF_MODE_PROMISC;
-	status |= BCM43xx_SBF_MODE_NOTADHOC;
-
-/* FIXME: Always enable promisc mode, until we get the MAC filters working correctly. */
-status |= BCM43xx_SBF_MODE_PROMISC;
-
-	switch (iw_mode) {
-	case IW_MODE_MONITOR:
-		status |= BCM43xx_SBF_MODE_MONITOR;
-		status |= BCM43xx_SBF_MODE_PROMISC;
-		break;
-	case IW_MODE_ADHOC:
-		status &= ~BCM43xx_SBF_MODE_NOTADHOC;
-		break;
-	case IW_MODE_MASTER:
-		status |= BCM43xx_SBF_MODE_AP;
-		break;
-	case IW_MODE_SECOND:
-	case IW_MODE_REPEAT:
-		TODO(); /* TODO */
-		break;
-	case IW_MODE_INFRA:
-		/* nothing to be done here... */
-		break;
-	default:
-		dprintk(KERN_ERR PFX "Unknown mode in set_iwmode: %d\n", iw_mode);
+	struct bcm43xx_wl *wl = dev->wl;
+	u32 ctl;
+	u16 cfp_pretbtt;
+
+	ctl = bcm43xx_read32(dev, BCM43xx_MMIO_MACCTL);
+	/* Reset status to STA infrastructure mode. */
+	ctl &= ~BCM43xx_MACCTL_AP;
+	ctl &= ~BCM43xx_MACCTL_KEEP_CTL;
+	ctl &= ~BCM43xx_MACCTL_KEEP_BADPLCP;
+	ctl &= ~BCM43xx_MACCTL_KEEP_BAD;
+	ctl &= ~BCM43xx_MACCTL_PROMISC;
+	ctl |= BCM43xx_MACCTL_INFRA;
+
+	if (wl->operating) {
+		switch (wl->if_type) {
+		case IEEE80211_IF_TYPE_AP:
+			ctl |= BCM43xx_MACCTL_AP;
+			break;
+		case IEEE80211_IF_TYPE_IBSS:
+			ctl &= ~BCM43xx_MACCTL_INFRA;
+			break;
+		case IEEE80211_IF_TYPE_STA:
+		case IEEE80211_IF_TYPE_MNTR:
+		case IEEE80211_IF_TYPE_WDS:
+			break;
+		default:
+			bcmerr(wl, "Improper value of %d for wl->if_type\n",
+			       wl->if_type);
+		}
 	}
-	if (net_dev->flags & IFF_PROMISC)
-		status |= BCM43xx_SBF_MODE_PROMISC;
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD, status);
-
-	value = 0x0002;
-	if (iw_mode != IW_MODE_ADHOC && iw_mode != IW_MODE_MASTER) {
-		if (bcm->chip_id == 0x4306 && bcm->chip_rev == 3)
-			value = 0x0064;
+	if (wl->monitor) {
+		ctl |= BCM43xx_MACCTL_KEEP_CTL;
+		if (modparam_mon_keep_bad)
+			ctl |= BCM43xx_MACCTL_KEEP_BAD;
+		if (modparam_mon_keep_badplcp)
+			ctl |= BCM43xx_MACCTL_KEEP_BADPLCP;
+	}
+	if (wl->promisc)
+		ctl |= BCM43xx_MACCTL_PROMISC;
+	/* Workaround: On old hardware the HW-MAC-address-filter
+	 * doesn't work properly, so always run promisc in filter
+	 * it in software. */
+	if (dev->dev->id.revision <= 4)
+		ctl |= BCM43xx_MACCTL_PROMISC;
+
+	bcm43xx_write32(dev, BCM43xx_MMIO_MACCTL, ctl);
+
+	cfp_pretbtt = 2;
+	if ((ctl & BCM43xx_MACCTL_INFRA) &&
+	    !(ctl & BCM43xx_MACCTL_AP)) {
+		if (dev->dev->bus->chip_id == 0x4306 &&
+		    dev->dev->bus->chip_rev == 3)
+			cfp_pretbtt = 100;
 		else
-			value = 0x0032;
+			cfp_pretbtt = 50;
 	}
-	bcm43xx_write16(bcm, 0x0612, value);
+	bcm43xx_write16(dev, 0x612, cfp_pretbtt);
 }
 
-/* This is the opposite of bcm43xx_chip_init() */
-static void bcm43xx_chip_cleanup(struct bcm43xx_private *bcm)
+static void bcm43xx_rate_memory_write(struct bcm43xx_wldev *dev,
+				      u16 rate,
+				      int is_ofdm)
 {
-	bcm43xx_radio_turn_off(bcm);
-	if (!modparam_noleds)
-		bcm43xx_leds_exit(bcm);
-	bcm43xx_gpio_cleanup(bcm);
-	bcm43xx_release_firmware(bcm, 0);
+	u16 offset;
+
+	if (is_ofdm) {
+		offset = 0x480;
+		offset += (bcm43xx_plcp_get_ratecode_ofdm(rate) & 0x000F) * 2;
+	} else {
+		offset = 0x4C0;
+		offset += (bcm43xx_plcp_get_ratecode_cck(rate) & 0x000F) * 2;
+	}
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, offset + 0x20,
+			    bcm43xx_shm_read16(dev,
+			    BCM43xx_SHM_SHARED, offset));
 }
 
-/* Initialize the chip
- * http://bcm-specs.sipsolutions.net/ChipInit
- */
-static int bcm43xx_chip_init(struct bcm43xx_private *bcm)
+static void bcm43xx_rate_memory_init(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	int err;
-	int i, tmp;
-	u32 value32;
-	u16 value16;
-
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD,
-			BCM43xx_SBF_CORE_READY
-			| BCM43xx_SBF_400);
-
-	err = bcm43xx_request_firmware(bcm);
-	if (err)
-		goto out;
-	bcm43xx_upload_microcode(bcm);
-
-	bcm43xx_write32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON, 0xFFFFFFFF);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD, 0x00020402);
-	i = 0;
-	while (1) {
-		value32 = bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON);
-		if (value32 == BCM43xx_IRQ_READY)
-			break;
-		i++;
-		if (i >= BCM43xx_IRQWAIT_MAX_RETRIES) {
-			printk(KERN_ERR PFX "IRQ_READY timeout\n");
-			err = -ENODEV;
-			goto err_release_fw;
-		}
-		udelay(10);
+	switch (dev->phy.type) {
+	case BCM43xx_PHYTYPE_G:
+		bcm43xx_rate_memory_write(dev, BCM43xx_OFDM_RATE_6MB, 1);
+		bcm43xx_rate_memory_write(dev, BCM43xx_OFDM_RATE_12MB, 1);
+		bcm43xx_rate_memory_write(dev, BCM43xx_OFDM_RATE_18MB, 1);
+		bcm43xx_rate_memory_write(dev, BCM43xx_OFDM_RATE_24MB, 1);
+		bcm43xx_rate_memory_write(dev, BCM43xx_OFDM_RATE_36MB, 1);
+		bcm43xx_rate_memory_write(dev, BCM43xx_OFDM_RATE_48MB, 1);
+		bcm43xx_rate_memory_write(dev, BCM43xx_OFDM_RATE_54MB, 1);
+		/* fallthrough */
+	case BCM43xx_PHYTYPE_B:
+		bcm43xx_rate_memory_write(dev, BCM43xx_CCK_RATE_1MB, 0);
+		bcm43xx_rate_memory_write(dev, BCM43xx_CCK_RATE_2MB, 0);
+		bcm43xx_rate_memory_write(dev, BCM43xx_CCK_RATE_5MB, 0);
+		bcm43xx_rate_memory_write(dev, BCM43xx_CCK_RATE_11MB, 0);
+		break;
+	default:
+		BCM43xx_BUG_ON(1);
 	}
-	bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON); /* dummy read */
+}
 
-	value16 = bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED,
-				     BCM43xx_UCODE_REVISION);
+/* Set the TX-Antenna for management frames sent by firmware. */
+static void bcm43xx_mgmtframe_txantenna(struct bcm43xx_wldev *dev,
+					int antenna)
+{
+	u16 ant = 0;
+	u16 tmp;
 
-	dprintk(KERN_INFO PFX "Microcode rev 0x%x, pl 0x%x "
-		"(20%.2i-%.2i-%.2i  %.2i:%.2i:%.2i)\n", value16,
-		bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED,
-				   BCM43xx_UCODE_PATCHLEVEL),
-		(bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED,
-				    BCM43xx_UCODE_DATE) >> 12) & 0xf,
-		(bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED,
-				    BCM43xx_UCODE_DATE) >> 8) & 0xf,
-		bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED,
-				   BCM43xx_UCODE_DATE) & 0xff,
-		(bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED,
-				   BCM43xx_UCODE_TIME) >> 11) & 0x1f,
-		(bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED,
-				   BCM43xx_UCODE_TIME) >> 5) & 0x3f,
-		bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED,
-				   BCM43xx_UCODE_TIME) & 0x1f);
-
-	if ( value16 > 0x128 ) {
-		printk(KERN_ERR PFX
-			"Firmware: no support for microcode extracted "
-			"from version 4.x binary drivers.\n");
-		err = -EOPNOTSUPP;
-		goto err_release_fw;
+	switch (antenna) {
+	case BCM43xx_ANTENNA0:
+		ant |= BCM43xx_TX4_PHY_ANT0;
+		break;
+	case BCM43xx_ANTENNA1:
+		ant |= BCM43xx_TX4_PHY_ANT1;
+		break;
+	case BCM43xx_ANTENNA_AUTO:
+		ant |= BCM43xx_TX4_PHY_ANTLAST;
+		break;
+	default:
+		BCM43xx_BUG_ON(1);
 	}
 
-	err = bcm43xx_gpio_init(bcm);
+	/* FIXME We also need to set the other flags of the PHY control
+	 * field somewhere. */
+
+	/* For Beacons */
+	tmp = bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED,
+				 BCM43xx_SHM_SH_BEACPHYCTL);
+	tmp = (tmp & ~BCM43xx_TX4_PHY_ANT) | ant;
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
+			    BCM43xx_SHM_SH_BEACPHYCTL, tmp);
+	/* For ACK/CTS */
+	tmp = bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED,
+				 BCM43xx_SHM_SH_ACKCTSPHYCTL);
+	tmp = (tmp & ~BCM43xx_TX4_PHY_ANT) | ant;
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
+			    BCM43xx_SHM_SH_ACKCTSPHYCTL, tmp);
+	/* For Probe Resposes */
+	tmp = bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED,
+				 BCM43xx_SHM_SH_PRPHYCTL);
+	tmp = (tmp & ~BCM43xx_TX4_PHY_ANT) | ant;
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
+			    BCM43xx_SHM_SH_PRPHYCTL, tmp);
+}
+
+/* This is the opposite of bcm43xx_chip_init() */
+static void bcm43xx_chip_exit(struct bcm43xx_wldev *dev)
+{
+	bcm43xx_radio_turn_off(dev);
+	if (!modparam_noleds)
+		bcm43xx_leds_exit(dev);
+	bcm43xx_gpio_cleanup(dev);
+	/* firmware is released later */
+}
+
+/* Initialize the chip
+ * http://bcm-specs.sipsolutions.net/ChipInit
+ */
+static int bcm43xx_chip_init(struct bcm43xx_wldev *dev)
+{
+	struct bcm43xx_phy *phy = &dev->phy;
+	int err;
+	int tmp;
+	u32 value32;
+	u16 value16;
+
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD,
+			BCM43xx_SBF_CORE_READY
+			| BCM43xx_SBF_400);
+
+	err = bcm43xx_request_firmware(dev);
 	if (err)
-		goto err_release_fw;
+		goto out;
+	err = bcm43xx_upload_microcode(dev);
+	if (err)
+		goto out; /* firmware is released later */
 
-	err = bcm43xx_upload_initvals(bcm);
+	err = bcm43xx_gpio_init(dev);
+	if (err)
+		goto out; /* firmware is released later */
+	err = bcm43xx_upload_initvals(dev);
 	if (err)
 		goto err_gpio_cleanup;
-	bcm43xx_radio_turn_on(bcm);
-	bcm->radio_hw_enable = bcm43xx_is_hw_radio_enabled(bcm);
-	dprintk(KERN_INFO PFX "Radio %s by hardware\n",
-		(bcm->radio_hw_enable == 0) ? "disabled" : "enabled");
+	bcm43xx_radio_turn_on(dev);
+	dev->radio_hw_enable = bcm43xx_is_hw_radio_enabled(dev);
+	bcmdbg(dev->wl, "Radio %s by hardware\n",
+	       (dev->radio_hw_enable == 0) ? "disabled" : "enabled");
 
-	bcm43xx_write16(bcm, 0x03E6, 0x0000);
-	err = bcm43xx_phy_init(bcm);
+	bcm43xx_write16(dev, 0x03E6, 0x0000);
+	err = bcm43xx_phy_init(dev);
 	if (err)
 		goto err_radio_off;
 
 	/* Select initial Interference Mitigation. */
-	tmp = radio->interfmode;
-	radio->interfmode = BCM43xx_RADIO_INTERFMODE_NONE;
-	bcm43xx_radio_set_interference_mitigation(bcm, tmp);
+	tmp = phy->interfmode;
+	phy->interfmode = BCM43xx_INTERFMODE_NONE;
+	bcm43xx_radio_set_interference_mitigation(dev, tmp);
+
+	bcm43xx_phy_set_antenna_diversity(dev);
+	bcm43xx_mgmtframe_txantenna(dev, BCM43xx_ANTENNA_DEFAULT);
 
-	bcm43xx_phy_set_antenna_diversity(bcm);
-	bcm43xx_radio_set_txantenna(bcm, BCM43xx_RADIO_TXANTENNA_DEFAULT);
 	if (phy->type == BCM43xx_PHYTYPE_B) {
-		value16 = bcm43xx_read16(bcm, 0x005E);
+		value16 = bcm43xx_read16(dev, 0x005E);
 		value16 |= 0x0004;
-		bcm43xx_write16(bcm, 0x005E, value16);
+		bcm43xx_write16(dev, 0x005E, value16);
 	}
-	bcm43xx_write32(bcm, 0x0100, 0x01000000);
-	if (bcm->current_core->rev < 5)
-		bcm43xx_write32(bcm, 0x010C, 0x01000000);
+	bcm43xx_write32(dev, 0x0100, 0x01000000);
+	if (dev->dev->id.revision < 5)
+		bcm43xx_write32(dev, 0x010C, 0x01000000);
 
-	value32 = bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD);
+	value32 = bcm43xx_read32(dev, BCM43xx_MMIO_STATUS_BITFIELD);
 	value32 &= ~ BCM43xx_SBF_MODE_NOTADHOC;
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD, value32);
-	value32 = bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD);
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD, value32);
+	value32 = bcm43xx_read32(dev, BCM43xx_MMIO_STATUS_BITFIELD);
 	value32 |= BCM43xx_SBF_MODE_NOTADHOC;
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD, value32);
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD, value32);
 
-	value32 = bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD);
+	value32 = bcm43xx_read32(dev, BCM43xx_MMIO_STATUS_BITFIELD);
 	value32 |= 0x100000;
-	bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD, value32);
+	bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD, value32);
 
-	if (bcm43xx_using_pio(bcm)) {
-		bcm43xx_write32(bcm, 0x0210, 0x00000100);
-		bcm43xx_write32(bcm, 0x0230, 0x00000100);
-		bcm43xx_write32(bcm, 0x0250, 0x00000100);
-		bcm43xx_write32(bcm, 0x0270, 0x00000100);
-		bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x0034, 0x0000);
+	if (bcm43xx_using_pio(dev)) {
+		bcm43xx_write32(dev, 0x0210, 0x00000100);
+		bcm43xx_write32(dev, 0x0230, 0x00000100);
+		bcm43xx_write32(dev, 0x0250, 0x00000100);
+		bcm43xx_write32(dev, 0x0270, 0x00000100);
+		bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, 0x0034, 0x0000);
 	}
 
 	/* Probe Response Timeout value */
 	/* FIXME: Default to 0, has to be set by ioctl probably... :-/ */
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x0074, 0x0000);
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, 0x0074, 0x0000);
 
 	/* Initially set the wireless operation mode. */
-	bcm43xx_set_iwmode(bcm, bcm->ieee->iw_mode);
+	bcm43xx_adjust_opmode(dev);
 
-	if (bcm->current_core->rev < 3) {
-		bcm43xx_write16(bcm, 0x060E, 0x0000);
-		bcm43xx_write16(bcm, 0x0610, 0x8000);
-		bcm43xx_write16(bcm, 0x0604, 0x0000);
-		bcm43xx_write16(bcm, 0x0606, 0x0200);
+	if (dev->dev->id.revision < 3) {
+		bcm43xx_write16(dev, 0x060E, 0x0000);
+		bcm43xx_write16(dev, 0x0610, 0x8000);
+		bcm43xx_write16(dev, 0x0604, 0x0000);
+		bcm43xx_write16(dev, 0x0606, 0x0200);
 	} else {
-		bcm43xx_write32(bcm, 0x0188, 0x80000000);
-		bcm43xx_write32(bcm, 0x018C, 0x02000000);
+		bcm43xx_write32(dev, 0x0188, 0x80000000);
+		bcm43xx_write32(dev, 0x018C, 0x02000000);
 	}
-	bcm43xx_write32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON, 0x00004000);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA0_IRQ_MASK, 0x0001DC00);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA1_IRQ_MASK, 0x0000DC00);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA2_IRQ_MASK, 0x0000DC00);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA3_IRQ_MASK, 0x0001DC00);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA4_IRQ_MASK, 0x0000DC00);
-	bcm43xx_write32(bcm, BCM43xx_MMIO_DMA5_IRQ_MASK, 0x0000DC00);
+	bcm43xx_write32(dev, BCM43xx_MMIO_GEN_IRQ_REASON, 0x00004000);
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA0_IRQ_MASK, 0x0001DC00);
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA1_IRQ_MASK, 0x0000DC00);
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA2_IRQ_MASK, 0x0000DC00);
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA3_IRQ_MASK, 0x0001DC00);
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA4_IRQ_MASK, 0x0000DC00);
+	bcm43xx_write32(dev, BCM43xx_MMIO_DMA5_IRQ_MASK, 0x0000DC00);
 
-	value32 = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
+	value32 = ssb_read32(dev->dev, SSB_TMSLOW);
 	value32 |= 0x00100000;
-	bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, value32);
+	ssb_write32(dev->dev, SSB_TMSLOW, value32);
 
-	bcm43xx_write16(bcm, BCM43xx_MMIO_POWERUP_DELAY, bcm43xx_pctl_powerup_delay(bcm));
+	bcm43xx_write16(dev, BCM43xx_MMIO_POWERUP_DELAY,
+			dev->dev->bus->chipco.fast_pwrup_delay);
 
-	assert(err == 0);
-	dprintk(KERN_INFO PFX "Chip initialized\n");
+	BCM43xx_WARN_ON(err != 0);
+	bcmdbg(dev->wl, "Chip initialized\n");
 out:
 	return err;
 
 err_radio_off:
-	bcm43xx_radio_turn_off(bcm);
+	bcm43xx_radio_turn_off(dev);
 err_gpio_cleanup:
-	bcm43xx_gpio_cleanup(bcm);
-err_release_fw:
-	bcm43xx_release_firmware(bcm, 1);
+	bcm43xx_gpio_cleanup(dev);
 	goto out;
 }
-	
-/* Validate chip access
- * http://bcm-specs.sipsolutions.net/ValidateChipAccess */
-static int bcm43xx_validate_chip(struct bcm43xx_private *bcm)
-{
-	u32 value;
-	u32 shm_backup;
-
-	shm_backup = bcm43xx_shm_read32(bcm, BCM43xx_SHM_SHARED, 0x0000);
-	bcm43xx_shm_write32(bcm, BCM43xx_SHM_SHARED, 0x0000, 0xAA5555AA);
-	if (bcm43xx_shm_read32(bcm, BCM43xx_SHM_SHARED, 0x0000) != 0xAA5555AA)
-		goto error;
-	bcm43xx_shm_write32(bcm, BCM43xx_SHM_SHARED, 0x0000, 0x55AAAA55);
-	if (bcm43xx_shm_read32(bcm, BCM43xx_SHM_SHARED, 0x0000) != 0x55AAAA55)
-		goto error;
-	bcm43xx_shm_write32(bcm, BCM43xx_SHM_SHARED, 0x0000, shm_backup);
 
-	value = bcm43xx_read32(bcm, BCM43xx_MMIO_STATUS_BITFIELD);
-	if ((value | 0x80000000) != 0x80000400)
-		goto error;
+static void bcm43xx_periodic_every120sec(struct bcm43xx_wldev *dev)
+{
+	struct bcm43xx_phy *phy = &dev->phy;
 
-	value = bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON);
-	if (value != 0x00000000)
-		goto error;
+	if (phy->type != BCM43xx_PHYTYPE_G || phy->rev < 2)
+		return;
 
-	return 0;
-error:
-	printk(KERN_ERR PFX "Failed to validate the chipaccess\n");
-	return -ENODEV;
+	bcm43xx_mac_suspend(dev);
+	bcm43xx_phy_lo_g_measure(dev);
+	bcm43xx_mac_enable(dev);
 }
 
-static void bcm43xx_init_struct_phyinfo(struct bcm43xx_phyinfo *phy)
+static void bcm43xx_periodic_every60sec(struct bcm43xx_wldev *dev)
 {
-	/* Initialize a "phyinfo" structure. The structure is already
-	 * zeroed out.
-	 * This is called on insmod time to initialize members.
-	 */
-	phy->savedpctlreg = 0xFFFF;
-	spin_lock_init(&phy->lock);
+	bcm43xx_phy_lo_mark_all_unused(dev);
+	if (dev->dev->bus->sprom.r1.boardflags_lo & BCM43xx_BFL_RSSI) {
+		bcm43xx_mac_suspend(dev);
+		bcm43xx_calc_nrssi_slope(dev);
+		bcm43xx_mac_enable(dev);
+	}
 }
 
-static void bcm43xx_init_struct_radioinfo(struct bcm43xx_radioinfo *radio)
+static void bcm43xx_periodic_every30sec(struct bcm43xx_wldev *dev)
 {
-	/* Initialize a "radioinfo" structure. The structure is already
-	 * zeroed out.
-	 * This is called on insmod time to initialize members.
-	 */
-	radio->interfmode = BCM43xx_RADIO_INTERFMODE_NONE;
-	radio->channel = 0xFF;
-	radio->initial_channel = 0xFF;
-}
-
-static int bcm43xx_probe_cores(struct bcm43xx_private *bcm)
-{
-	int err, i;
-	int current_core;
-	u32 core_vendor, core_id, core_rev;
-	u32 sb_id_hi, chip_id_32 = 0;
-	u16 pci_device, chip_id_16;
-	u8 core_count;
-
-	memset(&bcm->core_chipcommon, 0, sizeof(struct bcm43xx_coreinfo));
-	memset(&bcm->core_pci, 0, sizeof(struct bcm43xx_coreinfo));
-	memset(&bcm->core_80211, 0, sizeof(struct bcm43xx_coreinfo)
-				    * BCM43xx_MAX_80211_CORES);
-	memset(&bcm->core_80211_ext, 0, sizeof(struct bcm43xx_coreinfo_80211)
-					* BCM43xx_MAX_80211_CORES);
-	bcm->nr_80211_available = 0;
-	bcm->current_core = NULL;
-	bcm->active_80211_core = NULL;
-
-	/* map core 0 */
-	err = _switch_core(bcm, 0);
-	if (err)
-		goto out;
-
-	/* fetch sb_id_hi from core information registers */
-	sb_id_hi = bcm43xx_read32(bcm, BCM43xx_CIR_SB_ID_HI);
-
-	core_id = (sb_id_hi & 0x8FF0) >> 4;
-	core_rev = (sb_id_hi & 0x7000) >> 8;
-	core_rev |= (sb_id_hi & 0xF);
-	core_vendor = (sb_id_hi & 0xFFFF0000) >> 16;
-
-	/* if present, chipcommon is always core 0; read the chipid from it */
-	if (core_id == BCM43xx_COREID_CHIPCOMMON) {
-		chip_id_32 = bcm43xx_read32(bcm, 0);
-		chip_id_16 = chip_id_32 & 0xFFFF;
-		bcm->core_chipcommon.available = 1;
-		bcm->core_chipcommon.id = core_id;
-		bcm->core_chipcommon.rev = core_rev;
-		bcm->core_chipcommon.index = 0;
-		/* While we are at it, also read the capabilities. */
-		bcm->chipcommon_capabilities = bcm43xx_read32(bcm, BCM43xx_CHIPCOMMON_CAPABILITIES);
-	} else {
-		/* without a chipCommon, use a hard coded table. */
-		pci_device = bcm->pci_dev->device;
-		if (pci_device == 0x4301)
-			chip_id_16 = 0x4301;
-		else if ((pci_device >= 0x4305) && (pci_device <= 0x4307))
-			chip_id_16 = 0x4307;
-		else if ((pci_device >= 0x4402) && (pci_device <= 0x4403))
-			chip_id_16 = 0x4402;
-		else if ((pci_device >= 0x4610) && (pci_device <= 0x4615))
-			chip_id_16 = 0x4610;
-		else if ((pci_device >= 0x4710) && (pci_device <= 0x4715))
-			chip_id_16 = 0x4710;
-		else {
-			printk(KERN_ERR PFX "Could not determine Chip ID\n");
-			return -ENODEV;
-		}
-	}
-
-	/* ChipCommon with Core Rev >=4 encodes number of cores,
-	 * otherwise consult hardcoded table */
-	if ((core_id == BCM43xx_COREID_CHIPCOMMON) && (core_rev >= 4)) {
-		core_count = (chip_id_32 & 0x0F000000) >> 24;
-	} else {
-		switch (chip_id_16) {
-			case 0x4610:
-			case 0x4704:
-			case 0x4710:
-				core_count = 9;
-				break;
-			case 0x4310:
-				core_count = 8;
-				break;
-			case 0x5365:
-				core_count = 7;
-				break;
-			case 0x4306:
-				core_count = 6;
-				break;
-			case 0x4301:
-			case 0x4307:
-				core_count = 5;
-				break;
-			case 0x4402:
-				core_count = 3;
-				break;
-			default:
-				/* SOL if we get here */
-				assert(0);
-				core_count = 1;
-		}
-	}
-
-	bcm->chip_id = chip_id_16;
-	bcm->chip_rev = (chip_id_32 & 0x000F0000) >> 16;
-	bcm->chip_package = (chip_id_32 & 0x00F00000) >> 20;
-
-	dprintk(KERN_INFO PFX "Chip ID 0x%x, rev 0x%x\n",
-		bcm->chip_id, bcm->chip_rev);
-	dprintk(KERN_INFO PFX "Number of cores: %d\n", core_count);
-	if (bcm->core_chipcommon.available) {
-		dprintk(KERN_INFO PFX "Core 0: ID 0x%x, rev 0x%x, vendor 0x%x\n",
-			core_id, core_rev, core_vendor);
-		current_core = 1;
-	} else
-		current_core = 0;
-	for ( ; current_core < core_count; current_core++) {
-		struct bcm43xx_coreinfo *core;
-		struct bcm43xx_coreinfo_80211 *ext_80211;
-
-		err = _switch_core(bcm, current_core);
-		if (err)
-			goto out;
-		/* Gather information */
-		/* fetch sb_id_hi from core information registers */
-		sb_id_hi = bcm43xx_read32(bcm, BCM43xx_CIR_SB_ID_HI);
-
-		/* extract core_id, core_rev, core_vendor */
-		core_id = (sb_id_hi & 0x8FF0) >> 4;
-		core_rev = ((sb_id_hi & 0xF) | ((sb_id_hi & 0x7000) >> 8));
-		core_vendor = (sb_id_hi & 0xFFFF0000) >> 16;
-
-		dprintk(KERN_INFO PFX "Core %d: ID 0x%x, rev 0x%x, vendor 0x%x\n",
-			current_core, core_id, core_rev, core_vendor);
-
-		core = NULL;
-		switch (core_id) {
-		case BCM43xx_COREID_PCI:
-		case BCM43xx_COREID_PCIE:
-			core = &bcm->core_pci;
-			if (core->available) {
-				printk(KERN_WARNING PFX "Multiple PCI cores found.\n");
-				continue;
-			}
-			break;
-		case BCM43xx_COREID_80211:
-			for (i = 0; i < BCM43xx_MAX_80211_CORES; i++) {
-				core = &(bcm->core_80211[i]);
-				ext_80211 = &(bcm->core_80211_ext[i]);
-				if (!core->available)
-					break;
-				core = NULL;
-			}
-			if (!core) {
-				printk(KERN_WARNING PFX "More than %d cores of type 802.11 found.\n",
-				       BCM43xx_MAX_80211_CORES);
-				continue;
-			}
-			if (i != 0) {
-				/* More than one 80211 core is only supported
-				 * by special chips.
-				 * There are chips with two 80211 cores, but with
-				 * dangling pins on the second core. Be careful
-				 * and ignore these cores here.
-				 */
-				if (1 /*bcm->pci_dev->device != 0x4324*/ ) {
-				/* TODO: A PHY */
-					dprintk(KERN_INFO PFX "Ignoring additional 802.11a core.\n");
-					continue;
-				}
-			}
-			switch (core_rev) {
-			case 2:
-			case 4:
-			case 5:
-			case 6:
-			case 7:
-			case 9:
-			case 10:
-				break;
-			default:
-				printk(KERN_WARNING PFX
-				       "Unsupported 80211 core revision %u\n",
-				       core_rev);
-			}
-			bcm->nr_80211_available++;
-			core->priv = ext_80211;
-			bcm43xx_init_struct_phyinfo(&ext_80211->phy);
-			bcm43xx_init_struct_radioinfo(&ext_80211->radio);
-			break;
-		case BCM43xx_COREID_CHIPCOMMON:
-			printk(KERN_WARNING PFX "Multiple CHIPCOMMON cores found.\n");
-			break;
-		}
-		if (core) {
-			core->available = 1;
-			core->id = core_id;
-			core->rev = core_rev;
-			core->index = current_core;
-		}
-	}
-
-	if (!bcm->core_80211[0].available) {
-		printk(KERN_ERR PFX "Error: No 80211 core found!\n");
-		err = -ENODEV;
-		goto out;
-	}
-
-	err = bcm43xx_switch_core(bcm, &bcm->core_80211[0]);
-
-	assert(err == 0);
-out:
-	return err;
+	/* Update device statistics. */
+	bcm43xx_calculate_link_quality(dev);
 }
 
-static void bcm43xx_gen_bssid(struct bcm43xx_private *bcm)
+static void bcm43xx_periodic_every15sec(struct bcm43xx_wldev *dev)
 {
-	const u8 *mac = (const u8*)(bcm->net_dev->dev_addr);
-	u8 *bssid = bcm->ieee->bssid;
-
-	switch (bcm->ieee->iw_mode) {
-	case IW_MODE_ADHOC:
-		random_ether_addr(bssid);
-		break;
-	case IW_MODE_MASTER:
-	case IW_MODE_INFRA:
-	case IW_MODE_REPEAT:
-	case IW_MODE_SECOND:
-	case IW_MODE_MONITOR:
-		memcpy(bssid, mac, ETH_ALEN);
-		break;
-	default:
-		assert(0);
-	}
+	bcm43xx_phy_xmitpower(dev); /* FIXME: unless scanning? */
 }
 
-static void bcm43xx_rate_memory_write(struct bcm43xx_private *bcm,
-				      u16 rate,
-				      int is_ofdm)
+static void bcm43xx_periodic_every1sec(struct bcm43xx_wldev *dev)
 {
-	u16 offset;
+	int radio_hw_enable;
 
-	if (is_ofdm) {
-		offset = 0x480;
-		offset += (bcm43xx_plcp_get_ratecode_ofdm(rate) & 0x000F) * 2;
-	}
-	else {
-		offset = 0x4C0;
-		offset += (bcm43xx_plcp_get_ratecode_cck(rate) & 0x000F) * 2;
+	/* check if radio hardware enabled status changed */
+	radio_hw_enable = bcm43xx_is_hw_radio_enabled(dev);
+	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
+		dev->radio_hw_enable = radio_hw_enable;
+		bcmdbg(dev->wl, "Radio hardware status changed to %s\n",
+		       (radio_hw_enable == 0) ? "disabled" : "enabled");
+		bcm43xx_leds_update(dev, 0);
 	}
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, offset + 0x20,
-			    bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED, offset));
 }
 
-static void bcm43xx_rate_memory_init(struct bcm43xx_private *bcm)
+static void do_periodic_work(struct bcm43xx_wldev *dev)
 {
-	switch (bcm43xx_current_phy(bcm)->type) {
-	case BCM43xx_PHYTYPE_A:
-	case BCM43xx_PHYTYPE_G:
-		bcm43xx_rate_memory_write(bcm, IEEE80211_OFDM_RATE_6MB, 1);
-		bcm43xx_rate_memory_write(bcm, IEEE80211_OFDM_RATE_12MB, 1);
-		bcm43xx_rate_memory_write(bcm, IEEE80211_OFDM_RATE_18MB, 1);
-		bcm43xx_rate_memory_write(bcm, IEEE80211_OFDM_RATE_24MB, 1);
-		bcm43xx_rate_memory_write(bcm, IEEE80211_OFDM_RATE_36MB, 1);
-		bcm43xx_rate_memory_write(bcm, IEEE80211_OFDM_RATE_48MB, 1);
-		bcm43xx_rate_memory_write(bcm, IEEE80211_OFDM_RATE_54MB, 1);
-	case BCM43xx_PHYTYPE_B:
-		bcm43xx_rate_memory_write(bcm, IEEE80211_CCK_RATE_1MB, 0);
-		bcm43xx_rate_memory_write(bcm, IEEE80211_CCK_RATE_2MB, 0);
-		bcm43xx_rate_memory_write(bcm, IEEE80211_CCK_RATE_5MB, 0);
-		bcm43xx_rate_memory_write(bcm, IEEE80211_CCK_RATE_11MB, 0);
-		break;
-	default:
-		assert(0);
-	}
+	unsigned int state;
+
+	state = dev->periodic_state;
+	if (state % 120 == 0)
+		bcm43xx_periodic_every120sec(dev);
+	if (state % 60 == 0)
+		bcm43xx_periodic_every60sec(dev);
+	if (state % 30 == 0)
+		bcm43xx_periodic_every30sec(dev);
+	if (state % 15 == 0)
+		bcm43xx_periodic_every15sec(dev);
+	bcm43xx_periodic_every1sec(dev);
 }
 
-static void bcm43xx_wireless_core_cleanup(struct bcm43xx_private *bcm)
+/* Estimate a "Badness" value based on the periodic work
+ * state-machine state. "Badness" is worse (bigger), if the
+ * periodic work will take longer.
+ */
+static int estimate_periodic_work_badness(unsigned int state)
 {
-	bcm43xx_chip_cleanup(bcm);
-	bcm43xx_pio_free(bcm);
-	bcm43xx_dma_free(bcm);
+	int badness = 0;
+
+	if (state % 120 == 0) /* every 120 sec */
+		badness += 10;
+	if (state % 60 == 0) /* every 60 sec */
+		badness += 5;
+	if (state % 30 == 0) /* every 30 sec */
+		badness += 1;
+	if (state % 15 == 0) /* every 15 sec */
+		badness += 1;
 
-	bcm->current_core->initialized = 0;
+#define BADNESS_LIMIT	4
+	return badness;
 }
 
-/* http://bcm-specs.sipsolutions.net/80211Init */
-static int bcm43xx_wireless_core_init(struct bcm43xx_private *bcm,
-				      int active_wlcore)
+static void bcm43xx_periodic_work_handler(struct work_struct *work)
 {
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
-	u32 ucodeflags;
-	int err;
-	u32 sbimconfiglow;
-	u8 limit;
+	struct bcm43xx_wldev *dev =
+		container_of(work, struct bcm43xx_wldev, periodic_work.work);
+	unsigned long flags;
+	unsigned long delay;
+	u32 savedirqs = 0;
+	int badness;
 
-	if (bcm->core_pci.rev <= 5 && bcm->core_pci.id != BCM43xx_COREID_PCIE) {
-		sbimconfiglow = bcm43xx_read32(bcm, BCM43xx_CIR_SBIMCONFIGLOW);
-		sbimconfiglow &= ~ BCM43xx_SBIMCONFIGLOW_REQUEST_TOUT_MASK;
-		sbimconfiglow &= ~ BCM43xx_SBIMCONFIGLOW_SERVICE_TOUT_MASK;
-		if (bcm->bustype == BCM43xx_BUSTYPE_PCI)
-			sbimconfiglow |= 0x32;
-		else
-			sbimconfiglow |= 0x53;
-		bcm43xx_write32(bcm, BCM43xx_CIR_SBIMCONFIGLOW, sbimconfiglow);
-	}
+	mutex_lock(&dev->wl->mutex);
 
-	bcm43xx_phy_calibrate(bcm);
-	err = bcm43xx_chip_init(bcm);
-	if (err)
+	if (unlikely(bcm43xx_status(dev) != BCM43xx_STAT_STARTED))
 		goto out;
+	if (bcm43xx_debug(dev, BCM43xx_DBG_PWORK_STOP))
+		goto out_requeue;
 
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x0016, bcm->current_core->rev);
-	ucodeflags = bcm43xx_shm_read32(bcm, BCM43xx_SHM_SHARED, BCM43xx_UCODEFLAGS_OFFSET);
-
-	if (0 /*FIXME: which condition has to be used here? */)
-		ucodeflags |= 0x00000010;
+	badness = estimate_periodic_work_badness(dev->periodic_state);
+	if (badness > BADNESS_LIMIT) {
+		spin_lock_irqsave(&dev->wl->irq_lock, flags);
+		/* Suspend TX as we don't want to transmit packets while
+		 * we recalibrate the hardware. */
+		bcm43xx_tx_suspend(dev);
+		savedirqs = bcm43xx_interrupt_disable(dev, BCM43xx_IRQ_ALL);
+		/* Periodic work will take a long time, so we want it to
+		 * be preemtible and release the spinlock. */
+		spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
+		bcm43xx_synchronize_irq(dev);
+
+		do_periodic_work(dev);
+
+		spin_lock_irqsave(&dev->wl->irq_lock, flags);
+		bcm43xx_interrupt_enable(dev, savedirqs);
+		bcm43xx_tx_resume(dev);
+		mmiowb();
+		spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
+	} else {
+		/* Take the global driver lock. This will lock any operation. */
+		spin_lock_irqsave(&dev->wl->irq_lock, flags);
 
-	/* HW decryption needs to be set now */
-	ucodeflags |= 0x40000000;
-	
-	if (phy->type == BCM43xx_PHYTYPE_G) {
-		ucodeflags |= BCM43xx_UCODEFLAG_UNKBGPHY;
-		if (phy->rev == 1)
-			ucodeflags |= BCM43xx_UCODEFLAG_UNKGPHY;
-		if (bcm->sprom.boardflags & BCM43xx_BFL_PACTRL)
-			ucodeflags |= BCM43xx_UCODEFLAG_UNKPACTRL;
-	} else if (phy->type == BCM43xx_PHYTYPE_B) {
-		ucodeflags |= BCM43xx_UCODEFLAG_UNKBGPHY;
-		if (phy->rev >= 2 && radio->version == 0x2050)
-			ucodeflags &= ~BCM43xx_UCODEFLAG_UNKGPHY;
-	}
+		do_periodic_work(dev);
 
-	if (ucodeflags != bcm43xx_shm_read32(bcm, BCM43xx_SHM_SHARED,
-					     BCM43xx_UCODEFLAGS_OFFSET)) {
-		bcm43xx_shm_write32(bcm, BCM43xx_SHM_SHARED,
-				    BCM43xx_UCODEFLAGS_OFFSET, ucodeflags);
+		mmiowb();
+		spin_unlock_irqrestore(&dev->wl->irq_lock, flags);
 	}
-
-	/* Short/Long Retry Limit.
-	 * The retry-limit is a 4-bit counter. Enforce this to avoid overflowing
-	 * the chip-internal counter.
-	 */
-	limit = limit_value(modparam_short_retry, 0, 0xF);
-	bcm43xx_shm_write32(bcm, BCM43xx_SHM_WIRELESS, 0x0006, limit);
-	limit = limit_value(modparam_long_retry, 0, 0xF);
-	bcm43xx_shm_write32(bcm, BCM43xx_SHM_WIRELESS, 0x0007, limit);
-
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x0044, 3);
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x0046, 2);
-
-	bcm43xx_rate_memory_init(bcm);
-
-	/* Minimum Contention Window */
-	if (phy->type == BCM43xx_PHYTYPE_B)
-		bcm43xx_shm_write32(bcm, BCM43xx_SHM_WIRELESS, 0x0003, 0x0000001f);
+	dev->periodic_state++;
+out_requeue:
+	if (bcm43xx_debug(dev, BCM43xx_DBG_PWORK_FAST))
+		delay = msecs_to_jiffies(50);
 	else
-		bcm43xx_shm_write32(bcm, BCM43xx_SHM_WIRELESS, 0x0003, 0x0000000f);
-	/* Maximum Contention Window */
-	bcm43xx_shm_write32(bcm, BCM43xx_SHM_WIRELESS, 0x0004, 0x000003ff);
-
-	bcm43xx_gen_bssid(bcm);
-	bcm43xx_write_mac_bssid_templates(bcm);
-
-	if (bcm->current_core->rev >= 5)
-		bcm43xx_write16(bcm, 0x043C, 0x000C);
-
-	if (active_wlcore) {
-		if (bcm43xx_using_pio(bcm)) {
-			err = bcm43xx_pio_init(bcm);
-		} else {
-			err = bcm43xx_dma_init(bcm);
-			if (err == -ENOSYS)
-				err = bcm43xx_pio_init(bcm);
-		}
-		if (err)
-			goto err_chip_cleanup;
-	}
-	bcm43xx_write16(bcm, 0x0612, 0x0050);
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x0416, 0x0050);
-	bcm43xx_shm_write16(bcm, BCM43xx_SHM_SHARED, 0x0414, 0x01F4);
-
-	if (active_wlcore) {
-		if (radio->initial_channel != 0xFF)
-			bcm43xx_radio_selectchannel(bcm, radio->initial_channel, 0);
-	}
-
-	/* Don't enable MAC/IRQ here, as it will race with the IRQ handler.
-	 * We enable it later.
-	 */
-	bcm->current_core->initialized = 1;
+		delay = round_jiffies(HZ);
+	queue_delayed_work(dev->wl->hw->workqueue,
+			   &dev->periodic_work, delay);
 out:
-	return err;
-
-err_chip_cleanup:
-	bcm43xx_chip_cleanup(bcm);
-	goto out;
+	mutex_unlock(&dev->wl->mutex);
 }
 
-static int bcm43xx_chipset_attach(struct bcm43xx_private *bcm)
+static void bcm43xx_periodic_tasks_delete(struct bcm43xx_wldev *dev)
 {
-	int err;
-	u16 pci_status;
-
-	err = bcm43xx_pctl_set_crystal(bcm, 1);
-	if (err)
-		goto out;
-	err = bcm43xx_pci_read_config16(bcm, PCI_STATUS, &pci_status);
-	if (err)
-		goto out;
-	err = bcm43xx_pci_write_config16(bcm, PCI_STATUS, pci_status & ~PCI_STATUS_SIG_TARGET_ABORT);
-
-out:
-	return err;
+	cancel_rearming_delayed_work(&dev->periodic_work);
 }
 
-static void bcm43xx_chipset_detach(struct bcm43xx_private *bcm)
+static void bcm43xx_periodic_tasks_setup(struct bcm43xx_wldev *dev)
 {
-	bcm43xx_pctl_set_clock(bcm, BCM43xx_PCTL_CLK_SLOW);
-	bcm43xx_pctl_set_crystal(bcm, 0);
-}
+	struct delayed_work *work = &dev->periodic_work;
 
-static void bcm43xx_pcicore_broadcast_value(struct bcm43xx_private *bcm,
-					    u32 address,
-					    u32 data)
-{
-	bcm43xx_write32(bcm, BCM43xx_PCICORE_BCAST_ADDR, address);
-	bcm43xx_write32(bcm, BCM43xx_PCICORE_BCAST_DATA, data);
+	dev->periodic_state = 0;
+	INIT_DELAYED_WORK(work, bcm43xx_periodic_work_handler);
+	queue_delayed_work(dev->wl->hw->workqueue, work, 0);
 }
 
-static int bcm43xx_pcicore_commit_settings(struct bcm43xx_private *bcm)
+/* Validate access to the chip (SHM) */
+static int bcm43xx_validate_chipaccess(struct bcm43xx_wldev *dev)
 {
-	int err = 0;
-
-	bcm->irq_savedstate = bcm43xx_interrupt_disable(bcm, BCM43xx_IRQ_ALL);
+	u32 value;
+	u32 shm_backup;
 
-	if (bcm->core_chipcommon.available) {
-		err = bcm43xx_switch_core(bcm, &bcm->core_chipcommon);
-		if (err)
-			goto out;
+	shm_backup = bcm43xx_shm_read32(dev, BCM43xx_SHM_SHARED, 0);
+	bcm43xx_shm_write32(dev, BCM43xx_SHM_SHARED, 0, 0xAA5555AA);
+	if (bcm43xx_shm_read32(dev, BCM43xx_SHM_SHARED, 0) != 0xAA5555AA)
+		goto error;
+	bcm43xx_shm_write32(dev, BCM43xx_SHM_SHARED, 0, 0x55AAAA55);
+	if (bcm43xx_shm_read32(dev, BCM43xx_SHM_SHARED, 0) != 0x55AAAA55)
+		goto error;
+	bcm43xx_shm_write32(dev, BCM43xx_SHM_SHARED, 0, shm_backup);
 
-		bcm43xx_pcicore_broadcast_value(bcm, 0xfd8, 0x00000000);
+	value = bcm43xx_read32(dev, BCM43xx_MMIO_MACCTL);
+	if ((value | BCM43xx_MACCTL_GMODE) !=
+	    (BCM43xx_MACCTL_GMODE | BCM43xx_MACCTL_IHR_ENABLED))
+		goto error;
 
-		/* this function is always called when a PCI core is mapped */
-		err = bcm43xx_switch_core(bcm, &bcm->core_pci);
-		if (err)
-			goto out;
-	} else
-		bcm43xx_pcicore_broadcast_value(bcm, 0xfd8, 0x00000000);
+	value = bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_REASON);
+	if (value)
+		goto error;
 
-	bcm43xx_interrupt_enable(bcm, bcm->irq_savedstate);
+	return 0;
+error:
+	bcmerr(dev->wl, "Failed to validate the chipaccess\n");
+	return -ENODEV;
+}
 
-out:
-	return err;
+static void bcm43xx_security_init(struct bcm43xx_wldev *dev)
+{
+	dev->max_nr_keys = (dev->dev->id.revision >= 5) ? 58 : 20;
+	BCM43xx_WARN_ON(dev->max_nr_keys > ARRAY_SIZE(dev->key));
+	dev->ktp = bcm43xx_shm_read16(dev, BCM43xx_SHM_SHARED,
+				      0x0056);
+	/* KTP is a word address, but we address SHM bytewise.
+	 * So multiply by two.
+	 */
+	dev->ktp *= 2;
+	if (dev->dev->id.revision >= 5)
+		/* Number of RCMTA address slots */
+		bcm43xx_write16(dev, BCM43xx_MMIO_RCMTA_COUNT,
+				dev->max_nr_keys - 8);
+	bcm43xx_clear_keys(dev);
 }
 
-static u32 bcm43xx_pcie_reg_read(struct bcm43xx_private *bcm, u32 address)
+static int bcm43xx_rng_read(struct hwrng *rng, u32 *data)
 {
-	bcm43xx_write32(bcm, BCM43xx_PCIECORE_REG_ADDR, address);
-	return bcm43xx_read32(bcm, BCM43xx_PCIECORE_REG_DATA);
+	struct bcm43xx_wl *wl = (struct bcm43xx_wl *)rng->priv;
+	unsigned long flags;
+
+	/* Don't take wl->mutex here, as it could deadlock with
+	 * hwrng internal locking. It's not needed to take
+	 * wl->mutex here, anyway. */
+
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	*data = bcm43xx_read16(wl->current_dev, BCM43xx_MMIO_RNG);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+
+	return (sizeof(u16));
 }
 
-static void bcm43xx_pcie_reg_write(struct bcm43xx_private *bcm, u32 address,
-				    u32 data)
+static void bcm43xx_rng_exit(struct bcm43xx_wl *wl)
 {
-	bcm43xx_write32(bcm, BCM43xx_PCIECORE_REG_ADDR, address);
-	bcm43xx_write32(bcm, BCM43xx_PCIECORE_REG_DATA, data);
+	if (wl->rng_initialized)
+		hwrng_unregister(&wl->rng);
 }
 
-static void bcm43xx_pcie_mdio_write(struct bcm43xx_private *bcm, u8 dev, u8 reg,
-				    u16 data)
+static int bcm43xx_rng_init(struct bcm43xx_wl *wl)
 {
-	int i;
+	int err;
 
-	bcm43xx_write32(bcm, BCM43xx_PCIECORE_MDIO_CTL, 0x0082);
-	bcm43xx_write32(bcm, BCM43xx_PCIECORE_MDIO_DATA, BCM43xx_PCIE_MDIO_ST |
-			BCM43xx_PCIE_MDIO_WT | (dev << BCM43xx_PCIE_MDIO_DEV) |
-			(reg << BCM43xx_PCIE_MDIO_REG) | BCM43xx_PCIE_MDIO_TA |
-			data);
-	udelay(10);
-
-	for (i = 0; i < 10; i++) {
-		if (bcm43xx_read32(bcm, BCM43xx_PCIECORE_MDIO_CTL) &
-		    BCM43xx_PCIE_MDIO_TC)
-			break;
-		msleep(1);
+	snprintf(wl->rng_name, ARRAY_SIZE(wl->rng_name),
+		 "%s_%s", KBUILD_MODNAME, wiphy_name(wl->hw->wiphy));
+	wl->rng.name = wl->rng_name;
+	wl->rng.data_read = bcm43xx_rng_read;
+	wl->rng.priv = (unsigned long)wl;
+	wl->rng_initialized = 1;
+	err = hwrng_register(&wl->rng);
+	if (err) {
+		wl->rng_initialized = 0;
+		bcmerr(wl, "Failed to register the random "
+		       "number generator (%d)\n", err);
 	}
-	bcm43xx_write32(bcm, BCM43xx_PCIECORE_MDIO_CTL, 0);
+
+	return err;
 }
 
-/* Make an I/O Core usable. "core_mask" is the bitmask of the cores to enable.
- * To enable core 0, pass a core_mask of 1<<0
- */
-static int bcm43xx_setup_backplane_pci_connection(struct bcm43xx_private *bcm,
-						  u32 core_mask)
+static int bcm43xx_tx(struct ieee80211_hw *hw,
+		      struct sk_buff *skb,
+		      struct ieee80211_tx_control *ctl)
 {
-	u32 backplane_flag_nr;
-	u32 value;
-	struct bcm43xx_coreinfo *old_core;
-	int err = 0;
-
-	value = bcm43xx_read32(bcm, BCM43xx_CIR_SBTPSFLAG);
-	backplane_flag_nr = value & BCM43xx_BACKPLANE_FLAG_NR_MASK;
+	struct bcm43xx_wl *wl = hw_to_bcm43xx_wl(hw);
+	struct bcm43xx_wldev *dev = wl->current_dev;
+	int err = -ENODEV;
+	unsigned long flags;
 
-	old_core = bcm->current_core;
-	err = bcm43xx_switch_core(bcm, &bcm->core_pci);
-	if (err)
+	if (unlikely(!dev))
 		goto out;
-
-	if (bcm->current_core->rev < 6 &&
-		bcm->current_core->id == BCM43xx_COREID_PCI) {
-		value = bcm43xx_read32(bcm, BCM43xx_CIR_SBINTVEC);
-		value |= (1 << backplane_flag_nr);
-		bcm43xx_write32(bcm, BCM43xx_CIR_SBINTVEC, value);
+	if (unlikely(bcm43xx_status(dev) < BCM43xx_STAT_STARTED))
+		goto out;
+	/* DMA-TX is done without a global lock. */
+	if (bcm43xx_using_pio(dev)) {
+		spin_lock_irqsave(&wl->irq_lock, flags);
+		err = bcm43xx_pio_tx(dev, skb, ctl);
+		spin_unlock_irqrestore(&wl->irq_lock, flags);
 	} else {
-		err = bcm43xx_pci_read_config32(bcm, BCM43xx_PCICFG_ICR, &value);
-		if (err) {
-			printk(KERN_ERR PFX "Error: ICR setup failure!\n");
-			goto out_switch_back;
-		}
-		value |= core_mask << 8;
-		err = bcm43xx_pci_write_config32(bcm, BCM43xx_PCICFG_ICR, value);
-		if (err) {
-			printk(KERN_ERR PFX "Error: ICR setup failure!\n");
-			goto out_switch_back;
-		}
+		err = bcm43xx_dma_tx(dev, skb, ctl);
 	}
+out:
+	if (unlikely(err))
+		return NETDEV_TX_BUSY;
+	return NETDEV_TX_OK;
+}
 
-	if (bcm->current_core->id == BCM43xx_COREID_PCI) {
-		value = bcm43xx_read32(bcm, BCM43xx_PCICORE_SBTOPCI2);
-		value |= BCM43xx_SBTOPCI2_PREFETCH | BCM43xx_SBTOPCI2_BURST;
-		bcm43xx_write32(bcm, BCM43xx_PCICORE_SBTOPCI2, value);
-
-		if (bcm->current_core->rev < 5) {
-			value = bcm43xx_read32(bcm, BCM43xx_CIR_SBIMCONFIGLOW);
-			value |= (2 << BCM43xx_SBIMCONFIGLOW_SERVICE_TOUT_SHIFT)
-				 & BCM43xx_SBIMCONFIGLOW_SERVICE_TOUT_MASK;
-			value |= (3 << BCM43xx_SBIMCONFIGLOW_REQUEST_TOUT_SHIFT)
-				 & BCM43xx_SBIMCONFIGLOW_REQUEST_TOUT_MASK;
-			bcm43xx_write32(bcm, BCM43xx_CIR_SBIMCONFIGLOW, value);
-			err = bcm43xx_pcicore_commit_settings(bcm);
-			assert(err == 0);
-		} else if (bcm->current_core->rev >= 11) {
-			value = bcm43xx_read32(bcm, BCM43xx_PCICORE_SBTOPCI2);
-			value |= BCM43xx_SBTOPCI2_MEMREAD_MULTI;
-			bcm43xx_write32(bcm, BCM43xx_PCICORE_SBTOPCI2, value);
-		}
-	} else {
-		if (bcm->current_core->rev == 0 || bcm->current_core->rev == 1) {
-			value = bcm43xx_pcie_reg_read(bcm, BCM43xx_PCIE_TLP_WORKAROUND);
-			value |= 0x8;
-			bcm43xx_pcie_reg_write(bcm, BCM43xx_PCIE_TLP_WORKAROUND,
-					       value);
-		}
-		if (bcm->current_core->rev == 0) {
-			bcm43xx_pcie_mdio_write(bcm, BCM43xx_MDIO_SERDES_RX,
-						BCM43xx_SERDES_RXTIMER, 0x8128);
-			bcm43xx_pcie_mdio_write(bcm, BCM43xx_MDIO_SERDES_RX,
-						BCM43xx_SERDES_CDR, 0x0100);
-			bcm43xx_pcie_mdio_write(bcm, BCM43xx_MDIO_SERDES_RX,
-						BCM43xx_SERDES_CDR_BW, 0x1466);
-		} else if (bcm->current_core->rev == 1) {
-			value = bcm43xx_pcie_reg_read(bcm, BCM43xx_PCIE_DLLP_LINKCTL);
-			value |= 0x40;
-			bcm43xx_pcie_reg_write(bcm, BCM43xx_PCIE_DLLP_LINKCTL,
-					       value);
-		}
+static int bcm43xx_conf_tx(struct ieee80211_hw *hw,
+			   int queue,
+			   const struct ieee80211_tx_queue_params *params)
+{
+	return 0;
+}
+
+static int bcm43xx_get_tx_stats(struct ieee80211_hw *hw,
+				struct ieee80211_tx_queue_stats *stats)
+{
+	struct bcm43xx_wl *wl = hw_to_bcm43xx_wl(hw);
+	struct bcm43xx_wldev *dev = wl->current_dev;
+	unsigned long flags;
+	int err = -ENODEV;
+
+	if (!dev)
+		goto out;
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	if (likely(bcm43xx_status(dev) >= BCM43xx_STAT_STARTED)) {
+		if (bcm43xx_using_pio(dev))
+			bcm43xx_pio_get_tx_stats(dev, stats);
+		else
+			bcm43xx_dma_get_tx_stats(dev, stats);
+		err = 0;
 	}
-out_switch_back:
-	err = bcm43xx_switch_core(bcm, old_core);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
 out:
 	return err;
 }
 
-static void bcm43xx_periodic_every120sec(struct bcm43xx_private *bcm)
+static int bcm43xx_get_stats(struct ieee80211_hw *hw,
+			     struct ieee80211_low_level_stats *stats)
 {
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
+	struct bcm43xx_wl *wl = hw_to_bcm43xx_wl(hw);
+	unsigned long flags;
 
-	if (phy->type != BCM43xx_PHYTYPE_G || phy->rev < 2)
-		return;
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	memcpy(stats, &wl->ieee_stats, sizeof(*stats));
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
-	bcm43xx_mac_suspend(bcm);
-	bcm43xx_phy_lo_g_measure(bcm);
-	bcm43xx_mac_enable(bcm);
+	return 0;
 }
 
-static void bcm43xx_periodic_every60sec(struct bcm43xx_private *bcm)
+static int bcm43xx_dev_reset(struct ieee80211_hw *hw)
 {
-	bcm43xx_phy_lo_mark_all_unused(bcm);
-	if (bcm->sprom.boardflags & BCM43xx_BFL_RSSI) {
-		bcm43xx_mac_suspend(bcm);
-		bcm43xx_calc_nrssi_slope(bcm);
-		bcm43xx_mac_enable(bcm);
-	}
-}
+	struct bcm43xx_wl *wl = hw_to_bcm43xx_wl(hw);
+	struct bcm43xx_wldev *dev = wl->current_dev;
+	unsigned long flags;
 
-static void bcm43xx_periodic_every30sec(struct bcm43xx_private *bcm)
-{
-	/* Update device statistics. */
-	bcm43xx_calculate_link_quality(bcm);
+	if (!dev)
+		return -ENODEV;
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	bcm43xx_controller_restart(dev, "Reset by ieee80211 subsystem");
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+
+	return 0;
 }
 
-static void bcm43xx_periodic_every15sec(struct bcm43xx_private *bcm)
+static const char *phymode_to_string(unsigned int phymode)
 {
-	bcm43xx_phy_xmitpower(bcm); //FIXME: unless scanning?
-	//TODO for APHY (temperature?)
+	switch (phymode) {
+	case BCM43xx_PHYMODE_B:
+		return "B";
+	case BCM43xx_PHYMODE_G:
+		return "G";
+	default:
+		BCM43xx_BUG_ON(1);
+	}
+	return "";
 }
 
-static void bcm43xx_periodic_every1sec(struct bcm43xx_private *bcm)
+static int find_wldev_for_phymode(struct bcm43xx_wl *wl,
+				  unsigned int phymode,
+				  struct bcm43xx_wldev **dev,
+				  bool *gmode)
 {
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
-	int radio_hw_enable;
+	struct bcm43xx_wldev *d;
 
-	/* check if radio hardware enabled status changed */
-	radio_hw_enable = bcm43xx_is_hw_radio_enabled(bcm);
-	if (unlikely(bcm->radio_hw_enable != radio_hw_enable)) {
-		bcm->radio_hw_enable = radio_hw_enable;
-		dprintk(KERN_INFO PFX "Radio hardware status changed to %s\n",
-		       (radio_hw_enable == 0) ? "disabled" : "enabled");
-		bcm43xx_leds_update(bcm, 0);
-	}
-	if (phy->type == BCM43xx_PHYTYPE_G) {
-		//TODO: update_aci_moving_average
-		if (radio->aci_enable && radio->aci_wlan_automatic) {
-			bcm43xx_mac_suspend(bcm);
-			if (!radio->aci_enable && 1 /*TODO: not scanning? */) {
-				if (0 /*TODO: bunch of conditions*/) {
-					bcm43xx_radio_set_interference_mitigation(bcm,
-										  BCM43xx_RADIO_INTERFMODE_MANUALWLAN);
-				}
-			} else if (1/*TODO*/) {
-				/*
-				if ((aci_average > 1000) && !(bcm43xx_radio_aci_scan(bcm))) {
-					bcm43xx_radio_set_interference_mitigation(bcm,
-										  BCM43xx_RADIO_INTERFMODE_NONE);
-				}
-				*/
-			}
-			bcm43xx_mac_enable(bcm);
-		} else if (radio->interfmode == BCM43xx_RADIO_INTERFMODE_NONWLAN &&
-			   phy->rev == 1) {
-			//TODO: implement rev1 workaround
+	list_for_each_entry(d, &wl->devlist, list) {
+		if (d->phy.possible_phymodes & phymode) {
+			/* Ok, this device supports the PHY-mode.
+			 * Set the gmode bit. */
+			*gmode = 1;
+			*dev = d;
+
+			return 0;
 		}
 	}
+
+	return -ESRCH;
 }
 
-static void do_periodic_work(struct bcm43xx_private *bcm)
+static void bcm43xx_put_phy_into_reset(struct bcm43xx_wldev *dev)
 {
-	if (bcm->periodic_state % 120 == 0)
-		bcm43xx_periodic_every120sec(bcm);
-	if (bcm->periodic_state % 60 == 0)
-		bcm43xx_periodic_every60sec(bcm);
-	if (bcm->periodic_state % 30 == 0)
-		bcm43xx_periodic_every30sec(bcm);
-	if (bcm->periodic_state % 15 == 0)
-		bcm43xx_periodic_every15sec(bcm);
-	bcm43xx_periodic_every1sec(bcm);
+	struct ssb_device *sdev = dev->dev;
+	u32 tmslow;
 
-	schedule_delayed_work(&bcm->periodic_work, HZ);
+	tmslow = ssb_read32(sdev, SSB_TMSLOW);
+	tmslow &= ~BCM43xx_TMSLOW_GMODE;
+	tmslow |= BCM43xx_TMSLOW_PHYRESET;
+	tmslow |= SSB_TMSLOW_FGC;
+	ssb_write32(sdev, SSB_TMSLOW, tmslow);
+	msleep(1);
+
+	tmslow = ssb_read32(sdev, SSB_TMSLOW);
+	tmslow &= ~SSB_TMSLOW_FGC;
+	tmslow |= BCM43xx_TMSLOW_PHYRESET;
+	ssb_write32(sdev, SSB_TMSLOW, tmslow);
+	msleep(1);
 }
 
-static void bcm43xx_periodic_work_handler(struct work_struct *work)
+/* Expects wl->mutex locked */
+static int bcm43xx_switch_phymode(struct bcm43xx_wl *wl,
+				  unsigned int new_mode)
 {
-	struct bcm43xx_private *bcm =
-		container_of(work, struct bcm43xx_private, periodic_work.work);
-	struct net_device *net_dev = bcm->net_dev;
-	unsigned long flags;
-	u32 savedirqs = 0;
-	unsigned long orig_trans_start = 0;
-
-	mutex_lock(&bcm->mutex);
-	if (unlikely(bcm->periodic_state % 60 == 0)) {
-		/* Periodic work will take a long time, so we want it to
-		 * be preemtible.
-		 */
+	struct bcm43xx_wldev *up_dev;
+	struct bcm43xx_wldev *down_dev;
+	int err;
+	bool gmode = 0;
+	int prev_status;
 
-		netif_tx_lock_bh(net_dev);
-		/* We must fake a started transmission here, as we are going to
-		 * disable TX. If we wouldn't fake a TX, it would be possible to
-		 * trigger the netdev watchdog, if the last real TX is already
-		 * some time on the past (slightly less than 5secs)
-		 */
-		orig_trans_start = net_dev->trans_start;
-		net_dev->trans_start = jiffies;
-		netif_stop_queue(net_dev);
-		netif_tx_unlock_bh(net_dev);
-
-		spin_lock_irqsave(&bcm->irq_lock, flags);
-		bcm43xx_mac_suspend(bcm);
-		if (bcm43xx_using_pio(bcm))
-			bcm43xx_pio_freeze_txqueues(bcm);
-		savedirqs = bcm43xx_interrupt_disable(bcm, BCM43xx_IRQ_ALL);
-		spin_unlock_irqrestore(&bcm->irq_lock, flags);
-		bcm43xx_synchronize_irq(bcm);
-	} else {
-		/* Periodic work should take short time, so we want low
-		 * locking overhead.
-		 */
-		spin_lock_irqsave(&bcm->irq_lock, flags);
+	err = find_wldev_for_phymode(wl, new_mode, &up_dev, &gmode);
+	if (err) {
+		bcmerr(wl, "Could not find a device for %s-PHY mode\n",
+		       phymode_to_string(new_mode));
+		return err;
 	}
-
-	do_periodic_work(bcm);
-
-	if (unlikely(bcm->periodic_state % 60 == 0)) {
-		spin_lock_irqsave(&bcm->irq_lock, flags);
-		tasklet_enable(&bcm->isr_tasklet);
-		bcm43xx_interrupt_enable(bcm, savedirqs);
-		if (bcm43xx_using_pio(bcm))
-			bcm43xx_pio_thaw_txqueues(bcm);
-		bcm43xx_mac_enable(bcm);
-		netif_wake_queue(bcm->net_dev);
-		net_dev->trans_start = orig_trans_start;
+	if ((up_dev == wl->current_dev) &&
+	    (!!wl->current_dev->phy.gmode == !!gmode))
+		/* This device is already running. */
+		return 0;
+	bcmdbg(wl, "Reconfiguring PHYmode to %s-PHY\n",
+	       phymode_to_string(new_mode));
+	down_dev = wl->current_dev;
+
+	prev_status = bcm43xx_status(down_dev);
+	/* Shutdown the currently running core. */
+	if (prev_status >= BCM43xx_STAT_STARTED)
+		bcm43xx_wireless_core_stop(down_dev);
+	if (prev_status >= BCM43xx_STAT_INITIALIZED)
+		bcm43xx_wireless_core_exit(down_dev);
+
+	if (down_dev != up_dev)
+		/* We switch to a different core, so we put PHY into
+		 * RESET on the old core. */
+		bcm43xx_put_phy_into_reset(down_dev);
+
+	/* Now start the new core. */
+	up_dev->phy.gmode = gmode;
+	if (prev_status >= BCM43xx_STAT_INITIALIZED) {
+		err = bcm43xx_wireless_core_init(up_dev);
+		if (err) {
+			bcmerr(wl, "Fatal: Could not initialize device for "
+			       "newly selected %s-PHY mode\n",
+			       phymode_to_string(new_mode));
+			goto init_failure;
+		}
 	}
-	mmiowb();
-	bcm->periodic_state++;
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
-	mutex_unlock(&bcm->mutex);
-}
+	if (prev_status >= BCM43xx_STAT_STARTED) {
+		err = bcm43xx_wireless_core_start(up_dev);
+		if (err) {
+			bcmerr(wl, "Fatal: Coult not start device for "
+			       "newly selected %s-PHY mode\n",
+			       phymode_to_string(new_mode));
+			bcm43xx_wireless_core_exit(up_dev);
+			goto init_failure;
+		}
+	}
+	BCM43xx_WARN_ON(bcm43xx_status(up_dev) != prev_status);
 
-void bcm43xx_periodic_tasks_delete(struct bcm43xx_private *bcm)
-{
-	cancel_rearming_delayed_work(&bcm->periodic_work);
-}
+	bcm43xx_shm_write32(up_dev, BCM43xx_SHM_SHARED, 0x003E, 0);
 
-void bcm43xx_periodic_tasks_setup(struct bcm43xx_private *bcm)
-{
-	struct delayed_work *work = &bcm->periodic_work;
+	wl->current_dev = up_dev;
 
-	assert(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED);
-	INIT_DELAYED_WORK(work, bcm43xx_periodic_work_handler);
-	schedule_delayed_work(work, 0);
+	return 0;
+init_failure:
+	/* Whoops, failed to init the new core. No core is operating now. */
+	wl->current_dev = NULL;
+	return err;
 }
 
-static void bcm43xx_security_init(struct bcm43xx_private *bcm)
+static int bcm43xx_antenna_from_ieee80211(u8 antenna)
 {
-	bcm->security_offset = bcm43xx_shm_read16(bcm, BCM43xx_SHM_SHARED,
-						  0x0056) * 2;
-	bcm43xx_clear_keys(bcm);
+	switch (antenna) {
+	case 0: /* default/diversity */
+		return BCM43xx_ANTENNA_DEFAULT;
+	case 1: /* Antenna 0 */
+		return BCM43xx_ANTENNA0;
+	case 2: /* Antenna 1 */
+		return BCM43xx_ANTENNA1;
+	default:
+		return BCM43xx_ANTENNA_DEFAULT;
+	}
 }
 
-static int bcm43xx_rng_read(struct hwrng *rng, u32 *data)
+static int bcm43xx_dev_config(struct ieee80211_hw *hw,
+			      struct ieee80211_conf *conf)
 {
-	struct bcm43xx_private *bcm = (struct bcm43xx_private *)rng->priv;
+	struct bcm43xx_wl *wl = hw_to_bcm43xx_wl(hw);
+	struct bcm43xx_wldev *dev;
+	struct bcm43xx_phy *phy;
 	unsigned long flags;
+	unsigned int new_phymode = 0xFFFF;
+	int antenna_tx;
+	int antenna_rx;
+	int err = 0;
+	u32 savedirqs;
 
-	spin_lock_irqsave(&(bcm)->irq_lock, flags);
-	*data = bcm43xx_read16(bcm, BCM43xx_MMIO_RNG);
-	spin_unlock_irqrestore(&(bcm)->irq_lock, flags);
-
-	return (sizeof(u16));
-}
-
-static void bcm43xx_rng_exit(struct bcm43xx_private *bcm)
-{
-	hwrng_unregister(&bcm->rng);
-}
+	antenna_tx = bcm43xx_antenna_from_ieee80211(conf->antenna_sel_tx);
+	antenna_rx = bcm43xx_antenna_from_ieee80211(conf->antenna_sel_rx);
 
-static int bcm43xx_rng_init(struct bcm43xx_private *bcm)
-{
-	int err;
+	mutex_lock(&wl->mutex);
 
-	snprintf(bcm->rng_name, ARRAY_SIZE(bcm->rng_name),
-		 "%s_%s", KBUILD_MODNAME, bcm->net_dev->name);
-	bcm->rng.name = bcm->rng_name;
-	bcm->rng.data_read = bcm43xx_rng_read;
-	bcm->rng.priv = (unsigned long)bcm;
-	err = hwrng_register(&bcm->rng);
+	/* Switch the PHY mode (if necessary). */
+	switch (conf->phymode) {
+	case MODE_IEEE80211B:
+		new_phymode = BCM43xx_PHYMODE_B;
+		break;
+	case MODE_IEEE80211G:
+		new_phymode = BCM43xx_PHYMODE_G;
+		break;
+	default:
+		BCM43xx_BUG_ON(1);
+	}
+	err = bcm43xx_switch_phymode(wl, new_phymode);
 	if (err)
-		printk(KERN_ERR PFX "RNG init failed (%d)\n", err);
-
-	return err;
-}
+		goto out_unlock_mutex;
+	dev = wl->current_dev;
+	phy = &dev->phy;
+
+	/* Disable IRQs while reconfiguring the device.
+	 * This makes it possible to drop the spinlock throughout
+	 * the reconfiguration process. */
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	if (bcm43xx_status(dev) < BCM43xx_STAT_STARTED) {
+		spin_unlock_irqrestore(&wl->irq_lock, flags);
+		goto out_unlock_mutex;
+	}
+	savedirqs = bcm43xx_interrupt_disable(dev, BCM43xx_IRQ_ALL);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	bcm43xx_synchronize_irq(dev);
+
+	/* Switch to the requested channel.
+	 * The firmware takes care of races with the TX handler. */
+	if (conf->channel_val != phy->channel)
+		bcm43xx_radio_selectchannel(dev, conf->channel_val, 0);
+
+	/* Enable/Disable ShortSlot timing. */
+	if ((!!(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME))
+	     != dev->short_slot) {
+		BCM43xx_WARN_ON(phy->type != BCM43xx_PHYTYPE_G);
+		if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME)
+			bcm43xx_short_slot_timing_enable(dev);
+		else
+			bcm43xx_short_slot_timing_disable(dev);
+	}
 
-static int bcm43xx_shutdown_all_wireless_cores(struct bcm43xx_private *bcm)
-{
-	int ret = 0;
-	int i, err;
-	struct bcm43xx_coreinfo *core;
-
-	bcm43xx_set_status(bcm, BCM43xx_STAT_SHUTTINGDOWN);
-	for (i = 0; i < bcm->nr_80211_available; i++) {
-		core = &(bcm->core_80211[i]);
-		assert(core->available);
-		if (!core->initialized)
-			continue;
-		err = bcm43xx_switch_core(bcm, core);
-		if (err) {
-			dprintk(KERN_ERR PFX "shutdown_all_wireless_cores "
-					     "switch_core failed (%d)\n", err);
-			ret = err;
-			continue;
+	/* Adjust the desired TX power level. */
+	if (conf->power_level != 0) {
+		if (conf->power_level != phy->power_level) {
+			phy->power_level = conf->power_level;
+			bcm43xx_phy_xmitpower(dev);
 		}
-		bcm43xx_interrupt_disable(bcm, BCM43xx_IRQ_ALL);
-		bcm43xx_read32(bcm, BCM43xx_MMIO_GEN_IRQ_REASON); /* dummy read */
-		bcm43xx_wireless_core_cleanup(bcm);
-		if (core == bcm->active_80211_core)
-			bcm->active_80211_core = NULL;
 	}
-	free_irq(bcm->irq, bcm);
-	bcm43xx_set_status(bcm, BCM43xx_STAT_UNINIT);
 
-	return ret;
-}
+	/* Hide/Show the SSID (AP mode only). */
+	if (conf->flags & IEEE80211_CONF_SSID_HIDDEN)
+		bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD,
+				bcm43xx_read32(dev,
+				BCM43xx_MMIO_STATUS_BITFIELD)
+				| BCM43xx_SBF_NO_SSID_BCAST);
+	else
+		bcm43xx_write32(dev, BCM43xx_MMIO_STATUS_BITFIELD,
+				bcm43xx_read32(dev,
+				BCM43xx_MMIO_STATUS_BITFIELD)
+				& ~BCM43xx_SBF_NO_SSID_BCAST);
 
-/* This is the opposite of bcm43xx_init_board() */
-static void bcm43xx_free_board(struct bcm43xx_private *bcm)
-{
-	bcm43xx_rng_exit(bcm);
-	bcm43xx_sysfs_unregister(bcm);
-	bcm43xx_periodic_tasks_delete(bcm);
+	/* Antennas for RX and management frame TX. */
+	bcm43xx_mgmtframe_txantenna(dev, antenna_tx);
 
-	mutex_lock(&(bcm)->mutex);
-	bcm43xx_shutdown_all_wireless_cores(bcm);
-	bcm43xx_pctl_set_crystal(bcm, 0);
-	mutex_unlock(&(bcm)->mutex);
-}
+	/* Update templates for AP mode. */
+	if (bcm43xx_is_mode(wl, IEEE80211_IF_TYPE_AP))
+		bcm43xx_set_beacon_int(dev, conf->beacon_int);
 
-static void prepare_phydata_for_init(struct bcm43xx_phyinfo *phy)
-{
-	phy->antenna_diversity = 0xFFFF;
-	memset(phy->minlowsig, 0xFF, sizeof(phy->minlowsig));
-	memset(phy->minlowsigpos, 0, sizeof(phy->minlowsigpos));
 
-	/* Flags */
-	phy->calibrated = 0;
-	phy->is_locked = 0;
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	bcm43xx_interrupt_enable(dev, savedirqs);
+	mmiowb();
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+out_unlock_mutex:
+	mutex_unlock(&wl->mutex);
 
-	if (phy->_lo_pairs) {
-		memset(phy->_lo_pairs, 0,
-		       sizeof(struct bcm43xx_lopair) * BCM43xx_LO_COUNT);
-	}
-	memset(phy->loopback_gain, 0, sizeof(phy->loopback_gain));
+	return err;
 }
 
-static void prepare_radiodata_for_init(struct bcm43xx_private *bcm,
-				       struct bcm43xx_radioinfo *radio)
+static int bcm43xx_dev_set_key(struct ieee80211_hw *hw,
+			       set_key_cmd cmd,
+			       u8 *addr,
+			       struct ieee80211_key_conf *key,
+			       int aid)
 {
-	int i;
-
-	/* Set default attenuation values. */
-	radio->baseband_atten = bcm43xx_default_baseband_attenuation(bcm);
-	radio->radio_atten = bcm43xx_default_radio_attenuation(bcm);
-	radio->txctl1 = bcm43xx_default_txctl1(bcm);
-	radio->txctl2 = 0xFFFF;
-	radio->txpwr_offset = 0;
+	struct bcm43xx_wl *wl = hw_to_bcm43xx_wl(hw);
+	struct bcm43xx_wldev *dev = wl->current_dev;
+	unsigned long flags;
+	u8 algorithm;
+	u8 index;
+	int err = -EINVAL;
 
-	/* NRSSI */
-	radio->nrssislope = 0;
-	for (i = 0; i < ARRAY_SIZE(radio->nrssi); i++)
-		radio->nrssi[i] = -1000;
-	for (i = 0; i < ARRAY_SIZE(radio->nrssi_lt); i++)
-		radio->nrssi_lt[i] = i;
+	if (!dev)
+		return -ENODEV;
+	switch (key->alg) {
+	case ALG_NONE:
+	case ALG_NULL:
+		algorithm = BCM43xx_SEC_ALGO_NONE;
+		break;
+	case ALG_WEP:
+		if (key->keylen == 5)
+			algorithm = BCM43xx_SEC_ALGO_WEP40;
+		else
+			algorithm = BCM43xx_SEC_ALGO_WEP104;
+		break;
+	case ALG_TKIP:
+		algorithm = BCM43xx_SEC_ALGO_TKIP;
+		break;
+	case ALG_CCMP:
+		algorithm = BCM43xx_SEC_ALGO_AES;
+		break;
+	default:
+		BCM43xx_BUG_ON(1);
+		goto out;
+	}
 
-	radio->lofcal = 0xFFFF;
-	radio->initval = 0xFFFF;
+	index = (u8)(key->keyidx);
+	if (index > 3)
+		goto out;
 
-	radio->aci_enable = 0;
-	radio->aci_wlan_automatic = 0;
-	radio->aci_hw_rssi = 0;
-}
+	mutex_lock(&wl->mutex);
+	spin_lock_irqsave(&wl->irq_lock, flags);
 
-static void prepare_priv_for_init(struct bcm43xx_private *bcm)
-{
-	int i;
-	struct bcm43xx_coreinfo *core;
-	struct bcm43xx_coreinfo_80211 *wlext;
+	if (bcm43xx_status(dev) != BCM43xx_STAT_INITIALIZED) {
+		err = -ENODEV;
+		goto out_unlock;
+	}
 
-	assert(!bcm->active_80211_core);
+	switch (cmd) {
+	case SET_KEY:
+		key->flags &= ~IEEE80211_KEY_FORCE_SW_ENCRYPT;
+
+		if (algorithm == BCM43xx_SEC_ALGO_TKIP)
+			/* FIXME: No TKIP hardware encryption for now. */
+			key->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
+
+		if (is_broadcast_ether_addr(addr))
+			/* addr is FF:FF:FF:FF:FF:FF for default keys */
+			err = bcm43xx_key_write(dev, index, algorithm,
+						key->key, key->keylen,
+						NULL, key);
+		else
+			err = bcm43xx_key_write(dev, -1, algorithm,
+						key->key, key->keylen,
+						addr, key);
+		if (err) {
+			key->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
+			goto out_unlock;
+		}
+		dev->key[key->hw_key_idx].enabled = 1;
 
-	bcm43xx_set_status(bcm, BCM43xx_STAT_INITIALIZING);
+	case DISABLE_KEY: {
+		static const u8 zero[BCM43xx_SEC_KEYSIZE] = { 0 };
 
-	/* Flags */
-	bcm->was_initialized = 0;
-	bcm->reg124_set_0x4 = 0;
+		algorithm = BCM43xx_SEC_ALGO_NONE;
+		if (is_broadcast_ether_addr(addr))
+			err = bcm43xx_key_write(dev, index, algorithm,
+						zero, BCM43xx_SEC_KEYSIZE,
+						NULL, key);
+		else
+			err = bcm43xx_key_write(dev, -1, algorithm,
+						zero, BCM43xx_SEC_KEYSIZE,
+						addr, key);
+		dev->key[key->hw_key_idx].enabled = 0;
+		break;
+	}
+	case REMOVE_ALL_KEYS:
+		bcm43xx_clear_keys(dev);
+		err = 0;
+		break;
+	default:
+		BCM43xx_BUG_ON(1);
+	}
+out_unlock:
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	mutex_unlock(&wl->mutex);
+out:
+	if (!err)
+		bcmdbg(wl, "Using %s based encryption for keyidx: %d, "
+		       "mac: " MAC_FMT "\n",
+		       (key->flags & IEEE80211_KEY_FORCE_SW_ENCRYPT) ?
+		       "software" : "hardware",
+		       key->keyidx, MAC_ARG(addr));
+	return err;
+}
 
-	/* Stats */
-	memset(&bcm->stats, 0, sizeof(bcm->stats));
+static void bcm43xx_set_multicast_list(struct ieee80211_hw *hw,
+				       unsigned short netflags,
+				       int mc_count)
+{
+	struct bcm43xx_wl *wl = hw_to_bcm43xx_wl(hw);
+	struct bcm43xx_wldev *dev = wl->current_dev;
+	unsigned long flags;
 
-	/* Wireless core data */
-	for (i = 0; i < BCM43xx_MAX_80211_CORES; i++) {
-		core = &(bcm->core_80211[i]);
-		wlext = core->priv;
+	if (!dev)
+		return;
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	if (wl->promisc != !!(netflags & IFF_PROMISC)) {
+		wl->promisc = !!(netflags & IFF_PROMISC);
+		if (bcm43xx_status(dev) == BCM43xx_STAT_INITIALIZED)
+			bcm43xx_adjust_opmode(dev);
+	}
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+}
 
-		if (!core->available)
-			continue;
-		assert(wlext == &(bcm->core_80211_ext[i]));
+static int bcm43xx_config_interface(struct ieee80211_hw *hw,
+				    int if_id,
+				    struct ieee80211_if_conf *conf)
+{
+	struct bcm43xx_wl *wl = hw_to_bcm43xx_wl(hw);
+	struct bcm43xx_wldev *dev = wl->current_dev;
+	unsigned long flags;
 
-		prepare_phydata_for_init(&wlext->phy);
-		prepare_radiodata_for_init(bcm, &wlext->radio);
+	if (!dev)
+		return -ENODEV;
+	mutex_lock(&wl->mutex);
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
+		BCM43xx_WARN_ON(wl->if_id != if_id);
+		wl->bssid = conf->bssid;
+		if (bcm43xx_is_mode(wl, IEEE80211_IF_TYPE_AP)) {
+			BCM43xx_WARN_ON(conf->type != IEEE80211_IF_TYPE_AP);
+			bcm43xx_set_ssid(dev, conf->ssid, conf->ssid_len);
+			if (conf->beacon)
+				bcm43xx_refresh_templates(dev, conf->beacon);
+		}
+		bcm43xx_write_mac_bssid_templates(dev);
 	}
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	mutex_unlock(&wl->mutex);
 
-	/* IRQ related flags */
-	bcm->irq_reason = 0;
-	memset(bcm->dma_reason, 0, sizeof(bcm->dma_reason));
-	bcm->irq_savedstate = BCM43xx_IRQ_INITIAL;
+	return 0;
+}
 
-	bcm->mac_suspended = 1;
+/* Locking: wl->mutex */
+static void bcm43xx_wireless_core_stop(struct bcm43xx_wldev *dev)
+{
+	struct bcm43xx_wl *wl = dev->wl;
+	unsigned long flags;
 
-	/* Noise calculation context */
-	memset(&bcm->noisecalc, 0, sizeof(bcm->noisecalc));
+	if (bcm43xx_status(dev) < BCM43xx_STAT_STARTED)
+		return;
+	bcm43xx_set_status(dev, BCM43xx_STAT_INITIALIZED);
 
-	/* Periodic work context */
-	bcm->periodic_state = 0;
+	mutex_unlock(&wl->mutex);
+	/* Must unlock as it would otherwise deadlock. No races here. */
+	bcm43xx_periodic_tasks_delete(dev);
+	flush_workqueue(dev->wl->hw->workqueue);
+	mutex_lock(&wl->mutex);
+
+	ieee80211_stop_queues(wl->hw); /* FIXME this could cause a deadlock */
+
+	/* Disable and sync interrupts. */
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	dev->irq_savedstate = bcm43xx_interrupt_disable(dev, BCM43xx_IRQ_ALL);
+	bcm43xx_read32(dev, BCM43xx_MMIO_GEN_IRQ_MASK); /* flush */
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	bcm43xx_synchronize_irq(dev);
+
+	bcm43xx_mac_suspend(dev);
+	free_irq(dev->dev->irq, dev);
+	bcmdbg(wl, "Wireless interface stopped\n");
 }
 
-static int wireless_core_up(struct bcm43xx_private *bcm,
-			    int active_wlcore)
+/* Locking: wl->mutex */
+static int bcm43xx_wireless_core_start(struct bcm43xx_wldev *dev)
 {
 	int err;
 
-	if (!bcm43xx_core_enabled(bcm))
-		bcm43xx_wireless_core_reset(bcm, 1);
-	if (!active_wlcore)
-		bcm43xx_wireless_core_mark_inactive(bcm);
-	err = bcm43xx_wireless_core_init(bcm, active_wlcore);
-	if (err)
+	BCM43xx_WARN_ON(bcm43xx_status(dev) != BCM43xx_STAT_INITIALIZED);
+
+	drain_txstatus_queue(dev);
+	err = request_irq(dev->dev->irq, bcm43xx_interrupt_handler,
+			  IRQF_SHARED, KBUILD_MODNAME, dev);
+	if (err) {
+		bcmerr(dev->wl, "Cannot request IRQ-%d\n",
+		       dev->dev->irq);
 		goto out;
-	if (!active_wlcore)
-		bcm43xx_radio_turn_off(bcm);
+	}
+	bcm43xx_mac_enable(dev);
+
+	bcm43xx_periodic_tasks_setup(dev);
+
+	ieee80211_start_queues(dev->wl->hw);
+	bcm43xx_set_status(dev, BCM43xx_STAT_STARTED);
+	bcm43xx_interrupt_enable(dev, dev->irq_savedstate);
+	bcmdbg(dev->wl, "Wireless interface started\n");
 out:
 	return err;
 }
 
-/* Select and enable the "to be used" wireless core.
- * Locking: bcm->mutex must be aquired before calling this.
- *          bcm->irq_lock must not be aquired.
- */
-int bcm43xx_select_wireless_core(struct bcm43xx_private *bcm,
-				 int phytype)
+/* Get PHY and RADIO versioning numbers */
+static int bcm43xx_phy_versioning(struct bcm43xx_wldev *dev)
 {
-	int i, err;
-	struct bcm43xx_coreinfo *active_core = NULL;
-	struct bcm43xx_coreinfo_80211 *active_wlext = NULL;
-	struct bcm43xx_coreinfo *core;
-	struct bcm43xx_coreinfo_80211 *wlext;
-	int adjust_active_sbtmstatelow = 0;
-
-	might_sleep();
-
-	if (phytype < 0) {
-		/* If no phytype is requested, select the first core. */
-		assert(bcm->core_80211[0].available);
-		wlext = bcm->core_80211[0].priv;
-		phytype = wlext->phy.type;
-	}
-	/* Find the requested core. */
-	for (i = 0; i < bcm->nr_80211_available; i++) {
-		core = &(bcm->core_80211[i]);
-		wlext = core->priv;
-		if (wlext->phy.type == phytype) {
-			active_core = core;
-			active_wlext = wlext;
-			break;
-		}
+	struct bcm43xx_phy *phy = &dev->phy;
+	u32 tmp;
+	u8 analog_type;
+	u8 phy_type;
+	u8 phy_rev;
+	u16 radio_manuf;
+	u16 radio_ver;
+	u16 radio_rev;
+	int unsupported = 0;
+
+	/* Get PHY versioning */
+	tmp = bcm43xx_read16(dev, BCM43xx_MMIO_PHY_VER);
+	analog_type = (tmp & BCM43xx_PHYVER_ANALOG)
+		      >> BCM43xx_PHYVER_ANALOG_SHIFT;
+	phy_type = (tmp & BCM43xx_PHYVER_TYPE) >> BCM43xx_PHYVER_TYPE_SHIFT;
+	phy_rev = (tmp & BCM43xx_PHYVER_VERSION);
+	switch (phy_type) {
+	case BCM43xx_PHYTYPE_B:
+		if (phy_rev != 2 && phy_rev != 4
+		    && phy_rev != 6 && phy_rev != 7)
+			unsupported = 1;
+		break;
+	case BCM43xx_PHYTYPE_G:
+		if (phy_rev > 8)
+			unsupported = 1;
+		break;
+	default:
+		unsupported = 1;
+	};
+	if (unsupported) {
+		bcmerr(dev->wl, "FOUND UNSUPPORTED PHY "
+		       "(Analog %u, Type %u, Revision %u)\n",
+		       analog_type, phy_type, phy_rev);
+		return -EOPNOTSUPP;
+	}
+	bcmdbg(dev->wl, "Found PHY: Analog %u, Type %u, Revision %u\n",
+	       analog_type, phy_type, phy_rev);
+
+
+	/* Get RADIO versioning */
+	if (dev->dev->bus->chip_id == 0x4317) {
+		if (dev->dev->bus->chip_rev == 0)
+			tmp = 0x3205017F;
+		else if (dev->dev->bus->chip_rev == 1)
+			tmp = 0x4205017F;
+		else
+			tmp = 0x5205017F;
+	} else {
+		bcm43xx_write16(dev, BCM43xx_MMIO_RADIO_CONTROL,
+				BCM43xx_RADIOCTL_ID);
+		tmp = bcm43xx_read16(dev, BCM43xx_MMIO_RADIO_DATA_HIGH);
+		tmp <<= 16;
+		bcm43xx_write16(dev, BCM43xx_MMIO_RADIO_CONTROL,
+				BCM43xx_RADIOCTL_ID);
+		tmp |= bcm43xx_read16(dev, BCM43xx_MMIO_RADIO_DATA_LOW);
+	}
+	radio_manuf = (tmp & 0x00000FFF);
+	radio_ver = (tmp & 0x0FFFF000) >> 12;
+	radio_rev = (tmp & 0xF0000000) >> 28;
+	switch (phy_type) {
+	case BCM43xx_PHYTYPE_B:
+		if ((radio_ver & 0xFFF0) != 0x2050)
+			unsupported = 1;
+		break;
+	case BCM43xx_PHYTYPE_G:
+		if (radio_ver != 0x2050)
+			unsupported = 1;
+		break;
+	default:
+		BCM43xx_BUG_ON(1);
 	}
-	if (!active_core)
-		return -ESRCH; /* No such PHYTYPE on this board. */
-
-	if (bcm->active_80211_core) {
-		/* We already selected a wl core in the past.
-		 * So first clean up everything.
-		 */
-		dprintk(KERN_INFO PFX "select_wireless_core: cleanup\n");
-		ieee80211softmac_stop(bcm->net_dev);
-		bcm43xx_set_status(bcm, BCM43xx_STAT_INITIALIZED);
-		err = bcm43xx_disable_interrupts_sync(bcm);
-		assert(!err);
-		tasklet_enable(&bcm->isr_tasklet);
-		err = bcm43xx_shutdown_all_wireless_cores(bcm);
-		if (err)
-			goto error;
-		/* Ok, everything down, continue to re-initialize. */
-		bcm43xx_set_status(bcm, BCM43xx_STAT_INITIALIZING);
+	if (unsupported) {
+		bcmerr(dev->wl, "FOUND UNSUPPORTED RADIO "
+		       "(Manuf 0x%X, Version 0x%X, Revision %u)\n",
+		       radio_manuf, radio_ver, radio_rev);
+		return -EOPNOTSUPP;
 	}
+	bcmdbg(dev->wl, "Found Radio: Manuf 0x%X, Version 0x%X, Revision %u\n",
+	       radio_manuf, radio_ver, radio_rev);
 
-	/* Reset all data structures. */
-	prepare_priv_for_init(bcm);
 
-	err = bcm43xx_pctl_set_clock(bcm, BCM43xx_PCTL_CLK_FAST);
-	if (err)
-		goto error;
+	phy->radio_manuf = radio_manuf;
+	phy->radio_ver = radio_ver;
+	phy->radio_rev = radio_rev;
 
-	/* Mark all unused cores "inactive". */
-	for (i = 0; i < bcm->nr_80211_available; i++) {
-		core = &(bcm->core_80211[i]);
-		wlext = core->priv;
+	phy->analog = analog_type;
+	phy->type = phy_type;
+	phy->rev = phy_rev;
 
-		if (core == active_core)
-			continue;
-		err = bcm43xx_switch_core(bcm, core);
-		if (err) {
-			dprintk(KERN_ERR PFX "Could not switch to inactive "
-					     "802.11 core (%d)\n", err);
-			goto error;
-		}
-		err = wireless_core_up(bcm, 0);
-		if (err) {
-			dprintk(KERN_ERR PFX "core_up for inactive 802.11 core "
-					     "failed (%d)\n", err);
-			goto error;
-		}
-		adjust_active_sbtmstatelow = 1;
-	}
+	return 0;
+}
 
-	/* Now initialize the active 802.11 core. */
-	err = bcm43xx_switch_core(bcm, active_core);
-	if (err) {
-		dprintk(KERN_ERR PFX "Could not switch to active "
-				     "802.11 core (%d)\n", err);
-		goto error;
-	}
-	if (adjust_active_sbtmstatelow &&
-	    active_wlext->phy.type == BCM43xx_PHYTYPE_G) {
-		u32 sbtmstatelow;
-
-		sbtmstatelow = bcm43xx_read32(bcm, BCM43xx_CIR_SBTMSTATELOW);
-		sbtmstatelow |= BCM43xx_SBTMSTATELOW_G_MODE_ENABLE;
-		bcm43xx_write32(bcm, BCM43xx_CIR_SBTMSTATELOW, sbtmstatelow);
-	}
-	err = wireless_core_up(bcm, 1);
-	if (err) {
-		dprintk(KERN_ERR PFX "core_up for active 802.11 core "
-				     "failed (%d)\n", err);
-		goto error;
-	}
-	err = bcm43xx_pctl_set_clock(bcm, BCM43xx_PCTL_CLK_DYNAMIC);
-	if (err)
-		goto error;
-	bcm->active_80211_core = active_core;
+static void setup_struct_phy_for_init(struct bcm43xx_wldev *dev,
+				      struct bcm43xx_phy *phy)
+{
+	struct bcm43xx_lopair *lo;
+	int i;
 
-	bcm43xx_macfilter_clear(bcm, BCM43xx_MACFILTER_ASSOC);
-	bcm43xx_macfilter_set(bcm, BCM43xx_MACFILTER_SELF, (u8 *)(bcm->net_dev->dev_addr));
-	bcm43xx_security_init(bcm);
-	drain_txstatus_queue(bcm);
-	ieee80211softmac_start(bcm->net_dev);
+	memset(phy->minlowsig, 0xFF, sizeof(phy->minlowsig));
+	memset(phy->minlowsigpos, 0, sizeof(phy->minlowsigpos));
 
-	/* Let's go! Be careful after enabling the IRQs.
-	 * Don't switch cores, for example.
-	 */
-	bcm43xx_mac_enable(bcm);
-	bcm43xx_set_status(bcm, BCM43xx_STAT_INITIALIZED);
-	err = bcm43xx_initialize_irq(bcm);
-	if (err)
-		goto error;
-	bcm43xx_interrupt_enable(bcm, bcm->irq_savedstate);
+	/* Flags */
+	phy->locked = 0;
 
-	dprintk(KERN_INFO PFX "Selected 802.11 core (phytype %d)\n",
-		active_wlext->phy.type);
+	phy->savedpctlreg = 0xFFFF;
+	phy->aci_enable = 0;
+	phy->aci_wlan_automatic = 0;
+	phy->aci_hw_rssi = 0;
+
+	lo = phy->_lo_pairs;
+	if (lo)
+		memset(lo, 0, sizeof(struct bcm43xx_lopair) * BCM43xx_LO_COUNT);
+	phy->max_lb_gain = 0;
+	phy->trsw_rx_gain = 0;
 
-	return 0;
+	/* Set default attenuation values. */
+	phy->bbatt = bcm43xx_default_baseband_attenuation(dev);
+	phy->rfatt = bcm43xx_default_radio_attenuation(dev);
+	phy->txctl1 = bcm43xx_default_txctl1(dev);
+	phy->txpwr_offset = 0;
 
-error:
-	bcm43xx_set_status(bcm, BCM43xx_STAT_UNINIT);
-	bcm43xx_pctl_set_clock(bcm, BCM43xx_PCTL_CLK_SLOW);
-	return err;
-}
+	/* NRSSI */
+	phy->nrssislope = 0;
+	for (i = 0; i < ARRAY_SIZE(phy->nrssi); i++)
+		phy->nrssi[i] = -1000;
+	for (i = 0; i < ARRAY_SIZE(phy->nrssi_lt); i++)
+		phy->nrssi_lt[i] = i;
 
-static int bcm43xx_init_board(struct bcm43xx_private *bcm)
-{
-	int err;
+	phy->lofcal = 0xFFFF;
+	phy->initval = 0xFFFF;
 
-	mutex_lock(&(bcm)->mutex);
+	spin_lock_init(&phy->lock);
+	phy->interfmode = BCM43xx_INTERFMODE_NONE;
+	phy->channel = 0xFF;
+}
 
-	tasklet_enable(&bcm->isr_tasklet);
-	err = bcm43xx_pctl_set_crystal(bcm, 1);
-	if (err)
-		goto err_tasklet;
-	err = bcm43xx_pctl_init(bcm);
-	if (err)
-		goto err_crystal_off;
-	err = bcm43xx_select_wireless_core(bcm, -1);
-	if (err)
-		goto err_crystal_off;
-	err = bcm43xx_sysfs_register(bcm);
-	if (err)
-		goto err_wlshutdown;
-	err = bcm43xx_rng_init(bcm);
-	if (err)
-		goto err_sysfs_unreg;
-	bcm43xx_periodic_tasks_setup(bcm);
+static void setup_struct_wldev_for_init(struct bcm43xx_wldev *dev)
+{
+	/* Flags */
+	dev->reg124_set_0x4 = 0;
 
-	/*FIXME: This should be handled by softmac instead. */
-	schedule_delayed_work(&bcm->softmac->associnfo.work, 0);
+	/* Stats */
+	memset(&dev->stats, 0, sizeof(dev->stats));
 
-out:
-	mutex_unlock(&(bcm)->mutex);
+	setup_struct_phy_for_init(dev, &dev->phy);
 
-	return err;
+	/* IRQ related flags */
+	dev->irq_reason = 0;
+	memset(dev->dma_reason, 0, sizeof(dev->dma_reason));
+	dev->irq_savedstate = BCM43xx_IRQ_MASKTEMPLATE;
 
-err_sysfs_unreg:
-	bcm43xx_sysfs_unregister(bcm);
-err_wlshutdown:
-	bcm43xx_shutdown_all_wireless_cores(bcm);
-err_crystal_off:
-	bcm43xx_pctl_set_crystal(bcm, 0);
-err_tasklet:
-	tasklet_disable(&bcm->isr_tasklet);
-	goto out;
+	dev->mac_suspended = 1;
+
+	/* Noise calculation context */
+	memset(&dev->noisecalc, 0, sizeof(dev->noisecalc));
 }
 
-static void bcm43xx_detach_board(struct bcm43xx_private *bcm)
+static void bcm43xx_imcfglo_timeouts_workaround(struct bcm43xx_wldev *dev)
 {
-	struct pci_dev *pci_dev = bcm->pci_dev;
-	int i;
+#ifdef CONFIG_SSB_DRIVER_PCICORE
+	struct ssb_bus *bus = dev->dev->bus;
+	u32 tmp;
 
-	bcm43xx_chipset_detach(bcm);
-	/* Do _not_ access the chip, after it is detached. */
-	pci_iounmap(pci_dev, bcm->mmio_addr);
-	pci_release_regions(pci_dev);
-	pci_disable_device(pci_dev);
-
-	/* Free allocated structures/fields */
-	for (i = 0; i < BCM43xx_MAX_80211_CORES; i++) {
-		kfree(bcm->core_80211_ext[i].phy._lo_pairs);
-		if (bcm->core_80211_ext[i].phy.dyn_tssi_tbl)
-			kfree(bcm->core_80211_ext[i].phy.tssi2dbm);
+	if (bus->pcicore.dev &&
+	    bus->pcicore.dev->id.coreid == SSB_DEV_PCI &&
+	    bus->pcicore.dev->id.revision <= 5) {
+		/* IMCFGLO timeouts workaround. */
+		tmp = ssb_read32(dev->dev, SSB_IMCFGLO);
+		tmp &= ~SSB_IMCFGLO_REQTO;
+		tmp &= ~SSB_IMCFGLO_SERTO;
+		switch (bus->bustype) {
+		case SSB_BUSTYPE_PCI:
+		case SSB_BUSTYPE_PCMCIA:
+			tmp |= 0x32;
+			break;
+		case SSB_BUSTYPE_SSB:
+			tmp |= 0x53;
+			break;
+		}
+		ssb_write32(dev->dev, SSB_IMCFGLO, tmp);
 	}
-}	
+#endif /* CONFIG_SSB_DRIVER_PCICORE */
+}
 
-static int bcm43xx_read_phyinfo(struct bcm43xx_private *bcm)
+/* Shutdown a wireless core */
+static void bcm43xx_wireless_core_exit(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
-	u16 value;
-	u8 phy_analog;
-	u8 phy_type;
-	u8 phy_rev;
-	int phy_rev_ok = 1;
-	void *p;
+	struct bcm43xx_phy *phy = &dev->phy;
 
-	value = bcm43xx_read16(bcm, BCM43xx_MMIO_PHY_VER);
+	BCM43xx_WARN_ON(bcm43xx_status(dev) > BCM43xx_STAT_INITIALIZED);
+	if (bcm43xx_status(dev) != BCM43xx_STAT_INITIALIZED)
+		return;
 
-	phy_analog = (value & 0xF000) >> 12;
-	phy_type = (value & 0x0F00) >> 8;
-	phy_rev = (value & 0x000F);
+	bcm43xx_rng_exit(dev->wl);
+	bcm43xx_pio_free(dev);
+	bcm43xx_dma_free(dev);
+	bcm43xx_chip_exit(dev);
+	bcm43xx_radio_turn_off(dev);
+	bcm43xx_switch_analog(dev, 0);
+	if (phy->dyn_tssi_tbl)
+		kfree(phy->tssi2dbm);
+	kfree(phy->lo_control);
+	phy->lo_control = NULL;
+	ssb_device_disable(dev->dev, 0);
+	ssb_bus_may_powerdown(dev->dev->bus);
+	bcm43xx_set_status(dev, BCM43xx_STAT_UNINIT);
+}
 
-	dprintk(KERN_INFO PFX "Detected PHY: Analog: %x, Type %x, Revision %x\n",
-		phy_analog, phy_type, phy_rev);
+static void prepare_phy_data_for_init(struct bcm43xx_wldev *dev)
+{
+	struct bcm43xx_phy *phy = &dev->phy;
+	int i;
 
-	switch (phy_type) {
-	case BCM43xx_PHYTYPE_A:
-		if (phy_rev >= 4)
-			phy_rev_ok = 0;
-		/*FIXME: We need to switch the ieee->modulation, etc.. flags,
-		 *       if we switch 80211 cores after init is done.
-		 *       As we do not implement on the fly switching between
-		 *       wireless cores, I will leave this as a future task.
-		 */
-		bcm->ieee->modulation = IEEE80211_OFDM_MODULATION;
-		bcm->ieee->mode = IEEE_A;
-		bcm->ieee->freq_band = IEEE80211_52GHZ_BAND |
-				       IEEE80211_24GHZ_BAND;
-		break;
-	case BCM43xx_PHYTYPE_B:
-		if (phy_rev != 2 && phy_rev != 4 && phy_rev != 6 && phy_rev != 7)
-			phy_rev_ok = 0;
-		bcm->ieee->modulation = IEEE80211_CCK_MODULATION;
-		bcm->ieee->mode = IEEE_B;
-		bcm->ieee->freq_band = IEEE80211_24GHZ_BAND;
-		break;
-	case BCM43xx_PHYTYPE_G:
-		if (phy_rev > 8)
-			phy_rev_ok = 0;
-		bcm->ieee->modulation = IEEE80211_OFDM_MODULATION |
-					IEEE80211_CCK_MODULATION;
-		bcm->ieee->mode = IEEE_G;
-		bcm->ieee->freq_band = IEEE80211_24GHZ_BAND;
-		break;
-	default:
-		printk(KERN_ERR PFX "Error: Unknown PHY Type %x\n",
-		       phy_type);
-		return -ENODEV;
-	};
-	bcm->ieee->perfect_rssi = RX_RSSI_MAX;
-	bcm->ieee->worst_rssi = 0;
-	if (!phy_rev_ok) {
-		printk(KERN_WARNING PFX "Invalid PHY Revision %x\n",
-		       phy_rev);
-	}
+	/* Set default attenuation values. */
+	phy->bbatt = bcm43xx_default_baseband_attenuation(dev);
+	phy->rfatt = bcm43xx_default_radio_attenuation(dev);
+	phy->txctl1 = bcm43xx_default_txctl1(dev);
+	phy->txctl2 = 0xFFFF;
+	phy->txpwr_offset = 0;
 
-	phy->analog = phy_analog;
-	phy->type = phy_type;
-	phy->rev = phy_rev;
-	if ((phy_type == BCM43xx_PHYTYPE_B) || (phy_type == BCM43xx_PHYTYPE_G)) {
-		p = kzalloc(sizeof(struct bcm43xx_lopair) * BCM43xx_LO_COUNT,
-			    GFP_KERNEL);
-		if (!p)
-			return -ENOMEM;
-		phy->_lo_pairs = p;
-	}
+	/* NRSSI */
+	phy->nrssislope = 0;
+	for (i = 0; i < ARRAY_SIZE(phy->nrssi); i++)
+		phy->nrssi[i] = -1000;
+	for (i = 0; i < ARRAY_SIZE(phy->nrssi_lt); i++)
+		phy->nrssi_lt[i] = i;
+
+	phy->lofcal = 0xFFFF;
+	phy->initval = 0xFFFF;
+
+	phy->aci_enable = 0;
+	phy->aci_wlan_automatic = 0;
+	phy->aci_hw_rssi = 0;
 
-	return 0;
+	phy->antenna_diversity = 0xFFFF;
+	memset(phy->minlowsig, 0xFF, sizeof(phy->minlowsig));
+	memset(phy->minlowsigpos, 0, sizeof(phy->minlowsigpos));
+
+	/* Flags */
+	phy->calibrated = 0;
+	phy->locked = 0;
+
+	if (phy->_lo_pairs)
+		memset(phy->_lo_pairs, 0,
+		       sizeof(struct bcm43xx_lopair) * BCM43xx_LO_COUNT);
+	memset(phy->loopback_gain, 0, sizeof(phy->loopback_gain));
 }
 
-static int bcm43xx_attach_board(struct bcm43xx_private *bcm)
+/* Initialize a wireless core */
+static int bcm43xx_wireless_core_init(struct bcm43xx_wldev *dev)
 {
-	struct pci_dev *pci_dev = bcm->pci_dev;
-	struct net_device *net_dev = bcm->net_dev;
+	struct bcm43xx_wl *wl = dev->wl;
+	struct ssb_bus *bus = dev->dev->bus;
+	struct bcm43xx_phy *phy = &dev->phy;
+	struct ssb_sprom *sprom = &dev->dev->bus->sprom;
 	int err;
-	int i;
-	u32 coremask;
+	u32 hf;
+	u32 tmp;
 
-	err = pci_enable_device(pci_dev);
-	if (err) {
-		printk(KERN_ERR PFX "pci_enable_device() failed\n");
+	BCM43xx_WARN_ON(bcm43xx_status(dev) != BCM43xx_STAT_UNINIT);
+
+	err = ssb_bus_powerup(bus, 0);
+	if (err)
 		goto out;
+	if (!ssb_device_is_enabled(dev->dev)) {
+		tmp = phy->gmode ? BCM43xx_TMSLOW_GMODE : 0;
+		bcm43xx_wireless_core_reset(dev, tmp);
 	}
-	err = pci_request_regions(pci_dev, KBUILD_MODNAME);
-	if (err) {
-		printk(KERN_ERR PFX "pci_request_regions() failed\n");
-		goto err_pci_disable;
-	}
-	/* enable PCI bus-mastering */
-	pci_set_master(pci_dev);
-	bcm->mmio_addr = pci_iomap(pci_dev, 0, ~0UL);
-	if (!bcm->mmio_addr) {
-		printk(KERN_ERR PFX "pci_iomap() failed\n");
-		err = -EIO;
-		goto err_pci_release;
+
+	if ((phy->type == BCM43xx_PHYTYPE_B) ||
+	    (phy->type == BCM43xx_PHYTYPE_G)) {
+		phy->_lo_pairs = kzalloc(sizeof(struct bcm43xx_lopair)
+					 * BCM43xx_LO_COUNT,
+					 GFP_KERNEL);
+		if (!phy->_lo_pairs)
+			return -ENOMEM;
 	}
-	net_dev->base_addr = (unsigned long)bcm->mmio_addr;
+	setup_struct_wldev_for_init(dev);
 
-	err = bcm43xx_pci_read_config16(bcm, PCI_SUBSYSTEM_VENDOR_ID,
-	                          &bcm->board_vendor);
+	err = bcm43xx_phy_init_tssi2dbm_table(dev);
 	if (err)
-		goto err_iounmap;
-	err = bcm43xx_pci_read_config16(bcm, PCI_SUBSYSTEM_ID,
-	                          &bcm->board_type);
-	if (err)
-		goto err_iounmap;
+		goto err_kfree_lo_control;
 
-	bcm->board_revision = bcm->pci_dev->revision;
+	/* Enable IRQ routing to this device. */
+	ssb_pcicore_dev_irqvecs_enable(&bus->pcicore, dev->dev);
 
-	err = bcm43xx_chipset_attach(bcm);
-	if (err)
-		goto err_iounmap;
-	err = bcm43xx_pctl_init(bcm);
+	bcm43xx_imcfglo_timeouts_workaround(dev);
+	prepare_phy_data_for_init(dev);
+	bcm43xx_phy_calibrate(dev);
+	err = bcm43xx_chip_init(dev);
 	if (err)
-		goto err_chipset_detach;
-	err = bcm43xx_probe_cores(bcm);
-	if (err)
-		goto err_chipset_detach;
-	
-	/* Attach all IO cores to the backplane. */
-	coremask = 0;
-	for (i = 0; i < bcm->nr_80211_available; i++)
-		coremask |= (1 << bcm->core_80211[i].index);
-	//FIXME: Also attach some non80211 cores?
-	err = bcm43xx_setup_backplane_pci_connection(bcm, coremask);
-	if (err) {
-		printk(KERN_ERR PFX "Backplane->PCI connection failed!\n");
-		goto err_chipset_detach;
+		goto err_kfree_tssitbl;
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
+			    BCM43xx_SHM_SH_WLCOREREV,
+			    dev->dev->id.revision);
+	hf = bcm43xx_hf_read(dev);
+	if (phy->type == BCM43xx_PHYTYPE_G) {
+		hf |= BCM43xx_HF_SYMW;
+		if (phy->rev == 1)
+			hf |= BCM43xx_HF_GDCW;
+		if (sprom->r1.boardflags_lo & BCM43xx_BFL_PACTRL)
+			hf |= BCM43xx_HF_OFDMPABOOST;
+	} else if (phy->type == BCM43xx_PHYTYPE_B) {
+		hf |= BCM43xx_HF_SYMW;
+		if (phy->rev >= 2 && phy->radio_ver == 0x2050)
+			hf &= ~BCM43xx_HF_GDCW;
 	}
+	bcm43xx_hf_write(dev, hf);
 
-	err = bcm43xx_sprom_extract(bcm);
-	if (err)
-		goto err_chipset_detach;
-	err = bcm43xx_leds_init(bcm);
-	if (err)
-		goto err_chipset_detach;
-
-	for (i = 0; i < bcm->nr_80211_available; i++) {
-		err = bcm43xx_switch_core(bcm, &bcm->core_80211[i]);
-		assert(err != -ENODEV);
-		if (err)
-			goto err_80211_unwind;
+	/* Short/Long Retry Limit.
+	 * The retry-limit is a 4-bit counter. Enforce this to avoid overflowing
+	 * the chip-internal counter.
+	 */
+	tmp = limit_value(modparam_short_retry, 0, 0xF);
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_WIRELESS,
+			    0x0006, tmp);
+	dev->short_retry_limit = tmp;
+	tmp = limit_value(modparam_long_retry, 0, 0xF);
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_WIRELESS,
+			    0x0007, tmp);
+	dev->long_retry_limit = tmp;
+
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
+			    0x0044, 3);
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED,
+			    0x0046, 2);
 
-		/* Enable the selected wireless core.
-		 * Connect PHY only on the first core.
-		 */
-		bcm43xx_wireless_core_reset(bcm, (i == 0));
+	bcm43xx_rate_memory_init(dev);
 
-		err = bcm43xx_read_phyinfo(bcm);
-		if (err && (i == 0))
-			goto err_80211_unwind;
-
-		err = bcm43xx_read_radioinfo(bcm);
-		if (err && (i == 0))
-			goto err_80211_unwind;
-
-		err = bcm43xx_validate_chip(bcm);
-		if (err && (i == 0))
-			goto err_80211_unwind;
+	/* Minimum Contention Window */
+	if (phy->type == BCM43xx_PHYTYPE_B)
+		bcm43xx_shm_write16(dev, BCM43xx_SHM_WIRELESS,
+				    0x0003, 31);
+	else
+		bcm43xx_shm_write16(dev, BCM43xx_SHM_WIRELESS,
+				    0x0003, 15);
+	/* Maximum Contention Window */
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_WIRELESS,
+			    0x0004, 1023);
 
-		bcm43xx_radio_turn_off(bcm);
-		err = bcm43xx_phy_init_tssi2dbm_table(bcm);
-		if (err)
-			goto err_80211_unwind;
-		bcm43xx_wireless_core_disable(bcm);
-	}
-	err = bcm43xx_geo_init(bcm);
+	do {
+		if (bcm43xx_using_pio(dev)) {
+			err = bcm43xx_pio_init(dev);
+		} else {
+			err = bcm43xx_dma_init(dev);
+			if (!err)
+				bcm43xx_qos_init(dev);
+		}
+	} while (err == -EAGAIN);
 	if (err)
-		goto err_80211_unwind;
-	bcm43xx_pctl_set_crystal(bcm, 0);
+		goto err_chip_exit;
 
-	/* Set the MAC address in the networking subsystem */
-	if (is_valid_ether_addr(bcm->sprom.et1macaddr))
-		memcpy(bcm->net_dev->dev_addr, bcm->sprom.et1macaddr, 6);
-	else
-		memcpy(bcm->net_dev->dev_addr, bcm->sprom.il0macaddr, 6);
+	bcm43xx_write16(dev, 0x0612, 0x0050);
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, 0x0416, 0x0050);
+	bcm43xx_shm_write16(dev, BCM43xx_SHM_SHARED, 0x0414, 0x01F4);
+
+	ssb_bus_powerup(bus, 1); /* Enable dynamic PCTL */
+	wl->bssid = NULL;
+	bcm43xx_upload_card_macaddress(dev, NULL);
+	bcm43xx_security_init(dev);
+	bcm43xx_rng_init(wl);
 
-	snprintf(bcm->nick, IW_ESSID_MAX_SIZE,
-		 "Broadcom %04X", bcm->chip_id);
+	bcm43xx_set_status(dev, BCM43xx_STAT_INITIALIZED);
 
-	assert(err == 0);
 out:
 	return err;
 
-err_80211_unwind:
-	for (i = 0; i < BCM43xx_MAX_80211_CORES; i++) {
-		kfree(bcm->core_80211_ext[i].phy._lo_pairs);
-		if (bcm->core_80211_ext[i].phy.dyn_tssi_tbl)
-			kfree(bcm->core_80211_ext[i].phy.tssi2dbm);
-	}
-err_chipset_detach:
-	bcm43xx_chipset_detach(bcm);
-err_iounmap:
-	pci_iounmap(pci_dev, bcm->mmio_addr);
-err_pci_release:
-	pci_release_regions(pci_dev);
-err_pci_disable:
-	pci_disable_device(pci_dev);
-	printk(KERN_ERR PFX "Unable to attach board\n");
-	goto out;
+err_chip_exit:
+	bcm43xx_chip_exit(dev);
+err_kfree_tssitbl:
+	if (phy->dyn_tssi_tbl)
+		kfree(phy->tssi2dbm);
+err_kfree_lo_control:
+	kfree(phy->lo_control);
+	phy->lo_control = NULL;
+	ssb_bus_may_powerdown(bus);
+	BCM43xx_WARN_ON(bcm43xx_status(dev) != BCM43xx_STAT_UNINIT);
+	return err;
 }
 
-/* Do the Hardware IO operations to send the txb */
-static inline int bcm43xx_tx(struct bcm43xx_private *bcm,
-			     struct ieee80211_txb *txb)
+static int bcm43xx_add_interface(struct ieee80211_hw *hw,
+				 struct ieee80211_if_init_conf *conf)
 {
-	int err = -ENODEV;
+	struct bcm43xx_wl *wl = hw_to_bcm43xx_wl(hw);
+	struct bcm43xx_wldev *dev;
+	unsigned long flags;
+	int err = -EOPNOTSUPP;
+	int did_init = 0;
 
-	if (bcm43xx_using_pio(bcm))
-		err = bcm43xx_pio_tx(bcm, txb);
-	else
-		err = bcm43xx_dma_tx(bcm, txb);
-	bcm->net_dev->trans_start = jiffies;
+	mutex_lock(&wl->mutex);
+	if ((conf->type != IEEE80211_IF_TYPE_MNTR) &&
+	    wl->operating)
+		goto out_mutex_unlock;
+
+	bcmdbg(wl, "Adding Interface type %d\n", conf->type);
+
+	dev = wl->current_dev;
+	if (bcm43xx_status(dev) < BCM43xx_STAT_INITIALIZED) {
+		err = bcm43xx_wireless_core_init(dev);
+		if (err)
+			goto out_mutex_unlock;
+		did_init = 1;
+	}
+	if (bcm43xx_status(dev) < BCM43xx_STAT_STARTED) {
+		err = bcm43xx_wireless_core_start(dev);
+		if (err) {
+			if (did_init)
+				bcm43xx_wireless_core_exit(dev);
+			goto out_mutex_unlock;
+		}
+	}
+
+	spin_lock_irqsave(&wl->irq_lock, flags);
+	switch (conf->type) {
+	case IEEE80211_IF_TYPE_MNTR:
+		wl->monitor++;
+		break;
+	default:
+		wl->operating = 1;
+		wl->if_id = conf->if_id;
+		wl->if_type = conf->type;
+		bcm43xx_upload_card_macaddress(dev, conf->mac_addr);
+	}
+	bcm43xx_adjust_opmode(dev);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
+
+	err = 0;
+out_mutex_unlock:
+	mutex_unlock(&wl->mutex);
 
 	return err;
 }
 
-static void bcm43xx_ieee80211_set_chan(struct net_device *net_dev,
-				       u8 channel)
+static void bcm43xx_remove_interface(struct ieee80211_hw *hw,
+				     struct ieee80211_if_init_conf *conf)
 {
-	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
-	struct bcm43xx_radioinfo *radio;
+	struct bcm43xx_wl *wl = hw_to_bcm43xx_wl(hw);
+	struct bcm43xx_wldev *dev;
 	unsigned long flags;
 
-	mutex_lock(&bcm->mutex);
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-	if (bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED) {
-		bcm43xx_mac_suspend(bcm);
-		bcm43xx_radio_selectchannel(bcm, channel, 0);
-		bcm43xx_mac_enable(bcm);
+	bcmdbg(wl, "Removing Interface type %d\n", conf->type);
+
+	mutex_lock(&wl->mutex);
+	if (conf->type == IEEE80211_IF_TYPE_MNTR) {
+		wl->monitor--;
+		BCM43xx_WARN_ON(wl->monitor < 0);
 	} else {
-		radio = bcm43xx_current_radio(bcm);
-		radio->initial_channel = channel;
+		BCM43xx_WARN_ON(!wl->operating);
+		wl->operating = 0;
 	}
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
-	mutex_unlock(&bcm->mutex);
+
+	dev = wl->current_dev;
+	if (!wl->operating && wl->monitor == 0) {
+		/* No interface left. */
+		if (bcm43xx_status(dev) >= BCM43xx_STAT_STARTED)
+			bcm43xx_wireless_core_stop(dev);
+		bcm43xx_wireless_core_exit(dev);
+	} else {
+		/* Just monitor interfaces left. */
+		spin_lock_irqsave(&wl->irq_lock, flags);
+		bcm43xx_adjust_opmode(dev);
+		if (!wl->operating)
+			bcm43xx_upload_card_macaddress(dev, NULL);
+		spin_unlock_irqrestore(&wl->irq_lock, flags);
+	}
+	mutex_unlock(&wl->mutex);
 }
 
-/* set_security() callback in struct ieee80211_device */
-static void bcm43xx_ieee80211_set_security(struct net_device *net_dev,
-					   struct ieee80211_security *sec)
+
+static const struct ieee80211_ops bcm43xx_hw_ops = {
+	.tx = bcm43xx_tx,
+	.conf_tx = bcm43xx_conf_tx,
+	.add_interface = bcm43xx_add_interface,
+	.remove_interface = bcm43xx_remove_interface,
+	.reset = bcm43xx_dev_reset,
+	.config = bcm43xx_dev_config,
+	.config_interface = bcm43xx_config_interface,
+	.set_multicast_list = bcm43xx_set_multicast_list,
+	.set_key = bcm43xx_dev_set_key,
+	.get_stats = bcm43xx_get_stats,
+	.get_tx_stats = bcm43xx_get_tx_stats,
+};
+
+/* Hard-reset the chip. Do not call this directly.
+ * Use bcm43xx_controller_restart()
+ */
+static void bcm43xx_chip_reset(struct work_struct *work)
 {
-	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
-	struct ieee80211_security *secinfo = &bcm->ieee->sec;
-	unsigned long flags;
-	int keyidx;
-	
-	dprintk(KERN_INFO PFX "set security called");
-
-	mutex_lock(&bcm->mutex);
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-
-	for (keyidx = 0; keyidx<WEP_KEYS; keyidx++)
-		if (sec->flags & (1<<keyidx)) {
-			secinfo->encode_alg[keyidx] = sec->encode_alg[keyidx];
-			secinfo->key_sizes[keyidx] = sec->key_sizes[keyidx];
-			memcpy(secinfo->keys[keyidx], sec->keys[keyidx], SCM_KEY_LEN);
+	struct bcm43xx_wldev *dev =
+		container_of(work, struct bcm43xx_wldev, restart_work);
+	struct bcm43xx_wl *wl = dev->wl;
+	int err = 0;
+	int prev_status;
+
+	mutex_lock(&wl->mutex);
+
+	prev_status = bcm43xx_status(dev);
+	/* Bring the device down... */
+	if (prev_status >= BCM43xx_STAT_STARTED)
+		bcm43xx_wireless_core_stop(dev);
+	if (prev_status >= BCM43xx_STAT_INITIALIZED)
+		bcm43xx_wireless_core_exit(dev);
+
+	/* ...and up again. */
+	if (prev_status >= BCM43xx_STAT_INITIALIZED) {
+		err = bcm43xx_wireless_core_init(dev);
+		if (err)
+			goto out;
+	}
+	if (prev_status >= BCM43xx_STAT_STARTED) {
+		err = bcm43xx_wireless_core_start(dev);
+		if (err) {
+			bcm43xx_wireless_core_exit(dev);
+			goto out;
 		}
-	
-	if (sec->flags & SEC_ACTIVE_KEY) {
-		secinfo->active_key = sec->active_key;
-		dprintk(", .active_key = %d", sec->active_key);
-	}
-	if (sec->flags & SEC_UNICAST_GROUP) {
-		secinfo->unicast_uses_group = sec->unicast_uses_group;
-		dprintk(", .unicast_uses_group = %d", sec->unicast_uses_group);
-	}
-	if (sec->flags & SEC_LEVEL) {
-		secinfo->level = sec->level;
-		dprintk(", .level = %d", sec->level);
-	}
-	if (sec->flags & SEC_ENABLED) {
-		secinfo->enabled = sec->enabled;
-		dprintk(", .enabled = %d", sec->enabled);
-	}
-	if (sec->flags & SEC_ENCRYPT) {
-		secinfo->encrypt = sec->encrypt;
-		dprintk(", .encrypt = %d", sec->encrypt);
-	}
-	if (sec->flags & SEC_AUTH_MODE) {
-		secinfo->auth_mode = sec->auth_mode;
-		dprintk(", .auth_mode = %d", sec->auth_mode);
-	}
-	dprintk("\n");
-	if (bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED &&
-	    !bcm->ieee->host_encrypt) {
-		if (secinfo->enabled) {
-			/* upload WEP keys to hardware */
-			char null_address[6] = { 0 };
-			u8 algorithm = 0;
-			for (keyidx = 0; keyidx<WEP_KEYS; keyidx++) {
-				if (!(sec->flags & (1<<keyidx)))
-					continue;
-				switch (sec->encode_alg[keyidx]) {
-					case SEC_ALG_NONE: algorithm = BCM43xx_SEC_ALGO_NONE; break;
-					case SEC_ALG_WEP:
-						algorithm = BCM43xx_SEC_ALGO_WEP;
-						if (secinfo->key_sizes[keyidx] == 13)
-							algorithm = BCM43xx_SEC_ALGO_WEP104;
-						break;
-					case SEC_ALG_TKIP:
-						FIXME();
-						algorithm = BCM43xx_SEC_ALGO_TKIP;
-						break;
-					case SEC_ALG_CCMP:
-						FIXME();
-						algorithm = BCM43xx_SEC_ALGO_AES;
-						break;
-					default:
-						assert(0);
-						break;
-				}
-				bcm43xx_key_write(bcm, keyidx, algorithm, sec->keys[keyidx], secinfo->key_sizes[keyidx], &null_address[0]);
-				bcm->key[keyidx].enabled = 1;
-				bcm->key[keyidx].algorithm = algorithm;
-			}
-		} else
-				bcm43xx_clear_keys(bcm);
 	}
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
-	mutex_unlock(&bcm->mutex);
+out:
+	mutex_unlock(&wl->mutex);
+	if (err)
+		bcmerr(wl, "Controller restart FAILED\n");
+	else
+		bcminfo(wl, "Controller restarted\n");
 }
 
-/* hard_start_xmit() callback in struct ieee80211_device */
-static int bcm43xx_ieee80211_hard_start_xmit(struct ieee80211_txb *txb,
-					     struct net_device *net_dev,
-					     int pri)
+static int bcm43xx_setup_modes(struct bcm43xx_wldev *dev,
+			       int have_bphy,
+			       int have_gphy)
 {
-	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
-	int err = -ENODEV;
-	unsigned long flags;
+	struct ieee80211_hw *hw = dev->wl->hw;
+	struct ieee80211_hw_mode *mode;
+	struct bcm43xx_phy *phy = &dev->phy;
+	int cnt = 0;
+	int err;
 
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-	if (likely(bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED))
-		err = bcm43xx_tx(bcm, txb);
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
+	phy->possible_phymodes = 0;
+	for ( ; 1; cnt++) {
+		if (have_bphy) {
+			BCM43xx_WARN_ON(cnt >= BCM43xx_MAX_PHYHWMODES);
+			mode = &phy->hwmodes[cnt];
+
+			mode->mode = MODE_IEEE80211B;
+			mode->num_channels = bcm43xx_bg_chantable_size;
+			mode->channels = bcm43xx_bg_chantable;
+			mode->num_rates = bcm43xx_b_ratetable_size;
+			mode->rates = bcm43xx_b_ratetable;
+			err = ieee80211_register_hwmode(hw, mode);
+			if (err)
+				return err;
 
-	if (unlikely(err))
-		return NETDEV_TX_BUSY;
-	return NETDEV_TX_OK;
-}
+			phy->possible_phymodes |= BCM43xx_PHYMODE_B;
+			have_bphy = 0;
+			continue;
+		}
+		if (have_gphy) {
+			BCM43xx_WARN_ON(cnt >= BCM43xx_MAX_PHYHWMODES);
+			mode = &phy->hwmodes[cnt];
+
+			mode->mode = MODE_IEEE80211G;
+			mode->num_channels = bcm43xx_bg_chantable_size;
+			mode->channels = bcm43xx_bg_chantable;
+			mode->num_rates = bcm43xx_g_ratetable_size;
+			mode->rates = bcm43xx_g_ratetable;
+			err = ieee80211_register_hwmode(hw, mode);
+			if (err)
+				return err;
 
-static void bcm43xx_net_tx_timeout(struct net_device *net_dev)
-{
-	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
-	unsigned long flags;
+			phy->possible_phymodes |= BCM43xx_PHYMODE_G;
+			have_gphy = 0;
+			continue;
+		}
+		break;
+	}
 
-	spin_lock_irqsave(&bcm->irq_lock, flags);
-	bcm43xx_controller_restart(bcm, "TX timeout");
-	spin_unlock_irqrestore(&bcm->irq_lock, flags);
+	return 0;
 }
 
-#ifdef CONFIG_NET_POLL_CONTROLLER
-static void bcm43xx_net_poll_controller(struct net_device *net_dev)
+static void bcm43xx_wireless_core_detach(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
-	unsigned long flags;
-
-	local_irq_save(flags);
-	if (bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED)
-		bcm43xx_interrupt_handler(bcm->irq, bcm);
-	local_irq_restore(flags);
+	/* We release firmware that late to not be required to re-request
+	 * is all the time when we reinit the core. */
+	bcm43xx_release_firmware(dev);
 }
-#endif /* CONFIG_NET_POLL_CONTROLLER */
 
-static int bcm43xx_net_open(struct net_device *net_dev)
+static int bcm43xx_wireless_core_attach(struct bcm43xx_wldev *dev)
 {
-	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
+	struct bcm43xx_wl *wl = dev->wl;
+	struct ssb_bus *bus = dev->dev->bus;
+	struct pci_dev *pdev = bus->host_pci;
+	int err;
+	int have_bphy = 0;
+	int have_gphy = 0;
+	u32 tmp;
+
+	/* Do NOT do any device initialization here.
+	 * Do it in wireless_core_init() instead.
+	 * This function is for gathering basic information about the HW, only.
+	 * Also some structs may be set up here. But most likely you want to
+	 * have that in core_init(), too.
+	 */
+
+	/* Get the PHY type. */
+	if (dev->dev->id.revision >= 5) {
+		u32 tmshigh;
+
+		tmshigh = ssb_read32(dev->dev, SSB_TMSHIGH);
+		have_gphy = !!(tmshigh & BCM43xx_TMSHIGH_GPHY);
+		if (!have_gphy)
+			have_bphy = 1;
+	} else if (dev->dev->id.revision == 4) {
+		have_gphy = 1;
+	} else {
+		have_bphy = 1;
+	}
+
+	/* Initialize LEDs structs. */
+	err = bcm43xx_leds_init(dev);
+	if (err)
+		goto out;
+
+	dev->phy.gmode = (have_gphy || have_bphy);
+	tmp = dev->phy.gmode ? BCM43xx_TMSLOW_GMODE : 0;
+	bcm43xx_wireless_core_reset(dev, tmp);
+
+	err = bcm43xx_phy_versioning(dev);
+	if (err)
+		goto err_leds_exit;
+	/* Check if this device supports multiband. */
+	if (!pdev ||
+	    (pdev->device != 0x4312 &&
+	     pdev->device != 0x4319 &&
+	     pdev->device != 0x4324)) {
+		/* No multiband support. */
+		have_bphy = 0;
+		have_gphy = 0;
+		switch (dev->phy.type) {
+		case BCM43xx_PHYTYPE_B:
+			have_bphy = 1;
+			break;
+		case BCM43xx_PHYTYPE_G:
+			have_gphy = 1;
+			break;
+		default:
+			BCM43xx_BUG_ON(1);
+		}
+	}
+	dev->phy.gmode = (have_gphy || have_bphy);
+	tmp = dev->phy.gmode ? BCM43xx_TMSLOW_GMODE : 0;
+	bcm43xx_wireless_core_reset(dev, tmp);
+
+	err = bcm43xx_validate_chipaccess(dev);
+	if (err)
+		goto err_leds_exit;
+	err = bcm43xx_setup_modes(dev, have_bphy, have_gphy);
+	if (err)
+		goto err_leds_exit;
+
+	/* Now set some default "current_dev" */
+	if (!wl->current_dev)
+		wl->current_dev = dev;
+	INIT_WORK(&dev->restart_work, bcm43xx_chip_reset);
+
+	bcm43xx_radio_turn_off(dev);
+	bcm43xx_switch_analog(dev, 0);
+	ssb_device_disable(dev->dev, 0);
+	ssb_bus_may_powerdown(bus);
 
-	return bcm43xx_init_board(bcm);
+out:
+	return err;
+
+err_leds_exit:
+	bcm43xx_leds_exit(dev);
+	return err;
 }
 
-static int bcm43xx_net_stop(struct net_device *net_dev)
+static void bcm43xx_one_core_detach(struct ssb_device *dev)
 {
-	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
-	int err;
+	struct bcm43xx_wldev *wldev;
+	struct bcm43xx_wl *wl;
 
-	ieee80211softmac_stop(net_dev);
-	err = bcm43xx_disable_interrupts_sync(bcm);
-	assert(!err);
-	bcm43xx_free_board(bcm);
-	flush_scheduled_work();
+	wldev = ssb_get_drvdata(dev);
+	wl = wldev->wl;
+	bcm43xx_debugfs_remove_device(wldev);
+	bcm43xx_wireless_core_detach(wldev);
+	list_del(&wldev->list);
+	wl->nr_devs--;
+	ssb_set_drvdata(dev, NULL);
+	kfree(wldev);
+}
+
+static int bcm43xx_one_core_attach(struct ssb_device *dev,
+				   struct bcm43xx_wl *wl)
+{
+	struct bcm43xx_wldev *wldev;
+	struct pci_dev *pdev;
+	int err = -ENOMEM;
+
+	if (!list_empty(&wl->devlist)) {
+		/* We are not the first core on this chip. */
+		pdev = dev->bus->host_pci;
+		/* Only special chips support more than one wireless
+		 * core, although some of the other chips have more than
+		 * one wireless core as well. Check for this and
+		 * bail out early.
+		 */
+		if (!pdev ||
+		    ((pdev->device != 0x4321) &&
+		     (pdev->device != 0x4313) &&
+		     (pdev->device != 0x431A))) {
+			bcmdbg(wl, "Ignoring unconnected 802.11 core\n");
+			return -ENODEV;
+		}
+	}
 
-	return 0;
-}
+	wldev = kzalloc(sizeof(*wldev), GFP_KERNEL);
+	if (!wldev)
+		goto out;
 
-static int bcm43xx_init_private(struct bcm43xx_private *bcm,
-				struct net_device *net_dev,
-				struct pci_dev *pci_dev)
-{
-	bcm43xx_set_status(bcm, BCM43xx_STAT_UNINIT);
-	bcm->ieee = netdev_priv(net_dev);
-	bcm->softmac = ieee80211_priv(net_dev);
-	bcm->softmac->set_channel = bcm43xx_ieee80211_set_chan;
-
-	bcm->irq_savedstate = BCM43xx_IRQ_INITIAL;
-	bcm->mac_suspended = 1;
-	bcm->pci_dev = pci_dev;
-	bcm->net_dev = net_dev;
-	bcm->bad_frames_preempt = modparam_bad_frames_preempt;
-	spin_lock_init(&bcm->irq_lock);
-	spin_lock_init(&bcm->leds_lock);
-	mutex_init(&bcm->mutex);
-	tasklet_init(&bcm->isr_tasklet,
+	wldev->dev = dev;
+	wldev->wl = wl;
+	bcm43xx_set_status(wldev, BCM43xx_STAT_UNINIT);
+	wldev->bad_frames_preempt = modparam_bad_frames_preempt;
+	tasklet_init(&wldev->isr_tasklet,
 		     (void (*)(unsigned long))bcm43xx_interrupt_tasklet,
-		     (unsigned long)bcm);
-	tasklet_disable_nosync(&bcm->isr_tasklet);
+		     (unsigned long)wldev);
 	if (modparam_pio)
-		bcm->__using_pio = 1;
-	bcm->rts_threshold = BCM43xx_DEFAULT_RTS_THRESHOLD;
+		wldev->__using_pio = 1;
+	INIT_LIST_HEAD(&wldev->list);
 
-	/* default to sw encryption for now */
-	bcm->ieee->host_build_iv = 0;
-	bcm->ieee->host_encrypt = 1;
-	bcm->ieee->host_decrypt = 1;
-	
-	bcm->ieee->iw_mode = BCM43xx_INITIAL_IWMODE;
-	bcm->ieee->tx_headroom = sizeof(struct bcm43xx_txhdr);
-	bcm->ieee->set_security = bcm43xx_ieee80211_set_security;
-	bcm->ieee->hard_start_xmit = bcm43xx_ieee80211_hard_start_xmit;
+	err = bcm43xx_wireless_core_attach(wldev);
+	if (err)
+		goto err_kfree_wldev;
 
-	return 0;
+	list_add(&wldev->list, &wl->devlist);
+	wl->nr_devs++;
+	ssb_set_drvdata(dev, wldev);
+	bcm43xx_debugfs_add_device(wldev);
+out:
+	return err;
+
+err_kfree_wldev:
+	kfree(wldev);
+	return err;
 }
 
-static int __devinit bcm43xx_init_one(struct pci_dev *pdev,
-				      const struct pci_device_id *ent)
+static void bcm43xx_sprom_fixup(struct ssb_bus *bus)
 {
-	struct net_device *net_dev;
-	struct bcm43xx_private *bcm;
-	int err;
+	/* boardflags workarounds */
+	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE &&
+	    bus->boardinfo.type == 0x4E &&
+	    bus->boardinfo.rev > 0x40)
+		bus->sprom.r1.boardflags_lo |= BCM43xx_BFL_PACTRL;
 
-#ifdef DEBUG_SINGLE_DEVICE_ONLY
-	if (strcmp(pci_name(pdev), DEBUG_SINGLE_DEVICE_ONLY))
-		return -ENODEV;
-#endif
+	/* Convert Antennagain values to Q5.2 */
+	bus->sprom.r1.antenna_gain_bg <<= 2;
+}
 
-	net_dev = alloc_ieee80211softmac(sizeof(*bcm));
-	if (!net_dev) {
-		printk(KERN_ERR PFX
-		       "could not allocate ieee80211 device %s\n",
-		       pci_name(pdev));
-		err = -ENOMEM;
-		goto out;
-	}
-	/* initialize the net_device struct */
-	SET_MODULE_OWNER(net_dev);
-	SET_NETDEV_DEV(net_dev, &pdev->dev);
-
-	net_dev->open = bcm43xx_net_open;
-	net_dev->stop = bcm43xx_net_stop;
-	net_dev->tx_timeout = bcm43xx_net_tx_timeout;
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	net_dev->poll_controller = bcm43xx_net_poll_controller;
-#endif
-	net_dev->wireless_handlers = &bcm43xx_wx_handlers_def;
-	net_dev->irq = pdev->irq;
-	SET_ETHTOOL_OPS(net_dev, &bcm43xx_ethtool_ops);
-
-	/* initialize the bcm43xx_private struct */
-	bcm = bcm43xx_priv(net_dev);
-	memset(bcm, 0, sizeof(*bcm));
-	err = bcm43xx_init_private(bcm, net_dev, pdev);
-	if (err)
-		goto err_free_netdev;
+static void bcm43xx_wireless_exit(struct ssb_device *dev,
+				  struct bcm43xx_wl *wl)
+{
+	struct ieee80211_hw *hw = wl->hw;
 
-	pci_set_drvdata(pdev, net_dev);
+	ssb_set_devtypedata(dev, NULL);
+	ieee80211_free_hw(hw);
+}
 
-	err = bcm43xx_attach_board(bcm);
-	if (err)
-		goto err_free_netdev;
+static int bcm43xx_wireless_init(struct ssb_device *dev)
+{
+	struct ssb_sprom *sprom = &dev->bus->sprom;
+	struct ieee80211_hw *hw;
+	struct bcm43xx_wl *wl;
+	int err = -ENOMEM;
 
-	err = register_netdev(net_dev);
-	if (err) {
-		printk(KERN_ERR PFX "Cannot register net device, "
-		       "aborting.\n");
-		err = -ENOMEM;
-		goto err_detach_board;
+	bcm43xx_sprom_fixup(dev->bus);
+
+	hw = ieee80211_alloc_hw(sizeof(*wl), &bcm43xx_hw_ops);
+	if (!hw) {
+		bcmerr(NULL, "Could not allocate ieee80211 device\n");
+		goto out;
 	}
 
-	bcm43xx_debugfs_add_device(bcm);
+	/* fill hw info */
+	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
+		    IEEE80211_HW_MONITOR_DURING_OPER |
+		    IEEE80211_HW_DEVICE_HIDES_WEP |
+		    IEEE80211_HW_WEP_INCLUDE_IV;
+	hw->max_signal = 100;
+	hw->max_rssi = -110;
+	hw->max_noise = -110;
+	hw->queues = 1; /* FIXME: hardware has more queues */
+	SET_IEEE80211_DEV(hw, dev->dev);
+	if (is_valid_ether_addr(sprom->r1.et1mac))
+		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.et1mac);
+	else
+		SET_IEEE80211_PERM_ADDR(hw, sprom->r1.il0mac);
 
-	assert(err == 0);
+	/* Get and initialize struct bcm43xx_wl */
+	wl = hw_to_bcm43xx_wl(hw);
+	memset(wl, 0, sizeof(*wl));
+	wl->hw = hw;
+	spin_lock_init(&wl->irq_lock);
+	spin_lock_init(&wl->leds_lock);
+	mutex_init(&wl->mutex);
+	INIT_LIST_HEAD(&wl->devlist);
+
+	ssb_set_devtypedata(dev, wl);
+	bcminfo(wl, "Broadcom %04X WLAN found\n", dev->bus->chip_id);
+	err = 0;
 out:
 	return err;
-
-err_detach_board:
-	bcm43xx_detach_board(bcm);
-err_free_netdev:
-	free_ieee80211softmac(net_dev);
-	goto out;
 }
 
-static void __devexit bcm43xx_remove_one(struct pci_dev *pdev)
+static int bcm43xx_probe(struct ssb_device *dev,
+			 const struct ssb_device_id *id)
 {
-	struct net_device *net_dev = pci_get_drvdata(pdev);
-	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
+	struct bcm43xx_wl *wl;
+	int err;
+	int first = 0;
+
+	wl = ssb_get_devtypedata(dev);
+	if (!wl) {
+		/* Probing the first core - setup common struct bcm43xx_wl */
+		first = 1;
+		err = bcm43xx_wireless_init(dev);
+		if (err)
+			goto out;
+		wl = ssb_get_devtypedata(dev);
+		BCM43xx_WARN_ON(!wl);
+	}
+	err = bcm43xx_one_core_attach(dev, wl);
+	if (err)
+		goto err_wireless_exit;
+
+	if (first) {
+		err = ieee80211_register_hw(wl->hw);
+		if (err)
+			goto err_one_core_detach;
+	}
+
+out:
+	return err;
 
-	bcm43xx_debugfs_remove_device(bcm);
-	unregister_netdev(net_dev);
-	bcm43xx_detach_board(bcm);
-	free_ieee80211softmac(net_dev);
+err_one_core_detach:
+	bcm43xx_one_core_detach(dev);
+err_wireless_exit:
+	if (first)
+		bcm43xx_wireless_exit(dev, wl);
+	return err;
 }
 
-/* Hard-reset the chip. Do not call this directly.
- * Use bcm43xx_controller_restart()
- */
-static void bcm43xx_chip_reset(struct work_struct *work)
+static void bcm43xx_remove(struct ssb_device *dev)
 {
-	struct bcm43xx_private *bcm =
-		container_of(work, struct bcm43xx_private, restart_work);
-	struct bcm43xx_phyinfo *phy;
-	int err = -ENODEV;
+	struct bcm43xx_wl *wl = ssb_get_devtypedata(dev);
+	struct bcm43xx_wldev *wldev = ssb_get_drvdata(dev);
 
-	mutex_lock(&(bcm)->mutex);
-	if (bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED) {
-		bcm43xx_periodic_tasks_delete(bcm);
-		phy = bcm43xx_current_phy(bcm);
-		err = bcm43xx_select_wireless_core(bcm, phy->type);
-		if (!err)
-			bcm43xx_periodic_tasks_setup(bcm);
-	}
-	mutex_unlock(&(bcm)->mutex);
+	BCM43xx_WARN_ON(!wl);
+	if (wl->current_dev == wldev)
+		ieee80211_unregister_hw(wl->hw);
 
-	printk(KERN_ERR PFX "Controller restart%s\n",
-	       (err == 0) ? "ed" : " failed");
+	bcm43xx_one_core_detach(dev);
+
+	if (list_empty(&wl->devlist))
+		/* Last core on the chip unregistered.
+		 * We can destroy common struct bcm43xx_wl.
+		 */
+		bcm43xx_wireless_exit(dev, wl);
 }
 
 /* Hard-reset the chip.
  * This can be called from interrupt or process context.
- * bcm->irq_lock must be locked.
+ * dev->irq_lock must be locked.
  */
-void bcm43xx_controller_restart(struct bcm43xx_private *bcm, const char *reason)
+void bcm43xx_controller_restart(struct bcm43xx_wldev *dev, const char *reason)
 {
-	if (bcm43xx_status(bcm) != BCM43xx_STAT_INITIALIZED)
+	if (bcm43xx_status(dev) != BCM43xx_STAT_INITIALIZED)
 		return;
-	printk(KERN_ERR PFX "Controller RESET (%s) ...\n", reason);
-	INIT_WORK(&bcm->restart_work, bcm43xx_chip_reset);
-	schedule_work(&bcm->restart_work);
+	bcminfo(dev->wl, "Controller RESET (%s) ...\n", reason);
+	queue_work(dev->wl->hw->workqueue, &dev->restart_work);
 }
 
 #ifdef CONFIG_PM
 
-static int bcm43xx_suspend(struct pci_dev *pdev, pm_message_t state)
+static int bcm43xx_suspend(struct ssb_device *dev, pm_message_t state)
 {
-	struct net_device *net_dev = pci_get_drvdata(pdev);
-	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
-	int err;
-
-	dprintk(KERN_INFO PFX "Suspending...\n");
+	struct bcm43xx_wldev *wldev = ssb_get_drvdata(dev);
+	struct bcm43xx_wl *wl = wldev->wl;
 
-	netif_device_detach(net_dev);
-	bcm->was_initialized = 0;
-	if (bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED) {
-		bcm->was_initialized = 1;
-		ieee80211softmac_stop(net_dev);
-		err = bcm43xx_disable_interrupts_sync(bcm);
-		if (unlikely(err)) {
-			dprintk(KERN_ERR PFX "Suspend failed.\n");
-			return -EAGAIN;
-		}
-		bcm->firmware_norelease = 1;
-		bcm43xx_free_board(bcm);
-		bcm->firmware_norelease = 0;
-	}
-	bcm43xx_chipset_detach(bcm);
+	bcmdbg(wl, "Suspending...\n");
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	mutex_lock(&wl->mutex);
+	wldev->suspend_init_status = bcm43xx_status(wldev);
+	if (wldev->suspend_init_status >= BCM43xx_STAT_STARTED)
+		bcm43xx_wireless_core_stop(wldev);
+	if (wldev->suspend_init_status >= BCM43xx_STAT_INITIALIZED)
+		bcm43xx_wireless_core_exit(wldev);
+	mutex_unlock(&wl->mutex);
 
-	dprintk(KERN_INFO PFX "Device suspended.\n");
+	bcmdbg(wl, "Device suspended.\n");
 
 	return 0;
 }
 
-static int bcm43xx_resume(struct pci_dev *pdev)
+static int bcm43xx_resume(struct ssb_device *dev)
 {
-	struct net_device *net_dev = pci_get_drvdata(pdev);
-	struct bcm43xx_private *bcm = bcm43xx_priv(net_dev);
+	struct bcm43xx_wldev *wldev = ssb_get_drvdata(dev);
+	struct bcm43xx_wl *wl = wldev->wl;
 	int err = 0;
 
-	dprintk(KERN_INFO PFX "Resuming...\n");
+	bcmdbg(wl, "Resuming...\n");
 
-	pci_set_power_state(pdev, 0);
-	err = pci_enable_device(pdev);
-	if (err) {
-		printk(KERN_ERR PFX "Failure with pci_enable_device!\n");
-		return err;
+	mutex_lock(&wl->mutex);
+	if (wldev->suspend_init_status >= BCM43xx_STAT_INITIALIZED) {
+		err = bcm43xx_wireless_core_init(wldev);
+		if (err) {
+			bcmerr(wl, "Resume failed at core init\n");
+			goto out;
+		}
 	}
-	pci_restore_state(pdev);
-
-	bcm43xx_chipset_attach(bcm);
-	if (bcm->was_initialized)
-		err = bcm43xx_init_board(bcm);
-	if (err) {
-		printk(KERN_ERR PFX "Resume failed!\n");
-		return err;
+	if (wldev->suspend_init_status >= BCM43xx_STAT_STARTED) {
+		err = bcm43xx_wireless_core_start(wldev);
+		if (err) {
+			bcm43xx_wireless_core_exit(wldev);
+			bcmerr(wl, "Resume failed at core start\n");
+			goto out;
+		}
 	}
-	netif_device_attach(net_dev);
-
-	dprintk(KERN_INFO PFX "Device resumed.\n");
+	mutex_unlock(&wl->mutex);
 
-	return 0;
+	bcmdbg(wl, "Device resumed.\n");
+out:
+	return err;
 }
 
-#endif				/* CONFIG_PM */
+#else	/* CONFIG_PM */
+# define bcm43xx_suspend	NULL
+# define bcm43xx_resume		NULL
+#endif	/* CONFIG_PM */
+
+static struct ssb_driver bcm43xx_ssb_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= bcm43xx_ssb_tbl,
+	.probe		= bcm43xx_probe,
+	.remove		= bcm43xx_remove,
+	.suspend	= bcm43xx_suspend,
+	.resume		= bcm43xx_resume,
+};
+
+/* The PCI frontend stub */
+static const struct pci_device_id bcm43xx_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4307) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4311) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4312) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4318) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4319) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4320) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4321) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4324) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4325) },
+	{ 0 },
+};
+MODULE_DEVICE_TABLE(pci, bcm43xx_pci_tbl);
 
 static struct pci_driver bcm43xx_pci_driver = {
-	.name = KBUILD_MODNAME,
-	.id_table = bcm43xx_pci_tbl,
-	.probe = bcm43xx_init_one,
-	.remove = __devexit_p(bcm43xx_remove_one),
-#ifdef CONFIG_PM
-	.suspend = bcm43xx_suspend,
-	.resume = bcm43xx_resume,
-#endif				/* CONFIG_PM */
+	.name		= "bcm43xx-pci",
+	.id_table	= bcm43xx_pci_tbl,
 };
 
 static int __init bcm43xx_init(void)
 {
-	printk(KERN_INFO KBUILD_MODNAME " driver\n");
+	int err;
+
 	bcm43xx_debugfs_init();
-	return pci_register_driver(&bcm43xx_pci_driver);
+	err = ssb_pcihost_register(&bcm43xx_pci_driver);
+	if (err)
+		goto err_dfs_exit;
+	err = ssb_driver_register(&bcm43xx_ssb_driver);
+	if (err)
+		goto err_pci_exit;
+
+	return err;
+
+err_pci_exit:
+	ssb_pcihost_unregister(&bcm43xx_pci_driver);
+err_dfs_exit:
+	bcm43xx_debugfs_exit();
+	return err;
 }
 
 static void __exit bcm43xx_exit(void)
 {
-	pci_unregister_driver(&bcm43xx_pci_driver);
+	ssb_driver_unregister(&bcm43xx_ssb_driver);
+	ssb_pcihost_unregister(&bcm43xx_pci_driver);
 	bcm43xx_debugfs_exit();
 }
 
Index: linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.h
+++ linux-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.h
@@ -3,10 +3,11 @@
   Broadcom BCM43xx wireless driver
 
   Copyright (c) 2005 Martin Langer <martin-langer@gmx.de>,
-                     Stefano Brivio <st3@riseup.net>
-                     Michael Buesch <mbuesch@freenet.de>
-                     Danny van Dyk <kugelfang@gentoo.org>
-                     Andreas Jaggi <andreas.jaggi@waterwave.ch>
+  Copyright (c) 2005 Stefano Brivio <st3@riseup.net>
+  Copyright (c) 2005, 2006 Michael Buesch <mb@bu3sch.de>
+  Copyright (c) 2005  Danny van Dyk <kugelfang@gentoo.org>
+  Copyright (c) 2005  Andreas Jaggi <andreas.jaggi@waterwave.ch>
+  Copyright (c) 2007  Larry Finger <Larry.Finger@lwfinger.net>
 
   Some parts of the code in this file are derived from the ipw2200
   driver  Copyright(c) 2003 - 2004 Intel Corporation.
@@ -33,6 +34,7 @@
 
 #include "bcm43xx.h"
 
+
 #define P4D_BYT3S(magic, nr_bytes)	u8 __p4dding##magic[nr_bytes]
 #define P4D_BYTES(line, nr_bytes)	P4D_BYT3S(line, nr_bytes)
 /* Magic helper macro to pad structures. Ignore those above. It's magic. */
@@ -41,11 +43,6 @@
 
 /* Lightweight function to convert a frequency (in Mhz) to a channel number. */
 static inline
-u8 bcm43xx_freq_to_channel_a(int freq)
-{
-	return ((freq - 5000) / 5);
-}
-static inline
 u8 bcm43xx_freq_to_channel_bg(int freq)
 {
 	u8 channel;
@@ -58,21 +55,14 @@ u8 bcm43xx_freq_to_channel_bg(int freq)
 	return channel;
 }
 static inline
-u8 bcm43xx_freq_to_channel(struct bcm43xx_private *bcm,
+u8 bcm43xx_freq_to_channel(struct bcm43xx_wldev *dev,
 			   int freq)
 {
-	if (bcm43xx_current_phy(bcm)->type == BCM43xx_PHYTYPE_A)
-		return bcm43xx_freq_to_channel_a(freq);
 	return bcm43xx_freq_to_channel_bg(freq);
 }
 
 /* Lightweight function to convert a channel number to a frequency (in Mhz). */
 static inline
-int bcm43xx_channel_to_freq_a(u8 channel)
-{
-	return (5000 + (5 * channel));
-}
-static inline
 int bcm43xx_channel_to_freq_bg(u8 channel)
 {
 	int freq;
@@ -84,50 +74,71 @@ int bcm43xx_channel_to_freq_bg(u8 channe
 
 	return freq;
 }
+
 static inline
-int bcm43xx_channel_to_freq(struct bcm43xx_private *bcm,
+int bcm43xx_channel_to_freq(struct bcm43xx_wldev *dev,
 			    u8 channel)
 {
-	if (bcm43xx_current_phy(bcm)->type == BCM43xx_PHYTYPE_A)
-		return bcm43xx_channel_to_freq_a(channel);
 	return bcm43xx_channel_to_freq_bg(channel);
 }
 
-void bcm43xx_tsf_read(struct bcm43xx_private *bcm, u64 *tsf);
-void bcm43xx_tsf_write(struct bcm43xx_private *bcm, u64 tsf);
+static inline
+int bcm43xx_is_cck_rate(int rate)
+{
+	return (rate == BCM43xx_CCK_RATE_1MB ||
+		rate == BCM43xx_CCK_RATE_2MB ||
+		rate == BCM43xx_CCK_RATE_5MB ||
+		rate == BCM43xx_CCK_RATE_11MB);
+}
+
+static inline
+int bcm43xx_is_ofdm_rate(int rate)
+{
+	return !bcm43xx_is_cck_rate(rate);
+}
+
+static inline
+int bcm43xx_is_hw_radio_enabled(struct bcm43xx_wldev *dev)
+{
+	/* function to return state of hardware enable of radio
+	 * returns 0 if radio disabled, 1 if radio enabled
+	 */
+	struct bcm43xx_phy *phy = &dev->phy;
 
-void bcm43xx_set_iwmode(struct bcm43xx_private *bcm,
-			int iw_mode);
+	if (phy->rev >= 3)
+		return ((bcm43xx_read32(dev, BCM43xx_MMIO_RADIO_HWENABLED_HI)
+					& BCM43xx_MMIO_RADIO_HWENABLED_HI_MASK)
+					== 0) ? 1 : 0;
+	else
+		return ((bcm43xx_read16(dev, BCM43xx_MMIO_RADIO_HWENABLED_LO)
+					& BCM43xx_MMIO_RADIO_HWENABLED_LO_MASK)
+					== 0) ? 0 : 1;
+}
+
+void bcm43xx_tsf_read(struct bcm43xx_wldev *dev, u64 *tsf);
+void bcm43xx_tsf_write(struct bcm43xx_wldev *dev, u64 tsf);
 
-u32 bcm43xx_shm_read32(struct bcm43xx_private *bcm,
+u32 bcm43xx_shm_read32(struct bcm43xx_wldev *dev,
 		       u16 routing, u16 offset);
-u16 bcm43xx_shm_read16(struct bcm43xx_private *bcm,
+u16 bcm43xx_shm_read16(struct bcm43xx_wldev *dev,
 		       u16 routing, u16 offset);
-void bcm43xx_shm_write32(struct bcm43xx_private *bcm,
+void bcm43xx_shm_write32(struct bcm43xx_wldev *dev,
 			 u16 routing, u16 offset,
 			 u32 value);
-void bcm43xx_shm_write16(struct bcm43xx_private *bcm,
+void bcm43xx_shm_write16(struct bcm43xx_wldev *dev,
 			 u16 routing, u16 offset,
 			 u16 value);
 
-void bcm43xx_dummy_transmission(struct bcm43xx_private *bcm);
-
-int bcm43xx_switch_core(struct bcm43xx_private *bcm, struct bcm43xx_coreinfo *new_core);
-
-int bcm43xx_select_wireless_core(struct bcm43xx_private *bcm,
-				 int phytype);
-
-void bcm43xx_wireless_core_reset(struct bcm43xx_private *bcm, int connect_phy);
+u32 bcm43xx_hf_read(struct bcm43xx_wldev *dev);
+void bcm43xx_hf_write(struct bcm43xx_wldev *dev, u32 value);
 
-void bcm43xx_mac_suspend(struct bcm43xx_private *bcm);
-void bcm43xx_mac_enable(struct bcm43xx_private *bcm);
+void bcm43xx_dummy_transmission(struct bcm43xx_wldev *dev);
 
-void bcm43xx_periodic_tasks_delete(struct bcm43xx_private *bcm);
-void bcm43xx_periodic_tasks_setup(struct bcm43xx_private *bcm);
+void bcm43xx_wireless_core_reset(struct bcm43xx_wldev *dev, u32 flags);
 
-void bcm43xx_controller_restart(struct bcm43xx_private *bcm, const char *reason);
+void bcm43xx_mac_suspend(struct bcm43xx_wldev *dev);
+void bcm43xx_mac_enable(struct bcm43xx_wldev *dev);
 
-int bcm43xx_sprom_read(struct bcm43xx_private *bcm, u16 *sprom);
-int bcm43xx_sprom_write(struct bcm43xx_private *bcm, const u16 *sprom);
+void bcm43xx_controller_restart(struct bcm43xx_wldev *dev, const char *reason);
 
 #endif /* BCM43xx_MAIN_H_ */


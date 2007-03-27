Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2785 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934168AbXC0SoP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2007 14:44:15 -0400
Date: Tue, 27 Mar 2007 14:26:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'upstream' branch of wireless-2.6
Message-ID: <20070327182653.GD3887@tuxdriver.com>
References: <20070327182624.GC3887@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070327182624.GC3887@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit b1944354101f15f4afeffd842e12c7d70fb7e822:
  John W. Linville (1):
        Merge branch 'upstream-fixes' into upstream

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream

Daniel Drake (3):
      zd1211rw: Mark some data const
      zd1211rw: Don't handle broken frames in monitor mode
      zd1211rw: Add another ID for Linksys WUSBF54G

Jouni Malinen (1):
      Update my email address from jkmaline@cc.hut.fi to j@w1.fi

 MAINTAINERS                                   |    5 +++--
 crypto/michael_mic.c                          |    4 ++--
 drivers/net/wireless/hostap/hostap_ap.c       |    4 ++--
 drivers/net/wireless/hostap/hostap_cs.c       |    2 +-
 drivers/net/wireless/hostap/hostap_hw.c       |    4 ++--
 drivers/net/wireless/hostap/hostap_main.c     |    4 ++--
 drivers/net/wireless/hostap/hostap_pci.c      |    2 +-
 drivers/net/wireless/hostap/hostap_plx.c      |    2 +-
 drivers/net/wireless/ipw2100.c                |    4 ++--
 drivers/net/wireless/zd1211rw/zd_mac.c        |   13 ++-----------
 drivers/net/wireless/zd1211rw/zd_rf.c         |    2 +-
 drivers/net/wireless/zd1211rw/zd_rf_al7230b.c |    4 ++--
 drivers/net/wireless/zd1211rw/zd_rf_rf2959.c  |    4 ++--
 drivers/net/wireless/zd1211rw/zd_usb.c        |    1 +
 include/linux/wireless.h                      |    2 +-
 include/net/ieee80211.h                       |    4 ++--
 include/net/ieee80211_crypt.h                 |    4 ++--
 net/ieee80211/ieee80211_crypt.c               |    2 +-
 net/ieee80211/ieee80211_crypt_ccmp.c          |    2 +-
 net/ieee80211/ieee80211_crypt_tkip.c          |    2 +-
 net/ieee80211/ieee80211_crypt_wep.c           |    2 +-
 net/ieee80211/ieee80211_module.c              |    4 ++--
 net/ieee80211/ieee80211_rx.c                  |    4 ++--
 net/ieee80211/ieee80211_wx.c                  |    4 ++--
 24 files changed, 39 insertions(+), 46 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dd6978b..3fe1335 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1537,8 +1537,9 @@ S:	Supported
  
 HOST AP DRIVER
 P:	Jouni Malinen
-M:	jkmaline@cc.hut.fi
-L:	hostap@shmoo.com
+M:	j@w1.fi
+L:	hostap@shmoo.com (subscribers-only)
+L:	linux-wireless@vger.kernel.org
 W:	http://hostap.epitest.fi/
 S:	Maintained
 
diff --git a/crypto/michael_mic.c b/crypto/michael_mic.c
index 094397b..9e917b8 100644
--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -3,7 +3,7 @@
  *
  * Michael MIC (IEEE 802.11i/TKIP) keyed digest
  *
- * Copyright (c) 2004 Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2004 Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -173,4 +173,4 @@ module_exit(michael_mic_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Michael MIC");
-MODULE_AUTHOR("Jouni Malinen <jkmaline@cc.hut.fi>");
+MODULE_AUTHOR("Jouni Malinen <j@w1.fi>");
diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index efb8cf3..9ec32fa 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -1,8 +1,8 @@
 /*
  * Intersil Prism2 driver with Host AP (software access point) support
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2005, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2005, Jouni Malinen <j@w1.fi>
  *
  * This file is to be included into hostap.c when S/W AP functionality is
  * compiled.
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 534da85..4b81c7d 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -22,7 +22,7 @@
 #include "hostap_wlan.h"
 
 
-static char *version = PRISM2_VERSION " (Jouni Malinen <jkmaline@cc.hut.fi>)";
+static char *version = PRISM2_VERSION " (Jouni Malinen <j@w1.fi>)";
 static dev_info_t dev_info = "hostap_cs";
 
 MODULE_AUTHOR("Jouni Malinen");
diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 3079378..d21b8a9 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -3,8 +3,8 @@
  * Intersil Prism2/2.5/3.
  *
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2005, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2005, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wireless/hostap/hostap_main.c
index 9077e6e..71ec281 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -3,8 +3,8 @@
  * Intersil Prism2/2.5/3 - hostap.o module, common routines
  *
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2005, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2005, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/net/wireless/hostap/hostap_pci.c b/drivers/net/wireless/hostap/hostap_pci.c
index c4f6020..db4899e 100644
--- a/drivers/net/wireless/hostap/hostap_pci.c
+++ b/drivers/net/wireless/hostap/hostap_pci.c
@@ -20,7 +20,7 @@
 #include "hostap_wlan.h"
 
 
-static char *version = PRISM2_VERSION " (Jouni Malinen <jkmaline@cc.hut.fi>)";
+static char *version = PRISM2_VERSION " (Jouni Malinen <j@w1.fi>)";
 static char *dev_info = "hostap_pci";
 
 
diff --git a/drivers/net/wireless/hostap/hostap_plx.c b/drivers/net/wireless/hostap/hostap_plx.c
index e235e06..f0fd5ec 100644
--- a/drivers/net/wireless/hostap/hostap_plx.c
+++ b/drivers/net/wireless/hostap/hostap_plx.c
@@ -23,7 +23,7 @@
 #include "hostap_wlan.h"
 
 
-static char *version = PRISM2_VERSION " (Jouni Malinen <jkmaline@cc.hut.fi>)";
+static char *version = PRISM2_VERSION " (Jouni Malinen <j@w1.fi>)";
 static char *dev_info = "hostap_plx";
 
 
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index ad6e4a4..61706c9 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -28,8 +28,8 @@
 
   Portions of this file are based on the Host AP project,
   Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
-    <jkmaline@cc.hut.fi>
-  Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+    <j@w1.fi>
+  Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
 
   Portions of ipw2100_mod_firmware_load, ipw2100_do_mod_firmware_load, and
   ipw2100_fw_load are loosely based on drivers/sound/sound_firmware.c
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 19172f5..6753d24 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -156,17 +156,8 @@ void zd_mac_clear(struct zd_mac *mac)
 static int reset_mode(struct zd_mac *mac)
 {
 	struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
-	struct zd_ioreq32 ioreqs[] = {
-		{ CR_RX_FILTER, STA_RX_FILTER },
-		{ CR_SNIFFER_ON, 0U },
-	};
-
-	if (ieee->iw_mode == IW_MODE_MONITOR) {
-		ioreqs[0].value = 0xffffffff;
-		ioreqs[1].value = 0x1;
-	}
-
-	return zd_iowrite32a(&mac->chip, ioreqs, ARRAY_SIZE(ioreqs));
+	u32 filter = (ieee->iw_mode == IW_MODE_MONITOR) ? ~0 : STA_RX_FILTER;
+	return zd_iowrite32(&mac->chip, CR_RX_FILTER, filter);
 }
 
 int zd_mac_open(struct net_device *netdev)
diff --git a/drivers/net/wireless/zd1211rw/zd_rf.c b/drivers/net/wireless/zd1211rw/zd_rf.c
index e6d604b..4ddc2cb 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf.c
@@ -23,7 +23,7 @@
 #include "zd_ieee80211.h"
 #include "zd_chip.h"
 
-static const char *rfs[] = {
+static const char * const rfs[] = {
 	[0]		= "unknown RF0",
 	[1]		= "unknown RF1",
 	[UW2451_RF]	= "UW2451_RF",
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c b/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
index a289f95..bd07c9b 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_al7230b.c
@@ -183,12 +183,12 @@ static int al7230b_set_channel(struct zd_rf *rf, u8 channel)
 	const u32 *rv = chan_rv[channel-1];
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
-	struct zd_ioreq16 ioreqs_1[] = {
+	static const struct zd_ioreq16 ioreqs_1[] = {
 		{ CR128, 0x14 }, { CR129, 0x12 }, { CR130, 0x10 },
 		{ CR38,  0x38 }, { CR136, 0xdf },
 	};
 
-	struct zd_ioreq16 ioreqs_2[] = {
+	static const struct zd_ioreq16 ioreqs_2[] = {
 		/* PLL_ON */
 		{ CR251, 0x3f },
 		{ CR203, 0x06 }, { CR240, 0x08 },
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c b/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
index 5824727..2d736bd 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_rf2959.c
@@ -21,7 +21,7 @@
 #include "zd_usb.h"
 #include "zd_chip.h"
 
-static u32 rf2959_table[][2] = {
+static const u32 rf2959_table[][2] = {
 	RF_CHANNEL( 1) = { 0x181979, 0x1e6666 },
 	RF_CHANNEL( 2) = { 0x181989, 0x1e6666 },
 	RF_CHANNEL( 3) = { 0x181999, 0x1e6666 },
@@ -228,7 +228,7 @@ static int rf2959_init_hw(struct zd_rf *rf)
 static int rf2959_set_channel(struct zd_rf *rf, u8 channel)
 {
 	int i, r;
-	u32 *rv = rf2959_table[channel-1];
+	const u32 *rv = rf2959_table[channel-1];
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
 	for (i = 0; i < 2; i++) {
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 145ad61..55f4c61 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -52,6 +52,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0b3b, 0x1630), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0586, 0x3401), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x14ea, 0xab13), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x13b1, 0x001e), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
 	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 48759b2..0987aa7 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -186,7 +186,7 @@
  *	- Wireless Event capability in struct iw_range
  *	- Add support for relative TxPower (yick !)
  *
- * V17 to V18 (From Jouni Malinen <jkmaline@cc.hut.fi>)
+ * V17 to V18 (From Jouni Malinen <j@w1.fi>)
  * ----------
  *	- Add support for WPA/WPA2
  *	- Add extended encoding configuration (SIOCSIWENCODEEXT and
diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index e02d85f..d56b292 100644
--- a/include/net/ieee80211.h
+++ b/include/net/ieee80211.h
@@ -6,8 +6,8 @@
  * LAN access point) driver for Intersil Prism2/2.5/3.
  *
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
  *
  * Adaption to a generic IEEE 802.11 stack by James Ketrenos
  * <jketreno@linux.intel.com>
diff --git a/include/net/ieee80211_crypt.h b/include/net/ieee80211_crypt.h
index eb47641..b3d65e0 100644
--- a/include/net/ieee80211_crypt.h
+++ b/include/net/ieee80211_crypt.h
@@ -3,8 +3,8 @@
  * for Intersil Prism2/2.5/3.
  *
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
  *
  * Adaption to a generic IEEE 802.11 stack by James Ketrenos
  * <jketreno@linux.intel.com>
diff --git a/net/ieee80211/ieee80211_crypt.c b/net/ieee80211/ieee80211_crypt.c
index 5ed0a98..df5592c 100644
--- a/net/ieee80211/ieee80211_crypt.c
+++ b/net/ieee80211/ieee80211_crypt.c
@@ -1,7 +1,7 @@
 /*
  * Host AP crypto routines
  *
- * Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
  * Portions Copyright (C) 2004, Intel Corporation <jketreno@linux.intel.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/ieee80211/ieee80211_crypt_ccmp.c b/net/ieee80211/ieee80211_crypt_ccmp.c
index 35aa342..7ec8314 100644
--- a/net/ieee80211/ieee80211_crypt_ccmp.c
+++ b/net/ieee80211/ieee80211_crypt_ccmp.c
@@ -1,7 +1,7 @@
 /*
  * Host AP crypt: host-based CCMP encryption implementation for Host AP driver
  *
- * Copyright (c) 2003-2004, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2003-2004, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/ieee80211/ieee80211_crypt_tkip.c
index fc1f99a..bd0988f 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -1,7 +1,7 @@
 /*
  * Host AP crypt: host-based TKIP encryption implementation for Host AP driver
  *
- * Copyright (c) 2003-2004, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2003-2004, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/ieee80211/ieee80211_crypt_wep.c b/net/ieee80211/ieee80211_crypt_wep.c
index ec6d885..1213d70 100644
--- a/net/ieee80211/ieee80211_crypt_wep.c
+++ b/net/ieee80211/ieee80211_crypt_wep.c
@@ -1,7 +1,7 @@
 /*
  * Host AP crypt: host-based WEP encryption implementation for Host AP driver
  *
- * Copyright (c) 2002-2004, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright (c) 2002-2004, Jouni Malinen <j@w1.fi>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/ieee80211/ieee80211_module.c b/net/ieee80211/ieee80211_module.c
index b1c6d1f..7630434 100644
--- a/net/ieee80211/ieee80211_module.c
+++ b/net/ieee80211/ieee80211_module.c
@@ -5,8 +5,8 @@
   Portions of this file are based on the WEP enablement code provided by the
   Host AP project hostap-drivers v0.1.3
   Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
-  <jkmaline@cc.hut.fi>
-  Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+  <j@w1.fi>
+  Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
 
   This program is free software; you can redistribute it and/or modify it
   under the terms of version 2 of the GNU General Public License as
diff --git a/net/ieee80211/ieee80211_rx.c b/net/ieee80211/ieee80211_rx.c
index 4084909..9d33546 100644
--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -3,8 +3,8 @@
  * for Intersil Prism2/2.5/3 - hostap.o module, common routines
  *
  * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <jkmaline@cc.hut.fi>
- * Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * <j@w1.fi>
+ * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
  * Copyright (c) 2004-2005, Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/ieee80211/ieee80211_wx.c b/net/ieee80211/ieee80211_wx.c
index 40d7a55..cee5e13 100644
--- a/net/ieee80211/ieee80211_wx.c
+++ b/net/ieee80211/ieee80211_wx.c
@@ -5,8 +5,8 @@
   Portions of this file are based on the WEP enablement code provided by the
   Host AP project hostap-drivers v0.1.3
   Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
-  <jkmaline@cc.hut.fi>
-  Copyright (c) 2002-2003, Jouni Malinen <jkmaline@cc.hut.fi>
+  <j@w1.fi>
+  Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
 
   This program is free software; you can redistribute it and/or modify it
   under the terms of version 2 of the GNU General Public License as
-- 
John W. Linville
linville@tuxdriver.com

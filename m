Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:65301 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbZHPSWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 14:22:42 -0400
Received: by fxm11 with SMTP id 11so1942801fxm.39
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2009 11:22:42 -0700 (PDT)
Message-ID: <4A884E71.6070202@gmail.com>
Date: Sun, 16 Aug 2009 20:22:41 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] b43: LP-PHY: Remove BROKEN from B43_PHY_LP
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry has reported success getting scan data with an LP-PHY device,
so it's probably time to release LP-PHY support for testing.

Also disable 802.11a support for now, as 802.11a currently causes
the driver to panic on startup (NULL pointer dereference).

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
V2:
-Remove "VERY" from the warning in the symbol name.
-Remove list of known devices.
-Don't create a separate symbol for 5GHz, just disable it in the code.

 drivers/net/wireless/b43/Kconfig |   14 +++++++-------
 drivers/net/wireless/b43/main.c  |    2 ++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 67f564e..237b1aa 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -80,16 +80,16 @@ config B43_NPHY
 	  SAY N.
 
 config B43_PHY_LP
-	bool "IEEE 802.11g LP-PHY support (BROKEN)"
-	depends on B43 && EXPERIMENTAL && BROKEN
+	bool "Support for low-power (LP-PHY) devices (EXPERIMENTAL)"
+	depends on B43 && EXPERIMENTAL
 	---help---
 	  Support for the LP-PHY.
-	  The LP-PHY is an IEEE 802.11g based PHY built into some notebooks
-	  and embedded devices.
-
-	  THIS IS BROKEN AND DOES NOT WORK YET.
+	  The LP-PHY is a low-power PHY built into some notebooks
+	  and embedded devices. It supports 802.11a/g
+	  (802.11a support is optional, and currently disabled).
 
-	  SAY N.
+	  This is heavily experimental, and probably will not work for you.
+	  Say N unless you want to help debug the driver.
 
 # This config option automatically enables b43 LEDS support,
 # if it's possible.
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 99b41ce..c5bece0 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4514,7 +4514,9 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 			have_5ghz_phy = 1;
 			break;
 		case B43_PHYTYPE_LP: //FIXME not always!
+#if 0 //FIXME enabling 5GHz causes a NULL pointer dereference
 			have_5ghz_phy = 1;
+#endif
 		case B43_PHYTYPE_G:
 		case B43_PHYTYPE_N:
 			have_2ghz_phy = 1;
-- 
1.6.2.4




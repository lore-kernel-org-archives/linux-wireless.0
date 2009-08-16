Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:36597 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZHPQmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 12:42:53 -0400
Received: by bwz22 with SMTP id 22so1915429bwz.18
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2009 09:42:53 -0700 (PDT)
Message-ID: <4A88370B.5090506@gmail.com>
Date: Sun, 16 Aug 2009 18:42:51 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Remove BROKEN from B43_PHY_LP
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry has reported success getting scan data with an LP-PHY device,
so it's probably time to release LP-PHY support for testing.

Also add a temporary BROKEN Kconfig symbol to disable 5GHz support,
as 5GHz currently causes the driver to panic (NULL pointer deref).

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/Kconfig  |   25 +++++++++++++++++++------
 drivers/net/wireless/b43/main.c   |    2 ++
 drivers/net/wireless/b43/phy_lp.c |    2 ++
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 67f564e..13414c9 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -80,16 +80,29 @@ config B43_NPHY
 	  SAY N.
 
 config B43_PHY_LP
-	bool "IEEE 802.11g LP-PHY support (BROKEN)"
-	depends on B43 && EXPERIMENTAL && BROKEN
+	bool "Support for low-power (LP-PHY) devices (VERY EXPERIMENTAL)"
+	depends on B43 && EXPERIMENTAL
 	---help---
 	  Support for the LP-PHY.
-	  The LP-PHY is an IEEE 802.11g based PHY built into some notebooks
-	  and embedded devices.
+	  The LP-PHY is a low-power PHY built into some notebooks
+	  and embedded devices. It supports 802.11a/g
+	  (802.11a support is optional, and currently disabled).
 
-	  THIS IS BROKEN AND DOES NOT WORK YET.
+	  Known LP-PHY devices include the BCM4310, BCM4312 (PCI ID 0x4315),
+	  BCM4325 (currently unsupported), BCM4326 & BCM4328 wireless cards
+	  and the BCM5354 SoC.
 
-	  SAY N.
+	  This is heavily experimental, and probably will not work for you.
+	  Say N unless you want to help debug the driver.
+
+config B43_PHY_LP_5GHZ
+	bool "Enable 802.11a support for LP-PHYs (BROKEN)"
+	depends on B43_PHY_LP && BROKEN
+	---help---
+	  Enable the 5GHz band of LP-PHY devices. Currently, all it
+	  does is cause the driver to panic on startup.
+
+	  Only select this if you are a developer working on this feature.
 
 # This config option automatically enables b43 LEDS support,
 # if it's possible.
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 99b41ce..0096d25 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4514,7 +4514,9 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 			have_5ghz_phy = 1;
 			break;
 		case B43_PHYTYPE_LP: //FIXME not always!
+#ifdef CONFIG_B43_PHY_LP_5GHZ
 			have_5ghz_phy = 1;
+#endif
 		case B43_PHYTYPE_G:
 		case B43_PHYTYPE_N:
 			have_2ghz_phy = 1;
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 3889519..c902dd1 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -43,7 +43,9 @@ static inline u16 channel2freq_lp(u8 channel)
 
 static unsigned int b43_lpphy_op_get_default_chan(struct b43_wldev *dev)
 {
+#ifdef CONFIG_B43_PHY_LP_5GHZ
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+#endif
 		return 1;
 	return 36;
 }
-- 
1.6.2.4




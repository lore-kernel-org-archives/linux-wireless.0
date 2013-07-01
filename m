Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47650 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab3GAHsn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 03:48:43 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 20/20] rt2x00: rt2800usb: add USB device ID for Linksys AE3000
Date: Mon,  1 Jul 2013 09:47:59 +0200
Message-Id: <1372664879-18474-21-git-send-email-juhosg@openwrt.org> (sfid-20130701_094848_428691_5FF4AD9F)
In-Reply-To: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Linksys AE3000 device is based on the RT3573
chipset. The support for this chipset is available
already, and the AE3000 device works with the driver.

Only managed mode works correctly at the moment,
for AP mode additional changes are needed in the
driver.

Also add a new RT2800USB_RT3573 Kconfig option and
only enable support for RT3573 based devices if
that is enabled.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v1:
  - Make the support selectable by a Kconfig option.
---
 drivers/net/wireless/rt2x00/Kconfig     |    6 ++++++
 drivers/net/wireless/rt2x00/rt2800usb.c |    4 ++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 9b915d3..c60d6e8 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -166,6 +166,12 @@ config RT2800USB_RT35XX
 	  rt2800usb driver.
 	  Supported chips: RT3572
 
+config RT2800USB_RT3573
+	bool "rt2800usb - Include support for rt3573 devices (EXPERIMENTAL)"
+	---help---
+	  This enables support for RT3573 chipset based wireless USB devices
+	  in the rt2800usb driver.
+
 config RT2800USB_RT53XX
        bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
        ---help---
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index c24c1fd..ab609ae 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1197,6 +1197,10 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Zinwell */
 	{ USB_DEVICE(0x5a57, 0x0284) },
 #endif
+#ifdef CONFIG_RT2800USB_RT3573
+	/* Linksys */
+	{ USB_DEVICE(0x13b1, 0x003b) },
+#endif
 #ifdef CONFIG_RT2800USB_RT53XX
 	/* Arcadyan */
 	{ USB_DEVICE(0x043e, 0x7a12) },
-- 
1.7.10


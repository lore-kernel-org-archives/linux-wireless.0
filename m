Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61445 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab1DRNgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:36:13 -0400
Received: by fxm17 with SMTP id 17so2833934fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:36:12 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/23] rt2x00: RT33xx device support is no longer experimental.
Date: Mon, 18 Apr 2011 15:33:00 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181532.14262.IvDoorn@gmail.com> <201104181532.34476.IvDoorn@gmail.com>
In-Reply-To: <201104181532.34476.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181533.00721.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

The rt33xx devices support for both PCI and USB devices has been in
the tree for a couple of months now, and seems to be functional and
not in a worse shape than the support for rt28xx and rt30xx devices.

No longer mark it as experimental and enable the support for these
devices by default.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index f630552..e7e361e 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -74,17 +74,13 @@ config RT2800PCI
 if RT2800PCI
 
 config RT2800PCI_RT33XX
-	bool "rt2800pci - Include support for rt33xx devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	default n
+	bool "rt2800pci - Include support for rt33xx devices"
+	default y
 	---help---
 	  This adds support for rt33xx wireless chipset family to the
 	  rt2800pci driver.
 	  Supported chips: RT3390
 
-	  Support for these devices is non-functional at the moment and is
-	  intended for testers and developers.
-
 config RT2800PCI_RT35XX
 	bool "rt2800pci - Include support for rt35xx devices (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -153,17 +149,13 @@ config RT2800USB
 if RT2800USB
 
 config RT2800USB_RT33XX
-	bool "rt2800usb - Include support for rt33xx devices (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	default n
+	bool "rt2800usb - Include support for rt33xx devices"
+	default y
 	---help---
 	  This adds support for rt33xx wireless chipset family to the
 	  rt2800usb driver.
 	  Supported chips: RT3370
 
-	  Support for these devices is non-functional at the moment and is
-	  intended for testers and developers.
-
 config RT2800USB_RT35XX
 	bool "rt2800usb - Include support for rt35xx devices (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-- 
1.7.2.3


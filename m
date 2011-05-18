Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33255 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465Ab1ERS0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 14:26:53 -0400
Received: by mail-ew0-f46.google.com with SMTP id 4so526998ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 11:26:53 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/7] rt2x00: Enabled rt35xx device support by default.
Date: Wed, 18 May 2011 20:26:04 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201105182022.20341.IvDoorn@gmail.com> <201105182023.47984.IvDoorn@gmail.com> <201105182024.21295.IvDoorn@gmail.com>
In-Reply-To: <201105182024.21295.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <201105182026.04503.IvDoorn@gmail.com> (sfid-20110518_202657_446752_58FDA04D)
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Now that support for these devices has been added we can enable them
by default and remove the Kconfig not on support for these devices to
be non-functional.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 9def1e5..3a91033 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -83,14 +83,12 @@ config RT2800PCI_RT33XX
 config RT2800PCI_RT35XX
 	bool "rt2800pci - Include support for rt35xx devices (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	default n
+	default y
 	---help---
 	  This adds support for rt35xx wireless chipset family to the
 	  rt2800pci driver.
 	  Supported chips: RT3060, RT3062, RT3562, RT3592
 
-	  Support for these devices is non-functional at the moment and is
-	  intended for testers and developers.
 
 config RT2800PCI_RT53XX
        bool "rt2800pci - Include support for rt53xx devices (EXPERIMENTAL)"
@@ -154,15 +152,12 @@ config RT2800USB_RT33XX
 config RT2800USB_RT35XX
 	bool "rt2800usb - Include support for rt35xx devices (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	default n
+	default y
 	---help---
 	  This adds support for rt35xx wireless chipset family to the
 	  rt2800usb driver.
 	  Supported chips: RT3572
 
-	  Support for these devices is non-functional at the moment and is
-	  intended for testers and developers.
-
 config RT2800USB_RT53XX
        bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
        depends on EXPERIMENTAL
-- 
1.7.2.3


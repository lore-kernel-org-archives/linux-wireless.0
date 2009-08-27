Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:63407 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZH0PYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 11:24:23 -0400
Received: by mail-ew0-f206.google.com with SMTP id 2so1299828ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 08:24:25 -0700 (PDT)
Message-ID: <4A96A527.5040605@gmail.com>
Date: Thu, 27 Aug 2009 17:24:23 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] b43: Enable LP-PHY support by default and remove Kconfig
 warning
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The most common LP-PHY device, BCM4312, is now fully functional.
So, no need to say "probably won't work for you" anymore.
It's also not "for debuggers and developers only", as it is
perfectly usable for end-users now (at least for BCM4312).

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
This replaces the "remove scary message" patch.

V2: Fix pastebin damage.

 drivers/net/wireless/b43/Kconfig |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 237b1aa..2af3b35 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -82,15 +82,13 @@ config B43_NPHY
 config B43_PHY_LP
 	bool "Support for low-power (LP-PHY) devices (EXPERIMENTAL)"
 	depends on B43 && EXPERIMENTAL
+	default y
 	---help---
 	  Support for the LP-PHY.
 	  The LP-PHY is a low-power PHY built into some notebooks
 	  and embedded devices. It supports 802.11a/g
 	  (802.11a support is optional, and currently disabled).
 
-	  This is heavily experimental, and probably will not work for you.
-	  Say N unless you want to help debug the driver.
-
 # This config option automatically enables b43 LEDS support,
 # if it's possible.
 config B43_LEDS
-- 
1.6.2.4



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28091 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbZG1PDn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 11:03:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 08:03:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH v2] rt2x00: move experimental on kconfig only to rt2800usb
Date: Tue, 28 Jul 2009 08:03:42 -0700
Message-ID: <1248793422-9106-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These drivers have been around for a while, if there are issues
they should be reported. rt2800usb is still a bit flaky though.

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/rt2x00/Kconfig |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index f970aa2..ed1f997 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -1,8 +1,8 @@
 menuconfig RT2X00
 	tristate "Ralink driver support"
-	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on MAC80211 && WLAN_80211
 	---help---
-	  This will enable the experimental support for the Ralink drivers,
+	  This will enable the support for the Ralink drivers,
 	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
 
 	  These drivers make use of the mac80211 stack.
@@ -79,14 +79,14 @@ config RT73USB
 
 config RT2800USB
 	tristate "Ralink rt2800 (USB) support"
-	depends on USB
+	depends on USB && EXPERIMENTAL
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_HT
 	select RT2X00_LIB_FIRMWARE
 	select RT2X00_LIB_CRYPTO
 	select CRC_CCITT
 	---help---
-	  This adds support for rt2800 wireless chipset family.
+	  This adds experimental support for rt2800 wireless chipset family.
 	  Supported chips: RT2770, RT2870 & RT3070.
 
 	  When compiled as a module, this driver will be called "rt2800usb.ko".
-- 
1.6.3.3


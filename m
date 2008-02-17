Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:5154 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbYBQQgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 11:36:01 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1178110fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 08:36:00 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 06/11] rt2x00: Rename dscape -> mac80211
Date: Sun, 17 Feb 2008 17:34:26 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802171730.44353.IvDoorn@gmail.com>
In-Reply-To: <200802171730.44353.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802171734.26423.IvDoorn@gmail.com> (sfid-20080217_163617_170349_E50866D6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The dscape stack was renamed to mac80211 a long time ago,
we are long overdue with fixing all comments to reflect this.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig     |    2 +-
 drivers/net/wireless/rt2x00/rt2400pci.h |    6 +++---
 drivers/net/wireless/rt2x00/rt2500pci.h |    4 ++--
 drivers/net/wireless/rt2x00/rt2500usb.h |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.h   |    4 ++--
 drivers/net/wireless/rt2x00/rt73usb.h   |    4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 4bb46e9..bfeb4f8 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -5,7 +5,7 @@ config RT2X00
 	  This will enable the experimental support for the Ralink drivers,
 	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.
 
-	  These drivers will make use of the Devicescape ieee80211 stack.
+	  These drivers will make use of the mac80211 stack.
 
 	  When building one of the individual drivers, the rt2x00 library
 	  will also be created. That library (when the driver is built as
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index 3d59d66..da178d4 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -923,13 +923,13 @@
 #define RXD_W7_RESERVED			FIELD32(0xffffffff)
 
 /*
- * Macro's for converting txpower from EEPROM to dscape value
- * and from dscape value to register value.
+ * Macro's for converting txpower from EEPROM to mac80211 value
+ * and from mac80211 value to register value.
  * NOTE: Logics in rt2400pci for txpower are reversed
  * compared to the other rt2x00 drivers. A higher txpower
  * value means that the txpower must be lowered. This is
  * important when converting the value coming from the
- * dscape stack to the rt2400 acceptable value.
+ * mac80211 stack to the rt2400 acceptable value.
  */
 #define MIN_TXPOWER	31
 #define MAX_TXPOWER	62
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index 0af130c..1389955 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -1213,8 +1213,8 @@
 #define RXD_W10_DROP			FIELD32(0x00000001)
 
 /*
- * Macro's for converting txpower from EEPROM to dscape value
- * and from dscape value to register value.
+ * Macro's for converting txpower from EEPROM to mac80211 value
+ * and from mac80211 value to register value.
  */
 #define MIN_TXPOWER	0
 #define MAX_TXPOWER	31
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 647cd2d..a37a068 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -787,8 +787,8 @@
 #define RXD_W3_EIV			FIELD32(0xffffffff)
 
 /*
- * Macro's for converting txpower from EEPROM to dscape value
- * and from dscape value to register value.
+ * Macro's for converting txpower from EEPROM to mac80211 value
+ * and from mac80211 value to register value.
  */
 #define MIN_TXPOWER	0
 #define MAX_TXPOWER	31
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index d504e70..4ef7ef3 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -1455,8 +1455,8 @@ struct hw_pairwise_ta_entry {
 #define RXD_W15_RESERVED		FIELD32(0xffffffff)
 
 /*
- * Macro's for converting txpower from EEPROM to dscape value
- * and from dscape value to register value.
+ * Macro's for converting txpower from EEPROM to mac80211 value
+ * and from mac80211 value to register value.
  */
 #define MIN_TXPOWER	0
 #define MAX_TXPOWER	31
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 3f96756..06d6874 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -1023,8 +1023,8 @@ struct hw_pairwise_ta_entry {
 #define RXD_W5_RESERVED			FIELD32(0xffffffff)
 
 /*
- * Macro's for converting txpower from EEPROM to dscape value
- * and from dscape value to register value.
+ * Macro's for converting txpower from EEPROM to mac80211 value
+ * and from mac80211 value to register value.
  */
 #define MIN_TXPOWER	0
 #define MAX_TXPOWER	31
-- 
1.5.4


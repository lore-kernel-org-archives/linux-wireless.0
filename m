Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54675 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954Ab0LTUaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 15:30:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl818x: move rtl8180 and rtl8187 to separate subdirectories
Date: Mon, 20 Dec 2010 15:22:31 -0500
Message-Id: <1292876551-26749-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These drivers share one header file, but nothing else.  Worse, both
drivers use the rtl8225 part with different register settings.  The
results has been some ugly naming -- let's simplify that.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/Makefile              |    9 ++-------
 drivers/net/wireless/rtl818x/rtl8180/Makefile      |    5 +++++
 .../rtl818x/{rtl8180_dev.c => rtl8180/dev.c}       |    8 ++++----
 .../{rtl8180_grf5101.c => rtl8180/grf5101.c}       |    2 +-
 .../{rtl8180_grf5101.h => rtl8180/grf5101.h}       |    0
 .../{rtl8180_max2820.c => rtl8180/max2820.c}       |    2 +-
 .../{rtl8180_max2820.h => rtl8180/max2820.h}       |    0
 .../net/wireless/rtl818x/{ => rtl8180}/rtl8180.h   |    0
 .../{rtl8180_rtl8225.c => rtl8180/rtl8225.c}       |    2 +-
 .../{rtl8180_rtl8225.h => rtl8180/rtl8225.h}       |    0
 .../rtl818x/{rtl8180_sa2400.c => rtl8180/sa2400.c} |    2 +-
 .../rtl818x/{rtl8180_sa2400.h => rtl8180/sa2400.h} |    0
 drivers/net/wireless/rtl818x/rtl8187/Makefile      |    5 +++++
 .../rtl818x/{rtl8187_dev.c => rtl8187/dev.c}       |    6 +++---
 .../rtl818x/{rtl8187_leds.c => rtl8187/leds.c}     |    2 +-
 .../rtl818x/{rtl8187_leds.h => rtl8187/leds.h}     |    0
 .../rtl818x/{rtl8187_rfkill.c => rtl8187/rfkill.c} |    2 +-
 .../rtl818x/{rtl8187_rfkill.h => rtl8187/rfkill.h} |    0
 .../net/wireless/rtl818x/{ => rtl8187}/rtl8187.h   |    2 +-
 .../{rtl8187_rtl8225.c => rtl8187/rtl8225.c}       |    2 +-
 .../{rtl8187_rtl8225.h => rtl8187/rtl8225.h}       |    0
 21 files changed, 27 insertions(+), 22 deletions(-)
 create mode 100644 drivers/net/wireless/rtl818x/rtl8180/Makefile
 rename drivers/net/wireless/rtl818x/{rtl8180_dev.c => rtl8180/dev.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8180_grf5101.c => rtl8180/grf5101.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8180_grf5101.h => rtl8180/grf5101.h} (100%)
 rename drivers/net/wireless/rtl818x/{rtl8180_max2820.c => rtl8180/max2820.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8180_max2820.h => rtl8180/max2820.h} (100%)
 rename drivers/net/wireless/rtl818x/{ => rtl8180}/rtl8180.h (100%)
 rename drivers/net/wireless/rtl818x/{rtl8180_rtl8225.c => rtl8180/rtl8225.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8180_rtl8225.h => rtl8180/rtl8225.h} (100%)
 rename drivers/net/wireless/rtl818x/{rtl8180_sa2400.c => rtl8180/sa2400.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8180_sa2400.h => rtl8180/sa2400.h} (100%)
 create mode 100644 drivers/net/wireless/rtl818x/rtl8187/Makefile
 rename drivers/net/wireless/rtl818x/{rtl8187_dev.c => rtl8187/dev.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8187_leds.c => rtl8187/leds.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8187_leds.h => rtl8187/leds.h} (100%)
 rename drivers/net/wireless/rtl818x/{rtl8187_rfkill.c => rtl8187/rfkill.c} (98%)
 rename drivers/net/wireless/rtl818x/{rtl8187_rfkill.h => rtl8187/rfkill.h} (100%)
 rename drivers/net/wireless/rtl818x/{ => rtl8187}/rtl8187.h (99%)
 rename drivers/net/wireless/rtl818x/{rtl8187_rtl8225.c => rtl8187/rtl8225.c} (99%)
 rename drivers/net/wireless/rtl818x/{rtl8187_rtl8225.h => rtl8187/rtl8225.h} (100%)

diff --git a/drivers/net/wireless/rtl818x/Makefile b/drivers/net/wireless/rtl818x/Makefile
index 93cbfbe..9975690 100644
--- a/drivers/net/wireless/rtl818x/Makefile
+++ b/drivers/net/wireless/rtl818x/Makefile
@@ -1,7 +1,2 @@
-rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o rtl8180_grf5101.o
-rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o rtl8187_leds.o rtl8187_rfkill.o
-
-obj-$(CONFIG_RTL8180)	+= rtl8180.o
-obj-$(CONFIG_RTL8187)	+= rtl8187.o
-
-
+obj-$(CONFIG_RTL8180)	+= rtl8180/
+obj-$(CONFIG_RTL8187)	+= rtl8187/
diff --git a/drivers/net/wireless/rtl818x/rtl8180/Makefile b/drivers/net/wireless/rtl818x/rtl8180/Makefile
new file mode 100644
index 0000000..cb4fb85
--- /dev/null
+++ b/drivers/net/wireless/rtl818x/rtl8180/Makefile
@@ -0,0 +1,5 @@
+rtl8180-objs		:= dev.o rtl8225.o sa2400.o max2820.o grf5101.o
+
+obj-$(CONFIG_RTL8180)	+= rtl8180.o
+
+ccflags-y += -Idrivers/net/wireless/rtl818x
diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
similarity index 99%
rename from drivers/net/wireless/rtl818x/rtl8180_dev.c
rename to drivers/net/wireless/rtl818x/rtl8180/dev.c
index 707c688..5851cbc 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -24,10 +24,10 @@
 #include <net/mac80211.h>
 
 #include "rtl8180.h"
-#include "rtl8180_rtl8225.h"
-#include "rtl8180_sa2400.h"
-#include "rtl8180_max2820.h"
-#include "rtl8180_grf5101.h"
+#include "rtl8225.h"
+#include "sa2400.h"
+#include "max2820.h"
+#include "grf5101.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
diff --git a/drivers/net/wireless/rtl818x/rtl8180_grf5101.c b/drivers/net/wireless/rtl818x/rtl8180/grf5101.c
similarity index 99%
rename from drivers/net/wireless/rtl818x/rtl8180_grf5101.c
rename to drivers/net/wireless/rtl818x/rtl8180/grf5101.c
index 5cab9df..5ee7589 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_grf5101.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/grf5101.c
@@ -25,7 +25,7 @@
 #include <net/mac80211.h>
 
 #include "rtl8180.h"
-#include "rtl8180_grf5101.h"
+#include "grf5101.h"
 
 static const int grf5101_encode[] = {
 	0x0, 0x8, 0x4, 0xC,
diff --git a/drivers/net/wireless/rtl818x/rtl8180_grf5101.h b/drivers/net/wireless/rtl818x/rtl8180/grf5101.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180_grf5101.h
rename to drivers/net/wireless/rtl818x/rtl8180/grf5101.h
diff --git a/drivers/net/wireless/rtl818x/rtl8180_max2820.c b/drivers/net/wireless/rtl818x/rtl8180/max2820.c
similarity index 99%
rename from drivers/net/wireless/rtl818x/rtl8180_max2820.c
rename to drivers/net/wireless/rtl818x/rtl8180/max2820.c
index 16c4655..667b336 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_max2820.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/max2820.c
@@ -24,7 +24,7 @@
 #include <net/mac80211.h>
 
 #include "rtl8180.h"
-#include "rtl8180_max2820.h"
+#include "max2820.h"
 
 static const u32 max2820_chan[] = {
 	12, /* CH 1 */
diff --git a/drivers/net/wireless/rtl818x/rtl8180_max2820.h b/drivers/net/wireless/rtl818x/rtl8180/max2820.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180_max2820.h
rename to drivers/net/wireless/rtl818x/rtl8180/max2820.h
diff --git a/drivers/net/wireless/rtl818x/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180.h
rename to drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
diff --git a/drivers/net/wireless/rtl818x/rtl8180_rtl8225.c b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
similarity index 99%
rename from drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
rename to drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
index 69e4d47..7c4574b 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
@@ -21,7 +21,7 @@
 #include <net/mac80211.h>
 
 #include "rtl8180.h"
-#include "rtl8180_rtl8225.h"
+#include "rtl8225.h"
 
 static void rtl8225_write(struct ieee80211_hw *dev, u8 addr, u16 data)
 {
diff --git a/drivers/net/wireless/rtl818x/rtl8180_rtl8225.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180_rtl8225.h
rename to drivers/net/wireless/rtl818x/rtl8180/rtl8225.h
diff --git a/drivers/net/wireless/rtl818x/rtl8180_sa2400.c b/drivers/net/wireless/rtl818x/rtl8180/sa2400.c
similarity index 99%
rename from drivers/net/wireless/rtl818x/rtl8180_sa2400.c
rename to drivers/net/wireless/rtl818x/rtl8180/sa2400.c
index d064fcc..44771a62 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_sa2400.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/sa2400.c
@@ -25,7 +25,7 @@
 #include <net/mac80211.h>
 
 #include "rtl8180.h"
-#include "rtl8180_sa2400.h"
+#include "sa2400.h"
 
 static const u32 sa2400_chan[] = {
 	0x00096c, /* ch1 */
diff --git a/drivers/net/wireless/rtl818x/rtl8180_sa2400.h b/drivers/net/wireless/rtl818x/rtl8180/sa2400.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180_sa2400.h
rename to drivers/net/wireless/rtl818x/rtl8180/sa2400.h
diff --git a/drivers/net/wireless/rtl818x/rtl8187/Makefile b/drivers/net/wireless/rtl818x/rtl8187/Makefile
new file mode 100644
index 0000000..7b62992
--- /dev/null
+++ b/drivers/net/wireless/rtl818x/rtl8187/Makefile
@@ -0,0 +1,5 @@
+rtl8187-objs		:= dev.o rtl8225.o leds.o rfkill.o
+
+obj-$(CONFIG_RTL8187)	+= rtl8187.o
+
+ccflags-y += -Idrivers/net/wireless/rtl818x
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
similarity index 99%
rename from drivers/net/wireless/rtl818x/rtl8187_dev.c
rename to drivers/net/wireless/rtl818x/rtl8187/dev.c
index eeee244..6b82cac 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -29,11 +29,11 @@
 #include <net/mac80211.h>
 
 #include "rtl8187.h"
-#include "rtl8187_rtl8225.h"
+#include "rtl8225.h"
 #ifdef CONFIG_RTL8187_LEDS
-#include "rtl8187_leds.h"
+#include "leds.h"
 #endif
-#include "rtl8187_rfkill.h"
+#include "rfkill.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c b/drivers/net/wireless/rtl818x/rtl8187/leds.c
similarity index 99%
rename from drivers/net/wireless/rtl818x/rtl8187_leds.c
rename to drivers/net/wireless/rtl818x/rtl8187/leds.c
index 4637337..2e0de2f 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/leds.c
@@ -20,7 +20,7 @@
 #include <linux/eeprom_93cx6.h>
 
 #include "rtl8187.h"
-#include "rtl8187_leds.h"
+#include "leds.h"
 
 static void led_turn_on(struct work_struct *work)
 {
diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.h b/drivers/net/wireless/rtl818x/rtl8187/leds.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8187_leds.h
rename to drivers/net/wireless/rtl818x/rtl8187/leds.h
diff --git a/drivers/net/wireless/rtl818x/rtl8187_rfkill.c b/drivers/net/wireless/rtl818x/rtl8187/rfkill.c
similarity index 98%
rename from drivers/net/wireless/rtl818x/rtl8187_rfkill.c
rename to drivers/net/wireless/rtl818x/rtl8187/rfkill.c
index 03555e1..3411671 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/rfkill.c
@@ -18,7 +18,7 @@
 #include <net/mac80211.h>
 
 #include "rtl8187.h"
-#include "rtl8187_rfkill.h"
+#include "rfkill.h"
 
 static bool rtl8187_is_radio_enabled(struct rtl8187_priv *priv)
 {
diff --git a/drivers/net/wireless/rtl818x/rtl8187_rfkill.h b/drivers/net/wireless/rtl818x/rtl8187/rfkill.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8187_rfkill.h
rename to drivers/net/wireless/rtl818x/rtl8187/rfkill.h
diff --git a/drivers/net/wireless/rtl818x/rtl8187.h b/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
similarity index 99%
rename from drivers/net/wireless/rtl818x/rtl8187.h
rename to drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
index 9887816..0d7b142 100644
--- a/drivers/net/wireless/rtl818x/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
@@ -16,7 +16,7 @@
 #define RTL8187_H
 
 #include "rtl818x.h"
-#include "rtl8187_leds.h"
+#include "leds.h"
 
 #define RTL8187_EEPROM_TXPWR_BASE	0x05
 #define RTL8187_EEPROM_MAC_ADDR		0x07
diff --git a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c b/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
similarity index 99%
rename from drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
rename to drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
index 5c6666f..908903f 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
@@ -21,7 +21,7 @@
 #include <net/mac80211.h>
 
 #include "rtl8187.h"
-#include "rtl8187_rtl8225.h"
+#include "rtl8225.h"
 
 static void rtl8225_write_bitbang(struct ieee80211_hw *dev, u8 addr, u16 data)
 {
diff --git a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.h b/drivers/net/wireless/rtl818x/rtl8187/rtl8225.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8187_rtl8225.h
rename to drivers/net/wireless/rtl818x/rtl8187/rtl8225.h
-- 
1.7.3.3


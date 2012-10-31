Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:43467 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423159Ab2JaQY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 12:24:29 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 2/2] wireless: integrate wil6210 driver into build structure
Date: Wed, 31 Oct 2012 18:23:55 +0200
Message-ID: <1351700635-1462-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121031_172435_394495_3F82061E)
In-Reply-To: <1351700635-1462-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1351700635-1462-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/Kconfig          |    8 ++++++--
 drivers/net/wireless/ath/Makefile         |    1 +
 drivers/net/wireless/ath/ar5523/Kconfig   |    1 +
 drivers/net/wireless/ath/ath5k/Kconfig    |    1 +
 drivers/net/wireless/ath/ath6kl/Kconfig   |    1 +
 drivers/net/wireless/ath/ath9k/Kconfig    |    1 +
 drivers/net/wireless/ath/carl9170/Kconfig |    1 +
 drivers/net/wireless/ath/wil6210/Kconfig  |   23 +++--------------------
 8 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index c25dcf1..2c02b4e 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -1,4 +1,7 @@
-menuconfig ATH_COMMON
+config ATH_COMMON
+	tristate
+
+menuconfig ATH_CARDS
 	tristate "Atheros Wireless Cards"
 	depends on CFG80211 && (!UML || BROKEN)
 	---help---
@@ -14,7 +17,7 @@ menuconfig ATH_COMMON
 
 	  http://wireless.kernel.org/en/users/Drivers/Atheros
 
-if ATH_COMMON
+if ATH_CARDS
 
 config ATH_DEBUG
 	bool "Atheros wireless debugging"
@@ -27,5 +30,6 @@ source "drivers/net/wireless/ath/ath9k/Kconfig"
 source "drivers/net/wireless/ath/carl9170/Kconfig"
 source "drivers/net/wireless/ath/ath6kl/Kconfig"
 source "drivers/net/wireless/ath/ar5523/Kconfig"
+source "drivers/net/wireless/ath/wil6210/Kconfig"
 
 endif
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index 1e18621..97b964d 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_ATH9K_HW)		+= ath9k/
 obj-$(CONFIG_CARL9170)		+= carl9170/
 obj-$(CONFIG_ATH6KL)		+= ath6kl/
 obj-$(CONFIG_AR5523)		+= ar5523/
+obj-$(CONFIG_WIL6210)		+= wil6210/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
diff --git a/drivers/net/wireless/ath/ar5523/Kconfig b/drivers/net/wireless/ath/ar5523/Kconfig
index 11d99ee..0d320cc 100644
--- a/drivers/net/wireless/ath/ar5523/Kconfig
+++ b/drivers/net/wireless/ath/ar5523/Kconfig
@@ -1,6 +1,7 @@
 config AR5523
        tristate "Atheros AR5523 wireless driver support"
        depends on MAC80211 && USB
+       select ATH_COMMON
        select FW_LOADER
        ---help---
          This module add support for AR5523 based USB dongles such as D-Link
diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index 338c5c4..c9f81a3 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -1,6 +1,7 @@
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on (PCI || ATHEROS_AR231X) && MAC80211
+	select ATH_COMMON
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index d755a5e..2a61989 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -1,5 +1,6 @@
 config ATH6KL
 	tristate "Atheros mobile chipsets support"
+	select ATH_COMMON
 
 config ATH6KL_SDIO
 	tristate "Atheros ath6kl SDIO support"
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index c7aa664..5fc15bf 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -17,6 +17,7 @@ config ATH9K_BTCOEX_SUPPORT
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on MAC80211
+	select ATH_COMMON
 	select ATH9K_HW
 	select MAC80211_LEDS
 	select LEDS_CLASS
diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index 267d5dc..13a2045 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -1,6 +1,7 @@
 config CARL9170
 	tristate "Linux Community AR9170 802.11n USB support"
 	depends on USB && MAC80211 && EXPERIMENTAL
+	select ATH_COMMON
 	select FW_LOADER
 	select CRC32
 	help
diff --git a/drivers/net/wireless/ath/wil6210/Kconfig b/drivers/net/wireless/ath/wil6210/Kconfig
index b927adc..cfe2346 100644
--- a/drivers/net/wireless/ath/wil6210/Kconfig
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -7,7 +7,9 @@ config WIL6210
 	---help---
 	  This module adds support for wireless adapter based on
 	  wil6210 chip by Wilocity. It supports operation on the
-	  60g band, covered by the IEEE802.11ad standard.
+	  60g band, covered by the IEEE802.11ad standard. See
+	  http://wireless.kernel.org/en/users/Drivers/wil6210
+	  for more information.
 	  If you choose to build it as a module, it will be called
 	  wil6210
 
@@ -26,22 +28,3 @@ config WIL6210_ISR_COR
 	  such monitoring impossible.
 	  Say y unless you debug interrupts
 
-config WIL6210_DEBUG_TXRX
-	bool "Debug Tx/Rx path for wil6210"
-	depends on WIL6210
-	default n
-	---help---
-	  Enables Tx/Rx path debug. It will emitt lots of messages.
-	  Every Tx and Rx frame will be dumped, with some
-	  auxiliary information.
-	  Use with care.
-
-config WIL6210_DEBUG_IRQ
-	bool "Debug IRQ flows for wil6210"
-	depends on WIL6210
-	default n
-	---help---
-	  Enables IRQ debug. It will emitt lots of messages.
-	  For every IRQ its ISR bits will be printed, with
-	  some extra analysis.
-	  Use with care.
-- 
1.7.10.4


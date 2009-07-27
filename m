Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60486 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbZG0XwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 19:52:16 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 16:52:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath: simplify kconfig dependency and add documentation
Date: Mon, 27 Jul 2009 16:52:07 -0700
Message-ID: <1248738730-4003-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248738730-4003-1-git-send-email-lrodriguez@atheros.com>
References: <1248738730-4003-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make atheros wireless drivers visible when you select
"Atheros wirless drivers". Adds links to ath.ko page,
and Atheros drivers page on the wiki.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/Kconfig        |   18 ++++++++++++++++--
 drivers/net/wireless/ath/ar9170/Kconfig |    1 -
 drivers/net/wireless/ath/ath5k/Kconfig  |    1 -
 drivers/net/wireless/ath/ath9k/Kconfig  |    1 -
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 6bed009..f27f3a7 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -2,9 +2,23 @@ config ATH_COMMON
 	tristate "Atheros Wireless Cards"
 	depends on WLAN_80211
 	depends on CFG80211
-	depends on ATH5K || ATH9K || AR9170_USB
+	---help---
+	  This will enable the support for the Atheros wireless drivers.
+	  ath5k, ath9k and ar9170 drivers share some common code, this option
+	  enables the common ath.ko module which currently shares just common
+	  regulatory EEPROM helpers but will likely be extended later to share
+	  more between modules.
 
+	  For more information and documentation on this module you can visit:
+
+	  http://wireless.kernel.org/en/users/Drivers/ath
+
+	  For information on all Atheros wireless drivers visit:
+
+	  http://wireless.kernel.org/en/users/Drivers/Atheros
+
+if ATH_COMMON
 source "drivers/net/wireless/ath/ath5k/Kconfig"
 source "drivers/net/wireless/ath/ath9k/Kconfig"
 source "drivers/net/wireless/ath/ar9170/Kconfig"
-
+endif
diff --git a/drivers/net/wireless/ath/ar9170/Kconfig b/drivers/net/wireless/ath/ar9170/Kconfig
index b99e326..de4281f 100644
--- a/drivers/net/wireless/ath/ar9170/Kconfig
+++ b/drivers/net/wireless/ath/ar9170/Kconfig
@@ -2,7 +2,6 @@ config AR9170_USB
 	tristate "Atheros AR9170 802.11n USB support"
 	depends on USB && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
-	select ATH_COMMON
 	help
 	  This is a driver for the Atheros "otus" 802.11n USB devices.
 
diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index daf0c83..9b07eef 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -1,7 +1,6 @@
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
-	select ATH_COMMON
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 0f4a6d8..2cb72f8 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -1,7 +1,6 @@
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211
-	select ATH_COMMON
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
-- 
1.6.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:38259 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758812Ab2J2L6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 07:58:45 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 2/2] wireless: integrate wil6210 driver into build structure
Date: Mon, 29 Oct 2012 13:58:26 +0200
Message-ID: <1351511906-19989-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121029_125853_008973_C99428EC)
In-Reply-To: <1351511906-19989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1351511906-19989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wil6210 do not use Atheros common framework in form of
ath.ko module, so make small restructure to separate
"belonging to Atheros family" and "using ath.ko"

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/Kconfig          |    8 ++++++--
 drivers/net/wireless/ath/Makefile         |    1 +
 drivers/net/wireless/ath/ath5k/Kconfig    |    1 +
 drivers/net/wireless/ath/ath6kl/Kconfig   |    1 +
 drivers/net/wireless/ath/ath9k/Kconfig    |    1 +
 drivers/net/wireless/ath/carl9170/Kconfig |    1 +
 6 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 0960224..69ecb74 100644
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
@@ -26,5 +29,6 @@ source "drivers/net/wireless/ath/ath5k/Kconfig"
 source "drivers/net/wireless/ath/ath9k/Kconfig"
 source "drivers/net/wireless/ath/carl9170/Kconfig"
 source "drivers/net/wireless/ath/ath6kl/Kconfig"
+source "drivers/net/wireless/ath/wil6210/Kconfig"
 
 endif
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index d716b74..b1af57b 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_ATH5K)		+= ath5k/
 obj-$(CONFIG_ATH9K_HW)		+= ath9k/
 obj-$(CONFIG_CARL9170)		+= carl9170/
 obj-$(CONFIG_ATH6KL)		+= ath6kl/
+obj-$(CONFIG_WIL6210)		+= wil6210/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
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
-- 
1.7.10.4


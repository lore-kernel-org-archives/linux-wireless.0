Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:56497 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaCIG5q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 01:57:46 -0500
Subject: [PATCH 6/6] ath6kl: update Kconfig descriptions
To: ath6kl@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 09 Mar 2014 08:57:46 +0200
Message-ID: <20140309065746.10793.56291.stgit@x230> (sfid-20140309_075748_851230_40520C39)
In-Reply-To: <20140309065606.10793.67068.stgit@x230>
References: <20140309065606.10793.67068.stgit@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The help text were either out of date, too small or didn't exist at all. Also
move cfg80211 dependency to ath6kl_core module as it has all the calls to
cfg80211.

Fixes checkpatch warning:

WARNING: please write a paragraph that describes the config symbol fully

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Kconfig |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index e39e586..9c125ff 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -1,11 +1,19 @@
 config ATH6KL
 	tristate "Atheros mobile chipsets support"
+	depends on CFG80211
+        ---help---
+	  This module adds core support for wireless adapters based on
+	  Atheros AR6003 and AR6004 chipsets. You still need separate
+	  bus drivers for USB and SDIO to be able to use real devices.
+
+	  If you choose to build it as a module, it will be called
+	  ath6kl_core. Please note that AR6002 and AR6001 are not
+	  supported by this driver.
 
 config ATH6KL_SDIO
 	tristate "Atheros ath6kl SDIO support"
 	depends on ATH6KL
 	depends on MMC
-	depends on CFG80211
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros AR6003 and AR6004 chipsets running over SDIO. If you
@@ -17,25 +25,31 @@ config ATH6KL_USB
 	tristate "Atheros ath6kl USB support"
 	depends on ATH6KL
 	depends on USB
-	depends on CFG80211
 	---help---
 	  This module adds support for wireless adapters based on
-	  Atheros AR6004 chipset running over USB. This is still under
-	  implementation and it isn't functional. If you choose to
-	  build it as a module, it will be called ath6kl_usb.
+	  Atheros AR6004 chipset and chipsets based on it running over
+	  USB. If you choose to build it as a module, it will be
+	  called ath6kl_usb.
 
 config ATH6KL_DEBUG
 	bool "Atheros ath6kl debugging"
 	depends on ATH6KL
 	---help---
-	  Enables debug support
+	  Enables ath6kl debug support, including debug messages
+	  enabled with debug_mask module parameter and debugfs
+	  interface.
+
+	  If unsure, say Y to make it easier to debug problems.
 
 config ATH6KL_TRACING
 	bool "Atheros ath6kl tracing support"
 	depends on ATH6KL
 	depends on EVENT_TRACING
 	---help---
-	  Select this to ath6kl use tracing infrastructure.
+	  Select this to ath6kl use tracing infrastructure which, for
+	  example, can be enabled with help of trace-cmd. All debug
+	  messages and commands are delivered to using individually
+	  enablable trace points.
 
 	  If unsure, say Y to make it easier to debug problems.
 
@@ -47,3 +61,5 @@ config ATH6KL_REGDOMAIN
 	  Enabling this makes it possible to change the regdomain in
 	  the firmware. This can be only enabled if regulatory requirements
 	  are taken into account.
+
+	  If unsure, say N.


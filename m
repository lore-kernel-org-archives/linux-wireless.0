Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbbECTck (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:40 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/42] iwlwifi: clarify the device / firmware mapping in Kconfig
Date: Sun,  3 May 2015 22:31:31 +0300
Message-Id: <1430681513-7838-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213425_074224_95A7D432)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The lists of the devices supported by either MVM or DVM
firmwares was incomplete. Point to
https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#firmware
instead of maintaining the lists.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index ab019b4..99f9760 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -21,6 +21,7 @@ config IWLWIFI
 		Intel 7260 Wi-Fi Adapter
 		Intel 3160 Wi-Fi Adapter
 		Intel 7265 Wi-Fi Adapter
+		Intel 8260 Wi-Fi Adapter
 
 
 	  This driver uses the kernel's mac80211 subsystem.
@@ -53,16 +54,17 @@ config IWLDVM
 	tristate "Intel Wireless WiFi DVM Firmware support"
 	default IWLWIFI
 	help
-	  This is the driver that supports the DVM firmware which is
-	  used by most existing devices (with the exception of 7260
-	  and 3160).
+	  This is the driver that supports the DVM firmware. The list
+	  of the devices that use this firmware is available here:
+	  https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#firmware
 
 config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
 	select WANT_DEV_COREDUMP
 	help
-	  This is the driver that supports the MVM firmware which is
-	  currently only available for 7260 and 3160 devices.
+	  This is the driver that supports the MVM firmware. The list
+	  of the devices that use this firmware is available here:
+	  https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#firmware
 
 # don't call it _MODULE -- will confuse Kconfig/fixdep/...
 config IWLWIFI_OPMODE_MODULAR
-- 
2.1.0


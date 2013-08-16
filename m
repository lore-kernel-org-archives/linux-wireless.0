Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3HPLIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:08:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 17/20] iwlwifi: Kconfig: fix help texts wrt 7260 and 3160 devices
Date: Fri, 16 Aug 2013 13:07:07 +0200
Message-Id: <1376651230-1060-17-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130807_956910_5494F8D0)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Fix the help texts to properly reflect the 7260 and 3160 devices
support.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index e5c133e..3eb2102 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -22,6 +22,8 @@ config IWLWIFI
 		Intel Wireless WiFi Link 6150BGN 2 Adapter
 		Intel 100 Series Wi-Fi Adapters (100BGN and 130BGN)
 		Intel 2000 Series Wi-Fi Adapters
+		Intel 7260 Wi-Fi Adapter
+		Intel 3160 Wi-Fi Adapter
 
 
 	  This driver uses the kernel's mac80211 subsystem.
@@ -46,17 +48,16 @@ config IWLDVM
 	depends on IWLWIFI
 	default IWLWIFI
 	help
-	  This is the driver supporting the DVM firmware which is
-	  currently the only firmware available for existing devices.
+	  This is the driver that supports the DVM firmware which is
+	  used by most existing devices (with the exception of 7260
+	  and 3160).
 
 config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
 	depends on IWLWIFI
 	help
-	  This is the driver supporting the MVM firmware which is
-	  currently only available for 7000 series devices.
-
-	  Say yes if you have such a device.
+	  This is the driver that supports the MVM firmware which is
+	  currently only available for 7260 and 3160 devices.
 
 # don't call it _MODULE -- will confuse Kconfig/fixdep/...
 config IWLWIFI_OPMODE_MODULAR
-- 
1.8.4.rc2


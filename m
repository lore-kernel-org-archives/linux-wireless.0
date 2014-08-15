Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from platinum.linx.net ([195.66.234.3]:48076 "EHLO platinum.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbaHOKbk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2014 06:31:40 -0400
From: Tony Vroon <tony@linx.net>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] iwlwifi: Correctly deal with monolithic kernels
Message-Id: <20140815102354.96039202E9@platinum.linx.net> (sfid-20140815_123144_452939_F23B0784)
Date: Fri, 15 Aug 2014 11:23:54 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Post 3.16 any non-modular kernel ends up with IWLWIFI selectable but neither of the 
underlying required DVM or MVM drivers. This violates the principle of least 
astonishment.
If IWLWIFI only supports a modular system the main IWLWIFI should depend on m as well. 
Otherwise, removing the "depends on m" allows monolithic kernels to work once again.

Signed-off-by: Tony Vroon <tony@linx.net>

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 6451d2b..824f5e2 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -51,7 +51,6 @@ config IWLWIFI_LEDS
 
 config IWLDVM
 	tristate "Intel Wireless WiFi DVM Firmware support"
-	depends on m
 	default IWLWIFI
 	help
 	  This is the driver that supports the DVM firmware which is
@@ -60,7 +59,6 @@ config IWLDVM
 
 config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
-	depends on m
 	help
 	  This is the driver that supports the MVM firmware which is
 	  currently only available for 7260 and 3160 devices.

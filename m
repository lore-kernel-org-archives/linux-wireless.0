Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:32939 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbaGVT1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:10 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so113642wes.23
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:09 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 03/20] iwlwifi: fix Kconfig issues
Date: Tue, 22 Jul 2014 22:26:34 +0300
Message-Id: <1406057211-31752-3-git-send-email-egrumbach@gmail.com> (sfid-20140722_212717_417964_201F80E7)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Randy fixes a few issues in iwlwifi's Kconfig. Because of
this, 'Debugging options' was not indented under iwlwifi
using menuconfig.

I added a few other fixes on the way, like the link to the
website and added 7265 in the supported NICs.

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
[ Commit message + other fixes ]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 7fd5042..6451d2b 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -20,16 +20,17 @@ config IWLWIFI
 		Intel 2000 Series Wi-Fi Adapters
 		Intel 7260 Wi-Fi Adapter
 		Intel 3160 Wi-Fi Adapter
+		Intel 7265 Wi-Fi Adapter
 
 
 	  This driver uses the kernel's mac80211 subsystem.
 
-	  In order to use this driver, you will need a microcode (uCode)
+	  In order to use this driver, you will need a firmware
 	  image for it. You can obtain the microcode from:
 
-	          <http://intellinuxwireless.org/>.
+	          <http://wireless.kernel.org/en/users/Drivers/iwlwifi>.
 
-	  The microcode is typically installed in /lib/firmware. You can
+	  The firmware is typically installed in /lib/firmware. You can
 	  look in the hotplug script /etc/hotplug/firmware.agent to
 	  determine which directory FIRMWARE_DIR is set to when the script
 	  runs.
@@ -39,9 +40,10 @@ config IWLWIFI
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwlwifi.
 
+if IWLWIFI
+
 config IWLWIFI_LEDS
 	bool
-	depends on IWLWIFI
 	depends on LEDS_CLASS=y || LEDS_CLASS=IWLWIFI
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
@@ -49,7 +51,7 @@ config IWLWIFI_LEDS
 
 config IWLDVM
 	tristate "Intel Wireless WiFi DVM Firmware support"
-	depends on IWLWIFI
+	depends on m
 	default IWLWIFI
 	help
 	  This is the driver that supports the DVM firmware which is
@@ -58,7 +60,7 @@ config IWLDVM
 
 config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
-	depends on IWLWIFI
+	depends on m
 	help
 	  This is the driver that supports the MVM firmware which is
 	  currently only available for 7260 and 3160 devices.
@@ -70,7 +72,7 @@ config IWLWIFI_OPMODE_MODULAR
 	default y if IWLMVM=m
 
 comment "WARNING: iwlwifi is useless without IWLDVM or IWLMVM"
-	depends on IWLWIFI && IWLDVM=n && IWLMVM=n
+	depends on IWLDVM=n && IWLMVM=n
 
 config IWLWIFI_BCAST_FILTERING
 	bool "Enable broadcast filtering"
@@ -86,11 +88,9 @@ config IWLWIFI_BCAST_FILTERING
 	  expect incoming broadcasts for their normal operations.
 
 menu "Debugging Options"
-	depends on IWLWIFI
 
 config IWLWIFI_DEBUG
 	bool "Enable full debugging output in the iwlwifi driver"
-	depends on IWLWIFI
 	---help---
 	  This option will enable debug tracing output for the iwlwifi drivers
 
@@ -115,7 +115,7 @@ config IWLWIFI_DEBUG
 
 config IWLWIFI_DEBUGFS
         bool "iwlwifi debugfs support"
-        depends on IWLWIFI && MAC80211_DEBUGFS
+        depends on MAC80211_DEBUGFS
         ---help---
 	  Enable creation of debugfs files for the iwlwifi drivers. This
 	  is a low-impact option that allows getting insight into the
@@ -123,13 +123,12 @@ config IWLWIFI_DEBUGFS
 
 config IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
         bool "Experimental uCode support"
-        depends on IWLWIFI && IWLWIFI_DEBUG
+        depends on IWLWIFI_DEBUG
         ---help---
 	  Enable use of experimental ucode for testing and debugging.
 
 config IWLWIFI_DEVICE_TRACING
 	bool "iwlwifi device access tracing"
-	depends on IWLWIFI
 	depends on EVENT_TRACING
 	help
 	  Say Y here to trace all commands, including TX frames and IO
@@ -145,3 +144,5 @@ config IWLWIFI_DEVICE_TRACING
 	  If unsure, say Y so we can help you better when problems
 	  occur.
 endmenu
+
+endif
-- 
1.8.3.2


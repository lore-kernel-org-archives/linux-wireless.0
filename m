Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4045 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab3BLTpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 14:45:33 -0500
Date: Tue, 12 Feb 2013 13:45:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Rework Kconfig
Message-ID: <511a9bda.qSVbJjBneEGprv+8%Larry.Finger@lwfinger.net> (sfid-20130212_204536_418264_5C15EC2B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the number of drivers in the rtlwifi family has grown, the Kconfig
section for them has grown unwieldy. This change has two effects: (1)
Variable RTLWIFI_DEBUG is documented, and (2) the entries for the
drivers that depend on RTLWIFI and indented.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch has no particular urgency. It makes no functional
change in the kernel,

Thanks,

Larry
---

 Kconfig |   50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/Kconfig
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/Kconfig
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/Kconfig
@@ -1,8 +1,26 @@
+config RTLWIFI
+	tristate "Realtek wireless card support"
+	depends on MAC80211
+	select FW_LOADER
+	---help---
+	  This is common code for RTL8192CE/RTL8192CU/RTL8192SE/RTL8723AE
+	  drivers.  This module does nothing by itself - the various front-end
+	  drivers need to be enabled to support any desired devices.
+
+	  If you choose to build as a module, it'll be called rtlwifi.
+
+config RTLWIFI_DEBUG
+	bool "Debugging output for rtlwifi driver family"
+	depends on RTLWIFI
+	default y
+	---help---
+	This option is needed for the "debug=n" module option to produce any
+	output. For embedded or other memory-limited systems, choose "N".
+	For all other systems, or if in doubt, use "Y".
+
 config RTL8192CE
 	tristate "Realtek RTL8192CE/RTL8188CE Wireless Network Adapter"
-	depends on MAC80211 && PCI
-	select FW_LOADER
-	select RTLWIFI
+	depends on RTLWIFI && PCI
 	select RTL8192C_COMMON
 	---help---
 	This is the driver for Realtek RTL8192CE/RTL8188CE 802.11n PCIe
@@ -12,9 +30,7 @@ config RTL8192CE
 
 config RTL8192SE
 	tristate "Realtek RTL8192SE/RTL8191SE PCIe Wireless Network Adapter"
-	depends on MAC80211 && PCI
-	select FW_LOADER
-	select RTLWIFI
+	depends on RTLWIFI && PCI
 	---help---
 	This is the driver for Realtek RTL8192SE/RTL8191SE 802.11n PCIe
 	wireless network adapters.
@@ -23,9 +39,7 @@ config RTL8192SE
 
 config RTL8192DE
 	tristate "Realtek RTL8192DE/RTL8188DE PCIe Wireless Network Adapter"
-	depends on MAC80211 && PCI
-	select FW_LOADER
-	select RTLWIFI
+	depends on RTLWIFI && PCI
 	---help---
 	This is the driver for Realtek RTL8192DE/RTL8188DE 802.11n PCIe
 	wireless network adapters.
@@ -34,9 +48,7 @@ config RTL8192DE
 
 config RTL8723AE
 	tristate "Realtek RTL8723AE PCIe Wireless Network Adapter"
-	depends on MAC80211 && PCI && EXPERIMENTAL
-	select FW_LOADER
-	select RTLWIFI
+	depends on RTLWIFI && PCI
 	---help---
 	This is the driver for Realtek RTL8723AE 802.11n PCIe
 	wireless network adapters.
@@ -45,9 +57,7 @@ config RTL8723AE
 
 config RTL8192CU
 	tristate "Realtek RTL8192CU/RTL8188CU USB Wireless Network Adapter"
-	depends on MAC80211 && USB
-	select FW_LOADER
-	select RTLWIFI
+	depends on RTLWIFI && USB
 	select RTL8192C_COMMON
 	---help---
 	This is the driver for Realtek RTL8192CU/RTL8188CU 802.11n USB
@@ -55,16 +65,6 @@ config RTL8192CU
 
 	If you choose to build it as a module, it will be called rtl8192cu
 
-config RTLWIFI
-	tristate
-	depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE || RTL8723AE
-	default m
-
-config RTLWIFI_DEBUG
-	bool "Additional debugging output"
-	depends on RTL8192CE || RTL8192CU || RTL8192SE || RTL8192DE || RTL8723AE
-	default y
-
 config RTL8192C_COMMON
 	tristate
 	depends on RTL8192CE || RTL8192CU

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:26651 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753113AbXLRXhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 18:37:21 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] p54: add Kconfig description
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 Dec 2007 18:36:10 -0500
Message-ID: <20071218233610.15652.21165.stgit@tetra.sourmilk.net> (sfid-20071218_233727_412256_881086ED)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some people would like to know what p54 is.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/Kconfig |   51 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 4430b32..e4be4bb 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -600,15 +600,66 @@ config ADM8211
 config P54_COMMON
 	tristate "Softmac Prism54 support"
 	depends on MAC80211 && WLAN_80211 && FW_LOADER && EXPERIMENTAL
+	---help---
+	  This is common code for isl38xx based cards.
+	  This module does nothing by itself - the USB/PCI frontends
+	  also need to be enabled in order to support any devices.
+
+	  These devices require softmac firmware which can be found at
+	  http://prism54.org/
+
+	  If you choose to build a module, it'll be called p54common.
 
 config P54_USB
 	tristate "Prism54 USB support"
 	depends on P54_COMMON && USB
 	select CRC32
+	---help---
+	  This driver is for USB isl38xx based wireless cards.
+	  These are USB based adapters found in devices such as:
+
+	  3COM 3CRWE254G72
+	  SMC 2862W-G
+	  Accton 802.11g WN4501 USB
+	  Siemens Gigaset USB
+	  Netgear WG121
+	  Netgear WG111
+	  Medion 40900, Roper Europe
+	  Shuttle PN15, Airvast WM168g, IOGear GWU513
+	  Linksys WUSB54G
+	  Linksys WUSB54G Portable
+	  DLink DWL-G120 Spinnaker
+	  DLink DWL-G122
+	  Belkin F5D7050 ver 1000
+	  Cohiba Proto board
+	  SMC 2862W-G version 2
+	  U.S. Robotics U5 802.11g Adapter
+	  FUJITSU E-5400 USB D1700
+	  Sagem XG703A
+	  DLink DWL-G120 Cohiba
+	  Spinnaker Proto board
+	  Linksys WUSB54AG
+	  Inventel UR054G
+	  Spinnaker DUT
+
+	  These devices require softmac firmware which can be found at
+	  http://prism54.org/
+
+	  If you choose to build a module, it'll be called p54usb.
 
 config P54_PCI
 	tristate "Prism54 PCI support"
 	depends on P54_COMMON && PCI
+	---help---
+	  This driver is for PCI isl38xx based wireless cards.
+	  This driver supports most devices that are supported by the
+	  fullmac prism54 driver plus many devices which are not
+	  supported by the fullmac driver/firmware.
+
+	  This driver requires softmac firmware which can be found at
+	  http://prism54.org/
+
+	  If you choose to build a module, it'll be called p54pci.
 
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"



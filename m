Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60000 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969Ab3CTTwX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 15:52:23 -0400
From: John Crispin <blogic@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	John Crispin <blogic@openwrt.org>
Subject: [PATCH] rt2x00: make the driver build for Ralink SoC
Date: Wed, 20 Mar 2013 20:48:35 +0100
Message-Id: <1363808915-14278-1-git-send-email-blogic@openwrt.org> (sfid-20130320_205232_602567_A17FBAEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix up the dependencies to make the driver actually compile on Ralink WiSoC.

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 drivers/net/wireless/rt2x00/Kconfig     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 2bf4efa..dc7ee6c 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -57,7 +57,7 @@ config RT2800PCI
 	tristate "Ralink rt27xx/rt28xx/rt30xx (PCI/PCIe/PCMCIA) support"
 	depends on PCI || SOC_RT288X || SOC_RT305X
 	select RT2800_LIB
-	select RT2X00_LIB_PCI if PCI
+	select RT2X00_LIB_PCI
 	select RT2X00_LIB_SOC if SOC_RT288X || SOC_RT305X
 	select RT2X00_LIB_FIRMWARE
 	select RT2X00_LIB_CRYPTO
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index a0c8cae..fa20add 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -208,6 +208,7 @@ void rt2x00pci_uninitialize(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_uninitialize);
 
+#ifdef CONFIG_PCI
 /*
  * PCI driver handlers.
  */
@@ -392,6 +393,7 @@ int rt2x00pci_resume(struct pci_dev *pci_dev)
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_resume);
 #endif /* CONFIG_PM */
+#endif /* CONFIG_PCI */
 
 /*
  * rt2x00pci module information.
-- 
1.7.10.4


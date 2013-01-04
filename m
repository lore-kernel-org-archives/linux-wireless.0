Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1620 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab3ADJGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 04:06:00 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Hauke Mehrtens" <hauke@hauke-m.de>
Subject: [PATCH for 3.8] mips: bcm47xx: select GPIOLIB for BCMA on
 bcm47xx platform
Date: Fri, 4 Jan 2013 10:03:11 +0100
Message-ID: <1357290191-5728-1-git-send-email-arend@broadcom.com> (sfid-20130104_100609_123259_2930F139)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Kconfig items BCM47XX_BCMA and BCM47XX_SSB selected
respectively BCMA_DRIVER_GPIO and SSB_DRIVER_GPIO. These
options depend on GPIOLIB without explicitly selecting it
so it results in a warning when GPIOLIB is not set:

scripts/kconfig/conf --oldconfig Kconfig
warning: (BCM47XX_BCMA) selects BCMA_DRIVER_GPIO ... unmet direct
	dependencies (BCMA_POSSIBLE && BCMA && GPIOLIB)
warning: (BCM47XX_SSB) selects SSB_DRIVER_GPIO ... unmet direct
	dependencies (SSB_POSSIBLE && SSB && GPIOLIB)

which subsequently results in compile errors.

Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 arch/mips/bcm47xx/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/mips/bcm47xx/Kconfig b/arch/mips/bcm47xx/Kconfig
index d7af29f..ba61192 100644
--- a/arch/mips/bcm47xx/Kconfig
+++ b/arch/mips/bcm47xx/Kconfig
@@ -8,8 +8,10 @@ config BCM47XX_SSB
 	select SSB_DRIVER_EXTIF
 	select SSB_EMBEDDED
 	select SSB_B43_PCI_BRIDGE if PCI
+	select SSB_DRIVER_PCICORE if PCI
 	select SSB_PCICORE_HOSTMODE if PCI
 	select SSB_DRIVER_GPIO
+	select GPIOLIB
 	default y
 	help
 	 Add support for old Broadcom BCM47xx boards with Sonics Silicon Backplane support.
@@ -25,6 +27,7 @@ config BCM47XX_BCMA
 	select BCMA_HOST_PCI if PCI
 	select BCMA_DRIVER_PCI_HOSTMODE if PCI
 	select BCMA_DRIVER_GPIO
+	select GPIOLIB
 	default y
 	help
 	 Add support for new Broadcom BCM47xx boards with Broadcom specific Advanced Microcontroller Bus.
-- 
1.7.10.4



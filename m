Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751877AbdHCX7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 19:59:42 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: kvalo@codeaurora.org, gregkh@linuxfoundation.org
Cc: chunkeey@googlemail.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 1/2] wireless: move prism54 out to staging
Date: Thu,  3 Aug 2017 16:59:36 -0700
Message-Id: <20170803235937.8604-2-mcgrof@kernel.org> (sfid-20170804_020024_766938_27E9D2AC)
In-Reply-To: <20170803235937.8604-1-mcgrof@kernel.org>
References: <20170803235937.8604-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

prism54 is deprecated in favor of the p54pci device driver. Although
only *one soul* had reported issues with it long ago Linux most Linux
distributions these days just disable the device driver given the
conflicts with the PCI IDs of p54pci and the *very* unlikely situation
of folks really need this driver anymore.

Before trying to due away with prism54 once more stuff it into staging,
which is our hospice for dying drivers.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 MAINTAINERS                                          |  4 ++--
 drivers/net/wireless/intersil/Kconfig                | 20 --------------------
 drivers/net/wireless/intersil/Makefile               |  1 -
 drivers/staging/Kconfig                              |  2 ++
 drivers/staging/Makefile                             |  1 +
 .../wireless/intersil => staging}/prism54/Makefile   |  0
 .../wireless/intersil => staging}/prism54/isl_38xx.c |  0
 .../wireless/intersil => staging}/prism54/isl_38xx.h |  0
 .../intersil => staging}/prism54/isl_ioctl.c         |  0
 .../intersil => staging}/prism54/isl_ioctl.h         |  0
 .../wireless/intersil => staging}/prism54/isl_oid.h  |  0
 .../intersil => staging}/prism54/islpci_dev.c        |  0
 .../intersil => staging}/prism54/islpci_dev.h        |  0
 .../intersil => staging}/prism54/islpci_eth.c        |  0
 .../intersil => staging}/prism54/islpci_eth.h        |  0
 .../intersil => staging}/prism54/islpci_hotplug.c    |  0
 .../intersil => staging}/prism54/islpci_mgt.c        |  0
 .../intersil => staging}/prism54/islpci_mgt.h        |  0
 .../wireless/intersil => staging}/prism54/oid_mgt.c  |  0
 .../wireless/intersil => staging}/prism54/oid_mgt.h  |  0
 .../intersil => staging}/prism54/prismcompat.h       |  0
 21 files changed, 5 insertions(+), 23 deletions(-)
 rename drivers/{net/wireless/intersil => staging}/prism54/Makefile (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/isl_38xx.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/isl_38xx.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/isl_ioctl.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/isl_ioctl.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/isl_oid.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_dev.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_dev.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_eth.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_eth.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_hotplug.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_mgt.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_mgt.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/oid_mgt.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/oid_mgt.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/prismcompat.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index ef340b9aeb98..97cf436e6750 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10666,11 +10666,11 @@ F:	kernel/printk/
 F:	include/linux/printk.h
 
 PRISM54 WIRELESS DRIVER
-M:	"Luis R. Rodriguez" <mcgrof@gmail.com>
+M:	"Luis R. Rodriguez" <mcgrof@kernel.org>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/en/users/Drivers/p54
 S:	Obsolete
-F:	drivers/net/wireless/intersil/prism54/
+F:	drivers/staging/prism54/
 
 PROC SYSCTL
 M:	"Luis R. Rodriguez" <mcgrof@kernel.org>
diff --git a/drivers/net/wireless/intersil/Kconfig b/drivers/net/wireless/intersil/Kconfig
index 9da136049955..2b056b6daef8 100644
--- a/drivers/net/wireless/intersil/Kconfig
+++ b/drivers/net/wireless/intersil/Kconfig
@@ -15,24 +15,4 @@ source "drivers/net/wireless/intersil/hostap/Kconfig"
 source "drivers/net/wireless/intersil/orinoco/Kconfig"
 source "drivers/net/wireless/intersil/p54/Kconfig"
 
-config PRISM54
-	tristate 'Intersil Prism GT/Duette/Indigo PCI/Cardbus (DEPRECATED)'
-	depends on PCI
-	select WIRELESS_EXT
-	select WEXT_SPY
-	select WEXT_PRIV
-	select FW_LOADER
-	---help---
-	  This enables support for FullMAC PCI/Cardbus prism54 devices. This
-	  driver is now deprecated in favor for the SoftMAC driver, p54pci.
-	  p54pci supports FullMAC PCI/Cardbus devices as well.
-
-	  For more information refer to the p54 wiki:
-
-	  http://wireless.kernel.org/en/users/Drivers/p54
-
-	  Note: You need a motherboard with DMA support to use any of these cards
-
-	  When built as module you get the module prism54
-
 endif # WLAN_VENDOR_INTERSIL
diff --git a/drivers/net/wireless/intersil/Makefile b/drivers/net/wireless/intersil/Makefile
index 9a8cbfee3ea5..aedb713da746 100644
--- a/drivers/net/wireless/intersil/Makefile
+++ b/drivers/net/wireless/intersil/Makefile
@@ -1,4 +1,3 @@
 obj-$(CONFIG_HOSTAP)		+= hostap/
 obj-$(CONFIG_HERMES)		+= orinoco/
 obj-$(CONFIG_P54_COMMON)	+= p54/
-obj-$(CONFIG_PRISM54)		+= prism54/
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index e97d72e3bc40..ba13b07286c7 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -114,4 +114,6 @@ source "drivers/staging/vboxvideo/Kconfig"
 
 source "drivers/staging/pi433/Kconfig"
 
+source "drivers/staging/prism54/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 993ed0c1556c..d1be7b326e8c 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -46,3 +46,4 @@ obj-$(CONFIG_BCM2835_VCHIQ)	+= vc04_services/
 obj-$(CONFIG_CRYPTO_DEV_CCREE)	+= ccree/
 obj-$(CONFIG_DRM_VBOXVIDEO)	+= vboxvideo/
 obj-$(CONFIG_PI433)		+= pi433/
+obj-$(CONFIG_PRISM54)		+= prism54/
diff --git a/drivers/net/wireless/intersil/prism54/Makefile b/drivers/staging/prism54/Makefile
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/Makefile
rename to drivers/staging/prism54/Makefile
diff --git a/drivers/net/wireless/intersil/prism54/isl_38xx.c b/drivers/staging/prism54/isl_38xx.c
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/isl_38xx.c
rename to drivers/staging/prism54/isl_38xx.c
diff --git a/drivers/net/wireless/intersil/prism54/isl_38xx.h b/drivers/staging/prism54/isl_38xx.h
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/isl_38xx.h
rename to drivers/staging/prism54/isl_38xx.h
diff --git a/drivers/net/wireless/intersil/prism54/isl_ioctl.c b/drivers/staging/prism54/isl_ioctl.c
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/isl_ioctl.c
rename to drivers/staging/prism54/isl_ioctl.c
diff --git a/drivers/net/wireless/intersil/prism54/isl_ioctl.h b/drivers/staging/prism54/isl_ioctl.h
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/isl_ioctl.h
rename to drivers/staging/prism54/isl_ioctl.h
diff --git a/drivers/net/wireless/intersil/prism54/isl_oid.h b/drivers/staging/prism54/isl_oid.h
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/isl_oid.h
rename to drivers/staging/prism54/isl_oid.h
diff --git a/drivers/net/wireless/intersil/prism54/islpci_dev.c b/drivers/staging/prism54/islpci_dev.c
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/islpci_dev.c
rename to drivers/staging/prism54/islpci_dev.c
diff --git a/drivers/net/wireless/intersil/prism54/islpci_dev.h b/drivers/staging/prism54/islpci_dev.h
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/islpci_dev.h
rename to drivers/staging/prism54/islpci_dev.h
diff --git a/drivers/net/wireless/intersil/prism54/islpci_eth.c b/drivers/staging/prism54/islpci_eth.c
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/islpci_eth.c
rename to drivers/staging/prism54/islpci_eth.c
diff --git a/drivers/net/wireless/intersil/prism54/islpci_eth.h b/drivers/staging/prism54/islpci_eth.h
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/islpci_eth.h
rename to drivers/staging/prism54/islpci_eth.h
diff --git a/drivers/net/wireless/intersil/prism54/islpci_hotplug.c b/drivers/staging/prism54/islpci_hotplug.c
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/islpci_hotplug.c
rename to drivers/staging/prism54/islpci_hotplug.c
diff --git a/drivers/net/wireless/intersil/prism54/islpci_mgt.c b/drivers/staging/prism54/islpci_mgt.c
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/islpci_mgt.c
rename to drivers/staging/prism54/islpci_mgt.c
diff --git a/drivers/net/wireless/intersil/prism54/islpci_mgt.h b/drivers/staging/prism54/islpci_mgt.h
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/islpci_mgt.h
rename to drivers/staging/prism54/islpci_mgt.h
diff --git a/drivers/net/wireless/intersil/prism54/oid_mgt.c b/drivers/staging/prism54/oid_mgt.c
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/oid_mgt.c
rename to drivers/staging/prism54/oid_mgt.c
diff --git a/drivers/net/wireless/intersil/prism54/oid_mgt.h b/drivers/staging/prism54/oid_mgt.h
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/oid_mgt.h
rename to drivers/staging/prism54/oid_mgt.h
diff --git a/drivers/net/wireless/intersil/prism54/prismcompat.h b/drivers/staging/prism54/prismcompat.h
similarity index 100%
rename from drivers/net/wireless/intersil/prism54/prismcompat.h
rename to drivers/staging/prism54/prismcompat.h
-- 
2.11.0

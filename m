Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56974 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab0LQWnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 17:43:03 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: add support for RTL8192CE
Date: Fri, 17 Dec 2010 23:42:48 +0100
Message-Id: <1292625768-17318-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1292625768-17318-1-git-send-email-hauke@hauke-m.de>
References: <1292625768-17318-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                         |    3 +++
 patches/06-header-changes.patch   |   10 ++++++++++
 patches/20-pcidev.patch           |   11 +++++++++++
 patches/99-change-makefiles.patch |   10 +++++-----
 scripts/admin-update.sh           |    2 ++
 5 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/config.mk b/config.mk
index 3261aa3..964c646 100644
--- a/config.mk
+++ b/config.mk
@@ -353,6 +353,9 @@ CONFIG_PCMCIA_SPECTRUM=m
 endif #CONFIG_PCMCIA
 endif #CONFIG_WIRELESS_EXT
 
+CONFIG_RTL8192CE=m
+CONFIG_RTLWIFI=m
+
 endif #CONFIG_PCI
 ## end of PCI
 
diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index 69b1934..0b90d4c 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -16,6 +16,16 @@ cases.
  
  struct b43_wldev;
  
+--- a/drivers/net/wireless/rtlwifi/base.c
++++ b/drivers/net/wireless/rtlwifi/base.c
+@@ -28,6 +28,7 @@
+  *****************************************************************************/
+ 
+ #include <linux/ip.h>
++#include <linux/in.h>
+ #include "wifi.h"
+ #include "rc.h"
+ #include "base.h"
 --- a/drivers/net/wireless/wl1251/boot.c
 +++ b/drivers/net/wireless/wl1251/boot.c
 @@ -19,7 +19,6 @@
diff --git a/patches/20-pcidev.patch b/patches/20-pcidev.patch
index 19feea6..d576ce8 100644
--- a/patches/20-pcidev.patch
+++ b/patches/20-pcidev.patch
@@ -55,6 +55,17 @@ compat_is_pcie() when needed.
  		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
  	else
  		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
+--- a/drivers/net/wireless/rtlwifi/pci.c
++++ b/drivers/net/wireless/rtlwifi/pci.c
+@@ -1608,7 +1608,7 @@ static bool _rtl_pci_find_adapter(struct
+ 		pcipriv->ndis_adapter.pcibridge_funcnum =
+ 		    PCI_FUNC(bridge_pdev->devfn);
+ 		pcipriv->ndis_adapter.pcibridge_pciehdr_offset =
+-		    bridge_pdev->pcie_cap;
++		    pci_pcie_cap(bridge_pdev);
+ 		pcipriv->ndis_adapter.pcicfg_addrport =
+ 		    (pcipriv->ndis_adapter.pcibridge_busnum << 16) |
+ 		    (pcipriv->ndis_adapter.pcibridge_devnum << 11) |
 --- a/drivers/ssb/scan.c
 +++ b/drivers/ssb/scan.c
 @@ -405,10 +405,10 @@ int ssb_bus_scan(struct ssb_bus *bus,
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index 42c7ea3..585ff03 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -45,7 +45,7 @@ only the wireless stuff.
  
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
-@@ -7,32 +7,16 @@ obj-$(CONFIG_IPW2200) += ipw2x00/
+@@ -7,18 +7,8 @@ obj-$(CONFIG_IPW2200) += ipw2x00/
  
  obj-$(CONFIG_HERMES)		+= orinoco/
  
@@ -64,14 +64,14 @@ only the wireless stuff.
  obj-$(CONFIG_B43)		+= b43/
  obj-$(CONFIG_B43LEGACY)		+= b43legacy/
  obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
- obj-$(CONFIG_RTL8180)		+= rtl818x/
+@@ -26,13 +16,8 @@ obj-$(CONFIG_RTL8180)		+= rtl818x/
  obj-$(CONFIG_RTL8187)		+= rtl818x/
--obj-$(CONFIG_RTL8192CE)		+= rtlwifi/
--
+ obj-$(CONFIG_RTL8192CE)		+= rtlwifi/
+ 
 -# 16-bit wireless PCMCIA client drivers
 -obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
 -obj-$(CONFIG_PCMCIA_WL3501)	+= wl3501_cs.o
- 
+-
  obj-$(CONFIG_USB_NET_COMPAT_RNDIS_WLAN)	+= rndis_wlan.o
  
 -obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 6fd1bc0..b93761e 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -229,6 +229,8 @@ DRIVERS="$DRIVERS drivers/net/wireless/zd1211rw"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas"
 DRIVERS="$DRIVERS drivers/net/wireless/p54"
 DRIVERS="$DRIVERS drivers/net/wireless/rtl818x"
+DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi"
+DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192ce"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS="$DRIVERS drivers/net/wireless/ipw2x00"
 DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
-- 
1.7.1


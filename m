Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63308 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3GAUza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 16:55:30 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/3] backports: remove alx extra patch
Date: Mon,  1 Jul 2013 13:55:18 -0700
Message-Id: <1372712120-16606-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20130701_225533_218922_C1BEC3FC)
In-Reply-To: <1372712120-16606-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372712120-16606-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

The alx driver was upstreamed by Johannes, so this is
no longer required. Note that this driver is now GPLv2
or later, BSD folks will have to look at the old unified
tree for a permissive licensed port.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 .../network/0001-netdev_ops/mwifiex.patch          |    2 +-
 ...drivers_net_wireless_rtlwifi_rtl8192cu_sw.patch |    2 +-
 .../network/0002-alx-make-kconfig/alx.patch        |   32 --------------------
 3 files changed, 2 insertions(+), 34 deletions(-)
 delete mode 100644 patches/unified-drivers/network/0002-alx-make-kconfig/alx.patch

diff --git a/patches/collateral-evolutions/network/0001-netdev_ops/mwifiex.patch b/patches/collateral-evolutions/network/0001-netdev_ops/mwifiex.patch
index 0567191..58a38ab 100644
--- a/patches/collateral-evolutions/network/0001-netdev_ops/mwifiex.patch
+++ b/patches/collateral-evolutions/network/0001-netdev_ops/mwifiex.patch
@@ -1,6 +1,6 @@
 --- a/drivers/net/wireless/mwifiex/main.c
 +++ b/drivers/net/wireless/mwifiex/main.c
-@@ -750,7 +750,7 @@ static const struct net_device_ops mwifi
+@@ -749,7 +749,7 @@ static const struct net_device_ops mwifi
  void mwifiex_init_priv_params(struct mwifiex_private *priv,
  						struct net_device *dev)
  {
diff --git a/patches/collateral-evolutions/network/62-usb_driver_lpm/drivers_net_wireless_rtlwifi_rtl8192cu_sw.patch b/patches/collateral-evolutions/network/62-usb_driver_lpm/drivers_net_wireless_rtlwifi_rtl8192cu_sw.patch
index 28b2173..23181a0 100644
--- a/patches/collateral-evolutions/network/62-usb_driver_lpm/drivers_net_wireless_rtlwifi_rtl8192cu_sw.patch
+++ b/patches/collateral-evolutions/network/62-usb_driver_lpm/drivers_net_wireless_rtlwifi_rtl8192cu_sw.patch
@@ -1,6 +1,6 @@
 --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
 +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
-@@ -385,7 +385,9 @@ static struct usb_driver rtl8192cu_drive
+@@ -386,7 +386,9 @@ static struct usb_driver rtl8192cu_drive
  #ifdef CONFIG_AUTOSUSPEND
  	.supports_autosuspend = 1,
  #endif
diff --git a/patches/unified-drivers/network/0002-alx-make-kconfig/alx.patch b/patches/unified-drivers/network/0002-alx-make-kconfig/alx.patch
deleted file mode 100644
index 465e499..0000000
--- a/patches/unified-drivers/network/0002-alx-make-kconfig/alx.patch
+++ /dev/null
@@ -1,32 +0,0 @@
---- a/drivers/net/ethernet/atheros/Kconfig
-+++ b/drivers/net/ethernet/atheros/Kconfig
-@@ -67,4 +67,22 @@ config ATL1C
- 	  To compile this driver as a module, choose M here.  The module
- 	  will be called atl1c.
- 
-+config ALX
-+	tristate "Qualcomm Atheros L1F Gigabit Ethernet support"
-+	depends on PCI
-+	select CRC32
-+	select NET_CORE
-+	select MII
-+	---help---
-+	  This driver supports the Qualcomm Atheros L1F ethernet adapter.
-+	  This driver supports following chipsets:
-+
-+	  1969:1091 - AR8161 Gigabit Ethernet
-+	  1969:1090 - AR8162 Fast Ethernet
-+	  1969:10A1 - AR8171 Gigabit Ethernet
-+	  1969:10A0 - AR8172 Fast Ethernet
-+
-+	  To compile this driver as a module, choose M here.  The module
-+	  will be called alx.
-+
- endif # NET_VENDOR_ATHEROS
---- a/drivers/net/ethernet/atheros/Makefile
-+++ b/drivers/net/ethernet/atheros/Makefile
-@@ -6,3 +6,4 @@ obj-$(CONFIG_ATL1) += atlx/
- obj-$(CONFIG_ATL2) += atlx/
- obj-$(CONFIG_ATL1E) += atl1e/
- obj-$(CONFIG_ATL1C) += atl1c/
-+obj-$(CONFIG_ALX) += alx/
-- 
1.7.10.4


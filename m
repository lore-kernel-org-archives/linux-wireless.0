Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46159 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2I0Gvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 02:51:31 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20579.63268.74777.81720@gargle.gargle.HOWL> (sfid-20120927_085136_815976_5C095494)
Date: Thu, 27 Sep 2012 12:20:12 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 1/5] compat-drivers: Refresh patches for next-20120926
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 patches/0001-netdev_ops.patch    |  2 +-
 patches/04-netns.patch           |  2 +-
 patches/11-dev-pm-ops.patch      | 12 ++++++------
 patches/14-device-type.patch     |  2 +-
 patches/29-sdio_no_suspend.patch |  2 +-
 patches/62-usb_driver_lpm.patch  | 10 +++++-----
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/patches/0001-netdev_ops.patch b/patches/0001-netdev_ops.patch
index 3dc15ca..8c1dda5 100644
--- a/patches/0001-netdev_ops.patch
+++ b/patches/0001-netdev_ops.patch
@@ -49,7 +49,7 @@ Date:   Wed Nov 19 21:32:24 2008 -0800
  	if (unlikely(retval < 0)) {
 --- a/drivers/net/usb/usbnet.c
 +++ b/drivers/net/usb/usbnet.c
-@@ -1409,7 +1409,7 @@ usbnet_probe (struct usb_interface *udev
+@@ -1417,7 +1417,7 @@ usbnet_probe (struct usb_interface *udev
  		net->features |= NETIF_F_HIGHDMA;
  #endif
  
diff --git a/patches/04-netns.patch b/patches/04-netns.patch
index 98c8468..0085052 100644
--- a/patches/04-netns.patch
+++ b/patches/04-netns.patch
@@ -6,7 +6,7 @@ files...
 
 --- a/net/wireless/nl80211.c
 +++ b/net/wireless/nl80211.c
-@@ -5689,7 +5689,9 @@ static int nl80211_wiphy_netns(struct sk
+@@ -5691,7 +5691,9 @@ static int nl80211_wiphy_netns(struct sk
  	if (!net_eq(wiphy_net(&rdev->wiphy), net))
  		err = cfg80211_switch_netns(rdev, net);
  
diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 18dbba9..fc63aa0 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -19,7 +19,7 @@ calls on compat code with only slight modifications.
  static SIMPLE_DEV_PM_OPS(bcma_pm_ops, bcma_host_pci_suspend,
  			 bcma_host_pci_resume);
  #define BCMA_PM_OPS	(&bcma_pm_ops)
-@@ -283,7 +287,12 @@ static struct pci_driver bcma_pci_bridge
+@@ -283,7 +286,12 @@ static struct pci_driver bcma_pci_bridge
  	.id_table = bcma_pci_bridge_tbl,
  	.probe = bcma_host_pci_probe,
  	.remove = __devexit_p(bcma_host_pci_remove),
@@ -34,8 +34,7 @@ calls on compat code with only slight modifications.
  int __init bcma_host_pci_init(void)
 --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
 +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
-@@ -2691,6 +2691,9 @@ static struct pci_error_handlers atl1c_e
- 	.resume = atl1c_io_resume,
+@@ -2692,6 +2692,9 @@ static struct pci_error_handlers atl1c_e
  };
  
  static SIMPLE_DEV_PM_OPS(atl1c_pm_ops, atl1c_suspend, atl1c_resume);
@@ -44,6 +43,7 @@ calls on compat code with only slight modifications.
 +
  
  static struct pci_driver atl1c_driver = {
+ 	.name     = atl1c_driver_name,
 @@ -2700,7 +2703,12 @@ static struct pci_driver atl1c_driver =
  	.remove   = __devexit_p(atl1c_remove),
  	.shutdown = atl1c_shutdown,
@@ -271,7 +271,7 @@ calls on compat code with only slight modifications.
  
 --- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
 +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
-@@ -372,21 +372,22 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use
+@@ -374,21 +374,22 @@ MODULE_PARM_DESC(swlps, "Set to 1 to use
  MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
  MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
  
@@ -370,7 +370,7 @@ calls on compat code with only slight modifications.
  module_pci_driver(rtl92se_driver);
 --- a/drivers/net/wireless/p54/p54pci.c
 +++ b/drivers/net/wireless/p54/p54pci.c
-@@ -681,14 +681,10 @@ static int p54p_resume(struct device *de
+@@ -645,14 +645,10 @@ static int p54p_resume(struct device *de
  	return pci_set_power_state(pdev, PCI_D0);
  }
  
@@ -389,7 +389,7 @@ calls on compat code with only slight modifications.
  
  #define P54P_PM_OPS (&p54pci_pm_ops)
  #else
-@@ -700,7 +696,12 @@ static struct pci_driver p54p_driver = {
+@@ -664,7 +660,12 @@ static struct pci_driver p54p_driver = {
  	.id_table	= p54p_table,
  	.probe		= p54p_probe,
  	.remove		= __devexit_p(p54p_remove),
diff --git a/patches/14-device-type.patch b/patches/14-device-type.patch
index 9c4b2b6..4518bb4 100644
--- a/patches/14-device-type.patch
+++ b/patches/14-device-type.patch
@@ -36,7 +36,7 @@ compile warning.
  {
 --- a/drivers/net/usb/usbnet.c
 +++ b/drivers/net/usb/usbnet.c
-@@ -1326,13 +1326,17 @@ static const struct net_device_ops usbne
+@@ -1334,13 +1334,17 @@ static const struct net_device_ops usbne
  
  // precondition: never called in_interrupt
  
diff --git a/patches/29-sdio_no_suspend.patch b/patches/29-sdio_no_suspend.patch
index 6efe7f5..1adb65c 100644
--- a/patches/29-sdio_no_suspend.patch
+++ b/patches/29-sdio_no_suspend.patch
@@ -60,7 +60,7 @@ suspend and resume that are not backported.
  static int if_sdio_suspend(struct device *dev)
  {
  	struct sdio_func *func = dev_to_sdio_func(dev);
-@@ -1373,15 +1374,18 @@ static const struct dev_pm_ops if_sdio_p
+@@ -1378,15 +1379,18 @@ static const struct dev_pm_ops if_sdio_p
  	.suspend	= if_sdio_suspend,
  	.resume		= if_sdio_resume,
  };
diff --git a/patches/62-usb_driver_lpm.patch b/patches/62-usb_driver_lpm.patch
index fb888eb..6d94773 100644
--- a/patches/62-usb_driver_lpm.patch
+++ b/patches/62-usb_driver_lpm.patch
@@ -1,6 +1,6 @@
 --- a/drivers/bluetooth/ath3k.c
 +++ b/drivers/bluetooth/ath3k.c
-@@ -450,7 +450,9 @@ static struct usb_driver ath3k_driver =
+@@ -452,7 +452,9 @@ static struct usb_driver ath3k_driver =
  	.probe		= ath3k_probe,
  	.disconnect	= ath3k_disconnect,
  	.id_table	= ath3k_table,
@@ -48,7 +48,7 @@
  module_usb_driver(bpa10x_driver);
 --- a/drivers/bluetooth/btusb.c
 +++ b/drivers/bluetooth/btusb.c
-@@ -1226,7 +1226,9 @@ static struct usb_driver btusb_driver =
+@@ -1228,7 +1228,9 @@ static struct usb_driver btusb_driver =
  #endif
  	.id_table	= btusb_table,
  	.supports_autosuspend = 1,
@@ -204,7 +204,7 @@
  module_usb_driver(rndis_wlan_driver);
 --- a/drivers/net/wireless/rt2x00/rt2500usb.c
 +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
-@@ -1980,7 +1980,9 @@ static struct usb_driver rt2500usb_drive
+@@ -1989,7 +1989,9 @@ static struct usb_driver rt2500usb_drive
  	.disconnect	= rt2x00usb_disconnect,
  	.suspend	= rt2x00usb_suspend,
  	.resume		= rt2x00usb_resume,
@@ -216,7 +216,7 @@
  module_usb_driver(rt2500usb_driver);
 --- a/drivers/net/wireless/rt2x00/rt2800usb.c
 +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
-@@ -1304,7 +1304,9 @@ static struct usb_driver rt2800usb_drive
+@@ -1322,7 +1322,9 @@ static struct usb_driver rt2800usb_drive
  	.disconnect	= rt2x00usb_disconnect,
  	.suspend	= rt2x00usb_suspend,
  	.resume		= rt2x00usb_resume,
@@ -228,7 +228,7 @@
  module_usb_driver(rt2800usb_driver);
 --- a/drivers/net/wireless/rt2x00/rt73usb.c
 +++ b/drivers/net/wireless/rt2x00/rt73usb.c
-@@ -2527,7 +2527,9 @@ static struct usb_driver rt73usb_driver
+@@ -2536,7 +2536,9 @@ static struct usb_driver rt73usb_driver
  	.disconnect	= rt2x00usb_disconnect,
  	.suspend	= rt2x00usb_suspend,
  	.resume		= rt2x00usb_resume,
-- 
1.7.12.1


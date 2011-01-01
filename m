Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39368 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab1AAO0h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jan 2011 09:26:37 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] compat-wireless: remove patches applied mainline
Date: Sat,  1 Jan 2011 15:26:19 +0100
Message-Id: <1293891981-22151-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1293891981-22151-1-git-send-email-hauke@hauke-m.de>
References: <1293891981-22151-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The removed parts are now in mainline and do not have to be backported
any more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/06-header-changes.patch |   20 ---------
 patches/20-pcidev.patch         |   83 ---------------------------------------
 2 files changed, 0 insertions(+), 103 deletions(-)
 delete mode 100644 patches/20-pcidev.patch

diff --git a/patches/06-header-changes.patch b/patches/06-header-changes.patch
index 0b90d4c..6e4ae56 100644
--- a/patches/06-header-changes.patch
+++ b/patches/06-header-changes.patch
@@ -26,16 +26,6 @@ cases.
  #include "wifi.h"
  #include "rc.h"
  #include "base.h"
---- a/drivers/net/wireless/wl1251/boot.c
-+++ b/drivers/net/wireless/wl1251/boot.c
-@@ -19,7 +19,6 @@
-  *
-  */
- 
--#include <linux/gpio.h>
- #include <linux/slab.h>
- 
- #include "reg.h"
 --- a/drivers/net/wireless/wl1251/main.c
 +++ b/drivers/net/wireless/wl1251/main.c
 @@ -24,6 +24,9 @@
@@ -60,16 +50,6 @@ cases.
  #include <linux/spi/spi.h>
  #include <linux/wl12xx.h>
  
---- a/drivers/net/wireless/wl12xx/boot.c
-+++ b/drivers/net/wireless/wl12xx/boot.c
-@@ -21,7 +21,6 @@
-  *
-  */
- 
--#include <linux/gpio.h>
- #include <linux/slab.h>
- 
- #include "acx.h"
 --- a/net/mac80211/key.c
 +++ b/net/mac80211/key.c
 @@ -22,6 +22,9 @@
diff --git a/patches/20-pcidev.patch b/patches/20-pcidev.patch
deleted file mode 100644
index d576ce8..0000000
--- a/patches/20-pcidev.patch
+++ /dev/null
@@ -1,83 +0,0 @@
-Older kernels than 2.6.24 do not have the is_pcie member as part of
-the struct pci_dev, to help with that we use the compat-2.6.24.c supplied
-compat_is_pcie() when needed.
-
---- a/drivers/net/wireless/ath/ath5k/attach.c
-+++ b/drivers/net/wireless/ath/ath5k/attach.c
-@@ -276,7 +276,7 @@ int ath5k_hw_init(struct ath5k_softc *sc
- 	/*
- 	 * Write PCI-E power save settings
- 	 */
--	if ((ah->ah_version == AR5K_AR5212) && pdev && (pdev->is_pcie)) {
-+	if ((ah->ah_version == AR5K_AR5212) && pdev && (pci_is_pcie(pdev))) {
- 		ath5k_hw_reg_write(ah, 0x9248fc00, AR5K_PCIE_SERDES);
- 		ath5k_hw_reg_write(ah, 0x24924924, AR5K_PCIE_SERDES);
- 
---- a/drivers/net/wireless/ath/ath5k/reset.c
-+++ b/drivers/net/wireless/ath/ath5k/reset.c
-@@ -537,7 +537,7 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah
- 	 * we ingore that flag for PCI-E cards. On PCI cards
- 	 * this flag gets cleared after 64 PCI clocks.
- 	 */
--	bus_flags = (pdev && pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
-+	bus_flags = (pdev && pci_is_pcie(pdev)) ? 0 : AR5K_RESET_CTL_PCI;
- 
- 	if (ah->ah_version == AR5K_AR5210) {
- 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
-@@ -594,7 +594,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw
- 	 * we ingore that flag for PCI-E cards. On PCI cards
- 	 * this flag gets cleared after 64 PCI clocks.
- 	 */
--	bus_flags = (pdev && pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
-+	bus_flags = (pdev && pci_is_pcie(pdev)) ? 0 : AR5K_RESET_CTL_PCI;
- 
- 	if (ah->ah_version == AR5K_AR5210) {
- 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
---- a/drivers/net/wireless/ath/ath9k/pci.c
-+++ b/drivers/net/wireless/ath/ath9k/pci.c
-@@ -96,7 +96,7 @@ static void ath_pci_bt_coex_prep(struct
- 	struct pci_dev *pdev = to_pci_dev(sc->dev);
- 	u8 aspm;
- 
--	if (!pdev->is_pcie)
-+	if (!pci_is_pcie(pdev))
- 		return;
- 
- 	pci_read_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, &aspm);
---- a/drivers/net/wireless/rt2x00/rt2x00pci.c
-+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
-@@ -301,7 +301,7 @@ int rt2x00pci_probe(struct pci_dev *pci_
- 	rt2x00dev->irq = pci_dev->irq;
- 	rt2x00dev->name = pci_name(pci_dev);
- 
--	if (pci_dev->is_pcie)
-+	if (pci_is_pcie(pci_dev))
- 		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
- 	else
- 		rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
---- a/drivers/net/wireless/rtlwifi/pci.c
-+++ b/drivers/net/wireless/rtlwifi/pci.c
-@@ -1608,7 +1608,7 @@ static bool _rtl_pci_find_adapter(struct
- 		pcipriv->ndis_adapter.pcibridge_funcnum =
- 		    PCI_FUNC(bridge_pdev->devfn);
- 		pcipriv->ndis_adapter.pcibridge_pciehdr_offset =
--		    bridge_pdev->pcie_cap;
-+		    pci_pcie_cap(bridge_pdev);
- 		pcipriv->ndis_adapter.pcicfg_addrport =
- 		    (pcipriv->ndis_adapter.pcibridge_busnum << 16) |
- 		    (pcipriv->ndis_adapter.pcibridge_devnum << 11) |
---- a/drivers/ssb/scan.c
-+++ b/drivers/ssb/scan.c
-@@ -405,10 +405,10 @@ int ssb_bus_scan(struct ssb_bus *bus,
- 				/* Ignore PCI cores on PCI-E cards.
- 				 * Ignore PCI-E cores on PCI cards. */
- 				if (dev->id.coreid == SSB_DEV_PCI) {
--					if (bus->host_pci->is_pcie)
-+					if (pci_is_pcie(bus->host_pci))
- 						continue;
- 				} else {
--					if (!bus->host_pci->is_pcie)
-+					if (!pci_is_pcie(bus->host_pci))
- 						continue;
- 				}
- 			}
-- 
1.7.1


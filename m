Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1516 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab1LHXHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:12 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/23] brcm80211: smac: change attach interfaces in
 main.c for bcma support
Date: Thu, 8 Dec 2011 15:06:47 -0800
Message-ID: <1323385619-7454-12-git-send-email-frankyl@broadcom.com> (sfid-20111209_000723_871220_28034F51)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The driver is probed through bcma which provides a device representing
the core. This device is now passed in brcms_c_attach and brcms_b_attach
functions.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    4 +--
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   31 +++++++++----------
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    6 ++--
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 9e07dc4..30ac8b4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1030,9 +1030,7 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 	}
 
 	/* common load-time initialization */
-	wl->wlc = brcms_c_attach((void *)wl, pdev->bus->host_pci->vendor,
-				 pdev->bus->host_pci->device, unit, false,
-				 pdev->bus->mmio, pdev->bus->host_pci, &err);
+	wl->wlc = brcms_c_attach((void *)wl, pdev, unit, false, &err);
 	brcms_release_fw(wl);
 	if (!wl->wlc) {
 		wiphy_err(wl->wiphy, "%s: attach() failed with code %d\n",
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index ed8fcb4..d329c90 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4437,9 +4437,8 @@ struct brcms_pub *brcms_c_pub(struct brcms_c_info *wlc)
  *    initialize software state for each core and band
  *    put the whole chip in reset(driver down state), no clock
  */
-static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
-			  uint unit, bool piomode, void __iomem *regsva,
-			  struct pci_dev *btparam)
+static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
+			  uint unit, bool piomode)
 {
 	struct brcms_hardware *wlc_hw;
 	struct d11regs __iomem *regs;
@@ -4449,9 +4448,11 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	bool wme = false;
 	struct shared_phy_params sha_params;
 	struct wiphy *wiphy = wlc->wiphy;
+	struct pci_dev *pcidev = core->bus->host_pci;
 
-	BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit, vendor,
-		device);
+	BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit,
+	       pcidev->vendor,
+	       pcidev->device);
 
 	wme = true;
 
@@ -4468,7 +4469,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	 * Do the hardware portion of the attach. Also initialize software
 	 * state that depends on the particular hardware we are running.
 	 */
-	wlc_hw->sih = ai_attach(regsva, btparam);
+	wlc_hw->sih = ai_attach(core->bus->mmio, core->bus->host_pci);
 	if (wlc_hw->sih == NULL) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: si_attach failed\n",
 			  unit);
@@ -4477,16 +4478,16 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	}
 
 	/* verify again the device is supported */
-	if (!brcms_c_chipmatch(vendor, device)) {
+	if (!brcms_c_chipmatch(pcidev->vendor, pcidev->device)) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported "
 			"vendor/device (0x%x/0x%x)\n",
-			 unit, vendor, device);
+			 unit, pcidev->vendor, pcidev->device);
 		err = 12;
 		goto fail;
 	}
 
-	wlc_hw->vendorid = vendor;
-	wlc_hw->deviceid = device;
+	wlc_hw->vendorid = pcidev->vendor;
+	wlc_hw->deviceid = pcidev->device;
 
 	/* set bar0 window to point at D11 core */
 	wlc_hw->regs = (struct d11regs __iomem *)
@@ -8351,9 +8352,8 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
  * The common driver entry routine. Error codes should be unique
  */
 struct brcms_c_info *
-brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
-	       bool piomode, void __iomem *regsva, struct pci_dev *btparam,
-	       uint *perr)
+brcms_c_attach(struct brcms_info *wl, struct bcma_device *core, uint unit,
+	       bool piomode, uint *perr)
 {
 	struct brcms_c_info *wlc;
 	uint err = 0;
@@ -8361,7 +8361,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	struct brcms_pub *pub;
 
 	/* allocate struct brcms_c_info state and its substructures */
-	wlc = (struct brcms_c_info *) brcms_c_attach_malloc(unit, &err, device);
+	wlc = (struct brcms_c_info *) brcms_c_attach_malloc(unit, &err, 0);
 	if (wlc == NULL)
 		goto fail;
 	wlc->wiphy = wl->wiphy;
@@ -8388,8 +8388,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	 * low level attach steps(all hw accesses go
 	 * inside, no more in rest of the attach)
 	 */
-	err = brcms_b_attach(wlc, vendor, device, unit, piomode, regsva,
-			     btparam);
+	err = brcms_b_attach(wlc, core, unit, piomode);
 	if (err)
 		goto fail;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 21ccf3a..f0038ad 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -17,6 +17,7 @@
 #ifndef _BRCM_PUB_H_
 #define _BRCM_PUB_H_
 
+#include <linux/bcma/bcma.h>
 #include <brcmu_wifi.h>
 #include "types.h"
 #include "defs.h"
@@ -530,9 +531,8 @@ struct brcms_antselcfg {
 
 /* common functions for every port */
 extern struct brcms_c_info *
-brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
-	       bool piomode, void __iomem *regsva, struct pci_dev *btparam,
-	       uint *perr);
+brcms_c_attach(struct brcms_info *wl, struct bcma_device *core, uint unit,
+	       bool piomode, uint *perr);
 extern uint brcms_c_detach(struct brcms_c_info *wlc);
 extern int brcms_c_up(struct brcms_c_info *wlc);
 extern uint brcms_c_down(struct brcms_c_info *wlc);
-- 
1.7.5.4



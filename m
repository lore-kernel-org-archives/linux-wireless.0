Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45023 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab2D2AwC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:52:02 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 18/19] brcmsmac: read PCI vendor and device id only for PCI devices
Date: Sun, 29 Apr 2012 02:50:42 +0200
Message-Id: <1335660643-26368-19-git-send-email-hauke@hauke-m.de> (sfid-20120429_025207_958340_02154B21)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If brcmsmac is used on non PCI(s) devices it should not try to access
bus->host_pci.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 880fb55..8792bfc 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4434,9 +4434,14 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	struct pci_dev *pcidev = core->bus->host_pci;
 	struct ssb_sprom *sprom = &core->bus->sprom;
 
-	BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit,
-	       pcidev->vendor,
-	       pcidev->device);
+	if (core->bus->hosttype == BCMA_HOSTTYPE_PCI)
+		BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit,
+		       pcidev->vendor,
+		       pcidev->device);
+	else
+		BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit,
+		       core->bus->boardinfo.vendor,
+		       core->bus->boardinfo.type);
 
 	wme = true;
 
@@ -4462,7 +4467,8 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	}
 
 	/* verify again the device is supported */
-	if (!brcms_c_chipmatch(pcidev->vendor, pcidev->device)) {
+	if (core->bus->hosttype == BCMA_HOSTTYPE_PCI &&
+	    !brcms_c_chipmatch(pcidev->vendor, pcidev->device)) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported "
 			"vendor/device (0x%x/0x%x)\n",
 			 unit, pcidev->vendor, pcidev->device);
@@ -4470,8 +4476,13 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 		goto fail;
 	}
 
-	wlc_hw->vendorid = pcidev->vendor;
-	wlc_hw->deviceid = pcidev->device;
+	if (core->bus->hosttype == BCMA_HOSTTYPE_PCI) {
+		wlc_hw->vendorid = pcidev->vendor;
+		wlc_hw->deviceid = pcidev->device;
+	} else {
+		wlc_hw->vendorid = core->bus->boardinfo.vendor;
+		wlc_hw->deviceid = core->bus->boardinfo.type;
+	}
 
 	wlc_hw->d11core = core;
 	wlc_hw->corerev = core->id.rev;
-- 
1.7.9.5


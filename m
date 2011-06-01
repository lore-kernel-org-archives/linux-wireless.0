Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3785 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758820Ab1FALq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 21/83] staging: brcm80211: added support for more
 bcm43224 based boards
Date: Wed, 1 Jun 2011 13:45:06 +0200
Message-ID: <1306928768-7501-21-git-send-email-rvossen@broadcom.com> (sfid-20110601_134930_664193_2E70198D)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch created by Gottfried Haider. Add support for BCM943224HMB devices
as found in recent Lenovo ThinkPads.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |    5 ++++-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c    |    3 ++-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c    |    3 ++-
 drivers/staging/brcm80211/include/bcmdevs.h      |    1 +
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 105f426..590d65b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -95,6 +95,8 @@ static struct pci_device_id wl_id_table[] = {
 	{PCI_VENDOR_ID_BROADCOM, 0x4357, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* 43225 2G */
 	{PCI_VENDOR_ID_BROADCOM, 0x4353, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* 43224 DUAL */
 	{PCI_VENDOR_ID_BROADCOM, 0x4727, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},	/* 4313 DUAL */
+	/* 43224 Ven */
+	{PCI_VENDOR_ID_BROADCOM, 0x0576, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{0}
 };
 
@@ -1112,7 +1114,8 @@ wl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	       PCI_FUNC(pdev->devfn), pdev->irq);
 
 	if ((pdev->vendor != PCI_VENDOR_ID_BROADCOM) ||
-	    (((pdev->device & 0xff00) != 0x4300) &&
+	    ((pdev->device != 0x0576) &&
+	     ((pdev->device & 0xff00) != 0x4300) &&
 	     ((pdev->device & 0xff00) != 0x4700) &&
 	     ((pdev->device < 43000) || (pdev->device > 43999))))
 		return -ENODEV;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index adc06fc..f98f0fd 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -741,7 +741,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		wlc->war16165 = true;
 
 	/* check device id(srom, nvram etc.) to set bands */
-	if (wlc_hw->deviceid == BCM43224_D11N_ID) {
+	if (wlc_hw->deviceid == BCM43224_D11N_ID ||
+	    wlc_hw->deviceid == BCM43224_D11N_ID_VEN1) {
 		/* Dualband boards */
 		wlc_hw->_nbands = 2;
 	} else
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 0837e8d..54b5b79 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -2857,9 +2857,10 @@ bool wlc_chipmatch(u16 vendor, u16 device)
 		return false;
 	}
 
+	if (device == BCM43224_D11N_ID_VEN1)
+		return true;
 	if ((device == BCM43224_D11N_ID) || (device == BCM43225_D11N2G_ID))
 		return true;
-
 	if (device == BCM4313_D11N2G_ID)
 		return true;
 	if ((device == BCM43236_D11N_ID) || (device == BCM43236_D11N2G_ID))
diff --git a/drivers/staging/brcm80211/include/bcmdevs.h b/drivers/staging/brcm80211/include/bcmdevs.h
index 26947ef..eba10b6 100644
--- a/drivers/staging/brcm80211/include/bcmdevs.h
+++ b/drivers/staging/brcm80211/include/bcmdevs.h
@@ -30,6 +30,7 @@
 #define BCM4319_D11N5G_ID	0x4339	/* 4319 802.11n 5G device */
 
 #define BCM43224_D11N_ID	0x4353	/* 43224 802.11n dualband device */
+#define BCM43224_D11N_ID_VEN1	0x0576	/* Vendor specific 43224 802.11n db */
 
 #define BCM43225_D11N2G_ID	0x4357	/* 43225 802.11n 2.4GHz device */
 
-- 
1.7.4.1



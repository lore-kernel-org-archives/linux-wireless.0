Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45011 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab2D2Av6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:58 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 17/19] brcmsmac: do not access host_pci
Date: Sun, 29 Apr 2012 02:50:41 +0200
Message-Id: <1335660643-26368-18-git-send-email-hauke@hauke-m.de> (sfid-20120429_025207_407206_8BD1F8FE)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The irq number is copied from the PCIe host device to the bcma cores so
just request it using the bcma core device.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index b8350ff..50f92a0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -769,7 +769,7 @@ void brcms_dpc(unsigned long data)
  * Precondition: Since this function is called in brcms_pci_probe() context,
  * no locking is required.
  */
-static int brcms_request_fw(struct brcms_info *wl, struct pci_dev *pdev)
+static int brcms_request_fw(struct brcms_info *wl, struct bcma_device *pdev)
 {
 	int status;
 	struct device *device = &pdev->dev;
@@ -1021,7 +1021,7 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 	spin_lock_init(&wl->isr_lock);
 
 	/* prepare ucode */
-	if (brcms_request_fw(wl, pdev->bus->host_pci) < 0) {
+	if (brcms_request_fw(wl, pdev) < 0) {
 		wiphy_err(wl->wiphy, "%s: Failed to find firmware usually in "
 			  "%s\n", KBUILD_MODNAME, "/lib/firmware/brcm");
 		brcms_release_fw(wl);
@@ -1042,12 +1042,12 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 	wl->pub->ieee_hw = hw;
 
 	/* register our interrupt handler */
-	if (request_irq(pdev->bus->host_pci->irq, brcms_isr,
+	if (request_irq(pdev->irq, brcms_isr,
 			IRQF_SHARED, KBUILD_MODNAME, wl)) {
 		wiphy_err(wl->wiphy, "wl%d: request_irq() failed\n", unit);
 		goto fail;
 	}
-	wl->irq = pdev->bus->host_pci->irq;
+	wl->irq = pdev->irq;
 
 	/* register module */
 	brcms_c_module_register(wl->pub, "linux", wl, NULL);
@@ -1097,7 +1097,7 @@ static int __devinit brcms_bcma_probe(struct bcma_device *pdev)
 
 	dev_info(&pdev->dev, "mfg %x core %x rev %d class %d irq %d\n",
 		 pdev->id.manuf, pdev->id.id, pdev->id.rev, pdev->id.class,
-		 pdev->bus->host_pci->irq);
+		 pdev->irq);
 
 	if ((pdev->id.manuf != BCMA_MANUF_BCM) ||
 	    (pdev->id.id != BCMA_CORE_80211))
-- 
1.7.9.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33197 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaESVTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 17:19:10 -0400
Received: by mail-ee0-f54.google.com with SMTP id b57so4046485eek.13
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 14:19:08 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: move bands detection to a separated function
Date: Mon, 19 May 2014 23:18:54 +0200
Message-Id: <1400534335-23968-1-git-send-email-zajec5@gmail.com> (sfid-20140519_231915_435781_8714833D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cleans code a bit and allows adding support for more devices.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 98 +++++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 19aefa8..72a8e3f 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5081,10 +5081,50 @@ static void b43_wireless_core_detach(struct b43_wldev *dev)
 	b43_phy_free(dev);
 }
 
+static void b43_supported_bands(struct b43_wldev *dev, bool *have_2ghz_phy,
+				bool *have_5ghz_phy)
+{
+	u16 dev_id = 0;
+
+#ifdef CONFIG_B43_SSB
+	if (dev->dev->bus_type == B43_BUS_SSB &&
+	    dev->dev->sdev->bus->bustype == SSB_BUSTYPE_PCI)
+		dev_id = dev->dev->sdev->bus->host_pci->device;
+#endif
+
+	/* Note: below IDs can be "virtual" (not maching e.g. real PCI ID) */
+	switch (dev_id) {
+	case 0x4324: /* BCM4306 */
+	case 0x4312: /* BCM4311 */
+	case 0x4319: /* BCM4318 */
+		/* Dual band devices */
+		*have_2ghz_phy = true;
+		*have_5ghz_phy = true;
+		return;
+	}
+
+	/* As a fallback, try to guess using PHY type */
+	switch (dev->phy.type) {
+	case B43_PHYTYPE_A:
+		*have_2ghz_phy = false;
+		*have_5ghz_phy = true;
+		return;
+	case B43_PHYTYPE_G:
+	case B43_PHYTYPE_N:
+	case B43_PHYTYPE_LP:
+	case B43_PHYTYPE_HT:
+	case B43_PHYTYPE_LCN:
+		*have_2ghz_phy = true;
+		*have_5ghz_phy = false;
+		return;
+	}
+
+	B43_WARN_ON(1);
+}
+
 static int b43_wireless_core_attach(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
-	struct pci_dev *pdev = NULL;
 	int err;
 	u32 tmp;
 	bool have_2ghz_phy = false, have_5ghz_phy = false;
@@ -5096,19 +5136,13 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	 * that in core_init(), too.
 	 */
 
-#ifdef CONFIG_B43_SSB
-	if (dev->dev->bus_type == B43_BUS_SSB &&
-	    dev->dev->sdev->bus->bustype == SSB_BUSTYPE_PCI)
-		pdev = dev->dev->sdev->bus->host_pci;
-#endif
-
 	err = b43_bus_powerup(dev, 0);
 	if (err) {
 		b43err(wl, "Bus powerup failed\n");
 		goto out;
 	}
 
-	/* Get the PHY type. */
+	/* Try to guess supported bands for the first init needs */
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
@@ -5132,48 +5166,28 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	dev->phy.gmode = have_2ghz_phy;
 	b43_wireless_core_reset(dev, dev->phy.gmode);
 
+	/* Get the PHY type. */
 	err = b43_phy_versioning(dev);
 	if (err)
 		goto err_powerdown;
-	/* Check if this device supports multiband. */
-	if (!pdev ||
-	    (pdev->device != 0x4312 &&
-	     pdev->device != 0x4319 && pdev->device != 0x4324)) {
-		/* No multiband support. */
-		have_2ghz_phy = false;
+
+	/* Get real info about supported bands */
+	b43_supported_bands(dev, &have_2ghz_phy, &have_5ghz_phy);
+
+	/* We don't support 5 GHz on some PHYs yet */
+	switch (dev->phy.type) {
+	case B43_PHYTYPE_A:
+	case B43_PHYTYPE_N:
+	case B43_PHYTYPE_LP:
+		b43warn(wl, "5 GHz band is unsupported on this PHY\n");
 		have_5ghz_phy = false;
-		switch (dev->phy.type) {
-		case B43_PHYTYPE_A:
-			have_5ghz_phy = true;
-			break;
-		case B43_PHYTYPE_LP: //FIXME not always!
-#if 0 //FIXME enabling 5GHz causes a NULL pointer dereference
-			have_5ghz_phy = 1;
-#endif
-		case B43_PHYTYPE_G:
-		case B43_PHYTYPE_N:
-		case B43_PHYTYPE_HT:
-		case B43_PHYTYPE_LCN:
-			have_2ghz_phy = true;
-			break;
-		default:
-			B43_WARN_ON(1);
-		}
 	}
-	if (dev->phy.type == B43_PHYTYPE_A) {
-		/* FIXME */
-		b43err(wl, "IEEE 802.11a devices are unsupported\n");
+
+	if (!have_2ghz_phy && !have_5ghz_phy) {
+		b43err(wl, "b43 can't support any band on this device\n");
 		err = -EOPNOTSUPP;
 		goto err_powerdown;
 	}
-	if (1 /* disable A-PHY */) {
-		/* FIXME: For now we disable the A-PHY on multi-PHY devices. */
-		if (dev->phy.type != B43_PHYTYPE_N &&
-		    dev->phy.type != B43_PHYTYPE_LP) {
-			have_2ghz_phy = true;
-			have_5ghz_phy = false;
-		}
-	}
 
 	err = b43_phy_allocate(dev);
 	if (err)
-- 
1.8.4.5


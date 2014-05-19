Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:50511 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaESVTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 17:19:13 -0400
Received: by mail-ee0-f45.google.com with SMTP id d49so3985456eek.4
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 14:19:11 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: add more devices to the bands database
Date: Mon, 19 May 2014 23:18:55 +0200
Message-Id: <1400534335-23968-2-git-send-email-zajec5@gmail.com> (sfid-20140519_231918_885298_155C6EF3)
In-Reply-To: <1400534335-23968-1-git-send-email-zajec5@gmail.com>
References: <1400534335-23968-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 72a8e3f..397b7e4 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5086,21 +5086,52 @@ static void b43_supported_bands(struct b43_wldev *dev, bool *have_2ghz_phy,
 {
 	u16 dev_id = 0;
 
+#ifdef CONFIG_B43_BCMA
+	if (dev->dev->bus_type == B43_BUS_BCMA &&
+	    dev->dev->bdev->bus->hosttype == BCMA_HOSTTYPE_PCI)
+		dev_id = dev->dev->bdev->bus->host_pci->device;
+#endif
 #ifdef CONFIG_B43_SSB
 	if (dev->dev->bus_type == B43_BUS_SSB &&
 	    dev->dev->sdev->bus->bustype == SSB_BUSTYPE_PCI)
 		dev_id = dev->dev->sdev->bus->host_pci->device;
 #endif
+	/* Override with SPROM value if available */
+	if (dev->dev->bus_sprom->dev_id)
+		dev_id = dev->dev->bus_sprom->dev_id;
 
 	/* Note: below IDs can be "virtual" (not maching e.g. real PCI ID) */
 	switch (dev_id) {
 	case 0x4324: /* BCM4306 */
 	case 0x4312: /* BCM4311 */
 	case 0x4319: /* BCM4318 */
+	case 0x4328: /* BCM4321 */
+	case 0x432b: /* BCM4322 */
+	case 0x4350: /* BCM43222 */
+	case 0x4353: /* BCM43224 */
+	case 0x0576: /* BCM43224 */
+	case 0x435f: /* BCM6362 */
+	case 0x4331: /* BCM4331 */
+	case 0x4359: /* BCM43228 */
+	case 0x43a0: /* BCM4360 */
+	case 0x43b1: /* BCM4352 */
 		/* Dual band devices */
 		*have_2ghz_phy = true;
 		*have_5ghz_phy = true;
 		return;
+	case 0x4321: /* BCM4306 */
+	case 0x4313: /* BCM4311 */
+	case 0x431a: /* BCM4318 */
+	case 0x432a: /* BCM4321 */
+	case 0x432d: /* BCM4322 */
+	case 0x4352: /* BCM43222 */
+	case 0x4333: /* BCM4331 */
+	case 0x43a2: /* BCM4360 */
+	case 0x43b3: /* BCM4352 */
+		/* 5 GHz only devices */
+		*have_2ghz_phy = false;
+		*have_5ghz_phy = true;
+		return;
 	}
 
 	/* As a fallback, try to guess using PHY type */
@@ -5179,6 +5210,7 @@ static int b43_wireless_core_attach(struct b43_wldev *dev)
 	case B43_PHYTYPE_A:
 	case B43_PHYTYPE_N:
 	case B43_PHYTYPE_LP:
+	case B43_PHYTYPE_HT:
 		b43warn(wl, "5 GHz band is unsupported on this PHY\n");
 		have_5ghz_phy = false;
 	}
-- 
1.8.4.5


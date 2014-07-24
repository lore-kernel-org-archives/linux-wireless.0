Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:51099 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265AbaGXN3c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 09:29:32 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so2771989wes.3
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 06:29:31 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: add support for BCM43131 chipset with N-PHY rev 17
Date: Thu, 24 Jul 2014 15:29:18 +0200
Message-Id: <1406208559-19057-1-git-send-email-zajec5@gmail.com> (sfid-20140724_152937_804761_BDD4B07E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It contains radio 0x2057 rev 14 just like a BCM43217, so it doesn't
require any magic. The main difference is that BCM4313 is 1x1:1.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c  | 3 ++-
 drivers/net/wireless/b43/phy_n.c | 3 ++-
 include/linux/bcma/bcma.h        | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index d7055fe..2af1ac3 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2985,7 +2985,8 @@ void b43_mac_switch_freq(struct b43_wldev *dev, u8 spurmode)
 {
 	u16 chip_id = dev->dev->chip_id;
 
-	if (chip_id == BCMA_CHIP_ID_BCM43217 ||
+	if (chip_id == BCMA_CHIP_ID_BCM43131 ||
+	    chip_id == BCMA_CHIP_ID_BCM43217 ||
 	    chip_id == BCMA_CHIP_ID_BCM43222 ||
 	    chip_id == BCMA_CHIP_ID_BCM43224 ||
 	    chip_id == BCMA_CHIP_ID_BCM43225 ||
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d269fbb..1eead7a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4982,7 +4982,8 @@ static void b43_nphy_int_pa_set_tx_dig_filters(struct b43_wldev *dev)
 	if (dev->phy.rev == 16)
 		b43_nphy_pa_set_tx_dig_filter(dev, 0x186, dig_filter_phy_rev16);
 
-	if (dev->dev->chip_id == BCMA_CHIP_ID_BCM43217) {
+	/* Verified with BCM43131 and BCM43217 */
+	if (dev->phy.rev == 17) {
 		b43_nphy_pa_set_tx_dig_filter(dev, 0x186, dig_filter_phy_rev16);
 		b43_nphy_pa_set_tx_dig_filter(dev, 0x195,
 					      tbl_tx_filter_coef_rev4[1]);
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 969af0f..70b8d88 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -158,6 +158,7 @@ struct bcma_host_ops {
 /* Chip IDs of PCIe devices */
 #define BCMA_CHIP_ID_BCM4313	0x4313
 #define BCMA_CHIP_ID_BCM43142	43142
+#define BCMA_CHIP_ID_BCM43131	43131
 #define BCMA_CHIP_ID_BCM43217	43217
 #define BCMA_CHIP_ID_BCM43222	43222
 #define BCMA_CHIP_ID_BCM43224	43224
-- 
1.8.4.5


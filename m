Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54593 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1EKVYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 17:24:01 -0400
Received: by ewy4 with SMTP id 4so258482ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 14:23:59 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: pci: trivial: correct amount of maximum retries
Date: Thu, 12 May 2011 00:01:47 +0200
Message-Id: <1305151307-4100-1-git-send-email-zajec5@gmail.com> (sfid-20110511_232406_472028_0C78B3D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index b98b835..e757e4e 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -81,7 +81,7 @@ static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u8 device, u8 address)
 	pcicore_write32(pc, mdio_data, v);
 	/* Wait for the device to complete the transaction */
 	udelay(10);
-	for (i = 0; i < 200; i++) {
+	for (i = 0; i < max_retries; i++) {
 		v = pcicore_read32(pc, mdio_control);
 		if (v & 0x100 /* Trans complete */) {
 			udelay(10);
-- 
1.7.3.4


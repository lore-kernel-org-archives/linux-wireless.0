Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54480 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab1DAKIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 06:08:35 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so3885096wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 03:08:34 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: =?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] ssb: pci: fix mdio writes on newer cores (rev 10+)
Date: Fri,  1 Apr 2011 12:07:33 +0200
Message-Id: <1301652454-11251-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1301652454-11251-1-git-send-email-zajec5@gmail.com>
References: <1301652454-11251-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_pcicore.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index e0cf29e..08fa6fd 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -444,11 +444,35 @@ static void ssb_pcie_write(struct ssb_pcicore *pc, u32 address, u32 data)
 	pcicore_write32(pc, 0x134, data);
 }
 
+static void ssb_pcie_mdio_set_phy(struct ssb_pcicore *pc, u8 phy)
+{
+	const u16 mdio_control = 0x128;
+	const u16 mdio_data = 0x12C;
+	u32 v;
+	int i;
+
+	v = (1 << 30); /* Start of Transaction */
+	v |= (1 << 28); /* Write Transaction */
+	v |= (1 << 17); /* Turnaround */
+	v |= (0x1F << 18);
+	v |= (phy << 4);
+	pcicore_write32(pc, mdio_data, v);
+
+	udelay(10);
+	for (i = 0; i < 200; i++) {
+		v = pcicore_read32(pc, mdio_control);
+		if (v & 0x100 /* Trans complete */)
+			break;
+		msleep(1);
+	}
+}
+
 static void ssb_pcie_mdio_write(struct ssb_pcicore *pc, u8 device,
 				u8 address, u16 data)
 {
 	const u16 mdio_control = 0x128;
 	const u16 mdio_data = 0x12C;
+	int max_retries = 10;
 	u32 v;
 	int i;
 
@@ -456,16 +480,22 @@ static void ssb_pcie_mdio_write(struct ssb_pcicore *pc, u8 device,
 	v |= 0x2; /* MDIO Clock Divisor */
 	pcicore_write32(pc, mdio_control, v);
 
+	if (pc->dev->id.revision >= 10) {
+		max_retries = 200;
+		ssb_pcie_mdio_set_phy(pc, device);
+	}
+
 	v = (1 << 30); /* Start of Transaction */
 	v |= (1 << 28); /* Write Transaction */
 	v |= (1 << 17); /* Turnaround */
-	v |= (u32)device << 22;
+	if (pc->dev->id.revision < 10)
+		v |= (u32)device << 22;
 	v |= (u32)address << 18;
 	v |= data;
 	pcicore_write32(pc, mdio_data, v);
 	/* Wait for the device to complete the transaction */
 	udelay(10);
-	for (i = 0; i < 10; i++) {
+	for (i = 0; i < max_retries; i++) {
 		v = pcicore_read32(pc, mdio_control);
 		if (v & 0x100 /* Trans complete */)
 			break;
-- 
1.7.1


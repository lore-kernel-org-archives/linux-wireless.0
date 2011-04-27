Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63033 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1D0PCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 11:02:25 -0400
Received: by fxm17 with SMTP id 17so1181977fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 08:02:24 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] ssb: pci: update PCIe workarounds
Date: Wed, 27 Apr 2011 17:39:48 +0200
Message-Id: <1303918788-4903-2-git-send-email-zajec5@gmail.com> (sfid-20110427_170228_838872_1F3D2695)
In-Reply-To: <1303918788-4903-1-git-send-email-zajec5@gmail.com>
References: <1303918788-4903-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_pcicore.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index adde4f0..32a9b61 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -460,16 +460,23 @@ static void ssb_pcicore_pci_setup_workarounds(struct ssb_pcicore *pc)
 
 static void ssb_pcicore_pcie_setup_workarounds(struct ssb_pcicore *pc)
 {
-	struct ssb_device *pdev = pc->dev;
 	u32 tmp;
+	u8 rev = pc->dev->id.revision;
 
-	if ((pdev->id.revision == 0) || (pdev->id.revision == 1)) {
+	if (rev == 0 || rev == 1) {
 		/* TLP Workaround register. */
 		tmp = ssb_pcie_read(pc, 0x4);
 		tmp |= 0x8;
 		ssb_pcie_write(pc, 0x4, tmp);
 	}
-	if (pdev->id.revision == 0) {
+	if (rev == 1) {
+		/* DLLP Link Control register. */
+		tmp = ssb_pcie_read(pc, 0x100);
+		tmp |= 0x40;
+		ssb_pcie_write(pc, 0x100, tmp);
+	}
+
+	if (rev == 0) {
 		const u8 serdes_rx_device = 0x1F;
 
 		ssb_pcie_mdio_write(pc, serdes_rx_device,
@@ -478,11 +485,20 @@ static void ssb_pcicore_pcie_setup_workarounds(struct ssb_pcicore *pc)
 					6 /* CDR */, 0x0100);
 		ssb_pcie_mdio_write(pc, serdes_rx_device,
 					7 /* CDR BW */, 0x1466);
-	} else if (pdev->id.revision == 1) {
-		/* DLLP Link Control register. */
-		tmp = ssb_pcie_read(pc, 0x100);
-		tmp |= 0x40;
-		ssb_pcie_write(pc, 0x100, tmp);
+	} else if (rev == 3 || rev == 4 || rev == 5) {
+		/* TODO: DLLP Power Management Threshold */
+		ssb_pcicore_serdes_workaround(pc);
+		/* TODO: ASPM */
+	} else if (rev == 7) {
+		/* TODO: No PLL down */
+	}
+
+	if (rev >= 6) {
+		/* Miscellaneous Configuration Fixup */
+		tmp = pcicore_read16(pc, SSB_PCICORE_SPROM(5));
+		if (!(tmp & 0x8000))
+			pcicore_write16(pc, SSB_PCICORE_SPROM(5),
+					tmp | 0x8000);
 	}
 }
 
@@ -513,7 +529,10 @@ void ssb_pcicore_init(struct ssb_pcicore *pc)
 	if (!pc->hostmode)
 		ssb_pcicore_init_clientmode(pc);
 
+	/* Additional always once-executed workarounds */
 	ssb_pcicore_serdes_workaround(pc);
+	/* TODO: ASPM */
+	/* TODO: Clock Request Update */
 }
 
 static u32 ssb_pcie_read(struct ssb_pcicore *pc, u32 address)
-- 
1.7.3.4


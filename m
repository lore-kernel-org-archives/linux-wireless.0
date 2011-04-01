Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61941 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1DAL1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 07:27:48 -0400
Received: by wya21 with SMTP id 21so2846696wya.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 04:27:47 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: =?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: pci: implement serdes workaround
Date: Fri,  1 Apr 2011 13:26:52 +0200
Message-Id: <1301657212-12126-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_pcicore.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 76cbf96..1ba9f0e 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -15,6 +15,11 @@
 
 #include "ssb_private.h"
 
+static u32 ssb_pcie_read(struct ssb_pcicore *pc, u32 address);
+static void ssb_pcie_write(struct ssb_pcicore *pc, u32 address, u32 data);
+static u16 ssb_pcie_mdio_read(struct ssb_pcicore *pc, u8 device, u8 address);
+static void ssb_pcie_mdio_write(struct ssb_pcicore *pc, u8 device,
+				u8 address, u16 data);
 
 static inline
 u32 pcicore_read32(struct ssb_pcicore *pc, u16 offset)
@@ -403,6 +408,27 @@ static int pcicore_is_in_hostmode(struct ssb_pcicore *pc)
 }
 #endif /* CONFIG_SSB_PCICORE_HOSTMODE */
 
+/**************************************************
+ * Workarounds.
+ **************************************************/
+
+static u8 ssb_pcicore_polarity_workaround(struct ssb_pcicore *pc)
+{
+	return (ssb_pcie_read(pc, 0x204) & 0x10) ? 0xC0 : 0x80;
+}
+
+static void ssb_pcicore_serdes_workaround(struct ssb_pcicore *pc)
+{
+	const u8 serdes_pll_device = 0x1D;
+	const u8 serdes_rx_device = 0x1F;
+	u16 tmp;
+
+	ssb_pcie_mdio_write(pc, serdes_rx_device, 1 /* Control */,
+			    ssb_pcicore_polarity_workaround(pc));
+	tmp = ssb_pcie_mdio_read(pc, serdes_pll_device, 1 /* Control */);
+	if (tmp & 0x4000)
+		ssb_pcie_mdio_write(pc, serdes_pll_device, 1, tmp & ~0x4000);
+}
 
 /**************************************************
  * Generic and Clientmode operation code.
@@ -430,6 +456,8 @@ void ssb_pcicore_init(struct ssb_pcicore *pc)
 #endif /* CONFIG_SSB_PCICORE_HOSTMODE */
 	if (!pc->hostmode)
 		ssb_pcicore_init_clientmode(pc);
+
+	ssb_pcicore_serdes_workaround(pc);
 }
 
 static u32 ssb_pcie_read(struct ssb_pcicore *pc, u32 address)
@@ -467,8 +495,6 @@ static void ssb_pcie_mdio_set_phy(struct ssb_pcicore *pc, u8 phy)
 	}
 }
 
-#if 0
-//done but not used yet
 static u16 ssb_pcie_mdio_read(struct ssb_pcicore *pc, u8 device, u8 address)
 {
 	const u16 mdio_control = 0x128;
@@ -508,7 +534,6 @@ static u16 ssb_pcie_mdio_read(struct ssb_pcicore *pc, u8 device, u8 address)
 	pcicore_write32(pc, mdio_control, 0);
 	return ret;
 }
-#endif
 
 static void ssb_pcie_mdio_write(struct ssb_pcicore *pc, u8 device,
 				u8 address, u16 data)
-- 
1.7.1


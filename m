Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33431 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab1DAKIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 06:08:42 -0400
Received: by wya21 with SMTP id 21so2793239wya.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 03:08:41 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: =?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] ssb: pci: implement mdio reading
Date: Fri,  1 Apr 2011 12:07:34 +0200
Message-Id: <1301652454-11251-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1301652454-11251-1-git-send-email-zajec5@gmail.com>
References: <1301652454-11251-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/driver_pcicore.c |   43 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 08fa6fd..76cbf96 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -467,6 +467,49 @@ static void ssb_pcie_mdio_set_phy(struct ssb_pcicore *pc, u8 phy)
 	}
 }
 
+#if 0
+//done but not used yet
+static u16 ssb_pcie_mdio_read(struct ssb_pcicore *pc, u8 device, u8 address)
+{
+	const u16 mdio_control = 0x128;
+	const u16 mdio_data = 0x12C;
+	int max_retries = 10;
+	u16 ret = 0;
+	u32 v;
+	int i;
+
+	v = 0x80; /* Enable Preamble Sequence */
+	v |= 0x2; /* MDIO Clock Divisor */
+	pcicore_write32(pc, mdio_control, v);
+
+	if (pc->dev->id.revision >= 10) {
+		max_retries = 200;
+		ssb_pcie_mdio_set_phy(pc, device);
+	}
+
+	v = (1 << 30); /* Start of Transaction */
+	v |= (1 << 29); /* Read Transaction */
+	v |= (1 << 17); /* Turnaround */
+	if (pc->dev->id.revision < 10)
+		v |= (u32)device << 22;
+	v |= (u32)address << 18;
+	pcicore_write32(pc, mdio_data, v);
+	/* Wait for the device to complete the transaction */
+	udelay(10);
+	for (i = 0; i < 200; i++) {
+		v = pcicore_read32(pc, mdio_control);
+		if (v & 0x100 /* Trans complete */) {
+			udelay(10);
+			ret = pcicore_read32(pc, mdio_data);
+			break;
+		}
+		msleep(1);
+	}
+	pcicore_write32(pc, mdio_control, 0);
+	return ret;
+}
+#endif
+
 static void ssb_pcie_mdio_write(struct ssb_pcicore *pc, u8 device,
 				u8 address, u16 data)
 {
-- 
1.7.1


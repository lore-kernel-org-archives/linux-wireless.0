Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37494 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0AIM70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jan 2010 07:59:26 -0500
Received: by fxm25 with SMTP id 25so13340575fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jan 2010 04:59:25 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sat, 09 Jan 2010 14:00:51 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 1/4] b43: N-PHY: correct CCA resets
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u59nroc09lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   35 +++++++++++++++++++++++++++++++----
  1 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c4c39de..5cd4b1a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -314,11 +314,34 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
  	b43_phy_write(dev, B43_NPHY_PHASETR_B2, 0x20);
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BmacPhyClkFgc */
+void b43_nphy_bmac_clock_fgc(struct b43_wldev *dev, bool force)
+{
+	u32 tmslow;
+
+	if (dev->phy.type != B43_PHYTYPE_N)
+		return;
+
+	tmslow = ssb_read32(dev->dev, SSB_TMSLOW);
+	if (force)
+		tmslow |= SSB_TMSLOW_FGC;
+	else
+		tmslow &= ~SSB_TMSLOW_FGC;
+	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CCA */
  static void b43_nphy_reset_cca(struct b43_wldev *dev)
  {
-	u16 bbcfg = b43_phy_read(dev, B43_NPHY_BBCFG);
+	u16 bbcfg;
+
+	b43_nphy_bmac_clock_fgc(dev, 1);
+	bbcfg = b43_phy_read(dev, B43_NPHY_BBCFG);
  	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg | B43_NPHY_BBCFG_RSTCCA);
+	udelay(1);
  	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg & ~B43_NPHY_BBCFG_RSTCCA);
+	b43_nphy_bmac_clock_fgc(dev, 0);
+	//TODO: N PHY Force RF Seq with argument 2
  }

  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/clip-detection */
@@ -631,9 +654,13 @@ int b43_phy_initn(struct b43_wldev *dev)

  	b43_nphy_workarounds(dev);

-	//TODO N PHY BMAC Clock FGC with argument 1
-	b43_nphy_reset_cca(dev);
-	//TODO N PHY BMAC Clock FGC with argument 0
+	/* Reset CCA, in init code it differs from standard way a little */
+	b43_nphy_bmac_clock_fgc(dev, 1);
+	tmp = b43_phy_read(dev, B43_NPHY_BBCFG);
+	b43_phy_write(dev, B43_NPHY_BBCFG, tmp | B43_NPHY_BBCFG_RSTCCA);
+	b43_phy_write(dev, B43_NPHY_BBCFG, tmp & ~B43_NPHY_BBCFG_RSTCCA);
+	b43_nphy_bmac_clock_fgc(dev, 0);
+
  	//TODO N PHY MAC PHY Clock Set with argument 1
  	//TODO Disable PA Override
  	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RX2TX);
-- 
1.6.4.2


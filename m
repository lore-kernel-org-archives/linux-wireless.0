Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:52213 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab0BIUFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 15:05:53 -0500
Received: by ewy28 with SMTP id 28so4265986ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 12:05:51 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 10/11] b43: N-PHY: implement chanspec setup
Date: Tue,  9 Feb 2010 21:04:42 +0100
Message-Id: <1265745883-3392-11-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   62 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 631e01f..19d4f11 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3283,6 +3283,68 @@ int b43_phy_initn(struct b43_wldev *dev)
 	return 0;
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ChanspecSetup */
+static void b43_nphy_chanspec_setup(struct b43_wldev *dev,
+				const struct b43_nphy_channeltab_entry *e,
+				struct b43_chanspec chanspec)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	u16 tmp;
+	u32 tmp32;
+
+	tmp = b43_phy_read(dev, B43_NPHY_BANDCTL) & B43_NPHY_BANDCTL_5GHZ;
+	if (chanspec.b_freq == 1 && tmp == 0) {
+		tmp32 = b43_read32(dev, B43_MMIO_PSM_PHY_HDR);
+		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32 | 4);
+		b43_phy_set(dev, B43_PHY_B_BBCFG, 0xC000);
+		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32);
+		b43_phy_set(dev, B43_NPHY_BANDCTL, B43_NPHY_BANDCTL_5GHZ);
+	} else if (chanspec.b_freq == 1) {
+		b43_phy_mask(dev, B43_NPHY_BANDCTL, ~B43_NPHY_BANDCTL_5GHZ);
+		tmp32 = b43_read32(dev, B43_MMIO_PSM_PHY_HDR);
+		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32 | 4);
+		b43_phy_mask(dev, B43_PHY_B_BBCFG, (u16)~0xC000);
+		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32);
+	}
+
+	b43_chantab_phy_upload(dev, e);
+
+	tmp = chanspec.channel;
+	if (chanspec.b_freq == 1)
+		tmp |= 0x0100;
+	if (chanspec.b_width == 3)
+		tmp |= 0x0200;
+	b43_bmac_write_shm(dev, 0xA0, tmp);
+
+	if (nphy->radio_chanspec.channel == 14) {
+		b43_nphy_classifier(dev, 2, 0);
+		b43_phy_set(dev, B43_PHY_B_TEST, 0x0800);
+	} else {
+		b43_nphy_classifier(dev, 2, 2);
+		if (chanspec.b_freq == 2)
+			b43_phy_mask(dev, B43_PHY_B_TEST, ~0x840);
+	}
+
+	if (nphy->txpwrctrl)
+		b43_nphy_tx_power_fix(dev);
+
+	if (dev->phy.rev < 3)
+		b43_nphy_adjust_lna_gain_table(dev);
+
+	b43_nphy_tx_lp_fbw(dev);
+
+	if (dev->phy.rev >= 3 && 0) {
+		/* TODO */
+	}
+
+	b43_phy_write(dev, B43_NPHY_NDATAT_DUP40, 0x3830);
+
+	if (phy->rev >= 3)
+		b43_nphy_spur_workaround(dev);
+}
+
 static int b43_nphy_op_allocate(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy;
-- 
1.6.4.2


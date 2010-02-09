Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:23244 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab0BIUFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 15:05:34 -0500
Received: by ey-out-2122.google.com with SMTP id d26so1670260eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 12:05:32 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 09/11] b43: N-PHY: isloate 2055 radio setup
Date: Tue,  9 Feb 2010 21:04:41 +0100
Message-Id: <1265745883-3392-10-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 835d0da..631e01f 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -155,6 +155,23 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 	//TODO
 }
 
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/Radio/2055Setup */
+static void b43_radio_2055_setup(struct b43_wldev *dev,
+				const struct b43_nphy_channeltab_entry *e)
+{
+	B43_WARN_ON(dev->phy.rev >= 3);
+
+	b43_chantab_radio_upload(dev, e);
+	udelay(50);
+	b43_radio_write(dev, B2055_VCO_CAL10, 5);
+	b43_radio_write(dev, B2055_VCO_CAL10, 45);
+	if (dev->dev->bus->bustype == SSB_BUSTYPE_PCI)
+		b43_read32(dev, B43_MMIO_MACCTL);
+	b43_radio_write(dev, B2055_VCO_CAL10, 65);
+	udelay(300);
+}
+
 /* Tune the hardware to a new channel. */
 static int nphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
 {
@@ -169,12 +186,7 @@ static int nphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
 		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, 0x20);
 	else
 		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, 0x50);
-	b43_chantab_radio_upload(dev, tabent);
-	udelay(50);
-	b43_radio_write16(dev, B2055_VCO_CAL10, 5);
-	b43_radio_write16(dev, B2055_VCO_CAL10, 45);
-	b43_radio_write16(dev, B2055_VCO_CAL10, 65);
-	udelay(300);
+	b43_radio_2055_setup(dev, tabent);
 	if (0 /*FIXME 5Ghz*/)
 		b43_phy_set(dev, B43_NPHY_BANDCTL, B43_NPHY_BANDCTL_5GHZ);
 	else
-- 
1.6.4.2


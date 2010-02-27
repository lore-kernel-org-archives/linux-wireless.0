Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57978 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966330Ab0B0MEW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 07:04:22 -0500
Received: by mail-fx0-f219.google.com with SMTP id 19so915402fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 04:04:21 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 08/10] b43: N-PHY: isloate 2055 radio setup
Date: Sat, 27 Feb 2010 13:03:39 +0100
Message-Id: <1267272221-1873-9-git-send-email-zajec5@gmail.com>
In-Reply-To: <1267272221-1873-1-git-send-email-zajec5@gmail.com>
References: <1267272221-1873-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: unconditional flush
---
 drivers/net/wireless/b43/phy_n.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 30f8bf2..ffe2622 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -155,6 +155,22 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
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
+	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
+	b43_radio_write(dev, B2055_VCO_CAL10, 65);
+	udelay(300);
+}
+
 /* Tune the hardware to a new channel. */
 static int nphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
 {
@@ -169,12 +185,7 @@ static int nphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
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


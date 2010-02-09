Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:34124 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0BIUEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 15:04:54 -0500
Received: by ewy28 with SMTP id 28so4264852ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 12:04:52 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 03/11] b43: N-PHY: turn radio on/off (rfkill)
Date: Tue,  9 Feb 2010 21:04:35 +0100
Message-Id: <1265745883-3392-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   50 ++++++++++++++++++++++++++++----------
 1 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 2d8eda1..dd81e8a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -218,7 +218,10 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 	b43_radio_write16(dev, B2055_C2_RX_BB_MIDACHP, 0x83);
 }
 
-/* Initialize a Broadcom 2055 N-radio */
+/*
+ * Initialize a Broadcom 2055 N-radio
+ * http://bcm-v4.sipsolutions.net/802.11/Radio/2055/Init
+ */
 static void b43_radio_init2055(struct b43_wldev *dev)
 {
 	b43_radio_init2055_pre(dev);
@@ -229,17 +232,6 @@ static void b43_radio_init2055(struct b43_wldev *dev)
 	b43_radio_init2055_post(dev);
 }
 
-void b43_nphy_radio_turn_on(struct b43_wldev *dev)
-{
-	b43_radio_init2055(dev);
-}
-
-void b43_nphy_radio_turn_off(struct b43_wldev *dev)
-{
-	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
-		     ~B43_NPHY_RFCTL_CMD_EN);
-}
-
 /*
  * Upload the N-PHY tables.
  * http://bcm-v4.sipsolutions.net/802.11/PHY/N/InitTables
@@ -3277,9 +3269,41 @@ static void b43_nphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 	b43_write16(dev, B43_MMIO_RADIO_DATA_LOW, value);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/Radio/Switch%20Radio */
 static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 					bool blocked)
-{//TODO
+{
+	if (b43_read32(dev, B43_MMIO_MACCTL) & B43_MACCTL_ENABLED)
+		b43err(dev->wl, "MAC not suspended\n");
+
+	if (blocked) {
+		b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
+				~B43_NPHY_RFCTL_CMD_CHIP0PU);
+		if (dev->phy.rev >= 3) {
+			b43_radio_mask(dev, 0x09, ~0x2);
+
+			b43_radio_write(dev, 0x204D, 0);
+			b43_radio_write(dev, 0x2053, 0);
+			b43_radio_write(dev, 0x2058, 0);
+			b43_radio_write(dev, 0x205E, 0);
+			b43_radio_mask(dev, 0x2062, ~0xF0);
+			b43_radio_write(dev, 0x2064, 0);
+
+			b43_radio_write(dev, 0x304D, 0);
+			b43_radio_write(dev, 0x3053, 0);
+			b43_radio_write(dev, 0x3058, 0);
+			b43_radio_write(dev, 0x305E, 0);
+			b43_radio_mask(dev, 0x3062, ~0xF0);
+			b43_radio_write(dev, 0x3064, 0);
+		}
+	} else {
+		if (dev->phy.rev >= 3) {
+			/* TODO: b43_radio_init2056(dev); */
+			/* TODO: PHY Set Channel Spec (dev, radio_chanspec) */
+		} else {
+			b43_radio_init2055(dev);
+		}
+	}
 }
 
 static void b43_nphy_op_switch_analog(struct b43_wldev *dev, bool on)
-- 
1.6.4.2


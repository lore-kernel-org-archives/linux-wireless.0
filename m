Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:44952 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab1F0WIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 18:08:11 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so2183704fxd.11
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 15:08:10 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: HT-PHY: init radio when enabling it
Date: Tue, 28 Jun 2011 00:08:53 +0200
Message-Id: <1309212533-4473-2-git-send-email-zajec5@gmail.com> (sfid-20110628_001438_388005_CB815DA1)
In-Reply-To: <1309212533-4473-1-git-send-email-zajec5@gmail.com>
References: <1309212533-4473-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Masks and sets were found in MMIO dumps by using MMIO hacks. Shortly:
radio_write(0x0c51) <- 0x0070
radio_write(0x0c5a) <- 0x0003
radio_write(0x0146) <- 0x0003
radio_write(0x0546) <- 0x0003
radio_write(0x0946) <- 0x0003
radio_write(0x002e) <- 0x0078
radio_write(0x00c0) <- 0x0080
radio_write(0x002e) <- 0xff87
radio_write(0x00c0) <- 0xff7f
radio_write(0x0011) <- 0xfff7

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
The long versions of the dumps that were used to write it:

radio_write(0x0c51) <- 0x0070
radio_write(0x0c5a) <- 0x0003

 radio_read(0x0146) -> 0x0000
radio_write(0x0146) <- 0x0003
 radio_read(0x0546) -> 0x0000
radio_write(0x0546) <- 0x0003
 radio_read(0x0946) -> 0x0000
radio_write(0x0946) <- 0x0003

 radio_read(0x002e) -> 0x0000
radio_write(0x002e) <- 0x0078
 radio_read(0x00c0) -> 0x0000
radio_write(0x00c0) <- 0x0080
 radio_read(0x002e) -> 0x0000
radio_write(0x002e) <- 0x0000
 radio_read(0x00c0) -> 0x0000
radio_write(0x00c0) <- 0x0000

 radio_read(0x0011) -> 0x0000
radio_write(0x0011) <- 0x0000

*****

radio_write(0x0c51) <- 0x0070
radio_write(0x0c5a) <- 0x0003

 radio_read(0x0146) -> 0xffff
radio_write(0x0146) <- 0xffff
 radio_read(0x0546) -> 0xffff
radio_write(0x0546) <- 0xffff
 radio_read(0x0946) -> 0xffff
radio_write(0x0946) <- 0xffff

 radio_read(0x002e) -> 0xffff
radio_write(0x002e) <- 0xffff
 radio_read(0x00c0) -> 0xffff
radio_write(0x00c0) <- 0xffff
 radio_read(0x002e) -> 0xffff
radio_write(0x002e) <- 0xff87
 radio_read(0x00c0) -> 0xffff
radio_write(0x00c0) <- 0xff7f

 radio_read(0x0011) -> 0xffff
radio_write(0x0011) <- 0xfff7
---
 drivers/net/wireless/b43/phy_ht.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 8df92e1..28fb746 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -28,6 +28,10 @@
 #include "radio_2059.h"
 #include "main.h"
 
+/**************************************************
+ * Radio 2059.
+ **************************************************/
+
 static void b43_radio_2059_channel_setup(struct b43_wldev *dev,
 			const struct b43_phy_ht_channeltab_e_radio2059 *e)
 {
@@ -79,6 +83,30 @@ static void b43_radio_2059_channel_setup(struct b43_wldev *dev,
 	udelay(300);
 }
 
+static void b43_radio_2059_init(struct b43_wldev *dev)
+{
+	const u16 routing[] = { R2059_SYN, R2059_TXRX0, R2059_RXRX1 };
+	u8 i;
+
+	b43_radio_write(dev, R2059_ALL | 0x51, 0x0070);
+	b43_radio_write(dev, R2059_ALL | 0x5a, 0x0003);
+
+	for (i = 0; i < ARRAY_SIZE(routing); i++)
+		b43_radio_set(dev, routing[i] | 0x146, 0x3);
+
+	b43_radio_set(dev, 0x2e, 0x0078);
+	b43_radio_set(dev, 0xc0, 0x0080);
+	msleep(2);
+	b43_radio_mask(dev, 0x2e, ~0x0078);
+	b43_radio_mask(dev, 0xc0, ~0x0080);
+
+	b43_radio_mask(dev, 0x11, 0x0008);
+}
+
+/**************************************************
+ * Channel switching ops.
+ **************************************************/
+
 static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 				const struct b43_phy_ht_channeltab_e_phy *e,
 				struct ieee80211_channel *new_channel)
@@ -200,6 +228,11 @@ static void b43_phy_ht_op_software_rfkill(struct b43_wldev *dev,
 		b43_phy_maskset(dev, B43_PHY_HT_RF_CTL1, ~0, 0x1);
 		b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, ~0);
 		b43_phy_maskset(dev, B43_PHY_HT_RF_CTL1, ~0, 0x2);
+
+		if (dev->phy.radio_ver == 0x2059)
+			b43_radio_2059_init(dev);
+		else
+			B43_WARN_ON(1);
 	}
 }
 
-- 
1.7.1


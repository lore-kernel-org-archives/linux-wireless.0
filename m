Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53676 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1FOXVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 19:21:15 -0400
Received: by ewy4 with SMTP id 4so355085ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 16:21:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: HT-PHY: implement radio ops
Date: Thu, 16 Jun 2011 01:59:19 +0200
Message-Id: <1308182360-7711-1-git-send-email-zajec5@gmail.com> (sfid-20110616_012123_367872_14BFBF24)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Every PHY has some specific bit used for reading radio regs. Analyze of
MMIO dumps from BCM4331 and ndiswrapper has shown it is 0x200 for HT.
 radio_read(0x037f) -> 0x0073
radio_write(0x017f) <- 0x0072

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 320be0e..e535041 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -90,6 +90,22 @@ static void b43_phy_ht_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 		    (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set);
 }
 
+static u16 b43_phy_ht_op_radio_read(struct b43_wldev *dev, u16 reg)
+{
+	/* HT-PHY needs 0x200 for read access */
+	reg |= 0x200;
+
+	b43_write16(dev, B43_MMIO_RADIO24_CONTROL, reg);
+	return b43_read16(dev, B43_MMIO_RADIO24_DATA);
+}
+
+static void b43_phy_ht_op_radio_write(struct b43_wldev *dev, u16 reg,
+				      u16 value)
+{
+	b43_write16(dev, B43_MMIO_RADIO24_CONTROL, reg);
+	b43_write16(dev, B43_MMIO_RADIO24_DATA, value);
+}
+
 /**************************************************
  * PHY ops struct.
  **************************************************/
@@ -104,9 +120,9 @@ const struct b43_phy_operations b43_phyops_ht = {
 	.phy_read		= b43_phy_ht_op_read,
 	.phy_write		= b43_phy_ht_op_write,
 	.phy_maskset		= b43_phy_ht_op_maskset,
-	/*
 	.radio_read		= b43_phy_ht_op_radio_read,
 	.radio_write		= b43_phy_ht_op_radio_write,
+	/*
 	.software_rfkill	= b43_phy_ht_op_software_rfkill,
 	.switch_analog		= b43_phy_ht_op_switch_analog,
 	.switch_channel		= b43_phy_ht_op_switch_channel,
-- 
1.7.3.4


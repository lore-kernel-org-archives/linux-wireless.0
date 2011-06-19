Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52704 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1FRXkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 19:40:00 -0400
Received: by ewy4 with SMTP id 4so874472ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jun 2011 16:39:59 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: HT-PHY: implement killing radio
Date: Sun, 19 Jun 2011 02:18:11 +0200
Message-Id: <1308442692-4205-1-git-send-email-zajec5@gmail.com> (sfid-20110619_014004_283009_3F3F6484)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Closed drivers kill radio right after reading radio version and MACCTL,
so it was easy to find related PHY ops:
 phy_read(0x0810) -> 0x0000
phy_write(0x0810) <- 0x0000
To find out the mask of above OP, MMIO hack was used to fake read val:
 phy_read(0x0810) -> 0xffff
phy_write(0x0810) <- 0x0000

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
The bigger part of MMIO dump from BCM4331 driven by ndiswrapper:
 radio_read(0x0000) -> 0x0010 <-- RADIO READ WITHOUT 0x200 SET!
 radio_read(0x0001) -> 0x0059 <-- RADIO READ WITHOUT 0x200 SET!
 radio_read(0x0002) -> 0x0020 <-- RADIO READ WITHOUT 0x200 SET!
 read32 0xb0600120 -> 0x04000400
 phy_read(0x0810) -> 0x0000
phy_write(0x0810) <- 0x0000
 read32 0xb0601500 -> 0x0000100c
---
 drivers/net/wireless/b43/phy_ht.c |   15 +++++++++++++--
 drivers/net/wireless/b43/phy_ht.h |    2 ++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 5777cdb..e84d4c1 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -59,6 +59,19 @@ static void b43_phy_ht_op_free(struct b43_wldev *dev)
 	phy->ht = NULL;
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/Radio/Switch%20Radio */
+static void b43_phy_ht_op_software_rfkill(struct b43_wldev *dev,
+					bool blocked)
+{
+	if (b43_read32(dev, B43_MMIO_MACCTL) & B43_MACCTL_ENABLED)
+		b43err(dev->wl, "MAC not suspended\n");
+
+	if (blocked) {
+		b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, ~0);
+	} else {
+	}
+}
+
 static void b43_phy_ht_op_switch_analog(struct b43_wldev *dev, bool on)
 {
 	if (on) {
@@ -141,9 +154,7 @@ const struct b43_phy_operations b43_phyops_ht = {
 	.phy_maskset		= b43_phy_ht_op_maskset,
 	.radio_read		= b43_phy_ht_op_radio_read,
 	.radio_write		= b43_phy_ht_op_radio_write,
-	/*
 	.software_rfkill	= b43_phy_ht_op_software_rfkill,
-	*/
 	.switch_analog		= b43_phy_ht_op_switch_analog,
 	/*
 	.switch_channel		= b43_phy_ht_op_switch_channel,
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index 84ac47c..e16d4bb 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -8,6 +8,8 @@
 #define B43_PHY_HT_TABLE_DATALO			0x073 /* Table data low */
 #define B43_PHY_HT_TABLE_DATAHI			0x074 /* Table data high */
 
+#define B43_PHY_HT_RF_CTL1			B43_PHY_EXTG(0x010)
+
 #define B43_PHY_HT_AFE_CTL1			B43_PHY_EXTG(0x110)
 #define B43_PHY_HT_AFE_CTL2			B43_PHY_EXTG(0x111)
 #define B43_PHY_HT_AFE_CTL3			B43_PHY_EXTG(0x114)
-- 
1.7.3.4


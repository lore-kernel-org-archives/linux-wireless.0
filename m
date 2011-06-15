Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50527 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1FOXVV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 19:21:21 -0400
Received: by eyx24 with SMTP id 24so353279eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 16:21:19 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: HT-PHY: implement switching analog
Date: Thu, 16 Jun 2011 01:59:20 +0200
Message-Id: <1308182360-7711-2-git-send-email-zajec5@gmail.com> (sfid-20110616_012123_907733_B11C4B1B)
In-Reply-To: <1308182360-7711-1-git-send-email-zajec5@gmail.com>
References: <1308182360-7711-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Turning it on is always done between reading PHY version and radio
version, so it was easy to find it in MMIO dumps from ndiswrapper.
Turning off is done by writing different values to the same registers.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
MMIO dump for BCM43224 from wl:
[PHY CHECK]
 read16 0xfaafc3e0 -> 0x8406
[ANALOG ON]
phy_write(0x00a6) <- 0x000d
phy_write(0x008f) <- 0x0000
phy_write(0x00a7) <- 0x000d
phy_write(0x00a5) <- 0x0000
[RADIO CHECK]
 radio_read(0x0001) -> 0x617f

MMIO dump for BCM4331 from ndiswrapper:
[PHY CHECK]
 read16 0xb06003e0 -> 0x9701
[ANALOG ON]
phy_write(0x0911) <- 0x00cd
phy_write(0x0910) <- 0x0000
phy_write(0x0915) <- 0x00cd
phy_write(0x0914) <- 0x0000
phy_write(0x0919) <- 0x00cd
phy_write(0x0918) <- 0x0000
[RADIO CHECK]
 radio_read(0x0000) -> 0x0010
---
 drivers/net/wireless/b43/phy_ht.c |   21 +++++++++++++++++++++
 drivers/net/wireless/b43/phy_ht.h |    7 +++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index e535041..5777cdb 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -59,6 +59,25 @@ static void b43_phy_ht_op_free(struct b43_wldev *dev)
 	phy->ht = NULL;
 }
 
+static void b43_phy_ht_op_switch_analog(struct b43_wldev *dev, bool on)
+{
+	if (on) {
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL2, 0x00cd);
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL1, 0x0000);
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL4, 0x00cd);
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL3, 0x0000);
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL6, 0x00cd);
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL5, 0x0000);
+	} else {
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL1, 0x07ff);
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL2, 0x00fd);
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL3, 0x07ff);
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL4, 0x00fd);
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL5, 0x07ff);
+		b43_phy_write(dev, B43_PHY_HT_AFE_CTL6, 0x00fd);
+	}
+}
+
 static unsigned int b43_phy_ht_op_get_default_chan(struct b43_wldev *dev)
 {
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
@@ -124,7 +143,9 @@ const struct b43_phy_operations b43_phyops_ht = {
 	.radio_write		= b43_phy_ht_op_radio_write,
 	/*
 	.software_rfkill	= b43_phy_ht_op_software_rfkill,
+	*/
 	.switch_analog		= b43_phy_ht_op_switch_analog,
+	/*
 	.switch_channel		= b43_phy_ht_op_switch_channel,
 	*/
 	.get_default_chan	= b43_phy_ht_op_get_default_chan,
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index aabad6f..84ac47c 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -8,6 +8,13 @@
 #define B43_PHY_HT_TABLE_DATALO			0x073 /* Table data low */
 #define B43_PHY_HT_TABLE_DATAHI			0x074 /* Table data high */
 
+#define B43_PHY_HT_AFE_CTL1			B43_PHY_EXTG(0x110)
+#define B43_PHY_HT_AFE_CTL2			B43_PHY_EXTG(0x111)
+#define B43_PHY_HT_AFE_CTL3			B43_PHY_EXTG(0x114)
+#define B43_PHY_HT_AFE_CTL4			B43_PHY_EXTG(0x115)
+#define B43_PHY_HT_AFE_CTL5			B43_PHY_EXTG(0x118)
+#define B43_PHY_HT_AFE_CTL6			B43_PHY_EXTG(0x119)
+
 
 struct b43_phy_ht {
 };
-- 
1.7.3.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:48589 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab3CIMn5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 07:43:57 -0500
Received: by mail-we0-f182.google.com with SMTP id t57so2049620wey.13
        for <linux-wireless@vger.kernel.org>; Sat, 09 Mar 2013 04:43:56 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V3 01/13] b43: HT-PHY: rename AFE defines
Date: Sat,  9 Mar 2013 13:43:49 +0100
Message-Id: <1362833029-8484-1-git-send-email-zajec5@gmail.com> (sfid-20130309_134401_204184_A9FEB2A1)
In-Reply-To: <1362671247-10766-2-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It you take a look at N-PHY analog switch function it touches every core
on the chipset. It seems HT-PHY does they same, it just has 3 cores
instead of 2 (which make sense since BCM4331 is 3x3). Rename AFE defines
to include core id.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: make ctl_regs array static btw
V3: use correct --in-reply-to

Sorry for using wrong In-Reply-To in V2 :(
---
 drivers/net/wireless/b43/phy_ht.c |   38 ++++++++++++++++++-------------------
 drivers/net/wireless/b43/phy_ht.h |   12 ++++++------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 3719a88..df07c83 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -176,10 +176,10 @@ static void b43_phy_ht_afe_unk1(struct b43_wldev *dev)
 {
 	u8 i;
 
-	const u16 ctl_regs[3][2] = {
-		{ B43_PHY_HT_AFE_CTL1, B43_PHY_HT_AFE_CTL2 },
-		{ B43_PHY_HT_AFE_CTL3, B43_PHY_HT_AFE_CTL4 },
-		{ B43_PHY_HT_AFE_CTL5, B43_PHY_HT_AFE_CTL6},
+	static const u16 ctl_regs[3][2] = {
+		{ B43_PHY_HT_AFE_C1_OVER, B43_PHY_HT_AFE_C1 },
+		{ B43_PHY_HT_AFE_C2_OVER, B43_PHY_HT_AFE_C2 },
+		{ B43_PHY_HT_AFE_C3_OVER, B43_PHY_HT_AFE_C3},
 	};
 
 	for (i = 0; i < 3; i++) {
@@ -362,9 +362,9 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 
 	b43_phy_mask(dev, B43_PHY_EXTG(0), ~0x3);
 
-	b43_phy_write(dev, B43_PHY_HT_AFE_CTL1, 0);
-	b43_phy_write(dev, B43_PHY_HT_AFE_CTL3, 0);
-	b43_phy_write(dev, B43_PHY_HT_AFE_CTL5, 0);
+	b43_phy_write(dev, B43_PHY_HT_AFE_C1_OVER, 0);
+	b43_phy_write(dev, B43_PHY_HT_AFE_C2_OVER, 0);
+	b43_phy_write(dev, B43_PHY_HT_AFE_C3_OVER, 0);
 
 	b43_phy_write(dev, B43_PHY_EXTG(0x103), 0x20);
 	b43_phy_write(dev, B43_PHY_EXTG(0x101), 0x20);
@@ -511,19 +511,19 @@ static void b43_phy_ht_op_software_rfkill(struct b43_wldev *dev,
 static void b43_phy_ht_op_switch_analog(struct b43_wldev *dev, bool on)
 {
 	if (on) {
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL2, 0x00cd);
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL1, 0x0000);
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL4, 0x00cd);
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL3, 0x0000);
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL6, 0x00cd);
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL5, 0x0000);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C1, 0x00cd);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C1_OVER, 0x0000);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C2, 0x00cd);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C2_OVER, 0x0000);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C3, 0x00cd);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C3_OVER, 0x0000);
 	} else {
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL1, 0x07ff);
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL2, 0x00fd);
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL3, 0x07ff);
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL4, 0x00fd);
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL5, 0x07ff);
-		b43_phy_write(dev, B43_PHY_HT_AFE_CTL6, 0x00fd);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C1_OVER, 0x07ff);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C1, 0x00fd);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C2_OVER, 0x07ff);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C2, 0x00fd);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C3_OVER, 0x07ff);
+		b43_phy_write(dev, B43_PHY_HT_AFE_C3, 0x00fd);
 	}
 }
 
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index 6544c42..60824fa 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -36,12 +36,12 @@
 
 #define B43_PHY_HT_RF_CTL1			B43_PHY_EXTG(0x010)
 
-#define B43_PHY_HT_AFE_CTL1			B43_PHY_EXTG(0x110)
-#define B43_PHY_HT_AFE_CTL2			B43_PHY_EXTG(0x111)
-#define B43_PHY_HT_AFE_CTL3			B43_PHY_EXTG(0x114)
-#define B43_PHY_HT_AFE_CTL4			B43_PHY_EXTG(0x115)
-#define B43_PHY_HT_AFE_CTL5			B43_PHY_EXTG(0x118)
-#define B43_PHY_HT_AFE_CTL6			B43_PHY_EXTG(0x119)
+#define B43_PHY_HT_AFE_C1_OVER			B43_PHY_EXTG(0x110)
+#define B43_PHY_HT_AFE_C1			B43_PHY_EXTG(0x111)
+#define B43_PHY_HT_AFE_C2_OVER			B43_PHY_EXTG(0x114)
+#define B43_PHY_HT_AFE_C2			B43_PHY_EXTG(0x115)
+#define B43_PHY_HT_AFE_C3_OVER			B43_PHY_EXTG(0x118)
+#define B43_PHY_HT_AFE_C3			B43_PHY_EXTG(0x119)
 
 
 /* Values for PHY registers used on channel switching */
-- 
1.7.10.4


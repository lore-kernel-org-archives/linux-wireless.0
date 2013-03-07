Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:56620 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab3CGPrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:47:53 -0500
Received: by mail-ea0-f169.google.com with SMTP id d13so1650410eaa.28
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:47:52 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 06/13] b43: HT-PHY: implement CCA reset
Date: Thu,  7 Mar 2013 16:47:20 +0100
Message-Id: <1362671247-10766-7-git-send-email-zajec5@gmail.com> (sfid-20130307_164756_918916_4F66C51E)
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was just another similar-to-N-PHY and easy-to-track routine:
write32 0xb0601408 <- 0x00002057
 phy_read(0x0001) -> 0x0000
phy_write(0x0001) <- 0x4000
phy_write(0x0001) <- 0x0000
write32 0xb0601408 <- 0x00002055
(b43_phy_ht_force_rf_sequence was moved up unmodified)

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
P.S.
There is a "msleep" usage warning, but it's in the code I just move. Will fix
sleeps/waits later globally.
---
 drivers/net/wireless/b43/phy_ht.c |   68 +++++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 4b24816..aedbae7 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -154,6 +154,31 @@ static void b43_radio_2059_init(struct b43_wldev *dev)
 }
 
 /**************************************************
+ * RF
+ **************************************************/
+
+static void b43_phy_ht_force_rf_sequence(struct b43_wldev *dev, u16 rf_seq)
+{
+	u8 i;
+
+	u16 save_seq_mode = b43_phy_read(dev, B43_PHY_HT_RF_SEQ_MODE);
+	b43_phy_set(dev, B43_PHY_HT_RF_SEQ_MODE, 0x3);
+
+	b43_phy_set(dev, B43_PHY_HT_RF_SEQ_TRIG, rf_seq);
+	for (i = 0; i < 200; i++) {
+		if (!(b43_phy_read(dev, B43_PHY_HT_RF_SEQ_STATUS) & rf_seq)) {
+			i = 0;
+			break;
+		}
+		msleep(1);
+	}
+	if (i)
+		b43err(dev->wl, "Forcing RF sequence timeout\n");
+
+	b43_phy_write(dev, B43_PHY_HT_RF_SEQ_MODE, save_seq_mode);
+}
+
+/**************************************************
  * Various PHY ops
  **************************************************/
 
@@ -173,6 +198,20 @@ static u16 b43_phy_ht_classifier(struct b43_wldev *dev, u16 mask, u16 val)
 	return tmp;
 }
 
+static void b43_phy_ht_reset_cca(struct b43_wldev *dev)
+{
+	u16 bbcfg;
+
+	b43_phy_force_clock(dev, true);
+	bbcfg = b43_phy_read(dev, B43_PHY_HT_BBCFG);
+	b43_phy_write(dev, B43_PHY_HT_BBCFG, bbcfg | B43_PHY_HT_BBCFG_RSTCCA);
+	udelay(1);
+	b43_phy_write(dev, B43_PHY_HT_BBCFG, bbcfg & ~B43_PHY_HT_BBCFG_RSTCCA);
+	b43_phy_force_clock(dev, false);
+
+	b43_phy_ht_force_rf_sequence(dev, B43_PHY_HT_RF_SEQ_TRIG_RST2RX);
+}
+
 static void b43_phy_ht_zero_extg(struct b43_wldev *dev)
 {
 	u8 i, j;
@@ -209,27 +248,6 @@ static void b43_phy_ht_afe_unk1(struct b43_wldev *dev)
 	}
 }
 
-static void b43_phy_ht_force_rf_sequence(struct b43_wldev *dev, u16 rf_seq)
-{
-	u8 i;
-
-	u16 save_seq_mode = b43_phy_read(dev, B43_PHY_HT_RF_SEQ_MODE);
-	b43_phy_set(dev, B43_PHY_HT_RF_SEQ_MODE, 0x3);
-
-	b43_phy_set(dev, B43_PHY_HT_RF_SEQ_TRIG, rf_seq);
-	for (i = 0; i < 200; i++) {
-		if (!(b43_phy_read(dev, B43_PHY_HT_RF_SEQ_STATUS) & rf_seq)) {
-			i = 0;
-			break;
-		}
-		msleep(1);
-	}
-	if (i)
-		b43err(dev->wl, "Forcing RF sequence timeout\n");
-
-	b43_phy_write(dev, B43_PHY_HT_RF_SEQ_MODE, save_seq_mode);
-}
-
 static void b43_phy_ht_read_clip_detection(struct b43_wldev *dev, u16 *clip_st)
 {
 	clip_st[0] = b43_phy_read(dev, B43_PHY_HT_C1_CLIP1THRES);
@@ -319,6 +337,14 @@ static void b43_phy_ht_spur_avoid(struct b43_wldev *dev,
 	b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
 
 	/* TODO: reset PLL */
+
+	if (spuravoid)
+		b43_phy_set(dev, B43_PHY_HT_BBCFG, B43_PHY_HT_BBCFG_RSTRX);
+	else
+		b43_phy_mask(dev, B43_PHY_HT_BBCFG,
+				~B43_PHY_HT_BBCFG_RSTRX & 0xFFFF);
+
+	b43_phy_ht_reset_cca(dev);
 }
 
 static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
-- 
1.7.10.4


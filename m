Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33979 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab3CGPro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:47:44 -0500
Received: by mail-ee0-f53.google.com with SMTP id e53so452411eek.40
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:47:42 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 02/13] b43: HT-PHY: add classifier control function
Date: Thu,  7 Mar 2013 16:47:16 +0100
Message-Id: <1362671247-10766-3-git-send-email-zajec5@gmail.com> (sfid-20130307_164748_453948_EEF3FF38)
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After comparing operations on reg 0xB on N and HT it seems to be the
same register with similar ops. Implement them for HT-PHY.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   36 +++++++++++++++++++++++++++++++-----
 drivers/net/wireless/b43/phy_ht.h |    6 ++++++
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 20c4cb7f..2a65d01 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -157,6 +157,22 @@ static void b43_radio_2059_init(struct b43_wldev *dev)
  * Various PHY ops
  **************************************************/
 
+static u16 b43_phy_ht_classifier(struct b43_wldev *dev, u16 mask, u16 val)
+{
+	u16 tmp;
+	u16 allowed = B43_PHY_HT_CLASS_CTL_CCK_EN |
+		      B43_PHY_HT_CLASS_CTL_OFDM_EN |
+		      B43_PHY_HT_CLASS_CTL_WAITED_EN;
+
+	tmp = b43_phy_read(dev, B43_PHY_HT_CLASS_CTL);
+	tmp &= allowed;
+	tmp &= ~mask;
+	tmp |= (val & mask);
+	b43_phy_maskset(dev, B43_PHY_HT_CLASS_CTL, ~allowed, tmp);
+
+	return tmp;
+}
+
 static void b43_phy_ht_zero_extg(struct b43_wldev *dev)
 {
 	u8 i, j;
@@ -264,7 +280,15 @@ static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 	b43_phy_write(dev, B43_PHY_HT_BW5, e->bw5);
 	b43_phy_write(dev, B43_PHY_HT_BW6, e->bw6);
 
-	/* TODO: some ops on PHY regs 0x0B0 and 0xC0A */
+	if (new_channel->hw_value == 14) {
+		b43_phy_ht_classifier(dev, B43_PHY_HT_CLASS_CTL_OFDM_EN, 0);
+		b43_phy_set(dev, B43_PHY_HT_TEST, 0x0800);
+	} else {
+		b43_phy_ht_classifier(dev, B43_PHY_HT_CLASS_CTL_OFDM_EN,
+				      B43_PHY_HT_CLASS_CTL_OFDM_EN);
+		if (new_channel->band == IEEE80211_BAND_2GHZ)
+			b43_phy_mask(dev, B43_PHY_HT_TEST, ~0x840);
+	}
 
 	/* TODO: separated function? */
 	for (i = 0; i < 3; i++) {
@@ -376,8 +400,11 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 	if (0) /* TODO: condition */
 		; /* TODO: PHY op on reg 0x217 */
 
-	b43_phy_read(dev, 0xb0); /* TODO: what for? */
-	b43_phy_set(dev, 0xb0, 0x1);
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+		b43_phy_ht_classifier(dev, B43_PHY_HT_CLASS_CTL_CCK_EN, 0);
+	else
+		b43_phy_ht_classifier(dev, B43_PHY_HT_CLASS_CTL_CCK_EN,
+				      B43_PHY_HT_CLASS_CTL_CCK_EN);
 
 	b43_phy_set(dev, 0xb1, 0x91);
 	b43_phy_write(dev, 0x32f, 0x0003);
@@ -456,9 +483,8 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 	b43_phy_ht_force_rf_sequence(dev, B43_PHY_HT_RF_SEQ_TRIG_RX2TX);
 	b43_phy_ht_force_rf_sequence(dev, B43_PHY_HT_RF_SEQ_TRIG_RST2RX);
 
-	/* TODO: PHY op on reg 0xb0 */
-
 	/* TODO: Should we restore it? Or store it in global PHY info? */
+	b43_phy_ht_classifier(dev, 0, 0);
 	b43_phy_ht_read_clip_detection(dev, clip_state);
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index 60824fa..52603af 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -12,6 +12,10 @@
 #define B43_PHY_HT_TABLE_ADDR			0x072 /* Table address */
 #define B43_PHY_HT_TABLE_DATALO			0x073 /* Table data low */
 #define B43_PHY_HT_TABLE_DATAHI			0x074 /* Table data high */
+#define B43_PHY_HT_CLASS_CTL			0x0B0 /* Classifier control */
+#define  B43_PHY_HT_CLASS_CTL_CCK_EN		0x0001 /* CCK enable */
+#define  B43_PHY_HT_CLASS_CTL_OFDM_EN		0x0002 /* OFDM enable */
+#define  B43_PHY_HT_CLASS_CTL_WAITED_EN		0x0004 /* Waited enable */
 #define B43_PHY_HT_BW1				0x1CE
 #define B43_PHY_HT_BW2				0x1CF
 #define B43_PHY_HT_BW3				0x1D0
@@ -43,6 +47,8 @@
 #define B43_PHY_HT_AFE_C3_OVER			B43_PHY_EXTG(0x118)
 #define B43_PHY_HT_AFE_C3			B43_PHY_EXTG(0x119)
 
+#define B43_PHY_HT_TEST				B43_PHY_N_BMODE(0x00A)
+
 
 /* Values for PHY registers used on channel switching */
 struct b43_phy_ht_channeltab_e_phy {
-- 
1.7.10.4


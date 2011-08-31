Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56900 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1HaVe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 17:34:28 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so1223358eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:34:27 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/6] b43: LCN-PHY: rename functions, get rid of magic names
Date: Wed, 31 Aug 2011 23:36:20 +0200
Message-Id: <1314826581-27852-5-git-send-email-zajec5@gmail.com> (sfid-20110831_233437_239540_5856CE2E)
In-Reply-To: <1314826581-27852-1-git-send-email-zajec5@gmail.com>
References: <1314826581-27852-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've compared b43 with brcmsmac and took functions names from the
later.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c        |   29 +++++++++++++++++++++++------
 drivers/net/wireless/b43/tables_phy_lcn.c |   10 ++++++----
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 9e57577..b461278 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -31,6 +31,7 @@
  * Radio 2064.
  **************************************************/
 
+/* wlc_lcnphy_radio_2064_channel_tune_4313 */
 static void b43_radio_2064_channel_setup(struct b43_wldev *dev)
 {
 	u16 save[2];
@@ -73,6 +74,7 @@ static void b43_radio_2064_channel_setup(struct b43_wldev *dev)
 	b43_radio_write(dev, 0x091, 0x7);
 }
 
+/* wlc_radio_2064_init */
 static void b43_radio_2064_init(struct b43_wldev *dev)
 {
 	b43_radio_write(dev, 0x09c, 0x0020);
@@ -122,6 +124,7 @@ static void b43_radio_2064_init(struct b43_wldev *dev)
  * Various PHY ops
  **************************************************/
 
+/* wlc_lcnphy_toggle_afe_pwdn */
 static void b43_phy_lcn_afe_set_unset(struct b43_wldev *dev)
 {
 	u16 afe_ctl2 = b43_phy_read(dev, B43_PHY_LCN_AFE_CTL2);
@@ -137,7 +140,8 @@ static void b43_phy_lcn_afe_set_unset(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_LCN_AFE_CTL1, afe_ctl1);
 }
 
-static void b43_phy_lcn_clear_0x07_table(struct b43_wldev *dev)
+/* wlc_lcnphy_clear_tx_power_offsets */
+static void b43_phy_lcn_clear_tx_power_offsets(struct b43_wldev *dev)
 {
 	u8 i;
 
@@ -154,7 +158,8 @@ static void b43_phy_lcn_clear_0x07_table(struct b43_wldev *dev)
 	}
 }
 
-static void b43_phy_lcn_pre_radio_init(struct b43_wldev *dev)
+/* wlc_lcnphy_rev0_baseband_init */
+static void b43_phy_lcn_rev0_baseband_init(struct b43_wldev *dev)
 {
 	b43_radio_write(dev, 0x11c, 0);
 
@@ -181,7 +186,11 @@ static void b43_phy_lcn_pre_radio_init(struct b43_wldev *dev)
 	b43_phy_maskset(dev, 0x448, ~0x300, 0x100);
 	b43_phy_maskset(dev, 0x608, ~0xff, 0x17);
 	b43_phy_maskset(dev, 0x604, ~0x7ff, 0x3ea);
+}
 
+/* wlc_lcnphy_bu_tweaks */
+static void b43_phy_lcn_bu_tweaks(struct b43_wldev *dev)
+{
 	b43_phy_set(dev, 0x805, 0x1);
 
 	b43_phy_maskset(dev, 0x42f, ~0x7, 0x3);
@@ -203,9 +212,16 @@ static void b43_phy_lcn_pre_radio_init(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x7d6, 0x0902);
 
 	/* TODO: more ops */
+
+	if (dev->phy.rev == 1) {
+		/* TODO: more ops */
+
+		b43_phy_lcn_clear_tx_power_offsets(dev);
+	}
 }
 
-static void b43_phy_lcn_save_configsth_restore(struct b43_wldev *dev)
+/* wlc_lcnphy_vbat_temp_sense_setup */
+static void b43_phy_lcn_sense_setup(struct b43_wldev *dev)
 {
 	u8 i;
 
@@ -297,6 +313,7 @@ static void b43_phy_lcn_op_prepare_structs(struct b43_wldev *dev)
 	memset(phy_lcn, 0, sizeof(*phy_lcn));
 }
 
+/* wlc_phy_init_lcnphy */
 static int b43_phy_lcn_op_init(struct b43_wldev *dev)
 {
 	b43_phy_set(dev, 0x44a, 0x80);
@@ -312,15 +329,15 @@ static int b43_phy_lcn_op_init(struct b43_wldev *dev)
 
 	b43_phy_lcn_tables_init(dev);
 
-	b43_phy_lcn_pre_radio_init(dev);
-	b43_phy_lcn_clear_0x07_table(dev);
+	b43_phy_lcn_rev0_baseband_init(dev);
+	b43_phy_lcn_bu_tweaks(dev);
 
 	if (dev->phy.radio_ver == 0x2064)
 		b43_radio_2064_init(dev);
 	else
 		B43_WARN_ON(1);
 
-	b43_phy_lcn_save_configsth_restore(dev);
+	b43_phy_lcn_sense_setup(dev);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/b43/tables_phy_lcn.c b/drivers/net/wireless/b43/tables_phy_lcn.c
index fd2b16d..c62a940 100644
--- a/drivers/net/wireless/b43/tables_phy_lcn.c
+++ b/drivers/net/wireless/b43/tables_phy_lcn.c
@@ -295,7 +295,7 @@ static const u32 b43_lcntab_0x18[] = {
 	0x00080000, 0x00080000, 0x00080000, 0x00080000,
 };
 
-const u16 b43_lcntab_0x0f_late[] = {
+const u16 b43_lcntab_sw_ctl_4313_epa_rev0[] = {
 	0x0002, 0x0008, 0x0004, 0x0001, 0x0002, 0x0008,
 	0x0004, 0x0001, 0x0002, 0x0008, 0x0004, 0x0001,
 	0x0002, 0x0008, 0x0004, 0x0001, 0x0002, 0x0008,
@@ -488,7 +488,8 @@ static void b43_phy_lcn_rewrite_tables(struct b43_wldev *dev)
 	}
 }
 
-static void b43_phy_lcn_clean_0x18_table(struct b43_wldev *dev)
+/* wlc_lcnphy_clear_papd_comptable */
+static void b43_phy_lcn_clean_papd_comp_table(struct b43_wldev *dev)
 {
 	u8 i;
 
@@ -501,8 +502,9 @@ void b43_phy_lcn_tables_init(struct b43_wldev *dev)
 	b43_phy_lcn_upload_static_tables(dev);
 	/* TODO: various tables ops here */
 	b43_lcntab_write_bulk(dev, B43_LCNTAB16(0xf, 0),
-			ARRAY_SIZE(b43_lcntab_0x0f_late), b43_lcntab_0x0f_late);
+			ARRAY_SIZE(b43_lcntab_sw_ctl_4313_epa_rev0),
+			b43_lcntab_sw_ctl_4313_epa_rev0);
 	/* TODO: various tables ops here */
 	b43_phy_lcn_rewrite_tables(dev);
-	b43_phy_lcn_clean_0x18_table(dev);
+	b43_phy_lcn_clean_papd_comp_table(dev);
 }
-- 
1.7.3.4


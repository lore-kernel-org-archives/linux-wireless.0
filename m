Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4382 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbXDJUcU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2007 16:32:20 -0400
Date: Tue, 10 Apr 2007 16:23:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'upstream-fixes' branch of wireless-2.6
Message-ID: <20070410202337.GC14123@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit a21bd69e1509b43823c317c3bf3f7ffa99884356:
  Linus Torvalds (1):
        Linux 2.6.21-rc6

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-fixes

Daniel Drake (2):
      zd1211rw: Reject AL2230S devices
      zd1211rw: Fix E2P_PHY_REG patching

Larry Finger (2):
      bcm43xx: Fix 802.11b/g scan limits to match regulatory reqs
      bcm43xx: Fix PPC machine checks and match loopback gain specs

 drivers/net/wireless/bcm43xx/bcm43xx_main.c  |   20 +++++++++-
 drivers/net/wireless/bcm43xx/bcm43xx_phy.c   |   57 ++++++++++++++-----------
 drivers/net/wireless/zd1211rw/zd_chip.c      |   12 ++----
 drivers/net/wireless/zd1211rw/zd_chip.h      |    4 +-
 drivers/net/wireless/zd1211rw/zd_rf_al2230.c |    6 +++
 5 files changed, 63 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
index 80cb88e..a38e7ee 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -946,6 +946,7 @@ static int bcm43xx_geo_init(struct bcm43xx_private *bcm)
 	u8 channel;
 	struct bcm43xx_phyinfo *phy;
 	const char *iso_country;
+	u8 max_bg_channel;
 
 	geo = kzalloc(sizeof(*geo), GFP_KERNEL);
 	if (!geo)
@@ -967,6 +968,23 @@ static int bcm43xx_geo_init(struct bcm43xx_private *bcm)
 	}
 	iso_country = bcm43xx_locale_iso(bcm->sprom.locale);
 
+/* set the maximum channel based on locale set in sprom or witle locale option */
+	switch (bcm->sprom.locale) {
+	case BCM43xx_LOCALE_THAILAND:
+	case BCM43xx_LOCALE_ISRAEL:
+	case BCM43xx_LOCALE_JORDAN:
+	case BCM43xx_LOCALE_USA_CANADA_ANZ:
+	case BCM43xx_LOCALE_USA_LOW:
+		max_bg_channel = 11;
+		break;
+	case BCM43xx_LOCALE_JAPAN:
+	case BCM43xx_LOCALE_JAPAN_HIGH:
+		max_bg_channel = 14;
+		break;
+	default:
+		max_bg_channel = 13;
+	}
+
  	if (have_a) {
 		for (i = 0, channel = IEEE80211_52GHZ_MIN_CHANNEL;
 		      channel <= IEEE80211_52GHZ_MAX_CHANNEL; channel++) {
@@ -978,7 +996,7 @@ static int bcm43xx_geo_init(struct bcm43xx_private *bcm)
 	}
 	if (have_bg) {
 		for (i = 0, channel = IEEE80211_24GHZ_MIN_CHANNEL;
-		      channel <= IEEE80211_24GHZ_MAX_CHANNEL; channel++) {
+		      channel <= max_bg_channel; channel++) {
 			chan = &geo->bg[i++];
 			chan->freq = bcm43xx_channel_to_freq_bg(channel);
 			chan->channel = channel;
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
index d1e89be..72529a4 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_phy.c
@@ -978,7 +978,7 @@ static void bcm43xx_calc_loopback_gain(struct bcm43xx_private *bcm)
 {
 	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);
 	struct bcm43xx_radioinfo *radio = bcm43xx_current_radio(bcm);
-	u16 backup_phy[15];
+	u16 backup_phy[15] = {0};
 	u16 backup_radio[3];
 	u16 backup_bband;
 	u16 i;
@@ -989,8 +989,10 @@ static void bcm43xx_calc_loopback_gain(struct bcm43xx_private *bcm)
 	backup_phy[1] = bcm43xx_phy_read(bcm, 0x0001);
 	backup_phy[2] = bcm43xx_phy_read(bcm, 0x0811);
 	backup_phy[3] = bcm43xx_phy_read(bcm, 0x0812);
-	backup_phy[4] = bcm43xx_phy_read(bcm, 0x0814);
-	backup_phy[5] = bcm43xx_phy_read(bcm, 0x0815);
+	if (phy->rev != 1) {
+		backup_phy[4] = bcm43xx_phy_read(bcm, 0x0814);
+		backup_phy[5] = bcm43xx_phy_read(bcm, 0x0815);
+	}
 	backup_phy[6] = bcm43xx_phy_read(bcm, 0x005A);
 	backup_phy[7] = bcm43xx_phy_read(bcm, 0x0059);
 	backup_phy[8] = bcm43xx_phy_read(bcm, 0x0058);
@@ -1018,14 +1020,16 @@ static void bcm43xx_calc_loopback_gain(struct bcm43xx_private *bcm)
 			  bcm43xx_phy_read(bcm, 0x0811) | 0x0001);
 	bcm43xx_phy_write(bcm, 0x0812,
 			  bcm43xx_phy_read(bcm, 0x0812) & 0xFFFE);
-	bcm43xx_phy_write(bcm, 0x0814,
-			  bcm43xx_phy_read(bcm, 0x0814) | 0x0001);
-	bcm43xx_phy_write(bcm, 0x0815,
-			  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFE);
-	bcm43xx_phy_write(bcm, 0x0814,
-			  bcm43xx_phy_read(bcm, 0x0814) | 0x0002);
-	bcm43xx_phy_write(bcm, 0x0815,
-			  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFD);
+	if (phy->rev != 1) {
+		bcm43xx_phy_write(bcm, 0x0814,
+				  bcm43xx_phy_read(bcm, 0x0814) | 0x0001);
+		bcm43xx_phy_write(bcm, 0x0815,
+				  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFE);
+		bcm43xx_phy_write(bcm, 0x0814,
+				  bcm43xx_phy_read(bcm, 0x0814) | 0x0002);
+		bcm43xx_phy_write(bcm, 0x0815,
+				  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFD);
+	}
 	bcm43xx_phy_write(bcm, 0x0811,
 			  bcm43xx_phy_read(bcm, 0x0811) | 0x000C);
 	bcm43xx_phy_write(bcm, 0x0812,
@@ -1048,10 +1052,12 @@ static void bcm43xx_calc_loopback_gain(struct bcm43xx_private *bcm)
 				  bcm43xx_phy_read(bcm, 0x000A)
 				  | 0x2000);
 	}
-	bcm43xx_phy_write(bcm, 0x0814,
-			  bcm43xx_phy_read(bcm, 0x0814) | 0x0004);
-	bcm43xx_phy_write(bcm, 0x0815,
-			  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFB);
+	if (phy->rev != 1) {
+		bcm43xx_phy_write(bcm, 0x0814,
+				  bcm43xx_phy_read(bcm, 0x0814) | 0x0004);
+		bcm43xx_phy_write(bcm, 0x0815,
+				  bcm43xx_phy_read(bcm, 0x0815) & 0xFFFB);
+	}
 	bcm43xx_phy_write(bcm, 0x0003,
 			  (bcm43xx_phy_read(bcm, 0x0003)
 			   & 0xFF9F) | 0x0040);
@@ -1138,8 +1144,10 @@ static void bcm43xx_calc_loopback_gain(struct bcm43xx_private *bcm)
 		}
 	}
 
-	bcm43xx_phy_write(bcm, 0x0814, backup_phy[4]);
-	bcm43xx_phy_write(bcm, 0x0815, backup_phy[5]);
+	if (phy->rev != 1) {
+		bcm43xx_phy_write(bcm, 0x0814, backup_phy[4]);
+		bcm43xx_phy_write(bcm, 0x0815, backup_phy[5]);
+	}
 	bcm43xx_phy_write(bcm, 0x005A, backup_phy[6]);
 	bcm43xx_phy_write(bcm, 0x0059, backup_phy[7]);
 	bcm43xx_phy_write(bcm, 0x0058, backup_phy[8]);
@@ -1188,24 +1196,23 @@ static void bcm43xx_phy_initg(struct bcm43xx_private *bcm)
 		bcm43xx_phy_write(bcm, 0x0811, 0x0000);
 		bcm43xx_phy_write(bcm, 0x0015, 0x00C0);
 	}
-	if (phy->rev >= 3) {
+	if (phy->rev > 5) {
 		bcm43xx_phy_write(bcm, 0x0811, 0x0400);
 		bcm43xx_phy_write(bcm, 0x0015, 0x00C0);
 	}
 	if (phy->rev >= 2 && phy->connected) {
 		tmp = bcm43xx_phy_read(bcm, 0x0400) & 0xFF;
-		if (tmp < 6) {
+		if (tmp ==3 || tmp == 5) {
 			bcm43xx_phy_write(bcm, 0x04C2, 0x1816);
 			bcm43xx_phy_write(bcm, 0x04C3, 0x8006);
-			if (tmp != 3) {
+			if (tmp == 5) {
 				bcm43xx_phy_write(bcm, 0x04CC,
 						  (bcm43xx_phy_read(bcm, 0x04CC)
 						   & 0x00FF) | 0x1F00);
 			}
 		}
-	}
-	if (phy->rev < 3 && phy->connected)
 		bcm43xx_phy_write(bcm, 0x047E, 0x0078);
+	}
 	if (radio->revision == 8) {
 		bcm43xx_phy_write(bcm, 0x0801, bcm43xx_phy_read(bcm, 0x0801) | 0x0080);
 		bcm43xx_phy_write(bcm, 0x043E, bcm43xx_phy_read(bcm, 0x043E) | 0x0004);
@@ -1232,7 +1239,7 @@ static void bcm43xx_phy_initg(struct bcm43xx_private *bcm)
 		if (phy->rev >= 6) {
 			bcm43xx_phy_write(bcm, 0x0036,
 					  (bcm43xx_phy_read(bcm, 0x0036)
-					   & 0xF000) | (radio->txctl2 << 12));
+					   & 0x0FFF) | (radio->txctl2 << 12));
 		}
 		if (bcm->sprom.boardflags & BCM43xx_BFL_PACTRL)
 			bcm43xx_phy_write(bcm, 0x002E, 0x8075);
@@ -1243,7 +1250,7 @@ static void bcm43xx_phy_initg(struct bcm43xx_private *bcm)
 		else
 			bcm43xx_phy_write(bcm, 0x002F, 0x0202);
 	}
-	if (phy->connected) {
+	if (phy->connected || phy->rev >= 2) {
 		bcm43xx_phy_lo_adjust(bcm, 0);
 		bcm43xx_phy_write(bcm, 0x080F, 0x8078);
 	}
@@ -1257,7 +1264,7 @@ static void bcm43xx_phy_initg(struct bcm43xx_private *bcm)
 		 */
 		bcm43xx_nrssi_hw_update(bcm, 0xFFFF);
 		bcm43xx_calc_nrssi_threshold(bcm);
-	} else if (phy->connected) {
+	} else if (phy->connected || phy->rev >= 2) {
 		if (radio->nrssi[0] == -1000) {
 			assert(radio->nrssi[1] == -1000);
 			bcm43xx_calc_nrssi_slope(bcm);
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 9c64f89..87ee3ee 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -337,6 +337,7 @@ static int read_pod(struct zd_chip *chip, u8 *rf_type)
 	chip->patch_cr157 = (value >> 13) & 0x1;
 	chip->patch_6m_band_edge = (value >> 21) & 0x1;
 	chip->new_phy_layout = (value >> 31) & 0x1;
+	chip->al2230s_bit = (value >> 7) & 0x1;
 	chip->link_led = ((value >> 4) & 1) ? LED1 : LED2;
 	chip->supports_tx_led = 1;
 	if (value & (1 << 24)) { /* LED scenario */
@@ -591,16 +592,16 @@ int zd_chip_unlock_phy_regs(struct zd_chip *chip)
 	return r;
 }
 
-/* CR157 can be optionally patched by the EEPROM */
+/* CR157 can be optionally patched by the EEPROM for original ZD1211 */
 static int patch_cr157(struct zd_chip *chip)
 {
 	int r;
-	u32 value;
+	u16 value;
 
 	if (!chip->patch_cr157)
 		return 0;
 
-	r = zd_ioread32_locked(chip, &value, E2P_PHY_REG);
+	r = zd_ioread16_locked(chip, &value, E2P_PHY_REG);
 	if (r)
 		return r;
 
@@ -790,11 +791,6 @@ static int zd1211b_hw_reset_phy(struct zd_chip *chip)
 		goto out;
 
 	r = zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
-	if (r)
-		goto unlock;
-
-	r = patch_cr157(chip);
-unlock:
 	t = zd_chip_unlock_phy_regs(chip);
 	if (t && !r)
 		r = t;
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index b07569e..e57ed75 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -641,8 +641,8 @@ enum {
  * also only 11 channels. */
 #define E2P_ALLOWED_CHANNEL	E2P_DATA(0x18)
 
-#define E2P_PHY_REG		E2P_DATA(0x1a)
 #define E2P_DEVICE_VER		E2P_DATA(0x20)
+#define E2P_PHY_REG		E2P_DATA(0x25)
 #define E2P_36M_CAL_VALUE1	E2P_DATA(0x28)
 #define E2P_36M_CAL_VALUE2      E2P_DATA(0x2a)
 #define E2P_36M_CAL_VALUE3      E2P_DATA(0x2c)
@@ -711,7 +711,7 @@ struct zd_chip {
 	u16 link_led;
 	unsigned int pa_type:4,
 		patch_cck_gain:1, patch_cr157:1, patch_6m_band_edge:1,
-		new_phy_layout:1,
+		new_phy_layout:1, al2230s_bit:1,
 		is_zd1211b:1, supports_tx_led:1;
 };
 
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_al2230.c b/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
index 25323a1..5235a78 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_al2230.c
@@ -358,6 +358,12 @@ int zd_rf_init_al2230(struct zd_rf *rf)
 {
 	struct zd_chip *chip = zd_rf_to_chip(rf);
 
+	if (chip->al2230s_bit) {
+		dev_err(zd_chip_dev(chip), "AL2230S devices are not yet "
+			"supported by this driver.\n");
+		return -ENODEV;
+	}
+
 	rf->switch_radio_off = al2230_switch_radio_off;
 	if (chip->is_zd1211b) {
 		rf->init_hw = zd1211b_al2230_init_hw;
-- 
John W. Linville
linville@tuxdriver.com

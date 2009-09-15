Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53190 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751090AbZIOUXF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 16:23:05 -0400
Message-ID: <4AAFF7AA.4030509@gmx.de>
Date: Tue, 15 Sep 2009 22:23:06 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170: add heavy clip handling
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add heavy clip handling for 2.4GHz only (similar to the vendor driver).

Signed-off-by: Joerg Albert <jal2@gmx.de>
---
 drivers/net/wireless/ath/ar9170/ar9170.h |    2 +
 drivers/net/wireless/ath/ar9170/phy.c    |   71 ++++++++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 914e471..e63a7d9 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -204,6 +204,8 @@ struct ar9170 {
 	u8 power_2G_ht20[8];
 	u8 power_2G_ht40[8];
 
+	u8 phy_heavy_clip;
+
 #ifdef CONFIG_AR9170_LEDS
 	struct delayed_work led_work;
 	struct ar9170_led leds[AR9170_NUM_LEDS];
diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
index 941c699..c42dbd6 100644
--- a/drivers/net/wireless/ath/ar9170/phy.c
+++ b/drivers/net/wireless/ath/ar9170/phy.c
@@ -1280,8 +1280,38 @@ static u8 ar9170_get_max_edge_power(struct ar9170 *ar,
 	return rc;
 }
 
-/* calculate the conformance test limits and apply them to ar->power*
- * (derived from otus hal/hpmain.c, line 3706 ff.)
+static u8 ar9170_get_heavy_clip(struct ar9170 *ar,
+				struct ar9170_calctl_edges edges[],
+				u32 freq, enum ar9170_bw bw)
+{
+	u8 f;
+	int i;
+	u8 rc = 0;
+
+	if (freq < 3000)
+		f = freq - 2300;
+	else
+		f = (freq - 4800) / 5;
+
+	if (bw == AR9170_BW_40_BELOW || bw == AR9170_BW_40_ABOVE)
+		rc |= 0xf0;
+
+	for (i = 0; i < AR5416_NUM_BAND_EDGES; i++) {
+		if (edges[i].channel == 0xff)
+			break;
+		if (f == edges[i].channel) {
+			if (!(edges[i].power_flags & AR9170_CALCTL_EDGE_FLAGS))
+				rc |= 0x0f;
+			break;
+		}
+	}
+
+	return rc;
+}
+
+/*
+ * calculate the conformance test limits and the heavy clip parameter
+ * and apply them to ar->power* (derived from otus hal/hpmain.c, line 3706)
  */
 static void ar9170_calc_ctl(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 {
@@ -1314,6 +1344,8 @@ static void ar9170_calc_ctl(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 
 #define EDGES(c, n) (ar->eeprom.ctl_data[c].control_edges[n])
 
+	ar->phy_heavy_clip = 0;
+
 	/*
 	 * TODO: investigate the differences between OTUS'
 	 * hpreg.c::zfHpGetRegulatoryDomain() and
@@ -1349,6 +1381,15 @@ static void ar9170_calc_ctl(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 		if (ctl_idx < AR5416_NUM_CTLS) {
 			int f_off = 0;
 
+			/* determine heav clip parameter from
+			   the 11G edges array */
+			if (modes[i].ctl_mode == CTL_11G) {
+				ar->phy_heavy_clip =
+					ar9170_get_heavy_clip(ar,
+							      EDGES(ctl_idx, 1),
+							      freq, bw);
+			}
+
 			/* adjust freq for 40MHz */
 			if (modes[i].ctl_mode == CTL_2GHT40 ||
 			    modes[i].ctl_mode == CTL_5GHT40) {
@@ -1394,6 +1435,19 @@ static void ar9170_calc_ctl(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 						       modes[i].max_power);
 		}
 	}
+
+	if (ar->phy_heavy_clip & 0xf0) {
+		ar->power_2G_ht40[0]--;
+		ar->power_2G_ht40[1]--;
+		ar->power_2G_ht40[2]--;
+	}
+	if (ar->phy_heavy_clip & 0xf) {
+		ar->power_2G_ht20[0]++;
+		ar->power_2G_ht20[1]++;
+		ar->power_2G_ht20[2]++;
+	}
+
+
 #undef EDGES
 }
 
@@ -1503,8 +1557,6 @@ static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 	/* calc. conformance test limits and apply to ar->power*[] */
 	ar9170_calc_ctl(ar, freq, bw);
 
-	/* TODO: (heavy clip) regulatory domain power level fine-tuning. */
-
 	/* set ACK/CTS TX power */
 	ar9170_regwrite_begin(ar);
 
@@ -1647,6 +1699,17 @@ int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 	if (err)
 		return err;
 
+	if (ar->phy_heavy_clip) {
+		err = ar9170_write_reg(ar, 0x1c59e0,
+				       0x200 | ar->phy_heavy_clip);
+		if (err) {
+			if (ar9170_nag_limiter(ar))
+				printk(KERN_ERR "%s: failed to set "
+				       "heavy clip\n",
+				       wiphy_name(ar->hw->wiphy));
+		}
+	}
+
 	for (i = 0; i < 2; i++) {
 		ar->noise[i] = ar9170_calc_noise_dbm(
 				(le32_to_cpu(vals[2 + i]) >> 19) & 0x1ff);
-- 
1.6.0.4


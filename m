Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56477 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751358AbZIEOHs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 10:07:48 -0400
Message-ID: <4AA270B3.5060001@gmx.de>
Date: Sat, 05 Sep 2009 16:07:47 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	Christian Lamparter <chunkeey@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath,ar9170: implemented conformance test limit calc.
 for tx power
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

apply the conformance test limits (CTL) stored in the eeprom upon 
the values calculated for the tx power (ar->power_*).

This is based on the implementation in the vendor driver
(hal/hpmain.c, line 3700 ff.) with one difference:
If any ctl mode isn't found in the eeprom, we fall back to the "lower",
legacy modes (5GHT20,11A or 2GHT20,11G,11B). Otus only did 5GHT20->11A.

Currently CTL are applied for the FCC group only.

Signed-off-by: Joerg Albert <jal2@gmx.de>
---

The above diff is due to my AVM Fritz! USB stick having no *HT* CTL groups
in the eeprom at all.
Furthermore I moved the "TODO: heavy clip ..." to an, IMHO, better place.

 
 drivers/net/wireless/ath/ar9170/phy.c |  165 ++++++++++++++++++++++++++++++++-
 1 files changed, 164 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
index 108ebfe..b3e5cf3 100644
--- a/drivers/net/wireless/ath/ar9170/phy.c
+++ b/drivers/net/wireless/ath/ar9170/phy.c
@@ -556,7 +556,6 @@ int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
 	if (err)
 		return err;
 
-	/* TODO: (heavy clip) regulatory domain power level fine-tuning. */
 	err = ar9170_init_phy_from_eeprom(ar, is_2ghz, is_40mhz);
 	if (err)
 		return err;
@@ -1238,6 +1237,164 @@ static int ar9170_set_freq_cal_data(struct ar9170 *ar,
 	return ar9170_regwrite_result();
 }
 
+static u8 ar9170_get_max_edge_power(struct ar9170 *ar,
+				    struct ar9170_calctl_edges edges[],
+				    u32 freq)
+{
+/* TODO: move somewhere else */
+#define AR5416_MAX_RATE_POWER        63
+
+	int i;
+	u8 rc = AR5416_MAX_RATE_POWER;
+	u8 f;
+	if (freq < 3000)
+		f = freq - 2300;
+	else
+		f = (freq - 4800) / 5;
+
+	for (i = 0; i < AR5416_NUM_BAND_EDGES; i++) {
+		if (edges[i].channel == 0xff)
+			break;
+		if (f == edges[i].channel) {
+			/* exact freq match */
+			rc = edges[i].power_flags & ~AR9170_CALCTL_EDGE_FLAGS;
+			break;
+		}
+		if (i > 0 && f < edges[i].channel) {
+			if (f > edges[i-1].channel &&
+			    edges[i-1].power_flags & AR9170_CALCTL_EDGE_FLAGS) {
+				/* lower channel has the inband flag set */
+				rc = edges[i-1].power_flags &
+					~AR9170_CALCTL_EDGE_FLAGS;
+			}
+			break;
+		}
+	}
+
+	if (i == AR5416_NUM_BAND_EDGES) {
+		if (f > edges[i-1].channel &&
+		    edges[i-1].power_flags & AR9170_CALCTL_EDGE_FLAGS) {
+			/* lower channel has the inband flag set */
+			rc = edges[i-1].power_flags &
+				~AR9170_CALCTL_EDGE_FLAGS;
+		}
+	}
+	return rc;
+}
+
+/* calculate the conformance test limits and apply them to ar->power*
+ * (derived from otus hal/hpmain.c, line 3706 ff.)
+ */
+static void ar9170_calc_ctl(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
+{
+	u8 ctl_grp; /* CTL group */
+	u8 ctl_idx; /* CTL index */
+	int i, j;
+	struct ctl_modes {
+		u8 ctl_mode;
+		u8 max_power;
+		u8 *pwr_cal_data;
+		int pwr_cal_len;
+	} *modes;
+
+	/* order is relevant in the mode_list_*: we fall back to the
+	 * lower indices if any mode is missed in the EEPROM.
+	 */
+	struct ctl_modes mode_list_2ghz[] = {
+		{ CTL_11B, 0, ar->power_2G_cck, 4 },
+		{ CTL_11G, 0, ar->power_2G_ofdm, 4 },
+		{ CTL_2GHT20, 0, ar->power_2G_ht20, 8 },
+		{ CTL_2GHT40, 0, ar->power_2G_ht40, 8 },
+	};
+	struct ctl_modes mode_list_5ghz[] = {
+		{ CTL_11A, 0, ar->power_5G_leg, 4 },
+		{ CTL_5GHT20, 0, ar->power_5G_ht20, 8 },
+		{ CTL_5GHT40, 0, ar->power_5G_ht40, 8 },
+	};
+	int nr_modes;
+
+#define EDGES(c, n) (ar->eeprom.ctl_data[c].control_edges[n])
+
+	/* TODO: investigate the differences between OTUS'
+	 * hpreg.c::zfHpGetRegulatoryDomain() and
+	 * ath/regd.c::ath_regd_get_band_ctl() -
+	 * e.g. for FCC3_WORLD the OTUS procedure
+	 * always returns CTL_FCC, while the one in ath/ delivers
+	 * CTL_ETSI for 2GHz and CTL_FCC for 5GHz.
+	 */
+	ctl_grp = ath_regd_get_band_ctl(&ar->common.regulatory,
+					ar->hw->conf.channel->band);
+
+	/* ctl group not found - either invalid band (NO_CTL) or ww roaming */
+	if (ctl_grp == NO_CTL || ctl_grp == SD_NO_CTL)
+		ctl_grp = CTL_FCC;
+
+	if (ctl_grp != CTL_FCC)
+		/* skip CTL and heavy clip for CTL_MKK and CTL_ETSI */
+		return;
+
+	if (ar->hw->conf.channel->band == IEEE80211_BAND_2GHZ) {
+		modes = mode_list_2ghz;
+		nr_modes = ARRAY_SIZE(mode_list_2ghz);
+	} else {
+		modes = mode_list_5ghz;
+		nr_modes = ARRAY_SIZE(mode_list_5ghz);
+	}
+
+	for (i = 0; i < nr_modes; i++) {
+		u8 c = ctl_grp | modes[i].ctl_mode;
+		for (ctl_idx = 0; ctl_idx < AR5416_NUM_CTLS; ctl_idx++)
+			if (c == ar->eeprom.ctl_index[ctl_idx])
+				break;
+		if (ctl_idx < AR5416_NUM_CTLS) {
+			int f_off = 0;
+
+			/* adjust freq for 40MHz */
+			if (modes[i].ctl_mode == CTL_2GHT40 ||
+			    modes[i].ctl_mode == CTL_5GHT40) {
+				if (bw == AR9170_BW_40_BELOW)
+					f_off = -10;
+				else
+					f_off = 10;
+			}
+
+			modes[i].max_power =
+				ar9170_get_max_edge_power(ar, EDGES(ctl_idx, 1),
+							  freq+f_off);
+
+			/* TODO: check if the regulatory max. power is
+			 *  controlled by cfg80211 for DFS
+			 * (hpmain applies it to max_power itself for DFS freq)
+			 */
+
+		} else {
+			/* Workaround in otus driver, hpmain.c, line 3906:
+			 * if no data for 5GHT20 are found, take the
+			 * legacy 5G value.
+			 * We extend this here to fallback from any other *HT or
+			 * 11G, too.
+			 */
+			int k = i;
+
+			modes[i].max_power = AR5416_MAX_RATE_POWER;
+			while (k-- > 0) {
+				if (modes[k].max_power !=
+				    AR5416_MAX_RATE_POWER) {
+					modes[i].max_power = modes[k].max_power;
+					break;
+				}
+			}
+		}
+
+		/* apply max power to pwr_cal_data (ar->power_*) */
+		for (j = 0; j < modes[i].pwr_cal_len; j++) {
+			modes[i].pwr_cal_data[j] = min(modes[i].pwr_cal_data[j],
+						       modes[i].max_power);
+		}
+	}
+#undef EDGES
+}
+
 static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 {
 	struct ar9170_calibration_target_power_legacy *ctpl;
@@ -1340,6 +1497,12 @@ static int ar9170_set_power_cal(struct ar9170 *ar, u32 freq, enum ar9170_bw bw)
 					ctph[idx + 1].power[n]);
 	}
 
+
+	/* calc. conformance test limits and apply to ar->power*[] */
+	ar9170_calc_ctl(ar, freq, bw);
+
+	/* TODO: (heavy clip) regulatory domain power level fine-tuning. */
+
 	/* set ACK/CTS TX power */
 	ar9170_regwrite_begin(ar);
 
-- 
1.6.0.4


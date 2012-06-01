Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42281 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965393Ab2FAQP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 12:15:57 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/10] brcm80211: smac: use mac80211 channel data for tx power limits
Date: Fri,  1 Jun 2012 11:15:34 -0500
Message-Id: <1338567336-12076-9-git-send-email-seth.forshee@canonical.com> (sfid-20120601_181607_457217_B32EC325)
In-Reply-To: <1338567336-12076-1-git-send-email-seth.forshee@canonical.com>
References: <1338567336-12076-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the limits from the internal X2 domain are used, regardless
of what regulatory rules are in effect. Instead use the power limits set
by the higher-level regulatory support.

The rules for the MIMO power limits are still always derived from the
world domain. Guidance from Broadcom is needed on how these limits
should be determined for other regulatory domains.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |   73 ++++-----------------
 1 file changed, 14 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 9dbc1dd..19be4f7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -74,15 +74,6 @@
 /* max of BAND_5G_PWR_LVLS and 14 for 2.4 GHz */
 #define BRCMS_MAXPWR_MIMO_TBL_SIZE	14
 
-/* power level in group of 2.4GHz band channels:
- * maxpwr[0] - CCK  channels [1]
- * maxpwr[1] - CCK  channels [2-10]
- * maxpwr[2] - CCK  channels [11-14]
- * maxpwr[3] - OFDM channels [1]
- * maxpwr[4] - OFDM channels [2-10]
- * maxpwr[5] - OFDM channels [11-14]
- */
-
 /* maxpwr mapping to 5GHz band channels:
  * maxpwr[0] - channels [34-48]
  * maxpwr[1] - channels [52-60]
@@ -101,10 +92,6 @@
 #define LOCALES(band2, band5, mimo2, mimo5) \
 		{LC_2G(band2), LC_5G(band5), LC(mimo2), LC(mimo5)}
 
-/* macro to get 2.4 GHz channel group index for tx power */
-#define CHANNEL_POWER_IDX_2G_CCK(c) (((c) < 2) ? 0 : (((c) < 11) ? 1 : 2))
-#define CHANNEL_POWER_IDX_2G_OFDM(c) (((c) < 2) ? 3 : (((c) < 11) ? 4 : 5))
-
 /* macro to get 5 GHz channel group index for tx power */
 #define CHANNEL_POWER_IDX_5G(c) (((c) < 52) ? 0 : \
 				 (((c) < 62) ? 1 : \
@@ -194,8 +181,6 @@ struct locale_info {
 	u32 valid_channels;
 	/* List of channels used only if APs are detected */
 	u8 restricted_channels;
-	/* Max tx pwr in qdBm for each sub-band */
-	s8 maxpwr[BRCMS_MAXPWR_TBL_SIZE];
 	u8 flags;
 };
 
@@ -391,8 +376,6 @@ static void brcms_c_locale_get_channels(const struct locale_info *locale,
 static const struct locale_info locale_i = {	/* locale i. channel 1 - 13 */
 	LOCALE_CHAN_01_11 | LOCALE_CHAN_12_13,
 	LOCALE_RESTRICTED_SET_2G_SHORT,
-	{QDB(19), QDB(19), QDB(19),
-	 QDB(19), QDB(19), QDB(19)},
 	BRCMS_EIRP
 };
 
@@ -403,7 +386,6 @@ static const struct locale_info locale_11 = {
 	/* locale 11. channel 36 - 48, 52 - 64, 100 - 140, 149 - 165 */
 	LOCALE_CHAN_36_64 | LOCALE_CHAN_100_140 | LOCALE_CHAN_149_165,
 	LOCALE_RESTRICTED_NONE,
-	{QDB(21), QDB(21), QDB(21), QDB(21), QDB(21)},
 	BRCMS_EIRP | BRCMS_DFS_EU
 };
 
@@ -847,6 +829,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		       struct txpwr_limits *txpwr)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
+	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.channel;
 	uint i;
 	uint chan;
 	int maxpwr;
@@ -855,7 +838,6 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	struct brcms_band *band;
 	const struct locale_info *li;
 	int conducted_max = BRCMS_TXPWR_MAX;
-	int conducted_ofdm_max = BRCMS_TXPWR_MAX;
 	const struct locale_mimo_info *li_mimo;
 	int maxpwr20, maxpwr40;
 	int maxpwr_idx;
@@ -863,6 +845,9 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 
 	memset(txpwr, 0, sizeof(struct txpwr_limits));
 
+	if (WARN_ON(!ch))
+		return;
+
 	country = &wlc_cm->world_regd->country;
 
 	chan = CHSPEC_CHANNEL(chanspec);
@@ -875,49 +860,24 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	    brcms_c_get_mimo_5g(country->locale_mimo_5G) :
 	    brcms_c_get_mimo_2g(country->locale_mimo_2G);
 
-	if (li->flags & BRCMS_EIRP) {
-		delta = band->antgain;
-	} else {
-		delta = 0;
-		if (band->antgain > QDB(6))
-			delta = band->antgain - QDB(6);	/* Excess over 6 dB */
-	}
+	delta = band->antgain;
 
-	if (li == &locale_i) {
+	if (li == &locale_i)
 		conducted_max = QDB(22);
-		conducted_ofdm_max = QDB(22);
-	}
+
+	maxpwr = QDB(ch->max_power) - delta;
+	maxpwr = max(maxpwr, 0);
+	maxpwr = min(maxpwr, conducted_max);
 
 	/* CCK txpwr limits for 2.4G band */
 	if (band->bandtype == BRCM_BAND_2G) {
-		maxpwr = li->maxpwr[CHANNEL_POWER_IDX_2G_CCK(chan)];
-
-		maxpwr = maxpwr - delta;
-		maxpwr = max(maxpwr, 0);
-		maxpwr = min(maxpwr, conducted_max);
-
 		for (i = 0; i < BRCMS_NUM_RATES_CCK; i++)
 			txpwr->cck[i] = (u8) maxpwr;
 	}
 
-	/* OFDM txpwr limits for 2.4G or 5G bands */
-	if (band->bandtype == BRCM_BAND_2G)
-		maxpwr = li->maxpwr[CHANNEL_POWER_IDX_2G_OFDM(chan)];
-	else
-		maxpwr = li->maxpwr[CHANNEL_POWER_IDX_5G(chan)];
-
-	maxpwr = maxpwr - delta;
-	maxpwr = max(maxpwr, 0);
-	maxpwr = min(maxpwr, conducted_ofdm_max);
-
-	/* Keep OFDM lmit below CCK limit */
-	if (band->bandtype == BRCM_BAND_2G)
-		maxpwr = min_t(int, maxpwr, txpwr->cck[0]);
-
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
 		txpwr->ofdm[i] = (u8) maxpwr;
 
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
 		/*
 		 * OFDM 40 MHz SISO has the same power as the corresponding
 		 * MCS0-7 rate unless overriden by the locale specific code.
@@ -932,14 +892,9 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		txpwr->ofdm_40_cdd[i] = 0;
 	}
 
-	/* MIMO/HT specific limits */
-	if (li_mimo->flags & BRCMS_EIRP) {
-		delta = band->antgain;
-	} else {
-		delta = 0;
-		if (band->antgain > QDB(6))
-			delta = band->antgain - QDB(6);	/* Excess over 6 dB */
-	}
+	delta = 0;
+	if (band->antgain > QDB(6))
+		delta = band->antgain - QDB(6);	/* Excess over 6 dB */
 
 	if (band->bandtype == BRCM_BAND_2G)
 		maxpwr_idx = (chan - 1);
-- 
1.7.9.5


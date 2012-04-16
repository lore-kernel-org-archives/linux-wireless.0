Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41207 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2DPUSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 16:18:04 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: [RFC PATCH 6/8] brcm80211: smac: use mac80211 channel data for tx power limits
Date: Mon, 16 Apr 2012 15:17:40 -0500
Message-Id: <1334607462-5387-7-git-send-email-seth.forshee@canonical.com> (sfid-20120416_221809_149017_DD50EC29)
In-Reply-To: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the limits from the internal X2 domain are used, regardless
of what regulatory rules are in effect. Instead use the power limits set
by the higher-level regulatory support.

The rules for the MIMO power limits are still always derived from the
world domain. Guidance from Broadcom is needed on how these limits
should be determined for other regulatory domains.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |   73 ++++-----------------
 1 file changed, 14 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 590e8c1..cda40c8 100644
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
@@ -198,8 +185,6 @@ struct locale_info {
 	u32 valid_channels;
 	/* List of channels used only if APs are detected */
 	u8 restricted_channels;
-	/* Max tx pwr in qdBm for each sub-band */
-	s8 maxpwr[BRCMS_MAXPWR_TBL_SIZE];
 	u8 flags;
 };
 
@@ -395,8 +380,6 @@ static void brcms_c_locale_get_channels(const struct locale_info *locale,
 static const struct locale_info locale_i = {	/* locale i. channel 1 - 13 */
 	LOCALE_CHAN_01_11 | LOCALE_CHAN_12_13,
 	LOCALE_RESTRICTED_SET_2G_SHORT,
-	{QDB(19), QDB(19), QDB(19),
-	 QDB(19), QDB(19), QDB(19)},
 	BRCMS_EIRP
 };
 
@@ -407,7 +390,6 @@ static const struct locale_info locale_11 = {
 	/* locale 11. channel 36 - 48, 52 - 64, 100 - 140, 149 - 165 */
 	LOCALE_CHAN_36_64 | LOCALE_CHAN_100_140 | LOCALE_CHAN_149_165,
 	LOCALE_RESTRICTED_NONE,
-	{QDB(21), QDB(21), QDB(21), QDB(21), QDB(21)},
 	BRCMS_EIRP | BRCMS_DFS_EU
 };
 
@@ -852,6 +834,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		       struct txpwr_limits *txpwr)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
+	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.channel;
 	uint i;
 	uint chan;
 	int maxpwr;
@@ -860,7 +843,6 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	struct brcms_band *band;
 	const struct locale_info *li;
 	int conducted_max = BRCMS_TXPWR_MAX;
-	int conducted_ofdm_max = BRCMS_TXPWR_MAX;
 	const struct locale_mimo_info *li_mimo;
 	int maxpwr20, maxpwr40;
 	int maxpwr_idx;
@@ -868,6 +850,9 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 
 	memset(txpwr, 0, sizeof(struct txpwr_limits));
 
+	if (WARN_ON(!ch))
+		return;
+
 	country = &wlc_cm->world_regd->country;
 
 	chan = CHSPEC_CHANNEL(chanspec);
@@ -880,49 +865,24 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
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
@@ -937,14 +897,9 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
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


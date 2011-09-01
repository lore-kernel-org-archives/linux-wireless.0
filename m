Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2929 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033Ab1IAJRm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:42 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 28/30] staging: brcm80211: cleaned up softmac channel
 related macro's
Date: Thu, 1 Sep 2011 11:17:18 +0200
Message-ID: <1314868640-9425-29-git-send-email-rvossen@broadcom.com> (sfid-20110901_111808_784754_8C366220)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moved, deleted or substituted macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/channel.c     |  141 ++++++++++++++++------
 drivers/staging/brcm80211/brcmsmac/channel.h     |   82 +-------------
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.h        |    2 +-
 drivers/staging/brcm80211/brcmsmac/stf.c         |    2 +-
 5 files changed, 107 insertions(+), 122 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 6c5272e..e6afdc9 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -24,11 +24,6 @@
 #include "stf.h"
 #include "channel.h"
 
-#define	VALID_CHANNEL20_DB(wlc, val) brcms_c_valid_channel20_db((wlc)->cmi, val)
-#define	VALID_CHANNEL20_IN_BAND(wlc, bandunit, val) \
-	brcms_c_valid_channel20_in_band((wlc)->cmi, bandunit, val)
-#define	VALID_CHANNEL20(wlc, val) brcms_c_valid_channel20((wlc)->cmi, val)
-
 /* QDB() macro takes a dB value and converts to a quarter dB value */
 #define QDB(n) ((n) * BRCMS_TXPWR_DB_FACTOR)
 
@@ -76,6 +71,55 @@
 #define  LOCALE_RESTRICTED_LOW_HI	  7
 #define  LOCALE_RESTRICTED_12_13_14	  8
 
+#define LOCALE_2G_IDX_i			0
+#define LOCALE_5G_IDX_11		0
+#define LOCALE_MIMO_IDX_bn		0
+#define LOCALE_MIMO_IDX_11n		0
+
+/* max of BAND_5G_PWR_LVLS and 6 for 2.4 GHz */
+#define BRCMS_MAXPWR_TBL_SIZE		6
+/* max of BAND_5G_PWR_LVLS and 14 for 2.4 GHz */
+#define BRCMS_MAXPWR_MIMO_TBL_SIZE	14
+
+/* power level in group of 2.4GHz band channels:
+ * maxpwr[0] - CCK  channels [1]
+ * maxpwr[1] - CCK  channels [2-10]
+ * maxpwr[2] - CCK  channels [11-14]
+ * maxpwr[3] - OFDM channels [1]
+ * maxpwr[4] - OFDM channels [2-10]
+ * maxpwr[5] - OFDM channels [11-14]
+ */
+
+/* maxpwr mapping to 5GHz band channels:
+ * maxpwr[0] - channels [34-48]
+ * maxpwr[1] - channels [52-60]
+ * maxpwr[2] - channels [62-64]
+ * maxpwr[3] - channels [100-140]
+ * maxpwr[4] - channels [149-165]
+ */
+#define BAND_5G_PWR_LVLS	5	/* 5 power levels for 5G */
+
+#define LC(id)	LOCALE_MIMO_IDX_ ## id
+
+#define LC_2G(id)	LOCALE_2G_IDX_ ## id
+
+#define LC_5G(id)	LOCALE_5G_IDX_ ## id
+
+#define LOCALES(band2, band5, mimo2, mimo5) \
+		{LC_2G(band2), LC_5G(band5), LC(mimo2), LC(mimo5)}
+
+/* macro to get 2.4 GHz channel group index for tx power */
+#define CHANNEL_POWER_IDX_2G_CCK(c) (((c) < 2) ? 0 : (((c) < 11) ? 1 : 2))
+#define CHANNEL_POWER_IDX_2G_OFDM(c) (((c) < 2) ? 3 : (((c) < 11) ? 4 : 5))
+
+/* macro to get 5 GHz channel group index for tx power */
+#define CHANNEL_POWER_IDX_5G(c) (((c) < 52) ? 0 : \
+				 (((c) < 62) ? 1 : \
+				 (((c) < 100) ? 2 : \
+				 (((c) < 149) ? 3 : 4))))
+
+#define ISDFS_EU(fl)		(((fl) & BRCMS_DFS_EU) == BRCMS_DFS_EU)
+
 struct brcms_cm_band {
 	/* struct locale_info flags */
 	u8 locale_flags;
@@ -88,6 +132,26 @@ struct brcms_cm_band {
 	u8 PAD[8];
 };
 
+ /* locale per-channel tx power limits for MIMO frames
+  * maxpwr arrays are index by channel for 2.4 GHz limits, and
+  * by sub-band for 5 GHz limits using CHANNEL_POWER_IDX_5G(channel)
+  */
+struct locale_mimo_info {
+	/* tx 20 MHz power limits, qdBm units */
+	s8 maxpwr20[BRCMS_MAXPWR_MIMO_TBL_SIZE];
+	/* tx 40 MHz power limits, qdBm units */
+	s8 maxpwr40[BRCMS_MAXPWR_MIMO_TBL_SIZE];
+	u8 flags;
+};
+
+/* Country names and abbreviations with locale defined from ISO 3166 */
+struct country_info {
+	const u8 locale_2G;	/* 2.4G band locale */
+	const u8 locale_5G;	/* 5G band locale */
+	const u8 locale_mimo_2G;	/* 2.4G mimo info */
+	const u8 locale_mimo_5G;	/* 5G mimo info */
+};
+
 struct brcms_cm_info {
 	struct brcms_pub *pub;
 	struct brcms_c_info *wlc;
@@ -104,6 +168,20 @@ struct brcms_cm_info {
 	struct brcms_chanvec quiet_channels;
 };
 
+/* locale channel and power info. */
+struct locale_info {
+	u32 valid_channels;
+	/* List of radar sensitive channels */
+	u8 radar_channels;
+	/* List of channels used only if APs are detected */
+	u8 restricted_channels;
+	/* Max tx pwr in qdBm for each sub-band */
+	s8 maxpwr[BRCMS_MAXPWR_TBL_SIZE];
+	/* Country IE advertised max tx pwr in dBm per sub-band */
+	s8 pub_maxpwr[BAND_5G_PWR_LVLS];
+	u8 flags;
+};
+
 /* Regulatory Matrix Spreadsheet (CLM) MIMO v3.7.9 */
 
 /*
@@ -138,9 +216,6 @@ const struct brcms_chanvec chanvec_all_5G = {
  * Radar channel sets
  */
 
-/* No radar */
-#define radar_set_none chanvec_none
-
 /* Channels 52 - 64, 100 - 140 */
 static const struct brcms_chanvec radar_set1 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x11,  /* 52 - 60 */
@@ -153,8 +228,6 @@ static const struct brcms_chanvec radar_set1 = {
  * Restricted channel sets
  */
 
-#define restricted_set_none chanvec_none
-
 /* Channels 34, 38, 42, 46 */
 static const struct brcms_chanvec restricted_set_japan_legacy = {
 	{0x00, 0x00, 0x00, 0x00, 0x44, 0x44, 0x00, 0x00,
@@ -393,12 +466,10 @@ static const struct locale_info locale_11 = {
 	BRCMS_EIRP | BRCMS_DFS_EU
 };
 
-#define LOCALE_2G_IDX_i			0
 static const struct locale_info *g_locale_2g_table[] = {
 	&locale_i
 };
 
-#define LOCALE_5G_IDX_11	0
 static const struct locale_info *g_locale_5g_table[] = {
 	&locale_11
 };
@@ -416,9 +487,6 @@ static const struct locale_mimo_info locale_bn = {
 	0
 };
 
-/* locale mimo 2g indexes */
-#define LOCALE_MIMO_IDX_bn			0
-
 static const struct locale_mimo_info *g_mimo_2g_table[] = {
 	&locale_bn
 };
@@ -432,20 +500,10 @@ static const struct locale_mimo_info locale_11n = {
 	0
 };
 
-#define LOCALE_MIMO_IDX_11n			0
 static const struct locale_mimo_info *g_mimo_5g_table[] = {
 	&locale_11n
 };
 
-#define LC(id)	LOCALE_MIMO_IDX_ ## id
-
-#define LC_2G(id)	LOCALE_2G_IDX_ ## id
-
-#define LC_5G(id)	LOCALE_5G_IDX_ ## id
-
-#define LOCALES(band2, band5, mimo2, mimo5) \
-		{LC_2G(band2), LC_5G(band5), LC(mimo2), LC(mimo5)}
-
 static const struct {
 	char abbrev[BRCM_CNTRY_BUF_SZ];	/* country abbreviation */
 	struct country_info country;
@@ -679,7 +737,7 @@ static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm)
 	memset(&wlc_cm->quiet_channels, 0, sizeof(struct brcms_chanvec));
 
 	band = wlc->band;
-	for (i = 0; i < NBANDS(wlc);
+	for (i = 0; i < wlc->pub->_nbands;
 	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
 
 		/* initialize quiet channels for restricted channels */
@@ -715,9 +773,10 @@ static bool brcms_c_valid_channel20_db(struct brcms_cm_info *wlc_cm, uint val)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 
-	return VALID_CHANNEL20(wlc, val) ||
+	return brcms_c_valid_channel20(wlc->cmi, val) ||
 		(!wlc->bandlocked
-		 && VALID_CHANNEL20_IN_BAND(wlc, OTHERBANDUNIT(wlc), val));
+		 && brcms_c_valid_channel20_in_band(wlc->cmi,
+						    OTHERBANDUNIT(wlc), val));
 }
 
 /* JP, J1 - J10 are Japan ccodes */
@@ -819,7 +878,7 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 
 	/* search for the existence of any valid channel */
 	for (chan = 0; chan < MAXCHANNEL; chan++) {
-		if (VALID_CHANNEL20_DB(wlc, chan))
+		if (brcms_c_valid_channel20_db(wlc->cmi, chan))
 			break;
 	}
 	if (chan == MAXCHANNEL)
@@ -837,7 +896,7 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 		mboolset(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
 		wiphy_err(wlc->wiphy, "wl%d: %s: no valid channel for \"%s\" "
 			  "nbands %d bandlocked %d\n", wlc->pub->unit,
-			  __func__, wlc_cm->country_abbrev, NBANDS(wlc),
+			  __func__, wlc_cm->country_abbrev, wlc->pub->_nbands,
 			  wlc->bandlocked);
 	} else if (mboolisset(wlc->pub->radio_disabled,
 			      WL_RADIO_COUNTRY_DISABLE)) {
@@ -852,7 +911,7 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 	 * Now that the country abbreviation is set, if the radio supports 2G,
 	 * then set channel 14 restrictions based on the new locale.
 	 */
-	if (NBANDS(wlc) > 1 || BAND_2G(wlc->band->bandtype))
+	if (wlc->pub->_nbands > 1 || BAND_2G(wlc->band->bandtype))
 		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
 						     brcms_c_japan(wlc) ? true :
 						     false);
@@ -877,7 +936,7 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 	const struct locale_mimo_info *li_mimo;
 
 	band = wlc->band;
-	for (i = 0; i < NBANDS(wlc);
+	for (i = 0; i < wlc->pub->_nbands;
 	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
 
 		li = BAND_5G(band->bandtype) ?
@@ -1461,9 +1520,11 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
 	/* Check a 20Mhz channel */
 	if (CHSPEC_IS20(chspec)) {
 		if (dualband)
-			return VALID_CHANNEL20_DB(wlc_cm->wlc, channel);
+			return brcms_c_valid_channel20_db(wlc_cm->wlc->cmi,
+							  channel);
 		else
-			return VALID_CHANNEL20(wlc_cm->wlc, channel);
+			return brcms_c_valid_channel20(wlc_cm->wlc->cmi,
+						       channel);
 	}
 #ifdef SUPPORT_40MHZ
 	/*
@@ -1479,12 +1540,16 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
 			return false;
 
 		if (dualband) {
-			if (!VALID_CHANNEL20_DB(wlc, LOWER_20_SB(channel)) ||
-			    !VALID_CHANNEL20_DB(wlc, UPPER_20_SB(channel)))
+			if (!brcms_c_valid_channel20_db(wlc->cmi,
+							LOWER_20_SB(channel)) ||
+			    !brcms_c_valid_channel20_db(wlc->cmi,
+							UPPER_20_SB(channel)))
 				return false;
 		} else {
-			if (!VALID_CHANNEL20(wlc, LOWER_20_SB(channel)) ||
-			    !VALID_CHANNEL20(wlc, UPPER_20_SB(channel)))
+			if (!brcms_c_valid_channel20(wlc->cmi,
+						     LOWER_20_SB(channel)) ||
+			    !brcms_c_valid_channel20(wlc->cmi,
+						     UPPER_20_SB(channel)))
 				return false;
 		}
 
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.h b/drivers/staging/brcm80211/brcmsmac/channel.h
index 3e85844..808cb4f 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.h
+++ b/drivers/staging/brcm80211/brcmsmac/channel.h
@@ -20,60 +20,6 @@
 /* conversion for phy txpwr calculations that use .25 dB units */
 #define BRCMS_TXPWR_DB_FACTOR 4
 
-
-/* maxpwr mapping to 5GHz band channels:
- * maxpwr[0] - channels [34-48]
- * maxpwr[1] - channels [52-60]
- * maxpwr[2] - channels [62-64]
- * maxpwr[3] - channels [100-140]
- * maxpwr[4] - channels [149-165]
- */
-#define BAND_5G_PWR_LVLS	5	/* 5 power levels for 5G */
-
-/* power level in group of 2.4GHz band channels:
- * maxpwr[0] - CCK  channels [1]
- * maxpwr[1] - CCK  channels [2-10]
- * maxpwr[2] - CCK  channels [11-14]
- * maxpwr[3] - OFDM channels [1]
- * maxpwr[4] - OFDM channels [2-10]
- * maxpwr[5] - OFDM channels [11-14]
- */
-
-/* macro to get 2.4 GHz channel group index for tx power */
-#define CHANNEL_POWER_IDX_2G_CCK(c) (((c) < 2) ? 0 : (((c) < 11) ? 1 : 2))
-#define CHANNEL_POWER_IDX_2G_OFDM(c) (((c) < 2) ? 3 : (((c) < 11) ? 4 : 5))
-
-/* macro to get 5 GHz channel group index for tx power */
-#define CHANNEL_POWER_IDX_5G(c) (((c) < 52) ? 0 : \
-				 (((c) < 62) ? 1 : \
-				 (((c) < 100) ? 2 : \
-				 (((c) < 149) ? 3 : 4))))
-
-/* max of BAND_5G_PWR_LVLS and 6 for 2.4 GHz */
-#define BRCMS_MAXPWR_TBL_SIZE		6
-/* max of BAND_5G_PWR_LVLS and 14 for 2.4 GHz */
-#define BRCMS_MAXPWR_MIMO_TBL_SIZE	14
-
-#define NBANDS(wlc) ((wlc)->pub->_nbands)
-#define NBANDS_PUB(pub) ((pub)->_nbands)
-#define NBANDS_HW(hw) ((hw)->_nbands)
-
-#define IS_SINGLEBAND_5G(device)	0
-
-/* locale channel and power info. */
-struct locale_info {
-	u32 valid_channels;
-	/* List of radar sensitive channels */
-	u8 radar_channels;
-	/* List of channels used only if APs are detected */
-	u8 restricted_channels;
-	/* Max tx pwr in qdBm for each sub-band */
-	s8 maxpwr[BRCMS_MAXPWR_TBL_SIZE];
-	/* Country IE advertised max tx pwr in dBm per sub-band */
-	s8 pub_maxpwr[BAND_5G_PWR_LVLS];
-	u8 flags;
-};
-
 /* bits for locale_info flags */
 #define BRCMS_PEAK_CONDUCTED	0x00	/* Peak for locals */
 #define BRCMS_EIRP		0x01	/* Flag for EIRP */
@@ -83,34 +29,8 @@ struct locale_info {
 #define BRCMS_NO_MIMO		0x10	/* Flag for No MIMO, 20 or 40 MHz */
 #define BRCMS_RADAR_TYPE_EU       0x20	/* Flag for EU */
 #define BRCMS_DFS_FCC             BRCMS_DFS_TPC	/* Flag for DFS FCC */
-#define BRCMS_DFS_EU (BRCMS_DFS_TPC | BRCMS_RADAR_TYPE_EU) /* Flag for DFS EU */
-
-#define ISDFS_EU(fl)		(((fl) & BRCMS_DFS_EU) == BRCMS_DFS_EU)
-
-/* locale per-channel tx power limits for MIMO frames
- * maxpwr arrays are index by channel for 2.4 GHz limits, and
- * by sub-band for 5 GHz limits using CHANNEL_POWER_IDX_5G(channel)
- */
-struct locale_mimo_info {
-	/* tx 20 MHz power limits, qdBm units */
-	s8 maxpwr20[BRCMS_MAXPWR_MIMO_TBL_SIZE];
-	/* tx 40 MHz power limits, qdBm units */
-	s8 maxpwr40[BRCMS_MAXPWR_MIMO_TBL_SIZE];
-	u8 flags;
-};
 
-extern const struct brcms_chanvec chanvec_all_2G;
-extern const struct brcms_chanvec chanvec_all_5G;
-
-/*
- * Country names and abbreviations with locale defined from ISO 3166
- */
-struct country_info {
-	const u8 locale_2G;	/* 2.4G band locale */
-	const u8 locale_5G;	/* 5G band locale */
-	const u8 locale_mimo_2G;	/* 2.4G mimo info */
-	const u8 locale_mimo_5G;	/* 5G mimo info */
-};
+#define BRCMS_DFS_EU (BRCMS_DFS_TPC | BRCMS_RADAR_TYPE_EU) /* Flag for DFS EU */
 
 extern struct brcms_cm_info *
 brcms_c_channel_mgr_attach(struct brcms_c_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 6ed80b2..227beb6 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -1114,7 +1114,7 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	}
 
 	/* Assume all bands use the same phy.  True for 11n devices. */
-	if (NBANDS_PUB(wl->pub) > 1) {
+	if (wl->pub->_nbands > 1) {
 		has_5g++;
 		if (phy_list[0] == 'n' || phy_list[0] == 'c')
 			hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 433e6a9..d151a5c 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -1044,7 +1044,7 @@ struct brcms_bss_cfg {
 	((uint)((wlc)->band->bandunit ? BAND_2G_INDEX : BAND_5G_INDEX))
 
 #define IS_MBAND_UNLOCKED(wlc) \
-	((NBANDS(wlc) > 1) && !(wlc)->bandlocked)
+	((wlc->pub->_nbands > 1) && !(wlc)->bandlocked)
 
 #define BRCMS_BAND_PI_RADIO_CHANSPEC wlc_phy_chanspec_get(wlc->band->pi)
 
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 7a9349c..62f3efe 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -290,7 +290,7 @@ int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 		return -EINVAL;
 
 	if (txstreams == 1) {
-		for (i = 0; i < NBANDS(wlc); i++)
+		for (i = 0; i < wlc->pub->_nbands; i++)
 			if ((RSPEC_STF(wlc->bandstate[i]->rspec_override) !=
 			     PHY_TXC1_MODE_SISO)
 			    || (RSPEC_STF(wlc->bandstate[i]->mrspec_override) !=
-- 
1.7.4.1



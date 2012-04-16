Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41193 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2DPURx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 16:17:53 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: [RFC PATCH 3/8] brcm80211: smac: clean up channel.c
Date: Mon, 16 Apr 2012 15:17:37 -0500
Message-Id: <1334607462-5387-4-git-send-email-seth.forshee@canonical.com> (sfid-20120416_221755_854135_CFA395B8)
In-Reply-To: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Much of the code is either unsed or never put to any useful purpose.
Remove this code in advance of reworking the driver's regulatory
support.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |  254 +--------------------
 1 file changed, 5 insertions(+), 249 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 71fce2c..1998c86 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -58,18 +58,8 @@
 				 LOCALE_CHAN_12_13 | \
 				 LOCALE_CHAN_14)
 
-#define  LOCALE_RADAR_SET_NONE		  0
-#define  LOCALE_RADAR_SET_1		  1
-
 #define  LOCALE_RESTRICTED_NONE		  0
 #define  LOCALE_RESTRICTED_SET_2G_SHORT   1
-#define  LOCALE_RESTRICTED_CHAN_165       2
-#define  LOCALE_CHAN_ALL_5G		  3
-#define  LOCALE_RESTRICTED_JAPAN_LEGACY   4
-#define  LOCALE_RESTRICTED_11D_2G	  5
-#define  LOCALE_RESTRICTED_11D_5G	  6
-#define  LOCALE_RESTRICTED_LOW_HI	  7
-#define  LOCALE_RESTRICTED_12_13_14	  8
 
 #define LOCALE_2G_IDX_i			0
 #define LOCALE_5G_IDX_11		0
@@ -118,8 +108,6 @@
 				 (((c) < 100) ? 2 : \
 				 (((c) < 149) ? 3 : 4))))
 
-#define ISDFS_EU(fl)		(((fl) & BRCMS_DFS_EU) == BRCMS_DFS_EU)
-
 struct brcms_cm_band {
 	/* struct locale_info flags */
 	u8 locale_flags;
@@ -127,9 +115,6 @@ struct brcms_cm_band {
 	struct brcms_chanvec valid_channels;
 	/* List of restricted use channels */
 	const struct brcms_chanvec *restricted_channels;
-	/* List of radar sensitive channels */
-	const struct brcms_chanvec *radar_channels;
-	u8 PAD[8];
 };
 
  /* locale per-channel tx power limits for MIMO frames
@@ -158,7 +143,6 @@ struct brcms_cm_info {
 	char srom_ccode[BRCM_CNTRY_BUF_SZ];	/* Country Code in SROM */
 	uint srom_regrev;	/* Regulatory Rev for the SROM ccode */
 	const struct country_info *country;	/* current country def */
-	char ccode[BRCM_CNTRY_BUF_SZ];	/* current internal Country Code */
 	uint regrev;		/* current Regulatory Revision */
 	char country_abbrev[BRCM_CNTRY_BUF_SZ];	/* current advertised ccode */
 	/* per-band state (one per phy/radio) */
@@ -171,14 +155,10 @@ struct brcms_cm_info {
 /* locale channel and power info. */
 struct locale_info {
 	u32 valid_channels;
-	/* List of radar sensitive channels */
-	u8 radar_channels;
 	/* List of channels used only if APs are detected */
 	u8 restricted_channels;
 	/* Max tx pwr in qdBm for each sub-band */
 	s8 maxpwr[BRCMS_MAXPWR_TBL_SIZE];
-	/* Country IE advertised max tx pwr in dBm per sub-band */
-	s8 pub_maxpwr[BAND_5G_PWR_LVLS];
 	u8 flags;
 };
 
@@ -196,46 +176,10 @@ static const struct brcms_chanvec chanvec_none = {
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-/* All 2.4 GHz HW channels */
-static const struct brcms_chanvec chanvec_all_2G = {
-	{0xfe, 0x7f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/* All 5 GHz HW channels */
-static const struct brcms_chanvec chanvec_all_5G = {
-	{0x00, 0x00, 0x00, 0x00, 0x54, 0x55, 0x11, 0x11,
-	 0x01, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x11,
-	 0x11, 0x11, 0x20, 0x22, 0x22, 0x00, 0x00, 0x11,
-	 0x11, 0x11, 0x11, 0x01}
-};
-
-/*
- * Radar channel sets
- */
-
-/* Channels 52 - 64, 100 - 140 */
-static const struct brcms_chanvec radar_set1 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x11,  /* 52 - 60 */
-	 0x01, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x11,  /* 64, 100 - 124 */
-	 0x11, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  /* 128 - 140 */
-	 0x00, 0x00, 0x00, 0x00}
-};
-
 /*
  * Restricted channel sets
  */
 
-/* Channels 34, 38, 42, 46 */
-static const struct brcms_chanvec restricted_set_japan_legacy = {
-	{0x00, 0x00, 0x00, 0x00, 0x44, 0x44, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
 /* Channels 12, 13 */
 static const struct brcms_chanvec restricted_set_2g_short = {
 	{0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -244,47 +188,11 @@ static const struct brcms_chanvec restricted_set_2g_short = {
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-/* Channel 165 */
-static const struct brcms_chanvec restricted_chan_165 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/* Channels 36 - 48 & 149 - 165 */
-static const struct brcms_chanvec restricted_low_hi = {
-	{0x00, 0x00, 0x00, 0x00, 0x10, 0x11, 0x01, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x20, 0x22, 0x22, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/* Channels 12 - 14 */
-static const struct brcms_chanvec restricted_set_12_13_14 = {
-	{0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
 /* global memory to provide working buffer for expanded locale */
 
-static const struct brcms_chanvec *g_table_radar_set[] = {
-	&chanvec_none,
-	&radar_set1
-};
-
 static const struct brcms_chanvec *g_table_restricted_chan[] = {
 	&chanvec_none,		/* restricted_set_none */
 	&restricted_set_2g_short,
-	&restricted_chan_165,
-	&chanvec_all_5G,
-	&restricted_set_japan_legacy,
-	&chanvec_all_2G,	/* restricted_set_11d_2G */
-	&chanvec_all_5G,	/* restricted_set_11d_5G */
-	&restricted_low_hi,
-	&restricted_set_12_13_14
 };
 
 static const struct brcms_chanvec locale_2g_01_11 = {
@@ -445,11 +353,9 @@ static void brcms_c_locale_get_channels(const struct locale_info *locale,
  */
 static const struct locale_info locale_i = {	/* locale i. channel 1 - 13 */
 	LOCALE_CHAN_01_11 | LOCALE_CHAN_12_13,
-	LOCALE_RADAR_SET_NONE,
 	LOCALE_RESTRICTED_SET_2G_SHORT,
 	{QDB(19), QDB(19), QDB(19),
 	 QDB(19), QDB(19), QDB(19)},
-	{20, 20, 20, 0},
 	BRCMS_EIRP
 };
 
@@ -459,10 +365,8 @@ static const struct locale_info locale_i = {	/* locale i. channel 1 - 13 */
 static const struct locale_info locale_11 = {
 	/* locale 11. channel 36 - 48, 52 - 64, 100 - 140, 149 - 165 */
 	LOCALE_CHAN_36_64 | LOCALE_CHAN_100_140 | LOCALE_CHAN_149_165,
-	LOCALE_RADAR_SET_1,
 	LOCALE_RESTRICTED_NONE,
 	{QDB(21), QDB(21), QDB(21), QDB(21), QDB(21)},
-	{23, 23, 23, 30, 30},
 	BRCMS_EIRP | BRCMS_DFS_EU
 };
 
@@ -512,83 +416,6 @@ static const struct {
 	"X2", LOCALES(i, 11, bn, 11n)},	/* Worldwide RoW 2 */
 };
 
-#ifdef SUPPORT_40MHZ
-/* 20MHz channel info for 40MHz pairing support */
-struct chan20_info {
-	u8 sb;
-	u8 adj_sbs;
-};
-
-/* indicates adjacent channels that are allowed for a 40 Mhz channel and
- * those that permitted by the HT
- */
-struct chan20_info chan20_info[] = {
-	/* 11b/11g */
-/* 0 */ {1, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 1 */ {2, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 2 */ {3, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 3 */ {4, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 4 */ {5, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 5 */ {6, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 6 */ {7, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 7 */ {8, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 8 */ {9, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 9 */ {10, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 10 */ {11, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 11 */ {12, (CH_LOWER_SB)},
-/* 12 */ {13, (CH_LOWER_SB)},
-/* 13 */ {14, (CH_LOWER_SB)},
-
-/* 11a japan high */
-/* 14 */ {34, (CH_UPPER_SB)},
-/* 15 */ {38, (CH_LOWER_SB)},
-/* 16 */ {42, (CH_LOWER_SB)},
-/* 17 */ {46, (CH_LOWER_SB)},
-
-/* 11a usa low */
-/* 18 */ {36, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 19 */ {40, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 20 */ {44, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 21 */ {48, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 22 */ {52, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 23 */ {56, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 24 */ {60, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 25 */ {64, (CH_LOWER_SB | CH_EWA_VALID)},
-
-/* 11a Europe */
-/* 26 */ {100, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 27 */ {104, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 28 */ {108, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 29 */ {112, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 30 */ {116, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 31 */ {120, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 32 */ {124, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 33 */ {128, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 34 */ {132, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 35 */ {136, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 36 */ {140, (CH_LOWER_SB)},
-
-/* 11a usa high, ref5 only */
-/* The 0x80 bit in pdiv means these are REF5, other entries are REF20 */
-/* 37 */ {149, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 38 */ {153, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 39 */ {157, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 40 */ {161, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 41 */ {165, (CH_LOWER_SB)},
-
-/* 11a japan */
-/* 42 */ {184, (CH_UPPER_SB)},
-/* 43 */ {188, (CH_LOWER_SB)},
-/* 44 */ {192, (CH_UPPER_SB)},
-/* 45 */ {196, (CH_LOWER_SB)},
-/* 46 */ {200, (CH_UPPER_SB)},
-/* 47 */ {204, (CH_LOWER_SB)},
-/* 48 */ {208, (CH_UPPER_SB)},
-/* 49 */ {212, (CH_LOWER_SB)},
-/* 50 */ {216, (CH_LOWER_SB)}
-};
-#endif				/* SUPPORT_40MHZ */
-
 static const struct locale_info *brcms_c_get_locale_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_2g_table))
@@ -621,13 +448,6 @@ static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx)
 	return g_mimo_5g_table[locale_idx];
 }
 
-static int
-brcms_c_country_aggregate_map(struct brcms_cm_info *wlc_cm, const char *ccode,
-			  char *mapped_ccode, uint *mapped_regrev)
-{
-	return false;
-}
-
 /*
  * Indicates whether the country provided is valid to pass
  * to cfg80211 or not.
@@ -697,7 +517,6 @@ brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm, const char *ccode,
 	const struct country_info *country;
 	uint srom_regrev = wlc_cm->srom_regrev;
 	const char *srom_ccode = wlc_cm->srom_ccode;
-	int mapped;
 
 	/* check for currently supported ccode size */
 	if (strlen(ccode) > (BRCM_CNTRY_BUF_SZ - 1)) {
@@ -716,12 +535,7 @@ brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm, const char *ccode,
 	 */
 	if (!strcmp(srom_ccode, ccode)) {
 		*mapped_regrev = srom_regrev;
-		mapped = 0;
 		wiphy_err(wlc->wiphy, "srom_code == ccode %s\n", __func__);
-	} else {
-		mapped =
-		    brcms_c_country_aggregate_map(wlc_cm, ccode, mapped_ccode,
-					      mapped_regrev);
 	}
 
 	/* find the matching built-in country definition */
@@ -979,8 +793,6 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 
 		wlc_cm->bandstate[band->bandunit].restricted_channels =
 		    g_table_restricted_chan[li->restricted_channels];
-		wlc_cm->bandstate[band->bandunit].radar_channels =
-		    g_table_radar_set[li->radar_channels];
 
 		/*
 		 * set the channel availability, masking out the channels
@@ -1015,17 +827,11 @@ brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
 {
 	const struct locale_info *locale;
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	char prev_country_abbrev[BRCM_CNTRY_BUF_SZ];
 
 	/* save current country state */
 	wlc_cm->country = country;
 
-	memset(&prev_country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
-	strncpy(prev_country_abbrev, wlc_cm->country_abbrev,
-		BRCM_CNTRY_BUF_SZ - 1);
-
 	strncpy(wlc_cm->country_abbrev, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
-	strncpy(wlc_cm->ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
 	wlc_cm->regrev = regrev;
 
 	if ((wlc->pub->_n_enab & SUPPORT_11N) !=
@@ -1091,16 +897,12 @@ brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
 static int
 brcms_c_set_countrycode(struct brcms_cm_info *wlc_cm, const char *ccode)
 {
-	char country_abbrev[BRCM_CNTRY_BUF_SZ];
-	strncpy(country_abbrev, ccode, BRCM_CNTRY_BUF_SZ);
-	return brcms_c_set_countrycode_rev(wlc_cm, country_abbrev, ccode, -1);
+	return brcms_c_set_countrycode_rev(wlc_cm, ccode, ccode, -1);
 }
 
 struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 {
 	struct brcms_cm_info *wlc_cm;
-	char country_abbrev[BRCM_CNTRY_BUF_SZ];
-	const struct country_info *country;
 	struct brcms_pub *pub = wlc->pub;
 	char *ccode;
 
@@ -1118,21 +920,14 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 	if (ccode && brcms_c_country_valid(ccode))
 		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
 
-	/*
-	 * internal country information which must match
-	 * regulatory constraints in firmware
-	 */
-	memset(country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
-	strncpy(country_abbrev, "X2", sizeof(country_abbrev) - 1);
-	country = brcms_c_country_lookup(wlc, country_abbrev);
-
 	/* save default country for exiting 11d regulatory mode */
-	strncpy(wlc->country_default, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
+	strncpy(wlc->country_default, "X2", BRCM_CNTRY_BUF_SZ - 1);
 
 	/* initialize autocountry_default to driver default */
-	strncpy(wlc->autocountry_default, "X2", BRCM_CNTRY_BUF_SZ - 1);
+	strncpy(wlc->autocountry_default, wlc->country_default,
+		BRCM_CNTRY_BUF_SZ - 1);
 
-	brcms_c_set_countrycode(wlc_cm, country_abbrev);
+	brcms_c_set_countrycode(wlc_cm, wlc->country_default);
 
 	return wlc_cm;
 }
@@ -1450,45 +1245,6 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
 			return brcms_c_valid_channel20(wlc_cm->wlc->cmi,
 						       channel);
 	}
-#ifdef SUPPORT_40MHZ
-	/*
-	 * We know we are now checking a 40MHZ channel, so we should
-	 * only be here for NPHYS
-	 */
-	if (BRCMS_ISNPHY(wlc->band) || BRCMS_ISSSLPNPHY(wlc->band)) {
-		u8 upper_sideband = 0, idx;
-		u8 num_ch20_entries =
-		    sizeof(chan20_info) / sizeof(struct chan20_info);
-
-		if (!VALID_40CHANSPEC_IN_BAND(wlc, chspec_bandunit(chspec)))
-			return false;
-
-		if (dualband) {
-			if (!brcms_c_valid_channel20_db(wlc->cmi,
-							lower_20_sb(channel)) ||
-			    !brcms_c_valid_channel20_db(wlc->cmi,
-							upper_20_sb(channel)))
-				return false;
-		} else {
-			if (!brcms_c_valid_channel20(wlc->cmi,
-						     lower_20_sb(channel)) ||
-			    !brcms_c_valid_channel20(wlc->cmi,
-						     upper_20_sb(channel)))
-				return false;
-		}
-
-		/* find the lower sideband info in the sideband array */
-		for (idx = 0; idx < num_ch20_entries; idx++) {
-			if (chan20_info[idx].sb == lower_20_sb(channel))
-				upper_sideband = chan20_info[idx].adj_sbs;
-		}
-		/* check that the lower sideband allows an upper sideband */
-		if ((upper_sideband & (CH_UPPER_SB | CH_EWA_VALID)) ==
-		    (CH_UPPER_SB | CH_EWA_VALID))
-			return true;
-		return false;
-	}
-#endif				/* 40 MHZ */
 
 	return false;
 }
-- 
1.7.9.5


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53575 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab2FEOeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 10:34:36 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 4/9] brcm80211: smac: clean up channel.c
Date: Tue,  5 Jun 2012 09:34:04 -0500
Message-Id: <1338906849-26135-5-git-send-email-seth.forshee@canonical.com> (sfid-20120605_163440_446351_B519BBC8)
In-Reply-To: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Much of the code is either unsed or never put to any useful purpose.
Remove this code in advance of reworking the driver's regulatory
support.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |  138 +--------------------
 1 file changed, 5 insertions(+), 133 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 089cc87..c311ef7 100644
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
 
@@ -544,13 +448,6 @@ static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx)
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
@@ -620,7 +517,6 @@ brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm, const char *ccode,
 	const struct country_info *country;
 	uint srom_regrev = wlc_cm->srom_regrev;
 	const char *srom_ccode = wlc_cm->srom_ccode;
-	int mapped;
 
 	/* check for currently supported ccode size */
 	if (strlen(ccode) > (BRCM_CNTRY_BUF_SZ - 1)) {
@@ -639,12 +535,7 @@ brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm, const char *ccode,
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
@@ -902,8 +793,6 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 
 		wlc_cm->bandstate[band->bandunit].restricted_channels =
 		    g_table_restricted_chan[li->restricted_channels];
-		wlc_cm->bandstate[band->bandunit].radar_channels =
-		    g_table_radar_set[li->radar_channels];
 
 		/*
 		 * set the channel availability, masking out the channels
@@ -938,17 +827,11 @@ brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
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
@@ -1014,16 +897,12 @@ brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
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
 	struct ssb_sprom *sprom = &wlc->hw->d11core->bus->sprom;
 
@@ -1040,21 +919,14 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 	if (sprom->alpha2 && brcms_c_country_valid(sprom->alpha2))
 		strncpy(wlc->pub->srom_ccode, sprom->alpha2, sizeof(sprom->alpha2));
 
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
-- 
1.7.9.5


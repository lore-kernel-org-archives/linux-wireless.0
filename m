Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1182 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/30] staging: brcm80211: removed static function
 declarations in channel.c
Date: Thu, 1 Sep 2011 11:16:55 +0200
Message-ID: <1314868640-9425-6-git-send-email-rvossen@broadcom.com> (sfid-20110901_111757_045737_B4EABC9F)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/channel.c |  881 ++++++++++++--------------
 1 files changed, 416 insertions(+), 465 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 89d8fa7..6c5272e 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -29,6 +29,53 @@
 	brcms_c_valid_channel20_in_band((wlc)->cmi, bandunit, val)
 #define	VALID_CHANNEL20(wlc, val) brcms_c_valid_channel20((wlc)->cmi, val)
 
+/* QDB() macro takes a dB value and converts to a quarter dB value */
+#define QDB(n) ((n) * BRCMS_TXPWR_DB_FACTOR)
+
+#define  LOCALE_CHAN_01_11	 (1<<0)
+#define  LOCALE_CHAN_12_13	 (1<<1)
+#define  LOCALE_CHAN_14		 (1<<2)
+#define  LOCALE_SET_5G_LOW_JP1   (1<<3)	/* 34-48, step 2 */
+#define  LOCALE_SET_5G_LOW_JP2   (1<<4)	/* 34-46, step 4 */
+#define  LOCALE_SET_5G_LOW1      (1<<5)	/* 36-48, step 4 */
+#define  LOCALE_SET_5G_LOW2      (1<<6)	/* 52 */
+#define  LOCALE_SET_5G_LOW3      (1<<7)	/* 56-64, step 4 */
+#define  LOCALE_SET_5G_MID1      (1<<8)	/* 100-116, step 4 */
+#define  LOCALE_SET_5G_MID2	 (1<<9)	/* 120-124, step 4 */
+#define  LOCALE_SET_5G_MID3      (1<<10)	/* 128 */
+#define  LOCALE_SET_5G_HIGH1     (1<<11)	/* 132-140, step 4 */
+#define  LOCALE_SET_5G_HIGH2     (1<<12)	/* 149-161, step 4 */
+#define  LOCALE_SET_5G_HIGH3     (1<<13)	/* 165 */
+#define  LOCALE_CHAN_52_140_ALL  (1<<14)
+#define  LOCALE_SET_5G_HIGH4     (1<<15)	/* 184-216 */
+
+#define  LOCALE_CHAN_36_64	(LOCALE_SET_5G_LOW1 | \
+				 LOCALE_SET_5G_LOW2 | \
+				 LOCALE_SET_5G_LOW3)
+#define  LOCALE_CHAN_52_64	(LOCALE_SET_5G_LOW2 | LOCALE_SET_5G_LOW3)
+#define  LOCALE_CHAN_100_124	(LOCALE_SET_5G_MID1 | LOCALE_SET_5G_MID2)
+#define  LOCALE_CHAN_100_140	(LOCALE_SET_5G_MID1 | LOCALE_SET_5G_MID2 | \
+				  LOCALE_SET_5G_MID3 | LOCALE_SET_5G_HIGH1)
+#define  LOCALE_CHAN_149_165	(LOCALE_SET_5G_HIGH2 | LOCALE_SET_5G_HIGH3)
+#define  LOCALE_CHAN_184_216	LOCALE_SET_5G_HIGH4
+
+#define  LOCALE_CHAN_01_14	(LOCALE_CHAN_01_11 | \
+				 LOCALE_CHAN_12_13 | \
+				 LOCALE_CHAN_14)
+
+#define  LOCALE_RADAR_SET_NONE		  0
+#define  LOCALE_RADAR_SET_1		  1
+
+#define  LOCALE_RESTRICTED_NONE		  0
+#define  LOCALE_RESTRICTED_SET_2G_SHORT   1
+#define  LOCALE_RESTRICTED_CHAN_165       2
+#define  LOCALE_CHAN_ALL_5G		  3
+#define  LOCALE_RESTRICTED_JAPAN_LEGACY   4
+#define  LOCALE_RESTRICTED_11D_2G	  5
+#define  LOCALE_RESTRICTED_11D_5G	  6
+#define  LOCALE_RESTRICTED_LOW_HI	  7
+#define  LOCALE_RESTRICTED_12_13_14	  8
+
 struct brcms_cm_band {
 	/* struct locale_info flags */
 	u8 locale_flags;
@@ -57,58 +104,6 @@ struct brcms_cm_info {
 	struct brcms_chanvec quiet_channels;
 };
 
-static int brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
-			     const struct country_info *country);
-static void brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
-				   const char *country_abbrev,
-				   const char *ccode, uint regrev,
-				   const struct country_info *country);
-static int brcms_c_set_countrycode(struct brcms_cm_info *wlc_cm,
-				   const char *ccode);
-static int brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
-				   const char *country_abbrev,
-				   const char *ccode, int regrev);
-static int brcms_c_country_aggregate_map(struct brcms_cm_info *wlc_cm,
-				const char *ccode,
-				char *mapped_ccode, uint *mapped_regrev);
-
-static const struct country_info *
-brcms_c_country_lookup_direct(const char *ccode, uint regrev);
-
-static const struct country_info *
-brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm,
-			const char *ccode, char *mapped_ccode,
-			uint *mapped_regrev);
-
-static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm);
-static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm);
-static bool brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm,
-				   u16 chspec);
-static bool brcms_c_valid_channel20_db(struct brcms_cm_info *wlc_cm, uint val);
-static bool brcms_c_valid_channel20_in_band(struct brcms_cm_info *wlc_cm,
-					    uint bandunit, uint val);
-static bool brcms_c_valid_channel20(struct brcms_cm_info *wlc_cm, uint val);
-
-static const struct country_info *
-brcms_c_country_lookup(struct brcms_c_info *wlc, const char *ccode);
-
-static void brcms_c_locale_get_channels(const struct locale_info *locale,
-				    struct brcms_chanvec *valid_channels);
-static const struct locale_info *brcms_c_get_locale_2g(u8 locale_idx);
-static const struct locale_info *brcms_c_get_locale_5g(u8 locale_idx);
-static bool brcms_c_japan(struct brcms_c_info *wlc);
-static bool brcms_c_japan_ccode(const char *ccode);
-static void brcms_c_channel_min_txpower_limits_with_local_constraint(
-	struct brcms_cm_info *wlc_cm, struct txpwr_limits *txpwr,
-	u8 local_constraint_qdbm);
-static void brcms_c_locale_add_channels(struct brcms_chanvec *target,
-				    const struct brcms_chanvec *channels);
-static const struct locale_mimo_info *brcms_c_get_mimo_2g(u8 locale_idx);
-static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx);
-
-/* QDB() macro takes a dB value and converts to a quarter dB value */
-#define QDB(n) ((n) * BRCMS_TXPWR_DB_FACTOR)
-
 /* Regulatory Matrix Spreadsheet (CLM) MIMO v3.7.9 */
 
 /*
@@ -200,50 +195,6 @@ static const struct brcms_chanvec restricted_set_12_13_14 = {
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-#define  LOCALE_CHAN_01_11	 (1<<0)
-#define  LOCALE_CHAN_12_13	 (1<<1)
-#define  LOCALE_CHAN_14		 (1<<2)
-#define  LOCALE_SET_5G_LOW_JP1   (1<<3)	/* 34-48, step 2 */
-#define  LOCALE_SET_5G_LOW_JP2   (1<<4)	/* 34-46, step 4 */
-#define  LOCALE_SET_5G_LOW1      (1<<5)	/* 36-48, step 4 */
-#define  LOCALE_SET_5G_LOW2      (1<<6)	/* 52 */
-#define  LOCALE_SET_5G_LOW3      (1<<7)	/* 56-64, step 4 */
-#define  LOCALE_SET_5G_MID1      (1<<8)	/* 100-116, step 4 */
-#define  LOCALE_SET_5G_MID2	 (1<<9)	/* 120-124, step 4 */
-#define  LOCALE_SET_5G_MID3      (1<<10)	/* 128 */
-#define  LOCALE_SET_5G_HIGH1     (1<<11)	/* 132-140, step 4 */
-#define  LOCALE_SET_5G_HIGH2     (1<<12)	/* 149-161, step 4 */
-#define  LOCALE_SET_5G_HIGH3     (1<<13)	/* 165 */
-#define  LOCALE_CHAN_52_140_ALL  (1<<14)
-#define  LOCALE_SET_5G_HIGH4     (1<<15)	/* 184-216 */
-
-#define  LOCALE_CHAN_36_64	(LOCALE_SET_5G_LOW1 | \
-				 LOCALE_SET_5G_LOW2 | \
-				 LOCALE_SET_5G_LOW3)
-#define  LOCALE_CHAN_52_64	(LOCALE_SET_5G_LOW2 | LOCALE_SET_5G_LOW3)
-#define  LOCALE_CHAN_100_124	(LOCALE_SET_5G_MID1 | LOCALE_SET_5G_MID2)
-#define  LOCALE_CHAN_100_140	(LOCALE_SET_5G_MID1 | LOCALE_SET_5G_MID2 | \
-				  LOCALE_SET_5G_MID3 | LOCALE_SET_5G_HIGH1)
-#define  LOCALE_CHAN_149_165	(LOCALE_SET_5G_HIGH2 | LOCALE_SET_5G_HIGH3)
-#define  LOCALE_CHAN_184_216	LOCALE_SET_5G_HIGH4
-
-#define  LOCALE_CHAN_01_14	(LOCALE_CHAN_01_11 | \
-				 LOCALE_CHAN_12_13 | \
-				 LOCALE_CHAN_14)
-
-#define  LOCALE_RADAR_SET_NONE		  0
-#define  LOCALE_RADAR_SET_1		  1
-
-#define  LOCALE_RESTRICTED_NONE		  0
-#define  LOCALE_RESTRICTED_SET_2G_SHORT   1
-#define  LOCALE_RESTRICTED_CHAN_165       2
-#define  LOCALE_CHAN_ALL_5G		  3
-#define  LOCALE_RESTRICTED_JAPAN_LEGACY   4
-#define  LOCALE_RESTRICTED_11D_2G	  5
-#define  LOCALE_RESTRICTED_11D_5G	  6
-#define  LOCALE_RESTRICTED_LOW_HI	  7
-#define  LOCALE_RESTRICTED_12_13_14	  8
-
 /* global memory to provide working buffer for expanded locale */
 
 static const struct brcms_chanvec *g_table_radar_set[] = {
@@ -612,316 +563,249 @@ static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx)
 	return g_mimo_5g_table[locale_idx];
 }
 
-struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
+static int
+brcms_c_country_aggregate_map(struct brcms_cm_info *wlc_cm, const char *ccode,
+			  char *mapped_ccode, uint *mapped_regrev)
 {
-	struct brcms_cm_info *wlc_cm;
-	char country_abbrev[BRCM_CNTRY_BUF_SZ];
-	const struct country_info *country;
-	struct brcms_pub *pub = wlc->pub;
-	char *ccode;
-
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+	return false;
+}
 
-	wlc_cm = kzalloc(sizeof(struct brcms_cm_info), GFP_ATOMIC);
-	if (wlc_cm == NULL) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: out of memory", pub->unit,
-			  __func__);
-		return NULL;
-	}
-	wlc_cm->pub = pub;
-	wlc_cm->wlc = wlc;
-	wlc->cmi = wlc_cm;
+/* Lookup a country info structure from a null terminated country
+ * abbreviation and regrev directly with no translation.
+ */
+static const struct country_info *
+brcms_c_country_lookup_direct(const char *ccode, uint regrev)
+{
+	uint size, i;
 
-	/* store the country code for passing up as a regulatory hint */
-	ccode = getvar(wlc->pub->vars, "ccode");
-	if (ccode)
-		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
+	/* Should just return 0 for single locale driver. */
+	/* Keep it this way in case we add more locales. (for now anyway) */
 
 	/*
-	 * internal country information which must match
-	 * regulatory constraints in firmware
+	 * all other country def arrays are for regrev == 0, so if
+	 * regrev is non-zero, fail
 	 */
-	memset(country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
-	strncpy(country_abbrev, "X2", sizeof(country_abbrev) - 1);
-	country = brcms_c_country_lookup(wlc, country_abbrev);
+	if (regrev > 0)
+		return NULL;
 
-	/* save default country for exiting 11d regulatory mode */
-	strncpy(wlc->country_default, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
+	/* find matched table entry from country code */
+	size = ARRAY_SIZE(cntry_locales);
+	for (i = 0; i < size; i++) {
+		if (strcmp(ccode, cntry_locales[i].abbrev) == 0)
+			return &cntry_locales[i].country;
+	}
+	return NULL;
+}
 
-	/* initialize autocountry_default to driver default */
-	strncpy(wlc->autocountry_default, "X2", BRCM_CNTRY_BUF_SZ - 1);
+static const struct country_info *
+brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm, const char *ccode,
+			char *mapped_ccode, uint *mapped_regrev)
+{
+	struct brcms_c_info *wlc = wlc_cm->wlc;
+	const struct country_info *country;
+	uint srom_regrev = wlc_cm->srom_regrev;
+	const char *srom_ccode = wlc_cm->srom_ccode;
+	int mapped;
 
-	brcms_c_set_countrycode(wlc_cm, country_abbrev);
+	/* check for currently supported ccode size */
+	if (strlen(ccode) > (BRCM_CNTRY_BUF_SZ - 1)) {
+		wiphy_err(wlc->wiphy, "wl%d: %s: ccode \"%s\" too long for "
+			  "match\n", wlc->pub->unit, __func__, ccode);
+		return NULL;
+	}
 
-	return wlc_cm;
-}
+	/* default mapping is the given ccode and regrev 0 */
+	strncpy(mapped_ccode, ccode, BRCM_CNTRY_BUF_SZ);
+	*mapped_regrev = 0;
 
-void brcms_c_channel_mgr_detach(struct brcms_cm_info *wlc_cm)
-{
-	kfree(wlc_cm);
-}
+	/* If the desired country code matches the srom country code,
+	 * then the mapped country is the srom regulatory rev.
+	 * Otherwise look for an aggregate mapping.
+	 */
+	if (!strcmp(srom_ccode, ccode)) {
+		*mapped_regrev = srom_regrev;
+		mapped = 0;
+		wiphy_err(wlc->wiphy, "srom_code == ccode %s\n", __func__);
+	} else {
+		mapped =
+		    brcms_c_country_aggregate_map(wlc_cm, ccode, mapped_ccode,
+					      mapped_regrev);
+	}
 
-u8
-brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
-				     uint bandunit)
-{
-	return wlc_cm->bandstate[bandunit].locale_flags;
-}
+	/* find the matching built-in country definition */
+	country = brcms_c_country_lookup_direct(mapped_ccode, *mapped_regrev);
 
-/*
- * set the driver's current country and regulatory information using
- * a country code as the source. Lookup built in country information
- * found with the country code.
- */
-static int
-brcms_c_set_countrycode(struct brcms_cm_info *wlc_cm, const char *ccode)
-{
-	char country_abbrev[BRCM_CNTRY_BUF_SZ];
-	strncpy(country_abbrev, ccode, BRCM_CNTRY_BUF_SZ);
-	return brcms_c_set_countrycode_rev(wlc_cm, country_abbrev, ccode, -1);
+	/* if there is not an exact rev match, default to rev zero */
+	if (country == NULL && *mapped_regrev != 0) {
+		*mapped_regrev = 0;
+		country =
+		    brcms_c_country_lookup_direct(mapped_ccode, *mapped_regrev);
+	}
+
+	return country;
 }
 
-static int
-brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
-			const char *country_abbrev,
-			const char *ccode, int regrev)
+/* Lookup a country info structure from a null terminated country code
+ * The lookup is case sensitive.
+ */
+static const struct country_info *
+brcms_c_country_lookup(struct brcms_c_info *wlc, const char *ccode)
 {
 	const struct country_info *country;
 	char mapped_ccode[BRCM_CNTRY_BUF_SZ];
 	uint mapped_regrev;
 
-	/* if regrev is -1, lookup the mapped country code,
-	 * otherwise use the ccode and regrev directly
+	/*
+	 * map the country code to a built-in country code, regrev, and
+	 * country_info struct
 	 */
-	if (regrev == -1) {
-		/*
-		 * map the country code to a built-in country
-		 * code, regrev, and country_info
-		 */
-		country =
-		    brcms_c_countrycode_map(wlc_cm, ccode, mapped_ccode,
-					&mapped_regrev);
-	} else {
-		/* find the matching built-in country definition */
-		country = brcms_c_country_lookup_direct(ccode, regrev);
-		strncpy(mapped_ccode, ccode, BRCM_CNTRY_BUF_SZ);
-		mapped_regrev = regrev;
-	}
+	country = brcms_c_countrycode_map(wlc->cmi, ccode, mapped_ccode,
+					  &mapped_regrev);
 
-	if (country == NULL)
-		return -EINVAL;
-
-	/* set the driver state for the country */
-	brcms_c_set_country_common(wlc_cm, country_abbrev, mapped_ccode,
-			       mapped_regrev, country);
-
-	return 0;
+	return country;
 }
 
 /*
- * set the driver's current country and regulatory information
- * using a country code as the source. Look up built in country
- * information found with the country code.
+ * reset the quiet channels vector to the union
+ * of the restricted and radar channel sets
  */
-static void
-brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
-		       const char *country_abbrev,
-		       const char *ccode, uint regrev,
-		       const struct country_info *country)
+static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm)
 {
-	const struct locale_mimo_info *li_mimo;
-	const struct locale_info *locale;
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	char prev_country_abbrev[BRCM_CNTRY_BUF_SZ];
+	uint i, j;
+	struct brcms_band *band;
+	const struct brcms_chanvec *chanvec;
 
-	/* save current country state */
-	wlc_cm->country = country;
+	memset(&wlc_cm->quiet_channels, 0, sizeof(struct brcms_chanvec));
 
-	memset(&prev_country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
-	strncpy(prev_country_abbrev, wlc_cm->country_abbrev,
-		BRCM_CNTRY_BUF_SZ - 1);
+	band = wlc->band;
+	for (i = 0; i < NBANDS(wlc);
+	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
 
-	strncpy(wlc_cm->country_abbrev, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
-	strncpy(wlc_cm->ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
-	wlc_cm->regrev = regrev;
+		/* initialize quiet channels for restricted channels */
+		chanvec = wlc_cm->bandstate[band->bandunit].restricted_channels;
+		for (j = 0; j < sizeof(struct brcms_chanvec); j++)
+			wlc_cm->quiet_channels.vec[j] |= chanvec->vec[j];
 
-	/* disable/restore nmode based on country regulations */
-	li_mimo = brcms_c_get_mimo_2g(country->locale_mimo_2G);
-	if (li_mimo && (li_mimo->flags & BRCMS_NO_MIMO)) {
-		brcms_c_set_nmode(wlc, OFF);
-		wlc->stf->no_cddstbc = true;
-	} else {
-		wlc->stf->no_cddstbc = false;
-		if (N_ENAB(wlc->pub) != wlc->protection->nmode_user)
-			brcms_c_set_nmode(wlc, wlc->protection->nmode_user);
 	}
-
-	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
-	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
-	/* set or restore gmode as required by regulatory */
-	locale = brcms_c_get_locale_2g(country->locale_2G);
-	if (locale && (locale->flags & BRCMS_NO_OFDM))
-		brcms_c_set_gmode(wlc, GMODE_LEGACY_B, false);
-	else
-		brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
-
-	brcms_c_channels_init(wlc_cm, country);
-
-	return;
 }
 
-/* Lookup a country info structure from a null terminated country code
- * The lookup is case sensitive.
- */
-static const struct country_info *
-brcms_c_country_lookup(struct brcms_c_info *wlc, const char *ccode)
+/* Is the channel valid for the current locale and current band? */
+static bool brcms_c_valid_channel20(struct brcms_cm_info *wlc_cm, uint val)
 {
-	const struct country_info *country;
-	char mapped_ccode[BRCM_CNTRY_BUF_SZ];
-	uint mapped_regrev;
+	struct brcms_c_info *wlc = wlc_cm->wlc;
 
-	/*
-	 * map the country code to a built-in country code, regrev, and
-	 * country_info struct
-	 */
-	country = brcms_c_countrycode_map(wlc->cmi, ccode, mapped_ccode,
-					  &mapped_regrev);
+	return ((val < MAXCHANNEL) &&
+		isset(wlc_cm->bandstate[wlc->band->bandunit].valid_channels.vec,
+		      val));
+}
 
-	return country;
+/* Is the channel valid for the current locale and specified band? */
+static bool brcms_c_valid_channel20_in_band(struct brcms_cm_info *wlc_cm,
+					    uint bandunit, uint val)
+{
+	return ((val < MAXCHANNEL)
+		&& isset(wlc_cm->bandstate[bandunit].valid_channels.vec, val));
 }
 
-static const struct country_info *
-brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm, const char *ccode,
-			char *mapped_ccode, uint *mapped_regrev)
+/* Is the channel valid for the current locale? (but don't consider channels not
+ *   available due to bandlocking)
+ */
+static bool brcms_c_valid_channel20_db(struct brcms_cm_info *wlc_cm, uint val)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	const struct country_info *country;
-	uint srom_regrev = wlc_cm->srom_regrev;
-	const char *srom_ccode = wlc_cm->srom_ccode;
-	int mapped;
-
-	/* check for currently supported ccode size */
-	if (strlen(ccode) > (BRCM_CNTRY_BUF_SZ - 1)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: ccode \"%s\" too long for "
-			  "match\n", wlc->pub->unit, __func__, ccode);
-		return NULL;
-	}
 
-	/* default mapping is the given ccode and regrev 0 */
-	strncpy(mapped_ccode, ccode, BRCM_CNTRY_BUF_SZ);
-	*mapped_regrev = 0;
-
-	/* If the desired country code matches the srom country code,
-	 * then the mapped country is the srom regulatory rev.
-	 * Otherwise look for an aggregate mapping.
-	 */
-	if (!strcmp(srom_ccode, ccode)) {
-		*mapped_regrev = srom_regrev;
-		mapped = 0;
-		wiphy_err(wlc->wiphy, "srom_code == ccode %s\n", __func__);
-	} else {
-		mapped =
-		    brcms_c_country_aggregate_map(wlc_cm, ccode, mapped_ccode,
-					      mapped_regrev);
-	}
-
-	/* find the matching built-in country definition */
-	country = brcms_c_country_lookup_direct(mapped_ccode, *mapped_regrev);
-
-	/* if there is not an exact rev match, default to rev zero */
-	if (country == NULL && *mapped_regrev != 0) {
-		*mapped_regrev = 0;
-		country =
-		    brcms_c_country_lookup_direct(mapped_ccode, *mapped_regrev);
-	}
+	return VALID_CHANNEL20(wlc, val) ||
+		(!wlc->bandlocked
+		 && VALID_CHANNEL20_IN_BAND(wlc, OTHERBANDUNIT(wlc), val));
+}
 
-	return country;
+/* JP, J1 - J10 are Japan ccodes */
+static bool brcms_c_japan_ccode(const char *ccode)
+{
+	return (ccode[0] == 'J' &&
+		(ccode[1] == 'P' || (ccode[1] >= '1' && ccode[1] <= '9')));
 }
 
-static int
-brcms_c_country_aggregate_map(struct brcms_cm_info *wlc_cm, const char *ccode,
-			  char *mapped_ccode, uint *mapped_regrev)
+/* Returns true if currently set country is Japan or variant */
+static bool brcms_c_japan(struct brcms_c_info *wlc)
 {
-	return false;
+	return brcms_c_japan_ccode(wlc->cmi->country_abbrev);
 }
 
-/* Lookup a country info structure from a null terminated country
- * abbreviation and regrev directly with no translation.
- */
-static const struct country_info *
-brcms_c_country_lookup_direct(const char *ccode, uint regrev)
+static void
+brcms_c_channel_min_txpower_limits_with_local_constraint(
+		struct brcms_cm_info *wlc_cm, struct txpwr_limits *txpwr,
+		u8 local_constraint_qdbm)
 {
-	uint size, i;
+	int j;
 
-	/* Should just return 0 for single locale driver. */
-	/* Keep it this way in case we add more locales. (for now anyway) */
+	/* CCK Rates */
+	for (j = 0; j < WL_TX_POWER_CCK_NUM; j++)
+		txpwr->cck[j] = min(txpwr->cck[j], local_constraint_qdbm);
 
-	/*
-	 * all other country def arrays are for regrev == 0, so if
-	 * regrev is non-zero, fail
-	 */
-	if (regrev > 0)
-		return NULL;
+	/* 20 MHz Legacy OFDM SISO */
+	for (j = 0; j < WL_TX_POWER_OFDM_NUM; j++)
+		txpwr->ofdm[j] = min(txpwr->ofdm[j], local_constraint_qdbm);
 
-	/* find matched table entry from country code */
-	size = ARRAY_SIZE(cntry_locales);
-	for (i = 0; i < size; i++) {
-		if (strcmp(ccode, cntry_locales[i].abbrev) == 0)
-			return &cntry_locales[i].country;
-	}
-	return NULL;
-}
+	/* 20 MHz Legacy OFDM CDD */
+	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++)
+		txpwr->ofdm_cdd[j] =
+		    min(txpwr->ofdm_cdd[j], local_constraint_qdbm);
 
-static int
-brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
-		      const struct country_info *country)
-{
-	struct brcms_c_info *wlc = wlc_cm->wlc;
-	uint i, j;
-	struct brcms_band *band;
-	const struct locale_info *li;
-	struct brcms_chanvec sup_chan;
-	const struct locale_mimo_info *li_mimo;
+	/* 40 MHz Legacy OFDM SISO */
+	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++)
+		txpwr->ofdm_40_siso[j] =
+		    min(txpwr->ofdm_40_siso[j], local_constraint_qdbm);
 
-	band = wlc->band;
-	for (i = 0; i < NBANDS(wlc);
-	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
+	/* 40 MHz Legacy OFDM CDD */
+	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++)
+		txpwr->ofdm_40_cdd[j] =
+		    min(txpwr->ofdm_40_cdd[j], local_constraint_qdbm);
 
-		li = BAND_5G(band->bandtype) ?
-		    brcms_c_get_locale_5g(country->locale_5G) :
-		    brcms_c_get_locale_2g(country->locale_2G);
-		wlc_cm->bandstate[band->bandunit].locale_flags = li->flags;
-		li_mimo = BAND_5G(band->bandtype) ?
-		    brcms_c_get_mimo_5g(country->locale_mimo_5G) :
-		    brcms_c_get_mimo_2g(country->locale_mimo_2G);
+	/* 20MHz MCS 0-7 SISO */
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
+		txpwr->mcs_20_siso[j] =
+		    min(txpwr->mcs_20_siso[j], local_constraint_qdbm);
 
-		/* merge the mimo non-mimo locale flags */
-		wlc_cm->bandstate[band->bandunit].locale_flags |=
-		    li_mimo->flags;
+	/* 20MHz MCS 0-7 CDD */
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
+		txpwr->mcs_20_cdd[j] =
+		    min(txpwr->mcs_20_cdd[j], local_constraint_qdbm);
 
-		wlc_cm->bandstate[band->bandunit].restricted_channels =
-		    g_table_restricted_chan[li->restricted_channels];
-		wlc_cm->bandstate[band->bandunit].radar_channels =
-		    g_table_radar_set[li->radar_channels];
+	/* 20MHz MCS 0-7 STBC */
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
+		txpwr->mcs_20_stbc[j] =
+		    min(txpwr->mcs_20_stbc[j], local_constraint_qdbm);
 
-		/*
-		 * set the channel availability, masking out the channels
-		 * that may not be supported on this phy.
-		 */
-		wlc_phy_chanspec_band_validch(band->pi, band->bandtype,
-					      &sup_chan);
-		brcms_c_locale_get_channels(li,
-					&wlc_cm->bandstate[band->bandunit].
-					valid_channels);
-		for (j = 0; j < sizeof(struct brcms_chanvec); j++)
-			wlc_cm->bandstate[band->bandunit].valid_channels.
-			    vec[j] &= sup_chan.vec[j];
-	}
+	/* 20MHz MCS 8-15 MIMO */
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_2_STREAM; j++)
+		txpwr->mcs_20_mimo[j] =
+		    min(txpwr->mcs_20_mimo[j], local_constraint_qdbm);
 
-	brcms_c_quiet_channels_reset(wlc_cm);
-	brcms_c_channels_commit(wlc_cm);
+	/* 40MHz MCS 0-7 SISO */
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
+		txpwr->mcs_40_siso[j] =
+		    min(txpwr->mcs_40_siso[j], local_constraint_qdbm);
+
+	/* 40MHz MCS 0-7 CDD */
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
+		txpwr->mcs_40_cdd[j] =
+		    min(txpwr->mcs_40_cdd[j], local_constraint_qdbm);
+
+	/* 40MHz MCS 0-7 STBC */
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
+		txpwr->mcs_40_stbc[j] =
+		    min(txpwr->mcs_40_stbc[j], local_constraint_qdbm);
+
+	/* 40MHz MCS 8-15 MIMO */
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_2_STREAM; j++)
+		txpwr->mcs_40_mimo[j] =
+		    min(txpwr->mcs_40_mimo[j], local_constraint_qdbm);
+
+	/* 40MHz MCS 32 */
+	txpwr->mcs32 = min(txpwr->mcs32, local_constraint_qdbm);
 
-	return 0;
 }
 
 /* Update the radio state (enable/disable) and tx power targets
@@ -981,145 +865,225 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 	}
 }
 
+static int
+brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
+		      const struct country_info *country)
+{
+	struct brcms_c_info *wlc = wlc_cm->wlc;
+	uint i, j;
+	struct brcms_band *band;
+	const struct locale_info *li;
+	struct brcms_chanvec sup_chan;
+	const struct locale_mimo_info *li_mimo;
+
+	band = wlc->band;
+	for (i = 0; i < NBANDS(wlc);
+	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
+
+		li = BAND_5G(band->bandtype) ?
+		    brcms_c_get_locale_5g(country->locale_5G) :
+		    brcms_c_get_locale_2g(country->locale_2G);
+		wlc_cm->bandstate[band->bandunit].locale_flags = li->flags;
+		li_mimo = BAND_5G(band->bandtype) ?
+		    brcms_c_get_mimo_5g(country->locale_mimo_5G) :
+		    brcms_c_get_mimo_2g(country->locale_mimo_2G);
+
+		/* merge the mimo non-mimo locale flags */
+		wlc_cm->bandstate[band->bandunit].locale_flags |=
+		    li_mimo->flags;
+
+		wlc_cm->bandstate[band->bandunit].restricted_channels =
+		    g_table_restricted_chan[li->restricted_channels];
+		wlc_cm->bandstate[band->bandunit].radar_channels =
+		    g_table_radar_set[li->radar_channels];
+
+		/*
+		 * set the channel availability, masking out the channels
+		 * that may not be supported on this phy.
+		 */
+		wlc_phy_chanspec_band_validch(band->pi, band->bandtype,
+					      &sup_chan);
+		brcms_c_locale_get_channels(li,
+					&wlc_cm->bandstate[band->bandunit].
+					valid_channels);
+		for (j = 0; j < sizeof(struct brcms_chanvec); j++)
+			wlc_cm->bandstate[band->bandunit].valid_channels.
+			    vec[j] &= sup_chan.vec[j];
+	}
+
+	brcms_c_quiet_channels_reset(wlc_cm);
+	brcms_c_channels_commit(wlc_cm);
+
+	return 0;
+}
+
 /*
- * reset the quiet channels vector to the union
- * of the restricted and radar channel sets
+ * set the driver's current country and regulatory information
+ * using a country code as the source. Look up built in country
+ * information found with the country code.
  */
-static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm)
+static void
+brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
+		       const char *country_abbrev,
+		       const char *ccode, uint regrev,
+		       const struct country_info *country)
 {
+	const struct locale_mimo_info *li_mimo;
+	const struct locale_info *locale;
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	uint i, j;
-	struct brcms_band *band;
-	const struct brcms_chanvec *chanvec;
+	char prev_country_abbrev[BRCM_CNTRY_BUF_SZ];
 
-	memset(&wlc_cm->quiet_channels, 0, sizeof(struct brcms_chanvec));
+	/* save current country state */
+	wlc_cm->country = country;
 
-	band = wlc->band;
-	for (i = 0; i < NBANDS(wlc);
-	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
+	memset(&prev_country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
+	strncpy(prev_country_abbrev, wlc_cm->country_abbrev,
+		BRCM_CNTRY_BUF_SZ - 1);
 
-		/* initialize quiet channels for restricted channels */
-		chanvec = wlc_cm->bandstate[band->bandunit].restricted_channels;
-		for (j = 0; j < sizeof(struct brcms_chanvec); j++)
-			wlc_cm->quiet_channels.vec[j] |= chanvec->vec[j];
+	strncpy(wlc_cm->country_abbrev, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
+	strncpy(wlc_cm->ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
+	wlc_cm->regrev = regrev;
 
+	/* disable/restore nmode based on country regulations */
+	li_mimo = brcms_c_get_mimo_2g(country->locale_mimo_2G);
+	if (li_mimo && (li_mimo->flags & BRCMS_NO_MIMO)) {
+		brcms_c_set_nmode(wlc, OFF);
+		wlc->stf->no_cddstbc = true;
+	} else {
+		wlc->stf->no_cddstbc = false;
+		if (N_ENAB(wlc->pub) != wlc->protection->nmode_user)
+			brcms_c_set_nmode(wlc, wlc->protection->nmode_user);
 	}
-}
-
-static bool
-brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm, u16 chspec)
-{
-	return N_ENAB(wlc_cm->wlc->pub) && CHSPEC_IS40(chspec) ?
-		(isset(wlc_cm->quiet_channels.vec,
-		       LOWER_20_SB(CHSPEC_CHANNEL(chspec))) ||
-		 isset(wlc_cm->quiet_channels.vec,
-		       UPPER_20_SB(CHSPEC_CHANNEL(chspec)))) :
-		isset(wlc_cm->quiet_channels.vec, CHSPEC_CHANNEL(chspec));
-}
 
-/* Is the channel valid for the current locale? (but don't consider channels not
- *   available due to bandlocking)
- */
-static bool brcms_c_valid_channel20_db(struct brcms_cm_info *wlc_cm, uint val)
-{
-	struct brcms_c_info *wlc = wlc_cm->wlc;
+	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
+	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
+	/* set or restore gmode as required by regulatory */
+	locale = brcms_c_get_locale_2g(country->locale_2G);
+	if (locale && (locale->flags & BRCMS_NO_OFDM))
+		brcms_c_set_gmode(wlc, GMODE_LEGACY_B, false);
+	else
+		brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
 
-	return VALID_CHANNEL20(wlc, val) ||
-		(!wlc->bandlocked
-		 && VALID_CHANNEL20_IN_BAND(wlc, OTHERBANDUNIT(wlc), val));
-}
+	brcms_c_channels_init(wlc_cm, country);
 
-/* Is the channel valid for the current locale and specified band? */
-static bool brcms_c_valid_channel20_in_band(struct brcms_cm_info *wlc_cm,
-					    uint bandunit, uint val)
-{
-	return ((val < MAXCHANNEL)
-		&& isset(wlc_cm->bandstate[bandunit].valid_channels.vec, val));
+	return;
 }
 
-/* Is the channel valid for the current locale and current band? */
-static bool brcms_c_valid_channel20(struct brcms_cm_info *wlc_cm, uint val)
+static int
+brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
+			const char *country_abbrev,
+			const char *ccode, int regrev)
 {
-	struct brcms_c_info *wlc = wlc_cm->wlc;
+	const struct country_info *country;
+	char mapped_ccode[BRCM_CNTRY_BUF_SZ];
+	uint mapped_regrev;
 
-	return ((val < MAXCHANNEL) &&
-		isset(wlc_cm->bandstate[wlc->band->bandunit].valid_channels.vec,
-		      val));
-}
+	/* if regrev is -1, lookup the mapped country code,
+	 * otherwise use the ccode and regrev directly
+	 */
+	if (regrev == -1) {
+		/*
+		 * map the country code to a built-in country
+		 * code, regrev, and country_info
+		 */
+		country =
+		    brcms_c_countrycode_map(wlc_cm, ccode, mapped_ccode,
+					&mapped_regrev);
+	} else {
+		/* find the matching built-in country definition */
+		country = brcms_c_country_lookup_direct(ccode, regrev);
+		strncpy(mapped_ccode, ccode, BRCM_CNTRY_BUF_SZ);
+		mapped_regrev = regrev;
+	}
 
-static void
-brcms_c_channel_min_txpower_limits_with_local_constraint(
-		struct brcms_cm_info *wlc_cm, struct txpwr_limits *txpwr,
-		u8 local_constraint_qdbm)
-{
-	int j;
+	if (country == NULL)
+		return -EINVAL;
 
-	/* CCK Rates */
-	for (j = 0; j < WL_TX_POWER_CCK_NUM; j++)
-		txpwr->cck[j] = min(txpwr->cck[j], local_constraint_qdbm);
+	/* set the driver state for the country */
+	brcms_c_set_country_common(wlc_cm, country_abbrev, mapped_ccode,
+			       mapped_regrev, country);
 
-	/* 20 MHz Legacy OFDM SISO */
-	for (j = 0; j < WL_TX_POWER_OFDM_NUM; j++)
-		txpwr->ofdm[j] = min(txpwr->ofdm[j], local_constraint_qdbm);
+	return 0;
+}
 
-	/* 20 MHz Legacy OFDM CDD */
-	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++)
-		txpwr->ofdm_cdd[j] =
-		    min(txpwr->ofdm_cdd[j], local_constraint_qdbm);
+/*
+ * set the driver's current country and regulatory information using
+ * a country code as the source. Lookup built in country information
+ * found with the country code.
+ */
+static int
+brcms_c_set_countrycode(struct brcms_cm_info *wlc_cm, const char *ccode)
+{
+	char country_abbrev[BRCM_CNTRY_BUF_SZ];
+	strncpy(country_abbrev, ccode, BRCM_CNTRY_BUF_SZ);
+	return brcms_c_set_countrycode_rev(wlc_cm, country_abbrev, ccode, -1);
+}
 
-	/* 40 MHz Legacy OFDM SISO */
-	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++)
-		txpwr->ofdm_40_siso[j] =
-		    min(txpwr->ofdm_40_siso[j], local_constraint_qdbm);
+struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
+{
+	struct brcms_cm_info *wlc_cm;
+	char country_abbrev[BRCM_CNTRY_BUF_SZ];
+	const struct country_info *country;
+	struct brcms_pub *pub = wlc->pub;
+	char *ccode;
 
-	/* 40 MHz Legacy OFDM CDD */
-	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++)
-		txpwr->ofdm_40_cdd[j] =
-		    min(txpwr->ofdm_40_cdd[j], local_constraint_qdbm);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
-	/* 20MHz MCS 0-7 SISO */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
-		txpwr->mcs_20_siso[j] =
-		    min(txpwr->mcs_20_siso[j], local_constraint_qdbm);
+	wlc_cm = kzalloc(sizeof(struct brcms_cm_info), GFP_ATOMIC);
+	if (wlc_cm == NULL) {
+		wiphy_err(wlc->wiphy, "wl%d: %s: out of memory", pub->unit,
+			  __func__);
+		return NULL;
+	}
+	wlc_cm->pub = pub;
+	wlc_cm->wlc = wlc;
+	wlc->cmi = wlc_cm;
 
-	/* 20MHz MCS 0-7 CDD */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
-		txpwr->mcs_20_cdd[j] =
-		    min(txpwr->mcs_20_cdd[j], local_constraint_qdbm);
+	/* store the country code for passing up as a regulatory hint */
+	ccode = getvar(wlc->pub->vars, "ccode");
+	if (ccode)
+		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
 
-	/* 20MHz MCS 0-7 STBC */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
-		txpwr->mcs_20_stbc[j] =
-		    min(txpwr->mcs_20_stbc[j], local_constraint_qdbm);
+	/*
+	 * internal country information which must match
+	 * regulatory constraints in firmware
+	 */
+	memset(country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
+	strncpy(country_abbrev, "X2", sizeof(country_abbrev) - 1);
+	country = brcms_c_country_lookup(wlc, country_abbrev);
 
-	/* 20MHz MCS 8-15 MIMO */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_2_STREAM; j++)
-		txpwr->mcs_20_mimo[j] =
-		    min(txpwr->mcs_20_mimo[j], local_constraint_qdbm);
+	/* save default country for exiting 11d regulatory mode */
+	strncpy(wlc->country_default, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
 
-	/* 40MHz MCS 0-7 SISO */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
-		txpwr->mcs_40_siso[j] =
-		    min(txpwr->mcs_40_siso[j], local_constraint_qdbm);
+	/* initialize autocountry_default to driver default */
+	strncpy(wlc->autocountry_default, "X2", BRCM_CNTRY_BUF_SZ - 1);
 
-	/* 40MHz MCS 0-7 CDD */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
-		txpwr->mcs_40_cdd[j] =
-		    min(txpwr->mcs_40_cdd[j], local_constraint_qdbm);
+	brcms_c_set_countrycode(wlc_cm, country_abbrev);
 
-	/* 40MHz MCS 0-7 STBC */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
-		txpwr->mcs_40_stbc[j] =
-		    min(txpwr->mcs_40_stbc[j], local_constraint_qdbm);
+	return wlc_cm;
+}
 
-	/* 40MHz MCS 8-15 MIMO */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_2_STREAM; j++)
-		txpwr->mcs_40_mimo[j] =
-		    min(txpwr->mcs_40_mimo[j], local_constraint_qdbm);
+void brcms_c_channel_mgr_detach(struct brcms_cm_info *wlc_cm)
+{
+	kfree(wlc_cm);
+}
 
-	/* 40MHz MCS 32 */
-	txpwr->mcs32 = min(txpwr->mcs32, local_constraint_qdbm);
+u8
+brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
+				     uint bandunit)
+{
+	return wlc_cm->bandstate[bandunit].locale_flags;
+}
 
+static bool
+brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm, u16 chspec)
+{
+	return N_ENAB(wlc_cm->wlc->pub) && CHSPEC_IS40(chspec) ?
+		(isset(wlc_cm->quiet_channels.vec,
+		       LOWER_20_SB(CHSPEC_CHANNEL(chspec))) ||
+		 isset(wlc_cm->quiet_channels.vec,
+		       UPPER_20_SB(CHSPEC_CHANNEL(chspec)))) :
+		isset(wlc_cm->quiet_channels.vec, CHSPEC_CHANNEL(chspec));
 }
 
 void
@@ -1471,19 +1435,6 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	return;
 }
 
-/* Returns true if currently set country is Japan or variant */
-static bool brcms_c_japan(struct brcms_c_info *wlc)
-{
-	return brcms_c_japan_ccode(wlc->cmi->country_abbrev);
-}
-
-/* JP, J1 - J10 are Japan ccodes */
-static bool brcms_c_japan_ccode(const char *ccode)
-{
-	return (ccode[0] == 'J' &&
-		(ccode[1] == 'P' || (ccode[1] >= '1' && ccode[1] <= '9')));
-}
-
 /*
  * Validate the chanspec for this locale, for 40MHZ we need to also
  * check that the sidebands are valid 20MZH channels in this locale
-- 
1.7.4.1



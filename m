Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41202 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2DPUSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 16:18:02 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: [RFC PATCH 7/8] brcm80211: smac: don't validate channels against internal regulatory data
Date: Mon, 16 Apr 2012 15:17:41 -0500
Message-Id: <1334607462-5387-8-git-send-email-seth.forshee@canonical.com> (sfid-20120416_221806_449295_7AE3032F)
In-Reply-To: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The core regulatory support will disable channels not allowed by
regulatory rules, so brcmsmac doesn't need to duplicate it.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |  344 +--------------------
 1 file changed, 6 insertions(+), 338 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index cda40c8..a31a3de 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -30,40 +30,6 @@
 /* QDB() macro takes a dB value and converts to a quarter dB value */
 #define QDB(n) ((n) * BRCMS_TXPWR_DB_FACTOR)
 
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
-#define  LOCALE_RESTRICTED_NONE		  0
-#define  LOCALE_RESTRICTED_SET_2G_SHORT   1
-
 #define LOCALE_2G_IDX_i			0
 #define LOCALE_5G_IDX_11		0
 #define LOCALE_MIMO_IDX_bn		0
@@ -138,10 +104,6 @@ static const struct ieee80211_regdomain brcms_regdom_x2 = {
 struct brcms_cm_band {
 	/* struct locale_info flags */
 	u8 locale_flags;
-	/* List of valid channels in the country */
-	struct brcms_chanvec valid_channels;
-	/* List of restricted use channels */
-	const struct brcms_chanvec *restricted_channels;
 };
 
  /* locale per-channel tx power limits for MIMO frames
@@ -175,211 +137,17 @@ struct brcms_cm_info {
 	const struct brcms_regd *world_regd;
 	/* per-band state (one per phy/radio) */
 	struct brcms_cm_band bandstate[MAXBANDS];
-	/* quiet channels currently for radar sensitivity or 11h support */
-	/* channels on which we cannot transmit */
-	struct brcms_chanvec quiet_channels;
 };
 
 /* locale channel and power info. */
 struct locale_info {
-	u32 valid_channels;
-	/* List of channels used only if APs are detected */
-	u8 restricted_channels;
 	u8 flags;
 };
 
-/* Regulatory Matrix Spreadsheet (CLM) MIMO v3.7.9 */
-
-/*
- * Some common channel sets
- */
-
-/* No channels */
-static const struct brcms_chanvec chanvec_none = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/*
- * Restricted channel sets
- */
-
-/* Channels 12, 13 */
-static const struct brcms_chanvec restricted_set_2g_short = {
-	{0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-/* global memory to provide working buffer for expanded locale */
-
-static const struct brcms_chanvec *g_table_restricted_chan[] = {
-	&chanvec_none,		/* restricted_set_none */
-	&restricted_set_2g_short,
-};
-
-static const struct brcms_chanvec locale_2g_01_11 = {
-	{0xfe, 0x0f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_2g_12_13 = {
-	{0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_2g_14 = {
-	{0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_LOW_JP1 = {
-	{0x00, 0x00, 0x00, 0x00, 0x54, 0x55, 0x01, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_LOW_JP2 = {
-	{0x00, 0x00, 0x00, 0x00, 0x44, 0x44, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_LOW1 = {
-	{0x00, 0x00, 0x00, 0x00, 0x10, 0x11, 0x01, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_LOW2 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_LOW3 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11,
-	 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_MID1 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_MID2 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_MID3 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_HIGH1 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x10, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_HIGH2 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x20, 0x22, 0x02, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_HIGH3 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_52_140_ALL = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x11,
-	 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11,
-	 0x11, 0x11, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
-};
-
-static const struct brcms_chanvec locale_5g_HIGH4 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11,
-	 0x11, 0x11, 0x11, 0x11}
-};
-
-static const struct brcms_chanvec *g_table_locale_base[] = {
-	&locale_2g_01_11,
-	&locale_2g_12_13,
-	&locale_2g_14,
-	&locale_5g_LOW_JP1,
-	&locale_5g_LOW_JP2,
-	&locale_5g_LOW1,
-	&locale_5g_LOW2,
-	&locale_5g_LOW3,
-	&locale_5g_MID1,
-	&locale_5g_MID2,
-	&locale_5g_MID3,
-	&locale_5g_HIGH1,
-	&locale_5g_HIGH2,
-	&locale_5g_HIGH3,
-	&locale_5g_52_140_ALL,
-	&locale_5g_HIGH4
-};
-
-static void brcms_c_locale_add_channels(struct brcms_chanvec *target,
-				    const struct brcms_chanvec *channels)
-{
-	u8 i;
-	for (i = 0; i < sizeof(struct brcms_chanvec); i++)
-		target->vec[i] |= channels->vec[i];
-}
-
-static void brcms_c_locale_get_channels(const struct locale_info *locale,
-				    struct brcms_chanvec *channels)
-{
-	u8 i;
-
-	memset(channels, 0, sizeof(struct brcms_chanvec));
-
-	for (i = 0; i < ARRAY_SIZE(g_table_locale_base); i++) {
-		if (locale->valid_channels & (1 << i))
-			brcms_c_locale_add_channels(channels,
-						g_table_locale_base[i]);
-	}
-}
-
 /*
  * Locale Definitions - 2.4 GHz
  */
 static const struct locale_info locale_i = {	/* locale i. channel 1 - 13 */
-	LOCALE_CHAN_01_11 | LOCALE_CHAN_12_13,
-	LOCALE_RESTRICTED_SET_2G_SHORT,
 	BRCMS_EIRP
 };
 
@@ -387,9 +155,6 @@ static const struct locale_info locale_i = {	/* locale i. channel 1 - 13 */
  * Locale Definitions - 5 GHz
  */
 static const struct locale_info locale_11 = {
-	/* locale 11. channel 36 - 48, 52 - 64, 100 - 140, 149 - 165 */
-	LOCALE_CHAN_36_64 | LOCALE_CHAN_100_140 | LOCALE_CHAN_149_165,
-	LOCALE_RESTRICTED_NONE,
 	BRCMS_EIRP | BRCMS_DFS_EU
 };
 
@@ -525,62 +290,6 @@ static const struct brcms_regd *brcms_default_world_regd(void)
 	return &cntry_locales[0];
 }
 
-/*
- * reset the quiet channels vector to the union
- * of the restricted and radar channel sets
- */
-static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm)
-{
-	struct brcms_c_info *wlc = wlc_cm->wlc;
-	uint i, j;
-	struct brcms_band *band;
-	const struct brcms_chanvec *chanvec;
-
-	memset(&wlc_cm->quiet_channels, 0, sizeof(struct brcms_chanvec));
-
-	band = wlc->band;
-	for (i = 0; i < wlc->pub->_nbands;
-	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
-
-		/* initialize quiet channels for restricted channels */
-		chanvec = wlc_cm->bandstate[band->bandunit].restricted_channels;
-		for (j = 0; j < sizeof(struct brcms_chanvec); j++)
-			wlc_cm->quiet_channels.vec[j] |= chanvec->vec[j];
-
-	}
-}
-
-/* Is the channel valid for the current locale and current band? */
-static bool brcms_c_valid_channel20(struct brcms_cm_info *wlc_cm, uint val)
-{
-	struct brcms_c_info *wlc = wlc_cm->wlc;
-
-	return ((val < MAXCHANNEL) &&
-		isset(wlc_cm->bandstate[wlc->band->bandunit].valid_channels.vec,
-		      val));
-}
-
-/* Is the channel valid for the current locale and specified band? */
-static bool brcms_c_valid_channel20_in_band(struct brcms_cm_info *wlc_cm,
-					    uint bandunit, uint val)
-{
-	return ((val < MAXCHANNEL)
-		&& isset(wlc_cm->bandstate[bandunit].valid_channels.vec, val));
-}
-
-/* Is the channel valid for the current locale? (but don't consider channels not
- *   available due to bandlocking)
- */
-static bool brcms_c_valid_channel20_db(struct brcms_cm_info *wlc_cm, uint val)
-{
-	struct brcms_c_info *wlc = wlc_cm->wlc;
-
-	return brcms_c_valid_channel20(wlc->cmi, val) ||
-		(!wlc->bandlocked
-		 && brcms_c_valid_channel20_in_band(wlc->cmi,
-						    OTHERBANDUNIT(wlc), val));
-}
-
 /* JP, J1 - J10 are Japan ccodes */
 static bool brcms_c_japan_ccode(const char *ccode)
 {
@@ -668,10 +377,9 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 		      const struct country_info *country)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	uint i, j;
+	uint i;
 	struct brcms_band *band;
 	const struct locale_info *li;
-	struct brcms_chanvec sup_chan;
 	const struct locale_mimo_info *li_mimo;
 
 	band = wlc->band;
@@ -689,26 +397,8 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 		/* merge the mimo non-mimo locale flags */
 		wlc_cm->bandstate[band->bandunit].locale_flags |=
 		    li_mimo->flags;
-
-		wlc_cm->bandstate[band->bandunit].restricted_channels =
-		    g_table_restricted_chan[li->restricted_channels];
-
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
 	}
 
-	brcms_c_quiet_channels_reset(wlc_cm);
-
 	return 0;
 }
 
@@ -799,23 +489,12 @@ brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
 	return wlc_cm->bandstate[bandunit].locale_flags;
 }
 
-static bool
-brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm, u16 chspec)
-{
-	return (wlc_cm->wlc->pub->_n_enab & SUPPORT_11N) &&
-		CHSPEC_IS40(chspec) ?
-		(isset(wlc_cm->quiet_channels.vec,
-		       lower_20_sb(CHSPEC_CHANNEL(chspec))) ||
-		 isset(wlc_cm->quiet_channels.vec,
-		       upper_20_sb(CHSPEC_CHANNEL(chspec)))) :
-		isset(wlc_cm->quiet_channels.vec, CHSPEC_CHANNEL(chspec));
-}
-
 void
 brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
 			 u8 local_constraint_qdbm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
+	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.channel;
 	struct txpwr_limits txpwr;
 
 	brcms_c_channel_reg_limits(wlc_cm, chanspec, &txpwr);
@@ -825,7 +504,7 @@ brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	);
 
 	brcms_b_set_chanspec(wlc->hw, chanspec,
-			      (brcms_c_quiet_chanspec(wlc_cm, chanspec) != 0),
+			      !!(ch->flags & IEEE80211_CHAN_PASSIVE_SCAN),
 			      &txpwr);
 }
 
@@ -1041,8 +720,7 @@ static bool brcms_c_chspec_malformed(u16 chanspec)
  * and they are also a legal HT combination
  */
 static bool
-brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
-			   bool dualband)
+brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	u8 channel = CHSPEC_CHANNEL(chspec);
@@ -1058,22 +736,12 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
 	    chspec_bandunit(chspec))
 		return false;
 
-	/* Check a 20Mhz channel */
-	if (CHSPEC_IS20(chspec)) {
-		if (dualband)
-			return brcms_c_valid_channel20_db(wlc_cm->wlc->cmi,
-							  channel);
-		else
-			return brcms_c_valid_channel20(wlc_cm->wlc->cmi,
-						       channel);
-	}
-
-	return false;
+	return true;
 }
 
 bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm, u16 chspec)
 {
-	return brcms_c_valid_chanspec_ext(wlc_cm, chspec, true);
+	return brcms_c_valid_chanspec_ext(wlc_cm, chspec);
 }
 
 bool brcms_is_radar_freq(u16 center_freq)
-- 
1.7.9.5


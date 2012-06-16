Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2FPMsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 08:48:41 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v3 9/9] brcm80211: smac: use current regulatory domain when checking whether OFDM is allowed
Date: Sat, 16 Jun 2012 07:47:56 -0500
Message-Id: <1339850876-8020-10-git-send-email-seth.forshee@canonical.com> (sfid-20120616_144844_417672_74348681)
In-Reply-To: <1339850876-8020-1-git-send-email-seth.forshee@canonical.com>
References: <1339850876-8020-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmsmac internal regulatory data is being used to determine whether
OFDM should be allowed, and this is only done once during
initialization. To be effective this needs to be checked against
mac80211's regulatory rules for the current channel.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |  132 +++------------------
 drivers/net/wireless/brcm80211/brcmsmac/channel.h |    3 -
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |    6 +-
 3 files changed, 15 insertions(+), 126 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 04e6a6e..d3c7260 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -30,13 +30,9 @@
 /* QDB() macro takes a dB value and converts to a quarter dB value */
 #define QDB(n) ((n) * BRCMS_TXPWR_DB_FACTOR)
 
-#define LOCALE_2G_IDX_i			0
-#define LOCALE_5G_IDX_11		0
 #define LOCALE_MIMO_IDX_bn		0
 #define LOCALE_MIMO_IDX_11n		0
 
-/* max of BAND_5G_PWR_LVLS and 6 for 2.4 GHz */
-#define BRCMS_MAXPWR_TBL_SIZE		6
 /* max of BAND_5G_PWR_LVLS and 14 for 2.4 GHz */
 #define BRCMS_MAXPWR_MIMO_TBL_SIZE	14
 
@@ -51,12 +47,8 @@
 
 #define LC(id)	LOCALE_MIMO_IDX_ ## id
 
-#define LC_2G(id)	LOCALE_2G_IDX_ ## id
-
-#define LC_5G(id)	LOCALE_5G_IDX_ ## id
-
-#define LOCALES(band2, band5, mimo2, mimo5) \
-		{LC_2G(band2), LC_5G(band5), LC(mimo2), LC(mimo5)}
+#define LOCALES(mimo2, mimo5) \
+		{LC(mimo2), LC(mimo5)}
 
 /* macro to get 5 GHz channel group index for tx power */
 #define CHANNEL_POWER_IDX_5G(c) (((c) < 52) ? 0 : \
@@ -97,11 +89,6 @@ static const struct ieee80211_regdomain brcms_regdom_x2 = {
 	}
 };
 
-struct brcms_cm_band {
-	/* struct locale_info flags */
-	u8 locale_flags;
-};
-
  /* locale per-channel tx power limits for MIMO frames
   * maxpwr arrays are index by channel for 2.4 GHz limits, and
   * by sub-band for 5 GHz limits using CHANNEL_POWER_IDX_5G(channel)
@@ -111,13 +98,10 @@ struct locale_mimo_info {
 	s8 maxpwr20[BRCMS_MAXPWR_MIMO_TBL_SIZE];
 	/* tx 40 MHz power limits, qdBm units */
 	s8 maxpwr40[BRCMS_MAXPWR_MIMO_TBL_SIZE];
-	u8 flags;
 };
 
 /* Country names and abbreviations with locale defined from ISO 3166 */
 struct country_info {
-	const u8 locale_2G;	/* 2.4G band locale */
-	const u8 locale_5G;	/* 5G band locale */
 	const u8 locale_mimo_2G;	/* 2.4G mimo info */
 	const u8 locale_mimo_5G;	/* 5G mimo info */
 };
@@ -131,35 +115,6 @@ struct brcms_cm_info {
 	struct brcms_pub *pub;
 	struct brcms_c_info *wlc;
 	const struct brcms_regd *world_regd;
-	/* per-band state (one per phy/radio) */
-	struct brcms_cm_band bandstate[MAXBANDS];
-};
-
-/* locale channel and power info. */
-struct locale_info {
-	u8 flags;
-};
-
-/*
- * Locale Definitions - 2.4 GHz
- */
-static const struct locale_info locale_i = {	/* locale i. channel 1 - 13 */
-	BRCMS_EIRP
-};
-
-/*
- * Locale Definitions - 5 GHz
- */
-static const struct locale_info locale_11 = {
-	BRCMS_EIRP | BRCMS_DFS_EU
-};
-
-static const struct locale_info *g_locale_2g_table[] = {
-	&locale_i
-};
-
-static const struct locale_info *g_locale_5g_table[] = {
-	&locale_11
 };
 
 /*
@@ -172,7 +127,6 @@ static const struct locale_mimo_info locale_bn = {
 	{0, 0, QDB(13), QDB(13), QDB(13),
 	 QDB(13), QDB(13), QDB(13), QDB(13), QDB(13),
 	 QDB(13), 0, 0},
-	0
 };
 
 static const struct locale_mimo_info *g_mimo_2g_table[] = {
@@ -185,7 +139,6 @@ static const struct locale_mimo_info *g_mimo_2g_table[] = {
 static const struct locale_mimo_info locale_11n = {
 	{ /* 12.5 dBm */ 50, 50, 50, QDB(15), QDB(15)},
 	{QDB(14), QDB(15), QDB(15), QDB(15), QDB(15)},
-	0
 };
 
 static const struct locale_mimo_info *g_mimo_5g_table[] = {
@@ -195,27 +148,11 @@ static const struct locale_mimo_info *g_mimo_5g_table[] = {
 static const struct brcms_regd cntry_locales[] = {
 	/* Worldwide RoW 2, must always be at index 0 */
 	{
-		.country = LOCALES(i, 11, bn, 11n),
+		.country = LOCALES(bn, 11n),
 		.regdomain = &brcms_regdom_x2,
 	},
 };
 
-static const struct locale_info *brcms_c_get_locale_2g(u8 locale_idx)
-{
-	if (locale_idx >= ARRAY_SIZE(g_locale_2g_table))
-		return NULL; /* error condition */
-
-	return g_locale_2g_table[locale_idx];
-}
-
-static const struct locale_info *brcms_c_get_locale_5g(u8 locale_idx)
-{
-	if (locale_idx >= ARRAY_SIZE(g_locale_5g_table))
-		return NULL; /* error condition */
-
-	return g_locale_5g_table[locale_idx];
-}
-
 static const struct locale_mimo_info *brcms_c_get_mimo_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_mimo_2g_table))
@@ -368,36 +305,6 @@ brcms_c_channel_min_txpower_limits_with_local_constraint(
 
 }
 
-static int
-brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
-		      const struct country_info *country)
-{
-	struct brcms_c_info *wlc = wlc_cm->wlc;
-	uint i;
-	struct brcms_band *band;
-	const struct locale_info *li;
-	const struct locale_mimo_info *li_mimo;
-
-	band = wlc->band;
-	for (i = 0; i < wlc->pub->_nbands;
-	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
-
-		li = (band->bandtype == BRCM_BAND_5G) ?
-		    brcms_c_get_locale_5g(country->locale_5G) :
-		    brcms_c_get_locale_2g(country->locale_2G);
-		wlc_cm->bandstate[band->bandunit].locale_flags = li->flags;
-		li_mimo = (band->bandtype == BRCM_BAND_5G) ?
-		    brcms_c_get_mimo_5g(country->locale_mimo_5G) :
-		    brcms_c_get_mimo_2g(country->locale_mimo_2G);
-
-		/* merge the mimo non-mimo locale flags */
-		wlc_cm->bandstate[band->bandunit].locale_flags |=
-		    li_mimo->flags;
-	}
-
-	return 0;
-}
-
 /*
  * set the driver's current country and regulatory information
  * using a country code as the source. Look up built in country
@@ -407,8 +314,6 @@ static void
 brcms_c_set_country(struct brcms_cm_info *wlc_cm,
 		    const struct brcms_regd *regd)
 {
-	const struct country_info *country = &regd->country;
-	const struct locale_info *locale;
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 
 	if ((wlc->pub->_n_enab & SUPPORT_11N) !=
@@ -417,14 +322,8 @@ brcms_c_set_country(struct brcms_cm_info *wlc_cm,
 
 	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
 	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
-	/* set or restore gmode as required by regulatory */
-	locale = brcms_c_get_locale_2g(country->locale_2G);
-	if (locale && (locale->flags & BRCMS_NO_OFDM))
-		brcms_c_set_gmode(wlc, GMODE_LEGACY_B, false);
-	else
-		brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
 
-	brcms_c_channels_init(wlc_cm, country);
+	brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
 
 	return;
 }
@@ -477,20 +376,15 @@ void brcms_c_channel_mgr_detach(struct brcms_cm_info *wlc_cm)
 	kfree(wlc_cm);
 }
 
-u8
-brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
-				     uint bandunit)
-{
-	return wlc_cm->bandstate[bandunit].locale_flags;
-}
-
 void
 brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
 			 u8 local_constraint_qdbm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.channel;
+	const struct ieee80211_reg_rule *reg_rule;
 	struct txpwr_limits txpwr;
+	int ret;
 
 	brcms_c_channel_reg_limits(wlc_cm, chanspec, &txpwr);
 
@@ -498,6 +392,13 @@ brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		wlc_cm, &txpwr, local_constraint_qdbm
 	);
 
+	/* set or restore gmode as required by regulatory */
+	ret = freq_reg_info(wlc->wiphy, ch->center_freq, 0, &reg_rule);
+	if (!ret && (reg_rule->flags & NL80211_RRF_NO_OFDM))
+		brcms_c_set_gmode(wlc, GMODE_LEGACY_B, false);
+	else
+		brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
+
 	brcms_b_set_chanspec(wlc->hw, chanspec,
 			      !!(ch->flags & IEEE80211_CHAN_PASSIVE_SCAN),
 			      &txpwr);
@@ -515,7 +416,6 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	int delta;
 	const struct country_info *country;
 	struct brcms_band *band;
-	const struct locale_info *li;
 	int conducted_max = BRCMS_TXPWR_MAX;
 	const struct locale_mimo_info *li_mimo;
 	int maxpwr20, maxpwr40;
@@ -531,17 +431,13 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 
 	chan = CHSPEC_CHANNEL(chanspec);
 	band = wlc->bandstate[chspec_bandunit(chanspec)];
-	li = (band->bandtype == BRCM_BAND_5G) ?
-	    brcms_c_get_locale_5g(country->locale_5G) :
-	    brcms_c_get_locale_2g(country->locale_2G);
-
 	li_mimo = (band->bandtype == BRCM_BAND_5G) ?
 	    brcms_c_get_mimo_5g(country->locale_mimo_5G) :
 	    brcms_c_get_mimo_2g(country->locale_mimo_2G);
 
 	delta = band->antgain;
 
-	if (li == &locale_i)
+	if (band->bandtype == BRCM_BAND_2G)
 		conducted_max = QDB(22);
 
 	maxpwr = QDB(ch->max_power) - delta;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.h b/drivers/net/wireless/brcm80211/brcmsmac/channel.h
index de9887d..006483a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.h
@@ -37,9 +37,6 @@ brcms_c_channel_mgr_attach(struct brcms_c_info *wlc);
 
 extern void brcms_c_channel_mgr_detach(struct brcms_cm_info *wlc_cm);
 
-extern u8 brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
-					   uint bandunit);
-
 extern bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm,
 				      u16 chspec);
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 93c865d..8776fbc 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -18,6 +18,7 @@
 
 #include <linux/pci_ids.h>
 #include <linux/if_ether.h>
+#include <net/cfg80211.h>
 #include <net/mac80211.h>
 #include <brcm_hw_ids.h>
 #include <aiutils.h>
@@ -5386,11 +5387,6 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	else
 		return -EINVAL;
 
-	/* Legacy or bust when no OFDM is supported by regulatory */
-	if ((brcms_c_channel_locale_flags_in_band(wlc->cmi, band->bandunit) &
-	     BRCMS_NO_OFDM) && (gmode != GMODE_LEGACY_B))
-		return -EINVAL;
-
 	/* update configuration value */
 	if (config)
 		brcms_c_protection_upd(wlc, BRCMS_PROT_G_USER, gmode);
-- 
1.7.9.5


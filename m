Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3958 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab2EYWdd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 18:33:33 -0400
Message-ID: <4FC008AB.4080107@broadcom.com> (sfid-20120526_003337_202130_B8C00B76)
Date: Sat, 26 May 2012 00:33:15 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 4/8] brcm80211: smac: inform mac80211 of the X2
 regulatory domain
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-5-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1334607462-5387-5-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 10:17 PM, Seth Forshee wrote:
> brcmsmac implements enforcement of regulatory constraints internally,
> using a Broadcom-specific world roaming domain named X2. Besides being
> duplication of functionality, this also causes some channels to be
> unnecessarily disabled, as mac80211 is unaware of the X2 domain and thus
> applies the more restrictive default world domain.
> 
> This patch is the first step in making brcmsmac cooperate with
> mac80211's regulatory support. X2 is registered as a custom domain with
> mac80211, so that at least both implementations will be enforcing the
> same set of constraints. The internal enforcement of rules is kept for
> now; this will be converted over to relying on mac80211 regulatory
> enforcement in later patches.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/channel.c  |  392 +++++++++++---------
>  drivers/net/wireless/brcm80211/brcmsmac/channel.h  |    2 +
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 +
>  3 files changed, 217 insertions(+), 179 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> index 1998c86..fd5b807 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> @@ -15,7 +15,9 @@
>   */
>  
>  #include <linux/types.h>
> +#include <net/cfg80211.h>
>  #include <net/mac80211.h>
> +#include <net/regulatory.h>
>  
>  #include <defs.h>
>  #include "pub.h"
> @@ -23,6 +25,7 @@
>  #include "main.h"
>  #include "stf.h"
>  #include "channel.h"
> +#include "mac80211_if.h"
>  
>  /* QDB() macro takes a dB value and converts to a quarter dB value */
>  #define QDB(n) ((n) * BRCMS_TXPWR_DB_FACTOR)
> @@ -108,6 +111,43 @@
>  				 (((c) < 100) ? 2 : \
>  				 (((c) < 149) ? 3 : 4))))
>  
> +#define BRCM_2GHZ_2412_2462	REG_RULE(2412-10, 2462+10, 40, 0, 19, 0)
> +#define BRCM_2GHZ_2467_2472	REG_RULE(2467-10, 2472+10, 20, 0, 19, \
> +					 NL80211_RRF_PASSIVE_SCAN | \
> +					 NL80211_RRF_NO_IBSS)
> +#define BRCM_2GHZ_2484		REG_RULE(2484-10, 2484+10, 40, 0, 19, \
> +					 NL80211_RRF_PASSIVE_SCAN | \
> +					 NL80211_RRF_NO_OFDM)
> +

If channels 12 and 13 are 20MHz only, shouldn't channel 14 above
(2484MHz) be 20MHz as well?

> +#define BRCM_5GHZ_5180_5240	REG_RULE(5180-10, 5240+10, 40, 0, 21, \
> +					 NL80211_RRF_PASSIVE_SCAN | \
> +					 NL80211_RRF_NO_IBSS)
> +#define BRCM_5GHZ_5260_5320	REG_RULE(5260-10, 5320+10, 40, 0, 21, \
> +					 NL80211_RRF_PASSIVE_SCAN | \
> +					 NL80211_RRF_DFS | \
> +					 NL80211_RRF_NO_IBSS)
> +#define BRCM_5GHZ_5500_5700	REG_RULE(5500-10, 5700+10, 40, 0, 21, \
> +					 NL80211_RRF_PASSIVE_SCAN | \
> +					 NL80211_RRF_DFS | \
> +					 NL80211_RRF_NO_IBSS)
> +#define BRCM_5GHZ_5745_5825	REG_RULE(5745-10, 5825+10, 40, 0, 21, \
> +					 NL80211_RRF_PASSIVE_SCAN | \
> +					 NL80211_RRF_NO_IBSS)
> +
> +static const struct ieee80211_regdomain brcms_regdom_x2 = {
> +	.n_reg_rules = 7,
> +	.alpha2 = "X2",
> +	.reg_rules = {
> +		BRCM_2GHZ_2412_2462,
> +		BRCM_2GHZ_2467_2472,
> +		BRCM_2GHZ_2484,

The X2 domain did not support channel 14 so this is cheating ;-)

> +		BRCM_5GHZ_5180_5240,
> +		BRCM_5GHZ_5260_5320,
> +		BRCM_5GHZ_5500_5700,
> +		BRCM_5GHZ_5745_5825,
> +	}
> +};
> + 
>  struct brcms_cm_band {
>  	/* struct locale_info flags */
>  	u8 locale_flags;
> @@ -137,14 +177,15 @@ struct country_info {
>  	const u8 locale_mimo_5G;	/* 5G mimo info */
>  };
>  
> +struct brcms_regd {
> +	struct country_info country;
> +	const struct ieee80211_regdomain *regdomain;
> +};
> +
>  struct brcms_cm_info {
>  	struct brcms_pub *pub;
>  	struct brcms_c_info *wlc;
> -	char srom_ccode[BRCM_CNTRY_BUF_SZ];	/* Country Code in SROM */
> -	uint srom_regrev;	/* Regulatory Rev for the SROM ccode */
> -	const struct country_info *country;	/* current country def */
> -	uint regrev;		/* current Regulatory Revision */
> -	char country_abbrev[BRCM_CNTRY_BUF_SZ];	/* current advertised ccode */
> +	const struct brcms_regd *world_regd;
>  	/* per-band state (one per phy/radio) */
>  	struct brcms_cm_band bandstate[MAXBANDS];
>  	/* quiet channels currently for radar sensitivity or 11h support */
> @@ -408,12 +449,12 @@ static const struct locale_mimo_info *g_mimo_5g_table[] = {
>  	&locale_11n
>  };
>  
> -static const struct {
> -	char abbrev[BRCM_CNTRY_BUF_SZ];	/* country abbreviation */
> -	struct country_info country;
> -} cntry_locales[] = {
> +static const struct brcms_regd cntry_locales[] = {
> +	/* Worldwide Row 2, must always be at index 0 */

Row is abbreviation for Rest of World, hence RoW. Come to think of it,
this actually makes the term Worldwide a bit redundant.

>  	{
> -	"X2", LOCALES(i, 11, bn, 11n)},	/* Worldwide RoW 2 */
> +		.country = LOCALES(i, 11, bn, 11n),
> +		.regdomain = &brcms_regdom_x2,
> +	},
>  };
>  
>  static const struct locale_info *brcms_c_get_locale_2g(u8 locale_idx)
> @@ -482,93 +523,24 @@ static bool brcms_c_country_valid(const char *ccode)
>  	return true;
>  }
>  
> -/* Lookup a country info structure from a null terminated country
> - * abbreviation and regrev directly with no translation.
> - */
> -static const struct country_info *
> -brcms_c_country_lookup_direct(const char *ccode, uint regrev)
> +static const struct brcms_regd *brcms_world_regd(const char *regdom)
>  {
> -	uint size, i;
> -
> -	/* Should just return 0 for single locale driver. */
> -	/* Keep it this way in case we add more locales. (for now anyway) */
> -
> -	/*
> -	 * all other country def arrays are for regrev == 0, so if
> -	 * regrev is non-zero, fail
> -	 */
> -	if (regrev > 0)
> -		return NULL;
> -
> -	/* find matched table entry from country code */
> -	size = ARRAY_SIZE(cntry_locales);
> -	for (i = 0; i < size; i++) {
> -		if (strcmp(ccode, cntry_locales[i].abbrev) == 0)
> -			return &cntry_locales[i].country;
> -	}
> -	return NULL;
> -}
> +	const struct brcms_regd *regd = NULL;
> +	int i;
>  
> -static const struct country_info *
> -brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm, const char *ccode,
> -			char *mapped_ccode, uint *mapped_regrev)
> -{
> -	struct brcms_c_info *wlc = wlc_cm->wlc;
> -	const struct country_info *country;
> -	uint srom_regrev = wlc_cm->srom_regrev;
> -	const char *srom_ccode = wlc_cm->srom_ccode;
> -
> -	/* check for currently supported ccode size */
> -	if (strlen(ccode) > (BRCM_CNTRY_BUF_SZ - 1)) {
> -		wiphy_err(wlc->wiphy, "wl%d: %s: ccode \"%s\" too long for "
> -			  "match\n", wlc->pub->unit, __func__, ccode);
> -		return NULL;
> -	}
> -
> -	/* default mapping is the given ccode and regrev 0 */
> -	strncpy(mapped_ccode, ccode, BRCM_CNTRY_BUF_SZ);
> -	*mapped_regrev = 0;
> -
> -	/* If the desired country code matches the srom country code,
> -	 * then the mapped country is the srom regulatory rev.
> -	 * Otherwise look for an aggregate mapping.
> -	 */
> -	if (!strcmp(srom_ccode, ccode)) {
> -		*mapped_regrev = srom_regrev;
> -		wiphy_err(wlc->wiphy, "srom_code == ccode %s\n", __func__);
> -	}
> -
> -	/* find the matching built-in country definition */
> -	country = brcms_c_country_lookup_direct(mapped_ccode, *mapped_regrev);
> -
> -	/* if there is not an exact rev match, default to rev zero */
> -	if (country == NULL && *mapped_regrev != 0) {
> -		*mapped_regrev = 0;
> -		country =
> -		    brcms_c_country_lookup_direct(mapped_ccode, *mapped_regrev);
> +	for (i = 0; i < ARRAY_SIZE(cntry_locales); i++) {
> +		if (!strcmp(regdom, cntry_locales[i].regdomain->alpha2)) {
> +			regd = &cntry_locales[i];
> +			break;
> +		}
>  	}
>  
> -	return country;
> +	return regd;
>  }
>  
> -/* Lookup a country info structure from a null terminated country code
> - * The lookup is case sensitive.
> - */
> -static const struct country_info *
> -brcms_c_country_lookup(struct brcms_c_info *wlc, const char *ccode)
> +static const struct brcms_regd *brcms_default_world_regd(void)
>  {
> -	const struct country_info *country;
> -	char mapped_ccode[BRCM_CNTRY_BUF_SZ];
> -	uint mapped_regrev;
> -
> -	/*
> -	 * map the country code to a built-in country code, regrev, and
> -	 * country_info struct
> -	 */
> -	country = brcms_c_countrycode_map(wlc->cmi, ccode, mapped_ccode,
> -					  &mapped_regrev);
> -
> -	return country;
> +	return &cntry_locales[0];
>  }
>  
>  /*
> @@ -634,12 +606,6 @@ static bool brcms_c_japan_ccode(const char *ccode)
>  		(ccode[1] == 'P' || (ccode[1] >= '1' && ccode[1] <= '9')));
>  }
>  
> -/* Returns true if currently set country is Japan or variant */
> -static bool brcms_c_japan(struct brcms_c_info *wlc)
> -{
> -	return brcms_c_japan_ccode(wlc->cmi->country_abbrev);
> -}
> -
>  static void
>  brcms_c_channel_min_txpower_limits_with_local_constraint(
>  		struct brcms_cm_info *wlc_cm, struct txpwr_limits *txpwr,
> @@ -743,8 +709,8 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
>  		mboolset(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
>  		wiphy_err(wlc->wiphy, "wl%d: %s: no valid channel for \"%s\" "
>  			  "nbands %d bandlocked %d\n", wlc->pub->unit,
> -			  __func__, wlc_cm->country_abbrev, wlc->pub->_nbands,
> -			  wlc->bandlocked);
> +			  __func__, wlc_cm->world_regd->regdomain->alpha2,
> +			  wlc->pub->_nbands, wlc->bandlocked);
>  	} else if (mboolisset(wlc->pub->radio_disabled,
>  			      WL_RADIO_COUNTRY_DISABLE)) {
>  		/*
> @@ -753,15 +719,6 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
>  		 */
>  		mboolclr(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
>  	}
> -
> -	/*
> -	 * Now that the country abbreviation is set, if the radio supports 2G,
> -	 * then set channel 14 restrictions based on the new locale.
> -	 */
> -	if (wlc->pub->_nbands > 1 || wlc->band->bandtype == BRCM_BAND_2G)
> -		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
> -						     brcms_c_japan(wlc) ? true :
> -						     false);
>  }
>  
>  static int
> @@ -820,20 +777,13 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
>   * information found with the country code.
>   */
>  static void
> -brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
> -		       const char *country_abbrev,
> -		       const char *ccode, uint regrev,
> -		       const struct country_info *country)
> +brcms_c_set_country(struct brcms_cm_info *wlc_cm,
> +		    const struct brcms_regd *regd)
>  {
> +	const struct country_info *country = &regd->country;
>  	const struct locale_info *locale;
>  	struct brcms_c_info *wlc = wlc_cm->wlc;
>  
> -	/* save current country state */
> -	wlc_cm->country = country;
> -
> -	strncpy(wlc_cm->country_abbrev, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
> -	wlc_cm->regrev = regrev;
> -
>  	if ((wlc->pub->_n_enab & SUPPORT_11N) !=
>  	    wlc->protection->nmode_user)
>  		brcms_c_set_nmode(wlc);
> @@ -852,59 +802,11 @@ brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
>  	return;
>  }
>  
> -static int
> -brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
> -			const char *country_abbrev,
> -			const char *ccode, int regrev)
> -{
> -	const struct country_info *country;
> -	char mapped_ccode[BRCM_CNTRY_BUF_SZ];
> -	uint mapped_regrev;
> -
> -	/* if regrev is -1, lookup the mapped country code,
> -	 * otherwise use the ccode and regrev directly
> -	 */
> -	if (regrev == -1) {
> -		/*
> -		 * map the country code to a built-in country
> -		 * code, regrev, and country_info
> -		 */
> -		country =
> -		    brcms_c_countrycode_map(wlc_cm, ccode, mapped_ccode,
> -					&mapped_regrev);
> -	} else {
> -		/* find the matching built-in country definition */
> -		country = brcms_c_country_lookup_direct(ccode, regrev);
> -		strncpy(mapped_ccode, ccode, BRCM_CNTRY_BUF_SZ);
> -		mapped_regrev = regrev;
> -	}
> -
> -	if (country == NULL)
> -		return -EINVAL;
> -
> -	/* set the driver state for the country */
> -	brcms_c_set_country_common(wlc_cm, country_abbrev, mapped_ccode,
> -			       mapped_regrev, country);
> -
> -	return 0;
> -}
> -
> -/*
> - * set the driver's current country and regulatory information using
> - * a country code as the source. Lookup built in country information
> - * found with the country code.
> - */
> -static int
> -brcms_c_set_countrycode(struct brcms_cm_info *wlc_cm, const char *ccode)
> -{
> -	return brcms_c_set_countrycode_rev(wlc_cm, ccode, ccode, -1);
> -}
> -
>  struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
>  {
>  	struct brcms_cm_info *wlc_cm;
>  	struct brcms_pub *pub = wlc->pub;
> -	char *ccode;
> +	const char *ccode;
>  
>  	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
>  
> @@ -917,17 +819,29 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
>  
>  	/* store the country code for passing up as a regulatory hint */
>  	ccode = getvar(wlc->hw->sih, BRCMS_SROM_CCODE);
> -	if (ccode && brcms_c_country_valid(ccode))
> -		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
> +	if (ccode) {
> +		wlc_cm->world_regd = brcms_world_regd(ccode);
> +		if (brcms_c_country_valid(ccode))
> +			strncpy(wlc->pub->srom_ccode, ccode,
> +				BRCM_CNTRY_BUF_SZ - 1);
> +	}
> +
> +	/*
> +	 * If no custom world domain is found in the SROM, use the
> +	 * default "X2" domain.
> +	 */
> +	if (!wlc_cm->world_regd) {
> +		wlc_cm->world_regd = brcms_default_world_regd();
> +		ccode = wlc_cm->world_regd->regdomain->alpha2;
> +	}
>  
>  	/* save default country for exiting 11d regulatory mode */
> -	strncpy(wlc->country_default, "X2", BRCM_CNTRY_BUF_SZ - 1);
> +	strncpy(wlc->country_default, ccode, BRCM_CNTRY_BUF_SZ - 1);
>  
>  	/* initialize autocountry_default to driver default */
> -	strncpy(wlc->autocountry_default, wlc->country_default,
> -		BRCM_CNTRY_BUF_SZ - 1);
> +	strncpy(wlc->autocountry_default, ccode, BRCM_CNTRY_BUF_SZ - 1);
>  
> -	brcms_c_set_countrycode(wlc_cm, wlc->country_default);
> +	brcms_c_set_country(wlc_cm, wlc_cm->world_regd);
>  
>  	return wlc_cm;
>  }
> @@ -995,13 +909,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
>  
>  	memset(txpwr, 0, sizeof(struct txpwr_limits));
>  
> -	if (!brcms_c_valid_chanspec_db(wlc_cm, chanspec)) {
> -		country = brcms_c_country_lookup(wlc, wlc->autocountry_default);
> -		if (country == NULL)
> -			return;
> -	} else {
> -		country = wlc_cm->country;
> -	}
> +	country = &wlc_cm->world_regd->country;
>  
>  	chan = CHSPEC_CHANNEL(chanspec);
>  	band = wlc->bandstate[chspec_bandunit(chanspec)];
> @@ -1253,3 +1161,129 @@ bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm, u16 chspec)
>  {
>  	return brcms_c_valid_chanspec_ext(wlc_cm, chspec, true);
>  }
> +
> +bool brcms_is_radar_freq(u16 center_freq)
> +{
> +	return center_freq >= 5260 && center_freq <= 5700;

You can avoid this code if you/we do not add the channels to
wiphy->bands[IEEE80211_BAND_5GHZ]. The driver does not support DFS so we
better stay away from these channels, which was your original issue to
start this work if I recall correct :-( Sorry.

> +}
> +
> +static void brcms_reg_apply_radar_flags(struct wiphy *wiphy)
> +{
> +	struct ieee80211_supported_band *sband;
> +	struct ieee80211_channel *ch;
> +	int i;
> +
> +	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
> +	if (!sband)
> +		return;
> +
> +	for (i = 0; i < sband->n_channels; i++) {
> +		ch = &sband->channels[i];
> +
> +		if (!brcms_is_radar_freq(ch->center_freq))
> +			continue;
> +
> +		/*
> +		 * All channels in this range should be passive and have
> +		 * DFS enabled.
> +		 */
> +		if (!(ch->flags & IEEE80211_CHAN_DISABLED))
> +			ch->flags |= IEEE80211_CHAN_RADAR |
> +				     IEEE80211_CHAN_NO_IBSS |
> +				     IEEE80211_CHAN_PASSIVE_SCAN;
> +	}
> +}
> +
> +static void
> +brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
> +				enum nl80211_reg_initiator initiator)
> +{
> +	struct ieee80211_supported_band *sband;
> +	struct ieee80211_channel *ch;
> +	const struct ieee80211_reg_rule *reg_rule;
> +	int band, i, ret;
> +
> +	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> +		sband = wiphy->bands[band];
> +		if (!sband)
> +			continue;
> +
> +		for (i = 0; i < sband->n_channels; i++) {
> +			ch = &sband->channels[i];
> +
> +			if (brcms_is_radar_freq(ch->center_freq) ||
> +			    (ch->flags & IEEE80211_CHAN_RADAR))
> +				continue;
> +
> +			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
> +				ret = freq_reg_info(wiphy, ch->center_freq,
> +						    0, &reg_rule);
> +				if (ret)
> +					continue;
> +
> +				if (!(reg_rule->flags & NL80211_RRF_NO_IBSS))
> +					ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
> +				if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
> +					ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
> +			} else {
> +				if (ch->beacon_found)

can save one indent when using else if () immediately here.

> +					ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
> +						IEEE80211_CHAN_PASSIVE_SCAN);
> +			}
> +		}
> +	}
> +}
> +
> +static int brcms_reg_notifier(struct wiphy *wiphy,
> +			      struct regulatory_request *request)
> +{
> +	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
> +	struct brcms_info *wl = hw->priv;
> +	struct brcms_c_info *wlc = wl->wlc;
> +
> +	brcms_reg_apply_radar_flags(wiphy);
> +
> +	if (request && request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
> +		brcms_reg_apply_beaconing_flags(wiphy, request->initiator);
> +
> +	if (wlc->pub->_nbands > 1 || wlc->band->bandtype == BRCM_BAND_2G)
> +		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
> +					brcms_c_japan_ccode(request->alpha2));
> +
> +	return 0;
> +}
> +
> +void brcms_c_regd_init(struct brcms_c_info *wlc)
> +{
> +	struct wiphy *wiphy = wlc->wiphy;
> +	const struct brcms_regd *regd = wlc->cmi->world_regd;
> +	struct ieee80211_supported_band *sband;
> +	struct ieee80211_channel *ch;
> +	struct brcms_chanvec sup_chan;
> +	struct brcms_band *band;
> +	int band_idx, i;
> +
> +	/* Disable any channels not supported by the phy */
> +	for (band_idx = 0; band_idx < IEEE80211_NUM_BANDS; band_idx++) {
> +		if (band_idx == IEEE80211_BAND_2GHZ)
> +			band = wlc->bandstate[BAND_2G_INDEX];
> +		else
> +			band = wlc->bandstate[BAND_5G_INDEX];
> +		wlc_phy_chanspec_band_validch(band->pi, band->bandtype,
> +					      &sup_chan);
> +
> +		sband = wiphy->bands[band_idx];
> +		for (i = 0; i < sband->n_channels; i++) {
> +			ch = &sband->channels[i];
> +			if (!isset(sup_chan.vec, ch->hw_value))
> +				ch->flags |= IEEE80211_CHAN_DISABLED;
> +		}
> +	}
> +
> +	wlc->wiphy->reg_notifier = brcms_reg_notifier;
> +	wlc->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
> +			     WIPHY_FLAG_STRICT_REGULATORY;
> +	wiphy_apply_custom_regulatory(wlc->wiphy, regd->regdomain);
> +	brcms_reg_apply_radar_flags(wiphy);
> +	brcms_reg_apply_beaconing_flags(wiphy, NL80211_REGDOM_SET_BY_DRIVER);
> +}
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.h b/drivers/net/wireless/brcm80211/brcmsmac/channel.h
> index 808cb4f..dbe60ef 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/channel.h
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.h
> @@ -50,4 +50,6 @@ extern void brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm,
>  				     u16 chanspec,
>  				     u8 local_constraint_qdbm);
>  
> +extern void brcms_c_regd_init(struct brcms_c_info *wlc);
> +
>  #endif				/* _WLC_CHANNEL_H */
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> index aa15558..f26e93c 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> @@ -1059,6 +1059,8 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
>  		goto fail;
>  	}
>  
> +	brcms_c_regd_init(wl->wlc);
> +

can this be moved in brcms_c_channel_mgr_attach()?

>  	memcpy(perm, &wl->pub->cur_etheraddr, ETH_ALEN);
>  	if (WARN_ON(!is_valid_ether_addr(perm)))
>  		goto fail;

Gr. AvS


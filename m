Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41876 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZKPTsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 14:48:08 -0500
Date: Mon, 16 Nov 2009 14:48:12 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC] ath9k: properly use the mac80211 rate control api
Message-ID: <20091116194812.GA25188@bombadil.infradead.org>
References: <4B007D5D.6000801@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B007D5D.6000801@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 15, 2009 at 11:14:53PM +0100, Felix Fietkau wrote:
> This patch changes ath9k to pass proper MCS indexes and flags
> between the RC and the rest of the driver code.
> sc->cur_rate_table remains, as it's used by the RC code internally,
> but the rest of the driver code no longer uses it, so a potential
> new RC for ath9k would not have to update it.

Awesome! Some comments below.

> +static const struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX] = {
> +	[ATH9K_MODE_11A] = &ar5416_11a_ratetable,
> +	[ATH9K_MODE_11G] = &ar5416_11g_ratetable,
> +	[ATH9K_MODE_11NA_HT20] = &ar5416_11na_ratetable,
> +	[ATH9K_MODE_11NG_HT20] = &ar5416_11ng_ratetable,
> +	[ATH9K_MODE_11NA_HT40PLUS] = &ar5416_11na_ratetable,
> +	[ATH9K_MODE_11NA_HT40MINUS] = &ar5416_11na_ratetable,
> +	[ATH9K_MODE_11NG_HT40PLUS] = &ar5416_11ng_ratetable,
> +	[ATH9K_MODE_11NG_HT40MINUS] = &ar5416_11ng_ratetable,
> +};

It seems this is the only reason to keep around the
sc->cur_rate_table and cur_rate_mode. We could just remove
this array and sc->cur_rate_table and cur_rate_mode if we just
relied on the current wiphy->hw conf as we do in the hw code.

To make checks easier we could add helpers to mac80211.h for things
like:

ATH9K_MODE_11A --> conf_is_no_ht_5g()
ATH9K_MODE_11G --> conf_is_no_ht_2g()
ATH9K_MODE_11NA_HT20 --> conf_is_ht20_2g()
ATH9K_MODE_11NG_HT20] --> conf_is_ht20_5g()
ATH9K_MODE_11NA_HT40PLUS --> conf_is_ht40_plus_5g()
ATH9K_MODE_11NA_HT40MINUS --> conf_is_ht40_minus_5g()
ATH9K_MODE_11NG_HT40PLUS --> conf_is_ht40_plus_2g()
ATH9K_MODE_11NG_HT40MINUS --> conf_is_ht40_minus_2g()

Then we can just pass the iee80211_hw to rc.c and remove the
cur_rate_mode and cur_rate_table.

Then -- ath9k.h no longer needs to forward declare or even know
about struct ath_rate_table and we can keep that private to rc.c.

This could be done on a separate patch though.

> +static struct ieee80211_rate ath9k_legacy_rates[] = {
> +	{ .bitrate = 10,
> +	  .hw_value = 0x1b,
> +	  .flags = 0 },
> +	{ .bitrate = 20,
> +	  .hw_value = 0x1a,
> +	  .hw_value_short = 0x1a | 0x04,
> +	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate = 55,
> +	  .hw_value = 0x19,
> +	  .hw_value_short = 0x19 | 0x04,
> +	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate = 110,
> +	  .hw_value = 0x18,
> +	  .hw_value_short = 0x18 | 0x4,
> +	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
> +	{ .bitrate = 60,
> +	  .hw_value = 0x0b,
> +	  .flags = 0 },
> +	{ .bitrate = 90,
> +	  .hw_value = 0x0f,
> +	  .flags = 0 },
> +	{ .bitrate = 120,
> +	  .hw_value = 0x0a,
> +	  .flags = 0 },
> +	{ .bitrate = 180,
> +	  .hw_value = 0x0e,
> +	  .flags = 0 },
> +	{ .bitrate = 240,
> +	  .hw_value = 0x09,
> +	  .flags = 0 },
> +	{ .bitrate = 360,
> +	  .hw_value = 0x0d,
> +	  .flags = 0 },
> +	{ .bitrate = 480,
> +	  .hw_value = 0x08,
> +	  .flags = 0 },
> +	{ .bitrate = 540,
> +	  .hw_value = 0x0c,
> +	  .flags = 0 },
> +};
> +

Cool!  Hey so I had done something similar for ath9k_htc, feel free to
use:

/* Atheros hardware rate code addition for short premble */
#define SHPCHECK(__hw_rate, __flags) \
        ((__flags & IEEE80211_RATE_SHORT_PREAMBLE) ? (__hw_rate | 0x04 ) : 0)

#define RATE(_bitrate, _hw_rate, _flags) {              \
        .bitrate        = (_bitrate),                   \
        .flags          = (_flags),                     \
        .hw_value       = (_hw_rate),                   \
        .hw_value_short = (SHPCHECK(_hw_rate, _flags))  \
}

static struct ieee80211_rate ath9k_htc_ratetable[] = {
        RATE(10, 0x1b, 0),
        RATE(20, 0x1a, IEEE80211_RATE_SHORT_PREAMBLE), /* shortp : 0x1e */
        RATE(55, 0x19, IEEE80211_RATE_SHORT_PREAMBLE), /* shortp: 0x1d */
        RATE(110, 0x18, IEEE80211_RATE_SHORT_PREAMBLE), /* short: 0x1c */
        RATE(60, 0x0b, 0),
        RATE(90, 0x0f, 0),
        RATE(120, 0x0a, 0),
        RATE(180, 0x0e, 0),
        RATE(240, 0x09, 0),
        RATE(360, 0x0d, 0),
        RATE(480, 0x08, 0),
        RATE(540, 0x0c, 0),
};

>  static void ath_cache_conf_rate(struct ath_softc *sc,
>  				struct ieee80211_conf *conf)
>  {
>  	switch (conf->channel->band) {
>  	case IEEE80211_BAND_2GHZ:
>  		if (conf_is_ht20(conf))
> -			sc->cur_rate_table =
> -			  sc->hw_rate_table[ATH9K_MODE_11NG_HT20];
> +			sc->cur_rate_mode = ATH9K_MODE_11NG_HT20;
>  		else if (conf_is_ht40_minus(conf))
> -			sc->cur_rate_table =
> -			  sc->hw_rate_table[ATH9K_MODE_11NG_HT40MINUS];
> +			sc->cur_rate_mode = ATH9K_MODE_11NG_HT40MINUS;
>  		else if (conf_is_ht40_plus(conf))
> -			sc->cur_rate_table =
> -			  sc->hw_rate_table[ATH9K_MODE_11NG_HT40PLUS];
> +			sc->cur_rate_mode = ATH9K_MODE_11NG_HT40PLUS;
>  		else
> -			sc->cur_rate_table =
> -			  sc->hw_rate_table[ATH9K_MODE_11G];
> +			sc->cur_rate_mode = ATH9K_MODE_11G;
>  		break;
>  	case IEEE80211_BAND_5GHZ:
>  		if (conf_is_ht20(conf))
> -			sc->cur_rate_table =
> -			  sc->hw_rate_table[ATH9K_MODE_11NA_HT20];
> +			sc->cur_rate_mode = ATH9K_MODE_11NA_HT20;
>  		else if (conf_is_ht40_minus(conf))
> -			sc->cur_rate_table =
> -			  sc->hw_rate_table[ATH9K_MODE_11NA_HT40MINUS];
> +			sc->cur_rate_mode = ATH9K_MODE_11NA_HT40MINUS;
>  		else if (conf_is_ht40_plus(conf))
> -			sc->cur_rate_table =
> -			  sc->hw_rate_table[ATH9K_MODE_11NA_HT40PLUS];
> +			sc->cur_rate_mode = ATH9K_MODE_11NA_HT40PLUS;
>  		else
> -			sc->cur_rate_table =
> -			  sc->hw_rate_table[ATH9K_MODE_11A];
> +			sc->cur_rate_mode = ATH9K_MODE_11A;
>  		break;
>  	default:
>  		BUG_ON(1);

If we do the conf check on the hw struct we could end up removing this stuff.

> @@ -1833,19 +1816,22 @@ static int ath_init_softc(u16 devid, str
>  	/* setup channels and rates */
>  
>  	sc->sbands[IEEE80211_BAND_2GHZ].channels = ath9k_2ghz_chantable;
> -	sc->sbands[IEEE80211_BAND_2GHZ].bitrates =
> -		sc->rates[IEEE80211_BAND_2GHZ];
>  	sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
>  	sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
>  		ARRAY_SIZE(ath9k_2ghz_chantable);
> +	sc->sbands[IEEE80211_BAND_2GHZ].bitrates = ath9k_legacy_rates;
> +	sc->sbands[IEEE80211_BAND_2GHZ].n_bitrates =
> +		ARRAY_SIZE(ath9k_legacy_rates);
>  
>  	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes)) {
>  		sc->sbands[IEEE80211_BAND_5GHZ].channels = ath9k_5ghz_chantable;
> -		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
> -			sc->rates[IEEE80211_BAND_5GHZ];
>  		sc->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
>  		sc->sbands[IEEE80211_BAND_5GHZ].n_channels =
>  			ARRAY_SIZE(ath9k_5ghz_chantable);
> +		sc->sbands[IEEE80211_BAND_5GHZ].bitrates =
> +			ath9k_legacy_rates + 4;
> +		sc->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
> +			ARRAY_SIZE(ath9k_legacy_rates) - 4;
>  	}

We could also remove sc->sbands and just assign the sband for the hw
if appropriate, somethign like:

	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &ath9k_2ghz_sband;

But again, best on another patch.

>  struct ath_rate_table {
>  	int rate_cnt;
> +	int mcs_start;
>  	struct {
>  		int valid;
>  		int valid_single_stream;
> @@ -111,14 +112,12 @@ struct ath_rate_table {
>  		u32 ratekbps;
>  		u32 user_ratekbps;
>  		u8 ratecode;
> -		u8 short_preamble;
>  		u8 dot11rate;
>  		u8 ctrl_rate;
>  		u8 base_index;
>  		u8 cw40index;
>  		u8 sgi_index;
>  		u8 ht_index;
> -		u32 max_4ms_framelen;
>  	} info[RATE_TABLE_SIZE];
>  	u32 probe_interval;
>  	u8 initial_ratemax;

Do you think its possible to do this change in one patch and the rest in
another for easier review?

> --- a/drivers/net/wireless/ath/ath9k/beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
> @@ -65,9 +65,9 @@ static void ath_beacon_setup(struct ath_
>  	struct ath_common *common = ath9k_hw_common(ah);
>  	struct ath_desc *ds;
>  	struct ath9k_11n_rate_series series[4];
> -	const struct ath_rate_table *rt;
>  	int flags, antenna, ctsrate = 0, ctsduration = 0;
> -	u8 rate;
> +	struct ieee80211_supported_band *sband;
> +	u8 rate = 0;
>  
>  	ds = bf->bf_desc;
>  	flags = ATH9K_TXDESC_NOACK;
> @@ -91,10 +91,10 @@ static void ath_beacon_setup(struct ath_
>  
>  	ds->ds_data = bf->bf_buf_addr;
>  
> -	rt = sc->cur_rate_table;
> -	rate = rt->info[0].ratecode;
> +	sband = &sc->sbands[sc->hw->conf.channel->band];

The sc->hw *will not* be the current hw config but the first wiphy so this
could end up using the wrong hw config for a virtual wiphy. This should rely
on the aphy->hw instead of sc->hw, or the common->hw as that is updated when
the virtual ath9k wiphy changes. Using the aphy->hw seems best though, I suppose
we can pass the aphy on the routine as the caller has it.

Rest looks good so far, thanks!

  Luis

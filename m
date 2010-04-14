Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20649 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756458Ab0DNRaq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 13:30:46 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 14 Apr 2010 10:30:46 -0700
Date: Wed, 14 Apr 2010 10:30:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Holger Schurig <holgerschurig@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Anton Puolakka <Anton.Puolakka@7signal.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Survey mode volunteers
Message-ID: <20100414173044.GA2841@tux>
References: <0290AB2F0A8E124B9FFC144088A1A95609D6029647@EX-MBS04.nbl.local>
 <0290AB2F0A8E124B9FFC144088A1A95609D6096AB9@EX-MBS04.nbl.local>
 <20100412180424.GB2920@tux>
 <201004140911.11459.holgerschurig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201004140911.11459.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 14, 2010 at 12:11:11AM -0700, Holger Schurig wrote:
> I've some preliminary patch for ath5k.
> 
> ---
> Subject: [ath5k] add noise reporting to survey
> 
> Signed-off-by: Holger Schurig <holgerschurig@gmail.com>
> 
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> --- compat-wireless-2010-03-15.orig/drivers/net/wireless/ath/ath5k/base.c
> +++ compat-wireless-2010-03-15/drivers/net/wireless/ath/ath5k/base.c
> @@ -273,6 +273,8 @@ static int ath5k_set_key(struct ieee8021
>  		struct ieee80211_key_conf *key);
>  static int ath5k_get_stats(struct ieee80211_hw *hw,
>  		struct ieee80211_low_level_stats *stats);
> +static int ath5k_get_survey(struct ieee80211_hw *hw,
> +		int idx, struct survey_info *survey);
>  static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
>  static void ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf);
>  static void ath5k_reset_tsf(struct ieee80211_hw *hw);
> @@ -298,6 +300,7 @@ static const struct ieee80211_ops ath5k_
>  	.configure_filter = ath5k_configure_filter,
>  	.set_key 	= ath5k_set_key,
>  	.get_stats 	= ath5k_get_stats,
> +	.get_survey	= ath5k_get_survey,
>  	.conf_tx 	= NULL,
>  	.get_tsf 	= ath5k_get_tsf,
>  	.set_tsf 	= ath5k_set_tsf,
> @@ -3250,6 +3253,22 @@ ath5k_get_stats(struct ieee80211_hw *hw,
>  
>  	return 0;
>  }
> +
> +static int ath5k_get_survey(struct ieee80211_hw *hw, int idx,
> +		struct survey_info *survey)
> +{
> +	struct ath5k_softc *sc = hw->priv;
> +	struct ieee80211_conf *conf = &hw->conf;
> +
> +	 if (idx != 0)
> +		return -ENOENT;
> +
> +	survey->channel = conf->channel;
> +	survey->filled = SURVEY_INFO_NOISE_DBM;
> +	survey->noise = sc->ah->ah_noise_floor;
> +
> +	return 0;
> +}

Nice, it should be very similar for ath9k BTW, one enhancement which we've
been meanint to address but haven't had the time yet is to split noise floor
per channel. This can be seen how its done on the legacy HAL with the code
sprinkled with the ATH_NF_PER_CHAN ifdef.

  Luis


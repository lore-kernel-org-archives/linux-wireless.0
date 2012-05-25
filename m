Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3213 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab2EYWdp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 18:33:45 -0400
Message-ID: <4FC008BB.1020606@broadcom.com> (sfid-20120526_003347_743624_8DB7D1F4)
Date: Sat, 26 May 2012 00:33:31 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 5/8] brcm80211: smac: enable/disable radio on
 regulatory updates
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-6-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1334607462-5387-6-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 10:17 PM, Seth Forshee wrote:
> Currently the radio disable state is only updated during initialization,
> and it's only checked against the internal world domain. This is
> unnecessary, as there are always valid channels against this domain.
> Instead, check whether any channels are enabled in the regulatory
> notifier and update the radio state accordingly.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/channel.c |   66 ++++++++-------------
>  1 file changed, 25 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> index fd5b807..590e8c1 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
> @@ -681,46 +681,6 @@ brcms_c_channel_min_txpower_limits_with_local_constraint(
>  
>  }
>  
> -/* Update the radio state (enable/disable) and tx power targets
> - * based on a new set of channel/regulatory information
> - */
> -static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
> -{
> -	struct brcms_c_info *wlc = wlc_cm->wlc;
> -	uint chan;
> -
> -	/* search for the existence of any valid channel */
> -	for (chan = 0; chan < MAXCHANNEL; chan++) {
> -		if (brcms_c_valid_channel20_db(wlc->cmi, chan))
> -			break;
> -	}
> -	if (chan == MAXCHANNEL)
> -		chan = INVCHANNEL;
> -
> -	/*
> -	 * based on the channel search above, set or
> -	 * clear WL_RADIO_COUNTRY_DISABLE.
> -	 */
> -	if (chan == INVCHANNEL) {
> -		/*
> -		 * country/locale with no valid channels, set
> -		 * the radio disable bit
> -		 */
> -		mboolset(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
> -		wiphy_err(wlc->wiphy, "wl%d: %s: no valid channel for \"%s\" "
> -			  "nbands %d bandlocked %d\n", wlc->pub->unit,
> -			  __func__, wlc_cm->world_regd->regdomain->alpha2,
> -			  wlc->pub->_nbands, wlc->bandlocked);
> -	} else if (mboolisset(wlc->pub->radio_disabled,
> -			      WL_RADIO_COUNTRY_DISABLE)) {
> -		/*
> -		 * country/locale with valid channel, clear
> -		 * the radio disable bit
> -		 */
> -		mboolclr(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
> -	}
> -}
> -
>  static int
>  brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
>  		      const struct country_info *country)
> @@ -766,7 +726,6 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
>  	}
>  
>  	brcms_c_quiet_channels_reset(wlc_cm);
> -	brcms_c_channels_commit(wlc_cm);
>  
>  	return 0;
>  }
> @@ -1240,12 +1199,37 @@ static int brcms_reg_notifier(struct wiphy *wiphy,
>  	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
>  	struct brcms_info *wl = hw->priv;
>  	struct brcms_c_info *wlc = wl->wlc;
> +	struct ieee80211_supported_band *sband;
> +	struct ieee80211_channel *ch;
> +	int band, i, n_channels = 0;
>  
>  	brcms_reg_apply_radar_flags(wiphy);
>  
>  	if (request && request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
>  		brcms_reg_apply_beaconing_flags(wiphy, request->initiator);
>  
> +	/* Disable radio if all channels disallowed by regulatory */

I think we need to validate the channels against our phy as well. See
brcms_c_channels_init().

> +	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> +		sband = wiphy->bands[band];
> +		if (!sband)
> +			continue;
> +
> +		for (i = 0; i < sband->n_channels; i++) {
> +			ch = &sband->channels[i];
> +
> +			if (!(ch->flags & IEEE80211_CHAN_DISABLED))
> +				n_channels++;

could break here when a valid channel is found.

> +		}
> +	}
> +
> +	if (n_channels == 0) {
> +		mboolset(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
> +		wiphy_err(wlc->wiphy, "wl%d: %s: no valid channel for \"%s\"\n",
> +			  wlc->pub->unit, __func__, request->alpha2);
> +	} else {
> +		mboolclr(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
> +	}
> +
>  	if (wlc->pub->_nbands > 1 || wlc->band->bandtype == BRCM_BAND_2G)
>  		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
>  					brcms_c_japan_ccode(request->alpha2));

Gr. AvS


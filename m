Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573AbaAaNfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 08:35:22 -0500
Message-ID: <1391175318.4141.8.camel@jlt4.sipsolutions.net> (sfid-20140131_143539_812870_9C95CA18)
Subject: Re: [PATCH V6] mac80211: Update opmode during adding new station
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 31 Jan 2014 14:35:18 +0100
In-Reply-To: <1386252334-26696-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131205_150631_170209_F7B8D684)
References: <1386252334-26696-1-git-send-email-marek.kwaczynski@tieto.com>
	 (sfid-20131205_150631_170209_F7B8D684)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, I had somehow lost this patch before.

> +	if (params->opmode_notif_used) {
> +		enum ieee80211_band band =
> +				ieee80211_get_sdata_band(sdata);
> +		ieee80211_vht_recalc_handle_opmode(sdata, sta,
> +						   params->opmode_notif,
> +						   band, 0);
> +	}

That last argument should be 'false', it seems. You're also ignoring the
return value, which seems wrong at first look? Maybe it's right, but
then you should probably add a comment?

> +u32 ieee80211_vht_recalc_handle_opmode(struct ieee80211_sub_if_data *sdata,
> +				       struct sta_info *sta, u8 opmode,
> +				       enum ieee80211_band band, bool nss_only);
>  void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
>  				 struct sta_info *sta, u8 opmode,
>  				 enum ieee80211_band band, bool nss_only);

It's not clear to me what those function name distinction means, maybe
it would be better to not call this 'recalc' but just give it two
underscores in the function name or so, since it's really the same but
without calling the RC upate?

> -	struct ieee80211_local *local = sdata->local;
> -	struct ieee80211_supported_band *sband;
>  	enum ieee80211_sta_rx_bandwidth new_bw;
> -	u32 changed = 0;
>  	u8 nss;
> -
> -	sband = local->hw.wiphy->bands[band];
> +	u32 changed = 0;

Why change the order of nss/changed? If you leave as is the diff might
be simpler? Not that it matters, I was just wondering for a bit here
what was really changed on the 'changed' line.


>  		sta->sta.bandwidth = new_bw;
>  		changed |= IEEE80211_RC_BW_CHANGED;
>  	}
> +	return changed;

Would prefer a blank line after the }

> +void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
> +				 struct sta_info *sta, u8 opmode,
> +				 enum ieee80211_band band, bool nss_only)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
> +	u32 changed = ieee80211_vht_recalc_handle_opmode(sdata, sta, opmode,
> +							 band, nss_only);
> +	if (changed > 0)

And after the variable declarations, i.e. before the if

Sorry for the delay, not sure why I missed your patch!

johannes



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1KHUMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 15:12:10 -0500
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320780995-30483-2-git-send-email-greearb@candelatech.com> (sfid-20111108_203659_989707_E33ECA13)
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>
	 <1320780995-30483-2-git-send-email-greearb@candelatech.com>
	 (sfid-20111108_203659_989707_E33ECA13)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 21:12:08 +0100
Message-ID: <1320783128.24797.48.camel@jlt3.sipsolutions.net> (sfid-20111108_211213_875547_E1753A2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 11:36 -0800, greearb@candelatech.com wrote:

> +bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata)
> +{
> +	if ((sdata->u.mgd.ht_capa_mask.cap_info &
> +	     IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
> +	    !(sdata->u.mgd.ht_capa.cap_info &
> +	      IEEE80211_HT_CAP_SUP_WIDTH_20_40))
> +		return true;
> +	return false;

Would it really go above 80 cols if you didn't line-wrap it? Maybe
remove the extra sets of parentheses? And even if it goes to a little
bit above 80 it's still be more readable without the wrapping ...

One thing I don't quite understand: Why don't you calculate the HT caps
to use upon assoc request, and then store *those* instead, then you
wouldn't have to check the overrides every time.

For example here:

>  		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
> +		    !ieee80111_cfg_override_disables_ht40(sdata) &&
>  		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
>  		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
>  			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {

This just adds complexity. If you calculate sdata->used_ht_caps first
then you can replace the sband->ht_cap.cap check with an
sdata->used_ht_caps.cap check and be done with it, instead of having to
check both.

johannes


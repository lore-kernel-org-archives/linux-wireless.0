Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab1KCIr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 04:47:27 -0400
Subject: Re: [PATCH v3 3/3] mac80211: Allow overriding some HT information.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320299722-30113-3-git-send-email-greearb@candelatech.com> (sfid-20111103_065549_863747_7FFD5818)
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>
	 <1320299722-30113-3-git-send-email-greearb@candelatech.com>
	 (sfid-20111103_065549_863747_7FFD5818)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 09:47:25 +0100
Message-ID: <1320310045.3950.23.camel@jlt3.sipsolutions.net> (sfid-20111103_094731_958535_12EB3358)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 22:55 -0700, greearb@candelatech.com wrote:

> -void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
> +void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
> +				     struct ieee80211_sta_ht_cap *ht_cap,
> +				     int min_rates)
> +{
> +	u8 *scaps = (u8 *)(&sdata->u.mgd.ht_capa.mcs.rx_mask);
> +	u8 *smask = (u8 *)(&sdata->u.mgd.ht_capa_mask.mcs.rx_mask);
> +	int i;
> +
> +	/* check for HT over-rides, MCS rates first. */
> +	for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
> +		int q;
> +		for (q = 0; q < 8; q++) {
> +			/*
> +			 * We always need to advert at least MCS0-7, to
> +			 * be a compliant HT station, for instance
> +			 */
> +			if (((i * 8 + q) >= min_rates) &&
> +			    (smask[i] & (1<<q))) {
> +				if (!(scaps[i] & (1<<q))) {
> +					/*
> +					 * Can only disable rates, not force
> +					 * new ones
> +					 */
> +					ht_cap->mcs.rx_mask[i] &= ~(1<<q);
> +				}
> +			}
> +		}
> +	}
> +
> +	/* Force removal of HT-40 capabilities? */
> +	if (sdata->u.mgd.flags & IEEE80211_STA_DISABLE_HT40) {
> +		ht_cap->cap &= ~(IEEE80211_HT_CAP_SUP_WIDTH_20_40
> +				 | IEEE80211_HT_CAP_SGI_40);
> +	}

Here's another argument for splitting the patches differently -- this
ought to be part of the disable HT40 patch.

> +	/* Allow user to decrease AMPDU factor */
> +	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info &
> +	    IEEE80211_HT_AMPDU_PARM_FACTOR) {
> +		u16 n = sdata->u.mgd.ht_capa.ampdu_params_info
> +			& IEEE80211_HT_AMPDU_PARM_FACTOR;
> +		if (n < ht_cap->ampdu_factor)
> +			ht_cap->ampdu_factor = n;
> +	}
> +
> +	/* Set the AMPDU density. */
> +	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info &
> +	    IEEE80211_HT_AMPDU_PARM_DENSITY)
> +		ht_cap->ampdu_density =
> +			(sdata->u.mgd.ht_capa.ampdu_params_info &
> +			 IEEE80211_HT_AMPDU_PARM_DENSITY)
> +			>> IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT;
> +}

The AMPDU density should only allow increasing.

I think a lot of this validation should live in cfg80211 so if another
driver wants to implement it, this kind of thing is already covered.

> +	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
> +	/*
> +	 * This is for an association attempt, and stations must
> +	 * support at least the first 8 MCS rates.  See section 20.1.1
> +	 * of the 802.11n spec for details.
> +	 */

I think cfg80211 should probably just reject other configuration
attempts.

> +       [NL80211_ATTR_HT_CAPABILITY_MASK] = {
> +               .type = NLA_BINARY,
> +               .len = NL80211_HT_CAPABILITY_LEN
> +       },

My mistake -- remove the type, it should be just the length for proper
checking.


I think there's a lot of data in the ht_cap struct that you don't use,
is that right? If so you should reject it being configured. I'm also not
quite sure why you support both disable-HT40, and then this setting here
that has SUP_WIDTH_20_40 too.

I'm more and more coming to the conclusion that it would be clearer to
make separate configuration items for the various things. Most
capabilities you could only disable (greenfield, ...) except for maybe
40mhz-intol, so maybe that would be easier as a separate u16 attribute
"disable these HT capabilities"?

johannes


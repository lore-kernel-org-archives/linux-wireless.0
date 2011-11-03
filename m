Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56731 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab1KCRNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 13:13:54 -0400
Message-ID: <4EB2CBCC.6080709@candelatech.com> (sfid-20111103_181356_841089_4D88D032)
Date: Thu, 03 Nov 2011 10:13:48 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mac80211: Allow overriding some HT information.
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>  <1320299722-30113-3-git-send-email-greearb@candelatech.com>  (sfid-20111103_065549_863747_7FFD5818) <1320310045.3950.23.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320310045.3950.23.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 01:47 AM, Johannes Berg wrote:
> On Wed, 2011-11-02 at 22:55 -0700, greearb@candelatech.com wrote:
>
>> -void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
>> +void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
>> +				     struct ieee80211_sta_ht_cap *ht_cap,
>> +				     int min_rates)
>> +{
>> +	u8 *scaps = (u8 *)(&sdata->u.mgd.ht_capa.mcs.rx_mask);
>> +	u8 *smask = (u8 *)(&sdata->u.mgd.ht_capa_mask.mcs.rx_mask);
>> +	int i;
>> +
>> +	/* check for HT over-rides, MCS rates first. */
>> +	for (i = 0; i<  IEEE80211_HT_MCS_MASK_LEN; i++) {
>> +		int q;
>> +		for (q = 0; q<  8; q++) {
>> +			/*
>> +			 * We always need to advert at least MCS0-7, to
>> +			 * be a compliant HT station, for instance
>> +			 */
>> +			if (((i * 8 + q)>= min_rates)&&
>> +			    (smask[i]&  (1<<q))) {
>> +				if (!(scaps[i]&  (1<<q))) {
>> +					/*
>> +					 * Can only disable rates, not force
>> +					 * new ones
>> +					 */
>> +					ht_cap->mcs.rx_mask[i]&= ~(1<<q);
>> +				}
>> +			}
>> +		}
>> +	}
>> +
>> +	/* Force removal of HT-40 capabilities? */
>> +	if (sdata->u.mgd.flags&  IEEE80211_STA_DISABLE_HT40) {
>> +		ht_cap->cap&= ~(IEEE80211_HT_CAP_SUP_WIDTH_20_40
>> +				 | IEEE80211_HT_CAP_SGI_40);
>> +	}
>
> Here's another argument for splitting the patches differently -- this
> ought to be part of the disable HT40 patch.

One thing I could do is move patch 3 to be the first patch.  That gives this method
reason to exist, but I can leave out the disable-HT40 parts and (re)add that in
the disable-ht40 patch.

>> +	/* Allow user to decrease AMPDU factor */
>> +	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info&
>> +	    IEEE80211_HT_AMPDU_PARM_FACTOR) {
>> +		u16 n = sdata->u.mgd.ht_capa.ampdu_params_info
>> +			&  IEEE80211_HT_AMPDU_PARM_FACTOR;
>> +		if (n<  ht_cap->ampdu_factor)
>> +			ht_cap->ampdu_factor = n;
>> +	}
>> +
>> +	/* Set the AMPDU density. */
>> +	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info&
>> +	    IEEE80211_HT_AMPDU_PARM_DENSITY)
>> +		ht_cap->ampdu_density =
>> +			(sdata->u.mgd.ht_capa.ampdu_params_info&
>> +			 IEEE80211_HT_AMPDU_PARM_DENSITY)
>> +			>>  IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT;
>> +}
>
> The AMPDU density should only allow increasing.
>
> I think a lot of this validation should live in cfg80211 so if another
> driver wants to implement it, this kind of thing is already covered.

The ath9k driver supports 0, and then every value that corresponds to 1us or higher.
If you set it to 1/2us, for instance, it just quietly rounds up to 1us.  It defaults
to 8, so it appears valid to decrease or increase this value.

So, we'd either need to have cfg80211 somehow query the driver for valid
settings to do precise checks on what is valid or not.

I think at some point, for esoteric settings such as this, the user is
just going to have to be somewhat aware of what their hardware is capable
of.

>> +	memcpy(&ht_cap,&sband->ht_cap, sizeof(ht_cap));
>> +	/*
>> +	 * This is for an association attempt, and stations must
>> +	 * support at least the first 8 MCS rates.  See section 20.1.1
>> +	 * of the 802.11n spec for details.
>> +	 */
>
> I think cfg80211 should probably just reject other configuration
> attempts.

It's valid to force a lower rate (mcs-1, for instance), but we just need to
advertise that we support mcs0-7.  We *could* allow individually setting
advertise-mcs-rates v/s allow-mcs-rates, but that may be useful to exactly
no one :)

>
>> +       [NL80211_ATTR_HT_CAPABILITY_MASK] = {
>> +               .type = NLA_BINARY,
>> +               .len = NL80211_HT_CAPABILITY_LEN
>> +       },
>
> My mistake -- remove the type, it should be just the length for proper
> checking.
>
>
> I think there's a lot of data in the ht_cap struct that you don't use,
> is that right? If so you should reject it being configured. I'm also not
> quite sure why you support both disable-HT40, and then this setting here
> that has SUP_WIDTH_20_40 too.

If I add rejection like this, it will make writing backwards compat user
space very difficult.  It would be similar to rejecting unknown netlink
attributes, for instance.

I was thinking that if ht-40 is disabled, then I should clear both the
IEEE80211_HT_CAP_SUP_WIDTH_20_40 and the IEEE80211_HT_CAP_SGI_40 from
the capabilities.  Perhaps there are other flags I should clear as well?

> I'm more and more coming to the conclusion that it would be clearer to
> make separate configuration items for the various things. Most
> capabilities you could only disable (greenfield, ...) except for maybe
> 40mhz-intol, so maybe that would be easier as a separate u16 attribute
> "disable these HT capabilities"?

It seemed like more work for not much gain to me, but I don't mind splitting
it out into separate netlink configurables if you want.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56895 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab1KHXLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 18:11:12 -0500
Message-ID: <4EB9B70B.6000406@candelatech.com> (sfid-20111109_001115_794198_B5DC4BB2)
Date: Tue, 08 Nov 2011 15:11:07 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8 2/2] mac80211:  Support ht-cap over-rides.
References: <1320780995-30483-1-git-send-email-greearb@candelatech.com>  <1320780995-30483-2-git-send-email-greearb@candelatech.com>  (sfid-20111108_203659_989707_E33ECA13) <1320783128.24797.48.camel@jlt3.sipsolutions.net>  <4EB99812.3000507@candelatech.com> <1320786130.24797.78.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320786130.24797.78.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 01:02 PM, Johannes Berg wrote:
> On Tue, 2011-11-08 at 12:58 -0800, Ben Greear wrote:
>
>>>> +bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata)
>>>> +{
>>>> +	if ((sdata->u.mgd.ht_capa_mask.cap_info&
>>>> +	     IEEE80211_HT_CAP_SUP_WIDTH_20_40)&&
>>>> +	    !(sdata->u.mgd.ht_capa.cap_info&
>>>> +	      IEEE80211_HT_CAP_SUP_WIDTH_20_40))
>>>> +		return true;
>>>> +	return false;
>>>
>>> Would it really go above 80 cols if you didn't line-wrap it? Maybe
>>> remove the extra sets of parentheses? And even if it goes to a little
>>> bit above 80 it's still be more readable without the wrapping ...
>>
>> It is more readable w/out the wrapping, but hard to know when
>> patches get rejected about that or not, so I tried to keep
>> checkpatch happy.  If you'll take slightly longer lines I'll
>> happily un-wrap it.
>
> Please. I'd rather go over a bit than read the above :-)

I just fixed this by using a tmp variable.  Hopefully the
compiler is smart enough to make it disappear.

>>> For example here:
>>>
>>>>    		if (!(ap_ht_cap_flags&   IEEE80211_HT_CAP_40MHZ_INTOLERANT)&&
>>>> +		    !ieee80111_cfg_override_disables_ht40(sdata)&&
>>>>    		(sband->ht_cap.cap&   IEEE80211_HT_CAP_SUP_WIDTH_20_40)&&
>>>>    		(hti->ht_param&   IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
>>>>    			switch(hti->ht_param&   IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
>>>
>>> This just adds complexity. If you calculate sdata->used_ht_caps first
>>> then you can replace the sband->ht_cap.cap check with an
>>> sdata->used_ht_caps.cap check and be done with it, instead of having to
>>> check both.
>>
>> I think that's a bad idea, but will change it if you insist.
>
> I really think that'd be much nicer. As it is now we have to add all
> these checks everywhere, if we just calculate it once and then change
> places to use it we just have to remember to use the right thing.

I'm quite nervous about attempting this change.  I'm pretty
confident my current patch works as designed, and over all,
it's pretty non-intrusive.  I am afraid that if I start trying
to substitute something for sband->ht_cap that I'm going
to end up changing a lot of code and possibly adding all sorts
of strange bugs.

Out of curiousity, if one is doing off-channel work, wouldn't
sband be different from when we associated and possibly different
in it's ht-capabilities?  If so, the used-ht-caps would not
be valid for that work?

I'm posting a v9 with just the minimum MCS rates stuff removed
and some formatting cleanup.

If this used-ht-caps stuff is required, I'll see
what I can do.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


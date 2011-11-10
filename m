Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55294 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab1KJTZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:25:17 -0500
Message-ID: <4EBC2516.4080807@candelatech.com> (sfid-20111110_202523_539728_DDF7BDF2)
Date: Thu, 10 Nov 2011 11:25:10 -0800
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

I rebased against today's wireless-testing tree and started work on this.

But, I don't think it is going to work..or at least if it can, I
don't see a good way to do it.

I'm stuck in the ieee80211_ht_cap_ie_to_sta_ht_cap method.  With
my original patch, I apply overrides here, at the bottom of the
method.  If we're associated (or started associating)
and user asked for over-rides, we'll apply requested overrides, else
nothing will change because the over-rides mask is not set.

But, if I have to use pre-computed values here then I need to
be certain they are set properly.  If association has been
requested, then that is fine.  But, what about the
sta_apply_parameters() method?  Can we guarantee that association has
been requested when this method is called?  I think we cannot,
and if not, then I cannot use pre-computed sdata->used_ht_caps.
I could attempt to set a flag when used_ht_caps
has been calculated, and add a check for that, but that is yet another piece
of computed state that could be stale if we make a mistake somewhere.

There is another caller in mesh_plink.c: mesh_plink_alloc()
I don't know much of anything about mesh, but I think we will always be
associated here.  The callers in mlme.c should always be associated as
far as I can tell.

The ieee80211_add_ht_ie method appears to be called when association is
already started, so it should be ok to use a derived value (it is
called only from send_assoc()).

If you prefer the additional-flag-if-already-calculated approach,
let me know and I'll continue on this path.  Or, if I'm confused
about the sta_apply_parameters path and it *is* always set?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


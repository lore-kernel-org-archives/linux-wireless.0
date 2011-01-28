Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39444 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1A1SsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 13:48:03 -0500
Message-ID: <4D430F5E.8080805@candelatech.com>
Date: Fri, 28 Jan 2011 10:47:58 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3] mac80211:  Optimize scans on current operating channel.
References: <1296074238-4012-1-git-send-email-greearb@candelatech.com>	 <1296136347.3622.55.camel@jlt3.sipsolutions.net>	 <4D41A895.4060304@candelatech.com> <1296221067.5118.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296221067.5118.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2011 05:24 AM, Johannes Berg wrote:
> On Thu, 2011-01-27 at 09:17 -0800, Ben Greear wrote:
>
>>>> +	if (local->scan_channel) {
>>>> +		chan = local->scan_channel;
>>>> +		channel_type = NL80211_CHAN_NO_HT;
>>>> +	} else if (local->tmp_channel) {
>>>> +		chan = scan_chan = local->tmp_channel;
>>>> +		channel_type = local->tmp_channel_type;
>>>> +	} else {
>>>> +		chan = local->oper_channel;
>>>> +		channel_type = local->_oper_channel_type;
>>>> +	}
>>>
>>> Don't understand -- why not return true in the else branch?
>>
>> Because the hardware might not actually be set to the oper_channel.
>> The idea is that you configure the mac80211 state as you want it, and then
>> use this method to figure out if you really need to make hardware
>> changes.
>
> Oh. Wouldn't it make more sense to stick that into the _config()
> function then and return something there? Hmm. I kinda start to
> understand I guess.

The code is similar..seems like it could be put into a common helper
method, but I haven't thought of a clean way to do that yet.

>>>> +	if (chan != local->oper_channel ||
>>>> +	    channel_type != local->_oper_channel_type)
>>>> +		return false;
>>>> +
>>>> +	/* Check current hardware-config against oper_channel. */
>>>> +	if ((local->oper_channel != local->hw.conf.channel) ||
>>>> +	    (local->_oper_channel_type != local->hw.conf.channel_type))
>>>> +		return false;
>>>
>>> That's confusing, and kinda racy IIRC?
>>
>> This method should be locked such that the hardware conf
>> cannot be changed while it is being called.  I can double
>> check that this is true.
>
> Not all of this is always properly locked unfortunately. Not sure about
> this case though.

On that note:  It seems to me that __ieee80211_scan_completed_finish
must grab the mutex_lock(&local->mtx); early in this method, before
any calls to ieee80211_hw_config, for instance.  I believe this would
be an issue in both my patch and the existing code.  I'm adding code
to grab it early, but still release after recalc_idle() is called.
I'll test it with lockdep enabled to make sure it's at least mostly
sane.

>>> Also, won't this do some weird things like not stop, but try to start
>>> stations again?
>>
>> I was thinking that should be harmless.  As far as I can tell, current
>> code would never actually stop beaconing in this method but might try
>> to start it later, so it must not cause too much trouble.
>
> Yeah, maybe you're right and it doesn't matter, but I think it'd be
> nicer to always nest the calls. I see you've done that already.

Yeah, the v5 patch was better about this.  The code is still complex,
but perhaps we'll think of something simpler down the road.

I'll post a v6 soon, with the earlier mutex grab I mention above
and the debug stuff removed.

Hopefully it's getting close!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


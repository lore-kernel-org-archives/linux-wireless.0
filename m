Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55511 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947965AbcBRU7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 15:59:36 -0500
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when building
 IEs.
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
 <1453807009.2759.23.camel@sipsolutions.net>
 <56A78E8F.1080505@candelatech.com> <1454576521.2564.6.camel@sipsolutions.net>
 <56B38FD1.40902@candelatech.com> <1455827536.2084.35.camel@sipsolutions.net>
 <56C62C4E.7020600@candelatech.com>
 <1455828330.2084.38.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56C630B7.7020604@candelatech.com> (sfid-20160218_220008_705509_EE394C1A)
Date: Thu, 18 Feb 2016 12:59:35 -0800
MIME-Version: 1.0
In-Reply-To: <1455828330.2084.38.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2016 12:45 PM, Johannes Berg wrote:
> On Thu, 2016-02-18 at 12:40 -0800, Ben Greear wrote:
>
>>> 1) sdata->sband[5GHZ].vht = wiphy->sband[5GHZ].vht & user-config
>>>      (semantically, not implementation of course)
>>> 2) sdata->sband[5GHZ].vht = wiphy->sband[5GHZ].vht
>
>> I think option 1 might be better.  For option 2, I'd be worried about
>> someone changing the wiphy somehow and vdevs getting out of sync.
>
> Huh? I'm confused. Those two options above weren't meant as options,
> they were meant as two sides of an "if (have-user-config)" branch :)

Oh.  In that case, what if this happens:

wiphy created and init
vdev created, vht copied from wiphy
....
wiphy vht info changes?  Can this ever happen?  I'm thinking maybe when
  a user uses 'iw' to set the rx/rx chainmask on a phy?  Possibly nasty
debugfs hacks that have worked so far?

I wouldn't want to try to re-propagate that to already-created vdevs.

So, I think it should be more like:

if (vdata->have-user-config) {
   return sdata->user_config_vht & sdata->wiphy->vht;
}
else {
   return sdata->wiphy->vht;
}

Point of the above 'code' is that we do not want to ever have duplicate
state (ie, a copy of wiphy->vht in sdata->vht, because then they can get out
of sync.  But, we can have a set of over-ride data in sdata, and since we logically
AND that with wiphy data, then we should never exceed the capabilities of either
sdata or wiphy.

That make sense?

>
>> Any opinions on the lifetime for the sdata->sband_user_config data?
>>
>> For instance, could be cleared when station dis-associates,
>> or we could make it persist until changed or until vdev goes away?
>
> Should probably persist.

That is fine with me, would make supplicant patches easier than my method,
probably.

>
>> And, while this would take care of some of the issues (3x3 vs 2x2?),
>> it still wouldn't let someone have full control over the advertised
>> rates vs configured-rates and such, would it?
>
> Why not? The sband also contains the rates list. I was just using VHT
> as an example.

Ok, the details of mac80211 have leaked out of my skull since the start
of this thread...I'll see if I can make a stab at implementing this
proposal.  But, likely it will be a bit, as I'm swamped with other things
at the moment.  If someone else is interested in trying this,
then of course be my guest!

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


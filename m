Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57701 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab3EHSO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 14:14:58 -0400
Message-ID: <518A9618.1020107@candelatech.com> (sfid-20130508_201519_965449_CFD5BB8A)
Date: Wed, 08 May 2013 11:14:48 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211:  3.9.0+:  Invalid WDS/flush state and non-connecting
 station.
References: <5182C38B.7060107@candelatech.com>   (sfid-20130502_215043_578677_76592D19) <1367526288.11375.2.camel@jlt4.sipsolutions.net>  <5182D078.4020605@candelatech.com> <518A7AD4.2060100@candelatech.com> <1368035937.8279.25.camel@jlt4.sipsolutions.net>
In-Reply-To: <1368035937.8279.25.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2013 10:58 AM, Johannes Berg wrote:
> On Wed, 2013-05-08 at 09:18 -0700, Ben Greear wrote:
>
>> Ok, I reproduced this with yet more debugging printouts in the kernel.
>>
>> The symptom is this:
>>
>> The sme_state is SME_CONNECTED, so it bails out below before sending the
>> 'connected' message to user-space.
>
> Is your system being really really really slow and/or are threads
> getting pre-empted a lot? This maybe seem like a bit of a stretch, but
> it seems possible that this happens:
>
> ieee80211_sta_rx_queued_mgmt() is running, possibly on one CPU, and is
> somewhere between printing "associated" and calling
> cfg80211_send_rx_assoc() (or in the call already, before taking the lock
> though.)
>
> Then your interface is set down at the same time, possibly on a
> different CPU. Here's where the scenario gets stretched, clearly your
> interface is getting set down over a minute later, I don't see how you
> could have stalled the other thread for that long.
>
> But if you did, then that thread is still processing things while the
> interface is going down, cfg80211 didn't know anything about the
> association having completed so it won't have disconnected, etc.
>
> So far, I haven't found any other scenario, nor a solution.

It is not that slow or overloaded (at least most of the time,
and in particular, I only had 20 virtual stations up on this system
not doing much traffic...it easily handles 100's of stations).

And, once it gets in this state..it stays there (overnight,
with my app resetting the port (via 'ip link set down' and
poking at wpa_supplicant) every minute or so in this case.

I was wondering..in the cfg80211_mlme_down method (or perhaps
some place similar), should we force sme state to IDLE
with a big WARN_ON_ONCE or similar.

That way, if it does get stuck somehow, we can recover by
downing the interface and bringing it back up?

For what it's worth, I don't recall ever seeing this problem
in 5.7, but it's way to rare to be able to bisect...

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


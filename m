Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40502 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdJRVal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 17:30:41 -0400
Subject: Re: Setting single rate in ath10k broken by "reject/clear user rate
 mask if not usable"
To: Johannes Berg <johannes@sipsolutions.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, kirtika@google.com
References: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com>
 <1507708948.1998.15.camel@sipsolutions.net>
 <2c293255-aa79-75a0-1c28-994f864cddf4@candelatech.com>
 <1508312033.2674.9.camel@sipsolutions.net>
 <2ad42671-59c4-80ed-4bca-f874eb53d653@candelatech.com>
 <8c2e0e98-f3f4-6e0c-1bf0-43dfa6e97275@rempel-privat.de>
 <1508358869.2674.55.camel@sipsolutions.net>
 <9791c86a-a15f-4c99-ab84-ce00b242d70f@candelatech.com>
 <1508360527.2674.61.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <0bfb289d-a9fa-03d9-f9c7-cc0d01b0bd43@candelatech.com> (sfid-20171018_233044_398379_60875C71)
Date: Wed, 18 Oct 2017 14:30:38 -0700
MIME-Version: 1.0
In-Reply-To: <1508360527.2674.61.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2017 02:02 PM, Johannes Berg wrote:
> On Wed, 2017-10-18 at 13:51 -0700, Ben Greear wrote:
>> "
>> I guess you could implement this part? I.e. iterating the clients and
>> checking that they all support the rate that is set. However, then you
>> also need to implement that this gets reset when a new client that
>> doesn't support this rate connects.
>> "
>>
>> The first part seems OK, but the second seems like a pain.  Maybe just
>> keep a new client from being able to connect at all if it doesn't support
>> any available rates?
>
> I suppose if you reject the NEW_STATION command, then hostapd will
> reject the association though, so it's probably not hard to do.
> However, I'm not really sure why you'd want that? If you do want that
> then basically you're just implemented a very roundabout way of adding
> this rate to the basic rates, so you might as well just add it and work
> with the current basic rates check?

If a user specifies a specific rate or rate-set, then I do not think we
should quietly change it out from under them.  So, we could check at the
time the rate-set is applied (all current peers).  We can reject the change
at that point if one of the peers does not support any common rates.
And, whenever a peer tries to be associated, we can check that there is some common rateset
in place.  If there is no common rateset, then reject the association
one way or another.

> We'll need to be a little careful what happens with client-mode
> interfaces, which is where we actually observed hitting the WARN_ON()
> about not having any rates at all, but I think I already put a reset of
> the rates there anyway if they're not compatible with the AP. At least
> that's easier because there's only one client.

It would be easy to configure a station to do VHT MCS 8 only, and then
it would never be able to associate with an HT AP, for instance.  I don't
think this should be a WARN_ON event, just a failure.  It would be great
if we could get a useful error message back to the caller, but I am not
sure how feasible that is with the current netlink and mac80211 code.

If your main concern is hitting a WARN_ON, maybe just change it to a
quieter error message or remove it entirely and just return a failure
code?

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

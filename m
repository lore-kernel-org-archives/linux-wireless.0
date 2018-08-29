Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36849 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbeH2SNg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 14:13:36 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC v2 2/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <1535539202.5215.32.camel@sipsolutions.net>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1> <153115422499.7447.2570671473822724496.stgit@alrua-x1> <1535528658.5215.19.camel@sipsolutions.net> <877ek94j66.fsf@toke.dk> <1535537670.5215.26.camel@sipsolutions.net> <87y3cp31ik.fsf@toke.dk> <1535539202.5215.32.camel@sipsolutions.net>
Date: Wed, 29 Aug 2018 16:16:25 +0200
Message-ID: <87va7t2r7q.fsf@toke.dk> (sfid-20180829_161633_561596_0E4CE060)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> > Perhaps then it should just be fractional? i.e. 8.8 bits or so?, so
>> > the default would be 1.0 (0x0100) and then you could scale down to 0.5
>> > (0x0080) etc?
>> 
>> Hmm, that's an interesting idea. I'll have to run some numbers to see
>> how the precision holds up on various examples; but that would allow us
>> to get rid of the quantum in the userspace API entirely, which is a good
>> thing as far as I'm concerned!
>
> :-)
>
> We can always go to 32 bits and then we have lots to play with? It's 16
> bits right now so I picked 8.8 for no real reason - in fact that seems
> quite pointless since dividing 300us by 256 gives you only just over 1us
> which is really short.
>
> So perhaps 12.4 (minimum 18 usec) is more appropriate?
>
> But perhaps I'm just completely mistaken and you don't really want to be
> able to scale the quantum down further at all, and so you have to play
> with all the stations anyway?
>
> No idea, really, how you'd use this.

I have a patch set for hostapd that will allow a user to configure
priorities (I can send you the paper if you want details). The obvious
thing is just to prioritise a specific station by mac address ("give my
TV twice the airtime so it can stream even though it's too far away from
AP"). But the more interesting thing is the dynamic prioritisation
(e.g., "these two SSIDs should share equally no matter how many clients
they have"). For that, group weights need to be calculated and turned
into station weights by dividing with the number of active stations per
group. I've been using integer weights and scaling in userspace, but if
we just express it as fractions in the netlink API that need would go
away.

Hmm, I'll think about which mode is easier :)
>
>> > > For the drivers that get airtime as part of TX completion, sure; but as
>> > > I understand it, at least ath10k gets airtime information in out of band
>> > > status reports, so there would need to be a callback for that in any
>> > > case...
>> > 
>> > Hmm, ok, but perhaps then we should also tie those to the existing
>> > airtime things?
>> 
>> Eh? Tie what to which existing airtime things?
>
> At least WMM-AC: ieee80211_sta_tx_wmm_ac_notify().

Gotcha; will look at that as well.

-Toke

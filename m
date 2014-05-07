Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42093 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaEGJFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 05:05:04 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so5961633wiw.15
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 02:05:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399449912.5038.7.camel@jlt4.sipsolutions.net>
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-3-git-send-email-michal.kazior@tieto.com>
	<1399387345.4218.44.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=FqfB46Bd6iC3F=Ps=b4f6CP77p5d6f4fiVLUttCYQjg@mail.gmail.com>
	<1399449912.5038.7.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 11:05:02 +0200
Message-ID: <CA+BoTQnJ7N=UtDu_tySg8uYrQg9i+BvuYrwez7x-LUVinroWDw@mail.gmail.com> (sfid-20140507_110510_972338_B83245BF)
Subject: Re: [PATCH v4 2/5] mac80211: use chanctx reservation for AP CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2014 10:05, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-07 at 09:25 +0200, Michal Kazior wrote:
>
>> > Should csa_active really stay true in the reserved_chanctx case?
>> > Wouldn't that leave it beaconing, with potentially suddenly negative
>> > (due to underflow) CSA counter, or something?
>>
>> Hmm.. I think drivers should check ieee80211_csa_is_complete() before
>> calling to ieee80211_beacon_get(). At least that's what ath9k and
>> ath10k effectively do now. Hwsim might complain though but this should
>> be changed for multi-vif CSA. You may need to wait for other vifs to
>> finish CS (the incompat case) so you shouldn't call
>> ieee80211_beacon_get() after you get last CSA beacon on a given AP
>> vif.
>
> I don't think that works for all drivers - only drivers that actually
> generate and tx each beacon - but other drivers just update a template.
> We actually have some pending patches to make that work correctly for
> the CSA counters, but I'm not really sure what you want to happen in the
> case that one is switching while the other hasn't yet? Should it stop
> beaconing? Seems like clients would give up the switch then, no?

Ah, I completely forgot about the template-based approach.

But I don't think any beacons should be sent after cs_count=1 on the
old channel either way. Thus, I would expect template-based drivers to
stop beaconing after cs_count=1. cs_count=0 is a separate case as it
means "i can disappear at any time now" and is a special case, not
what happens after reaching cs_count=1 if I remember correctly.

Clients should expect next beacon to appear on the new channel after
seeing beacon with cs_count=1. In that case regular cqm for clients
should apply.

Real-world multi-vif CSA will probably be off by up to 1 or 2 beacon
intervals between vifs which should be disruptive for clients I guess.


Michał

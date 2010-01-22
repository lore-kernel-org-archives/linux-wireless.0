Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:55301 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab0AVXpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 18:45:02 -0500
Received: by qyk32 with SMTP id 32so941346qyk.4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 15:45:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264189560.2593.14.camel@johannes.local>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	<1264186981.2593.10.camel@johannes.local> <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
	<1264189560.2593.14.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Jan 2010 15:44:41 -0800
Message-ID: <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org, j@w1.fi,
	Kalle Valo <kalle.valo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2010 at 11:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-01-22 at 11:20 -0800, Luis R. Rodriguez wrote:
>
>> > Previously, we would switch the channel completely to the new operating
>> > channel before even probing the AP. That way, we would virtually always
>> > receive a beacon from the new AP between the time we started the
>> > association process (probe,auth,assoc) and configuring the driver.
>> >
>> > Now with the new changes that use the off-channel work, we may return to
>> > the old "operating" channel, which may be no particular channel, between
>> > all these steps. Thus, if there's no beacon between any of probe
>> > request/response, auth "request"/"response", assoc request/response, we
>> > never get one, and this situation happens.
>> >
>> > I see two solutions, apart from this special-case patch fixing
>> >
>> > First, we could go back to the original behaviour if we have just one
>> > virtual interface. But that still leaves us with the race, we might do
>> > all three frame exchanges within a beacon interval and still miss the
>> > beacon, we just tend to not do that and get a beacon.
>>
>> Curious, what symptoms were seen when the dtim was not propagated
>> prior to association, did the STA just not wake up for the right dtim
>> interval when in PS mode?
>
> Yes, I don't really know exactly what happens,

OK -- Wey, can you elaborate a little as to how you found this and
what you were seeing? Does the device not go into PS mode at all?

>  but if you look at
> Wey-Yi's patch you'll see most of the problem was that we calculated the
> maximum powersaving interval wrong.

I see..

>> Wouldn't we get the dtim interval on
>> eventual beacons later or do we disregard all that information after
>> associated?
>
> As you can see from the patch, we currently disregard any "update" in
> that information -- this patch changes it.

Got it.

>> If so what if the AP changes the dtim interval?
>
> I believe the AP is not allowed to do that without turning off and back
> on completely.

OK. Still curious, if in practice would funky APs ever tune DTIM
dynamically and not kick you off, and if they do is it fair to ignore
that and blame the AP?

>> I take it this can easily be reproduced with a long beacon interval?
>
> Easier, yes. The easiest way to reproduce it is to associate using just
> "iw", no NM or wpa_supplicant -- make sure the scan list is empty before
> you associate -- and with a long beacon interval. We then scan, but that
> will only give us a probe response with high probability, and then we do
> all the switching as I explained and we don't ever get a beacon. If you
> use NM it may scan more often and increase the probability of us having
> a beacon at some point in time.

OK thanks.

>> > The other solution I see is that we add a new step before or after the
>> > direct probe step, which would just be "wait for a beacon". This would
>> > ensure we have both probe and beacon information always ready. It would
>> > also ensure we have both probe and beacon info for our new userspace
>> > reporting of that.
>>
>> This seems cleaner.
>
> I agree. And since we already keep track of this since 34a6eddb, we
> should be able to fairly easily determine whether we still need probe
> response or beacon, and only do either the direct probe or wait for
> beacon step.

  Luis

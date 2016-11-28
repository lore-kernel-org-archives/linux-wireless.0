Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35443 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbcK1SGH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 13:06:07 -0500
Received: by mail-io0-f171.google.com with SMTP id a124so243738957ioe.2
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 10:06:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480347358.8107.65.camel@sipsolutions.net>
References: <1478398113-14966-1-git-send-email-andrew.zaborowski@intel.com>
 <1478398113-14966-4-git-send-email-andrew.zaborowski@intel.com>
 <1480344479.8107.60.camel@sipsolutions.net> <CAOq732LFeKRjPdQ6xMx_d1cHmQmYp50NJ4MDsdf=mPXMs685PQ@mail.gmail.com>
 <1480347358.8107.65.camel@sipsolutions.net>
From: Andrew Zaborowski <balrogg@googlemail.com>
Date: Mon, 28 Nov 2016 19:06:06 +0100
Message-ID: <CAOq732K88CygXBmDfGmU21AcQHurcWx081Q3SM-b0ecm+848gA@mail.gmail.com> (sfid-20161128_190611_098952_CF153525)
Subject: Re: [PATCH 3/3][RFC] nl80211/mac80211: Accept multiple RSSI
 thresholds for CQM
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 November 2016 at 16:35, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2016-11-28 at 16:29 +0100, Andrew Zaborowski wrote:
>> In order to keep the hardware offload feature when working with
>> hardware that can only offload the old single-thresholds method, but
>> where the kernel also wants to support the new method by looking at
>> all the beacons in software.  IIRC I identified just one driver that
>> would be in this situation: wl1271.
>
> IMHO it would be better to not allow that. I'd think that wl1271 is
> only used in devices where power consumption will be far more
> interesting than providing this kind of API.

Ok.

>
>> This is a specific case and the semantics implemented by the wl1271
>> may be a little different from those in the rest of the drivers so
>> this may be worth very little.  I can change the comment to imply
>> only one method should be implemented.
>
> We might still have to allow both to be present for mac80211 though.
>
>> > Seems there still should be a hysteresis? Or am I misunderstanding
>> > the
>> > intent here? I.e. isn't it meant to report low/medium/high later?
>>
>> This isn't exposed directly to users, instead it's used by the code
>> in
>> nl80211.c which will always reset the thresholds when either
>> threshold
>> is crossed.  The hysteresis can then be either handled in nl80211.c
>> (factored into the threshold values) or in the firmware/driver, this
>> won't change the number of wakeups.
>
> That's only if you assume you can actually react to this fast enough
> though, no? If I offload this, I'd want to also offload a hysteresis to
> firmware, I'd think.

I wasn't clear: nl80211 sets the thresholds so that "high" is higher
than last known value and "low" is lower than last known value, also
the distance is at least 2 x hysteresis.  There's no purpose for
reporting "middle" rssi events because we have to set a new range as
soon as we receive a high or a low event.  I realize I need to
document better.

So I don't think this can result in additional events that wouldn't
occur if the firmware handled rssi hysteresis.  I think this is
generic enough that you can implement any monitoring logic on top of
it and squeeze the same number of wakeup in all scenarios as if the
driver handled it.  But it shouldn't discriminate hardware that
doesn't have the hysteresis parameter from offloading this.

BTW I fear if you wanted to have the hysteresis parameter handled by
firmware you'd end up with slightly differing semantics depending of
what the firmware does the moment you change you threshold values,
whether the rssi tracking is reset.

Best regards

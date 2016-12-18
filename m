Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35168 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752553AbcLRASS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Dec 2016 19:18:18 -0500
Received: by mail-io0-f194.google.com with SMTP id f73so15683311ioe.2
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2016 16:18:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1481645519.20412.37.camel@sipsolutions.net>
References: <1478398113-14966-1-git-send-email-andrew.zaborowski@intel.com>
 <1478398113-14966-4-git-send-email-andrew.zaborowski@intel.com>
 <1480344479.8107.60.camel@sipsolutions.net> <CAOq732LFeKRjPdQ6xMx_d1cHmQmYp50NJ4MDsdf=mPXMs685PQ@mail.gmail.com>
 <1480347358.8107.65.camel@sipsolutions.net> <CAOq732K88CygXBmDfGmU21AcQHurcWx081Q3SM-b0ecm+848gA@mail.gmail.com>
 <1481645519.20412.37.camel@sipsolutions.net>
From: Andrew Zaborowski <balrogg@googlemail.com>
Date: Sat, 17 Dec 2016 19:18:17 -0500
Message-ID: <CAOq732Jpst37ESQu_81RNrYOJEnLg=L2W-aPM-u3rYUsSofETA@mail.gmail.com> (sfid-20161218_011821_398952_06C264EF)
Subject: Re: [PATCH 3/3][RFC] nl80211/mac80211: Accept multiple RSSI
 thresholds for CQM
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 December 2016 at 11:11, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> I wasn't clear: nl80211 sets the thresholds so that "high" is higher
>> than last known value and "low" is lower than last known value, also
>> the distance is at least 2 x hysteresis.  There's no purpose for
>> reporting "middle" rssi events because we have to set a new range as
>> soon as we receive a high or a low event.  I realize I need to
>> document better.
>
> But there can be a delay between reporting and reprogramming, and if
> during that time a new event could be reported? I guess it doesn't
> matter much if we assume that upon reprogramming the driver will always
> report a new event if the current value falls outside the new range

That's the intention, I'm not sure if the comments in the code are
enough to make it clear.

> (either high or low)... it just seemed a little bit more consistent to
> unconditionally report a new event at the beginning, even if that new
> event is "yup - falling into the middle of your range now".

I can add a new value to the enum for "middle".  I think we'd
definitely want it if it was a userspace API but this is the internal
api with just this one use.  Also some drivers will have to query the
firmware for the new value and may need an additional wake-up for
every RSSI wake-up, doubling the amount of work.

Best regards

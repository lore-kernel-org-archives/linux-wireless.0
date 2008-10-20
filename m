Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:40917 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYJTBqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 21:46:30 -0400
Received: by gxk9 with SMTP id 9so3138342gxk.13
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2008 18:46:28 -0700 (PDT)
Message-ID: <43e72e890810191846h46a6b35br4ad61803a25bdf23@mail.gmail.com> (sfid-20081020_034651_344136_5CD2C714)
Date: Sun, 19 Oct 2008 18:46:28 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: Power saving on mac80211
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Tomas Winkler" <tomas.winkler@intel.com>
In-Reply-To: <87myh0a1zd.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
	 <87bpxh6t1n.fsf@nokia.com> <87y70l59p4.fsf@nokia.com>
	 <1224412006.6324.45.camel@johannes.berg> <871vyc7st7.fsf@nokia.com>
	 <1224434885.6324.49.camel@johannes.berg> <87myh0a1zd.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 19, 2008 at 11:12 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> On Sun, 2008-10-19 at 14:00 +0300, Kalle Valo wrote:
>>
>>> > Then add a new flag to mac80211 hw description that says "driver will
>>> > watch beacons". This means that the code above that rearms the timer for
>>> > the future 'nothing from AP' check is skipped.
>>>
>>> I will. I need to check that if the "firmware beacon watch" is enabled
>>> only when PSM is enabled. If it is, we might have to make the flag
>>> dynamic.
>>
>> IIRC it's a separate flag.
>
> Very good, that would be the best way.
>
>>>  There isn't any
>>> timeout for delivering beacons to the host, if the data path is idle
>>> for 24 hours, mac80211 will not receive any beacons for the 24 hours.
>>> I don't see why we need a timeout here.
>>
>> Right. But we need to program the chip to tell the chip "hey please tell
>> me if you haven't seen a beacon in X seconds".
>
> Ah, you mean that timeout. Sorry, I forgot that one altogether. Yes,
> we definitely need that timeout.

Is this to configure the firmware to report beacon misses so that in
those cases we can inform mac80211? And to let mac80211 be aware/be
able to set this as a tunable parameter?

I wanted to note intel hardware seems to handle parsing beacons in
firmware when is PS mode already and I have no clue when it would
inform mac80211 of a beacon miss and if it does it. Tomas?

 Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33358 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab1ISQa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:30:58 -0400
Received: by iaqq3 with SMTP id q3so5481667iaq.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 09:30:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87aaa0k0a1.fsf@purkki.adurom.net>
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	<1316408970.2157.9.camel@cumari>
	<87aaa0k0a1.fsf@purkki.adurom.net>
Date: Mon, 19 Sep 2011 19:30:57 +0300
Message-ID: <CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com> (sfid-20110919_183100_971366_9F10259D)
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
From: Eliad Peller <eliad@wizery.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 6:41 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Luciano Coelho <coelho@ti.com> writes:
>
>> On Sun, 2011-09-18 at 15:03 +0300, Eliad Peller wrote:
>>> In some cases the driver might want to change the
>>> default dynamic ps timeout (e.g. coex activity adds
>>> latency to the rx/tx path, which might result in
>>> redundant psm entrance).
>>>
>>> Introduce a new ieee80211_set_dyn_ps_timeout() function
>>> to let low-level drivers change the default timeout.
>>>
>>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>>> ---
>>
>>
>> Let's see what Johannes is going to say about this change in mac80211,
>> but IIRC this timeout used to exist with WEXT, but it was not
>> implemented in nl80211.  We (at Nokia, probably Juuso) tried to
>> implement it a long time ago, but after some discussions with Johannes,
>> it was decided that this value wouldn't be settable from userspace at
>> least.  I don't know if it was considered setting it from the driver
>> side, though.
>
> My first thought about this was: "This is so wrong." :)
>
yeah, mine too :)

> So we now have the wext interface for setting the timeout, we also use
> the PM QoS framework to set it and with this patch even from drivers
> can set it. That's quite a mess.
>
> What are these "some cases" referred above? I'm just worried that this
> is just a workaround for an issue and adding the extra complexity is a
> high cost just to workaround something. Please remember that mac80211
> power save is a big problem already now.
>
AFAIU from the coex guys, the scenario is something like this:
upon coex activity, the fw might delay its rx and tx paths. this means
that the fw might get a frame within the 100ms of the dyn ps, but
delay its processing and pass it up to the driver only later.
this will cause redundant psm enter (after 100ms) and psm exit (after
the fw passed the packet).
i'm not sure about the exact effect during coex operation, but
eventually these psm enter/exit affect the throughput.

another point here, is that during a specific period (during auto_mode
on), there might or might not be coex activity. thus, we can't just
disable dyn_ps, as it will hurt throughput (when there is no coex
activity).

bottom line - i'm not sure about all the details, but according to
their tests - it does improve the throughput.
(i can try getting better details if you have additional questions)

Eliad.

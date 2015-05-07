Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34444 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbbEGJ61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 05:58:27 -0400
Received: by iedfl3 with SMTP id fl3so39232867ied.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 May 2015 02:58:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1430918151.1954.6.camel@sipsolutions.net>
References: <1425902001-3163-1-git-send-email-eliad@wizery.com>
	<1425905568.1928.7.camel@sipsolutions.net>
	<CAB3XZEe71wE+zPR-knwvrFMjecvddJhVsMWJ9YcHkGa9xW-XZQ@mail.gmail.com>
	<1430918151.1954.6.camel@sipsolutions.net>
Date: Thu, 7 May 2015 12:58:26 +0300
Message-ID: <CAB3XZEcMX170CKdSWDpScfiptXJYsF1uCj3E-jH0hBf4RKk9TQ@mail.gmail.com> (sfid-20150507_115837_171025_C903B0C4)
Subject: Re: [PATCH] mac80211: handle hw roc cancel vs. expiration race
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 6, 2015 at 4:15 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> To revive an old thread - sorry...
>
>> >> Fix it by cancelling hw_roc_done on roc cancel.
>> >> Since hw_roc_done takes local->mtx, temporarily
>> >> release it (before re-acquiring it and starting
>> >> the next roc if needed).
>> >
>> > I can't say I like this, and I'm not even sure it doesn't leave a race?
>> > After all, the work will not take the RTNL.
>> >
>> the other way (cancel while hw_roc_done) is protected, since
>> ieee80211_cancel_roc() looks for a specific roc cookie.
>
> But you're saying that we rely on RTNL to not modify the list, and the
> hw_roc_done work doesn't use the RTNL? Hmm. Are you saying now that it
> also checks that it was started? But then why do we even have this
> issue?
>
sorry, i'll have to recall the exact details...

> Or I can see why we have this issue, but perhaps we could fix it by
> flushing the work *after* we cancel, so in case the driver was
> cancelling at the same time we'd not yet have started the next one?
>
that's basically what i did - canceled the work after
drv_cancel_remain_on_channel() was called.

>> > I think the only way to really fix that is to make the driver return the
>> > roc pointer or so and then we can either queue a work struct per roc
>> > struct, or at least mark the roc struct as driver-destroyed and
>> > double-check that in the work function?
>> >
>> that was my initial implementation. but then i thought it will be
>> nicer to implement it in mac80211 and avoid changing all the drivers
>> (with the need to save the cookie, etc.)
>> do you prefer adding such cookie/pointer param?
>
> How difficult was it for the driver(s)? It seems it would make the code
> far easier to reason about, which can only be a good thing. We'd save
> the whole race discussion above :)
>
sure. let's forget about this discussion and go with the clearer solution :)

Eliad.

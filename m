Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:44317 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbZLALoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 06:44:02 -0500
Received: by bwz27 with SMTP id 27so3332971bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 03:44:08 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211: add SM PS hooks
References: <20091130153857.963079149@sipsolutions.net>
	<20091130154300.492667106@sipsolutions.net>
	<87pr6z6uud.fsf@purkki.valot.fi>
	<1259659771.32171.62.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 01 Dec 2009 13:44:06 +0200
In-Reply-To: <1259659771.32171.62.camel@johannes.local> (Johannes Berg's message of "Tue\, 01 Dec 2009 10\:29\:31 +0100")
Message-ID: <871vje7wc9.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2009-12-01 at 09:01 +0200, Kalle Valo wrote:
>> My concern here is that we will end up having, yet again, complicated
>> user space interface for power save. The ideal situation would be that
>> kernel would configure all this automatically and we would have a
>> simple interface just to disable power save in cases where it doesn't
>> work (broken APs etc).
>
> I'm not actually sure that there are APs broken wrt. SM PS, it seems
> highly unlikely -- even if there are (like mac80211!!) the rate control
> algorithm would recover the situation.

Oh, that's good.

> As such, I suppose it's somewhat a debugging API. On the other hand,
> there are actual traffic throughput consequences of enabling SM PS, even
> when in powersave. Powersave will be turned off automatically if there's
> enough traffic, but SM PS won't. The default, automatic, means it just
> follows powersave (dynamic SM PS if on, no SM PS if off), but I'm not
> sure that is typically desirable.
>
> Of course, on the other hand, I don't see many users actually setting
> it. An alternative could be to try to estimate traffic, but that gets
> messy fairly quickly because the thresholds depend on the environment.

I think at some point we need to start estimating the traffic somehow
and having heuristics to dynamically change the power save settings.
But it's a huge challenge, so it isn't coming anytime soon.

> If you prefer to leave it out for now, I can probably move it to debugfs
> until we have a more clearly defined use case,

Great if you can convert it to debugfs for now. That way we have a bit
more time to think about the power save interface. Thanks.

> although if we decide that we never want it then obviously the
> action frame handling can go away again.

Yeah.

-- 
Kalle Valo

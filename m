Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:33599 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbcDSDGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 23:06:54 -0400
Received: by mail-yw0-f180.google.com with SMTP id t10so4033074ywa.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 20:06:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgVM8cVyKaNi0PEjqPmamPp3+YAXbVMu+Hifi6R0Le-ekg@mail.gmail.com>
References: <1460765986-12698-1-git-send-email-steve.derosier@lairdtech.com>
	<CAGRGNgV_W6uJF5DR43XdqvHPgBha1AfALYXcX4Lj=4jkO8TftQ@mail.gmail.com>
	<CALupW3CsuSGy=xBw-Wj5FfD+ALKBGi9xvi=Z8+YTdL9mGku5HQ@mail.gmail.com>
	<CAGRGNgVM8cVyKaNi0PEjqPmamPp3+YAXbVMu+Hifi6R0Le-ekg@mail.gmail.com>
Date: Mon, 18 Apr 2016 23:06:53 -0400
Message-ID: <CALupW3BtioZsX9dyBGEbtQrMh4O-BjA-0zG0MG1OwEH0YLbKKQ@mail.gmail.com> (sfid-20160419_050657_756390_3CC64925)
Subject: Re: [PATCH] ath6kl: Add ability to set debug uart baud rate
From: Steve deRosier <derosier@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Steve deRosier <steve.derosier@lairdtech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

First off, let me say I do appreciate your comments and I do
understand your perspective. I also generally prefer not to let users
shoot-themselves in the foot if it's avoidable.

In this case, however, I don't happen to agree with you. For one
specific reason: I don't want to say what baud rates are "safe"
because I think that's even more dangerous than not checking - because
we have no way of actually knowing what is or isn't for a particular
chip.

Oddly enough I thought this all out before I ever sent the patch up.

>
> I'm of the opinion that one should never underestimate the ability of
> people to attempt to shoot themselves in the foot. However this is
> only a debugging interface so you do make a good point.
>
> I guess I'm worried that some idiot is going to set it to 2 baud or 2
> billion baud for some dumb reason then come complaining to us when
> their wireless card crashes or locks up or something.
>
> Maybe we can just sweep this all under the carpet by putting all the
> debug uart stuff behind some nice #ifdef.

Well, first off the debugging stuff was never under some #ifdef. So,
we should make it even more complicated and add an #ifdef and yet
another kconfig option?

AFAIK, the firmware would be perfectly happy with 2 baud. I'm not in
my lab to try it right now, but it might well be (though your
throughput would be crap). Nor do I know the upper limit of the
register the firmware uses.

My firmware guy wanted 115200, and I could've hard-coded it to that
value, but I figured a bit of flexibility was warranted and would be
more upstreamable. I don't know every single valid or invalid value
for every ar6xxx chip. If we have it check for the value, then we have
some obligation to know the values we let in are valid for either all
or at least the chip the user is using. I don't know what was invalid
for many species of 6002. Or even all of the 6003 and 6004s and I've
been working with both the firmware and driver for these chips for 3
years now. What might be valid on the yet to be imagined 6009?

If we check, we are saying, "these are safe values and we want you to use them".

99.999% of users don't have access to this pin without a soldering
iron. I think someone who is going to tack a wire to their 6k chip is
entitled to set even stupid values if they think they have a reason.

Again, simply my perspective.

On a compromise: do you have a specific list of baud rates you'd like
to support and you know are valid across a wide swath of ath6kl chips?
Every rate I've tried, normal or weird, works fine. Granted, I haven't
tried anything slower than 9600, nor have I bothered checking the
clock error on the weird rates. If you have said list, I'd be happy to
code it up. But I think that specifically checking for rates is the
same as saying "this rate is supported" and I don't know that, so I
hope you do know what ones are valid.

Maybe you agree with my line of thinking (now that you know what it
is) or maybe not. That's OK. ;)

Thanks,
- Steve

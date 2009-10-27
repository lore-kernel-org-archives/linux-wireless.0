Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43118 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbZJ0Q40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 12:56:26 -0400
Received: by bwz19 with SMTP id 19so430786bwz.28
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2009 09:56:30 -0700 (PDT)
Message-ID: <4AE72639.9020402@lwfinger.net>
Date: Tue, 27 Oct 2009 11:56:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8187: kernel oops when leds enabled
References: <4AE5BD6C.2050303@gmail.com>
In-Reply-To: <4AE5BD6C.2050303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Farina wrote:
> Using kernel 2.6.31 and compat-wireless stable 2.6.32_rc5 I get this
> kernel oops nearly 100% of the time when I unplug the device.  I have
> tried with the device down, up, and while transmitting, here are the
> three oopses.  Sorry it took me so long for this report, it is an odd
> bug.  When I was running older kernel/compat-wireless this oops was
> about 4-5 screens longs so I couldn't take a picture.  Additionally I
> took the advice of a few of the list members to try the crashkernel
> feature (which is AWESOME  btw) but it doesn't work for this oops.  Let
> me be more specific, I can trigger an oops and the crash kernel kicks
> in, but with this oops the crash kernel never kicks in so I am guessing
> this is bad news.

I have a bit more information about this crash. It shows up as either
a "BUG: Scheduling while atomic" or "Kernel panic - not synching:
Fatal exception in interrupt". I could also trigger this oops by
running a rmmod/insmod loop, which makes testing easier in that I can
walk away and let the machine do the testing.

As you noted, the problem does not appear when the LED code is not
enabled. I tried to find a problem in the rtl8187 LED code without
success, then discovered that the problem is present in mainline
2.6.32-rc5, but not in 2.6.31. One does not need compat-wireless. Note
that the rtl8187 LED code did not change in that time. It seems likely
that there is a bug in some other part of the system that rtl8187 is
triggering. In any case, I now have a starting point for bisection,
which is my next step.

This problem is clearly a regression between 2.6.31 and 2.6.32-rc5. I
will file a Bugzilla on it once I know the commit that broke the system.

Larry


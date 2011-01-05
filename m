Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59369 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1AEN5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 08:57:16 -0500
Received: by qwa26 with SMTP id 26so15670538qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 05:57:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110105111314.GA23794@zenon.in.qult.net>
References: <20110105111314.GA23794@zenon.in.qult.net>
Date: Wed, 5 Jan 2011 08:57:14 -0500
Message-ID: <AANLkTi=WQwx5hOxeGweFOLVtpss54NZsRyV0tkBqf4CP@mail.gmail.com>
Subject: Re: About clocks in the carl9170 firmware
From: Brian Prodoehl <bprodoehl@gmail.com>
To: Ignacy Gawedzki <i@lri.fr>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 5, 2011 at 6:13 AM, Ignacy Gawedzki <i@lri.fr> wrote:
> Hi,
>
> A few months ago, Christian Lamparter suggested to me the use of
> get_clock_counter() in the carl9170 firmware code for time measurement
> purposes.
>
> I just got back to that, after a long period of other things to do instead.
>
> According to the results of a few tests I've been running yesterday, it looks
> that this clock is 44Mhz, not 40Mhz, nor 80Mhz.

I have seen the same thing.  In 802.11g mode, that clock counter runs
at 44MHz.  There are rumors that this changes with operating mode.
Its easy to believe that it would run at 80MHz in turbo (40MHz
channel-width) mode.  But, I haven't tested that, and can only say
that I've seen that clock counter run at 44MHz as well.

> According to Christian, the clock source, as accessed through
> get_clock_counter() is stable and does not depend on calls to clock_set().
> This is further corroborated by the definition and use of the
> AR9170_TICKS_PER_MICROSECOND *constant* in timer.h.  But still, how comes that
> constant is 80 then?

Does anything in the firmware really rely on that constant being
right?  I'm more familiar with ar9170usb and the open firmware for
that, where the constants were also wrong, but nothing used them
except for some delay functions, for which the accuracy wasn't
critical.

> I'm obviously missing something here.  I would be really thankful to anybody
> who could explain how these clocks/timers work and how they are supposed to be
> used.
>
> Thanks,
>
> Ignacy

-Brian

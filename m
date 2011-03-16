Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57744 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1CPJBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 05:01:00 -0400
Received: by iyb26 with SMTP id 26so1448220iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 02:01:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300265348.3761.3.camel@jlt3.sipsolutions.net>
References: <507B31BE-2066-4434-870D-108F7DF912A6@cs.washington.edu>
 <1300263716.3761.1.camel@jlt3.sipsolutions.net> <AANLkTikir41uU_fG91w68D4JyFMPcFYKW4QFg-Ag_EUK@mail.gmail.com>
 <1300265348.3761.3.camel@jlt3.sipsolutions.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 16 Mar 2011 02:00:40 -0700
Message-ID: <AANLkTi=8th1NyjQE4zvVcS21Dba3Ku_WhnwQS0ZR9+EH@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix aggregation frame release during timeout
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2011 at 1:49 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2011-03-16 at 01:44 -0700, Daniel Halperin wrote:
>> On Wed, Mar 16, 2011 at 1:21 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2011-03-15 at 16:49 -0700, Daniel Halperin wrote:
>> >
>> >> x-T-R1-y-R2,
>> >
>> >>                       if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
>> >> -                                     HT_RX_REORDER_BUF_TIMEOUT))
>> >> +                                     HT_RX_REORDER_BUF_TIMEOUT) && skipped)
>> >
>> > Wait, your previous example of xT---R worked fine, but if you say x-T-
>> > this patch won't work I think? Basically you're saying if we received
>> > frames 2 and 4 after 3, and 3 times out, we can release 2 through 4. I
>> > agree, but your code won't do that since skipped starts out at 1 due to
>> > the first x. Or am I misreading this?
>> >
>>
>> The syntax I used in our private mail was confusing and I tried to
>> simplify. Here, hyphens are just separators between frames (since R1,
>> R2 have two-letter identifiers). Does that clear it up?
>
> Oh. Right. Still though, what if it is x-R1-T-R2-y-...? This fixes
> x-T-R1-...-y-..., but shouldn't some release be possible in the other
> case as well?
>

Hmm -- you've got a point. That case wasn't handled by the original
code and my change only picks up my example but not yours.

One fix maybe is to also store the sequence of the frame that set the
timer when the buffer fires, and make sure to release up to that seq?
Or maybe the reception of an earlier frame SHOULD override the the
later frame's timeout, because it says the early part of the window is
"still alive".

I just don't see a good way to handle all cases (e.g.,
x-R3-R1-y-T-z-R2-w-T) without looping over the whole buffer.  (Here,
xyzw are skipped frames and R3 was received last.)  Again, long MAC
delays like BT could make this false, but I have to expect in most
cases R1/2/3 will be received pretty close to when T is.

Dan

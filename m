Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52377 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab1G1S5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 14:57:03 -0400
Received: by vxh35 with SMTP id 35so2133485vxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 11:57:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107281849.29700.chunkeey@googlemail.com>
References: <CAJ8GFOiTwtS7Ddjo8GR3uJMFtkBY+cFuNo3d4mX_4EwOLN9PxQ@mail.gmail.com>
	<201107232235.16710.chunkeey@googlemail.com>
	<CAJ8GFOg4FL2vkF5q2Hc1GZyTk0+cfX4nnEOovFcvXiL0nZLO_w@mail.gmail.com>
	<201107281849.29700.chunkeey@googlemail.com>
Date: Thu, 28 Jul 2011 13:57:01 -0500
Message-ID: <CAJ8GFOhQySNW+hL-NHR+TEgX+tzYOhP2G3NmfTv0bGt6fDVn4Q@mail.gmail.com> (sfid-20110728_205711_752691_B475A2B4)
Subject: Re: carl9170: Beacons at lower Tx power than data frames?
From: Harshal Chhaya <harshal@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 28, 2011 at 11:49 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Thursday, July 28, 2011 06:18:09 PM Harshal Chhaya wrote:
>> Sujith, Christian,
>>
>> On the wiki page for carl9170, the first item in the "not working yet" list is:
>> * Power Save Mode, It's implemented but buggy
>>
>> Is this still the case?
>>
>> I am seeing clients disconnect after a few seconds when I enable power
>> saving on the clients. I can send more details if needed.
> Oh no, unless of course your failing clients are also running carl9170.
> Take a look at 802.11-2007 11.2 for an explantation. APs usually don't
> do any PSM.

Sorry - looks like I misread the statement.  I didn't realize it
applied only for STA mode.

To clarify, my clients are not running carl9170 - only my AP is.

But I am seeing a definite problem with network stability when I
enable power saving on my clients. The clients work as expected with
another off-the-shelf AP.

Could you tell me how to enable debug output in carl9170? I would like
to better understand what's going on in the carl9170 driver/firmware
when I see these disconnects.

I found the 'ath_debug_level' enum in ath.h but don't know how to use
this with carl9170.


>> >> Here is what I have tried so far:
>> >>
>> >> 30 802.11g clients
>> >>
>> >> open mode + power save - no problems, can send data to all 30 for hrs
>> >> wpa2 + disable power save - no problems, can send data to all 30 for hrs
>> >> wpa2 + enable power save - clients connect but then randomly
>> >> disconnect every few seconds.
>> > Is this with or without the hardware crypto enabled? Usually it's enabled by
>> > default. But in your case I would give it a try to go without one. Just load
>> > the module with:
>> >
>> > nohwcrypt=1
>> >
>> > this will help to rule out any hw limitations in this regard.
>>
>> However - I am curious about the limit of 32. The chip itself supports
>> keys for up to 64 users (i.e. a total of 128 keys). I didn't see any
>> obvious pieces of the carl9170 code that limited this number to 32.
>
> well, the second "user" is currently only used by the tkip mic. If you
> are only using ccmp you may be able to utilize the second slot as well.
> However this requires a more sophisticated key-management in the driver.

All of my clients use CCMP. Which file/function do I look at to see
what it would take to use all 64 key entries for CCMP?

Thanks,
- Harshal

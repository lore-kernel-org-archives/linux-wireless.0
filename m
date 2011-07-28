Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52575 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab1G1Qto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 12:49:44 -0400
Received: by fxh19 with SMTP id 19so1428929fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 09:49:43 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Harshal Chhaya <harshal@gmail.com>
Subject: Re: carl9170: Beacons at lower Tx power than data frames?
Date: Thu, 28 Jul 2011 18:49:29 +0200
Cc: linux-wireless@vger.kernel.org, Sujith <m.sujith@gmail.com>
References: <CAJ8GFOiTwtS7Ddjo8GR3uJMFtkBY+cFuNo3d4mX_4EwOLN9PxQ@mail.gmail.com> <201107232235.16710.chunkeey@googlemail.com> <CAJ8GFOg4FL2vkF5q2Hc1GZyTk0+cfX4nnEOovFcvXiL0nZLO_w@mail.gmail.com>
In-Reply-To: <CAJ8GFOg4FL2vkF5q2Hc1GZyTk0+cfX4nnEOovFcvXiL0nZLO_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107281849.29700.chunkeey@googlemail.com> (sfid-20110728_184948_475634_18D8AB53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, July 28, 2011 06:18:09 PM Harshal Chhaya wrote:
> Sujith, Christian,
> 
> On the wiki page for carl9170, the first item in the "not working yet" list is:
> * Power Save Mode, It's implemented but buggy
> 
> Is this still the case?
>
> I am seeing clients disconnect after a few seconds when I enable power
> saving on the clients. I can send more details if needed.
Oh no, unless of course your failing clients are also running carl9170.
Take a look at 802.11-2007 11.2 for an explantation. APs usually don't
do any PSM.  
 

> >> Here is what I have tried so far:
> >>
> >> 30 802.11g clients
> >>
> >> open mode + power save - no problems, can send data to all 30 for hrs
> >> wpa2 + disable power save - no problems, can send data to all 30 for hrs
> >> wpa2 + enable power save - clients connect but then randomly
> >> disconnect every few seconds.
> > Is this with or without the hardware crypto enabled? Usually it's enabled by
> > default. But in your case I would give it a try to go without one. Just load
> > the module with:
> >
> > nohwcrypt=1
> >
> > this will help to rule out any hw limitations in this regard.
> 
> However - I am curious about the limit of 32. The chip itself supports
> keys for up to 64 users (i.e. a total of 128 keys). I didn't see any
> obvious pieces of the carl9170 code that limited this number to 32.
well, the second "user" is currently only used by the tkip mic. If you
are only using ccmp you may be able to utilize the second slot as well.
However this requires a more sophisticated key-management in the driver.

Regards,
	Chr

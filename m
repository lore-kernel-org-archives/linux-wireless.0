Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:44394 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbZAVT6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 14:58:45 -0500
Received: by ewy13 with SMTP id 13so2977674ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 11:58:42 -0800 (PST)
Message-ID: <4978CFEF.9090507@gmail.com> (sfid-20090122_205849_980873_A9EE13BE)
Date: Thu, 22 Jan 2009 19:58:39 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] orinoco: take the driver lock in the rx tasklet
References: <1231287835-17707-1-git-send-email-kilroyd@googlemail.com> <200901081128.30143.arvidjaar@mail.ru> <496644D0.6050301@gmail.com> <200901220702.14152.arvidjaar@mail.ru>
In-Reply-To: <200901220702.14152.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On 8 January 2009 21:24:16 Dave wrote:
>> The move to the RX tasklet was not motivated by improved performance,
>> but the requirements of the crypto library (can't call from
>> interrupt) and the need to do MIC calculations on RX.

> What exactly prevents crypto library being called from interrupt (aka 
> can it sleep)?

I don't know precisely, but have a look at the Developer section of
Documentation/crypto/api-intro.txt, and note that during RX we call the
setkey method of the MIC implementation to pass it the TKIP key.

> Because now it runs under spinlock with interrupts 
> disabled; how exactly does it differ from being called from interrupt 
> context?

Running in interrupt context is not necessarily the same as running with
interrupts disabled. For example, different platforms will have
different arrangements for your stack.

>> Unless the crypto routines have changed, reverting that commit will
>> break WPA support.

> For all I can tell, code now is functionally identical to code before 
> moving rx processing to tasklet. Meaning, if it was wrong before it 
> became just as wrong now.

That was the intent of this patch. Prior to WPA, the entire orinoco RX
path ran under a spinlock (and as far as I am aware was correct). After
WPA, only half did. The code is now as correct (or wrong) as it was
before the WPA patch (modulo the WPA stuff).

It is clear that a lot of the RX tasklet does not need to run with the
spinlock. But I prefer to reinstate the known correct locking behaviour
and then minimise what runs under the spinlock, than to try and go from
a broken state directly to an 'optimal' state.

One thing I want to play with (if I ever get time) is the whole locking
strategy in orinoco. I'm not a fan of the single lock protecting
hardware calls, driver data and now the RX queue. I would like to see if
we can separate them and get a bit of performance. Note that David
Gibson considered this a number of years back (more from the perspective
of USB support I think), and came to the opinion that the whole driver
should be serialized.

However I think this would be easier if we could get rid of all the WEXT
handlers, and configure the driver through the thinner cfg80211
interface. That is part of what my upcoming re-org of the orinoco driver
is aiming for.

I think that's enough from me for now...


Regards,

Dave.

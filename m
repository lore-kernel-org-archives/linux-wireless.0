Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:40396 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab1AEOTt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 09:19:49 -0500
Received: from zenon.in.qult.net ([192.168.128.3])
	by qult.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <i@lri.fr>)
	id 1PaUDL-0007CV-LL
	for linux-wireless@vger.kernel.org; Wed, 05 Jan 2011 15:19:47 +0100
Received: from ig by zenon.in.qult.net with local (Exim 4.72)
	(envelope-from <i@lri.fr>)
	id 1PaUDI-0005nJ-Sf
	for linux-wireless@vger.kernel.org; Wed, 05 Jan 2011 15:19:44 +0100
Date: Wed, 5 Jan 2011 15:19:44 +0100
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Subject: Re: About clocks in the carl9170 firmware
Message-ID: <20110105141944.GA8013@zenon.in.qult.net>
References: <20110105111314.GA23794@zenon.in.qult.net>
 <AANLkTi=WQwx5hOxeGweFOLVtpss54NZsRyV0tkBqf4CP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=WQwx5hOxeGweFOLVtpss54NZsRyV0tkBqf4CP@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 05, 2011 at 08:57:14AM -0500, thus spake Brian Prodoehl:
> On Wed, Jan 5, 2011 at 6:13 AM, Ignacy Gawedzki <i@lri.fr> wrote:
> > Hi,
> >
> > A few months ago, Christian Lamparter suggested to me the use of
> > get_clock_counter() in the carl9170 firmware code for time measurement
> > purposes.
> >
> > I just got back to that, after a long period of other things to do instead.
> >
> > According to the results of a few tests I've been running yesterday, it looks
> > that this clock is 44Mhz, not 40Mhz, nor 80Mhz.
> 
> I have seen the same thing.  In 802.11g mode, that clock counter runs
> at 44MHz.  There are rumors that this changes with operating mode.
> Its easy to believe that it would run at 80MHz in turbo (40MHz
> channel-width) mode.  But, I haven't tested that, and can only say
> that I've seen that clock counter run at 44MHz as well.

That would make sense indeed.

> 
> > According to Christian, the clock source, as accessed through
> > get_clock_counter() is stable and does not depend on calls to clock_set().
> > This is further corroborated by the definition and use of the
> > AR9170_TICKS_PER_MICROSECOND *constant* in timer.h.  But still, how comes that
> > constant is 80 then?
> 
> Does anything in the firmware really rely on that constant being
> right?  I'm more familiar with ar9170usb and the open firmware for
> that, where the constants were also wrong, but nothing used them
> except for some delay functions, for which the accuracy wasn't
> critical.

AFAICT, the delay functions are used during initialization and AGC
calibration.  I have no idea whether the accuracy is critical or not in these
parts.

In any case, there is room for developing an accurate clock, assuming that it
always changes on request of the firmware and never by itself.  I'll give it a
try and test whether it breaks everything or not. =)

-- 
I used to have a sig, but I've stopped smoking now.

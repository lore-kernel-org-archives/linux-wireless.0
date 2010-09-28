Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64780 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0I1MFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 08:05:08 -0400
Received: by fxm3 with SMTP id 3so2503906fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 05:05:06 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: A few questions about modifications in carl9170
Date: Tue, 28 Sep 2010 14:04:59 +0200
Cc: linux-wireless@vger.kernel.org
References: <20100927132957.GA2977@qubit.lri.fr> <201009280128.23207.chunkeey@googlemail.com> <20100928062720.GA31986@zenon.in.qult.net>
In-Reply-To: <20100928062720.GA31986@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009281404.59297.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 28 September 2010 08:27:21 Ignacy Gawedzki wrote:
> On Tue, Sep 28, 2010 at 01:28:22AM +0200, thus spake Christian Lamparter:
> > On Tuesday 28 September 2010 01:01:37 Ignacy Gawedzki wrote:
> > > On Mon, Sep 27, 2010 at 07:36:21PM +0200, thus spake Christian Lamparter:
> > > > Sure, but why when you have a monotonic 40 MHz timer?
> > > 
> > > Glad to know there is such a thing, then. =)
> > or was it 80Mhz? Nevermind, the docs are not very specific.
> 
> AFAICT there's a constant in timer.h :
> 
>   #define AR9170_TICKS_PER_MICROSECOND    80
it is supposed to be 25 ns clock counter

> but there's also that clock_set() function that seems to be setting the clock
> up with different frequencies, but I supppose that's a different thing.
clock_set sets the CPUs clock, which has an effect on timer0-3 but not
on the clock source.
 
> > > I just tried the whole setup with the latest wireless-testing sources and your
> > > patch on the firmware.  So far, so good, the problems I had previously are not
> > > showing up.  I'm now just adapting your proposition to support rollover and
> > > conversion of the measurement to nanoseconds.
> > Rollover checks? Can you please tell me where you exactly see a potential
> > rollover problem in the proposal?
> 
> Well, what I meant was to support the case when the clock ticks counter wraps
> around.  Supposing there are 40e6 ticks per second, 2^32 ticks run out in less
> than 108 seconds, or maybe I'm missing something here.
yes, "MAC RESET" and carl9170_tx_janitor. A frame can't be delayed for more
than 6 second.

> I then need to consider the case where comp_tsf ends up not being larger
> than tsfl.  Since > we're dealing with unsigned ints, in this case the
> simple difference would end up being something rather large. :/
Too much bad literature.
Give it a try, set comp_tsfl = 0x10 and super->s.tsfl = 0xfffff000.
then comp_tsfl - super->s.tsfl equals to 0x10 - 0xfffff000, which on
a 32-bit arch gives you 0x00001010 (+ carry/borrow)

Regards,
	Chr

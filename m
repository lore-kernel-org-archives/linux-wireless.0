Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:43609 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab0I1G6g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 02:58:36 -0400
Date: Tue, 28 Sep 2010 08:27:21 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: A few questions about modifications in carl9170
Message-ID: <20100928062720.GA31986@zenon.in.qult.net>
References: <20100927132957.GA2977@qubit.lri.fr>
 <201009271936.22261.chunkeey@googlemail.com>
 <20100927230137.GA5702@qubit.lri.fr>
 <201009280128.23207.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201009280128.23207.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 01:28:22AM +0200, thus spake Christian Lamparter:
> On Tuesday 28 September 2010 01:01:37 Ignacy Gawedzki wrote:
> > On Mon, Sep 27, 2010 at 07:36:21PM +0200, thus spake Christian Lamparter:
> > > Sure, but why when you have a monotonic 40 MHz timer?
> > 
> > Glad to know there is such a thing, then. =)
> or was it 80Mhz? Nevermind, the docs are not very specific.

AFAICT there's a constant in timer.h :

  #define AR9170_TICKS_PER_MICROSECOND    80

but there's also that clock_set() function that seems to be setting the clock
up with different frequencies, but I supppose that's a different thing.

> > Okay, I thought these API versions were there to be checked by the driver
> > somehow for conformance.
> 
> They are... But only at the "highest" level ;)
> Anyway, there's a bitfield which describe what commands, operation modes
> and features are support by the firmware image.

Very well then. =)

> I posted a few patches two hours ago. you should check out
> "[PATCH] carl9170: fix hung workqueue", because it may be fixes the bug.

I'll give it a try as soon as possible, thanks.

> > I just tried the whole setup with the latest wireless-testing sources and your
> > patch on the firmware.  So far, so good, the problems I had previously are not
> > showing up.  I'm now just adapting your proposition to support rollover and
> > conversion of the measurement to nanoseconds.
> Rollover checks? Can you please tell me where you exactly see a potential
> rollover problem in the proposal?

Well, what I meant was to support the case when the clock ticks counter wraps
around.  Supposing there are 40e6 ticks per second, 2^32 ticks run out in less
than 108 seconds, or maybe I'm missing something here.  I then need to
consider the case where comp_tsf ends up not being larger than tsfl.  Since
we're dealing with unsigned ints, in this case the simple difference would
end up being something rather large. :/

> > One last question about your patch.  If a frame transmission fails altogether,
> > i.e. the maximum attempts have been made and no ACK has been received
> > whatsoever, will the driver get a tx_status with the overall timer spent
> > serving that frame anyway (read: that's what I actually want)?
> Currently not, but this can be achieved by moving the tsfl =
> get_clock_counter(); from __wlan_tx to _wlan_tx() and kill the one in
> wlan_tx_status.

Thanks for that hint, too. =)

Best regards,

Ignacy

-- 
P.S.  All information contained in the above letter is false,
      for reasons of military security.

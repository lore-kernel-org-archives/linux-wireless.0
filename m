Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ext.lri.fr ([129.175.15.4]:32794 "EHLO ext.lri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab0I1Mk6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 08:40:58 -0400
Date: Tue, 28 Sep 2010 14:40:56 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: A few questions about modifications in carl9170
Message-ID: <20100928124056.GA10093@qubit.lri.fr>
References: <20100927132957.GA2977@qubit.lri.fr>
 <201009280128.23207.chunkeey@googlemail.com>
 <20100928062720.GA31986@zenon.in.qult.net>
 <201009281404.59297.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201009281404.59297.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 02:04:59PM +0200, thus spake Christian Lamparter:
> On Tuesday 28 September 2010 08:27:21 Ignacy Gawedzki wrote:
> > AFAICT there's a constant in timer.h :
> > 
> >   #define AR9170_TICKS_PER_MICROSECOND    80
> it is supposed to be 25 ns clock counter

I don't get what you mean by that.  Is anything wrong with this constant?

> clock_set sets the CPUs clock, which has an effect on timer0-3 but not
> on the clock source.

Ah okay, very well.

> > I then need to consider the case where comp_tsf ends up not being larger
> > than tsfl.  Since > we're dealing with unsigned ints, in this case the
> > simple difference would end up being something rather large. :/
> Too much bad literature.

In my case that must be too little literature overall.

> Give it a try, set comp_tsfl = 0x10 and super->s.tsfl = 0xfffff000.
> then comp_tsfl - super->s.tsfl equals to 0x10 - 0xfffff000, which on
> a 32-bit arch gives you 0x00001010 (+ carry/borrow)

Ha ha... shame on me. =)

Thanks for the lesson, master.

Regards,

Ignacy

-- 
A person is shit's way of making more shit.
		-- S. Barnett, anthropologist.

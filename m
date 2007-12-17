Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46320 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757792AbXLQVIy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 16:08:54 -0500
Subject: Re: [patch 3/9] mac80211: Add PID controller based rate control
	algorithm
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197892210.4885.21.camel@johannes.berg>
References: <20071217012517.882216322@gmx.de> >
	 <20071217012550.127484236@gmx.de> >
	 (sfid-20071217_012722_935905_F6E718EA)  <1197892210.4885.21.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 22:08:51 +0100
Message-Id: <1197925731.7505.17.camel@localhost> (sfid-20071217_210857_044353_07A65C5D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-17 at 12:50 +0100, Johannes Berg wrote:
> > +	/* We need to do an arithmetic right shift. ISO C says this is
> > +	 * implementation defined for negative left operands. Hence, be
> > +	 * careful to get it right, also for negative values. */
> > +	adj = (adj < 0) ? -((-adj) >> (2 * RC_PID_ARITH_SHIFT)) :
> > +			  adj >> (2 * RC_PID_ARITH_SHIFT);
> 
> That looks... weird.
> 
> As far as I know all compilers the kernel can use will do an arithmetic
> right shift if the data type is signed.

Where is your information from? I actually had some misbehaviour that
was fixed after I introduced this. I'll check the assembly gcc produces
to shed some light on this.

Mattias


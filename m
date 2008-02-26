Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:38265 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764149AbYBZUs3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 15:48:29 -0500
Date: Tue, 26 Feb 2008 21:36:42 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [PATCH 08/13 v2] o11s: other changes in mac80211 for mesh
 interface support
Message-ID: <20080226213642.6af22561@morte> (sfid-20080226_204853_735138_7631B18C)
In-Reply-To: <1203974113.6929.93.camel@localhost>
References: <47be7741.05d6720a.44c4.ffffd0c9@mx.google.com>
	<20080223074133.32a4609c@morte>
	<1203974113.6929.93.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 25 Feb 2008 13:15:13 -0800
Luis Carlos Cobo <luisca@cozybit.com> wrote:

> > >  		pf <<= RC_PID_ARITH_SHIFT;
> > > +		sta->fail_avg = ((pf + (spinfo->last_pf << 3)) / 9)
> > > +					>> RC_PID_ARITH_SHIFT;
> > >  	}
> > 
> > What do you need fail_avg for? Please note that we have better estimates of
> > the frame failure trends (e.g., err_avg). What these magic values are?
> 
> It's supposed to be an estimation of the probability of a frame
> transmission failure. The magic numbers just express the formula
> 
> fail_avg = (8 * old_fail_avg + 1 * fail_avg) / 9
> 
> a simple smoothing, there is nothing special to the exact numbers.
> 
> If you think err_avg is a good candidate (is it also 0-100?) I'd be
> happy to use that instead.

In short: no, it's not 0-100. And probably it's not what you expect it to
be. But you may consider to use it.

Boring explanation: in the algorithm, we define the error(T), which is a
function of time T (jiffies in the code), as the difference between the
failed frames rate f (pf) and a given value we use to call "target", t
(target_pf), at some time T.

Currently, t can be set through debugfs only, but it's meant to be tunable
by iw (the mac80211-ish replacement for wireless-tools) in a near future.
Other parameters will be tunable, such as s (>> smoothing_shift), which
stands for "smoothing".

Hence, err_avg is an exponential moving average of error(T), such that:
	err_avg = error(T - 1) / s + ... + error(T - n) / (s * n).

Now, I'm not sure about what you need for mesh networks, but from this
algorithm you can quickly and cheaply get a proportional, integral or
derivative error ("error" as in difference between the failed frame rate and
the allowance for packet loss) or even get them all. The first one is just
linearly based upon the current behaviour, the second is about weighed
behaviour in the past, and the third emphasizes the current trend. We
actually use them all to adjust rates we use in "regular" 802.11 networks,
so I think they may suit your needs as well. If they don't, I'm fine with
this fail_avg thing you introduced.


--
Ciao
Stefano

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:49374 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751040AbXLJIJy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 03:09:54 -0500
Date: Mon, 10 Dec 2007 09:03:23 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
 learning algorithm
Message-ID: <20071210090323.47d657e6@morte> (sfid-20071210_081008_103329_A8A190FE)
In-Reply-To: <1197269336.7490.25.camel@localhost>
References: <20071209211547.2d7fca32@morte>
	<20071209211931.26ff42fa@morte>
	<1197239150.7543.13.camel@localhost>
	<20071210002158.654ed960@morte>
	<1197269336.7490.25.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 10 Dec 2007 07:48:56 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> > > > +/* Normalize the failed frames per-rate differences. */
> > > > +static void rate_control_pid_normalize(struct rc_pid_rateinfo *r, int l)
> > > > +{
> > > > +	int i;
> > > > +
> > > > +	if (r[0].diff > RC_PID_NORM_FACTOR)
> > > > +		r[0].diff -= RC_PID_NORM_FACTOR;
> > > > +	else if (r[0].diff < -RC_PID_NORM_FACTOR)
> > > > +		r[0].diff += RC_PID_NORM_FACTOR;
> > > > +	for (i = 0; i < l - 1; i++)
> > > > +		if (likely(r[i + 1].valid)) {
> > > > +			if (r[i + 1].diff > r[i].diff + RC_PID_NORM_FACTOR)
> > > > +				r[i + 1].diff -= RC_PID_NORM_FACTOR;
> > > > +			else if (r[i + 1].diff <= r[i].diff)
> > > > +				r[i + 1].diff += RC_PID_NORM_FACTOR;
> > > > +		}
> > > 
> > > If I understand correctly, you apply an offset to all valid entries. So
> > > I'd rather call it RC_PID_NORM_OFFSET.
> > 
> > Well, I don't care that much. I was referring to this definition of factor:
> > 
> > n., 1. One that actively contributes to an accomplishment, result, or process
> > 
> > Anyway "offset" may be more clear. Will fix it.
> > 
> > > Furthermore, what if the diff
> > > values are larger than k * RC_PID_NORM_OFFSET (with k an integer)? If
> > > you first compute the offset, you can just loop over the array and apply
> > > the offset without checking for the condition.
> > 
> > I frankly don't get your point here. No offsets are computed...
> 
> Well, let's see, maybe I misunderstood the code. I thought the idea was:
> If the diff values grow too large (too small), we substract (add)
> RC_PID_NORM_FACTOR from (to) all of them. But now it seems to me you do
> this for every diff value individually to achieve something like an
> aging effect. Is that correct? The term "normalize" probably confused
> me.

I used the "normalize" term as in "process that makes something more
normal, which typically means conforming to some regularity or rule, or
returning from some state of abnormality" [wikipedia].

What I do here is to assume that lower rates will perform better, in the
long term, let's make an example: my card can transmit at three rates, 1,
2, and 3M. But it performs really bad at 3M, so what I can expect to have
is:

[rate] [diff]
  1      0
  2      10
  3      105
[this means we have used rate 1, then switched to rate 2 and had 10% more
fails, then switched to rate 3 and had 95% more fails than rate 2]

But now we don't know if bad performance of rate 3 was due to external
conditions or to a somehow broken device. Let's say that we move our
laptop to a different environment, which causes the rate 3 to work
reasonably well. That 105 doesn't make sense now and we have to make it
similar to diff for rate 2. But not equal, as 1) it's unlikely to be equal;
2) if it would be equal we would never use rate 2, which we can
theoretically suppose to be a little better than rate 3 (compare with
_shift_adjust() here). So in the end, if we don't get any recent events,
we should end up with something like:

[rate] [diff]
  1      0
  2      3
  3      6
[with norm_offset set to 3]

So what really matters here are recent events. Yes, it's something like an
aging effect. Note that norm_offset is meant to tune how fast it's supposed
that we move between different environments. A little caveat here: all
values can be negative, even the one for rate 1. This doesn't matter,
because anyway, as per the definition of the algorithm, all values are
referred to the lowest rate behaviour (and not to zero).

> > > > +	for (i = 1; i < mode->num_rates; i++) {
> > > > +		s = 0;
> > > > +		for (j = 0; j < mode->num_rates - i; j++)
> > > > +			if (unlikely(mode->rates[rinfo[j].index].rate >
> > > > +				     mode->rates[rinfo[j + 1].index].rate)) {
> > > > +				tmp = rinfo[j].index;
> > > > +				rinfo[j].index = rinfo[j + 1].index;
> > > > +				rinfo[j + 1].index = tmp;
> > > > +				s = 1;
> > > > +			}
> > > > +		if (!s)
> > > > +			break;
> > > > +	}
> > > 
> > > There is include/linux/sort.h. I guess using this would make the code
> > > clearer. It took me a moment to recognize the code as bubble sort.
> > 
> > Heapsort (please see lib/sort.c) is suboptimal here. I think that
> > bubblesort is the right compromise between insertion sort (performance) and
> > readability here.
> 
> This is one of the places where you don't have performance issues at
> all. This only called once when initializing the rate control algorithm,
> so you will never need to optimize this code :-)
> 
> If you don't want the sort() call, please at least add a comment that
> you're doing a bubble sort here, just to aid people reading this.

Ok, I'll pick one. :)

> However, the issue here is quite subtle: Currently, we don't know
> whether the frames that we receive status about in tx_status() were
> actually sent with the rate as decided by the algorithm. This is
> something I have on my list, but I currently don't know how to address
> it properly. Comments welcome.

Could you elaborate here? I miss the point (i.e. what's the problem here).


--
Ciao
Stefano

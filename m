Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:36530 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755901AbXK0XeJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 18:34:09 -0500
Date: Wed, 28 Nov 2007 00:29:02 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving average
 estimate for rc80211_simple
Message-ID: <20071128002902.5dad5804@morte> (sfid-20071127_233413_131457_C2C39227)
In-Reply-To: <1196199484.8298.23.camel@localhost>
References: <1196112605.8318.6.camel@localhost>
	<20071127163520.028f91fb@morte>
	<1196199484.8298.23.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 27 Nov 2007 22:38:04 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:


> Is it sensible to preprocess (i.e. calculate a smoothed average) the
> input data for a PID controller? If so, should we compute a time average
> or just average over the last N frames?

By computing an average, you won't be able to implement differentiation,
even if you could implement integration.

In fact, the integration here means considering error values occurred over
some time (and I'd think of some 'windowing' approach, as explained below),
and so if we make an average, that doesn't really matter because all the
input numbers would weigh the same in the term to be integrated, as in an
average.

But in order to differentiate, you need to have some array of values for
the slope calculation (if you get a value only, you can't find the slope of
the line which is passing by - or near to, if we consider more than two
values - two points). 

Maybe it doesn't even make sense to have more than two values, and it would
be better to just compute a regular slope between two points, so that we
would just need to keep an average value and two values. Plus, the
differentiation here would just mean to make a difference between the
latest two values and divide it by the time difference between the two
frames, so we would get just two input values.

I would take this approach for computing the ID terms:

[number of bad frames]
[2][3][5][6][9][7]
|      |        |
0      S <-n->  E  <-- S is where the sliding window starts, E where it
ends, n is the length of the window (here it's 4 as an example, that'll be
subject to tuning).

- in order to integrate, we make the average of the bad frame values
ranging from S to E; if that average is going to be over a reasonable
threshold for bad frame values we preset, the I factor will be negative,
positive otherwise;
- in order to differentiate, we'll just subtract the preset threshold
from the values stored in E, E-1 from the preset threshold, then subtract
the resulting E value from the resulting E-1 value and divide by the time
which passed between the two bad frames computation; if this value is
positive, the D factor will be negative, positive otherwise;
- after we did these computation, we wait for some time and make the
sliding window shift right, and then repeat.

What we would avoid here - by properly tuning the n value - is the
so-called integral wind-up [1], which could be really bad if the quality of
the link varies rapidly, because we would take too much into account the
past events, which could be meaningless to some degree if considering a not
recent past.

> Note that the rates (or actually modulations) are not a continuous
> entity, but we only have a limited set of choices. Normally, the PID
> would output a value from some continuous range. What are good ways to
> map the PID controller output to a rate?

The quick approach would be to round it to the nearest rate. A better one
could be to keep a map of (1):[rate] <-> (2):[k1*rate + k2*recent errors at
this rate], so that if we do have to decide whether to switch between two
rates, we could actually evaluate the device performance - mainly
sensitivity - at different rates(1), and accordingly think of the real
difference between two rates(2). Then we round the output to the nearest
rate(2) and choose the corresponding rate(1).

I understand this could look a bit obscure, if you are still interested
however feel free to ask questions. :)


[1] http://en.wikipedia.org/wiki/Integral_windup

-- 
Ciao
Stefano

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54409 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756569AbXK1QeZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 11:34:25 -0500
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving average
	estimate for rc80211_simple
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20071128002902.5dad5804@morte>
References: <1196112605.8318.6.camel@localhost>
	 <20071127163520.028f91fb@morte> <1196199484.8298.23.camel@localhost>
	 <20071128002902.5dad5804@morte>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 17:34:21 +0100
Message-Id: <1196267661.8234.19.camel@localhost> (sfid-20071128_163429_752001_81E76F32)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stefano,

first of all, thanks for your input.

On Wed, 2007-11-28 at 00:29 +0100, Stefano Brivio wrote:

> By computing an average, you won't be able to implement differentiation,
> even if you could implement integration.
> 
> In fact, the integration here means considering error values occurred over
> some time (and I'd think of some 'windowing' approach, as explained below),
> and so if we make an average, that doesn't really matter because all the
> input numbers would weigh the same in the term to be integrated, as in an
> average.
> 
> But in order to differentiate, you need to have some array of values for
> the slope calculation (if you get a value only, you can't find the slope of
> the line which is passing by - or near to, if we consider more than two
> values - two points). 
> 
> Maybe it doesn't even make sense to have more than two values, and it would
> be better to just compute a regular slope between two points, so that we
> would just need to keep an average value and two values. Plus, the
> differentiation here would just mean to make a difference between the
> latest two values and divide it by the time difference between the two
> frames, so we would get just two input values.
> 
> I would take this approach for computing the ID terms:
> 
> [number of bad frames]
> [2][3][5][6][9][7]
> |      |        |
> 0      S <-n->  E  <-- S is where the sliding window starts, E where it
> ends, n is the length of the window (here it's 4 as an example, that'll be
> subject to tuning).
> 
> - in order to integrate, we make the average of the bad frame values
> ranging from S to E; if that average is going to be over a reasonable
> threshold for bad frame values we preset, the I factor will be negative,
> positive otherwise;
> - in order to differentiate, we'll just subtract the preset threshold
> >from the values stored in E, E-1 from the preset threshold, then subtract
> the resulting E value from the resulting E-1 value and divide by the time
> which passed between the two bad frames computation; if this value is
> positive, the D factor will be negative, positive otherwise;
> - after we did these computation, we wait for some time and make the
> sliding window shift right, and then repeat.
> 
> What we would avoid here - by properly tuning the n value - is the
> so-called integral wind-up [1], which could be really bad if the quality of
> the link varies rapidly, because we would take too much into account the
> past events, which could be meaningless to some degree if considering a not
> recent past.

That's all good, I completely agree.

I should have been a little clearer with my question, but when I wrote
it, I probably still had some concepts mashed up in my brain. Anyway,
let me try again: What about the problem of getting the failed frame
number samples? The input data received by the rate scaling algorithm is
basically if a frame failed to be transmitted or not, and if it was
transmitted, how many retries were needed. What my original patch does
(and what you also seem to assume in your explanations) is to count
failed frames and total number of frames over fix-sized time intervals
and compute a failed frames percentage sample value. The question is now
whether this approach is a good one. There are situations where the
device might only transmitted very few frames (as low as 1 frame every
ten seconds). Clearly, there is not much information available to the
rate scaling algorithm (not much need for rate scaling either, but
nevertheless we have to consider the effect of such a situation for
frames following an idle period). And then there are of course periods
with many transmitted frames. So what I thought of is maybe using
discrete time to calculate samples is perhaps not a good idea. Another
option would be to calculate failed frames percentage samples from each
M frames that were to be transmitted. What's your opinion on this?

> 
> > Note that the rates (or actually modulations) are not a continuous
> > entity, but we only have a limited set of choices. Normally, the PID
> > would output a value from some continuous range. What are good ways to
> > map the PID controller output to a rate?
> 
> The quick approach would be to round it to the nearest rate. A better one
> could be to keep a map of (1):[rate] <-> (2):[k1*rate + k2*recent errors at
> this rate], so that if we do have to decide whether to switch between two
> rates, we could actually evaluate the device performance - mainly
> sensitivity - at different rates(1), and accordingly think of the real
> difference between two rates(2). Then we round the output to the nearest
> rate(2) and choose the corresponding rate(1).

Ok, I understand. Question is whether it's worth the added overhead both
in computation and storage.

Mattias


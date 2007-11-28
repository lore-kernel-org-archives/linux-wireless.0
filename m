Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:59946 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752891AbXK1Rtr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 12:49:47 -0500
Date: Wed, 28 Nov 2007 18:43:48 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving average
 estimate for rc80211_simple
Message-ID: <20071128184348.2d5843d1@morte> (sfid-20071128_174955_464642_158A7DED)
In-Reply-To: <1196267661.8234.19.camel@localhost>
References: <1196112605.8318.6.camel@localhost>
	<20071127163520.028f91fb@morte>
	<1196199484.8298.23.camel@localhost>
	<20071128002902.5dad5804@morte>
	<1196267661.8234.19.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 28 Nov 2007 17:34:21 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> I should have been a little clearer with my question, but when I wrote
> it, I probably still had some concepts mashed up in my brain. Anyway,
> let me try again: What about the problem of getting the failed frame
> number samples? The input data received by the rate scaling algorithm is
> basically if a frame failed to be transmitted or not, and if it was
> transmitted, how many retries were needed. What my original patch does
> (and what you also seem to assume in your explanations) is to count
> failed frames and total number of frames over fix-sized time intervals
> and compute a failed frames percentage sample value.

Exactly.

> The question is now whether this approach is a good one. There are
> situations where the device might only transmitted very few frames (as
> low as 1 frame every ten seconds). Clearly, there is not much information
> available to the rate scaling algorithm (not much need for rate scaling
> either, but nevertheless we have to consider the effect of such a
> situation for frames following an idle period). And then there are of
> course periods with many transmitted frames. So what I thought of is
> maybe using discrete time to calculate samples is perhaps not a good
> idea. Another option would be to calculate failed frames percentage
> samples from each M frames that were to be transmitted. What's your
> opinion on this?

The size of the time interval (not to be confused with the sliding
window) could vary depending on number of frames we tried to sent. But I
don't know if this is worth the effort. I'll list a few examples:
1) we are downloading a big file through our NFS server at home; we dance
around with our laptop in our hands and suddenly we fall behind a short
wall - SNR drops by 10dB and we need to suddenly react at this, the D term
does this and we would need the time interval to be short enough so that we
notice in time about the fast drop in SNR;
2) what if we consider 1), except that we are just on IRC, sending a few
frames every some seconds? The time interval needs to be short anyway,
because we would notice about the drop in SNR too late otherwise;
3) we are stealing connectivity from the neighborhood, rain falls and
humidity slowly increases, thus producing a slow decrease in SNR; the I
term should deal with this, by integrating the error over time and thus
force a lower rate after, maybe, some minutes; both if we make a lot of
traffic or just send few frames, the time interval here should be short
enough - again - so that we can actually see a consistent decrease in SNR
between different time intervals.

So I'd say that for maximum granularity and good precision, we should try
to keep this time interval as short as possible (my rough guess is about
1s). We then need to solve the issue you mentioned, but I'd come up with
another approach here. Instead of taking a long time interval, let's do
interpolation. In other words, we can reasonably assume that, if at a given
time t we don't transmit any frame so we miss data, the frame errors rate
is similar to the one at t-1, and if we missed data from t-1 as well, we
grab the value from the t-2 interval, and so on. This is rough, but
still it seems to me a precise enough method for dealing with the issue.

 
> > The quick approach would be to round it to the nearest rate. A better
> > one could be to keep a map of (1):[rate] <-> (2):[k1*rate + k2*recent
> > errors at this rate], so that if we do have to decide whether to switch
> > between two rates, we could actually evaluate the device performance -
> > mainly sensitivity - at different rates(1), and accordingly think of
> > the real difference between two rates(2). Then we round the output to
> > the nearest rate(2) and choose the corresponding rate(1).
> 
> Ok, I understand. Question is whether it's worth the added overhead both
> in computation and storage.

Probably not, but so far I've seen very few examples of PID controllers for
data rates by googling around, and my guess here is that you would need to
try the simplest approach and then go further adding complexity until you
are satisfied.


-- 
Ciao
Stefano

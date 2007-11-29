Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:33578 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756340AbXK2EIY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 23:08:24 -0500
Date: Thu, 29 Nov 2007 05:02:46 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving average
 estimate for rc80211_simple
Message-ID: <20071129050246.6d8deacc@morte> (sfid-20071129_040828_774606_A860F76A)
In-Reply-To: <1196301583.7622.11.camel@localhost>
References: <1196112605.8318.6.camel@localhost>
	<20071127163520.028f91fb@morte>
	<1196199484.8298.23.camel@localhost>
	<20071128002902.5dad5804@morte>
	<1196267661.8234.19.camel@localhost>
	<20071128184348.2d5843d1@morte>
	<1196301583.7622.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 29 Nov 2007 02:59:43 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> Ok, I your case study sounds reasonable :-) So I guess I'll stick with
> averaging over fix sized time intervals. The interpolation approach you
> suggest seems good enough. How I'd expect the rate control algorithm to
> behave in situations with not much input data is:
> 
> a) Stay at the current rate, just assume conditions didn't change.
> b) Be optimistic: Slowly ramp up tx rate, so if more data to be
> transmitted is available, it'll get good rates from the beginning, if
> possible.
> 
> I think the approach you suggest is basically a) if we aren't adjusting
> rate heavily at the moment.

Yes, because:
1) if the number of frame errors is over some threshold, by interpolating
the way I suggested we will probably switch to a lower rate (mostly because
of the I term - as the slope there would be 1); this should be just fine
because anyway we didn't need the extra bitrate, and once we need it, we'll
have enough data to switch to an higher rate, in case. A caveat here: what
if we don't want an high throughput but we want low latency? We'll have to
see if your b) approach is reasonable - i.e. if the increased latency
provided by a lower bitrate is significant;
2) if the frame errors are below the threshold, no problem because we won't
switch rate (if we are near to the threshold) or we'll switch to an higher
one. We don't aim to 0 frame errors, but we aim to the threshold (and this
threshold could be meant as a userspace parameter, maybe, and may be seen as
a 'reliability over throughput' parameter).

> Ok, this whole thing sounds very promising to me. Now that we've
> discussed some important points, I'll go ahead and write some code,
> probably over the weekend.

If I'm not too busy, I'm going to help you.


--
Ciao
Stefano

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42207 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755540AbXK2B7s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 20:59:48 -0500
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving average
	estimate for rc80211_simple
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20071128184348.2d5843d1@morte>
References: <1196112605.8318.6.camel@localhost>
	 <20071127163520.028f91fb@morte> <1196199484.8298.23.camel@localhost>
	 <20071128002902.5dad5804@morte> <1196267661.8234.19.camel@localhost>
	 <20071128184348.2d5843d1@morte>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 02:59:43 +0100
Message-Id: <1196301583.7622.11.camel@localhost> (sfid-20071129_015953_693930_A70DFE92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-11-28 at 18:43 +0100, Stefano Brivio wrote:

> The size of the time interval (not to be confused with the sliding
> window) could vary depending on number of frames we tried to sent. But I
> don't know if this is worth the effort. I'll list a few examples:
> 1) we are downloading a big file through our NFS server at home; we dance
> around with our laptop in our hands and suddenly we fall behind a short
> wall - SNR drops by 10dB and we need to suddenly react at this, the D term
> does this and we would need the time interval to be short enough so that we
> notice in time about the fast drop in SNR;
> 2) what if we consider 1), except that we are just on IRC, sending a few
> frames every some seconds? The time interval needs to be short anyway,
> because we would notice about the drop in SNR too late otherwise;
> 3) we are stealing connectivity from the neighborhood, rain falls and
> humidity slowly increases, thus producing a slow decrease in SNR; the I
> term should deal with this, by integrating the error over time and thus
> force a lower rate after, maybe, some minutes; both if we make a lot of
> traffic or just send few frames, the time interval here should be short
> enough - again - so that we can actually see a consistent decrease in SNR
> between different time intervals.
> 
> So I'd say that for maximum granularity and good precision, we should try
> to keep this time interval as short as possible (my rough guess is about
> 1s). We then need to solve the issue you mentioned, but I'd come up with
> another approach here. Instead of taking a long time interval, let's do
> interpolation. In other words, we can reasonably assume that, if at a given
> time t we don't transmit any frame so we miss data, the frame errors rate
> is similar to the one at t-1, and if we missed data from t-1 as well, we
> grab the value from the t-2 interval, and so on. This is rough, but
> still it seems to me a precise enough method for dealing with the issue.

Ok, I your case study sounds reasonable :-) So I guess I'll stick with
averaging over fix sized time intervals. The interpolation approach you
suggest seems good enough. How I'd expect the rate control algorithm to
behave in situations with not much input data is:

a) Stay at the current rate, just assume conditions didn't change.
b) Be optimistic: Slowly ramp up tx rate, so if more data to be
transmitted is available, it'll get good rates from the beginning, if
possible.

I think the approach you suggest is basically a) if we aren't adjusting
rate heavily at the moment.

> 
>  
> > > The quick approach would be to round it to the nearest rate. A better
> > > one could be to keep a map of (1):[rate] <-> (2):[k1*rate + k2*recent
> > > errors at this rate], so that if we do have to decide whether to switch
> > > between two rates, we could actually evaluate the device performance -
> > > mainly sensitivity - at different rates(1), and accordingly think of
> > > the real difference between two rates(2). Then we round the output to
> > > the nearest rate(2) and choose the corresponding rate(1).
> > 
> > Ok, I understand. Question is whether it's worth the added overhead both
> > in computation and storage.
> 
> Probably not, but so far I've seen very few examples of PID controllers for
> data rates by googling around, and my guess here is that you would need to
> try the simplest approach and then go further adding complexity until you
> are satisfied.

Ok, this whole thing sounds very promising to me. Now that we've
discussed some important points, I'll go ahead and write some code,
probably over the weekend.

Mattias


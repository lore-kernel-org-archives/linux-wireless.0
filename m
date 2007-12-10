Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53420 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751496AbXLJWFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 17:05:53 -0500
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
	learning algorithm
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071210223018.2f7a31d1@morte>
References: <20071209211547.2d7fca32@morte> <20071209211931.26ff42fa@morte>
	 <1197239150.7543.13.camel@localhost> <20071210002158.654ed960@morte>
	 <1197269336.7490.25.camel@localhost> <20071210090323.47d657e6@morte>
	 <1197320192.7493.10.camel@localhost>  <20071210223018.2f7a31d1@morte>
Content-Type: text/plain
Date: Mon, 10 Dec 2007 23:05:50 +0100
Message-Id: <1197324350.7493.16.camel@localhost> (sfid-20071210_220604_223917_F9BAC790)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-10 at 22:30 +0100, Stefano Brivio wrote:
> On Mon, 10 Dec 2007 21:56:32 +0100
> Mattias Nissler <mattias.nissler@gmx.de> wrote:
> 
> > Sometimes, the stack sends frames at different rates than what was
> > decided by the rate control algorithm (there are several situations in
> > which this can happen, e.g. an AP only allowing 802.11b rates, rts/cts
> 
> No, wait, to consider rts/cts frames makes sense here, but I'd say that the
> same doesn't apply to AP only allowing 802.11b rates, because anyway
> non-CCK rates would get excluded from supported rates, and we wouldn't even
> map them.

Actually I meant we are an AP and decide we need to send b-only rates.

> 
> > frames, maybe more). But still, the tx status is reported back to the
> > rate control algorithm as for normal frames. Now the rate control
> > algorithm just doesn't care and accounts the tx status to the wrong
> > rate. This is clearly suboptimal. I cannot estimate how much impact this
> > behaviour has. However, it shouldn't be hard to improve the situation
> > either by reporting back to the rate control algorithm on which rate the
> > frame handed to tx_status() was actually transmitted, so it can decide
> > itself what to do about this (this is my preferred solution). Or you
> > could just have the stack don't call tx_status() for frames that were
> > transmitted on another rate.
> 
> Ok, got it. But I would just discard them, I can't think of any
> significant measurement on those frames. So I would follow the second
> approach here. Or do you have any suggestions on how to consider those
> frames?

As this fix is concerned with the rate control algorithm in general, we
should also consider other possible rate control algorithms. And I don't
think it's too far-fetched that this information might be valuable in
some cases. You are right, the PID algorithm should probably discard
them. But there is a gotcha: Suppose again, we're an AP and the stack
decides to transmit on b-only rates. If we just discard frames sent on
other rates, we'll soon be stuck on an OFDM rate and cannot switch back
since we don't have any measurements. I guess this whole issue needs
some more thought. Ideas welcome :-)

Mattias


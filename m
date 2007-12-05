Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41355 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751705AbXLEJEH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 04:04:07 -0500
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <200712050849.46760.hs4233@mail.mn-solutions.de>
References: <1196622331.7472.4.camel@localhost>
	 <20071204024146.15689ee3@morte>
	 <40f31dec0712041405sb14243dw9ccb7509e6f58d8@mail.gmail.com>
	 <200712050849.46760.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 10:04:04 +0100
Message-Id: <1196845444.7472.6.camel@localhost> (sfid-20071205_090412_012660_AD604D50)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-12-05 at 08:49 +0100, Holger Schurig wrote:
> On Tuesday 04 December 2007 23:05:28 Nick Kossifidis wrote:
> > [  3]  0.0-60.0 sec  29.4 MBytes  4.11 Mbits/sec  3.242 ms
> > [  3]  0.0-60.0 sec  29.4 MBytes  4.11 Mbits/sec  4.439 ms
> > [  3]  0.0-60.0 sec  32.7 MBytes  4.57 Mbits/sec
> ...
> 
> 
> Could it be the case that if we test the PID controller such way,
> then we optimize for throughtput in a scenario like "laptop sits 
> next the the AP".
> 
> Or, in other words: if we put the AP 80m away and then try the 
> test, would the same PID parameters that yielded high MB/s rates 
> now still keep us a sane (for that distance!) connection?

Good question. The important parameter here is the failed frames
precentage target value. If we're sitting next to the AP, the percentage
of failed frames will be very low, so the PID controller won't ever be
able to tune the TX rate to increase the failed frames percentage to the
target value. So this is not the right test case for tuning PID rate
control parameters. It'd be interesting to find out about the failed
frames percentage target value that gives us the best throughput. And
then do this experiment several times for different levels of distance
(or noise). Then see whether the optimal value is constant or not.

At the moment, I'm still cleaning up the rate control code. I also plan
to add some debugfs support, so we can retrieve the relevant data from
the kernel and make graphs from them. Only when this is done, I'm gonna
resume tuning parameters.

Mattias


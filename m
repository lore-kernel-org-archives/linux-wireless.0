Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41840 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751644AbXLDIPH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 03:15:07 -0500
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071204024146.15689ee3@morte>
References: <1196622331.7472.4.camel@localhost>
	 <20071203041608.3af3b462@morte> <1196679780.7470.9.camel@localhost>
	 <20071203125402.76562f26@morte> <1196683144.7470.14.camel@localhost>
	 <20071203130602.49ab7234@morte>
	 <40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
	 <20071204024146.15689ee3@morte>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 09:15:03 +0100
Message-Id: <1196756103.7476.12.camel@localhost> (sfid-20071204_081525_203373_81890F25)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stefano,

On Tue, 2007-12-04 at 02:41 +0100, Stefano Brivio wrote:
> I would say that these results show that the derivative coefficient is too
> high, or that the sharpening factor I introduced doesn't work that good.
> Anyway, just by a lowering a bit the failed frames target, results should be
> far better than the plain -simple algorithm.

Um, if Nick says the device has problems transmitting frames, IMHO this
will make it quite impossible to get the PID rate control right by
tuning parameters. Of course you can set the failed frames percentage
target to 100, but that's certainly not what we want. While I'm at it,
we should really run tests with different target values to see what
target gives us the best throughput in noisy situations.

Just an idea for your hack: wouldn't it be easier if we had all these
parameters accessible via debugfs instead of module parameters? Also, it
might be useful to have the parameters in sysfs so they can be changed
also for production systems, once mac80211 is stable.

Having the parameters in debugfs would also make things much easier for
me, since mac80211 oopses on module unload every now and then. I think
that started with the 2.6.24 series. So far I haven't had the time to
figure out why.

Mattias


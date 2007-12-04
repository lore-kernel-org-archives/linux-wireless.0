Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40140 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751331AbXLDRkv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 12:40:51 -0500
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20071204110135.1835a57e@morte>
References: <1196622331.7472.4.camel@localhost>
	 <20071203041608.3af3b462@morte> <1196679780.7470.9.camel@localhost>
	 <20071203125402.76562f26@morte> <1196683144.7470.14.camel@localhost>
	 <20071203130602.49ab7234@morte>
	 <40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
	 <20071204024146.15689ee3@morte> <1196756103.7476.12.camel@localhost>
	 <20071204110135.1835a57e@morte>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 18:40:47 +0100
Message-Id: <1196790047.7472.5.camel@localhost> (sfid-20071204_174054_741811_0CB579E5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-12-04 at 11:01 +0100, Stefano Brivio wrote:
> On Tue, 04 Dec 2007 09:15:03 +0100
> Mattias Nissler <mattias.nissler@gmx.de> wrote:
> 
> > Um, if Nick says the device has problems transmitting frames, IMHO this
> > will make it quite impossible to get the PID rate control right by
> > tuning parameters. Of course you can set the failed frames percentage
> > target to 100, but that's certainly not what we want.
> 
> Ok, sure. But to some degree, having problems in transmitting frames
> because of driver issues is an approximation of a noisy environment.
> However, we can't do so much in this specific case.

I don't think this data is useful for tuning the TX control algorithm at
all. In the case of a noisy channel, you can improve the rate of
successful transmission by switching to a more-robust rate. However, if
the driver just gets the parameters wrong, a slower rate won't help at
all, thus the feedback loop model on which the PID controller relies is
severely flawed.

> 
> > Just an idea for your hack: wouldn't it be easier if we had all these
> > parameters accessible via debugfs instead of module parameters? Also, it
> > might be useful to have the parameters in sysfs so they can be changed
> > also for production systems, once mac80211 is stable.
> 
> They are in sysfs. You just need to set perm to 0644. But this is racy, and
> you should implement some locking, and I just didn't want to bother about
> this. It's not racy, if you make sure that the interface is down while you
> write parameters. Of course, if we want these parameters to get into
> mac80211, proper locking should be implemented.

Ah, ok, module parameters show up in sysfs. This is good for testing,
but if we want to make some parameters available for everybody, we
cannot rely on module parameters, i.e. when mac80211 is compiled int the
kernel. I'd say we even want to be able to tweak the parameters on a per
device basis, we should really add them to mac80211 sysfs.

Mattias


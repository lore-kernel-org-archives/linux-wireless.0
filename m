Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59248 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754427AbXKYSZ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 13:25:28 -0500
Subject: Re: [PATCH] mac80211: Exponential moving average estimate for
	rc80211_simple
From: Mattias Nissler <mattias.nissler@gmx.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1196014318.8365.1.camel@localhost>
References: <1196014318.8365.1.camel@localhost>
Content-Type: text/plain
Date: Sun, 25 Nov 2007 19:25:26 +0100
Message-Id: <1196015126.8365.14.camel@localhost> (sfid-20071125_182530_900804_4D070DAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I guess this patch will spawn a discussion, so let me comment a little
more.

I have a rt61pci card sitting in the box under my desk. Seems reception
isn't really good below my desk :-) With the current rc80211_simple I
have the following behaviour: Failed frames accumulate until
rc80211_simple decides to lower the rate. Unfortunately, the rate
control algorithm is quite unresponsive, so my rate goes down to 1Mb/s
immediately. Then I have to wait for some minutes until the statistics
have recovered enough for the rate control to raise the rate. Of course
it goes straight through the roof to 54Mb/s. Errors accumulate, and soon
I'm back at 1Mb/s. And so on.

My patch changes the way the average of failed frames is computed. By
using a moving average approach, old values don't influence the estimate
after some time (note the current approach always uses the plain
counters, thus using all information accumulated since the interface has
been brought up!). This makes the estimate more responsive and thus the
rate control algorithm works a lot better.

I've tested my approach by listening to web radio for some time and it
successfully keeps me between around 24Mb/s and 54Mb/s. From what I see
here, that's a big improvement over the roller coaster rate control
behaviour I had before.

Mattias


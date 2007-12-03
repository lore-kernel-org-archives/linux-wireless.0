Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48352 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751358AbXLCXgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 18:36:09 -0500
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
References: <1196622331.7472.4.camel@localhost>
	 <20071203041608.3af3b462@morte> <1196679780.7470.9.camel@localhost>
	 <20071203125402.76562f26@morte> <1196683144.7470.14.camel@localhost>
	 <20071203130602.49ab7234@morte>
	 <40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 00:36:05 +0100
Message-Id: <1196724965.7468.74.camel@localhost> (sfid-20071203_233624_035777_0E213A1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick,

thanks for your input.

On Tue, 2007-12-04 at 00:42 +0200, Nick Kossifidis wrote: 
> Here are some tests with ath5k + your patches...
> 
> I've tested a 5213 and a 5413 card, both have poor phy performance (we
> still work on phy initialization,  txpower etc) that means they
> receive ok but they can't transmit well (with other supported cards
> i've got much better performance up to 27Mbits/sec but i didn't have
> one in hand while testing, if you want i can repeat the test).

Hm, so the rate control will probably limit TX rate more than necessary
because of transmission failures caused by the driver.

> 
> I've run iperf on the previous rate control, the patched one and with
> locked tx rate.

Looking at your data, it's interesting to see that TX rate varies a lot.
I don't know your setup, but I doubt this is due to noise/interference
varying at your place. Question is whether it's the drivers fault or the
rate control failing. But still the PID rate control performs better
than the old simple algorithm.

I'll run a similar set of tests on my rt61 for comparison.

Mattias



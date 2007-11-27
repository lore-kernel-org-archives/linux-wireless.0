Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40656 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760000AbXK0Vas (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 16:30:48 -0500
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving
	average	estimate for rc80211_simple
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <474C32CB.9090301@lwfinger.net>
References: <1196112605.8318.6.camel@localhost>
	 (sfid-20071126_213044_416915_EDBE20FD) <1196172814.6058.23.camel@johannes.berg>
	 <474C32CB.9090301@lwfinger.net>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 22:30:44 +0100
Message-Id: <1196199044.8298.15.camel@localhost> (sfid-20071127_213121_819437_859ADA35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-11-27 at 09:07 -0600, Larry Finger wrote:
> Johannes Berg wrote:
> > On Mon, 2007-11-26 at 22:30 +0100, Mattias Nissler wrote:
> >> This changes rc80211_simple failed frame percentage estimation to use an
> >> exponential moving average method. Failed frames percentage is sampled over
> >> time and a smoothed average is computed. This average is examined periodically
> >> and the rate adjusted eventually.
> >>
> >> Compared to the old method this new approach is much more responsive. The old
> >> method used plain tx success/failure counters. This made rate control very
> >> unresponsive after a short time of using the interface, since old data wouldn't
> >> age properly.
> > 
> > Sounds sane and better than before. If it works we can apply this I
> > guess.
> 
> I have not done any rigorous testing of this patch; however, it has not caused any harm on my system.

Good to hear. I've tested it with rt61pci and rt73usb. I guess you
tested b43[legacy]. Any other test results, especially in low signal
quality situations would be of great help.

Mattias


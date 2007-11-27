Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59893 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758055AbXK0V3M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 16:29:12 -0500
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving average
	estimate for rc80211_simple
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1196172814.6058.23.camel@johannes.berg>
References: <1196112605.8318.6.camel@localhost>
	 (sfid-20071126_213044_416915_EDBE20FD)  <1196172814.6058.23.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 22:29:07 +0100
Message-Id: <1196198947.8298.13.camel@localhost> (sfid-20071127_212915_589364_6A5C33A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-11-27 at 15:13 +0100, Johannes Berg wrote:
> On Mon, 2007-11-26 at 22:30 +0100, Mattias Nissler wrote:
> > This changes rc80211_simple failed frame percentage estimation to use an
> > exponential moving average method. Failed frames percentage is sampled over
> > time and a smoothed average is computed. This average is examined periodically
> > and the rate adjusted eventually.
> > 
> > Compared to the old method this new approach is much more responsive. The old
> > method used plain tx success/failure counters. This made rate control very
> > unresponsive after a short time of using the interface, since old data wouldn't
> > age properly.
> 
> Sounds sane and better than before. If it works we can apply this I
> guess.

Before this goes in, I have at least one issue to be discussed: As it
is, the patch calculates the failed frames percentage exclusively from
the retry_count. I'm not sure whether this is what we want, because some
drivers cannot provide this parameter (or they only know there have been
retries, but not how many). This is the case e.g. for the rt2x00 usb
devices. I'm not sure what to do about this. My suggestion would be
something like:

	srctrl->tx_num_xmit++;

	if (status->excessive_retries) {
		srctrl->tx_num_failed += 2;
		srctrl->tx_num_xmit++;
	} else if (status->retry_count) {
		srctrl->tx_num_failed++;
		srctrl->tx_num_xmit++;
	}

This accounts correctly transmitted frames as one good, failed frames 2
bad and retry-succeeded frames 1 good + 1 bad point in the failed
percentage calculation. Opinions?

Mattias


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60276
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbXIKKyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 06:54:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: zd-mac80211: Fix TX status reports.
Date: Tue, 11 Sep 2007 12:52:29 +0200
Cc: Tomas Winkler <tomasw@gmail.com>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200709082341.31720.mb@bu3sch.de> <200709111220.31700.mb@bu3sch.de> <1189506596.6161.14.camel@johannes.berg>
In-Reply-To: <1189506596.6161.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200709111252.30291.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 September 2007 12:29:56 Johannes Berg wrote:
> On Tue, 2007-09-11 at 12:20 +0200, Michael Buesch wrote:
> 
> > What about the following:
> > We have a "the packet failed" IRQ. so we know that if that didn't
> > raise for a packet, it must have succeed.
> > So currently we already maintain a queue of TX packets. What about
> > changing the handling of this queue? Instead of dropping (and
> > telling mac80211 success) on an ACK RX, simply do a timeout.
> > We can calculate the time (plus some additional msecs to be sure)
> > by when an ACK must have arrived, no? 
> 
> That's tricky though, because multiple retry rates mean that it can
> possibly take quite a while for the packet to go through. And ath5k
> wants to support up to 7 different rates for each packet.

I'm only talking about zd, though.

> > So, if that times out,
> > signal a success. Wouldn't that be reliable? Given that the "tx failed"
> > IRQ actually _is_ reliable.
> 
> Yeah, and in-order would have to be guaranteed as well so we can match
> which packet failed and assume all previous ones were OK.

-- 
Greetings Michael.

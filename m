Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57685
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbXIKKXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 06:23:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: zd-mac80211: Fix TX status reports.
Date: Tue, 11 Sep 2007 12:20:31 +0200
Cc: Tomas Winkler <tomasw@gmail.com>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200709082341.31720.mb@bu3sch.de> <1ba2fa240709102050l75402df4w19ef746d6243dbab@mail.gmail.com> <1189505821.6161.1.camel@johannes.berg>
In-Reply-To: <1189505821.6161.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200709111220.31700.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 September 2007 12:17:01 Johannes Berg wrote:
> > However I liked the idea about
> > 
> > "An alternative option could be that the mac80211 stack would call
> > a non-atomic function of the driver to report the total count of
> > transmitted packets and the number of successful transmissions."
> > 
> > This mechanism will help us to implement aggregation rate scaling
> > I would actually prefer if such statistics will be pushed by driver
> > rather then pulled by mac though.
> 
> It doesn't help knowing whether the relevant packets were acked though.

What about the following:
We have a "the packet failed" IRQ. so we know that if that didn't
raise for a packet, it must have succeed.
So currently we already maintain a queue of TX packets. What about
changing the handling of this queue? Instead of dropping (and
telling mac80211 success) on an ACK RX, simply do a timeout.
We can calculate the time (plus some additional msecs to be sure)
by when an ACK must have arrived, no? So, if that times out,
signal a success. Wouldn't that be reliable? Given that the "tx failed"
IRQ actually _is_ reliable.

-- 
Greetings Michael.

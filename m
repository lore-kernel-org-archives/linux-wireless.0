Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab2FOQsC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 12:48:02 -0400
Message-ID: <1339778927.22782.25.camel@dcbw.foobar.com> (sfid-20120615_184806_616487_455E5E38)
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
From: Dan Williams <dcbw@redhat.com>
To: Andreas Kemnade <andreas@kemnade.info>
Cc: hong zhang <henryzhang62@yahoo.com>,
	linux-wireless@vger.kernel.org, dsd@laptop.org,
	libertas-dev@lists.infradead.org
Date: Fri, 15 Jun 2012 11:48:47 -0500
In-Reply-To: <20120615081850.77454e10@kemnade.info>
References: <20120614074545.105a459d@kemnade.info>
	 <1339690266.19412.YahooMailClassic@web161704.mail.bf1.yahoo.com>
	 <20120615081850.77454e10@kemnade.info>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-15 at 08:18 +0200, Andreas Kemnade wrote:
> Hi,
> 
> On Thu, 14 Jun 2012 09:11:06 -0700 (PDT)
> hong zhang <henryzhang62@yahoo.com> wrote:
> 
> > bit mode and interrupt or PIO are configured in SDIO hoster side.
> > Not in driver side.
> > 
> yes, I wrote the last email just to say that I have found something to look at.
> That is of course in the host driver. So the thing I did was reading
> commit logs of the 2.6.32 kernel working well.
> 
> The only thing which puzzles me is the 5.5Mb/s data rate iwconfig shows.
> After playing with the host side driver, it also shows higher rates. But
> why does host driver affects *that* data rate of link qualitiy is good?

As said, that's the WiFi air link rate which is determined by the
firmware based on the link quality with the AP, on things like RSSI,
missed beacons, TX/RX errors, etc.  That's not the SDIO data rate which
is completely independent.

Dan


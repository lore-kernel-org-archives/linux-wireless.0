Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm18-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.145]:20978 "HELO
	nm18-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756969Ab2FOO4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 10:56:48 -0400
Message-ID: <1339772206.64850.YahooMailClassic@web161701.mail.bf1.yahoo.com> (sfid-20120615_165651_575291_AFEA82D8)
Date: Fri, 15 Jun 2012 07:56:46 -0700 (PDT)
From: hong zhang <henryzhang62@yahoo.com>
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
To: Andreas Kemnade <andreas@kemnade.info>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	dsd@laptop.org, libertas-dev@lists.infradead.org
In-Reply-To: <20120615081850.77454e10@kemnade.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To measure throughput, should not check iwconfig that is not accurate.

1. use wpa_supplicant to associate with AP
2. use iperf to measure throughput using UDP for Rx and Tx.

for SDIO host, command 52 doing register configuration. For rate, command 53 handles data rate. as sdio spec says clock rate is 0 to 100kHz means low speed mode. clock 0 to 25MHz means high speed mode.

Max throughput = clock-rate*num-of-data-line
for 4-bit, high clock,
max-throughput=25M*4=100Mbits/sec.
for 1-bit,low rate
max-throughput=100K*1=100Kbits/sec.



--- On Fri, 6/15/12, Andreas Kemnade <andreas@kemnade.info> wrote:

> From: Andreas Kemnade <andreas@kemnade.info>
> Subject: Re: poor performance with W2CBW003 (Marvell 8686)
> To: "hong zhang" <henryzhang62@yahoo.com>
> Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org, dsd@laptop.org, libertas-dev@lists.infradead.org
> Date: Friday, June 15, 2012, 1:18 AM
> Hi,
> 
> On Thu, 14 Jun 2012 09:11:06 -0700 (PDT)
> hong zhang <henryzhang62@yahoo.com>
> wrote:
> 
> > bit mode and interrupt or PIO are configured in SDIO
> hoster side.
> > Not in driver side.
> > 
> yes, I wrote the last email just to say that I have found
> something to look at.
> That is of course in the host driver. So the thing I did was
> reading
> commit logs of the 2.6.32 kernel working well.
> 
> The only thing which puzzles me is the 5.5Mb/s data rate
> iwconfig shows.
> After playing with the host side driver, it also shows
> higher rates. But
> why does host driver affects *that* data rate of link
> qualitiy is good?
> 
> Thanks for all your ideas where to look at.
> 
> Greetings
> Andreas Kemnade
> 

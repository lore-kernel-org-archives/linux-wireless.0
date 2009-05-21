Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbZEUWiV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 18:38:21 -0400
Subject: Re: Throughput is not changed when setting to a much higher bit
 rate
From: Dan Williams <dcbw@redhat.com>
To: Dongas <dongas86@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <60ce8d250905201700v13fe1394l6a9704bb02be3807@mail.gmail.com>
References: <60ce8d250905191048t46e3848fw3416ecd793dab9d1@mail.gmail.com>
	 <20090519175336.GF2691@tuxdriver.com>
	 <60ce8d250905200748p5984df0bl1984f0d3bdaf79b5@mail.gmail.com>
	 <1242854588.7048.13.camel@localhost.localdomain>
	 <60ce8d250905201700v13fe1394l6a9704bb02be3807@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 18:38:20 -0400
Message-Id: <1242945500.6444.24.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-05-21 at 08:00 +0800, Dongas wrote:
> 2009/5/21 Dan Williams <dcbw@redhat.com>:
> > On Wed, 2009-05-20 at 22:48 +0800, Dongas wrote:
> >> 2009/5/20 John W. Linville <linville@tuxdriver.com>:
> >> > On Wed, May 20, 2009 at 01:48:32AM +0800, Dongas wrote:
> >> >
> >> >> Why the bandwidth is not changed when bit rate is changed to 11Mb/s?
> >> >> Any thing wrong?
> >> >
> >> > More errors at higher bit rate, resulting in more retries?  Just a
> >> > thought...
> >> >
> >> Is there a quick way to verify this possible reason? I'm using Libertas driver.
> >>
> >> BTW, my sdio host driver is using polling mode to handle SDIO IRQ.
> >> Could this be the cause of such poor performance?
> >
> > Definitely.  With libertas, the largest class of issues by *far* that
> > we've seen are controller related.  I seem to recall that I've pulled
> > about 6Mbps through the card using a normal Ricoh controller from a
> > Fujitsu laptop.  I can recheck that.
> 
> AFAIK, most old laptop ,including my x61, doesn't support SDIO in HW.
> So did Ricoh controller you tested use polling mode to handle SDIO IRQ?
> Which clock of controller and which bit rate did you test?

Actually, most of the older machines *can* do SDIO, those made from
about 2006 - 2009.  These days a lot of the SD "controllers" are
actually USB-based mass-storage converters and cannot do SDIO, they are
essentially 10-in-1 cardreaders.

What is the 'lspci' output for your Thinkpad?  If the controller isn't
in 'lspci' but is in 'lsusb', then it's quite unlikely to work because
of the above reason, I think.

Dan

> >> (However I just can't believe the performance is so poor ,only around
> >> 1.1Mbps, with polling mode of SDIO IRQ)
> >
> > What specific kernel version are you using?  There have been some
> > latency fixes in recent kernels, but would be good to know just to make
> > sure.
> 
> I'm using kenrel 2.6.25.
> 
> Thanks
> 
> Regards
> Dongas


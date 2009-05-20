Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42156 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688AbZETVXJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 17:23:09 -0400
Subject: Re: Throughput is not changed when setting to a much higher bit
 rate
From: Dan Williams <dcbw@redhat.com>
To: Dongas <dongas86@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <60ce8d250905200748p5984df0bl1984f0d3bdaf79b5@mail.gmail.com>
References: <60ce8d250905191048t46e3848fw3416ecd793dab9d1@mail.gmail.com>
	 <20090519175336.GF2691@tuxdriver.com>
	 <60ce8d250905200748p5984df0bl1984f0d3bdaf79b5@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 20 May 2009 17:23:08 -0400
Message-Id: <1242854588.7048.13.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-20 at 22:48 +0800, Dongas wrote:
> 2009/5/20 John W. Linville <linville@tuxdriver.com>:
> > On Wed, May 20, 2009 at 01:48:32AM +0800, Dongas wrote:
> >
> >> Why the bandwidth is not changed when bit rate is changed to 11Mb/s?
> >> Any thing wrong?
> >
> > More errors at higher bit rate, resulting in more retries?  Just a
> > thought...
> >
> Is there a quick way to verify this possible reason? I'm using Libertas driver.
> 
> BTW, my sdio host driver is using polling mode to handle SDIO IRQ.
> Could this be the cause of such poor performance?

Definitely.  With libertas, the largest class of issues by *far* that
we've seen are controller related.  I seem to recall that I've pulled
about 6Mbps through the card using a normal Ricoh controller from a
Fujitsu laptop.  I can recheck that.

> (However I just can't believe the performance is so poor ,only around
> 1.1Mbps, with polling mode of SDIO IRQ)

What specific kernel version are you using?  There have been some
latency fixes in recent kernels, but would be good to know just to make
sure.

Dan


> Thanks a lot for the reply.
> 
> Regards
> Dongas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


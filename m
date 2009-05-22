Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42126 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbZEVDt6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 23:49:58 -0400
Subject: Re: Throughput is not changed when setting to a much higher bit
 rate
From: Dan Williams <dcbw@redhat.com>
To: Dongas <dongas86@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <60ce8d250905211727m71f2d17eice895fa961d82e17@mail.gmail.com>
References: <60ce8d250905191048t46e3848fw3416ecd793dab9d1@mail.gmail.com>
	 <20090519175336.GF2691@tuxdriver.com>
	 <60ce8d250905200748p5984df0bl1984f0d3bdaf79b5@mail.gmail.com>
	 <1242854588.7048.13.camel@localhost.localdomain>
	 <60ce8d250905211727m71f2d17eice895fa961d82e17@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 21 May 2009 23:49:53 -0400
Message-Id: <1242964193.8569.42.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-05-22 at 08:27 +0800, Dongas wrote:
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
> >
> 
> Thanks for your info,Dan.
> For Libertas driver , do you know which reason would be the cause of
> the issue i encounterred?
> Basically if i set the bit rate of Marvell card to a much higher value
> such as 11Mb/s or even 48Mb/s, the HW should be capable of
> transferring in hign bit rate.
> However , the result from iperf indicates that the real bandwidth is
> remain around 1.1Mbps, even no improvement.
> It seems Marvell 8686 WiFi module will adjust the bit rate according
> to the real situation.
> So the bottleneck would be host side , HW or driver, right?
> If there a way for me to debug this issue in libertas driver to find
> out the root reason?
> If the issue is related to our HW, we would like to take some
> modifications on it.

Tests with my *unshielded* 8686 dev module with 15 other APs in the
area, running v9 firmware from the linux-firmware git tree, pulling a
240123904 byte file off a host connected via ethernet to a Netgear
WGR614 802.11g router using WPA-PSK:

HP EliteBook 2530p  (1.40 MB/s)
------------------------------
Core 2 Duo LV 1.86GHz
2.6.29.3-140.fc11.x86_64
Ricoh R5C822 (rev 22)

Fujitsu Lifebook P7230  (1015 KB/s)
------------------------------
Core Duo LV 1.2GHz
2.6.29.2-126.fc11.i586
Ricoh R5C822 (rev 17)

Fujitsu LifeBook P1510  (1.26 MB/s)
------------------------------
Pentium M 1.2GHz
2.6.27.15-170.2.24.fc10.i686
Ricoh R5C822 (rev 13)


So that's up to 11Mbps (bursting to 12.5 Mbps) on the Ricoh controller,
which is a pretty sane, standard SDIO controller on many laptops.
Unfortunately, all I have to test with are Ricoh controllers...

In the past, most of the issues we've had are due to the host controller
used, not really the libertas driver or the chip itself.  Yes, there are
deficiencies in the driver, but apparently speed isn't one of them when
it's used in combination with a Ricoh controller on a laptop.  There
were some questions earlier about speed with embedded controllers being
correlated to HZ somehow, but I think we took care of that with
9b02f419a7dbd956b2c293e5cb1790b6b687f367 in February.

Dan



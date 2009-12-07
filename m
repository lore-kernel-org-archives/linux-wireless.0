Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54479 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S935670AbZLGXGX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 18:06:23 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 =?utf-8?q?in=092=2E6=2E32?=
Date: Tue, 8 Dec 2009 00:06:26 +0100
Cc: Andi Kleen <andi@firstfloor.org>, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
References: <20091204233202.GA13658@basil.fritz.box> <4B1BB44E.90706@gmail.com>
In-Reply-To: <4B1BB44E.90706@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200912080006.28892.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Monday 07 December 2009, Gertjan van Wingerde wrote:
> On 12/05/09 00:32, Andi Kleen wrote:
> > [Rafael, something for your regression list]
> > 
> > I upgraded a system which was running 2.6.30 to 2.6.32.
> > It has a 
> > 
> > 06:02.0 Network controller: RaLink RT2561/RT61 802.11g PCI
> > 
> > wireless PCI card. Now regularly even under moderate traffic
> > I see messages like
> > 
> > phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
> > Please file bug report to http://rt2x00.serialmonkey.com.
> > 
> > and loss of connectivity, often until the wireless connection
> > is restarted. This wasn't the case in 2.6.30, there the driver
> > ran stable without any problems. The problem currently
> > happens every few minutes.

I can reproduce the problem with 2.6.32 and rt61pci.

rt73usb and rt2500usb seem to be fine.
 
> Andi, Tim,
> 
> Both of you have reported this problem on 2.6.32.
> 
> In the past this always has occurred due to queue locking problems. This led me
> to audit the queue locking code, and that certainly looked suspicious to me.
> 
> Would you be able to test whether the attached test patch fixes the problem for
> you. The patch basically applies proper queue locking to the code, although in 
> a very course manner. The patch is relative to 2.6.32.
> 
> Note: I am not 100% sure that this is where the problem is, but at least the test
> patch should confirm whether I am searching in the right direction.

This patch doesn't seem to change this particular issue, disabling 
powersaving however makes rt62pci work again.

Regards
	Stefan Lippers-Hollmann

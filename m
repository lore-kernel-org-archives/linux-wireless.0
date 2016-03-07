Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:49269 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbcCGLOu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 06:14:50 -0500
Date: Mon, 7 Mar 2016 12:14:43 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Tuomas =?iso-8859-1?Q?R=E4s=E4nen?= <tuomasjjrasanen@tjjr.fi>
Cc: Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, tuomasjjrasanen@opinsys.fi,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: About adding support for MT76x2U to Linux kernel
Message-ID: <20160307111443.GA7205@sig21.net> (sfid-20160307_121454_520014_34C1063C)
References: <20150814081526.GC20192@hackpad.Elisa>
 <20150814143229.61440072@north>
 <20160302073210.GA31353@lakka.kapsi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20160302073210.GA31353@lakka.kapsi.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 02, 2016 at 09:32:10AM +0200, Tuomas Räsänen wrote:
> On Fri, Aug 14, 2015 at 02:32:29PM +0200, Jakub Kiciński wrote:
> > CC: Linus W who was hacking on mt7630e recently.
> > 
> > There is a fourth option: merge mt76 and mt7601u and add support for
> > mt76x2u along the way ;)
> 
> Btw, how difficult it would be to add master mode support to mt7601u?
> 
> From 1 to 5, where 1 corresponds to "I know what I do, just give me
> couple of days, no interruptions" and 5 corresponds to the work you
> had to make to get mt7601u to its current shape?

I can't answer that question, but I've spent time studying
the various drivers in preparation for adding support
for mt7610u, my conclusion is the hardware is similar
to mt76x2e (same MAC, same RF) so for me that's the way to go.

The big drawback of the USB devices is the lack of interrupts,
especially no TBTT and PRE_TBTT, so it's not clear how to
support AP mode properly.  FWIW, the mt7610u vendor driver
doesn't support AP mode, while the mt7612u vendor driver does,
but I didn't understand how their timing of sending buffered
frames works.

Another concern is the handling of the TX status since there
is also no TX_STAT interrupt.  I remember from rt2800usb
it was always problematic to ensure no FIFO items were lost,
which is a problem for rt2800usb since it doesn't report
TX status before it got it from the hardware.
The mt7601u driver takes the approach to report IEEE80211_TX_STAT_ACK
immediately after urb completion, and send the real
status later from a delayed workqueue in mt7601u_tx_stat().
Could someone enlighten me if this approach is sane
wrt to minstrel rate control?

The mt7610u vendor driver doesn't use the TX_STAT_FIFO at
all (it has code to read it but it is bypassed for mt7610u),
its rate control relies on the statistic registers only.


Johannes

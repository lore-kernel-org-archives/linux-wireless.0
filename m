Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:50425 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbcCGMl7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:41:59 -0500
Date: Mon, 7 Mar 2016 13:41:03 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Tuomas =?iso-8859-1?Q?R=E4s=E4nen?= <tuomasjjrasanen@tjjr.fi>,
	Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>,
	linux-wireless@vger.kernel.org, tuomasjjrasanen@opinsys.fi,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: About adding support for MT76x2U to Linux kernel
Message-ID: <20160307124103.GA22175@sig21.net> (sfid-20160307_134202_678081_11838010)
References: <20150814081526.GC20192@hackpad.Elisa>
 <20150814143229.61440072@north>
 <20160302073210.GA31353@lakka.kapsi.fi>
 <20160307111443.GA7205@sig21.net>
 <56DD6B4F.2050405@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56DD6B4F.2050405@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 07, 2016 at 12:51:43PM +0100, Felix Fietkau wrote:
> On 2016-03-07 12:14, Johannes Stezenbach wrote:
> > FWIW, the mt7610u vendor driver
> > doesn't support AP mode, while the mt7612u vendor driver does,
> > but I didn't understand how their timing of sending buffered
> > frames works.
> Where can I find the most recent version of that vendor driver?
> I can take a quick look at it.

http://www.mediatek.com/en/downloads1/downloads/
or more specifically
http://www.mediatek.com/en/downloads1/downloads/mt7612u/

> > Another concern is the handling of the TX status since there
> > is also no TX_STAT interrupt.  I remember from rt2800usb
> > it was always problematic to ensure no FIFO items were lost,
> > which is a problem for rt2800usb since it doesn't report
> > TX status before it got it from the hardware.
> > The mt7601u driver takes the approach to report IEEE80211_TX_STAT_ACK
> > immediately after urb completion, and send the real
> > status later from a delayed workqueue in mt7601u_tx_stat().
> > Could someone enlighten me if this approach is sane
> > wrt to minstrel rate control?
> When I started writing mt76 I did lots of experiments with trying to map
> TX_STAT_FIFO data to individual frames and pretty much gave up, because
> the status register was just too unreliable. Even in cases where it was
> reliable, mapping the status info to frames is expensive on slower
> embedded hardware, so I pretty much gave up on that approach and
> extended the rate control API to support submitting tx status
> information without the corresponding skb.
> 
> This turned out to work quite well, and I think it might be worth using
> to some extent even on drivers with proper skb tx status reporting,
> since it has better cache footprint and has to run less code.
> 
> I think the best approach is to try to map tx status info from
> TX_STAT_FIFO in cases where IEEE80211_TX_CTL_REQ_TX_STATUS is set, and
> just use ieee80211_tx_status_noskb for all other frames. I did something
> like that on my work-in-progress mt7603 code.

OK, I thought minstrels send some probe frames with high
rates to check if they go through and thus relies
on exact TX status for these? (IEEE80211_TX_CTL_RATE_CTRL_PROBE)

Thanks,
Johannes

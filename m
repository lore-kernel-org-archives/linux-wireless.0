Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caladan.dune.hu ([78.24.191.180]:57164 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751146AbcCGLvs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 06:51:48 -0500
Subject: Re: About adding support for MT76x2U to Linux kernel
To: Johannes Stezenbach <js@sig21.net>,
	=?UTF-8?Q?Tuomas_R=c3=a4s=c3=a4nen?= <tuomasjjrasanen@tjjr.fi>
References: <20150814081526.GC20192@hackpad.Elisa>
 <20150814143229.61440072@north> <20160302073210.GA31353@lakka.kapsi.fi>
 <20160307111443.GA7205@sig21.net>
Cc: =?UTF-8?Q?Jakub_Kici=c5=84ski?= <moorray3@wp.pl>,
	linux-wireless@vger.kernel.org, tuomasjjrasanen@opinsys.fi,
	Linus Walleij <linus.walleij@linaro.org>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56DD6B4F.2050405@openwrt.org> (sfid-20160307_125151_574333_665F8B86)
Date: Mon, 7 Mar 2016 12:51:43 +0100
MIME-Version: 1.0
In-Reply-To: <20160307111443.GA7205@sig21.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-03-07 12:14, Johannes Stezenbach wrote:
> On Wed, Mar 02, 2016 at 09:32:10AM +0200, Tuomas Räsänen wrote:
>> On Fri, Aug 14, 2015 at 02:32:29PM +0200, Jakub Kiciński wrote:
>> > CC: Linus W who was hacking on mt7630e recently.
>> > 
>> > There is a fourth option: merge mt76 and mt7601u and add support for
>> > mt76x2u along the way ;)
>> 
>> Btw, how difficult it would be to add master mode support to mt7601u?
>> 
>> From 1 to 5, where 1 corresponds to "I know what I do, just give me
>> couple of days, no interruptions" and 5 corresponds to the work you
>> had to make to get mt7601u to its current shape?
> 
> I can't answer that question, but I've spent time studying
> the various drivers in preparation for adding support
> for mt7610u, my conclusion is the hardware is similar
> to mt76x2e (same MAC, same RF) so for me that's the way to go.
> 
> The big drawback of the USB devices is the lack of interrupts,
> especially no TBTT and PRE_TBTT, so it's not clear how to
> support AP mode properly.  FWIW, the mt7610u vendor driver
> doesn't support AP mode, while the mt7612u vendor driver does,
> but I didn't understand how their timing of sending buffered
> frames works.
Where can I find the most recent version of that vendor driver?
I can take a quick look at it.

> Another concern is the handling of the TX status since there
> is also no TX_STAT interrupt.  I remember from rt2800usb
> it was always problematic to ensure no FIFO items were lost,
> which is a problem for rt2800usb since it doesn't report
> TX status before it got it from the hardware.
> The mt7601u driver takes the approach to report IEEE80211_TX_STAT_ACK
> immediately after urb completion, and send the real
> status later from a delayed workqueue in mt7601u_tx_stat().
> Could someone enlighten me if this approach is sane
> wrt to minstrel rate control?
When I started writing mt76 I did lots of experiments with trying to map
TX_STAT_FIFO data to individual frames and pretty much gave up, because
the status register was just too unreliable. Even in cases where it was
reliable, mapping the status info to frames is expensive on slower
embedded hardware, so I pretty much gave up on that approach and
extended the rate control API to support submitting tx status
information without the corresponding skb.

This turned out to work quite well, and I think it might be worth using
to some extent even on drivers with proper skb tx status reporting,
since it has better cache footprint and has to run less code.

I think the best approach is to try to map tx status info from
TX_STAT_FIFO in cases where IEEE80211_TX_CTL_REQ_TX_STATUS is set, and
just use ieee80211_tx_status_noskb for all other frames. I did something
like that on my work-in-progress mt7603 code.

- Felix

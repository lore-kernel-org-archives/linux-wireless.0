Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caladan.dune.hu ([78.24.191.180]:59236 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752537AbcCHM6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 07:58:07 -0500
Subject: Re: About adding support for MT76x2U to Linux kernel
To: Johannes Stezenbach <js@sig21.net>
References: <20150814081526.GC20192@hackpad.Elisa>
 <20150814143229.61440072@north> <20160302073210.GA31353@lakka.kapsi.fi>
 <20160307111443.GA7205@sig21.net> <56DD6B4F.2050405@openwrt.org>
 <20160307124103.GA22175@sig21.net> <56DDF11E.3060102@openwrt.org>
 <20160308124908.GA14746@sig21.net>
Cc: =?UTF-8?Q?Tuomas_R=c3=a4s=c3=a4nen?= <tuomasjjrasanen@tjjr.fi>,
	=?UTF-8?Q?Jakub_Kici=c5=84ski?= <moorray3@wp.pl>,
	linux-wireless@vger.kernel.org, tuomasjjrasanen@opinsys.fi,
	Linus Walleij <linus.walleij@linaro.org>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56DECC5B.2090508@openwrt.org> (sfid-20160308_135824_911345_D1FFA4FD)
Date: Tue, 8 Mar 2016 13:58:03 +0100
MIME-Version: 1.0
In-Reply-To: <20160308124908.GA14746@sig21.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-03-08 13:49, Johannes Stezenbach wrote:
> On Mon, Mar 07, 2016 at 10:22:38PM +0100, Felix Fietkau wrote:
>> On 2016-03-07 13:41, Johannes Stezenbach wrote:
>> > http://www.mediatek.com/en/downloads1/downloads/mt7612u/
>> I checked, they simply use a software timer for it and stuff buffered
>> multicast packets into the BE queue. I don't think the hardware offers
>> any better way of doing this...
> 
> I had to refresh my memory on this driver.  The thing that tripped
> me when I first read through it was that is using a jiffies based
> timer and additionally sets it to fire 10ms after the calculated
> beacon time.  So it's always too late, isn't it?
> 
> But of course it is irrelevant for us since we can use a hrtimer.
> However, if other frames are queued in the hw they are still sent
> before the buffered frames.  Since the hw has a dedicated queue
> for HCCA I wonder if it could be used here?
> (My knowledged of the standard is also rusty, ISTR the buffered
> traffic must be sent before other traffic before the stations
> go back to sleep.)
On mt76x2e, I simply use the management queue for buffered frames, since
it has a very high priority, and management frames are typically
delivered via the voice WMM queue anyway.
I think the MAC is probably similar enough that the same approach is
possible on mt76x2u as well.

- Felix

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:57860 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbcCHMuk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 07:50:40 -0500
Date: Tue, 8 Mar 2016 13:49:08 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Tuomas =?iso-8859-1?Q?R=E4s=E4nen?= <tuomasjjrasanen@tjjr.fi>,
	Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>,
	linux-wireless@vger.kernel.org, tuomasjjrasanen@opinsys.fi,
	Linus Walleij <linus.walleij@linaro.org>
Subject: Re: About adding support for MT76x2U to Linux kernel
Message-ID: <20160308124908.GA14746@sig21.net> (sfid-20160308_135043_480308_6680FB29)
References: <20150814081526.GC20192@hackpad.Elisa>
 <20150814143229.61440072@north>
 <20160302073210.GA31353@lakka.kapsi.fi>
 <20160307111443.GA7205@sig21.net>
 <56DD6B4F.2050405@openwrt.org>
 <20160307124103.GA22175@sig21.net>
 <56DDF11E.3060102@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56DDF11E.3060102@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 07, 2016 at 10:22:38PM +0100, Felix Fietkau wrote:
> On 2016-03-07 13:41, Johannes Stezenbach wrote:
> > http://www.mediatek.com/en/downloads1/downloads/mt7612u/
> I checked, they simply use a software timer for it and stuff buffered
> multicast packets into the BE queue. I don't think the hardware offers
> any better way of doing this...

I had to refresh my memory on this driver.  The thing that tripped
me when I first read through it was that is using a jiffies based
timer and additionally sets it to fire 10ms after the calculated
beacon time.  So it's always too late, isn't it?

But of course it is irrelevant for us since we can use a hrtimer.
However, if other frames are queued in the hw they are still sent
before the buffered frames.  Since the hw has a dedicated queue
for HCCA I wonder if it could be used here?
(My knowledged of the standard is also rusty, ISTR the buffered
traffic must be sent before other traffic before the stations
go back to sleep.)


Johannes

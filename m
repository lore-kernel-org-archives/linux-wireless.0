Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58637 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab1ECRSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 13:18:38 -0400
Received: by eyx24 with SMTP id 24so94150eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 10:18:37 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Andrew V. Stepanov" <stanv@altlinux.org>
Subject: Re: carl9170.ko RX - DMA, TX - COPY.
Date: Tue, 3 May 2011 19:18:28 +0000
Cc: linux-wireless@vger.kernel.org
References: <BANLkTiniamP_zXeGkW2TgatdkSv1+rdfeg@mail.gmail.com> <201105031652.03208.chunkeey@googlemail.com> <BANLkTinpMmuz4yD+tQQAHGTSbTvmVjcVQw@mail.gmail.com>
In-Reply-To: <BANLkTinpMmuz4yD+tQQAHGTSbTvmVjcVQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105031918.28451.chunkeey@googlemail.com> (sfid-20110503_191843_922827_DC78CAF0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(readded ML -  KEEP IT in your replies/use reply all)

On Tuesday 03 May 2011 16:17:36 Andrew V. Stepanov wrote:
> On Tue, May 3, 2011 at 8:52 PM, Christian Lamparter
> > > On Tuesday 03 May 2011 13:43:56 Andrew V. Stepanov wrote:
> > > I have ARM board (davinci dm365) with slow CPU.
> > 
> > do you use compat-wireless and what kernel?
I repeat: do you use compat-wireless? and what kernel do you have?

> >> carl9170.ko shows only 16 MBit/sec emit speed from kernel space,
> >> without touching user space.
> >> 
> >> Other driver rt3070sta.ko (another USB wifi device) shows 166Mb/sec.
> > 
> > The staging rt3070sta driver is no more, for a comparison you would
> > have to use rt2800usb.
> > 
> >> At this time 'top' command shows 100 % CPU load by  "kpktgend_0" thread:
> >> 2477 root      20   0     0    0    0 R 94.8  0.0   6:10.23 kpktgend_0
> >> 
> >> I concluded that carl9170.ko doesn't uses DMA.
> >> Also, in source code drivers/net/wireless/ath/carl9170, i didn't find
> >> DMA functions.
> > 
> > That's because the USB subsystem takes care of that entirely, so unless
> > your musb ehci highspeed host does PIO because of incompatibility,
> > there's no "manual copy" in the TX path [except in cases where there's
> > not enough headroom/tailroom, or a second virtual interface, etc...].
> 
> I believe my musb host support HIGH SPEED protocol.
True, but the USB-core in the device[AR9170] is a little bit picky, Also users 
have told me that they had problems in "low-power" conditions. Which is not
that unlikely and maybe one of the reasons AR9170 was replaced so quickly.
[Note: some vendors [Unex?] can sell you other solutions which have some
nifty protocol offload capabilities, so why not get one of those for the setup 
instead?] 

> rt3070sta.ko - also shows up to 6Mbytes/sec output throughput on this
> board.
Again: rt3070sta is gone/obsolete, test with rt2800usb instead!

> carl9170.ko - shows only 2 Mbytes/sec output throughput with 100%
> CPU utilization (kpktgend_0 thread).
Well, looks like you will have to enable profiling to find the bottleneck.
Is oprofile available for your target, or are there any other profiling
tools you can use [there should be some, given that you have a DEV board]? 

> User space programs can recive data with 4 MBytes/sec on carl9170.ko.
Heh, did you know that the RX-path actually has to "memcpy" all incoming
data? In this regard, the rx result should be even worse....

> On Intel platform with carl9170.ko I can send data with 8Mbytes/sec
> and recive 11Mbytes/sec (restriction of 100MBps ethernet hub).
ok, so the device/cable isn't broken.

Regards,
	Chr

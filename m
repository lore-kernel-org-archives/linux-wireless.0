Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44657 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab1ECOwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 10:52:05 -0400
Received: by ewy4 with SMTP id 4so49188ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 07:52:04 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Andrew V. Stepanov" <stanv@altlinux.org>
Subject: Re: carl9170.ko RX - DMA, TX - COPY.
Date: Tue, 3 May 2011 16:52:02 +0000
Cc: linux-wireless@vger.kernel.org
References: <BANLkTiniamP_zXeGkW2TgatdkSv1+rdfeg@mail.gmail.com> <BANLkTi=6+P9Hj3LtciMeK4g-kDBrsuRXNw@mail.gmail.com> <201105031642.43472.chunkeey@googlemail.com>
In-Reply-To: <201105031642.43472.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105031652.03208.chunkeey@googlemail.com> (sfid-20110503_165213_019542_463F9E4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(readded ML -  please keep it in your replies)
> On Tuesday 03 May 2011 13:43:56 Andrew V. Stepanov wrote:
> I have ARM board (davinci dm365) with slow CPU.
do you use compat-wireless and what kernel?

> I uses pktgen.ko for testing purposes
For testing, I extensively use  iperf (TCP / UDP). It's a userspace
application and binaries are available for most OS easily.
Furthermore, the data it produces is more comparable to
the applications people actually use.
 
> carl9170.ko shows only 16 MBit/sec emit speed from kernel space,
> without touching user space.
> 
> Other driver rt3070sta.ko (another USB wifi device) shows 166Mb/sec.
The staging rt3070sta driver is no more, for a comparison you would
have to use rt2800usb.
 
> At this time 'top' command shows 100 % CPU load by  "kpktgend_0" thread:
> 2477 root      20   0     0    0    0 R 94.8  0.0   6:10.23 kpktgend_0
> 
> I concluded that carl9170.ko doesn't uses DMA.
> Also, in source code drivers/net/wireless/ath/carl9170, i didn't find
> DMA functions.
 
That's because the USB subsystem takes care of that entirely, so unless
your musb ehci highspeed host does PIO because of incompatibility, there's
no "manual copy" in the TX path [except in cases where there's not enough
headroom/tailroom, or a second virtual interface, etc...].
 
Regards,
	Chr

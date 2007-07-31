Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:15800 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbXGaOqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 10:46:51 -0400
Received: by mu-out-0910.google.com with SMTP id i10so2728941mue
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 07:46:49 -0700 (PDT)
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
Date: Tue, 31 Jul 2007 16:50:34 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <20070731115446.5717.37617.stgit@localhost> <200707311611.26683.IvDoorn@gmail.com> <46AF4889.4070902@warmcat.com>
In-Reply-To: <46AF4889.4070902@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707311650.34795.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 July 2007, Andy Green wrote:
> Somebody in the thread at some point said:
> 
> > I think I have an idea why mac80211 always reports 1 MBs,
> > rt2x00 checks if PREAMBLE was enabled or not. If that is the case it sets
> > the rate value to rate->val2
> > Mac80211 in turn only compares the value against rate->val which
> > means that it won't find the rate and assume the lowest possible rate.
> > I'll fix this by always setting the rate->val value instead (It isn't
> really
> > important for mac80211 to know if the preamble bit was set anyway).
> 
> Somehow the rates seem to be correct now after your change to the DROP
> bits...

Excellent! :)

> > #define TXRX_CSR0_DROP_CRC				FIELD32(0x00020000)
> > #define TXRX_CSR0_DROP_PHYSICAL			FIELD32(0x00040000)
> > #define TXRX_CSR0_DROP_CONTROL			FIELD32(0x00080000)
> > #define TXRX_CSR0_DROP_NOT_TO_ME		FIELD32(0x00100000)
> > #define TXRX_CSR0_DROP_TO_DS				FIELD32(0x00200000)
> > #define TXRX_CSR0_DROP_VERSION_ERROR	FIELD32(0x00400000)
> > #define TXRX_CSR0_DROP_MULTICAST			FIELD32(0x00800000)
> > #define TXRX_CSR0_DROP_BORADCAST		FIELD32(0x01000000)
> > #define TXRX_CSR0_DROP_ACK_CTS			FIELD32(0x02000000)
> >
> > Which means it will only pass multicast, broadcast and ACK_CTS frames. :S
> > Always dropping CRC errors is correct, since enabling that will
> greatly upset
> > any monitoring tool listening to the interface.
> 
> Well one day it will be nice if there is a stack-level way to turn it on
> and off.  We can also pass in the radiotap part a flag to show if the
> packet's CRC was valid or not.  The tools can then either turn on the
> filtering before the packets come or filter on good packets only.

Well the problem with the CRC errors is that, when enabled, mac80211
will be flooded with frames. Regular frames which are usually the interesting
ones could get lost in there.
But you are right, having the stack to control the DROP filter would be a very
nice feature. :)

> > To see if it helps try:
> >
> > echo 16 > csr_offset
> > echo 0x0002b162 > csr_value
> >
> > This will disable all DROP bits (except for the CRC error) and thus should
> > trigger more frames to be received by your interface. In the mean time
> I'll search
> > why those bits weren't cleared when enabling the interface in monitor
> mode.
> 
> Yes, that seems to have done it, thanks

Excellent :)

> > Which version are you using?
> > wireless-dev <---
> > rt2x00.git
> > rt2x00 cvs

Ok, rt2x00.git contains many changes to the initialization of the device,
so it is a bit hard to compare at the moment. At least it is confirmed that rt2x00 can
receive all frames in monitor mode and the problem area is the DROP filter.

I'll release rt2x00 2.0.5 later today with all those changes, including the rxdone rate
selection fix. So if you could retest later to see if the problem disappeared in 2.0.5 it
would be great. :)

Ivo

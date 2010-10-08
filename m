Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61748 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab0JHSnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 14:43:06 -0400
Received: by fxm14 with SMTP id 14so669566fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 11:43:02 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: Questions on carl9170 architecture
Date: Fri, 8 Oct 2010 20:42:58 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <3E9EF80F-15AF-4B40-AA26-C97A1E01D897@ing.unibs.it>
In-Reply-To: <3E9EF80F-15AF-4B40-AA26-C97A1E01D897@ing.unibs.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010082042.58974.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 08 October 2010 18:31:42 Francesco Gringoli wrote:
> Hello Christian,
> 
> I have tried carl9170 for a while, everything is ok: what a great work!
> I have not noticed any problem so far, it seems almost stable.
"almost". That's the biggest issue, the driver is "new" and all
the bugs are hidden from sight.

> - how are handled acknowledgments? I don't see anything that schedules ack
> transmission when a packet that need ack is received. Is that accomplished
> internally by the hw?
Yes, Atheros calls it the "Response Controller" (and it's pretty much
hardwired into the MAC HW)

> If yes, do you know if it can be disabled and replaced with new code so
> that it is the firmware to control ack transmission?
Maybe. The normal ACKs can be disabled by zeroing 0x1c36f8.

> For instance, a number of techniques have been recently proposed to estimate
> the channel condition when receiving corrupted frames: it could be
> interesting to send back a "special-ack" when a packet is received corrupted
> to help the transmitter understanding how to best retransmit the packet.
Hmm, by the time you've "generated" your special response, the peer
already knows that the attempt has failed.
anyway, that's OT ;)

> Obviously this should be done within a SIFS from the reception of the packet;
That's going to be though, especially under load.
Apparently, the HW doesn't provide real interrupts.
Therefore everything needs to be "polled"
(yes, that includes the USB DMA too). 
 
> - to which precision is it possible to drive packet transmission?
> e.g., is it possible to start sending a packet a chosen interval after the previous?
Sorry, but my documentation doesn't cover the topic.
You have to ask Atheros.

> - is it possible to send packet independently of CCA, e.g., starting
> sending a packet even if the channel is busy?
hmm, there's a CCA threshold register somewhere.
But no details in the docs, so you might want to ask Atheros.

> - is it possible to build a packet internally and decide to send
> it independently of the host?
kind of. Take a look at handle_bar() and wlan_send_buffered_ba().

> - is it possible to modify packets sent by the host before
> they leave the adapter?
sure, you can probably do that. but keep in mind that device
uses vectored-i/o and the frame data is split across 320 bytes
chunks.

Regards,
	Christian

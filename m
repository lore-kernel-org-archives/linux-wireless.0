Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63084 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2BTHfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 02:35:01 -0500
Received: by wics10 with SMTP id s10so2676952wic.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2012 23:34:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACct8ekj6sq6AeN-mGGyoCa2qfA-kttsVZ2a2i_VGn7BdkOqCQ@mail.gmail.com>
References: <CACct8en2C+fuL81mLwdNUXvvAzyKjj5yjmcWGg_tWHAzQkeF8w@mail.gmail.com>
	<CAJ-VmomgWo=QRemDv5-NHfne9Oj128A_Qn6Xu4UVzJAMRMgXhg@mail.gmail.com>
	<CACct8ekj6sq6AeN-mGGyoCa2qfA-kttsVZ2a2i_VGn7BdkOqCQ@mail.gmail.com>
Date: Sun, 19 Feb 2012 23:34:59 -0800
Message-ID: <CAJ-VmokHo9ST=WJT+5qiuMTjvK=NkL1TkS_pHf0tm6bjKQAfwQ@mail.gmail.com> (sfid-20120220_083507_092237_1A161D1A)
Subject: Re: ath5k : Where does the actual CSMA take place?
From: Adrian Chadd <adrian@freebsd.org>
To: Yiannis Yiakoumis <gyiakoumis@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 February 2012 14:31, Yiannis Yiakoumis <gyiakoumis@gmail.com> wrote:
> Hi Adrian,
>
> Thanks for the explanation. I am a bit confused though. You are saying
> that the DMA starts when there is a txop, is this correct?

I'll have to do some digging. I recall reading about this at some
stage but I can't for the life of me remember the details.

The first couple of bits of each DCU D_MISC register controls when the
DCU starts arbitration for the PCU. The PCU is what does the DMA.
That _may_ begin the process of doing frame DMA early? As I said, I'd
hav eto check.

> So, does DMA take place on a per packet basis? If so, what does start_tx_dma do?

The driver just tickles the hardware to say "start DMA when you're
ready." It just enables the DMA to occur at some point in the future.
May reasons may stop the DMA from occuring at exactly the time you
flip on the QCU TxE bit - for example, you may flip on the TX DMA when
the unit is currently RX'ing, so there's no way the frame will go out
immediately. Or it's a beacon queue, and although you flip on TxE, the
QCU won't allow the frame to go out until the relevant beacon interval
DMA timer fires. The QCU has a variety of frame scheduling policies -
ASAP, CBR, DBA-gated (ie, the beacon gating), TIM gated, beacon-sent
gated.

So no, tickling "start DMA" doesn't necessarily start DMA.

> To trace things, I am sending a 10-packet train through a raw socket.
> All packets go to the tx queue (length reaches 11) and then I start
> receiving TX interrupts. Does each DMA request gets completed before
> the next come, or tx_dma just posts the requests and these are
> processed later?

I can't really say. I'd guess it's a mix - ie, the hardware is likely
free to fill the TX FIFO as it needs to. It may decide to DMA the next
frame whilst the current frame is going out. I'm not sure of all the
hairy MAC DMA details just yet.

> When all 10 packets have been through tx_dma I start getting
> interrupts. The first is a TXEOL and the rest TXDESC.

That's because the MAC can be told to fire off certain kinds of
interrupts, based on:

* the contents of the AR_ISR and AR_ISR_S* registers - you can request
that you be notified of TXDESC, TXEOL, TXURN, etc.
* the contents of the per-descriptor "interrupt me!" bit.

> My understanding is that the time between the tx_dma and the TXDESC of
> a packet, captures both DMA and wireless transmission - could somebody
> comment on that?

It won't be _greater_ than that (unless it failed - ie, it didn't go
out at all.) But, it is likely less than that.

Poking the MAC and saying "DMA me!" is not as accurate a starting
point as you'd like it to be. You don't AFAIK get notified by the
hardware when the DMA _occurs_, only that it's completed the transfer,
and you are provided a TSF snapshot in the TX completion part of the
TX descriptor. I can't recall whether it's the TSF value at the head
or the end of the (successful) packet transmission. But that value is
there.

Why don't you ask the list for help about what it is you're exactly
trying to achieve? :-)



Adrian

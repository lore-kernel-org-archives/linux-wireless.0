Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1KNIEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 03:04:24 -0500
Subject: Re: off- & multi-channel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CAJ-VmokRJ2fGS5Cb-2OY2vV_-cGdNTmEyBn1acndejiyhE8G7g@mail.gmail.com> (sfid-20111112_234709_362354_FD841A43)
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
	 <CAJ-VmokRJ2fGS5Cb-2OY2vV_-cGdNTmEyBn1acndejiyhE8G7g@mail.gmail.com>
	 (sfid-20111112_234709_362354_FD841A43)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 08:52:46 +0100
Message-ID: <1321257166.4472.9.camel@jlt3.sipsolutions.net> (sfid-20111114_090433_858305_75283338)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-11-12 at 14:46 -0800, Adrian Chadd wrote:
> I'm looking at this in FreeBSD's net80211, primarily to be able to
> bring sanity to tx/rx aggregation handling so things like active, high
> throughput traffic doesn't get annoyed when off-channel mode occurs.
> 
> So when you decide to start scanning, there may be frames already in
> the TX queue. If you simply called "start scanning now!", hardware
> like say ath9k would have to do this (and i haven't looked to see if
> it does, I bet it does. :-)
> 
> * the TX queue would have to be paused in its entirety, so the higher
> layers both stop sending frames, _and_ any existing call to
> if_transmit/if_start (and the linux equivalents) have entirely
> completed;
> * that doesn't guarantee the hardware-queued TXes have completed, so
> you either have to wait for those to complete before you start
> off-channel operation, or ..
> * .. you tell the driver "i'm about to start scanning, please get ready";
> * where the driver (eg ath9k) would then stop RX/TX DMA, with frames
> still in the RX completion queue and TX pending/completion state;

I have no idea what ath9k does, but we do tell it about start/stop
scanning and flush queues explicitly (the latter may not be the best
thing to do with multi-channel)

> * .. which have to be handled at some point;
> * .. since the hardware may hvae multiple TX queues, but you typically
> use the same for on-channel and off-channel, you have to then handle
> those frames then, OR set them aside and handle them once you go
> on-channel again;

I'm thinking that since the hardware has enough queues, you might use a
set per channel to switch more quickly, but that's up to the driver
implementation :-)

[snip]

> I do think you need the stack to be able to do the frame buffering;
> the driver could exert a little more control so it's not forced to
> simply drop all the frames on the floor, but be given time to complete
> what it's doing before scanning begins.

Yes, well, the driver can always start & stop queues, and for software
scan we do already stop queues (not for hardware scan for obvious
reasons).

johannes


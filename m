Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51240 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab1KLWqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Nov 2011 17:46:38 -0500
Received: by vws1 with SMTP id 1so4281662vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Nov 2011 14:46:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
Date: Sat, 12 Nov 2011 14:46:37 -0800
Message-ID: <CAJ-VmokRJ2fGS5Cb-2OY2vV_-cGdNTmEyBn1acndejiyhE8G7g@mail.gmail.com> (sfid-20111112_234646_409327_89EB313C)
Subject: Re: off- & multi-channel operation
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm looking at this in FreeBSD's net80211, primarily to be able to
bring sanity to tx/rx aggregation handling so things like active, high
throughput traffic doesn't get annoyed when off-channel mode occurs.

So when you decide to start scanning, there may be frames already in
the TX queue. If you simply called "start scanning now!", hardware
like say ath9k would have to do this (and i haven't looked to see if
it does, I bet it does. :-)

* the TX queue would have to be paused in its entirety, so the higher
layers both stop sending frames, _and_ any existing call to
if_transmit/if_start (and the linux equivalents) have entirely
completed;
* that doesn't guarantee the hardware-queued TXes have completed, so
you either have to wait for those to complete before you start
off-channel operation, or ..
* .. you tell the driver "i'm about to start scanning, please get ready";
* where the driver (eg ath9k) would then stop RX/TX DMA, with frames
still in the RX completion queue and TX pending/completion state;
* .. which have to be handled at some point;
* .. since the hardware may hvae multiple TX queues, but you typically
use the same for on-channel and off-channel, you have to then handle
those frames then, OR set them aside and handle them once you go
on-channel again;
* then you do off-channel work, whilst all non-on-channel mgmt frame
TX is done (although god knows how I'm going to make sure that
off-channel mgmt frames (eg probes) go out, but on-channel mgmt frames
(eg BAR) are properly paused :) ;
* once the scan is completed, handle whatever off-channel stuff is
pending in RX, cancel (or handle?) TX to the off-channel stuff;
* .. then go back to on-channel,
* .. then restart TX/RX where you left off, including handle any and
all pending frames.

FreeBSD's net80211 has some logic already to inform the driver about
off-channel scanning (ie, ic scan_start and scan_end methods) along
with a way for firmware devices to take charge of scanning and replace
the net80211 default software scanning mode. The trick is what I've
covered above - making sure that absolutely, positively all the cases
are handled and you're not TX'ing on the wrong channel or dropping
frames which cause aggregation session hangs.

You can't just stuff it into a separate hardware TX queue right now
with ath9k unless you start populating ath9k with lots of special
queue "flavour" handling. You still have to cleanly stop/start DMA,
handle frame completion for ampdu session continuity (or send BAR
frames as needed), etc.

I do think you need the stack to be able to do the frame buffering;
the driver could exert a little more control so it's not forced to
simply drop all the frames on the floor, but be given time to complete
what it's doing before scanning begins.


Adrian

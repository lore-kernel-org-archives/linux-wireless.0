Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:56674 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbXLWVST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 16:18:19 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1129096mue.5
        for <linux-wireless@vger.kernel.org>; Sun, 23 Dec 2007 13:18:17 -0800 (PST)
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: tx_status reporting of RTS/CTS frames
Date: Sun, 23 Dec 2007 22:18:42 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
References: <1197412922.7030.11.camel@localhost> <1197545672.6558.238.camel@johannes.berg> <1197572204.7489.7.camel@localhost>
In-Reply-To: <1197572204.7489.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712232218.42415.IvDoorn@gmail.com> (sfid-20071223_211821_568748_8063DC91)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 13 December 2007, Mattias Nissler wrote:
> 
> On Thu, 2007-12-13 at 12:34 +0100, Johannes Berg wrote:
> > > rt2x00 devices have some flags in the TX descriptor that basically tell
> > > the device to send a burst of frames, optionally requesting to wait for
> > > an ack (i.e. CTS in the case of an RTS frame) for any of them.
> > 
> > Interesting. I can't the place where that is set though, can you point
> > me to it?
> 
> For each frame, rt2x00 creates a txdata_entry_desc structure (see
> rt2x00lib_write_tx_desc()), which holds all the information that is
> written to the actual tx descriptors (format of these varies among the
> different devices we support, but the information in the tx descriptors
> is roughly the same). See rt61pci_write_tx_desc() for an example of how
> the information is stored into the actual tx descriptor, but that's
> rather boring.
> 
> The bits you're interested in are ENTRY_TXD_ACK and ENTRY_TXD_BURST.
> BURST tells the device the next frame is part of the same burst (also
> note that we have to set the correct IFS), i.e. the next frame goes out
> directly after the current one (respecting the IFS of course). The
> TXD_ACK bit means the hardware should wait for an ack of some kind (e.g.
> CTS for RTS frames).

Additionally there is the ENTRY_TXD_RTS_FRAME flag to indicate the frame
is a rts frame. This is something that at least rt2400pci and rt2500pci required
for rts frames in the TX queue.

Ivo

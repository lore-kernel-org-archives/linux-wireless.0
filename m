Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43744 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756781AbXLMS4u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 13:56:50 -0500
Subject: Re: tx_status reporting of RTS/CTS frames
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <1197545672.6558.238.camel@johannes.berg>
References: <1197412922.7030.11.camel@localhost>
	 (sfid-20071211_224234_989906_7701C071)  <1197479702.6558.125.camel@johannes.berg>
	 <1197488971.7491.1.camel@localhost>
	 (sfid-20071212_195008_015503_712CB6C6)  <1197545672.6558.238.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 19:56:44 +0100
Message-Id: <1197572204.7489.7.camel@localhost> (sfid-20071213_185656_648147_BA3B4461)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2007-12-13 at 12:34 +0100, Johannes Berg wrote:
> > rt2x00 devices have some flags in the TX descriptor that basically tell
> > the device to send a burst of frames, optionally requesting to wait for
> > an ack (i.e. CTS in the case of an RTS frame) for any of them.
> 
> Interesting. I can't the place where that is set though, can you point
> me to it?

For each frame, rt2x00 creates a txdata_entry_desc structure (see
rt2x00lib_write_tx_desc()), which holds all the information that is
written to the actual tx descriptors (format of these varies among the
different devices we support, but the information in the tx descriptors
is roughly the same). See rt61pci_write_tx_desc() for an example of how
the information is stored into the actual tx descriptor, but that's
rather boring.

The bits you're interested in are ENTRY_TXD_ACK and ENTRY_TXD_BURST.
BURST tells the device the next frame is part of the same burst (also
note that we have to set the correct IFS), i.e. the next frame goes out
directly after the current one (respecting the IFS of course). The
TXD_ACK bit means the hardware should wait for an ack of some kind (e.g.
CTS for RTS frames).

Mattas


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:58669 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbXLNFVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 00:21:47 -0500
Date: Thu, 13 Dec 2007 21:20:46 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: tx_status reporting of RTS/CTS frames
Message-ID: <20071214052046.GF5698@jm.kir.nu> (sfid-20071214_052150_081419_03035872)
References: <1197412922.7030.11.camel@localhost> <1197479702.6558.125.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197479702.6558.125.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 12, 2007 at 06:15:02PM +0100, Johannes Berg wrote:

> > rt2x00 devices can't generate rts/cts frames themselves, but rely on the
> > driver to generate them. Also, the hardware reports tx status back for
> > those frames. Now the question is whether these frames should be
> > reported back to mac80211 using ieee80211_tx_status[_irqsafe]. AFAIK,
> > this has some subtle effects, e.g. they won't show up on monitor
> > interfaces if we don't report them.
> 
> They never show up on monitor interfaces for all other hardware because
> there the hardware handles them. How is it that rt2x00 cannot handle
> rts? It has to at least know that an RTS was sent and to send the frame
> only after the CTS, and that needs to be a MAC function and cannot be
> implemented in host software.
> 
> So, I'd think they shouldn't be reported at all.

I'm not sure I understood the comment about monitor interface correctly.
If the driver is configured in monitor mode (or whatever you would call
a mode where it receives all frames), I do expect to see ACK and RTS/CTS
frames in mac80211 (and in the monitor interface in user space for that
matter). I hope that this won't be changed.

It sounds perfectly reasonable to not indicate these control frame
subtypes when in normal (non-monitor) mode since they are most likely
processed in hardware/microcode/firmware. However, if they provide
additional information (say, signal strength), it could be useful to
send them to mac80211 anyway to provide more information for TX rate
control.

-- 
Jouni Malinen                                            PGP id EFC895FA

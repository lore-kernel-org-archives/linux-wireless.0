Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36938 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752603AbXLLTte (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 14:49:34 -0500
Subject: Re: tx_status reporting of RTS/CTS frames
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <1197479702.6558.125.camel@johannes.berg>
References: <1197412922.7030.11.camel@localhost>
	 (sfid-20071211_224234_989906_7701C071)  <1197479702.6558.125.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 20:49:31 +0100
Message-Id: <1197488971.7491.1.camel@localhost> (sfid-20071212_194938_801766_1DC41A29)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-12-12 at 18:15 +0100, Johannes Berg wrote:
> Hi,
> 
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

rt2x00 devices have some flags in the TX descriptor that basically tell
the device to send a burst of frames, optionally requesting to wait for
an ack (i.e. CTS in the case of an RTS frame) for any of them.

> So, I'd think they shouldn't be reported at all.

Ok, I'll prepare a patch for rt2x00.

Mattias


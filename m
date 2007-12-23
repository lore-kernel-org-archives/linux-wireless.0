Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:7791 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbXLWVQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 16:16:55 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1494877fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 23 Dec 2007 13:16:53 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: tx_status reporting of RTS/CTS frames
Date: Sun, 23 Dec 2007 22:17:18 +0100
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
References: <1197412922.7030.11.camel@localhost> <1197479702.6558.125.camel@johannes.berg>
In-Reply-To: <1197479702.6558.125.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712232217.18941.IvDoorn@gmail.com> (sfid-20071223_211659_208987_F1E71D47)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

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

Than this is a problem in multiple mac80211 drivers, since rt2x00 previously
did filter out rts and cts frames when reporting txdone events to mac80211
and upon request on the linux-wireless list that filter was disabled, because
the other drivers didn't filter the RTS/CTS frames so for consistent behavior
the filter was removed from rt2x00.

Ivo


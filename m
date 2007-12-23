Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:41115 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXLWVtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 16:49:51 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1508466fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 23 Dec 2007 13:49:49 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: tx_status reporting of RTS/CTS frames
Date: Sun, 23 Dec 2007 22:50:12 +0100
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
References: <1197412922.7030.11.camel@localhost> <200712232217.18941.IvDoorn@gmail.com> <1198445352.4103.0.camel@johannes.berg>
In-Reply-To: <1198445352.4103.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712232250.12962.IvDoorn@gmail.com> (sfid-20071223_215003_872078_2ADC7BE3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Than this is a problem in multiple mac80211 drivers, since rt2x00 previously
> > did filter out rts and cts frames when reporting txdone events to mac80211
> > and upon request on the linux-wireless list that filter was disabled, because
> > the other drivers didn't filter the RTS/CTS frames so for consistent behavior
> > the filter was removed from rt2x00.
> 
> Huh? Seriously? I can't remember any such thing. It doesn't really make
> sense because most hw will handle rts/cts fully transparently and not
> give you status notification for it. As for showing received rts/cts on
> monitor, sure, but txdone for sent rts/cts isn't done by any driver I'm
> aware of.

I just checked, only rt2x00 and b43 call the rts/cts functions for ieee80211.
For b43 seems to report the tx status for the rts/cts frames as well.

I have found the 2 emails that introduced and later reverted the behavior from rt2x00:
[PATCH 16/26] rt2x00: Correctly handle RTS frames
[PATCH 7/24] RT2x00: Add RTS frame creation
They are dated from July 2006, so they were quite old actually :S

Anyway, I have no objects against not report those frames to mac80211,
so if mac80211 doesn't want those frames reported rt2x00 can filter them out. :)

Ivo

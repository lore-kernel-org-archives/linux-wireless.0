Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:43121 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYHOVDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 17:03:45 -0400
From: Chr <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted from commit 741b4fbc44
Date: Fri, 15 Aug 2008 23:06:38 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808152215.05761.chunkeey@web.de> <1218831437.3197.5.camel@localhost>
In-Reply-To: <1218831437.3197.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808152306.38450.chunkeey@web.de> (sfid-20080815_230349_180244_20BAC523)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 August 2008 22:17:16 Johannes Berg wrote:
> On Fri, 2008-08-15 at 22:15 +0200, Chr wrote:
> > hmm? has this something to do with the per STA TID in
> > 7.1.3.4.1 (802.11-2007) ?
>
> yes
>
> > Well the firmware (aka: LowerMAC) has some sort station
> > database so there could be some room for that... maybe.
>
> makes little sense since we don't tell it about stations, well, I dunno.
well, the firmware parses some parts of the ieee80211 header.
And we are actually supposed to tell the firmware about the station aid,
on every tx (and that's why there's a AID field in the tx_info struct now. ;-) 
It's not used yet, but it will when Linville returns...

>
> > (But yes, when I was playing with the AP/IBSS,
> > all beacon frames had a running sequence counter...
>
> Maybe only non-QoS frames?
well, if you take a look at the cx3110x log you can see
that the duration & sequence field is always zero...

the firmware is actually ~30kb of ARM-code, but unfortunatly
they decided to pack it...

>
> > maybe you can see this with a cx3110x in IBSS mode too?!)
>
> we're supposed to be getting documentation on the lmac in there...
Really?! Well, from my POV it would be better to kickstart FreeMAC,
rather than writing a driver for these LMAC Firmwares... seriously!

Regards,
	Chr

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0DLIKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 04:10:05 -0400
Subject: Re: [PATCH 2/2] mac80211: Initialize IBSS basic rates according to
 band
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <201004121658.09189.br1@einfach.org>
References: <20100412073658.28078.32155.stgit@tt-desk>
	 <20100412073703.28078.90501.stgit@tt-desk>
	 <1271058082.3877.3.camel@jlt3.sipsolutions.net>
	 <201004121658.09189.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 10:10:01 +0200
Message-ID: <1271059801.3877.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-12 at 16:58 +0900, Bruno Randolf wrote:
> On Monday 12 April 2010 16:41:22 you wrote:
> > On Mon, 2010-04-12 at 16:37 +0900, Bruno Randolf wrote:
> > > When we create an IBSS we are can define the basic rates according to the
> > > band in use. Previously only the B mode rates (1 and 2Mbps) were used
> > > unconditionally, which resulted in low thruput when using RTS/CTS.
> > > 
> > > Also we should save the IBSS basic rates configuration when we join an
> > > IBSS.
> > 
> > Again, this breaks things. If you feel this is necessary for some
> > reason, it needs to be configurable during the IBSS join by userspace.
> 
> without the previous patch (which you NACKed) this is still the correct thing 
> to do in B mode and will result in only 1Mbps as a basic rate. without this 
> patch it is definetly wrong for A mode.

No, you don't understand. It will break _talking to_ 11b only stations
when the local station is 11g capable.

> i can see the reason why you refused the first patch, but the main problem is 
> that there is no clear distiction between B and G in mac80211. there needs to 
> be a way to configure B-only, G-only and BG ERP mode. i don't believe this is 
> applicable to IBSS mode only... is it?

It is, as far as I can tell. And mesh maybe.

> btw: why is only 1Mbps used as a basic rate in B mode in 
> set_mandatory_flags_band()? i think 2Mbps should be there as well?

Not sure, could be a bug?

> anyhow, i wouldn't mind adding something to configure this from userspace. can 
> you point me to the right direction? i mean i can add something to IBSS setup 
> but as i said i can't believe this is only relevant to IBSS mode.

What other modes do you think it is relevant to?

johannes


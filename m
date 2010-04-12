Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:40068 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752869Ab0DLIek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 04:34:40 -0400
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0783751278
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 17:34:38 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: Initialize IBSS basic rates according to band
Date: Mon, 12 Apr 2010 17:34:39 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20100412073658.28078.32155.stgit@tt-desk> <201004121658.09189.br1@einfach.org> <1271059801.3877.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1271059801.3877.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201004121734.39700.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 April 2010 17:10:01 Johannes Berg wrote:
> On Mon, 2010-04-12 at 16:58 +0900, Bruno Randolf wrote:
> > On Monday 12 April 2010 16:41:22 you wrote:
> > > On Mon, 2010-04-12 at 16:37 +0900, Bruno Randolf wrote:
> > > > When we create an IBSS we are can define the basic rates according to
> > > > the band in use. Previously only the B mode rates (1 and 2Mbps) were
> > > > used unconditionally, which resulted in low thruput when using
> > > > RTS/CTS.
> > > > 
> > > > Also we should save the IBSS basic rates configuration when we join
> > > > an IBSS.
> > > 
> > > Again, this breaks things. If you feel this is necessary for some
> > > reason, it needs to be configurable during the IBSS join by userspace.
> > 
> > without the previous patch (which you NACKed) this is still the correct
> > thing to do in B mode and will result in only 1Mbps as a basic rate.
> > without this patch it is definetly wrong for A mode.
> 
> No, you don't understand. It will break _talking to_ 11b only stations
> when the local station is 11g capable.

i understood that this is what you mean. note that i said *without* the other 
patch! the first patch breaks talking to 11b only stations, true. the second 
doesn't because:

as it is now ieee80211_mandatory_rates(local, sband->band) returns 1 (1Mbps) 
in a 2GHz channel. which is o.k. for B only stations.

before we unconditionally used 3 (1Mbps, 2 Mbps) as basic rates. this clearly 
is wrong in the 5GHz band.

> > i can see the reason why you refused the first patch, but the main
> > problem is that there is no clear distiction between B and G in
> > mac80211. there needs to be a way to configure B-only, G-only and BG ERP
> > mode. i don't believe this is applicable to IBSS mode only... is it?
> 
> It is, as far as I can tell. And mesh maybe.
> 
> > btw: why is only 1Mbps used as a basic rate in B mode in
> > set_mandatory_flags_band()? i think 2Mbps should be there as well?
> 
> Not sure, could be a bug?

maybe... unfortunately i can't find a clear definition of basic rates in the 
11b standard, but usually 1 and 2Mbps are used. for b/g compatibiliy i've  
seen 1, 2, 5.5, 11 used as basic rates - i think that's what most APs do.

> > anyhow, i wouldn't mind adding something to configure this from
> > userspace. can you point me to the right direction? i mean i can add
> > something to IBSS setup but as i said i can't believe this is only
> > relevant to IBSS mode.
> 
> What other modes do you think it is relevant to?

i'm not so familiar with the way STA and AP operate, but i thought that also 
there the distiction between B, B/G and pure-G could make sense. if not i'll 
just add code to the IBSS setup...

bruno

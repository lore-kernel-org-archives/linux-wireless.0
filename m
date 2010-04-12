Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:9978 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752725Ab0DLH6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 03:58:09 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0465869088
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 16:58:08 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: Initialize IBSS basic rates according to band
Date: Mon, 12 Apr 2010 16:58:09 +0900
References: <20100412073658.28078.32155.stgit@tt-desk> <20100412073703.28078.90501.stgit@tt-desk> <1271058082.3877.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1271058082.3877.3.camel@jlt3.sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201004121658.09189.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 April 2010 16:41:22 you wrote:
> On Mon, 2010-04-12 at 16:37 +0900, Bruno Randolf wrote:
> > When we create an IBSS we are can define the basic rates according to the
> > band in use. Previously only the B mode rates (1 and 2Mbps) were used
> > unconditionally, which resulted in low thruput when using RTS/CTS.
> > 
> > Also we should save the IBSS basic rates configuration when we join an
> > IBSS.
> 
> Again, this breaks things. If you feel this is necessary for some
> reason, it needs to be configurable during the IBSS join by userspace.

without the previous patch (which you NACKed) this is still the correct thing 
to do in B mode and will result in only 1Mbps as a basic rate. without this 
patch it is definetly wrong for A mode.

i can see the reason why you refused the first patch, but the main problem is 
that there is no clear distiction between B and G in mac80211. there needs to 
be a way to configure B-only, G-only and BG ERP mode. i don't believe this is 
applicable to IBSS mode only... is it?

btw: why is only 1Mbps used as a basic rate in B mode in 
set_mandatory_flags_band()? i think 2Mbps should be there as well?

anyhow, i wouldn't mind adding something to configure this from userspace. can 
you point me to the right direction? i mean i can add something to IBSS setup 
but as i said i can't believe this is only relevant to IBSS mode.

bruno

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0DLIk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 04:40:57 -0400
Subject: Re: [PATCH 2/2] mac80211: Initialize IBSS basic rates according to
 band
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <201004121734.39700.br1@einfach.org>
References: <20100412073658.28078.32155.stgit@tt-desk>
	 <201004121658.09189.br1@einfach.org>
	 <1271059801.3877.5.camel@jlt3.sipsolutions.net>
	 <201004121734.39700.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 10:40:52 +0200
Message-ID: <1271061652.3877.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-12 at 17:34 +0900, Bruno Randolf wrote:

> > No, you don't understand. It will break _talking to_ 11b only stations
> > when the local station is 11g capable.
> 
> i understood that this is what you mean. note that i said *without* the other 
> patch! the first patch breaks talking to 11b only stations, true. the second 
> doesn't because:
> 
> as it is now ieee80211_mandatory_rates(local, sband->band) returns 1 (1Mbps) 
> in a 2GHz channel. which is o.k. for B only stations.

Oh ok, right.

> before we unconditionally used 3 (1Mbps, 2 Mbps) as basic rates. this clearly 
> is wrong in the 5GHz band.

No, it's fine. Look again at how this works.

> > > anyhow, i wouldn't mind adding something to configure this from
> > > userspace. can you point me to the right direction? i mean i can add
> > > something to IBSS setup but as i said i can't believe this is only
> > > relevant to IBSS mode.
> > 
> > What other modes do you think it is relevant to?
> 
> i'm not so familiar with the way STA and AP operate, but i thought that also 
> there the distiction between B, B/G and pure-G could make sense.

Not unless you want your 11g+ STA to operate in 11b-only mode.

johannes


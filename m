Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1FFQLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 12:11:35 -0400
Subject: Re: sta_find_ibss (active_ibss=1) in a loop?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ignacy Gawedzki <i@lri.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110606160115.GA31258@zenon.in.qult.net>
References: <20110603201644.GA7836@zenon.in.qult.net>
	 <20110603204939.GA12854@zenon.in.qult.net>
	 <20110606110429.GA18775@zenon.in.qult.net>
	 <1307370716.3894.10.camel@jlt3.sipsolutions.net>
	 <20110606160115.GA31258@zenon.in.qult.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 18:11:32 +0200
Message-ID: <1307376692.3894.12.camel@jlt3.sipsolutions.net> (sfid-20110606_181141_781519_E24D09EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-06 at 18:01 +0200, Ignacy Gawedzki wrote:

> > @@ -999,7 +1002,6 @@ int ieee80211_ibss_leave(struct ieee8021
> >  	kfree_skb(skb);
> >  
> >  	skb_queue_purge(&sdata->skb_queue);
> > -	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
> >  	sdata->u.ibss.ssid_len = 0;
> 
> Shouldn't that second line also move up with the memset?

Not really necessary -- that's not used in the RX path. But yeah we can
do that for consistency. Also maybe the skb queue purge.

> >  	del_timer_sync(&sdata->u.ibss.timer);
> 
> So this fix relies on the fact that reading sdata->i.ibss.state is an atomic
> operation, right?
> 
> Thanks for the patch, I'll give it a try, though it may be some time until I
> report further on this, since the problem is difficult to reproduce.

Oh ok. Well, I think we should put these changes in anyway since I see
nothing preventing the race now.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:34180 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab1FFLEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 07:04:32 -0400
Received: from zenon.in.qult.net ([192.168.128.3])
	by qult.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1QTXbi-0002xE-Ca
	for linux-wireless@vger.kernel.org; Mon, 06 Jun 2011 13:04:30 +0200
Received: from ig by zenon.in.qult.net with local (Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1QTXbh-00056c-Ei
	for linux-wireless@vger.kernel.org; Mon, 06 Jun 2011 13:04:29 +0200
Date: Mon, 6 Jun 2011 13:04:29 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Subject: Re: sta_find_ibss (active_ibss=1) in a loop?
Message-ID: <20110606110429.GA18775@zenon.in.qult.net> (sfid-20110606_130435_455828_E01BDAF0)
References: <20110603201644.GA7836@zenon.in.qult.net>
 <20110603204939.GA12854@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110603204939.GA12854@zenon.in.qult.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 03, 2011 at 10:49:39PM +0200, thus spake Ignacy Gawedzki:
> On Fri, Jun 03, 2011 at 10:16:44PM +0200, thus spake Ignacy Gawedzki:
> > I can't confirm right now that this is indeed what's happening, but I'll post
> > more information as soon as possible.
> 
> I can now confirm that the state is MLME_SEARCH and that the ignored station
> can't be added because of the following in ieee80211_ibss_add_sta():
> 
>           if (ifibss->state == IEEE80211_IBSS_MLME_SEARCH)
>                 return NULL;

After looking more in details at the code, I think I'm getting closer to a
proper diagnostic.

The state is changed to MLME_SEARCH when ieee80211_ibss_join() is called from
ieee80211_join_ibss() in cfg.c.  I suppose this is what's called when an
application asks the kernel to make the interface join an IBSS.  Since in that
state no new STA can be added to local->sta_list, if there were no STA at all,
there's no last_rx to update and consequently ieee80211_sta_active_ibss()
returns 0 and ieee80211_sta_find_ibss() may proceed.

But apparently, if there are still some remaining STAs in local->sta_list,
their last_rx is updated upon reception of a frame from them, so if they are
transmitting frames often enough, ieee80211_sta_active_ibss() won't ever
return 0 and ieee80211_sta_find_ibss() won't be able to proceed at all, which
will keep the interface in the MLME_SEARCH state and hence the loop.

So how comes there are remaining STAs in local->sta_list?  When
ieee80211_ibss_leave() is called from ieee80211_leave_ibss() in cfg.c,
sta_info_flush() is called and there are no remaining STAs.  But what if
ieee80211_ibss_join() is called without prior call to ieee80211_ibss_leave()?
I suppose this is when it goes wrong.

Is flushing the local->sta_list in ieee80211_ibss_join() a good solution?

Please just tell me and I'll happily post a patch.

Thanks,

Ignacy

-- 
The groove will take you through times without money
much better than money will take you through times without groove.

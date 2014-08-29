Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58597 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbaH2LFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 07:05:53 -0400
Message-ID: <1409310350.4577.14.camel@jlt4.sipsolutions.net> (sfid-20140829_130557_911360_6DA9E438)
Subject: Re: [PATCH] mac80211: fix chantype recalc warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 29 Aug 2014 13:05:50 +0200
In-Reply-To: <CA+BoTQk-iR2aAsgioZY+CgjV3JkvQf3pakiAzsw-o65ogDYHRA@mail.gmail.com> (sfid-20140818_150739_370743_7BFD48D6)
References: <1406553419-16196-1-git-send-email-michal.kazior@tieto.com>
	 <1407769505.9844.8.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk-iR2aAsgioZY+CgjV3JkvQf3pakiAzsw-o65ogDYHRA@mail.gmail.com>
	 (sfid-20140818_150739_370743_7BFD48D6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-08-18 at 15:07 +0200, Michal Kazior wrote:

> If you eject, e.g. plug a usb wifi device out, its driver will call
> ieee80211_unregister_hw() which calls ieee80211_remove_interfaces().
> If there are still running interfaces that have a netdev (probably to
> avoid a deadlock on iflist_mtx?) each interface is *moved* to a
> temporary list for a later call to unregister_netdevice_many(). While
> unregister_netdevice_many() executes the local->interfaces is empty.
> ieee80211_recalc_chanctx_chantype() is called whenever a chanctx is
> unassigned from a vif as long as there are still references to that
> chanctx. If there is just 1 interface when device is ejected, then
> ieee80211_recalc_chanctx_chantype() is not called. If there is more
> than 1 running interfaces then the removal of each but the last one
> calls to ieee80211_recalc_chanctx_chantype(). Since local->interfaces
> is empty compat pointer stays NULL and this triggers WARN_ON_ONCE (but
> only the first one effectively dumps a trace).

Ah ok.

> Another way to fix this would probably be to change
> ieee80211_remove_interfaces() to remove all interfaces one-by-one
> (instead of in bulk). It seems iflist_mtx can be temporarily released
> while iterating over interfaces for the sake of calling
> unregister_netdevice() for each one because RTNL is held all the time
> guaranteeing no new interfaces are added in the meantime. I'm not sure
> if it's perfectly safe to replace unregister_netdevice_many() just
> like that though. I can look more into it.

Well, it's safe, but it's more efficient to call the _many() because
otherwise you require rcu_synchronize() for each one.

I'll apply this, to -next for now, later we can decide if we want to
send it to stable or so?

johannes


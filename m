Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35111 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752158AbXCWRRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 13:17:48 -0400
Date: Fri, 23 Mar 2007 18:17:46 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Properly kill tasklets before shutdown
Message-ID: <20070323181746.7a8f4b56@griffin.suse.cz>
In-Reply-To: <200703061902.00001.mb@bu3sch.de>
References: <200703061902.00001.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 6 Mar 2007 19:01:59 +0100, Michael Buesch wrote:
> We need to do tasklet_kill() on any tasklet on unregister
> to make sure the tasklet is not running _and_ scheduled anymore.
> (tasklet_disable() only ensures it's not running anymore).
> 
> This fixes the tasklet related crash that was reported some time ago.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> Index: bu3sch-wireless-dev/net/mac80211/ieee80211.c
> ===================================================================
> --- bu3sch-wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-06 15:55:53.000000000 +0100
> +++ bu3sch-wireless-dev/net/mac80211/ieee80211.c	2007-03-06 15:58:10.000000000 +0100
> @@ -4761,8 +4761,8 @@
>  	struct ieee80211_sub_if_data *sdata, *tmp;
>  	int i;
>  
> -	tasklet_disable(&local->tasklet);

I think this tasklet_disable should not be removed.

> -	/* TODO: skb_queue should be empty here, no need to do anything? */
> +	tasklet_kill(&local->tx_pending_tasklet);
> +	tasklet_kill(&local->tasklet);
>  
>  	rtnl_lock();
>  	local->reg_state = IEEE80211_DEV_UNREGISTERED;

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37307 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbbETNR4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:17:56 -0400
Message-ID: <1432127874.19214.13.camel@sipsolutions.net> (sfid-20150520_151808_644260_5B1376EA)
Subject: Re: [PATCH 1/2] cfg80211: ignore netif running state when changing
 iftype
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 May 2015 15:17:54 +0200
In-Reply-To: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com> (sfid-20150519_143715_930971_C928777B)
References: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150519_143715_930971_C928777B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-19 at 14:37 +0200, Michal Kazior wrote:
> This isn't a revert of f8cdddb8d61d ("cfg80211:
> check iface combinations only when iface is
> running") as far as functionality is considred
> because b6a550156bc ("cfg80211/mac80211: move more
> combination checks to mac80211") moved the logic
> somewhere else.
> 
> It was possible for mac80211 to be coerced into an
> unexpected flow causing sdata union to become
> corrupted. Station pointer was put into
> sdata->u.vlan.sta memory location while it was
> really master AP's sdata->u.ap.next_beacon. This
> led to station entry being later freed as CSA
> beacon before __sta_info_flush() in
> ieee80211_stop_ap() and a subsequent invalid
> pointer dereference crash.
> 
> The problem was observed with the following test
> steps:
> 
>  1. prepare 2 devices
>  2. start hostapd AP with wds_sta=1
>  3. connect client with 4addr
>  4. disconnect
>  5. swap roles & connect
>  6. disconnect
>     [ During AP (which was a client first)
>       teardown kernel would crash. ]

That doesn't really explain how it crashes?

> +++ b/net/wireless/util.c
> @@ -944,7 +944,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
>  	     ntype == NL80211_IFTYPE_P2P_CLIENT))
>  		return -EBUSY;
>  
> -	if (ntype != otype && netif_running(dev)) {
> +	if (ntype != otype) {
>  		dev->ieee80211_ptr->use_4addr = false;
>  		dev->ieee80211_ptr->mesh_id_up_len = 0;
>  		wdev_lock(dev->ieee80211_ptr);

I don't think that makes much sense - the code within this block really
only makes sense when the interface *is* running, like disconnecting
etc. Doing that when it's *not* would be entirely unexpected to the
drivers, no?

johannes


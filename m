Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3FXNlP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:41:15 -0400
Message-ID: <1372081270.8439.2.camel@jlt4.sipsolutions.net> (sfid-20130624_154118_083915_678D6471)
Subject: Re: [PATCH] nl80211: fix mgmt tx status and testmode reporting for
 netns
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Jun 2013 15:41:10 +0200
In-Reply-To: <1372074644-15280-1-git-send-email-michal.kazior@tieto.com>
References: <1372074644-15280-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-24 at 13:50 +0200, Michal Kazior wrote:
> These two events were sent to the default network
> namespace.
> 
> This caused AP mode in a non-default netns to not
> work correctly. Mgmt tx status was multicasted to
> a different (default) netns instead of the one the
> AP was in.

Good catch.

> @@ -6593,7 +6593,10 @@ void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
>  
>  	nla_nest_end(skb, data);
>  	genlmsg_end(skb, hdr);
> -	genlmsg_multicast(skb, 0, nl80211_testmode_mcgrp.id, gfp);
> +
> +	rcu_read_lock();
> +	genlmsg_multicast_allns(skb, 0, nl80211_testmode_mcgrp.id, GFP_ATOMIC);
> +	rcu_read_unlock();
>  }
>  EXPORT_SYMBOL(cfg80211_testmode_event);

I think this one should get a wiphy parameter though, to put it into the
right netns.

johannes


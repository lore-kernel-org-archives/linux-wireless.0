Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2FDGQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 02:16:40 -0400
Message-ID: <1338790597.4512.3.camel@jlt3.sipsolutions.net> (sfid-20120604_081642_240148_42325632)
Subject: Re: [PATCH] mac80211: stop Rx during HW reconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Jun 2012 08:16:37 +0200
In-Reply-To: <1338755422-13220-1-git-send-email-arik@wizery.com> (sfid-20120603_223057_537536_88947913)
References: <1338755422-13220-1-git-send-email-arik@wizery.com>
	 (sfid-20120603_223057_537536_88947913)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-06-03 at 23:30 +0300, Arik Nemtsov wrote:

> +++ b/net/mac80211/rx.c
> @@ -3023,6 +3023,9 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  	if (WARN_ON(!sband))
>  		goto drop;
>  
> +	/* make sure we get the latest values for the next variable checks */
> +	smp_rmb();
> +

That doesn't make a lot of sense I think? This entire thing is
inherently racy, you could be processing RX already even while just
setting the variable in the other code. I'm not really sure what the
effect of this here is, but it's certainly a hot-path.

> +       /*
> +        * Stop all Rx during the reconfig. We don't want state changes
> +        * or driver callbacks while this is in progress.
> +        */
> +       local->in_reconfig = true;
> +       smp_wmb();


If anything, you should probably put this right into
ieee80211_restart_hw() rather than the reconfig function? It's not
needed for suspend/resume anyway since we check that separately.

johannes


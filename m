Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3FCPBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 11:01:34 -0400
Message-ID: <1370271690.8227.18.camel@jlt4.sipsolutions.net> (sfid-20130603_170137_070813_08560553)
Subject: Re: [PATCH 2/2] mac80211: in mgmt_tx use the current channel if
 none has been specified
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Mon, 03 Jun 2013 17:01:30 +0200
In-Reply-To: <1370241587-2609-2-git-send-email-ordex@autistici.org>
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
	 <1370241587-2609-2-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-03 at 08:39 +0200, Antonio Quartulli wrote:

> @@ -2845,6 +2852,10 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>  		rcu_read_lock();
>  		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
>  
> +		/* if no channel was specified, use the current one */
> +		if (chanctx_conf && !chan)
> +			chan = chanctx_conf->def.chan;
> +
>  		if (chanctx_conf)
>  			need_offchan = chan != chanctx_conf->def.chan;
>  		else
> @@ -2852,6 +2863,12 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>  		rcu_read_unlock();
>  	}
>  
> +	/* at this point a channel should have been chosen */
> +	if (!chan) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +

These two changes make no sense at all. If you look at the function
you'll see that "chan" isn't used at all after the check, and modifying
the "check if ..." part to use the channel also doesn't make sense.

johannes


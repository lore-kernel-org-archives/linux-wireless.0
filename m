Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50970 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2DCMsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 08:48:30 -0400
Message-ID: <1333457309.3574.20.camel@jlt3.sipsolutions.net> (sfid-20120403_144848_277475_8E52A86D)
Subject: Re: [PATCH] mac80211: clean up an ieee80211_do_open error path
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>
Date: Tue, 03 Apr 2012 14:48:29 +0200
In-Reply-To: <1333457154.3574.18.camel@jlt3.sipsolutions.net> (sfid-20120403_144559_919415_04C97E86)
References: <1333457154.3574.18.camel@jlt3.sipsolutions.net>
	 (sfid-20120403_144559_919415_04C97E86)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-03 at 14:45 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Eliad's comment prompted me to look closer at
> the error paths in ieee80211_do_open() and I
> found one that should use the error labels.

Note that in practice it doesn't matter.

> +++ b/net/mac80211/iface.c	2012-04-03 14:44:24.000000000 +0200
> @@ -349,9 +349,8 @@ static int ieee80211_do_open(struct net_
>  		memcpy(dev->perm_addr, dev->dev_addr, ETH_ALEN);
>  
>  		if (!is_valid_ether_addr(dev->dev_addr)) {
> -			if (!local->open_count)
> -				drv_stop(local);
> -			return -EADDRNOTAVAIL;
> +			res = -EADDRNOTAVAIL;
> +			goto err_stop;
>  		}

This calls drv_stop() etc, so the only thing we don't clean up here is

>  	sdata->bss = NULL;
>  	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
>  		list_del(&sdata->u.vlan.list);
> +	/* might already be clear but that doesn't matter */
>  	clear_bit(SDATA_STATE_RUNNING, &sdata->state);

the BSS clearing and the state bit. Neither of those can actually be
relevant though since AP_VLAN interfaces can't be brought up as the
first ones since they're slaved to an AP interface...

Still better to clean up, but no reason to bother stable.

johannes


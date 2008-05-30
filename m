Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40589 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbYE3A4e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 20:56:34 -0400
Subject: Re: [PATCH] ipw2200: expire and use oldest BSS on adhoc create
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1212086308.25805.25.camel@localhost.localdomain>
References: <1212086308.25805.25.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 30 May 2008 08:56:05 +0800
Message-Id: <1212108965.7814.316.camel@debian.sh.intel.com> (sfid-20080530_025640_242060_4C2AEF92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-29 at 14:38 -0400, Dan Williams wrote:
> If there are no networks on the free list, expire the oldest one when
> creating a new adhoc network.  Because ipw2200 and the ieee80211 stack
> don't actually cull old networks and place them back on the free list
> unless they are needed for new probe responses, over time the free list
> would become empty and creating an adhoc network would fail due to the !
> list_empty(...) check.
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>

ACK. Looks like you are doing stress testing to create/delete ad-hoc
networks (> 128) ;-)

Thanks,
-yi

> diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
> index d74c061..db2bf46 100644
> --- a/drivers/net/wireless/ipw2200.c
> +++ b/drivers/net/wireless/ipw2200.c
> @@ -7558,8 +7558,31 @@ static int ipw_associate(void *data)
>  	    priv->ieee->iw_mode == IW_MODE_ADHOC &&
>  	    priv->config & CFG_ADHOC_CREATE &&
>  	    priv->config & CFG_STATIC_ESSID &&
> -	    priv->config & CFG_STATIC_CHANNEL &&
> -	    !list_empty(&priv->ieee->network_free_list)) {
> +	    priv->config & CFG_STATIC_CHANNEL) {
> +		/* Use oldest network if the free list is empty */
> +		if (list_empty(&priv->ieee->network_free_list)) {
> +			struct ieee80211_network *oldest = NULL;
> +			struct ieee80211_network *target;
> +			DECLARE_MAC_BUF(mac);
> +
> +			list_for_each_entry(target, &priv->ieee->network_list, list) {
> +				if ((oldest == NULL) ||
> +				    (target->last_scanned < oldest->last_scanned))
> +					oldest = target;
> +			}
> +
> +			/* If there are no more slots, expire the oldest */
> +			list_del(&oldest->list);
> +			target = oldest;
> +			IPW_DEBUG_ASSOC("Expired '%s' (%s) from "
> +					"network list.\n",
> +					escape_essid(target->ssid,
> +						     target->ssid_len),
> +					print_mac(mac, target->bssid));
> +			list_add_tail(&target->list,
> +				      &priv->ieee->network_free_list);
> +		}
> +
>  		element = priv->ieee->network_free_list.next;
>  		network = list_entry(element, struct ieee80211_network, list);
>  		ipw_adhoc_create(priv, network);


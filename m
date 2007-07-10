Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:43545 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753837AbXGJNwy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 09:52:54 -0400
Date: Tue, 10 Jul 2007 15:52:44 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Daniel Drake <dsd@gentoo.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: STA reassociation improvements
Message-ID: <20070710155244.2f16fd69@logostar.upir.cz>
In-Reply-To: <20070706195835.67CA17B409F@zog.reactivated.net>
References: <20070706195835.67CA17B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri,  6 Jul 2007 20:58:35 +0100 (BST), Daniel Drake wrote:
> --- wireless-dev.orig/net/mac80211/ieee80211.c
> +++ wireless-dev/net/mac80211/ieee80211.c
> @@ -2281,15 +2281,17 @@ static void ieee80211_if_shutdown(struct
>  {
>  	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
>  	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
>  
>  	ASSERT_RTNL();
>  	switch (sdata->type) {
>  	case IEEE80211_IF_TYPE_STA:
>  	case IEEE80211_IF_TYPE_IBSS:
> -		sdata->u.sta.state = IEEE80211_DISABLED;
> -		del_timer_sync(&sdata->u.sta.timer);
> -		del_timer_sync(&sdata->u.sta.admit_timer);
> -		skb_queue_purge(&sdata->u.sta.skb_queue);
> +		ifsta->state = IEEE80211_DISABLED;
> +		ifsta->prev_bssid_set = 0;

Good catch. But it should be set in ieee80211_if_open, not here.

> +		del_timer_sync(&ifsta->timer);
> +		del_timer_sync(&ifsta->admit_timer);
> +		skb_queue_purge(&ifsta->skb_queue);
>  		if (!local->ops->hw_scan &&
>  		    local->scan_dev == sdata->dev) {
>  			local->sta_scanning = 0;
> Index: wireless-dev/net/mac80211/ieee80211_sta.c
> ===================================================================
> --- wireless-dev.orig/net/mac80211/ieee80211_sta.c
> +++ wireless-dev/net/mac80211/ieee80211_sta.c
> @@ -1605,8 +1605,9 @@ static void ieee80211_rx_mgmt_assoc_resp
>  	if (status_code != WLAN_STATUS_SUCCESS) {
>  		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
>  		       dev->name, status_code);
> -		if (status_code == WLAN_STATUS_REASSOC_NO_ASSOC)
> -			ifsta->prev_bssid_set = 0;
> +		/* if this was a reassociation, ensure we try a "full"
> +		 * association next time */
> +		ifsta->prev_bssid_set = 0;

Although I don't like this, it probably does no harm and can workaround a
variety of broken APs. Could you extend the comment to include the reason
why this is done (i.e. that it's a workaround for broken APs)?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs

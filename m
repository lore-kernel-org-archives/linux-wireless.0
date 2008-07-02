Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4065 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbYGBTRS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 15:17:18 -0400
Date: Wed, 2 Jul 2008 15:00:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <bruno@thinktube.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: fix alternating-BSSID issue in IBSS
Message-ID: <20080702190059.GA31288@tuxdriver.com> (sfid-20080702_211721_604255_1F78CFF0)
References: <486A43D0.8020507@work.ksp.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <486A43D0.8020507@work.ksp.sk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 01, 2008 at 04:48:48PM +0200, Vladimir Koutny wrote:
> Due to the fact that we (still) keep old BSS information, we can end
> up switching between 2 or more BSSIDs when in IBSS (these are the
> BSSIDs of networks with the same name we've seen before, even if they
> are not around anymore). This switching happens in 30sec intervals
> (IBSS merge attempt when no active STAs are around).
> 
> This patch expires old BSS entries after IEEE80211_SCAN_RESULT_EXPIRE
> seconds (the same time after it will not be reported in scan results)
> when trying to merge.
> 
> Signed-off-by: Vladimir Koutny <vlado@ksp.sk>

This seems like a good thing to do, but the sta_bss_list is used in STA
mode too.  Perhaps we should find a time to run ieee80211_bss_expire
in STA mode as well?

> 
> ---
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 2b49852..b9ec4f6 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3276,12 +3276,32 @@ static void ieee80211_sta_expire(struct net_device *dev, unsigned long exp_time)
>  }
> 
> 
> +static void ieee80211_bss_expire(struct net_device *dev, unsigned long exp_time)

You probably want this positioned before (or
after?) ieee80211_rx_bss_free, and change the name to match.

> +{
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +	struct ieee80211_sta_bss *bss, *tmp;
> +	DECLARE_MAC_BUF(mac);
> +
> +	spin_lock_bh(&local->sta_bss_lock);
> +	list_for_each_entry_safe(bss, tmp, &local->sta_bss_list, list) {
> +		if (time_after(jiffies, bss->last_update + exp_time)) {
> +#ifdef CONFIG_MAC80211_IBSS_DEBUG

Since this hopefully won't be IBSS-specific, maybe use
MAC80211_VERBOSE_DEBUG instead?

> +			printk(KERN_DEBUG "%s: expiring inactive BSS %s\n",
> +				dev->name, print_mac(mac, bss->bssid));
> +#endif /* CONFIG_MAC80211_IBSS_DEBUG */
> +			ieee80211_rx_bss_put(dev, bss);
> +		}
> +	}
> +	spin_unlock_bh(&local->sta_bss_lock);
> +}
> +
>  static void ieee80211_sta_merge_ibss(struct net_device *dev,
>  				     struct ieee80211_if_sta *ifsta)
>  {
>  	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
> 
>  	ieee80211_sta_expire(dev, IEEE80211_IBSS_INACTIVITY_LIMIT);
> +	ieee80211_bss_expire(dev, IEEE80211_SCAN_RESULT_EXPIRE);
>  	if (ieee80211_sta_active_ibss(dev))
>  		return;
> 
> @@ -3662,8 +3662,10 @@ static int ieee80211_sta_find_ibss(struct net_device *dev,
>  	spin_unlock_bh(&local->sta_bss_lock);
> 
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
> -	printk(KERN_DEBUG "   sta_find_ibss: selected %s current "
> -	       "%s\n", print_mac(mac, bssid), print_mac(mac2, ifsta->bssid));
> +	if (found)
> +		printk(KERN_DEBUG "   sta_find_ibss: selected %s current "
> +		       "%s\n", print_mac(mac, bssid),
> +		       print_mac(mac2, ifsta->bssid));
>  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
>  	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
>  	    (bss = ieee80211_rx_bss_get(dev, bssid,

Should the last hunk be a different patch?

John
-- 
John W. Linville
linville@tuxdriver.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.171.29]:56244 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753353AbYJECbp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 22:31:45 -0400
Date: Sat, 4 Oct 2008 21:31:43 -0500
From: Robin Holt <holt@sgi.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Robin Holt <holt@sgi.com>, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: Infinite loop in sta_info_debugfs_add_work().
Message-ID: <20081005023143.GJ8534@sgi.com> (sfid-20081005_043149_967845_5BE91E1E)
References: <20081004103144.GI8534@sgi.com> <1223165956.24551.76.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223165956.24551.76.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 05, 2008 at 02:19:16AM +0200, Johannes Berg wrote:
...
> The code's trying to add debugfs entries for all STAs that don't have
> any yet. I suspect that maybe you don't have debugfs configured into
> your kernel or something is wrong; anyway, the code is really abusing
> the debugfs.dir as a flag "need to run ieee80211_sta_debugfs_add"; the
> problem is that ieee80211_sta_debugfs_add() doesn't necessarily set
> debugfs.dir to != NULL under all circumstances.
> 
> I think we'll have to add a flag, do you have a way to reproduce this?
> Can you try this patch?

Will try it.  To reproduce, suspend, wait 5 or so minutes, resume,
repeat until your keyboard leds stop flashing (usually within 3 or so
cycles).  I think this will kick us out of the loop.

As for not configured correctly, I just took the standard Ubuntu config
and answered the unconfigured items with their default settings.

Thanks,
Robin Holt


> 
> johannes
> 
> --- everything.orig/net/mac80211/debugfs_sta.c	2008-10-05 02:16:51.000000000 +0200
> +++ everything/net/mac80211/debugfs_sta.c	2008-10-05 02:17:06.000000000 +0200
> @@ -249,6 +249,8 @@ void ieee80211_sta_debugfs_add(struct st
>  	DECLARE_MAC_BUF(mbuf);
>  	u8 *mac;
>  
> +	sta->debugfs.add_has_run = true;
> +
>  	if (!stations_dir)
>  		return;
>  
> --- everything.orig/net/mac80211/sta_info.c	2008-10-05 02:16:06.000000000 +0200
> +++ everything/net/mac80211/sta_info.c	2008-10-05 02:18:12.000000000 +0200
> @@ -635,7 +635,12 @@ static void sta_info_debugfs_add_work(st
>  
>  		spin_lock_irqsave(&local->sta_lock, flags);
>  		list_for_each_entry(tmp, &local->sta_list, list) {
> -			if (!tmp->debugfs.dir) {
> +			/*
> +			 * debugfs.add_has_run will be set by
> +			 * ieee80211_sta_debugfs_add regardless
> +			 * of what else it does.
> +			 */
> +			if (!tmp->debugfs.add_has_run) {
>  				sta = tmp;
>  				__sta_info_pin(sta);
>  				break;
> --- everything.orig/net/mac80211/sta_info.h	2008-10-05 02:16:09.000000000 +0200
> +++ everything/net/mac80211/sta_info.h	2008-10-05 02:17:13.000000000 +0200
> @@ -312,6 +312,7 @@ struct sta_info {
>  		struct dentry *wme_tx_queue;
>  #endif
>  		struct dentry *agg_status;
> +		bool add_has_run;
>  	} debugfs;
>  #endif
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

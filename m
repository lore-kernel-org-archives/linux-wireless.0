Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:56094 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791AbZKWUVv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 15:21:51 -0500
Message-ID: <4B0AEEE3.2050808@irobot.com>
Date: Mon, 23 Nov 2009 12:21:55 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: Adhoc networking, was Re: compat-wireless and minstrel
References: <4AF0D54D.4090303@irobot.com>	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>	 <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com>	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>	 <4B01D4A5.7060204@irobot.com>	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>	 <4B01E298.3030602@irobot.com>	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz> <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>
In-Reply-To: <4B02DFE3.9040602@irobot.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What's the next step in making sure this patch makes it into the real world?

Adam Wozniak wrote:
> In either case, having minstrel use all rates doesn't seem like it 
> should hurt much.  This is the patch I'm running with now, and it 
> seems to work.  The changes in ibss.c make sure supp_rates is 
> initialized properly, and that rate control is called when a change 
> occurs.  If other stuff is working right (?) this should help PID and 
> other rate control algorithms.  The changes in rc80211_minstrel.c make 
> it ignore the supported rates set and just try everything.
>
>
> diff -upr compat-wireless-2009-11-17/net/mac80211/ibss.c 
> compat-wireless-2009-11-17a/net/mac80211/ibss.c
> --- compat-wireless-2009-11-17/net/mac80211/ibss.c    2009-11-16 
> 21:17:21.000000000 -0800
> +++ compat-wireless-2009-11-17a/net/mac80211/ibss.c    2009-11-17 
> 09:01:54.287720290 -0800
> @@ -246,9 +246,13 @@ static void ieee80211_rx_bss_info(struct
>     if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
>         return;
>
> +    supp_rates = ieee80211_sta_get_rates(local, elems, band);
> +
> +    /* make sure mandatory rates are always added */
> +    supp_rates |= ieee80211_mandatory_rates(local, band);
> +
>     if (sdata->vif.type == NL80211_IFTYPE_ADHOC && elems->supp_rates &&
>         memcmp(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0) {
> -        supp_rates = ieee80211_sta_get_rates(local, elems, band);
>
>         rcu_read_lock();
>
> @@ -257,12 +261,10 @@ static void ieee80211_rx_bss_info(struct
>             u32 prev_rates;
>
>             prev_rates = sta->sta.supp_rates[band];
> -            /* make sure mandatory rates are always added */
> -            sta->sta.supp_rates[band] = supp_rates |
> -                ieee80211_mandatory_rates(local, band);
> +            sta->sta.supp_rates[band] = supp_rates;
>
> +            if (sta->sta.supp_rates[band] != prev_rates) {
> #ifdef CONFIG_MAC80211_IBSS_DEBUG
> -            if (sta->sta.supp_rates[band] != prev_rates)
>                 printk(KERN_DEBUG "%s: updated supp_rates set "
>                     "for %pM based on beacon info (0x%llx | "
>                     "0x%llx -> 0x%llx)\n",
> @@ -272,6 +274,8 @@ static void ieee80211_rx_bss_info(struct
>                     (unsigned long long) supp_rates,
>                     (unsigned long long) sta->sta.supp_rates[band]);
> #endif
> +                rate_control_rate_init(sta);
> +            }
>         } else
>             ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 
> supp_rates);
>
> @@ -415,6 +419,15 @@ struct sta_info *ieee80211_ibss_add_sta(
>     sta->sta.supp_rates[band] = supp_rates |
>             ieee80211_mandatory_rates(local, band);
>
> +#ifdef CONFIG_MAC80211_IBSS_DEBUG
> +    printk(KERN_DEBUG "%s: initialized supp_rates set "
> +        "for %pM (0x%llx) (band %d)\n",
> +        sdata->dev->name,
> +        sta->sta.addr,
> +        (unsigned long long) sta->sta.supp_rates[band],
> +        band);
> +#endif
> +
>     rate_control_rate_init(sta);
>
>     if (sta_info_insert(sta))
> diff -upr compat-wireless-2009-11-17/net/mac80211/rc80211_minstrel.c 
> compat-wireless-2009-11-17a/net/mac80211/rc80211_minstrel.c
> --- compat-wireless-2009-11-17/net/mac80211/rc80211_minstrel.c    
> 2009-11-16 21:17:21.000000000 -0800
> +++ compat-wireless-2009-11-17a/net/mac80211/rc80211_minstrel.c    
> 2009-11-17 09:02:25.544628968 -0800
> @@ -395,8 +395,6 @@ minstrel_rate_init(void *priv, struct ie
>         unsigned int tx_time_single;
>         unsigned int cw = mp->cw_min;
>
> -        if (!rate_supported(sta, sband->band, i))
> -            continue;
>         n++;
>         memset(mr, 0, sizeof(*mr));


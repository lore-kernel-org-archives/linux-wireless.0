Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbXIZTOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 15:14:46 -0400
Subject: Re: [PATCH] mac80211: bss_tim_clear must use ~ instead of !
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709262108.47882.mb@bu3sch.de>
References: <200709262108.47882.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 21:15:56 +0200
Message-Id: <1190834156.16048.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-09-26 at 21:08 +0200, Michael Buesch wrote:
> We need to use bitwise NOT.
> This also cleans up the code a little bit to make it more readable.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Looks good, thanks

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> Index: wireless-2.6/net/mac80211/ieee80211_i.h
> ===================================================================
> --- wireless-2.6.orig/net/mac80211/ieee80211_i.h	2007-09-26 21:04:03.000000000 +0200
> +++ wireless-2.6/net/mac80211/ieee80211_i.h	2007-09-26 21:04:05.000000000 +0200
> @@ -648,34 +648,34 @@ struct sta_attribute {
>  	ssize_t (*store)(struct sta_info *, const char *buf, size_t count);
>  };
>  
> -static inline void __bss_tim_set(struct ieee80211_if_ap *bss, int aid)
> +static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
>  {
>  	/*
> -	 * This format has ben mandated by the IEEE specifications,
> +	 * This format has been mandated by the IEEE specifications,
>  	 * so this line may not be changed to use the __set_bit() format.
>  	 */
> -	bss->tim[(aid)/8] |= 1<<((aid) % 8);
> +	bss->tim[aid / 8] |= (1 << (aid % 8));
>  }
>  
>  static inline void bss_tim_set(struct ieee80211_local *local,
> -			       struct ieee80211_if_ap *bss, int aid)
> +			       struct ieee80211_if_ap *bss, u16 aid)
>  {
>  	read_lock_bh(&local->sta_lock);
>  	__bss_tim_set(bss, aid);
>  	read_unlock_bh(&local->sta_lock);
>  }
>  
> -static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, int aid)
> +static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, u16 aid)
>  {
>  	/*
> -	 * This format has ben mandated by the IEEE specifications,
> +	 * This format has been mandated by the IEEE specifications,
>  	 * so this line may not be changed to use the __clear_bit() format.
>  	 */
> -	bss->tim[(aid)/8] &= !(1<<((aid) % 8));
> +	bss->tim[aid / 8] &= ~(1 << (aid % 8));
>  }
>  
>  static inline void bss_tim_clear(struct ieee80211_local *local,
> -				 struct ieee80211_if_ap *bss, int aid)
> +				 struct ieee80211_if_ap *bss, u16 aid)
>  {
>  	read_lock_bh(&local->sta_lock);
>  	__bss_tim_clear(bss, aid);
> 


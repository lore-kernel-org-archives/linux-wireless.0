Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965291AbXCFQfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 11:35:24 -0500
Subject: Re: [FYI] compiling hostapd against latest wireless-dev
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1173095902.6131.63.camel@johannes.berg>
References: <1173095902.6131.63.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 10:40:38 -0500
Message-Id: <1173195638.12545.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-03-05 at 12:58 +0100, Johannes Berg wrote:
> ... isn't really possible at the moment. But you only need to change
> some include paths (to be able to include the
> net/mac80211/mac80211_common.h header!) and apply this change to be able
> to include include/net/mac80211.h into the userspace code.
> 
> And no, this shouldn't be applied. Rather should the prism ioctl foo be
> deleted.

Right; if there's something that the prism ioctls do that cfg80211
doesn't, and that something is useful, then we probably need to extend
cfg80211 to do that thing.  Then we rip out all the custom ioctl junk
everywhere.

Dan


> johannes
> 
> --- wireless-dev.orig/include/net/mac80211.h	2007-03-04 01:53:43.719146462 +0100
> +++ wireless-dev/include/net/mac80211.h	2007-03-04 01:55:13.489146462 +0100
> @@ -10,6 +10,7 @@
>  #ifndef MAC80211_H
>  #define MAC80211_H
>  
> +#ifdef __KERNEL__
>  #include <linux/kernel.h>
>  #include <linux/if_ether.h>
>  #include <linux/skbuff.h>
> @@ -18,7 +19,7 @@
>  #include <linux/ieee80211.h>
>  #include <net/wireless.h>
>  #include <net/cfg80211.h>
> -
> +#endif
>  /* Note! Only ieee80211_tx_status_irqsafe() and ieee80211_rx_irqsafe() can be
>   * called in hardware interrupt context. The low-level driver must not call any
>   * other functions in hardware interrupt context. If there is a need for such
> @@ -108,7 +109,7 @@ enum {
>  	MODE_ATHEROS_TURBOG = 4 /* Atheros Turbo mode (2x.11g at 2.4 GHz) */,
>  	NUM_IEEE80211_MODES = 5
>  };
> -
> +#ifdef __KERNEL__
>  struct ieee80211_hw_mode {
>  	int mode; /* MODE_IEEE80211... */
>  	int num_channels; /* Number of channels (below) */
> @@ -118,7 +119,7 @@ struct ieee80211_hw_mode {
>  
>  	struct list_head list; /* Internal, don't touch */
>  };
> -
> +#endif
>  struct ieee80211_tx_queue_params {
>  	int aifs; /* 0 .. 255; -1 = use default */
>  	int cw_min; /* 2^n-1: 1, 3, 7, .. , 1023; 0 = use default */
> @@ -552,7 +553,7 @@ struct ieee80211_hw {
>  	 * WMM requires at least four queues. */
>  	int queues;
>  };
> -
> +#ifdef __KERNEL__
>  static inline void SET_IEEE80211_DEV(struct ieee80211_hw *hw, struct device *dev)
>  {
>  	set_wiphy_dev(hw->wiphy, dev);
> @@ -1079,4 +1080,6 @@ static inline int ieee80211_get_morefrag
>  #define MAC_ARG(x) ((u8*)(x))[0], ((u8*)(x))[1], ((u8*)(x))[2], \
>  		   ((u8*)(x))[3], ((u8*)(x))[4], ((u8*)(x))[5]
>  
> +#endif
> +
>  #endif /* MAC80211_H */
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19490 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326AbYD3TjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 15:39:04 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [RFC/RFT 4/4] mac80211: use multi-queue master netdevice
Date: Wed, 30 Apr 2008 12:39:04 -0700
Message-ID: <D5C1322C3E673F459512FB59E0DDC32904FE144F@orsmsx414.amr.corp.intel.com> (sfid-20080430_213901_949898_771C3282)
In-Reply-To: <20080430130051.397094000@sipsolutions.net>
References: <20080430124055.091382000@sipsolutions.net> <20080430130051.397094000@sipsolutions.net>
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Cc: <netdev@vger.kernel.org>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> --- everything.orig/net/mac80211/util.c	2008-04-30 
> 14:02:31.000000000 +0200
> +++ everything/net/mac80211/util.c	2008-04-30 
> 14:20:06.000000000 +0200
> @@ -323,18 +323,28 @@ __le16 ieee80211_ctstoself_duration(stru
>  }
>  EXPORT_SYMBOL(ieee80211_ctstoself_duration);
>  
> +void ieee80211_start_queue(struct ieee80211_hw *hw, int queue)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +#ifdef CONFIG_MAC80211_QOS
> +	netif_start_subqueue(local->mdev, queue);
> +#else
> +	WARN_ON(queue != 0);
> +	netif_start_queue(local->mdev);
> +#endif
> +}
> +EXPORT_SYMBOL(ieee80211_start_queue);
> +

I would suggest that you enable the netdev feature flag for
NETIF_F_MULTI_QUEUE on devices when you create them.  That way you can
have things like ieee80211_start_queue() key on that instead of a
compile-time option, in case wireless devices come along that won't
support multiple queues, if that's possible.  So something like this:

+void ieee80211_start_queue(struct ieee80211_hw *hw, int queue)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	if (netif_is_multiqueue(local->mdev) {
+		netif_start_subqueue(local->mdev, queue);
+	} else {
+		WARN_ON(queue != 0);
+		netif_start_queue(local->mdev);
+	}
+}
+EXPORT_SYMBOL(ieee80211_start_queue);
+

If you think this is a decent idea, I'd suggest that any function that
has a compile-time check for multiqueue being changed to use the runtime
check.  Then in your device setup, where you call netdev_alloc_mq(),
there you set the flag NETIF_F_MULTI_QUEUE based on the device features.

Other than that, this patch looks great.  Exciting to see this starting
to take flight.

Cheers,
-PJ Waskiewicz

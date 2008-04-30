Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:2353 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595AbYD3Pah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 11:30:37 -0400
Received: by fg-out-1718.google.com with SMTP id 19so196604fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2008 08:30:35 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT 4/4] mac80211: use multi-queue master netdevice
Date: Wed, 30 Apr 2008 17:34:10 +0200
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
References: <20080430124055.091382000@sipsolutions.net> <1209566743.18659.30.camel@johannes.berg> <1209567609.18659.33.camel@johannes.berg>
In-Reply-To: <1209567609.18659.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804301734.11804.IvDoorn@gmail.com> (sfid-20080430_173041_399724_C46A339F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Don't want to spoil the fun, but the following part doesn't compile
when CONFIG_MAC80211_QOS is not set.

In the following occurences struct ieee80211_local *local needs to be defined.

>  void ieee80211_start_queues(struct ieee80211_hw *hw)
>  {
> -	struct ieee80211_local *local = hw_to_local(hw);
> +#ifdef CONFIG_MAC80211_QOS
>  	int i;
>  
> -	for (i = 0; i < local->hw.queues; i++)
> -		clear_bit(IEEE80211_LINK_STATE_XOFF, &local->state[i]);
> -	if (!ieee80211_qdisc_installed(local->mdev))
> -		netif_start_queue(local->mdev);
> +	for (i = 0; i < hw->queues; i++)
> +		ieee80211_start_queue(hw, i);
> +#else

	struct ieee80211_local *local = hw_to_local(hw);

> +	netif_start_queue(local->mdev);
> +#endif
>  }
>  EXPORT_SYMBOL(ieee80211_start_queues);
>  
>  void ieee80211_stop_queues(struct ieee80211_hw *hw)
>  {
> +#ifdef CONFIG_MAC80211_QOS
>  	int i;
>  
>  	for (i = 0; i < hw->queues; i++)
>  		ieee80211_stop_queue(hw, i);
> +#else

	struct ieee80211_local *local = hw_to_local(hw);

> +	netif_stop_queue(local->mdev);
> +#endif
>  }
>  EXPORT_SYMBOL(ieee80211_stop_queues);
>  
>  void ieee80211_wake_queues(struct ieee80211_hw *hw)
>  {
> +#ifdef CONFIG_MAC80211_QOS
>  	int i;
>  
>  	for (i = 0; i < hw->queues; i++)
>  		ieee80211_wake_queue(hw, i);
> +#else

	struct ieee80211_local *local = hw_to_local(hw);

> +	netif_wake_queue(local->mdev);
> +#endif
>  }
>  EXPORT_SYMBOL(ieee80211_wake_queues);

Ivo

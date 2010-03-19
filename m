Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:45982 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0CSJdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 05:33:50 -0400
Received: by fxm19 with SMTP id 19so408473fxm.21
        for <linux-wireless@vger.kernel.org>; Fri, 19 Mar 2010 02:33:48 -0700 (PDT)
Message-ID: <4BA344FB.1090500@gmail.com>
Date: Fri, 19 Mar 2010 10:33:47 +0100
From: "lorenzo.bianconi83@gmail.com" <lorenzo.bianconi@fluidmesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Bruno Randolf <br1@einfach.org>, Tony Huang <ht6100@gmail.com>
Subject: Re: [PATCH V2] mac80211: Revise,pending queue depth in ieee80211_local
 data structure
References: <4BA24A12.4030208@gmail.com> <1268936446.4005.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1268936446.4005.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Please try this.
> 
> johannes
> 
> ---
>  net/mac80211/tx.c   |    6 ++++++
>  net/mac80211/util.c |    6 ------
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> --- wireless-testing.orig/net/mac80211/tx.c	2010-03-18 11:17:43.000000000 -0700
> +++ wireless-testing/net/mac80211/tx.c	2010-03-18 11:19:16.000000000 -0700
> @@ -1991,6 +1991,7 @@ static bool ieee80211_tx_pending_skb(str
>  void ieee80211_tx_pending(unsigned long data)
>  {
>  	struct ieee80211_local *local = (struct ieee80211_local *)data;
> +	struct ieee80211_sub_if_data *sdata;
>  	unsigned long flags;
>  	int i;
>  	bool txok;
> @@ -2029,6 +2030,11 @@ void ieee80211_tx_pending(unsigned long
>  			if (!txok)
>  				break;
>  		}
> +
> +		if (skb_queue_empty(&local->pending[i]))
> +			list_for_each_entry_rcu(sdata, &local->interfaces, list)
> +				netif_tx_wake_queue(
> +					netdev_get_tx_queue(sdata->dev, i));
>  	}
>  	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
>  
> --- wireless-testing.orig/net/mac80211/util.c	2010-03-18 11:17:08.000000000 -0700
> +++ wireless-testing/net/mac80211/util.c	2010-03-18 11:19:28.000000000 -0700
> @@ -268,7 +268,6 @@ static void __ieee80211_wake_queue(struc
>  				   enum queue_stop_reason reason)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
> -	struct ieee80211_sub_if_data *sdata;
>  
>  	if (WARN_ON(queue >= hw->queues))
>  		return;
> @@ -281,11 +280,6 @@ static void __ieee80211_wake_queue(struc
>  
>  	if (!skb_queue_empty(&local->pending[queue]))
>  		tasklet_schedule(&local->tx_pending_tasklet);
> -
> -	rcu_read_lock();
> -	list_for_each_entry_rcu(sdata, &local->interfaces, list)
> -		netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
> -	rcu_read_unlock();
>  }
>  
>  void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
> 
> 

Hi Johannes,

I tested the patch on kernel 2.6.32.7 with compat-wireless-2010-03-03 but
it seems that the problem is not solved. If I set the lowest priority queue
(Backgreound), the system will crash for an out of memory panic. During the
tests I carried out, I transmit 50Mbps UDP traffic.

Regards

Lorenzo

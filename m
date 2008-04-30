Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:2301 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbYD3Odw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 10:33:52 -0400
Received: by fg-out-1718.google.com with SMTP id 19so176603fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2008 07:33:50 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT 4/4] mac80211: use multi-queue master netdevice
Date: Wed, 30 Apr 2008 16:37:33 +0200
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
References: <20080430124055.091382000@sipsolutions.net> <20080430130051.397094000@sipsolutions.net>
In-Reply-To: <20080430130051.397094000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804301637.35170.IvDoorn@gmail.com> (sfid-20080430_163345_412797_D48B651E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Overall the rt2x00 changes are good, but I have a few suggestions :)

> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-04-30 14:02:32.000000000 +0200
> +++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-04-30 14:02:34.000000000 +0200
> @@ -81,7 +81,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
>  {
>  	struct rt2x00_dev *rt2x00dev = hw->priv;
>  	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
> -	enum data_queue_qid qid = mac80211_queue_to_qid(control->queue);
> +	enum data_queue_qid qid = skb_get_queue_mapping(skb);
>  	struct data_queue *queue;
>  	struct skb_frame_desc *skbdesc;
>  	u16 frame_control;
> @@ -129,12 +129,14 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
>  			       IEEE80211_TXCTL_USE_CTS_PROTECT)) &&
>  	    !rt2x00dev->ops->hw->set_rts_threshold) {
>  		if (rt2x00queue_available(queue) <= 1) {
> -			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
> +			ieee80211_stop_queue(
> +				rt2x00dev->hw, skb_get_queue_mapping(skb));

ieee80211_stop_queue(rt2x00dev->hw, qid);
The result of skb_get_queue_mapping(skb) was already stored in the
'qid' variable at the start of the function. And since this is a 1-1 mapping
from skb queue to rt2x00 queue, it is safe to use 'qid' directly in all instances.

>  			return NETDEV_TX_BUSY;
>  		}
>  
>  		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb, control)) {
> -			ieee80211_stop_queue(rt2x00dev->hw, control->queue);
> +			ieee80211_stop_queue(
> +				rt2x00dev->hw, skb_get_queue_mapping(skb));

ieee80211_stop_queue(rt2x00dev->hw, qid);

>  			return NETDEV_TX_BUSY;
>  		}
>  	}
> @@ -146,12 +148,12 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
>  	memset(skbdesc, 0, sizeof(*skbdesc));
>  
>  	if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb, control)) {
> -		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
> +		ieee80211_stop_queue(rt2x00dev->hw, skb_get_queue_mapping(skb));

ieee80211_stop_queue(rt2x00dev->hw, qid);

>  		return NETDEV_TX_BUSY;
>  	}
>  
>  	if (rt2x00queue_full(queue))
> -		ieee80211_stop_queue(rt2x00dev->hw, control->queue);
> +		ieee80211_stop_queue(rt2x00dev->hw, skb_get_queue_mapping(skb));

ieee80211_stop_queue(rt2x00dev->hw, qid);

>  	if (rt2x00dev->ops->lib->kick_tx_queue)
>  		rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, qid);

Thanks,

Ivo

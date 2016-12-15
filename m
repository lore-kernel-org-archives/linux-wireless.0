Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42214 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751214AbcLOJQe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 04:16:34 -0500
Message-ID: <1481793392.31776.3.camel@sipsolutions.net> (sfid-20161215_101640_512642_51996379)
Subject: Re: [RFC 1/3] mac80211: Add provision for 802.11 encap/decap offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Dec 2016 10:16:32 +0100
In-Reply-To: <1481781608-5181-2-git-send-email-vthiagar@qti.qualcomm.com>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1481781608-5181-2-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Drivers advertising this capability should also implement other
> functionalities which deal with 802.11 frame format like below

> 	- ADDBA/DELBA offload

This shouldn't be necessary.

> 	- Hardware rate control

Neither is this, if we find some API to do sampling. The existing rate
table API already allows setting the rates out of band, so the only
thing that you'd have to support out of band is sampling.

> 	- Powersave offload

That's ambiguous - you do need to handle sleeping stations (and PS-
Poll/U-APSD) in AP mode in the device with this, but I don't see a deep
technical reason to require it for client mode. OTOH, client mode is
almost always offloaded anyway.

I think you may have forgotten one important item,

	- control port handling

?

> + * @IEEE80211_HW_SUPPORTS_80211_ENCAP_DECAP: Hardware/driver
> supports 802.11
> + *	encap/decap for data frames. Supporting driver have to
> implement
> + *	get_vif_80211_encap_decap_offload() to pass if 802.11
> encap/decap
> + *	offload	is supported for the vif.

I don't see why you need this, when you have the method - you can just
assume that the method returns false when it's not implemented.

>  struct ieee80211_ops {
>  	void (*tx)(struct ieee80211_hw *hw,
> @@ -3639,6 +3651,10 @@ struct ieee80211_ops {
>  	void (*wake_tx_queue)(struct ieee80211_hw *hw,
>  			      struct ieee80211_txq *txq);
>  	void (*sync_rx_queues)(struct ieee80211_hw *hw);
> +
> +	int (*get_vif_80211_hdr_offload)(struct ieee80211_hw *hw,
> +					 struct ieee80211_vif *vif,
> +					 bool is_4addr, bool
> *supported);

Why are you not simply returning "supported"?

I don't like passing the vif pointer here. At this point, the vif
pointer isn't known to the driver yet (through drv_add_interface) so
it's a dead pointer as far as the sequencing is concerned.

Is there a possibility that drivers need to switch off ethernet format
handling entirely when an incompatible interface is added? For example,
if you add a mesh interface, is there a chance that the AP interface
might no longer be able to handle this?

I'd hope this doesn't happen because I think that would be extremely
complicated to handle safely.

johannes

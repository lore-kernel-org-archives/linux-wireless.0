Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:54661 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753725Ab3FEOJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 10:09:43 -0400
Date: Wed, 5 Jun 2013 17:09:32 +0300
From: Jouni Malinen <j@w1.fi>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: limit multicast buffer hardware queue depth
Message-ID: <20130605140932.GA8918@w1.fi> (sfid-20130605_160951_543901_807BC1CB)
References: <1370280714-1594-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370280714-1594-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 03, 2013 at 07:31:54PM +0200, Felix Fietkau wrote:
> The CAB (Content after Beacon) queue is used for beacon-triggered
> transmission of buffered multicast frames. If lots of multicast frames
> were buffered and this queue fills up, it drowns out all regular
> traffic. To limit the damage that buffered traffic can do, try to limit
> the queued data to becaon_interval / 8.

I'm not sure this would be compliant with the standard, but I guess
something along these lines could be reasonable in some cases. However,
it could be useful to take into account different DTIM Period parameters
in the limit and instead of hardcoding this to one eight of the Beacon
interval, the limit could be set based on Beacon interval * DTIM Period.
Especially with large DTIM Period values, one eight of a Beacon interval
may not be sufficient to handle even reasonable amount of group
addressed frames.

Does this commit address More Data field updates when the driver decides
to stop getting more frames without notifying mac80211 of this? The
associated STAs would need to know when they can go back to sleep after
the DTIM Beacon and the More Data field needs to be set to zero in the
last frame the AP is sending out in the case this new limit is hit.

> diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
> @@ -205,9 +205,15 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,

>  	while (skb) {
>  		ath9k_tx_cabq(hw, skb);
> +
> +		if (sc->beacon.cabq_dur / 1000 - 1 >
> +		    sc->cur_beacon_conf.beacon_interval / ATH_BCBUF)
> +			break;
> +
>  		skb = ieee80211_get_buffered_bc(hw, vif);
>  	}

mac80211 handles the More Data field values based on what is actually
buffered. I don't see how this patch would fix that either by modifying
mac80211 to know that no more buffered frames are sent or by having the
driver update the frame.
 
-- 
Jouni Malinen                                            PGP id EFC895FA

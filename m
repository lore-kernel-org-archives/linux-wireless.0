Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41899 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1KPOkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 09:40:02 -0500
Received: by vcbfk1 with SMTP id fk1so416343vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 06:40:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111116142911.501655161@sipsolutions.net>
References: <20111116142854.518391560@sipsolutions.net>
	<20111116142911.501655161@sipsolutions.net>
Date: Wed, 16 Nov 2011 15:40:01 +0100
Message-ID: <CAOZOX0VkGezQcijrEMiQSiuY=yadgSva7w9-SfrvYYW_UG+0LQ@mail.gmail.com> (sfid-20111116_154007_086166_B9B26D94)
Subject: Re: [PATCH 4/4] mac80211: transmit fragment list to drivers
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> --- a/include/net/mac80211.h    2011-11-16 15:19:31.000000000 +0100
> +++ b/include/net/mac80211.h    2011-11-16 15:20:03.000000000 +0100
> @@ -1760,11 +1760,20 @@ enum ieee80211_frame_release_type {
>  *     skb contains the buffer starting from the IEEE 802.11 header.
>  *     The low-level driver should send the frame out based on
>  *     configuration in the TX control data. This handler should,
> - *     preferably, never fail and stop queues appropriately, more
> - *     importantly, however, it must never fail for A-MPDU-queues.
> - *     This function should return NETDEV_TX_OK except in very
> - *     limited cases.
> - *     Must be implemented and atomic.
> + *     preferably, never fail and stop queues appropriately.
> + *     This needs only be implemented if @tx_frags is set to the
> + *     ieee80211_generic_tx_frags handler.
> + *     Must be atomic.
> + *
> + * @tx_frags: Called to transmit multiple fragments of a single MSDU.
> + *     This handler must consume all fragments, sending out some of
> + *     them only is useless and it can't ask for some of them to be
> + *     queued again. If the frame is not fragmented the queue has a
> + *     single SKB only.
> + *     If this is called, the tx_info @vif and @sta pointer will be
> + *     invalid -- you must not use them in that case.
> + *     Must be implemented and atomic. If the driver implements @tx
> + *     only then this must be set to ieee80211_generic_tx_frags().

<..snip..>

> --- a/net/mac80211/driver-ops.h 2011-11-16 15:19:31.000000000 +0100
> +++ b/net/mac80211/driver-ops.h 2011-11-16 15:20:03.000000000 +0100
> @@ -15,6 +15,18 @@ static inline void drv_tx(struct ieee802
>        local->ops->tx(&local->hw, skb);
>  }
>
> +static inline void drv_tx_frags(struct ieee80211_local *local,
> +                               struct ieee80211_sub_if_data *sdata,
> +                               struct sta_info *sta,
> +                               struct sk_buff_head *skbs,
> +                               void *internal)
> +{
> +       local->ops->tx_frags(&local->hw,
> +                            sdata ? &sdata->vif : NULL,
> +                            sta ? &sta->sta : NULL,
> +                            skbs, internal);
> +}

Instead of changing every driver and making .tx_frags callback mandatory,
isn't it easier to have a if-else here?
Then it is much easier for the drivers as you can document that either
.tx or .tx_frags is mandatory but never both.

Ivo

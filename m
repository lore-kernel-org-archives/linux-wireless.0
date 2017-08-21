Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:43275 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753264AbdHUNlb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 09:41:31 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3/3] mac80211: fix VLAN handling with TXQs
In-Reply-To: <20170622102030.9795-3-johannes@sipsolutions.net>
References: <20170622102030.9795-1-johannes@sipsolutions.net> <20170622102030.9795-3-johannes@sipsolutions.net>
Date: Mon, 21 Aug 2017 15:32:16 +0200
Message-ID: <87378lvyfz.fsf@toke.dk> (sfid-20170821_154135_094658_E8FF41A0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index b2b5419467cc..263cb30d77c8 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -919,21 +919,10 @@ struct ieee80211_tx_info {
>  				unsigned long jiffies;
>  			};
>  			/* NB: vif can be NULL for injected frames */
> -			union {
> -				/* NB: vif can be NULL for injected frames */
> -				struct ieee80211_vif *vif;
> -
> -				/* When packets are enqueued on txq it's easy
> -				 * to re-construct the vif pointer. There's no
> -				 * more space in tx_info so it can be used to
> -				 * store the necessary enqueue time for packet
> -				 * sojourn time computation.
> -				 */
> -				codel_time_t enqueue_time;
> -			};
> +			struct ieee80211_vif *vif;
>  			struct ieee80211_key_conf *hw_key;
>  			u32 flags;
> -			/* 4 bytes free */
> +			codel_time_t enqueue_time;

A side effect of this is that enqueue_time will be valid in the driver;
which is good as far as I'm concerned (I've been thinking about using it
to make decisions about when to stop retrying a frame).

If we want to save the four bytes, is there any reason we can't just
change the codel code to use skb->tstamp instead?

-Toke

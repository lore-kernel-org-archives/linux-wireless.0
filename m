Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40281 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab2EHUPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 16:15:44 -0400
Message-ID: <4FA97EEA.3070900@candelatech.com> (sfid-20120508_221555_378815_2907BEA3)
Date: Tue, 08 May 2012 13:15:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: allow low-level drivers to set netdev feature
 bits
References: <1336506821-23709-1-git-send-email-arik@wizery.com> <1336506821-23709-2-git-send-email-arik@wizery.com>
In-Reply-To: <1336506821-23709-2-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2012 12:53 PM, Arik Nemtsov wrote:
> Allow low-level drivers to change the feature bit for a vif's underlying
> net_device struct.
>
> Signed-off-by: Arik Nemtsov<arik@wizery.com>
> ---
>   include/net/mac80211.h |   10 ++++++++++
>   net/mac80211/tx.c      |    9 +++++++++
>   2 files changed, 19 insertions(+)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 4d6e6c6..acc46b2 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2992,6 +2992,16 @@ struct sk_buff *
>   ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
>
>   /**
> + * ieee80211_set_netdev_features - set netdev feature bits for vif
> + * @vif: virtual interface to set netdev flags on
> + * @features: feature bits (see&struct net_device for details)
> + *
> + * This function sets netdev feature bit for the device associated with the
> + * specified vif.
> + */
> +void ieee80211_set_netdev_features(struct ieee80211_vif *vif, int features);

Features are uint64 now I think.  In fact, there is a type-def
for them..probably should use that instead.

> +
> +/**
>    * ieee80211_get_tkip_p1k_iv - get a TKIP phase 1 key for IV32
>    *
>    * This function returns the TKIP phase 1 key for the given IV32.
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index d67d36f..d9f94a6 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -2754,3 +2754,12 @@ void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
>   	ieee80211_xmit(sdata, skb);
>   	local_bh_enable();
>   }
> +
> +void ieee80211_set_netdev_features(struct ieee80211_vif *vif, int features)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +
> +	if (sdata->dev)
> +		sdata->dev->features |= features;

And how to turn off features??  I think you could
just implement the ethtool api, and then have your drivers
call that?  That way you get two features at once!

Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


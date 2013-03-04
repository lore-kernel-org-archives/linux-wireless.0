Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50261 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243Ab3CDRMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 12:12:48 -0500
Message-ID: <5134D604.3060608@candelatech.com> (sfid-20130304_181252_789130_C71E1307)
Date: Mon, 04 Mar 2013 09:12:36 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: provide race-free 64-bit traffic counters
References: <1362416578-1672-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1362416578-1672-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/04/2013 09:02 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Make the TX bytes/packets counters race-free by keeping
> them per AC so concurrent TX on queues can't cause lost
> or wrong updates. This works since each station belongs
> to a single interface. While at it also make the bytes
> counters 64-bit.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   net/mac80211/cfg.c      | 22 ++++++++++++++--------
>   net/mac80211/sta_info.h |  9 +++++----
>   net/mac80211/tx.c       |  5 +++--
>   3 files changed, 22 insertions(+), 14 deletions(-)
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 8259a5b..1ff629a 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -445,12 +445,13 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>   	struct ieee80211_sub_if_data *sdata = sta->sdata;
>   	struct ieee80211_local *local = sdata->local;
>   	struct timespec uptime;
> +	int ac;
>
>   	sinfo->generation = sdata->local->sta_generation;
>
>   	sinfo->filled = STATION_INFO_INACTIVE_TIME |
> -			STATION_INFO_RX_BYTES |
> -			STATION_INFO_TX_BYTES |
> +			STATION_INFO_RX_BYTES64 |
> +			STATION_INFO_TX_BYTES64 |
>   			STATION_INFO_RX_PACKETS |
>   			STATION_INFO_TX_PACKETS |
>   			STATION_INFO_TX_RETRIES |
> @@ -467,10 +468,14 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>   	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
>
>   	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
> +	sinfo->tx_bytes = 0;
> +	sinfo->tx_packets = 0;
> +	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
> +		sinfo->tx_bytes += sta->tx_bytes[ac];
> +		sinfo->tx_packets += sta->tx_packets[ac];
> +	}

I think you'll need tx_packets to be u64 as well, as otherwise
if a queue wraps it's going to be quite hard to figure out?

Thanks,
Ben

>   	/* Updated from TX path only, no locking requirements */
> -	unsigned long tx_packets;
> -	unsigned long tx_bytes;
> -	unsigned long tx_fragments;
> +	u32 tx_packets[IEEE80211_NUM_ACS];
> +	u32 tx_fragments;
> +	u64 tx_bytes[IEEE80211_NUM_ACS];
>   	struct ieee80211_tx_rate last_tx_rate;
>   	int last_rx_rate_idx;
>   	u32 last_rx_rate_flag;
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index c79860f..6af7f60 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -991,14 +991,15 @@ static ieee80211_tx_result debug_noinline
>   ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
>   {
>   	struct sk_buff *skb;
> +	int ac = skb_get_queue_mapping(tx->skb);
>
>   	if (!tx->sta)
>   		return TX_CONTINUE;
>
> -	tx->sta->tx_packets++;
> +	tx->sta->tx_packets[ac]++;
>   	skb_queue_walk(&tx->skbs, skb) {
>   		tx->sta->tx_fragments++;
> -		tx->sta->tx_bytes += skb->len;
> +		tx->sta->tx_bytes[ac] += skb->len;
>   	}
>
>   	return TX_CONTINUE;
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


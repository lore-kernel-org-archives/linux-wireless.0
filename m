Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55589 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab1FXTVJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:21:09 -0400
Message-ID: <4E04E3A2.60408@openwrt.org> (sfid-20110624_212114_113931_D59B7968)
Date: Fri, 24 Jun 2011 21:21:06 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Alexander Simon <alexander.simon@saxnet.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3 3/3] mac80211: HT operation in IBSS
References: <1308671129.2656.4.camel@alex-2> <1308671609.2656.10.camel@alex-2>
In-Reply-To: <1308671609.2656.10.camel@alex-2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-06-21 5:53 PM, Alexander Simon wrote:
> My third try of an HT implementation for IBSS.
>
> * HT mode is proposed by nl80211
> * Allow frame aggregation to start for IBSS
> * Build HT IEs
>
> For fixed channel, HT mode is also fixed. Merge or join only if HT mode of some
> other BSS is the same as set by nl80211.
>
> For proposed channel, HT mode is also proposed. This means, if we join a HT
> IBSS, its HT mode is taken.
> nl80211 HT mode is taken when we join a non-HT ibss (then we "convert" it into
> one).
> If we see (from a beacon) that the IBSS has a different HT mode, we switch
> (first beacon wins, as we all have the same TSF).
>
>
> I tested this with the following scenario (using wireshark to confirm):
> * opening a IBSS with a Realtek under Windows
> * join with an ath9k station A without HT
>    ->  both stations joined, no HT beacons
> * join a 2nd ath9k station B in HT40+
>    ->  station B sending HT beacons. Interpreted by A, ignored by windows
> * A is switching to HT mode
>    ->  HT communication between A and B up and running. 11g with windows.
>
> Todo:
> * When switching HT mode, check if we are allow to do that.
>
> Signed-off-by: Alexander Simon<alexander.simon@saxnet.de>
> ---
>   agg-rx.c      |    2
>   agg-tx.c      |    5 +-
>   ht.c          |    2
>   ibss.c        |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
>   ieee80211_i.h |    2
>   rx.c          |    6 +-
>   6 files changed, 120 insertions(+), 19 deletions(-)
>
> diff -Nrup a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> --- a/net/mac80211/ibss.c	2011-06-01 21:04:24.000000000 +0200
> +++ b/net/mac80211/ibss.c	2011-06-21 13:21:38.000000000 +0200
> @@ -310,11 +334,65 @@ static void ieee80211_rx_bss_info(struct
>   			} else
>   				sta = ieee80211_ibss_add_sta(sdata, mgmt->bssid,
>   						mgmt->sa, supp_rates,
> -						GFP_ATOMIC);
> +						elems->ht_cap_elem, GFP_ATOMIC);
>   		}
>
> -		if (sta&&  elems->wmm_info)
> -			set_sta_flags(sta, WLAN_STA_WME);
> +		if (sta) {
> +			if (elems->wmm_info)
> +				set_sta_flags(sta, WLAN_STA_WME);
> +
> +			if (elems->ht_info_elem) {
> +				struct ieee80211_supported_band *sband =
> +					local->hw.wiphy->bands[channel->band];
> +				enum nl80211_channel_type channel_type;
> +
> +				channel_type =
> +					ieee80211_ht_info_to_channel_type(
> +						elems->ht_info_elem);
> +				if (channel_type != local->_oper_channel_type) {
> +					struct sk_buff *skb =
> +							sdata->u.ibss.presp;
sdata->u.ibss.presp is RCU protected, you need to use rcu_dereference().

> +					struct sk_buff *nskb;
> +					u8 *ht_ie;
> +
> +					nskb = skb_copy(skb, GFP_ATOMIC);
> +					ht_ie = cfg80211_find_ie(
> +						WLAN_EID_HT_CAPABILITY,
> +						nskb->data + 24 +
> +							sizeof(mgmt->u.beacon),
> +						nskb->len - 24 -
> +							sizeof(mgmt->u.beacon));
cfg80211_find_ie returns a const u8, so the compiler generates a warning.

> @@ -896,11 +980,16 @@ int ieee80211_ibss_join(struct ieee80211
>   	struct sk_buff *skb;
>
>   	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
> -			    36 /* bitrates */ +
> -			    34 /* SSID */ +
> -			    3  /* DS params */ +
> -			    4  /* IBSS params */ +
> -			    params->ie_len);
> +			    sizeof(struct ieee80211_hdr_3addr) +
> +			    12 /* struct ieee80211_mgmt.u.beacon */ +
> +			    2 + IEEE80211_MAX_SSID_LEN /* max SSID */ +
> +			    2 + 8 /* max Supported Rates */ +
> +			    3 /* max DS params */ +
> +			    4 /* IBSS params */ +
> +			    2 + (IEEE80211_MAX_SUPP_RATES - 8)
Does not compile, missing '+'
> +			    2 + sizeof(struct ieee80211_ht_cap) +
> +			    2 + sizeof(struct ieee80211_ht_info) +
> +			    params->ie_len);
>   	if (!skb)
>   		return -ENOMEM;
>


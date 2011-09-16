Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab1IPNDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 09:03:50 -0400
Subject: Re: [RFC 5/5] mac80211: send data directly to TDLS peers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1316082334-7664-6-git-send-email-arik@wizery.com> (sfid-20110915_123146_593683_1FBA16D4)
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
	 <1316082334-7664-6-git-send-email-arik@wizery.com>
	 (sfid-20110915_123146_593683_1FBA16D4)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 15:03:49 +0200
Message-ID: <1316178229.4130.33.camel@jlt3.sipsolutions.net> (sfid-20110916_150353_573790_07F37C61)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:

> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1725,6 +1725,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  	struct sta_info *sta = NULL;
>  	u32 sta_flags = 0;
>  	struct sk_buff *tmp_skb;
> +	bool tdls_link = false;
>  
>  	if (unlikely(skb->len < ETH_HLEN)) {
>  		ret = NETDEV_TX_OK;
> @@ -1836,11 +1837,25 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
>  		break;
>  #endif
>  	case NL80211_IFTYPE_STATION:
> -		memcpy(hdr.addr1, sdata->u.mgd.bssid, ETH_ALEN);
> -		if (sdata->u.mgd.use_4addr &&
> -		    cpu_to_be16(ethertype) != sdata->control_port_protocol) {
> -			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
> +		if (local->hw.flags & IEEE80211_HW_SUPPORTS_TDLS) {
> +			rcu_read_lock();
> +			sta = sta_info_get(sdata, skb->data);
> +			tdls_link = (sta && sta->tdls_link_enabled);

Why don't you test WLAN_STA_TDLS_PEER and add the station only when the
session is set up?

That would avoid the problem here when setting up the session.

> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c
> @@ -392,8 +392,9 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
>  		}
>  		break;
>  	case cpu_to_le16(0):
> -		if (iftype != NL80211_IFTYPE_ADHOC)
> -			return -1;
> +		if (iftype != NL80211_IFTYPE_ADHOC &&
> +		    iftype != NL80211_IFTYPE_STATION)
> +				return -1;
>  		break;
>  	}
>  

It seems there needs to be a check somewhere that this packet was
received from a TDLS peer? OTOH, if somebody is spoofing it crypto will
reject it or you're vulnerable anyway...

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1KBKSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 06:18:03 -0400
Subject: Re: [PATCH 2/4] mac80211: QoS multicast frames have No Ack policy
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
In-Reply-To: <1319864732-11286-2-git-send-email-thomas@cozybit.com> (sfid-20111029_070612_354228_603C12F5)
References: <1319864732-11286-1-git-send-email-thomas@cozybit.com>
	 <1319864732-11286-2-git-send-email-thomas@cozybit.com>
	 (sfid-20111029_070612_354228_603C12F5)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 11:17:57 +0100
Message-ID: <1320229077.3950.40.camel@jlt3.sipsolutions.net> (sfid-20111102_111808_986548_5F8B8E76)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 22:05 -0700, Thomas Pedersen wrote:
> Previously QoS multicast frames had the Normal Acknowledgment QoS
> control bits set. This would cause broadcast frames to be discarded by
> peers with which we have a BA session, since their sequence number would
> fall outside the allowed range. Set No Ack QoS control bits on multicast
> QoS frames and filter these in de-aggregation code.

I'm not sure why you would attempt to deaggregate broadcast frames but I
guess mesh is a bit special.

> @@ -770,6 +771,11 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
>  	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
>  		goto dont_reorder;
>  
> +	/* not part of a BA session */
> +	if (!((ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK) ||
> +	      (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)))
> +		goto dont_reorder;

Maybe ack_policy != BA && ack_policy != NORMAl would be easier to read?

> --- a/net/mac80211/wme.c
> +++ b/net/mac80211/wme.c
> @@ -147,7 +147,8 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
>  
>  		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
>  
> -		if (unlikely(sdata->local->wifi_wme_noack_test))
> +		if (unlikely(sdata->local->wifi_wme_noack_test) ||
> +		    is_multicast_ether_addr(hdr->addr1))
>  			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;

Interestingly, this seems to have been a bug for a long time --
7.1.3.5.3 indicates this is supposed to be done.

johannes


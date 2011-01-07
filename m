Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55045 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab1AGWrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 17:47:01 -0500
Message-ID: <4D2797D2.6000002@candelatech.com>
Date: Fri, 07 Jan 2011 14:46:42 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH 1/3] ath9k: Decrease skb size to fit into
 one page.
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>	 <1294397880.3467.1.camel@jlt3.sipsolutions.net>	 <4D275CCC.90905@candelatech.com>  <20110107200913.GF21588@tux>	 <1294432018.2709.2.camel@edumazet-laptop>	 <4D2791BD.7050502@candelatech.com> <1294439171.2709.6.camel@edumazet-laptop>
In-Reply-To: <1294439171.2709.6.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2011 02:26 PM, Eric Dumazet wrote:
> Le vendredi 07 janvier 2011 à 14:20 -0800, Ben Greear a écrit :
>> On 0
>>> Using skb_copy() is wrong then, since it makes a copy (order-1
>>> allocations)
>>>
>>> It should use :
>>>    skb_alloc( actual_size_of_frame  not the 3840 thing ...)
>>>    copy(data)
>>
>> We need the extra stuff copied too I think (like skb->cb).
>>
>> If you could provide a bit more complete example code, I'll be happy
>> to test it...
>
> take a random drivers/net using copybreak ... say ... tg3.c
>
> lines 4785
>
> len = length_of_the_current_frame
> copy_skb = netdev_alloc_skb(...,  len);
> // allocates exact required size not a byte more....
> ...
> skb_copy_from_linear_data(skb, copy_skb->data, len);
> ...
> skb_put(skb, len);
> ...

That seems fine for drivers, but I'm guessing something different
would be needed in the mac80211/rx.c code:

I figure doing the fix here might be a nice quick fix,
and would help with all funky drivers.  Later, can fix the
ath9k to do the skb copying as soon as DMA is done?

/*
  * This function returns whether or not the SKB
  * was destined for RX processing or not, which,
  * if consume is true, is equivalent to whether
  * or not the skb was consumed.
  */
static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
					    struct sk_buff *skb, bool consume)
{
	struct ieee80211_local *local = rx->local;
	struct ieee80211_sub_if_data *sdata = rx->sdata;
	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
	struct ieee80211_hdr *hdr = (void *)skb->data;
	int prepares;

	rx->skb = skb;
	status->rx_flags |= IEEE80211_RX_RA_MATCH;
	prepares = prepare_for_handlers(rx, hdr);

	if (!prepares)
		return false;

	if (status->flag & RX_FLAG_MMIC_ERROR) {
		if (status->rx_flags & IEEE80211_RX_RA_MATCH)
			ieee80211_rx_michael_mic_report(hdr, rx);
		return false;
	}

	if (!consume) {
		skb = skb_copy(skb, GFP_ATOMIC);
		if (!skb) {
			if (net_ratelimit()) {
				printk("failed skb_copy, skb->len: %i\n", skb->len);
				wiphy_debug(local->hw.wiphy,
					"failed to copy skb for %s\n",
					sdata->name);
			}
			return true;
		}

		rx->skb = skb;
	}

	ieee80211_invoke_rx_handlers(rx);
	return true;
}


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


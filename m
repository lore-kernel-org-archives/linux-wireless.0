Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:42907 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab0BDI71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 03:59:27 -0500
Received: by ey-out-2122.google.com with SMTP id d26so518779eyd.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 00:59:26 -0800 (PST)
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] mac80211: Reset dynamic ps timer in Rx path.
References: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
	<1265266442-6273-2-git-send-email-vnatarajan@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 04 Feb 2010 10:59:24 +0200
In-Reply-To: <1265266442-6273-2-git-send-email-vnatarajan@atheros.com> (Vivek Natarajan's message of "Thu\, 4 Feb 2010 12\:24\:02 +0530")
Message-ID: <87pr4ljs0j.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vnatarajan@atheros.com> writes:

> If there is a continuous Rx UDP traffic with power save enabled,
> there is some loss of packets with ath9k as Atheros chipsets
> need to be awake to do Rx, unlike other vendor chipsets.

Most probably this problem is related to ath9k staying awake after
PS-Poll frame. Maybe we need to change mac80211 disable PS (but not
send nullfunc!) when sending PS-Poll frames. But that might break p54,
I don't know.

But I want to emphasise that this patch is just a workaround, it
doesn't solve the actual, hidden, problem (whatever that is). I
recommmend finding and fixing the real problem first. This patch just
hides the real problem and makes the probability for it to happen
lower.

> The current mac80211 implementation enables power save if there is
> no Tx traffic for a specific timeout. This adversely affects ath9k
> when there is a continuous Rx UDP traffic going on since it depends
> only on the tim bit in the next beacon to awake. Fix this by
> restarting the dynamic ps timer on receiving every data packet.

I don't oppose changing the dynamic powersave to also wakeup from
received unicast frames destined to the client. Not because it solves
some problems with ath9k but because it decreases latency in some use
case, naturally with the cost of increased power consumption. But I
think we can manage with that for now.

But received multicast frames powersave should not disable powersave,
otherwise on a busy network we would wakeup way too often.

> + * @IEEE80211_HW_NEEDS_RX_PS_RESET:
> + *	Hardware requires the stack to reset the dynamic PS timer
> + *	on receiving a data frame.
>   */
>  enum ieee80211_hw_flags {
>  	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
> @@ -978,6 +982,7 @@ enum ieee80211_hw_flags {
>  	IEEE80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
>  	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
>  	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
> +	IEEE80211_HW_NEEDS_RX_PS_RESET			= 1<<18,

This should be dropped. I agree with Johannes, I don't see why we need
a new hw flag.

>  ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
>  {
>  	struct ieee80211_sub_if_data *sdata = rx->sdata;
> +	struct ieee80211_local *local = rx->local;
>  	struct net_device *dev = sdata->dev;
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
>  	__le16 fc = hdr->frame_control;
> @@ -1750,6 +1751,15 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
>  	dev->stats.rx_packets++;
>  	dev->stats.rx_bytes += rx->skb->len;
>  
> +	if ((local->hw.flags & IEEE80211_HW_NEEDS_RX_PS_RESET) &&
> +	    ieee80211_is_data(hdr->frame_control) &&
> +	    !is_multicast_ether_addr(hdr->addr1)) {
> +		if (local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
> +			mod_timer(&local->dynamic_ps_timer, jiffies +
> +			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
> +		}
> +	}

What if CONF_PS is set? You need to take that into account here and
disable powersave when it's enabled.

I'm busy now and I only took a quick peek of the patch. I need to
review this in detail later today.

-- 
Kalle Valo

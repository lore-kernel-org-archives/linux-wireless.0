Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab0CLLrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 06:47:09 -0500
Subject: Re: [PATCH/RFC 3/3] mac80211_hwsim: enable user space frame
 processing
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: jouni.malinen@atheros.com, linux-wireless@vger.kernel.org
In-Reply-To: <1268368999-12734-4-git-send-email-me@bobcopeland.com>
References: <1268368999-12734-1-git-send-email-me@bobcopeland.com>
	 <1268368999-12734-4-git-send-email-me@bobcopeland.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 03:46:59 -0800
Message-ID: <1268394419.4828.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-11 at 23:43 -0500, Bob Copeland wrote:

> -static int radios = 2;
> -module_param(radios, int, 0444);
> -MODULE_PARM_DESC(radios, "Number of simulated radios");

Never mind my other comment ...

> +	txi = IEEE80211_SKB_CB(skb);
> +	response->cookie = (unsigned long) skb;
> +	response->rts_cts_rate_idx = txi->control.rts_cts_rate_idx;
> +	for (i=0; i < IEEE80211_TX_MAX_RATES; i++)
> +	{
> +		response->rates[i].idx = txi->control.rates[i].idx;
> +		response->rates[i].count = txi->control.rates[i].count;
> +		response->rates[i].flags = txi->control.rates[i].flags;

It's a debugging thing, but still .. how stable do we expect these flags
to be? I sure wouldn't think twice about changing them in mac80211.h.

> +static
> +int mac80211_hwsim_control_write(struct file *file, const char __user *buf,
> +				 size_t count, loff_t *pos)
> +{
> +	struct mac80211_hwsim_data *data;
> +	struct sk_buff *skb;
> +	struct ieee80211_rx_status rx_status;
> +
> +	data = file->private_data;
> +
> +	skb = dev_alloc_skb(count);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(skb_put(skb, count), buf, count)) {
> +		dev_kfree_skb(skb);
> +		return -EFAULT;
> +	}
> +
> +	if (data->idle || !data->started ||
> +	    !data->channel ||
> +	    !hwsim_ps_rx_ok(data, skb)) {
> +		dev_kfree_skb(skb);
> +		goto out;
> +	}
> +
> +	/* XXX: parse radiotap header to set rx status, get channel etc. */

Or maybe just use a struct here just like for read()?

> +/* This structure is returned on a read() */
> +struct mac80211_hwsim_tx_packet {
> +	__u64 cookie;
> +	struct mac80211_hwsim_tx_rate rates[MAC80211_TX_MAX_RATES];
> +	__s8 rts_cts_rate_idx;
> +	__u16 pkt_len;
> +	__u8 pkt_data[0];
> +} __attribute__((packed));

Maybe this should have some reserved fields? But then you did say the
ABI should be reworked :)

> +#ifdef __KERNEL__
> +
> +#endif /* __KERNEL__ */

?

Overall looks pretty good!

johannes


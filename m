Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41725 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab1ESP5z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 11:57:55 -0400
Subject: Re: [PATCH v4] mac80211_hwsim driver support userspace frame tx/rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Lopez <jlopex@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, j@w1.fi,
	javier@cozybit.com
In-Reply-To: <1305149577-2636-1-git-send-email-jlopex@gmail.com> (sfid-20110511_233323_840596_E9B7F988)
References: <BANLkTi=_snQBSFH-d344bjk8-aSeC9Jh5w@mail.gmail.com>
	 <1305149577-2636-1-git-send-email-jlopex@gmail.com>
	 (sfid-20110511_233323_840596_E9B7F988)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 09:00:28 -0700
Message-ID: <1305820828.8237.10.camel@jlt3.sipsolutions.net> (sfid-20110519_175758_804771_C8869B65)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for the late reply, I was travelling and had so much other stuff
to do as well. I like what you did with the pending, but have some
further comments:

> +	/* We get the flags for this transmission, wmediumd maybe
> +	   changes its behaviour depending on the flags */
> +	NLA_PUT_U32(skb, HWSIM_ATTR_FLAGS, info->flags);

I'm not sure that we want to tie wmediumd to a precise version of
mac80211? This would make the mac80211 internals ABI for wmediumd rather
than API for the drivers, which I'd like to avoid. What flags does it
actually need? I think you should translate those flags into hwsim
netlink flags.

> +	/* We get the tx control (rate and retries) info*/
> +	NLA_PUT(skb, HWSIM_ATTR_TX_INFO,
> +		     sizeof(struct ieee80211_tx_rate)*IEEE80211_TX_MAX_RATES,
> +		     info->control.rates);

The same applies here, Felix is indeed planning to change this. I know
it's a lot of code and not very efficient, but I think you should wrap
this stuff in a real netlink attribute so it has a chance of not
breaking when mac80211 APIs change.

> +	/* We create a cookie to identify this skb */
> +	NLA_PUT_U32(skb, HWSIM_ATTR_COOKIE, (unsigned long) my_skb);

This needs to be a U64 so that 64-bit systems work.

> +static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
> +				    struct sk_buff *skb)
> +{
> +	if (atomic_read(&wmediumd_pid)) {

This reminds me -- why is that thing atomic? It doesn't seem necessary
since there will be locking (rtnl) on the callbacks setting it anyway?

> @@ -571,6 +671,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && ack)
>  		txi->flags |= IEEE80211_TX_STAT_ACK;
>  	ieee80211_tx_status_irqsafe(hw, skb);
> +
>  }

spurious whitespace change

> @@ -650,7 +751,6 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
>  
>  	mac80211_hwsim_monitor_rx(hw, skb);
>  	mac80211_hwsim_tx_frame(hw, skb);
> -	dev_kfree_skb(skb);
>  }

Where are frames freed in the no-wmediumd case?
 
> @@ -966,12 +1066,9 @@ static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
>  
>  static void mac80211_hwsim_flush(struct ieee80211_hw *hw, bool drop)
>  {
> -	/*
> -	 * In this special case, there's nothing we need to
> -	 * do because hwsim does transmission synchronously.
> -	 * In the future, when it does transmissions via
> -	 * userspace, we may need to do something.
> -	 */
> +	/* Let's purge the pending queue */
> +	struct mac80211_hwsim_data *data = hw->priv;
> +	skb_queue_purge(&data->pending);
>  }

This doesn't seem right, but unless you do buffering in wmediumd you
don't really have to worry much. I guess a real implementation would
send a notification to wmediumd to flush and then wait for the queue to
become empty (with some timeout I guess).


> +	if (!_found) {
> +		printk(KERN_DEBUG "mac80211_hwsim: invalid radio ID\n");
> +		return NULL;
> +	}

I think you're generally erring a bit on the side of too much debug
printing, but since it's a debug driver I don't really care :)

> +	return data;
> +}
> +
> +static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
> +					   struct genl_info *info)
> +{
> +
> +	struct ieee80211_hdr *hdr;
> +	struct mac80211_hwsim_data *data2;
> +	struct ieee80211_tx_info *txi;
> +	struct ieee80211_tx_rate *tx_attempts;
> +	struct sk_buff __user *ret_skb;
> +	struct sk_buff *skb = NULL, *tmp;
> +
> +	int i;
> +	bool found = false;
> +
> +	struct mac_address *dst = (struct mac_address *)nla_data(
> +				   info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
> +	int flags = nla_get_u32(info->attrs[HWSIM_ATTR_FLAGS]);

Maybe I'm missing it, but I don't see where you verified that the
attributes actually exist? This might otherwise crash. Same for other
attributes too.

> +	ret_skb = (struct sk_buff __user *)
> +		  (unsigned long) nla_get_u32(info->attrs[HWSIM_ATTR_COOKIE]);

Like this one, also u64.

> +	tx_attempts = (struct ieee80211_tx_rate *)nla_data(
> +		       info->attrs[HWSIM_ATTR_TX_INFO]);

Again, translation between structs and netlink would be good so we don't
tie this to internal mac80211 APIs.

> +	if (tx_attempts == NULL)
> +		goto out;

That can never happen ... either nla_data() already crashed because the
attribute didn't exist, or tx_attempts is non-NULL. However, you need to
check nla_len().

johannes


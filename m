Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2E2GXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 02:23:53 -0400
Message-ID: <1338272630.4342.2.camel@jlt3.sipsolutions.net> (sfid-20120529_082356_919686_7725F4EC)
Subject: Re: [PATCH] mac80211: Add routine for retrieving qosnull frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Soumik Das <soumik.das@stericsson.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Prakhar Vig <prakhar.vig@stericsson.com>
Date: Tue, 29 May 2012 08:23:50 +0200
In-Reply-To: <1338026781-25853-1-git-send-email-soumik.das@stericsson.com>
References: <1338026781-25853-1-git-send-email-soumik.das@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-05-26 at 15:36 +0530, Soumik Das wrote:

>  /**
> + * ieee80211_qosnullfunc_get - retrieve a qos nullfunc template
> + * @hw: pointer obtained from ieee80211_alloc_hw().
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + *
> + * Creates a QOS Nullfunc template which can, for example, be uploaded to
> + * hardware. The template must be updated after association so that correct
> + * BSSID and address is used.
> + *
> + * Note: Caller (or hardware) is responsible for setting the
> + * &IEEE80211_FCTL_PM bit as well as Duration and Sequence Control fields.
> + * The qos ctl field is set to zero by the function. Caller must
> + * fill up proper value.
> + */
> +struct sk_buff *ieee80211_qosnullfunc_get(struct ieee80211_hw *hw,
> +					  struct ieee80211_vif *vif);

You pass the hw & the vif, only one is really needed.

I also don't understand the need to update the BSSID? If you have the
vif, then it could trivially be correct upon returning from this
function.


> +	sdata = vif_to_sdata(vif);
> +	ifmgd = &sdata->u.mgd;
> +	local = sdata->local;

You don't even use the hw pointer that was passed :-)

> +	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*nullfunc));
> +	if (!skb) {
> +		printk(KERN_DEBUG "%s: failed to allocate buffer for qos "
> +		       "nullfunc template\n", sdata->name);

Please don't print messages on allocation failures, they're already very
verbose.

> +		return NULL;
> +	}
> +	skb_reserve(skb, local->hw.extra_tx_headroom);
> +
> +	nullfunc = (struct ieee80211_hdr_3addr *) skb_put(skb,
> +							  sizeof(*nullfunc));

(void *) cast is sufficient

Shouldn't the TID be set somehow?

This routine is largely the same as the non-QoS one, maybe it would be
possible to combine them?

johannes


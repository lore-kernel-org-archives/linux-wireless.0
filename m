Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1AXLhz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 06:37:55 -0500
Subject: Re: [PATCH v2 4/6] mac80211: Save probe response data for BSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1295816579-28925-5-git-send-email-arik@wizery.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
	 <1295816579-28925-5-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 12:38:46 +0100
Message-ID: <1295869126.3639.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-23 at 23:02 +0200, Arik Nemtsov wrote:

> +static int ieee80211_set_probe_resp(struct wiphy *wiphy,
> +				    struct net_device *dev, u8 *resp,
> +				    size_t resp_len)
> +{
> +	struct ieee80211_sub_if_data *sdata;
> +	struct sk_buff *new, *old;
> +
> +	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	old = sdata->u.ap.probe_resp;
> +
> +	if (!resp || !resp_len)
> +		return -EINVAL;
> +
> +	new = dev_alloc_skb(resp_len);
> +	if (!new) {
> +		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
> +		       "response template\n", sdata->name);
> +		return -ENOMEM;

I'd remove that message -- userspace already knows, and it's the only
thing that really needs to?

> +	}
> +
> +	memcpy(skb_put(new, resp_len), resp, resp_len);
> +
> +	rcu_assign_pointer(sdata->u.ap.probe_resp, new);
> +	synchronize_rcu();
> +
> +	if (old)
> +		dev_kfree_skb(old);

Just a note -- I don't really expect you to implement this -- but I
think since the skb's CB is not used otherwise, we could easily use
call_rcu() to free it.

johannes


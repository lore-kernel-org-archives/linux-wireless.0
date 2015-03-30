Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47301 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbbC3Ot2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 10:49:28 -0400
Message-ID: <1427726965.26117.33.camel@sipsolutions.net> (sfid-20150330_164932_064382_F1D02CE3)
Subject: Re: [PATCH 1/2] mac80211: add TX fastpath
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Date: Mon, 30 Mar 2015 16:49:25 +0200
In-Reply-To: <1427726167-17802-1-git-send-email-johannes@sipsolutions.net> (sfid-20150330_163615_451006_13377F81)
References: <1427726167-17802-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20150330_163615_451006_13377F81)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-30 at 16:36 +0200, Johannes Berg wrote:

> +static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
> +				struct net_device *dev, struct sta_info *sta,
> +				struct ieee80211_fast_tx *fast_tx,
> +				struct sk_buff *skb)
> +{

> +	if (skb_shared(skb)) {
> +		struct sk_buff *tmp_skb = skb;
> +
> +		skb = skb_clone(skb, GFP_ATOMIC);
> +		kfree_skb(tmp_skb);
> +
> +		if (!skb)
> +			return true;
> +	}

I don't really like this so much, but it's not all that relevant right
now. I'll probably remove this in the future though and ask drivers to
support shared SKBs if they want to take advantage of this, or so.

Also, I'll probably add checksum offload (properly - we do allow that
now but it's broken) and LSO only to the fast-xmit path here, so that we
don't have to audit all the rest of the code ...

The TI driver got this wrong, and enables checksum unconditionally, but
then if the frame needs any sort of software handling it'll totally mess
up. That's not very likely as all keys are installed into the HW, but
still ...

> +	/* will not be crypto-handled beyond what we do here, so use false
> +	 * as the may-encrypt argument for the resize
> +	 */
> +	if (unlikely(skb_headroom(skb) < extra_head + hw_headroom &&
> +	             ieee80211_skb_resize(sdata, skb, extra_head + hw_headroom,
> +					  false))) {
> +		kfree_skb(skb);
> +		return true;
> +	}

This might actually be wrong - I think we need to check for
IEEE80211_HW_SUPPORTS_CLONED_SKBS and skb_clone_writable(ETH_HLEN) as
well, like ieee80211_skb_resize() does.

johannes



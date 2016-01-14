Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33932 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbcANMcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 07:32:21 -0500
Message-ID: <1452774738.2444.22.camel@sipsolutions.net> (sfid-20160114_133228_735250_DCB2445B)
Subject: Re: [RFC/RFT v3] mac80211: Add NEED_ALIGNED4_SKBS hw flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org
Date: Thu, 14 Jan 2016 13:32:18 +0100
In-Reply-To: <1451999161-7286-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20160105_140614_128232_306916F3)
References: <1451999161-7286-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20160105_140614_128232_306916F3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-05 at 14:06 +0100, Janusz Dziedzic wrote:

> +++ b/net/mac80211/status.c
> @@ -678,9 +678,22 @@ void ieee80211_tx_monitor(struct ieee80211_local
> *local, struct sk_buff *skb,
>  	struct sk_buff *skb2;
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>  	struct ieee80211_sub_if_data *sdata;
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb-
> >data;

Could be (void *) cast

>  	struct net_device *prev_dev = NULL;
> +	unsigned int padsize, hdrlen;
>  	int rtap_len;
>  
> +	/* Remove padding if was added */
> +	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS)) {
> +		hdrlen = ieee80211_hdrlen(hdr->frame_control);
> +		padsize = hdrlen & 3;
> +
> +		if (padsize && skb->len > hdrlen + padsize) {
> +			memmove(skb->data + padsize, skb->data,
> hdrlen);
> +			skb_pull(skb, padsize);
> +		}
> +	}

But perhaps this should just be done by the driver?

>  /* tx handlers */
>  static ieee80211_tx_result debug_noinline
> +ieee80211_tx_h_hdrlen_add(struct ieee80211_tx_data *tx)
> +{
> +	struct ieee80211_hw *hw = &tx->local->hw;
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb-
> >data;
> +
> +	tx->hdrlen = ieee80211_hdrlen(hdr->frame_control);
> +
> +	if (ieee80211_hw_check(hw, NEEDS_ALIGNED4_SKBS))
> +		tx->hdrlen += tx->hdrlen & 3;
> +
> +	return TX_CONTINUE;
> +}

Can't we do this in the same place that actually adds the padding? Even
if not, I don't think it should be a separate TX handler, most of the
tx setup is done elsewhere.

> +	/* Check if aligned skb required */
> +	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS))
> +		build.hdr_len += build.hdr_len & 3;

Pretty sure you need to increase the reserved space in the fast-xmit
struct?

> -	hdrlen = ieee80211_hdrlen(hdr->frame_control);
> +	hdrlen = tx->hdrlen;

maybe you can also do all these changes separately?

>  	pos += IEEE80211_CCMP_HDR_LEN;
> +
>  	ccmp_special_blocks(skb, pn, b_0, aad);

spurious change

johannes

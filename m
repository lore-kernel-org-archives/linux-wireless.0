Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58792 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753182AbYEAKhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 06:37:10 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: mac80211 truesize bugs
Cc: johannes@sipsolutions.net, mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080501.024320.212547875.davem@davemloft.net>
Message-Id: <E1JrW9h-0001tI-00@gondolin.me.apana.org.au> (sfid-20080501_123658_010978_5E62512E)
Date: Thu, 01 May 2008 18:36:49 +0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> wrote:
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 9ad4e36..de2e904 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -1485,6 +1485,9 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
>        rthdr = (struct ieee80211_tx_status_rtap_hdr*)
>                                skb_push(skb, sizeof(*rthdr));
> ^M
> +       /* This is safe because the buffer has been orphaned.  */
> +       skb->truesize += sizeof(*rthdr);

skb->truesize should always account the skb->head area in its
entirety so we should never need to adjust it when pushing or
pulling.  So I suggest we find the place that expanded the head
area and make the adjustment there.  Alternative we could adjust
it right after the orphan call if the expansion occurs where we
can't adjust the truesize.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

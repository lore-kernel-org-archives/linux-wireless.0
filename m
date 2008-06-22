Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:37454 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYFVOAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 10:00:25 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1079918ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 07:00:23 -0700 (PDT)
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [RFC-PATCH] mac80211: add helpers for skb manipulation
Date: Sun, 22 Jun 2008 16:18:47 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1213939944.6591.13.camel@brick>
In-Reply-To: <1213939944.6591.13.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806221618.47366.IvDoorn@gmail.com> (sfid-20080622_160030_563054_6966D817)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index ce62b16..493ce19 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -176,6 +176,40 @@ unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
>  
> +unsigned int
> +ieee80211_hdrlen_check_skb(const struct sk_buff *skb, unsigned int slack)
> +{
> +	const struct ieee80211_hdr *hdr;
> +	unsigned int hdrlen;
> +
> +	hdr = (const struct ieee80211_hdr *)skb->data;
> +	hdrlen = ieee80211_hdrlen(hdr->frame_control);

	hdrlen = ieee80211_get_hdrlen_from_skb(skb);

That way you don't need the  const struct ieee80211_hdr *hdr variable.

> +	if (skb->len < hdrlen + slack)
> +		return 0;
> +	else
> +		return hdrlen;
> +}
> +EXPORT_SYMBOL(ieee80211_hdrlen_check_skb);
> +
> +void ieee80211_skb_trim_iv_icv(struct sk_buff *skb,
> +			       unsigned int iv, unsigned int icv)
> +{
> +	struct ieee80211_hdr *hdr;
> +	unsigned int hdrlen;
> +
> +	if (icv)
> +		skb_trim(skb, skb->len - icv);
> +
> +	if (iv) {
> +		hdr = (struct ieee80211_hdr *)skb->data;
> +		hdrlen = ieee80211_hdrlen(hdr->frame_control);

		hdrlen = ieee80211_get_hdrlen_from_skb(skb);

> +		memmove(skb->data + iv, skb->data, hdrlen);
> +		skb_pull(skb, iv);
> +	}
> +}
> +
>  int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
>  {
>  	int ae = meshhdr->flags & IEEE80211S_FLAGS_AE;
> diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
> index e7b6344..39bd9c9 100644
> --- a/net/mac80211/wep.c
> +++ b/net/mac80211/wep.c
> @@ -104,22 +104,6 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
>  	return newhdr + hdrlen;
>  }
>  


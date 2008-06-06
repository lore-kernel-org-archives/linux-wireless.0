Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34551 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYFFSYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 14:24:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 4/7] mac80211: make ieee80211_get_hdrlen_from_skb return unsigned
Date: Fri, 6 Jun 2008 20:24:24 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1212774672.6340.78.camel@brick>
In-Reply-To: <1212774672.6340.78.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806062024.24681.mb@bu3sch.de> (sfid-20080606_202453_536906_F75ED043)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 June 2008 19:51:12 Harvey Harrison wrote:
> Many callers already expect it to.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/net/mac80211.h |    2 +-
>  net/mac80211/util.c    |   10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 53c3b5e..7ab4ff6 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1535,7 +1535,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
>   *
>   * @skb: the frame
>   */
> -int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
> +unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
>  
>  /**
>   * ieee80211_get_hdrlen - get header length from frame control
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index fade001..60fec1c 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -165,15 +165,15 @@ out:
>  }
>  EXPORT_SYMBOL(ieee80211_hdrlen);
>  
> -int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
> +unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
>  {
>  	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *) skb->data;
> -	int hdrlen;
> +	unsigned int hdrlen;
>  
> -	if (unlikely(skb->len < 10))
> +	if (skb->len < 10)

Why are you removing the unlikely()? This should actually be pretty unlikely.
Sane firmware will drop short packets, so the kernel won't ever see them.

>  		return 0;
> -	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
> -	if (unlikely(hdrlen > skb->len))
> +	hdrlen = ieee80211_hdrlen(hdr->frame_control);
> +	if (hdrlen > skb->len)

I think this also is unlikely, as it can only come from corrupted packets.

>  		return 0;
>  	return hdrlen;
>  }



-- 
Greetings Michael.

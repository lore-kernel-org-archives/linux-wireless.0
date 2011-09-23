Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1IWSOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 14:14:17 -0400
Subject: Re: [RFC 00/15] mac80211 uAPSD support
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYiiyW3Ai_G8vs9Ksxqy9-3bwp88HpCX_iDSSwb7UKO-Hg@mail.gmail.com> (sfid-20110923_200636_786507_3A5EDB86)
References: <20110922154726.521122680@sipsolutions.net>
	 <CAMG6FYiiyW3Ai_G8vs9Ksxqy9-3bwp88HpCX_iDSSwb7UKO-Hg@mail.gmail.com>
	 (sfid-20110923_200636_786507_3A5EDB86)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 20:14:10 +0200
Message-ID: <1316801650.4058.10.camel@jlt3.sipsolutions.net> (sfid-20110923_201420_341358_7FCF61BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks for looking.

> I think it should be like below (NL80211_ATTR_QOS_INFO and
> NL80211_ATTR_UAPSD_SUPPORTED only for backward-compatibility)

Is the change below on top of my changes? I'm not sure I understand it
completely. See inline.

> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -117,6 +117,7 @@
>  #define IEEE80211_MAX_MESH_ID_LEN	32
> 
>  #define IEEE80211_QOS_CTL_LEN		2
> +#define IEEE80211_QOS_CTL_EOSP		0x0010
>  #define IEEE80211_QOS_CTL_TID_MASK	0x000F
>  #define IEEE80211_QOS_CTL_TAG1D_MASK	0x0007

This is already in the kernel for me...?

> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 2636c01..d831c15 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -610,8 +610,6 @@ enum nl80211_commands {
>  	NL80211_CMD_SET_NOA,
>  	NL80211_CMD_SET_P2P_POWER_SAVE,
> 
> -	NL80211_ATTR_STA_WME,
> -
>  	/* add new commands above here */

How did you get the ATTR_STA_WME as part of the commands? It's not like
that in my kernel.

>  	/* used to define NL80211_CMD_MAX below */
> @@ -1216,6 +1214,10 @@ enum nl80211_attrs {
>  	NL80211_ATTR_P2P_PS_CTWINDOW,
>  	NL80211_ATTR_UAPSD,
> 
> +	NL80211_ATTR_STA_WME,
> +	NL80211_ATTR_UAPSD_SUPPORTED,	/* OBSOLETE */
> +	NL80211_ATTR_QOS_INFO,		/* OBSOLETE */

Where do you get PS_CTWINDOW? ATTR_UAPSD? I'm getting the impression
that you're using a pretty hacked up nl80211 here.

> +++ b/net/mac80211/sta_info.c
> @@ -625,7 +625,7 @@ static bool
> sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
>  	unsigned long flags;
>  	struct sk_buff *skb;
> 
> -	if (skb_queue_empty(&sta->ps_tx_buf))
> +	if (skb_queue_empty(&sta->ps_tx_buf[ac]))
>  		return false;

If that kind of change was necessary on top of my patches, they wouldn't
even compile, so what does this mean?


I'm confused.


johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab0CQQWn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 12:22:43 -0400
Subject: Re: [RFC] cfg80211: Add local-state-change-only
 auth/deauth/disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100313195335.GA2420@jm.kir.nu>
References: <20100313195335.GA2420@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 09:22:43 -0700
Message-ID: <1268842963.5989.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-03-13 at 21:53 +0200, Jouni Malinen wrote:

>  static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
>  					   const u8 *bssid, u16 stype, u16 reason,
> -					   void *cookie)
> +					   void *cookie, bool send_frame)
>  {
>  	struct ieee80211_local *local = sdata->local;
>  	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> @@ -240,7 +240,11 @@ static void ieee80211_send_deauth_disass
>  			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
>  	if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
>  		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
> -	ieee80211_tx_skb(sdata, skb);
> +
> +	if (send_frame)
> +		ieee80211_tx_skb(sdata, skb);
> +	else
> +		kfree_skb(skb);
>  }

I'm wondering now why we even bother sending events to userspace when it
itself triggered the transition?

johannes


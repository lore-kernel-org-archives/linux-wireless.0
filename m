Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1LOIUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 03:20:03 -0500
Subject: Re: [PATCHv2] mac80211: Use appropriate TID for sending BAR, ADDBA
 and DELBA frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	adrian@freebsd.org
In-Reply-To: <1323936138-11357-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111215_090257_567394_BBE36913)
References: <1323871851-4808-1-git-send-email-helmut.schaa@googlemail.com>
	 <1323936138-11357-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20111215_090257_567394_BBE36913)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 09:19:58 +0100
Message-ID: <1323937198.3337.0.camel@jlt3.sipsolutions.net> (sfid-20111215_092007_564835_0EA1A0AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-15 at 09:02 +0100, Helmut Schaa wrote:

> Changes in v2: Make ieee80211_tx_skb an inline function.

> +++ b/net/mac80211/tx.c

> @@ -2719,3 +2718,10 @@ void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
>  	ieee80211_xmit(sdata, skb);
>  	local_bh_enable();
>  }
> +
> +void inline ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
> +{
> +	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
> +	ieee80211_tx_skb_tid(sdata, skb, 7);
> +}

Err, well, you should define inlines in a header file ... This inline
statement probably made no difference at all, except for potentially
causing a prototype mismatch compiler warning :)

johannes


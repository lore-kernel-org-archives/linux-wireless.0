Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40298 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbaKSSek (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 13:34:40 -0500
Message-ID: <1416422074.9374.21.camel@sipsolutions.net> (sfid-20141119_193443_275648_BA176D64)
Subject: Re: [PATCH 2/6] mac80211: minstrel_ht: move aggregation check to
 .get_rate()
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 19:34:34 +0100
In-Reply-To: <1416094080-49220-2-git-send-email-nbd@openwrt.org>
References: <1416094080-49220-1-git-send-email-nbd@openwrt.org>
	 <1416094080-49220-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-11-16 at 00:27 +0100, Felix Fietkau wrote:

> @@ -1026,6 +1023,10 @@ minstrel_ht_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
>  	if (!msp->is_ht)
>  		return mac80211_minstrel.get_rate(priv, sta, &msp->legacy, txrc);
>  
> +	if (!(info->flags & IEEE80211_TX_CTL_AMPDU) &&
> +		mi->max_prob_rate / MCS_GROUP_RATES != MINSTREL_CCK_GROUP)
> +		minstrel_aggr_check(sta, txrc->skb);

Indentation is now broken.

johannes


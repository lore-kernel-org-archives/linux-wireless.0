Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2IGIZB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 04:25:01 -0400
Message-ID: <1347006332.4256.9.camel@jlt4.sipsolutions.net> (sfid-20120907_102508_804314_45FE15DA)
Subject: Re: [PATCHv2 1/2] mac80211: export ieee80211_send_deauth_disassoc
 for usage outside of mlme.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 10:25:32 +0200
In-Reply-To: <1346951275-32081-1-git-send-email-ordex@autistici.org> (sfid-20120906_190828_405993_603EB9FF)
References: <1346951275-32081-1-git-send-email-ordex@autistici.org>
	 (sfid-20120906_190828_405993_603EB9FF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-06 at 19:07 +0200, Antonio Quartulli wrote:

> -		if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
> -			IEEE80211_SKB_CB(skb)->flags |=
> -				IEEE80211_TX_INTFL_DONT_ENCRYPT;


> +		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
> +		    !(sdata->u.mgd.flags & IEEE80211_STA_MFP_ENABLED))
> +			IEEE80211_SKB_CB(skb)->flags |=
> +				IEEE80211_TX_INTFL_DONT_ENCRYPT;

It would seem that this should be 

	if (sdata->vif.type != NL80211_IFTYPE_STATION ||
	    !(flags & MFP_ENABLED))

?

johannes


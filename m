Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1BNKVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:21:00 -0500
Subject: Re: [PATCH 1/2] nl80211: interface update
From: Johannes Berg <johannes@sipsolutions.net>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1297252905-29739-2-git-send-email-zefir.kurtisi@neratec.com>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
	 <1297252905-29739-2-git-send-email-zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:20:58 +0100
Message-ID: <1297678858.3785.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm thinking this is [RFC] really?

> @@ -1076,6 +1078,10 @@ enum nl80211_attrs {
>  
>  	/* add attributes here, update the policy in nl80211.c */
>  
> +	NL80211_DFSEVENT_ATTR_FREQ,
> +	NL80211_DFSEVENT_ATTR_TS,
> +	NL80211_DFSEVENT_ATTR_WIDTH,

I think it would be preferable to create a new DFS_EVENT attribute (also
note that all attributse should be prefixed by NL80211_ATTR_) and then
nest data into it.

However, why is the TS/width data needed at all?

johannes


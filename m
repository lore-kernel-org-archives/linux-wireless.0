Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2FFJUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 05:20:30 -0400
Message-ID: <1338974429.4513.51.camel@jlt3.sipsolutions.net> (sfid-20120606_112035_936924_ECD78D34)
Subject: Re: [RFC 14/14] cfg80211: respect iface combinations when starting
 operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 11:20:29 +0200
In-Reply-To: <1338203942-5667-15-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-15-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:19 +0200, Michal Kazior wrote:

> diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
> index 30f20fe..2583148 100644
> --- a/net/wireless/ibss.c
> +++ b/net/wireless/ibss.c
> @@ -115,6 +115,14 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
>  #ifdef CONFIG_CFG80211_WEXT
>  	wdev->wext.ibss.channel = params->channel;
>  #endif
> +
> +	err = cfg80211_can_change_interface(rdev, wdev, wdev->iftype,
> +					    params->channel);

So here again we have the problem with IBSS -- that channel is not
guaranteed to be used.

I think we have to somehow take into account that IBSS cannot share
channel (channel context in mac80211, just the count here in the
combinations) unless its set to fixed channel (which isn't supported in
all devices)

johannes


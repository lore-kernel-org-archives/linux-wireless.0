Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab0DSOnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 10:43:51 -0400
Subject: Re: [RFC PATCHv3 2/2] cfg80211: Remove default dynamic PS timeout
 value
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1271409274-17162-3-git-send-email-juuso.oikarinen@nokia.com>
References: <1271409274-17162-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271409274-17162-3-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 16:43:49 +0200
Message-ID: <1271688229.23671.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 12:14 +0300, Juuso Oikarinen wrote:
> Now that the mac80211 is choosing dynamic ps timeouts based on the ps-qos
> network latency configuration, configure a default value of -1 as the dynamic
> ps timeout in cfg80211. This value allows the mac80211 to determine the value
> to be used.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  net/wireless/core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 6ac70c1..37d0e0a 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -705,7 +705,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
>  			wdev->ps = true;
>  		else
>  			wdev->ps = false;
> -		wdev->ps_timeout = 100;
> +		/* allow mac80211 to determine the timeout */
> +		wdev->ps_timeout = -1;
>  		if (rdev->ops->set_power_mgmt)
>  			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
>  						      wdev->ps,

Does that need some API doc updates to indicate, as part of the cfg80211
API, that -1 means some way of setting it by default?

Or actually, wouldn't it make sense to move the pm_qos logic here (into
cfg80211)?

johannes


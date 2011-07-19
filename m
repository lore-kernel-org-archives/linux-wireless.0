Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1GSKNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 06:13:33 -0400
Subject: Re: [PATCH] cfg80211: enter psm when working as p2p_cli
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1311069433-17524-1-git-send-email-eliad@wizery.com> (sfid-20110719_115658_657993_7314DA69)
References: <1311069433-17524-1-git-send-email-eliad@wizery.com>
	 (sfid-20110719_115658_657993_7314DA69)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 12:13:30 +0200
Message-ID: <1311070410.24078.4.camel@jlt3.sipsolutions.net> (sfid-20110719_121335_932047_44E93B34)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-07-19 at 12:57 +0300, Eliad Peller wrote:
> cfg80211_netdev_notifier_call() is configuring psm in case
> of NL80211_IFTYPE_STATION interface type (on NETDEV_UP).
> do the same for NL80211_IFTYPE_P2P_CLIENT interface type.

Good catch!

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  net/wireless/core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index f6b359f..41f1598 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -922,7 +922,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
>  		 * Configure power management to the driver here so that its
>  		 * correctly set also after interface type changes etc.
>  		 */
> -		if (wdev->iftype == NL80211_IFTYPE_STATION &&
> +		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
> +		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
>  		    rdev->ops->set_power_mgmt)
>  			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
>  						      wdev->ps,



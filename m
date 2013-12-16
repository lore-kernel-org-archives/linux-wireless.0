Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3LPO37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 09:29:59 -0500
Message-ID: <1387204195.2057.14.camel@jlt4.sipsolutions.net> (sfid-20131216_153004_121310_ACE0F830)
Subject: Re: [PATCH v4] cfg80211: fix dfs channel state after stopping AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 16 Dec 2013 15:29:55 +0100
In-Reply-To: <1387191346-23830-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20131216_115607_589735_28E33061)
References: <1387191346-23830-1-git-send-email-marek.puzyniak@tieto.com>
	 (sfid-20131216_115607_589735_28E33061)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-16 at 11:55 +0100, Marek Puzyniak wrote:
> In AP mode DFS channel state is changed to DFS_AVAILABLE
> after successful CAC and remains as such until a radar
> signal is detected during the In-Service Monitoring.
> When AP is stopped it is no longer monitoring current channel
> for radar signals. DFS channel state should be changed
> to DFS_USABLE when last AP interface is stopped. Starting AP
> again on that channel will start CAC instead of starting radiation.

If you keep changing your patch without any changelog (after the "---"
line!) then I have no idea what I should look at?

> +	if (rdev->num_running_ifaces == 1) {
> +		/* Last running AP iface*/

missing a space

> +		wdev_lock(wdev_iter);

This will almost certainly cause a lockdep warning since you hold the
wdev lock already.

> +		if (!netif_running(wdev_iter->netdev)) {
> +			wdev_unlock(wdev_iter);
> +			continue;
> +		}
> +
> +		if (wdev_iter->iftype == NL80211_IFTYPE_AP) {
> +			wdev_unlock(wdev_iter);
> +			return false;
> +		}
> +		wdev_unlock(wdev_iter);

I don't think checking the iftype needs the lock (this lock - maybe
rtnl) anyway?

johannes


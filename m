Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39528 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab1AaMAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 07:00:39 -0500
Received: by pwj3 with SMTP id 3so1017082pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 04:00:39 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19782.42068.326897.606824@gargle.gargle.HOWL>
Date: Mon, 31 Jan 2011 17:30:20 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC] mac80211: deauthenticate STAs before suspend
In-Reply-To: <1296468391-12268-1-git-send-email-rmanoharan@atheros.com>
References: <1296468391-12268-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
>  #ifdef CONFIG_PM
> +static int ieee80211_pre_suspend(struct wiphy *wiphy)
> +{
> +	struct ieee80211_local *local = wiphy_priv(wiphy);
> +	struct ieee80211_sub_if_data *sdata = NULL;
> +	struct ieee80211_if_managed *ifmgd = NULL;
> +	struct cfg80211_deauth_request req;
> +
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		ifmgd = &sdata->u.mgd;

Shouldn't the interface type be checked here ?

> +	.pre_suspend = ieee80211_pre_suspend,
>  	.suspend = ieee80211_suspend,
>  	.resume = ieee80211_resume,
>  	.scan = ieee80211_scan,
> diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
> index 4294fa2..944d589 100644
> --- a/net/wireless/sysfs.c
> +++ b/net/wireless/sysfs.c
> @@ -91,6 +91,12 @@ static int wiphy_suspend(struct device *dev, pm_message_t state)
>  
>  	rdev->suspend_at = get_seconds();
>  
> +	if (rdev->ops->pre_suspend) {
> +		rtnl_lock();
> +		ret = rdev->ops->pre_suspend(&rdev->wiphy);
> +		rtnl_unlock();
> +	}
> +

Why a 'pre-suspend' ? :)
Can't this be done in __ieee80211_suspend() ?

Sujith

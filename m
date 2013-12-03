Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3LCOaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 09:30:21 -0500
Message-ID: <1386081014.4393.31.camel@jlt4.sipsolutions.net> (sfid-20131203_153050_657839_B1B479BD)
Subject: Re: [PATCH] cfg80211: fix WARN_ON for re-association to the expired
 BSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Ujjal Roy <royujjal@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 03 Dec 2013 15:30:14 +0100
In-Reply-To: <1385883096-7143-1-git-send-email-royujjal@gmail.com> (sfid-20131201_083145_260096_779C94CC)
References: <1385883096-7143-1-git-send-email-royujjal@gmail.com>
	 (sfid-20131201_083145_260096_779C94CC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-12-01 at 13:01 +0530, Ujjal Roy wrote:

> +	if (!bss)
> +		save_bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
> +					    wdev->ssid, wdev->ssid_len,
> +					    WLAN_CAPABILITY_ESS,
> +					    WLAN_CAPABILITY_ESS);
>  	if (wdev->current_bss) {
>  		cfg80211_unhold_bss(wdev->current_bss);
>  		cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
> @@ -651,10 +657,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
>  
>  	if (!bss) {
>  		WARN_ON_ONCE(!wiphy_to_dev(wdev->wiphy)->ops->connect);
> -		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
> -				       wdev->ssid, wdev->ssid_len,
> -				       WLAN_CAPABILITY_ESS,
> -				       WLAN_CAPABILITY_ESS);
> +		bss = save_bss;

In an unsuccessful result case, this leaks the BSS struct. I'd prefer to
reshuffle the code a bit to not need a separate save_bss variable, but I
don't immediately see an easy way to do that.

johannes


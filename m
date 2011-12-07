Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab1LGPR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 10:17:56 -0500
Subject: Re: [PATCH] cfg80211: Fix race in bss timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1323270687-5989-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1323270687-5989-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 16:17:50 +0100
Message-ID: <1323271070.3404.40.camel@jlt3.sipsolutions.net> (sfid-20111207_161804_649111_9750A927)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-07 at 20:41 +0530, Vasanthakumar Thiagarajan wrote:

> +	spin_lock_bh(&dev->bss_lock);
> +	memcpy(bssid, bss->bssid, ETH_ALEN);
> +	spin_unlock_bh(&dev->bss_lock);

I don't think this is necessary.

>  	nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), wdev->netdev, bssid,
>  			    req_ie, req_ie_len, resp_ie, resp_ie_len,
>  			    GFP_KERNEL);
> @@ -615,40 +612,65 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
>  	wdev->wext.prev_bssid_valid = true;
>  	wireless_send_event(wdev->netdev, SIOCGIWAP, &wrqu, NULL);
>  #endif
> +
> +	return;
> +out:
> +	if (bss)
> +		cfg80211_put_bss(bss);
>  }

Doesn't that leak the reference if you return? It'll also give you an
smatch warning since the function assumes the "bss" pointer that was
passed in is not NULL, no?

> +static void cfg80211_roamed_bss(struct net_device *dev,
> +				struct cfg80211_bss *bss, const u8 *req_ie,
> +				size_t req_ie_len, const u8 *resp_ie,
> +				size_t resp_ie_len, gfp_t gfp)
>  {
>  	struct wireless_dev *wdev = dev->ieee80211_ptr;
>  	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
>  	struct cfg80211_event *ev;
>  	unsigned long flags;
>  
> -	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED);
>  
>  	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);

Why remove that warning? Also maybe do something like

	if (WARN_ON(!bss))
		return;

(before allocating memory)

Other than that, I like this patch. Much nicer than the previous one I
think.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0LNHvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 02:51:54 -0500
Subject: Re: [PATCH] nl80211: Add notification for dropped Deauth/Disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20101213220048.GA24752@jm.kir.nu>
References: <20101213220048.GA24752@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 08:51:51 +0100
Message-ID: <1292313111.3569.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-14 at 00:00 +0200, Jouni Malinen wrote:

> @@ -1539,12 +1539,30 @@ ieee80211_drop_unencrypted_mgmt(struct i
>  	if (rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP)) {
>  		if (unlikely(!ieee80211_has_protected(fc) &&
>  			     ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
> -			     rx->key))
> +			     rx->key)) {
> +			if (ieee80211_is_deauth(fc))
> +				cfg80211_send_unprot_deauth(rx->sdata->dev,
> +							    rx->skb->data,
> +							    rx->skb->len);

This is the RX path.

> +void cfg80211_send_unprot_disassoc(struct net_device *dev, const u8 *buf,
> +				   size_t len)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct wiphy *wiphy = wdev->wiphy;
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
> +
> +	wdev_lock(wdev);
> +	nl80211_send_unprot_disassoc(rdev, dev, buf, len, GFP_KERNEL);

And this uses GFP_KERNEL. Surely that can't be right?

johannes


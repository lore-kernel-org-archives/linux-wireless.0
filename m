Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933177Ab0I0QRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 12:17:25 -0400
Subject: Re: [PATCH 2/2] wireless: Use first phyX name available when
 registering phy devices.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@gmail.com
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1285603646-7710-2-git-send-email-greearb@candelatech.com>
References: <1285603646-7710-1-git-send-email-greearb@candelatech.com>
	 <1285603646-7710-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 18:17:23 +0200
Message-ID: <1285604243.4043.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 09:07 -0700, greearb@gmail.com wrote:

> @@ -346,16 +332,36 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
>  
>  	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx))) {
>  		wiphy_counter--;
> +		goto too_many_devs;
> +	}

I believe the other path can also reduce the counter again, since it's
another failure case? Not that I'm really worried about it though.

> +	/* 64k wiphy devices is enough for anyone! */
> +	for (i = 0; i < 0xFFFF; i++) {

Come to think of it, this could be "i <= wiphy_counter", since in N
devices, only N different names can be in use, so checking N+1 names
will be sufficient, right?

johannes


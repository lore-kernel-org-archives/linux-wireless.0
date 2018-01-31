Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58076 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753240AbeAaVwE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 16:52:04 -0500
Message-ID: <1517435522.2189.66.camel@sipsolutions.net> (sfid-20180131_225207_271968_3161865B)
Subject: Re: [PATCH 5/6] nl80211: Implement TX of control port frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 31 Jan 2018 22:52:02 +0100
In-Reply-To: <20180131213329.25322-6-denkenz@gmail.com> (sfid-20180131_223349_476233_D75A8C24)
References: <20180131213329.25322-1-denkenz@gmail.com>
         <20180131213329.25322-6-denkenz@gmail.com>
         (sfid-20180131_223349_476233_D75A8C24)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-31 at 15:33 -0600, Denis Kenzior wrote:
> 
> +	return rdev_tx_control_port(rdev, dev, buf, len,
> +				    dest, cpu_to_be16(proto), noencrypt);

You're passing __be16 here

> +++ b/net/wireless/rdev-ops.h
> @@ -714,6 +714,21 @@ static inline int rdev_mgmt_tx(struct cfg80211_registered_device *rdev,
>  	return ret;
>  }
>  
> +static inline int rdev_tx_control_port(struct cfg80211_registered_device *rdev,
> +				       struct net_device *dev,
> +				       const void *buf, size_t len,
> +				       const u8 *dest, u16 proto,
> +				       const bool noencrypt)

but have u16 here - doesn't that make sparse unhappy?

Should also declare the API as __be16.

johannes

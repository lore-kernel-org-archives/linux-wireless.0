Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2AaFkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 00:40:13 -0500
Message-ID: <4F277E8D.5040809@sipsolutions.net> (sfid-20120131_064044_354396_3E221020)
Date: Mon, 30 Jan 2012 21:39:25 -0800
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Victor Goldenshtein <victorg@ti.com>
CC: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name
Subject: Re: [RFC 1/9] nl80211/cfg80211: add radar detection command/event
References: <1327581484-22047-1-git-send-email-victorg@ti.com> <1327581484-22047-2-git-send-email-victorg@ti.com>
In-Reply-To: <1327581484-22047-2-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/26/2012 4:37 AM, Victor Goldenshtein wrote:

> + * @NL80211_CMD_DFS_RADAR_DETECTION: Start radar detection in the
> + *	driver/HW. Once radar detected usermode notified with this event.

Why DFS & radar detection? I mean, why not just call it CMD_RADAR_DETECT 
or so?

> + *
> + * @dfs_start_radar_detection: Start radar detection in the driver.

ditto here

> @@ -3216,6 +3221,17 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
>   			      gfp_t gfp);
>
>   /**
> + * cfg80211_radar_detected_notify - radar detection event

The _notify suffix seems useless, maybe remove it?

> + * @dev: network device
> + * @freq: radar detected on this channel frequency

unit?

> +static int nl80211_dfs_start_radar_detection(struct sk_buff *skb,
> +					     struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct net_device *dev = info->user_ptr[1];
> +
> +	ASSERT_RDEV_LOCK(rdev);

That assert isn't really worth much here.


How do you *end* radar detection? What channel does it apply to? Any 
channel you're on? The channel you were on when it was enabled?

johannes

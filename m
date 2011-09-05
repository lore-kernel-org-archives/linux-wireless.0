Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1IEMIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 08:08:14 -0400
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315224151-16552-4-git-send-email-VictorG@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Sep 2011 14:08:10 +0200
Message-ID: <1315224490.4075.9.camel@jlt3.sipsolutions.net> (sfid-20110905_140816_167590_8E9C3F33)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-05 at 15:02 +0300, Victor Goldenshtein wrote:

> +void nl80211_send_intermediate_result(struct cfg80211_registered_device *rdev,
> +				      struct net_device *netdev,
> +				      struct cfg80211_event *ev)
> +{
> +	struct sk_buff *msg;
> +
> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg)
> +		return;
> +
> +	if (nl80211_send_intermediate_msg(msg, rdev, netdev, 0, 0, 0, ev,
> +				   NL80211_CMD_IM_SCAN_RESULT) < 0) {
> +		nlmsg_free(msg);
> +		return;
> +	}
> +
> +	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
> +				nl80211_scan_mcgrp.id, GFP_KERNEL);
> +}

This will generate LOTS of messages. Maybe it'd be worthwhile to not
multicast them but unicast them to the socket that requested the scan?

johannes


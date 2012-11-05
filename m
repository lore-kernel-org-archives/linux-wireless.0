Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab2KEOcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 09:32:48 -0500
Message-ID: <1352126003.9466.13.camel@jlt4.sipsolutions.net> (sfid-20121105_153302_476298_5CE1D261)
Subject: Re: [PATCH v2] [nl,cfg,mac]80211: Add nl80211 command to get mesh
 network statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Date: Mon, 05 Nov 2012 15:33:23 +0100
In-Reply-To: <1351735073-12011-1-git-send-email-ashok@cozybit.com> (sfid-20121101_025812_920021_5A18A159)
References: <1351735073-12011-1-git-send-email-ashok@cozybit.com>
	 (sfid-20121101_025812_920021_5A18A159)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> @@ -1281,6 +1286,9 @@ enum nl80211_commands {
>   *
>   * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
>   *
> + * @NL80211_CMD_GET_MESH_STATS: Get mesh networking statistics for the
> + *	interface identified by %NL80211_ATTR_IFINDEX

Hmm, what happened here? Should have attribute documentation.



> +	err = rdev->ops->get_mesh_stats(&rdev->wiphy, dev, &cur_stats);

Now that we have tracing for cfg80211 calls, could you please add that
here as well?

> +	wdev_unlock(wdev);

I don't see a need for the wdev lock, this protects data inside struct
wireless_dev so shouldn't be necessary?

> @@ -7275,6 +7338,14 @@ static struct genl_ops nl80211_ops[] = {
>  		.flags = GENL_ADMIN_PERM,
>  	},
>  	{
> +		.cmd = NL80211_CMD_GET_MESH_STATS,
> +		.doit = nl80211_get_mesh_stats,
> +		.policy = nl80211_policy,
> +		/* can be retrieved by unprivileged users */
> +		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
> +				  NL80211_FLAG_NEED_RTNL,
> +	},

There should probably be advertising that this command is supported, see
send_wiphy's CMD() macro.

johannes


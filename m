Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaAPNQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 08:16:04 -0500
Message-ID: <1389878160.4345.3.camel@jlt4.sipsolutions.net> (sfid-20140116_141744_330786_11E0515C)
Subject: Re: [PATCH] nl80211: Don't touch split_start when split dump is not
 used
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 Jan 2014 14:16:00 +0100
In-Reply-To: <1389877607-3162-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20140116_140701_812750_DB719CBA)
References: <1389877607-3162-1-git-send-email-pontus.fuchs@gmail.com>
	 (sfid-20140116_140701_812750_DB719CBA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-16 at 14:06 +0100, Pontus Fuchs wrote:
> When the netlink skb is exhausted split_start is left set. In the
> subsequent retry, with a larger buffer, the dump is continued from the
> failing point instead of from the beginning.

> +static void split_start_inc(struct nl80211_dump_wiphy_state *state)
> +{
> +	if (state->split)
> +		state->split_start++;
> +}

Wouldn't it be easier to just reset it in this case?

johannes


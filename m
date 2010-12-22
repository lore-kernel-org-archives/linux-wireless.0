Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0LVODk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:03:40 -0500
Subject: Re: [PATCH 2/2] cfg80211: pass DFS region to drivers through
 reg_notifier()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, kathy.giori@atheros.com,
	amod.bodas@atheros.com, david.quan@atheros.com,
	michael.green@atheros.com, linux-wireless@vger.kernel.org
In-Reply-To: <1292864555-28661-4-git-send-email-lrodriguez@atheros.com>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
	 <1292864555-28661-4-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 15:03:37 +0100
Message-ID: <1293026617.3531.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-20 at 12:02 -0500, Luis R. Rodriguez wrote:

> +	u8 dfs_region;

u8, when the real value is a u16?

> +	last_request->dfs_region = (cfg80211_regdomain->flags &
> +				    NL80211_CFLAG_ALL_DFS_FLAGS);

Also -- "regions", not "region" since it's still a bitmask of values. If
you think it should be a single region, then you should have an enum
instead.

johannes


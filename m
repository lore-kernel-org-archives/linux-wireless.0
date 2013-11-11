Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36235 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3KKODW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 09:03:22 -0500
Message-ID: <1384178599.14334.19.camel@jlt4.sipsolutions.net> (sfid-20131111_150325_208033_3231BBCF)
Subject: Re: [PATCH 1/3] cfg80211: DFS check dfs_region before CAC
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Mon, 11 Nov 2013 15:03:19 +0100
In-Reply-To: <1383907287-2925-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131108_114144_010591_656266BD)
References: <1383907287-2925-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131108_114144_010591_656266BD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-11-08 at 11:41 +0100, Janusz Dziedzic wrote:

> +	rcu_read_lock();
> +	regdom = rcu_dereference(cfg80211_regdomain);
> +	dfs_region = regdom->dfs_region;
> +	rcu_read_unlock();

Isn't all of this valid to dereference under RTNL anyway? See
get_cfg80211_regdom()

johannes


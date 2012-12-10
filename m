Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2LJREv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 12:04:51 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Ti6mg-0006o2-6t
	for linux-wireless@vger.kernel.org; Mon, 10 Dec 2012 18:04:50 +0100
Message-ID: <1355159114.8083.0.camel@jlt4.sipsolutions.net> (sfid-20121210_180455_428993_9EB7E18A)
Subject: Re: [PATCH 22/24] regulatory: use RCU to protect global and wiphy
 regdomains
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 18:05:14 +0100
In-Reply-To: <1354812468-15709-23-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174905_966334_CC7ACD45)
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
	 <1354812468-15709-23-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121206_174905_966334_CC7ACD45)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-06 at 17:47 +0100, Johannes Berg wrote:

> -	if (nla_put_string(msg, NL80211_ATTR_REG_ALPHA2,
> -			   cfg80211_regdomain->alpha2) ||
> -	    (cfg80211_regdomain->dfs_region &&
> -	     nla_put_u8(msg, NL80211_ATTR_DFS_REGION,
> -			cfg80211_regdomain->dfs_region)))
> -		goto nla_put_failure;
> +	rcu_read_lock();
> +	regdom = rcu_dereference(cfg80211_regdomain);
> +
> +	if (nla_put_string(msg, NL80211_ATTR_REG_ALPHA2, regdom->alpha2) ||
> +	    (regdom->dfs_region &&
> +	     nla_put_u8(msg, NL80211_ATTR_DFS_REGION, regdom->dfs_region)))
> +		goto nla_put_failure_rcu;
>  
>  	if (reg_last_request_cell_base() &&

This causes a locking issue -- mutex is taken in
reg_last_request_cell_base(), so it needs to be before the
rcu_read_lock(). I fixed the version in my mac80211-next.git tree's wip
branch.

johannes


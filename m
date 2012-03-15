Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762064Ab2COSzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:55:41 -0400
Subject: Re: [RFC 2/2] mac80211:  Support getting sta_info stats via
 ethtool.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1331833159-12694-2-git-send-email-greearb@candelatech.com> (sfid-20120315_183942_222982_FD61EFBD)
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com>
	 <1331833159-12694-2-git-send-email-greearb@candelatech.com>
	 (sfid-20120315_183942_222982_FD61EFBD)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 19:55:40 +0100
Message-ID: <1331837740.3432.39.camel@jlt3.sipsolutions.net> (sfid-20120315_195547_948416_59ED5CCD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok more technical look ...


It doesn't look like NUM_STA_INFO_STATS gets used at all, or am I
missing it?

> +static int ieee80211_get_et_sset_count(struct wiphy *wiphy,
> +				       struct net_device *dev,
> +				       int sset)
> +{
> +	switch (sset) {
> +	case ETH_SS_STATS:
> +		return STA_STATS_LEN;

Are there different "s* sets" that could be used to return different
types of stats, or how does this work?

> +	mutex_lock(&sdata->local->sta_mtx);

Why not use RCU? The mutex doesn't really protect anything useful here
except for the list iteration.

> +	list_for_each_entry(sta, &sdata->local->sta_list, list) {

That's not right -- these stats are per netdev so you should only
aggregate for the netdev, no?

> +		BUG_ON(i != STA_STATS_LEN);

That I really don't like much.

johannes


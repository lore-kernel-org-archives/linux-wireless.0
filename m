Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab2DRBiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 21:38:24 -0400
Message-ID: <1334713070.3725.14.camel@jlt3.sipsolutions.net> (sfid-20120418_033827_852475_85CFABFF)
Subject: Re: [PATCH v2 2/6] mac80211: Support getting sta_info stats via
 ethtool.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2012 18:37:50 -0700
In-Reply-To: <1334684807-14026-3-git-send-email-greearb@candelatech.com> (sfid-20120417_194716_243783_5644375D)
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>
	 <1334684807-14026-3-git-send-email-greearb@candelatech.com>
	 (sfid-20120417_194716_243783_5644375D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-17 at 10:46 -0700, greearb@candelatech.com wrote:

> +static void ieee80211_get_et_stats(struct wiphy *wiphy,
> +				   struct net_device *dev,
> +				   struct ethtool_stats *stats,
> +				   u64 *data)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct sta_info *sta;
> +	struct ieee80211_local *local = sdata->local;
> +
> +	memset(data, 0, sizeof(u64) * STA_STATS_LEN);
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(sta, &local->sta_list, list) {

This doesn't seem right -- shouldn't it look up the BSSID or something
and only work on managed interfaces? What if there really are two
stations on this interface -- then it'll just overwrite it and return a
random station's data? That's useless.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57979 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2GHJ4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 05:56:32 -0400
Message-ID: <1341741386.4987.5.camel@jlt3.sipsolutions.net> (sfid-20120708_115702_704512_7B0E1D85)
Subject: Re: [PATCH] nl/cfg/mac80211: add set_mcast_rate API
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Jul 2012 11:56:26 +0200
In-Reply-To: <1341739885-15385-1-git-send-email-ordex@autistici.org>
References: <1341739885-15385-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-07-08 at 11:31 +0200, Antonio Quartulli wrote:

> +int cfg80211_set_mcast_rate(struct cfg80211_registered_device *rdev,
> +			    struct net_device *dev,
> +			    struct cfg80211_ibss_params *params)

I'd say just inline the function into the nl80211.c handler itself, not
much value in having it separate.


> +	mcast_attr = nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE]);
> +	if (info->attrs[NL80211_ATTR_MCAST_RATE] &&

this is wrong

johannes


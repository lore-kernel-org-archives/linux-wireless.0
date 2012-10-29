Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab2J2JOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 05:14:36 -0400
Message-ID: <1351502110.10925.10.camel@jlt4.sipsolutions.net> (sfid-20121029_101440_744356_4BCE417A)
Subject: Re: [PATCHv3 2/2] mac80211: implement set_mcast_rate() callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 29 Oct 2012 10:15:10 +0100
In-Reply-To: <1351267055-21927-2-git-send-email-ordex@autistici.org>
References: <1351267055-21927-1-git-send-email-ordex@autistici.org>
	 <1351267055-21927-2-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-26 at 17:57 +0200, Antonio Quartulli wrote:
> The callback can be used with vif configured as
> ADHOC or MESH_POINT only.

You said the same in the cfg80211 patch, so

> +int ieee80211_mcast_rate(struct ieee80211_sub_if_data *sdata,
> +			 int rate[IEEE80211_NUM_BANDS])
> +{
> +	if (sdata->vif.type != NL80211_IFTYPE_ADHOC &&
> +	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
> +		return -EOPNOTSUPP;

should that check be in cfg80211?

OTOH, it seems it might be valid in AP mode as well?

johannes


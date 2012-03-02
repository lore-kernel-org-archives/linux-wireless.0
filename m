Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab2CBXSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 18:18:42 -0500
Subject: Re: [PATCH 3/3] mac80211: fix mesh airtime link metric estimating
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
In-Reply-To: <1330729524-1010-3-git-send-email-thomas@cozybit.com> (sfid-20120303_000604_467410_A1483369)
References: <1330729524-1010-1-git-send-email-thomas@cozybit.com>
	 <1330729524-1010-3-git-send-email-thomas@cozybit.com>
	 (sfid-20120303_000604_467410_A1483369)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Mar 2012 00:18:36 +0100
Message-ID: <1330730316.3865.0.camel@jlt3.sipsolutions.net> (sfid-20120303_001850_594943_BBE98E17)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-02 at 15:05 -0800, Thomas Pedersen wrote:
> Airtime link metric estimation was broken in HT mesh, use
> cfg80211_calculate_bitrate to get the right rate value.

> -	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
> +	sta_set_sinfo(sta, &sinfo);
> +	rate = cfg80211_calculate_bitrate(&sinfo.txrate);
> +	if (WARN_ON(!rate))
>  		return MAX_METRIC;

Patch 1 should be rolled into this, but I don't like it -- you fill a
lot of info you don't need, I think the rate should be factored out of
sta_set_sinfo then

johannes


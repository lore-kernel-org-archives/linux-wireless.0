Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43507 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbaEVHc6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:32:58 -0400
Message-ID: <1400743968.4174.7.camel@jlt4.sipsolutions.net> (sfid-20140522_093301_575634_2C05F07E)
Subject: Re: [PATCH] cfg80211: allow RSSI compensation
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 May 2014 09:32:48 +0200
In-Reply-To: <1400397324-8153-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1400397324-8153-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-05-18 at 10:15 +0300, Emmanuel Grumbach wrote:

> -	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp,
> -				  rx_channel == channel);
> +	signal_valid = abs(rx_channel->center_freq - channel->center_freq) <=
> +		wiphy->max_adj_channel_rssi_comp;
> +	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
>  	if (!res)
>  		return NULL;

I'm getting a bit worried now that rx_channel might be NULL for some
drivers?

johannes


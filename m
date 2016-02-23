Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59039 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbcBWJjm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 04:39:42 -0500
Message-ID: <1456220379.2041.0.camel@sipsolutions.net> (sfid-20160223_103946_670047_9805BEA6)
Subject: Re: [PATCH] mac80211: minstrel_ht: set default tx aggregation
 timeout to 0
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Cc: apenwarr@gmail.com
Date: Tue, 23 Feb 2016 10:39:39 +0100
In-Reply-To: <1455821358-37534-1-git-send-email-nbd@openwrt.org>
References: <1455821358-37534-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-18 at 19:49 +0100, Felix Fietkau wrote:
> The value 5000 was put here with the addition of the timeout field to
> ieee80211_start_tx_ba_session. It was originally added in mac80211 to
> save resources for drivers like iwlwifi, which only supports a
> limited
> number of concurrent aggregation sessions.
> 
> Since iwlwifi does not use minstrel_ht and other drivers don't need
> this, 0 is a better default - especially since there have been
> recent reports of aggregation setup related issues reproduced with
> ath9k. This should improve stability without causing any adverse
> effects.
> 
Applied, thanks.

johannes

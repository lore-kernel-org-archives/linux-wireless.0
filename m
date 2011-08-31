Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42208 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab1HaMPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 08:15:51 -0400
Subject: Re: [PATCH] mac80211: retry sending failed BAR frames later
 instead of tearing down aggr
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
In-Reply-To: <1314558661-28454-1-git-send-email-nbd@openwrt.org>
References: <1314558661-28454-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 14:15:48 +0200
Message-ID: <1314792948.4161.23.camel@jlt3.sipsolutions.net> (sfid-20110831_141555_593269_D2D5495A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-08-28 at 21:11 +0200, Felix Fietkau wrote:
> Unfortunately failed BAR tx attempts happen more frequently than I
> expected, and the resulting aggregation teardowns cause performance
> issues, as the aggregation session does not always get re-established
> properly.

I find this curious. How can tons of traffic go through, but BAR frames
fail? These are unicast and should be retried a bunch...

> Instead of tearing down the entire aggr session, we can simply store the
> SSN of the last failed BAR tx attempt, wait for the first successful
> tx status event, and then send another BAR with the same SSN.

So what if it keeps failing? I think eventually we'd want to kill the
session?

johannes


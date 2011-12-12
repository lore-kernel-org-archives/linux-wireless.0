Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LLJG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 04:06:28 -0500
Subject: Re: [PATCH] cfg80211: Return beacon loss count in station
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20111209223131.71B17206F0@glenhelen.mtv.corp.google.com> (sfid-20111209_233139_912049_EC569042)
References: <20111209223131.71B17206F0@glenhelen.mtv.corp.google.com>
	 (sfid-20111209_233139_912049_EC569042)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 10:06:25 +0100
Message-ID: <1323680785.3442.9.camel@jlt3.sipsolutions.net> (sfid-20111212_100632_669387_9ADD3AE4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-09 at 11:01 -0800, Paul Stewart wrote:
> If station info contains a beacon loss count, return
> it to userspace.


> + * @NL80211_STA_INFO_BEACON_LOSS: count of times beacon loss was detected (u32)

Hmm, this is very vague. Are you sure it does what you think it does?
Some drivers like wl12xx might not trigger the beacon loss function for
every beacon, instead aggregating things. I implemented this in iwlwifi
once and it would only tell mac80211 roughly every 20 beacons about
missed ones...

This should at least be documented, but I fear it makes the value rather
useless in the general case.

johannes



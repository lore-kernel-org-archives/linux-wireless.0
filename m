Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759188Ab2FUJpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 05:45:22 -0400
Message-ID: <1340271915.4489.18.camel@jlt3.sipsolutions.net> (sfid-20120621_114525_413475_B9E6885F)
Subject: Re: [PATCH v4 1/2] nl80211/cfg80211: add scan channel times to scan
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com
Date: Thu, 21 Jun 2012 11:45:15 +0200
In-Reply-To: <1340271185-7070-1-git-send-email-victorg@ti.com>
References: <1340271185-7070-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-21 at 12:33 +0300, Victor Goldenshtein wrote:

> + * @min_ch_time: minimum time to wait on each channel for active scans
> + * @max_ch_time: maximum time to wait on each channel for active scans
> + * @min_passive_ch_time: minimum time to wait on each channel for passive scans
> + * @max_passive_ch_time: maximum time to wait on each channel for passive scans
> + *  Note: If the above channel times are not set, the default channel times
> + *  will be used. The channel times are in TUs.

That note seems to be a bit unclear.

It's also starting to dawn on me that you actually wanted cases where
you only set the minimum time? Like in wireless extensions? You're also
only ever setting the minimum time defaults if none were given, this is
in cfg80211_trigger_scan().

So maybe you need to clarify the semantics? Clearly, I haven't
understood this yet from the documentation.

Otherwise it seems to me that there should be min/max always set, even
if mac80211 only ever uses min?

johannes


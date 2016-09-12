Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57601 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756845AbcILKYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 06:24:06 -0400
Message-ID: <1473675843.29016.18.camel@sipsolutions.net> (sfid-20160912_122409_818440_3FAF766A)
Subject: Re: [PATCH v8] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Mon, 12 Sep 2016 12:24:03 +0200
In-Reply-To: <1472649972-6649-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1472649972-6649-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm. Apart from some misleading documentation, that doesn't mention
"GCD" at all, the logic seems odd.

In order to validate a new beacon interval, you're first looking up the
min GCD value of all the combinations that allow the *current*
scenario, but doing that matching without the right # of channels or
radar detect parameters? And then you're trying to match that to the
new beacon interval?

It seems to me that the logic should be something like:

If the driver specified diff_beacon_int_gcd_min, then don't do anything
in cfg80211_validate_beacon_int(), other than perhaps a minimal range
check against the minimum of all diff_beacon_int_gcd_min values for all
combinations.

Then, add a new argument to cfg80211_check_combinations() (and
cfg80211_iter_combinations()) to have the beacon intervals for each
beaconing interface, and use that in order to match if a combination
fits, inside cfg80211_iter_combinations().

That new argument could be made the GCD of all existing beaconing
interfaces (or 0 if no such exists), since that's sufficient for
checking against a new min_gcd.

johannes

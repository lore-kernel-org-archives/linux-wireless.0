Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaDYPof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:44:35 -0400
Message-ID: <1398439491.4152.13.camel@jlt4.sipsolutions.net> (sfid-20140425_174533_183476_7A1A9FE0)
Subject: Re: [PATCH] regulatory: don't rule out some valid rules
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 25 Apr 2014 17:24:51 +0200
In-Reply-To: <1397394958-6827-1-git-send-email-eliad@wizery.com> (sfid-20140413_151604_220848_6C7D5666)
References: <1397394958-6827-1-git-send-email-eliad@wizery.com>
	 (sfid-20140413_151604_220848_6C7D5666)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-04-13 at 16:15 +0300, Eliad Peller wrote:
> commit 6d87df6 ("regdb: allow 40 MHz on world roaming
> channels 12/13") in wireless-regdb did the following
> change:
> 
> -        # Channel 12 - 13. No HT40 channel fits here
> -        (2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
> +        # Channel 12 - 13.
> +        (2457 - 2482 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
> 
> in order to allow HT40+ on lower channels (such as 9).
> 
> However, the current regulatory rules verification forbids
> such rules, as 2482 - 2457 < 40.

For better or worse, this is how the rules verification was defined. I
don't like this definition either and think the whole "max bandwidth"
thing was done badly in the original implementation, but this is
userspace API.

To bust this limit would mean to change the rule interpretation quite
significantly, I don't think we can do that without more analysis on why
it's safe or won't matter for the regdb.

However, we have the NL80211_RRF_AUTO_BW flag now, which presumably
could also be somehow set for the rule here to solve this issue?

johannes


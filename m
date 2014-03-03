Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaCCNMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 08:12:34 -0500
Message-ID: <1393852350.10039.7.camel@jlt4.sipsolutions.net> (sfid-20140303_141236_994932_FAF01466)
Subject: Re: [PATCH v3] cfg80211: processing regulatory requests on netdev
 notifier
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Mar 2014 14:12:30 +0100
In-Reply-To: <1393447080-9783-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20140226_213810_729280_C247C384)
References: <1393447080-9783-1-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20140226_213810_729280_C247C384)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-26 at 12:38 -0800, Luis R. Rodriguez wrote:
> This adds a trigger to review any pending regulatory
> requests whenever an 802.11 device interface is brought
> down or up. We use this as an opportunistic trigger
> for checking the regulatory work queues as otherwise
> they they're only checked upon an initial regulatory
> request or when beacon hints are found.
> 
> This opportunistic mechanism can be used to trigger
> kicking the queues regulatory queues at any time from
> userspace without having to change the regulatory state.
> 
> A timer just waiting upon init is not that appropriate
> as when it should be triggered will depend on systems,
> a much better approach is to use and add opportunistic
> triggers. The interface coming up is typically a good
> indicator that filesystems have been mounted since
> firmware is required for some devices.

I still don't like it. You have a problem in the regulatory code and
work around it by hooking into random parts of the other code - can't
you fix it properly in the regulatory code?

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54632 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaHONDw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2014 09:03:52 -0400
Message-ID: <1408107825.15705.3.camel@jlt4.sipsolutions.net> (sfid-20140815_150355_527988_9B3EE99A)
Subject: Re: [PATCH] wireless: core: Reorder wiphy_register() notifications
 relevantly
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 15 Aug 2014 15:03:45 +0200
In-Reply-To: <1407935091-28516-1-git-send-email-tomasz.bursztyka@linux.intel.com> (sfid-20140813_150457_552550_15CAEAC1)
References: <1407935091-28516-1-git-send-email-tomasz.bursztyka@linux.intel.com>
	 (sfid-20140813_150457_552550_15CAEAC1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject should say cfg80211.

On Wed, 2014-08-13 at 16:04 +0300, Tomasz Bursztyka wrote:
> Currently it can send regulatory domain change notification before any
> NEW_WIPHY notification. Moreover, if rfill_register() fails, calling
> wiphy_unregister() will send a DEL_WIPHY though no NEW_WIPHY had been
> sent previously.
> 
> Thus reordering so it properly notifies NEW_WIPHY before any other.

This also isn't actually true - now rfkill is *after* NEW_WIPHY.

This code had a bunch of sequencing issues in the past - please look
through the history and check that this doesn't re-introduce any of
them.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58613 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbaH2LKa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 07:10:30 -0400
Message-ID: <1409310627.4577.17.camel@jlt4.sipsolutions.net> (sfid-20140829_131033_520236_3D6B89D9)
Subject: Re: [PATCH v3] cfg80211: Reorder wiphy_register/unregister()
 notifications relevantly
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Aug 2014 13:10:27 +0200
In-Reply-To: <1408440957-3870-1-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1408440957-3870-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-08-19 at 12:35 +0300, Tomasz Bursztyka wrote:

> +	cfg80211_debugfs_rdev_add(rdev);
> +	rtnl_unlock();

I'm not convinced that it's safe to drop the rtnl here, when we only
later set wiphy.registered = true.

As is, the wiphy would end up on the list, but not registered - yet in
this period it would be reachable for example for nl80211 commands in
the unregistered state. This seems wrong.

Additionally, maybe add a brief note regarding the second part of the
patch (checking registered in unregister) to the commit log?

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaH2L27 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 07:28:59 -0400
Message-ID: <540063F8.30200@linux.intel.com> (sfid-20140829_132902_651134_0787F228)
Date: Fri, 29 Aug 2014 14:28:56 +0300
From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] cfg80211: Reorder wiphy_register/unregister() notifications
 relevantly
References: <1408440957-3870-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1409310627.4577.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1409310627.4577.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>> >+	cfg80211_debugfs_rdev_add(rdev);
>> >+	rtnl_unlock();
> I'm not convinced that it's safe to drop the rtnl here, when we only
> later set wiphy.registered = true.
>
> As is, the wiphy would end up on the list, but not registered - yet in
> this period it would be reachable for example for nl80211 commands in
> the unregistered state. This seems wrong.

Ok, I counted on the fact the device is not yet advertized as being 
ready (the NEW_WIPHY below).
Will see how to avoid this early unlock.

> Additionally, maybe add a brief note regarding the second part of the
> patch (checking registered in unregister) to the commit log?

Sure.

Tomasz

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55804 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbaKZJcX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 04:32:23 -0500
Message-ID: <1416994339.2019.4.camel@sipsolutions.net> (sfid-20141126_103228_392270_59D5E1E6)
Subject: Re: [PATCH v7] nl80211: Stop scheduled scan if netlink client
 disappears
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Nov 2014 10:32:19 +0100
In-Reply-To: <1416992841-15728-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141126_100742_107746_BD7B37FA)
References: <1416992841-15728-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141126_100742_107746_BD7B37FA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-26 at 11:07 +0200, Jukka Rissanen wrote:
> An attribute NL80211_ATTR_SOCKET_OWNER can be set by the scan initiator.
> If present, the attribute will cause the scan to be stopped if the client
> dies.
> 
> Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
> ---
> Hi,
> 
> v7:
> - convert the cfg80211_sched_scan_request to __rcu pointer in order
>   to avoid races when accessing it

You totally need to revisit how to use RCU.

Just some examples:
 * don't synchronize_rcu() after assignment - what did you do that for?
 * don't use rcu_read_lock() when you already have the write lock (rtnl)
 * don't use rcu_access_pointer(), use
    - local variables
    - rcu_dereference_protected() (or rather rtnl_dereference())
    - rcu_dereference()
 * actually fix it to assign the values before rcu_assign_pointer() so
they're
   all published together ...

Also, please make that a separate patch so it isn't mixed with the
functional changes.

johannes


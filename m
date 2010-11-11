Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:57812 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0KKJ15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 04:27:57 -0500
Message-ID: <4CDBB716.7020802@kernel.org>
Date: Thu, 11 Nov 2010 10:27:50 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
References: <4CDB2488.4040802@candelatech.com> <1289437356.3748.25.camel@jlt3.sipsolutions.net>
In-Reply-To: <1289437356.3748.25.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 11/11/2010 02:02 AM, Johannes Berg wrote:
> I don't really see any deadlock here... hmm. Tejun, do you see anything
> wrong with the "locking" in workq stuff here?
> 
> Something is holding the RTNL, and a bunch of other things are trying to
> acquire it. We don't really know who's holding it and who's acquiring it
> though.
> 
>> Nov 10 14:54:33 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
...
>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
...
>> Nov 10 14:54:33 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
...
>> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6438:
>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070f78c>] netlink_dump+0x3a/0x16a
>> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6441:
>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
>> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6442:
>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
>> Nov 10 14:54:33 localhost kernel: 1 lock held by iwconfig/6443:
>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
>> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6444:
>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11

Looks like everyone is stuck trying to get hold of rtnl_mutex.
Lockdep seems enabled, isn't there a sysrq which shows all held locks?
Yeah, it's 'd'.  I don't think much can be found out by looking at the
above part.  We need to be looking at who's holding the lock.  Is the
problem reproducible?

Thank you.

-- 
tejun

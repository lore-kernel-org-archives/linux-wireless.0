Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43529 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab3FMRYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 13:24:34 -0400
Message-ID: <51BA0051.6050205@candelatech.com> (sfid-20130613_192454_989859_959C507F)
Date: Thu, 13 Jun 2013 10:24:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Question on rcu_access_pointer, rcu_assign_pointer and locking.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I'm trying to better understand some code in net/mac80211/scan.c in order
to track down some memory leaks reported by kmemleak.

My question boils down to this.  Assume we have code similar to this:

spin_lock_bh(&dev->bss_lock);
old = rcu_access_pointer(found->pub.beacon_ies);
rcu_assign_pointer(found->pub.beacon_ies, tmp->pub.beacon_ies);
if (old)
	kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
spin_unlock_bh(&dev->bss_lock);

Would it be possible to somehow leak what is assigned to found->pub.beacon_ies,
perhaps because two threads managed to go through this
code within a single RCU period?

I think that if the rcu_assign_pointer logic wasn't 'published'
before a second thread came through this logic it could cause
this leakage?

The actual code I'm curious about is in net/mac80211/scan.c, in
the cfg80211_bss_update method.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


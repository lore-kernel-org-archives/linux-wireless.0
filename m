Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59306 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab2LMRqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 12:46:25 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id qBDHkO2Q014220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 09:46:24 -0800
Message-ID: <50CA1470.4030107@candelatech.com> (sfid-20121213_184629_945929_240FAE82)
Date: Thu, 13 Dec 2012 09:46:24 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Add a new work-queue for destructing stations?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As previously posted, there can be cases where the RTNL is held for a
very long time when trying to do the:  flush_workqueue(local->workqueue);
in mac80211_do_stop because there are lots of 'slow' work-items queued up.

I'd like to work on making this faster...

My first idea is to add a second work-queue to the 'local' for high-priority
items that can be executed independently from the current local->workqueue,
and put the free_sta_rcu work() in that queue.

I'm guessing that to be safe, the do_stop() code would need to selectively
purge any work items in the local->workqueue that relate to the sdata
being destroyed, as well.  I'm not sure how possible that would be...

Any comments on this, or suggestions for a better way to do this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


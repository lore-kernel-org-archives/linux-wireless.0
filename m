Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.171.30]:40713 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752274AbYJDKbq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 06:31:46 -0400
Date: Sat, 4 Oct 2008 05:31:44 -0500
From: Robin Holt <holt@sgi.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jiri Slaby <jirislaby@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Infinite loop in sta_info_debugfs_add_work().
Message-ID: <20081004103144.GI8534@sgi.com> (sfid-20081004_123204_594601_04AC5127)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been ignoring a hang/pause on my machine running an iwl3945
adapter following a suspend/resume cycle.   I finally decided to start
hunting it down.  This started with an Ubuntu kernel update to the Ubuntu
8.04 dist.  I don't recall seeing the hangs when I was running 7.10.
It continued when I was testing the community 2.6.27-rc1-8 kernels.
KDB helped me track it to one cpu's event thread infinitely looping.

events/0 process is on cpu0 with the following stack.

_spin_unlock_irqrestore+0x10
[mac80211]sta_info_debugfs_add_work+0x82
run_workqueue+0xd4
worker_thread+0x88
kthread+0x42


I few times later, I got:
_cond_resched+0x10
[mac80211]sta_info_destroy+0x10
[mac80211]sta_info_debugfs_add_work+0xee
run_workqueue+0xd4
worker_thread+0x88
kthread+0x42

I then added some debug printk's to sta_info_debugfs_add_work().

if (debug_80211) printk (KERN_WARNING "%d: Got sta = 0x%p, stations = 0x%p\n", __LINE__, sta, sta->local->debugfs.stations); //656
                ieee80211_sta_debugfs_add(sta);
if (debug_80211) printk (KERN_WARNING "%d: Got sta = 0x%p, debugfs.dir = 0x%p\n", __LINE__, sta, sta->debugfs.dir); //658
                rate_control_add_sta_debugfs(sta);

                sta = __sta_info_unpin(sta);
if (debug_80211) printk (KERN_WARNING "%d: Got sta = 0x%p\n", __LINE__, sta); //662
                sta_info_destroy(sta);


This resulted in dmesg output of:
656: Got sta = 0xef747270, stations = 0x0
658: Got sta = 0xef747270, debugfs.dir = 0x0
662: Got sta = 0x0
656: Got sta = 0xef747270, stations = 0x0
658: Got sta = 0xef747270, debugfs.dir = 0x0
662: Got sta = 0x0
656: Got sta = 0xef747270, stations = 0x0
658: Got sta = 0xef747270, debugfs.dir = 0x0
662: Got sta = 0x0
656: Got sta = 0xef747270, stations = 0x0
658: Got sta = 0xef747270, debugfs.dir = 0x0
662: Got sta = 0x0

I made up the 0xef747270 as the battery died before I had it written
down.  The idea is correct even if the address is not.

I have no idea what this code is trying to accomplish.  I assume it is
not corrrectly handling the case where sta->local->debugfs.stations is
NULL.

Any help would be appreciated,
Robin Holt

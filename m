Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53007 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3A2Voh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 16:44:37 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r0TLiaOc023339
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2013 13:44:36 -0800
Message-ID: <510842C4.3040608@candelatech.com> (sfid-20130129_224440_836761_5DE244B3)
Date: Tue, 29 Jan 2013 13:44:36 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: WARNING: at net/mac80211/agg-tx.c:625  (3.7.5)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is in 3.7.5, plus one ath9k patch to over-ride eeprom regdomain.

Code that causes this is here...I seem to have a good test case for
this currently, so if there is any other debugging I could put here
that would be useful, let me know.

	if (WARN_ON(!tid_tx)) {
		ht_dbg(sdata, "addBA was not requested!\n");
		goto unlock;
	}


[  104.499464] ------------[ cut here ]------------
[  104.509486] WARNING: at /home/greearb/git/linux-3.7.dev.y/net/mac80211/agg-tx.c:625 ieee80211_start_tx_ba_cb+0xcb/0xd0 [mac80211]()
[  104.534083] Hardware name: To Be Filled By O.E.M.
[  104.542979] Modules linked in: xt_CT[  104.543121] Pid: 44, comm: kworker/u:1 Tainted: G         C   3.7.5+ #35
[  104.543124] Call Trace:
[  104.543132]  [<c04440dd>] warn_slowpath_common+0x6d/0xa0
[  104.543148]  [<f8baeaab>] ? ieee80211_start_tx_ba_cb+0xcb/0xd0 [mac80211]
[  104.543179]  [<f8baeaab>] ? ieee80211_start_tx_ba_cb+0xcb/0xd0 [mac80211]
[  104.543205]  [<c044412d>] warn_slowpath_null+0x1d/0x20
[  104.543216]  [<f8baeaab>] ieee80211_start_tx_ba_cb+0xcb/0xd0 [mac80211]
[  104.543243]  [<f8bb221f>] ieee80211_iface_work+0x1ff/0x300 [mac80211]
[  104.543270]  [<c0459327>] process_one_work+0x127/0x2f0
[  104.543280]  [<f8bb2020>] ? ieee80211_netdev_select_queue+0x10/0x10 [mac80211]
[  104.543306]  [<c045bea2>] worker_thread+0x102/0x380
[  104.543314]  [<c045fedc>] kthread+0x9c/0xa0
[  104.543321]  [<c045bda0>] ? manage_workers+0x2b0/0x2b0
[  104.543328]  [<c0460000>] ? kthread_stop+0x10/0x70
[  104.543336]  [<c0917177>] ret_from_kernel_thread+0x1b/0x28
[  104.543345]  [<c045fe40>] ? kthread_freezable_should_stop+0x50/0x50
[  104.543357] ---[ end trace 84f17e8f8b9c9dda ]---


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


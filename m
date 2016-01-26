Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38363 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbcAZLL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 06:11:28 -0500
Date: Tue, 26 Jan 2016 11:11:23 +0000
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: aryabinin@virtuozzo.com, johannes@sipsolutions.net,
	sgruszka@redhat.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: UBSAN: Undefined behaviour in net/mac80211/rc80211_minstrel.h:47:34
Message-ID: <20160126111123.GD5054@localhost> (sfid-20160126_121134_316312_4256BA76)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

4.5.0-rc1 with the new UBSAN checker:

[ 2624.978741] ================================================================================
[ 2624.978749] UBSAN: Undefined behaviour in net/mac80211/rc80211_minstrel.h:47:34
[ 2624.978752] signed integer overflow:
[ 2624.978754] -32768 * 1000000 cannot be represented in type 'int'
[ 2624.978759] CPU: 1 PID: 5362 Comm: kworker/u16:2 Not tainted 4.5.0-rc1 #252
[ 2624.978762] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B0A.1509130955 09/13/2015
[ 2624.978770] Workqueue: phy1 rt2800usb_work_txdone
[ 2624.978773]  0000000000000000 0000000000000000 00000000000f4240 ffff8801e5d23990
[ 2624.978778]  ffffffff81b2e7d9 0000000000000007 ffff8801e5d239c0 ffff8801e5d239a8
[ 2624.978782]  ffffffff81bcb87d ffffffff850b928c ffff8801e5d23a30 ffffffff81bcbc4d
[ 2624.978785] Call Trace:
[ 2624.978792]  [<ffffffff81b2e7d9>] dump_stack+0x45/0x6c
[ 2624.978797]  [<ffffffff81bcb87d>] ubsan_epilogue+0xd/0x40
[ 2624.978802]  [<ffffffff81bcbc4d>] handle_overflow+0xbd/0xe0
[ 2624.978807]  [<ffffffff81b4f73f>] ? number+0x35f/0x600
[ 2624.978812]  [<ffffffff81bcbc9e>] __ubsan_handle_mul_overflow+0xe/0x10
[ 2624.978819]  [<ffffffff82b0e27c>] minstrel_calc_rate_stats+0x58c/0x5f0
[ 2624.978823]  [<ffffffff82b11d18>] minstrel_ht_update_stats.isra.4+0x148/0xdd0
[ 2624.978827]  [<ffffffff82b13223>] minstrel_ht_tx_status+0x683/0x1120
[ 2624.978832]  [<ffffffff82a1e0c8>] ieee80211_tx_status+0xff8/0x2d10
[ 2624.978836]  [<ffffffff8218a11c>] rt2x00lib_txdone+0x42c/0x11a0
[ 2624.978841]  [<ffffffff812110aa>] ? update_curr+0x15a/0x400
[ 2624.978846]  [<ffffffff821a3265>] rt2800_txdone_entry+0xc5/0x1b0
[ 2624.978850]  [<ffffffff821c331f>] rt2800usb_work_txdone+0x6ff/0xbb0
[ 2624.978854]  [<ffffffff811dc3b6>] process_one_work+0x266/0xc00
[ 2624.978857]  [<ffffffff811dce56>] worker_thread+0x96/0xd40
[ 2624.978861]  [<ffffffff811dcdc0>] ? process_scheduled_works+0x70/0x70
[ 2624.978865]  [<ffffffff811e91d8>] kthread+0x108/0x180
[ 2624.978869]  [<ffffffff811e90d0>] ? kthread_create_on_node+0x210/0x210
[ 2624.978874]  [<ffffffff82b40d9f>] ret_from_fork+0x3f/0x70
[ 2624.978878]  [<ffffffff811e90d0>] ? kthread_create_on_node+0x210/0x210
[ 2624.978880] ================================================================================

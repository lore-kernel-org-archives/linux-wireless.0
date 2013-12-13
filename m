Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:38818 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3LMMeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 07:34:23 -0500
Message-ID: <1386938061.23883.37.camel@porter.coelho.fi> (sfid-20131213_133427_250115_F9A317F8)
Subject: Re: [PATCH v9 0/5] CSA Beacon Count changes
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: sw@simonwunderlich.de, yeohchunyeow@gmail.com,
	yeohchunyeow@cozybit.com
Date: Fri, 13 Dec 2013 14:34:21 +0200
In-Reply-To: <1386935675-24548-1-git-send-email-luciano.coelho@intel.com>
References: <1386935675-24548-1-git-send-email-luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-12-13 at 13:54 +0200, Luciano Coelho wrote:
> Hi,
> 
> More changes, hopefully the last ones for this series. ;)
> 
> I have hacked wpa_supplicant to support CSA in IBSS, so I could test
> it too.  I created some ma80211_hwsim testcases on top of this.  The
> tests now pass, though I get some semi-random WARNs [1] when using 3
> stations.  It seems to be a race condition and it doesn't seem to be
> related to this series, so I think we should address it separately
> (Simon, hint! ;).

Forgot the reference.  Here it is:

[1] Sporadic warning during IBSS CSA:

[   65.601056] ------------[ cut here ]------------
[   65.601057] WARNING: CPU: 0 PID: 6 at net/mac80211/ibss.c:491 ieee80211_ibss_csa_beacon+0x30f/0x320()
[   65.601058] Modules linked in:
[   65.601059] CPU: 0 PID: 6 Comm: kworker/u8:0 Tainted: G        W    3.12.0-rc1+ #76
[   65.601060] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   65.601061] Workqueue: phy2 ieee80211_iface_work
[   65.601063]  0000000000000009 ffff88000696b950 ffffffff817a035c 0000000000000000
[   65.601065]  ffff88000696b988 ffffffff810649c8 ffff880000014b00 00000000ffffffea
[   65.601066]  0000000000000000 ffff88000696ba68 ffff880005e8ca00 ffff88000696b998
[   65.601067] Call Trace:
[   65.601069]  [<ffffffff817a035c>] dump_stack+0x54/0x74
[   65.601070]  [<ffffffff810649c8>] warn_slowpath_common+0x78/0xa0
[   65.601072]  [<ffffffff81064aa5>] warn_slowpath_null+0x15/0x20
[   65.601073]  [<ffffffff8171c0cf>] ieee80211_ibss_csa_beacon+0x30f/0x320
[   65.601075]  [<ffffffff81730680>] ieee80211_channel_switch+0x620/0x870
[   65.601077]  [<ffffffff81730149>] ? ieee80211_channel_switch+0xe9/0x870
[   65.601079]  [<ffffffff81718bec>] ieee80211_ibss_process_chanswitch+0x2ec/0x340
[   65.601080]  [<ffffffff8171c9e7>] ieee80211_ibss_rx_queued_mgmt+0x477/0x8d0
[   65.601082]  [<ffffffff810d6048>] ? __lock_acquire+0x408/0x1d50
[   65.601084]  [<ffffffff8171e434>] ieee80211_iface_work+0x274/0x360
[   65.601085]  [<ffffffff81086e61>] process_one_work+0x201/0x6b0
[   65.601087]  [<ffffffff81086df6>] ? process_one_work+0x196/0x6b0
[   65.601088]  [<ffffffff81087429>] worker_thread+0x119/0x3a0
[   65.601090]  [<ffffffff81087310>] ? process_one_work+0x6b0/0x6b0
[   65.601091]  [<ffffffff8108f358>] kthread+0xe8/0xf0
[   65.601094]  [<ffffffff8108f270>] ? insert_kthread_work+0x70/0x70
[   65.601095]  [<ffffffff817b29cc>] ret_from_fork+0x7c/0xb0
[   65.601097]  [<ffffffff8108f270>] ? insert_kthread_work+0x70/0x70
[   65.601098] ---[ end trace 5ff67f51ef1f40bb ]---



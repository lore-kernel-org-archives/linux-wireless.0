Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbXF1Jik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2007 05:38:40 -0400
Subject: Re: mac80211/bcm43xx deadlock
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1182954090.4769.28.camel@johannes.berg>
References: <1182848382.3830.5.camel@johannes.berg>
	 <200706261617.45713.mb@bu3sch.de> <1182937106.4769.10.camel@johannes.berg>
	 <200706271448.58087.mb@bu3sch.de>  <1182953184.4769.24.camel@johannes.berg>
	 <1182954090.4769.28.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 20:02:18 +0200
Message-Id: <1182967338.4769.34.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-06-27 at 16:21 +0200, Johannes Berg wrote:

> I shall be trying to add lockdep support for this sort of thing, but
> until then how can we fix this? What exactly does the rtnl protect in
> ieee80211_sta_config_auth?

Hah. My hacked-up lockdep tells me that we're not allowed to flush the
workqueue under rtnl:

[  164.126015] =======================================================
[  164.126026] [ INFO: possible circular locking dependency detected ]
[  164.126037] 2.6.22-rc6 #163
[  164.126045] -------------------------------------------------------
[  164.126054] wpa_supplicant/4418 is trying to acquire lock:
[  164.126062]  (khelper){--..}, at: [<c000000000060c8c>] .flush_workqueue+0x48/0xf4
[  164.126099] 
[  164.126102] but task is already holding lock:
[  164.126111]  (rtnl_mutex){--..}, at: [<c0000000003a4784>] .mutex_lock+0x3c/0x58
[  164.126146] 
[  164.126148] which lock already depends on the new lock.
[  164.126152] 
[  164.126161] 
[  164.126163] the existing dependency chain (in reverse order) is:
[  164.126174] 
[  164.126177] -> #1 (rtnl_mutex){--..}:
[  164.126202]        [<c000000000072434>] .__lock_acquire+0xb8c/0xd68
[  164.126265]        [<c0000000000726b0>] .lock_acquire+0xa0/0xe8
[  164.126319]        [<c0000000003a44b0>] .__mutex_lock_slowpath+0x138/0x3d0
[  164.126376]        [<c0000000003a4784>] .mutex_lock+0x3c/0x58
[  164.126439]        [<c000000000327208>] .rtnl_lock+0x24/0x40
[  164.126494]        [<c000000000328fb4>] .linkwatch_event+0x20/0x70
[  164.126554]        [<c00000000005fe38>] .run_workqueue+0x114/0x22c
[  164.126608]        [<c0000000000612f8>] .worker_thread+0x11c/0x140
[  164.126657]        [<c000000000066230>] .kthread+0x84/0xd4
[  164.126708]        [<c0000000000235ec>] .kernel_thread+0x4c/0x68
[  164.126767] 
[  164.126770] -> #0 (khelper){--..}:
[  164.126797]        [<c000000000072324>] .__lock_acquire+0xa7c/0xd68
[  164.126853]        [<c0000000000726b0>] .lock_acquire+0xa0/0xe8
[  164.126903]        [<c000000000060cbc>] .flush_workqueue+0x78/0xf4
[  164.126958]        [<d00000000048d374>] .ieee80211_stop+0x1fc/0x3a4 [mac80211]
[  164.127032]        [<c00000000031b8bc>] .dev_close+0xb8/0xfc
[  164.127086]        [<c00000000031a5b0>] .dev_change_flags+0xa4/0x1b4
[  164.127135]        [<c00000000036da9c>] .devinet_ioctl+0x2bc/0x768
[  164.127186]        [<c00000000036e9dc>] .inet_ioctl+0xe4/0x138
[  164.127247]        [<c00000000030d214>] .sock_ioctl+0x2cc/0x324
[  164.127305]        [<c0000000000d7e84>] .do_ioctl+0x68/0x14c
[  164.127359]        [<c0000000000d83b8>] .vfs_ioctl+0x450/0x494
[  164.127411]        [<c0000000000d8450>] .sys_ioctl+0x54/0x94
[  164.127462]        [<c0000000000086d0>] syscall_exit+0x0/0x40
[  164.127513] 
[  164.127516] other info that might help us debug this:
[  164.127519] 
[  164.127530] 1 lock held by wpa_supplicant/4418:
[  164.127538]  #0:  (rtnl_mutex){--..}, at: [<c0000000003a4784>] .mutex_lock+0x3c/0x58
[  164.127577] 
[  164.127580] stack backtrace:
[  164.127589] Call Trace:
[  164.127600] [c000000111f933a0] [c00000000000f624] .show_stack+0x70/0x1bc (unreliable)
[  164.127631] [c000000111f93450] [c00000000000f790] .dump_stack+0x20/0x34
[  164.127655] [c000000111f934d0] [c000000000070310] .print_circular_bug_tail+0x84/0xa8
[  164.127680] [c000000111f935a0] [c000000000072324] .__lock_acquire+0xa7c/0xd68
[  164.127705] [c000000111f93690] [c0000000000726b0] .lock_acquire+0xa0/0xe8
[  164.127729] [c000000111f93750] [c000000000060cbc] .flush_workqueue+0x78/0xf4
[  164.127753] [c000000111f937f0] [d00000000048d374] .ieee80211_stop+0x1fc/0x3a4 [mac80211]
[  164.127801] [c000000111f938b0] [c00000000031b8bc] .dev_close+0xb8/0xfc
[  164.127828] [c000000111f93940] [c00000000031a5b0] .dev_change_flags+0xa4/0x1b4
[  164.127853] [c000000111f939f0] [c00000000036da9c] .devinet_ioctl+0x2bc/0x768
[  164.127878] [c000000111f93b00] [c00000000036e9dc] .inet_ioctl+0xe4/0x138
[  164.127914] [c000000111f93b80] [c00000000030d214] .sock_ioctl+0x2cc/0x324
[  164.127943] [c000000111f93c20] [c0000000000d7e84] .do_ioctl+0x68/0x14c
[  164.127972] [c000000111f93cc0] [c0000000000d83b8] .vfs_ioctl+0x450/0x494
[  164.127999] [c000000111f93d80] [c0000000000d8450] .sys_ioctl+0x54/0x94
[  164.128024] [c000000111f93e30] [c0000000000086d0] syscall_exit+0x0/0x40



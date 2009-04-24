Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:42740 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354AbZDXNgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 09:36:40 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ar9170 lockdep
Date: Fri, 24 Apr 2009 15:36:36 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <1240413675.5198.0.camel@johannes.local>
In-Reply-To: <1240413675.5198.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200904241536.37239.chunkeey@web.de> (sfid-20090424_153648_477575_200867A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 April 2009 17:21:15 Johannes Berg wrote:
> [  255.700902] =======================================================
> [  255.700907] [ INFO: possible circular locking dependency detected ]
> [  255.700911] 2.6.30-rc2-wl-21724-g42dd251-dirty #5
> [  255.700913] -------------------------------------------------------
> [  255.700917] khubd/1305 is trying to acquire lock:
> [  255.700920]  (&(&ar->tx_status_janitor)->work){+.+...}, at: [<ffffffff80259600>] wait_on_work+0x0/0x140
> [  255.700931] 
> [  255.700932] but task is already holding lock:
> [  255.700934]  (&ar->mutex){+.+...}, at: [<ffffffffa03412d8>] ar9170_op_stop+0x38/0xb0 [ar9170usb]
> [  255.700945] 
> [  255.700946] which lock already depends on the new lock.
> [  255.700947] 
> [  255.700950] the existing dependency chain (in reverse order) is:
> [  255.700953] 
> [  255.700954] -> #1 (&ar->mutex){+.+...}:
> [  255.700959]        [<ffffffff80272615>] check_prev_add+0x365/0x720
> [  255.700965]        [<ffffffff80272fce>] validate_chain+0x5fe/0x6c0
> [  255.700969]        [<ffffffff802734cf>] __lock_acquire+0x43f/0x9f0
> [  255.700974]        [<ffffffff80273b90>] lock_acquire+0x110/0x150
> [  255.700978]        [<ffffffff805c2c3b>] mutex_lock_nested+0x6b/0x3e0
> [  255.700985]        [<ffffffffa03427c9>] ar9170_tx_status_janitor+0x39/0xe0 [ar9170usb]
> [  255.700992]        [<ffffffff80258b05>] run_workqueue+0x165/0x2a0
>
> [  255.701033] 
> [  255.701034] -> #0 (&(&ar->tx_status_janitor)->work){+.+...}:
> [  255.701039]        [<ffffffff80272312>] check_prev_add+0x62/0x720
> [  255.701044]        [<ffffffff80272fce>] validate_chain+0x5fe/0x6c0
> [  255.701049]        [<ffffffff802734cf>] __lock_acquire+0x43f/0x9f0
> [  255.701053]        [<ffffffff80273b90>] lock_acquire+0x110/0x150
> [  255.701058]        [<ffffffff8025964b>] wait_on_work+0x4b/0x140
> [  255.701062]        [<ffffffff80259784>] __cancel_work_timer+0x44/0x100
> [  255.701067]        [<ffffffff8025984d>] cancel_delayed_work_sync+0xd/0x10
> [  255.701071]        [<ffffffffa03412e4>] ar9170_op_stop+0x44/0xb0 [ar9170usb]
> [  255.701298] 
that's odd that it even triggered? do you know if op_stop / janitor_work state
check code was reordered (and I need to use atomic / barriers for that?!)
if you still have the module, can you please send it to me? thanks.

> [  255.701299] other info that might help us debug this:
> [  255.701300] 
> [  255.701303] 2 locks held by khubd/1305:
> [  255.701306]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff8050e9b2>] rtnl_lock+0x12/0x20
> [  255.701315]  #1:  (&ar->mutex){+.+...}, at: [<ffffffffa03412d8>] ar9170_op_stop+0x38/0xb0 [ar9170usb]
> [  255.701326] 
> [  255.701327] stack backtrace:
> [  255.701331] Pid: 1305, comm: khubd Tainted: G        W  2.6.30-rc2-wl-21724-g42dd251-dirty #5
> [  255.701334] Call Trace:
> [  255.701340]  [<ffffffff80271cb0>] print_circular_bug_tail+0xe0/0xf0
> [  255.701346]  [<ffffffff80272312>] check_prev_add+0x62/0x720
> [  255.701351]  [<ffffffff8020e518>] ? dump_trace+0x128/0x300
> [  255.701357]  [<ffffffff80272fce>] validate_chain+0x5fe/0x6c0
> [  255.701362]  [<ffffffff802734cf>] __lock_acquire+0x43f/0x9f0
> [  255.701368]  [<ffffffff80273b90>] lock_acquire+0x110/0x150
> [  255.701373]  [<ffffffff80259600>] ? wait_on_work+0x0/0x140
> [  255.701378]  [<ffffffff8025964b>] wait_on_work+0x4b/0x140
> [  255.701383]  [<ffffffff80259600>] ? wait_on_work+0x0/0x140
> [  255.701389]  [<ffffffff8026ecaa>] ? get_lock_stats+0x2a/0x60
> [  255.701394]  [<ffffffff80270ce8>] ? mark_held_locks+0x68/0x90
> [  255.701400]  [<ffffffff805c2f1d>] ? mutex_lock_nested+0x34d/0x3e0
> [  255.701406]  [<ffffffff80271065>] ? trace_hardirqs_on_caller+0x165/0x1c0
> [  255.701412]  [<ffffffff805c2eb0>] ? mutex_lock_nested+0x2e0/0x3e0
> [  255.701420]  [<ffffffffa03412d8>] ? ar9170_op_stop+0x38/0xb0 [ar9170usb]
> [  255.701425]  [<ffffffff80259970>] ? flush_workqueue+0x0/0xc0
> [  255.701431]  [<ffffffff80259784>] __cancel_work_timer+0x44/0x100
> [  255.701436]  [<ffffffff8025984d>] cancel_delayed_work_sync+0xd/0x10
> [  255.701444]  [<ffffffffa03412e4>] ar9170_op_stop+0x44/0xb0 [ar9170usb]
> [  255.701462]  [<ffffffffa0206178>] ieee80211_stop+0x2e8/0x690 [mac80211] 

Note: not the first lock problem: however ("[PATCH] ar9170: fix hang on stop")
it was at least obvious what went wrong because the state check was right after
the mutex_lock and not before (d'oh!)

Regards,
	Chr

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:52892 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYDFKCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2008 06:02:08 -0400
Received: by el-out-1112.google.com with SMTP id v27so549777ele.17
        for <linux-wireless@vger.kernel.org>; Sun, 06 Apr 2008 03:02:07 -0700 (PDT)
Message-ID: <1925ef8a0804060302u74cb6dfey8ea8bfe98761beee@mail.gmail.com> (sfid-20080406_110215_361657_D7628490)
Date: Sun, 6 Apr 2008 14:02:07 +0400
From: "Vitja Makarov" <vitja.makarov@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: deadlock bug in IBSS mode
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

Today I was trying wireless-testing in IBSS mode.
And found this bug, I have iwl39.. built-in card and rt73usb one.
Same bug with both.

what to do:
# iwconfig wlan2 mode ad-hoc essid have-fun
# ifconfig wlan2 up

kernel log is attached. w/o mutex debug option enabled kernel hangs.

vitja.


Apr  6 13:15:43 vitja-laptop kernel: [  184.635294] phy0: HW CONFIG: freq=2412
Apr  6 13:15:46 vitja-laptop kernel: [  187.214766] phy0: HW CONFIG: freq=2412
Apr  6 13:15:46 vitja-laptop kernel: [  187.214781] wlan0_rename:
sta_find_ibss (active_ibss=0)
Apr  6 13:15:46 vitja-laptop kernel: [  187.214917]    sta_find_ibss:
selected 80:04:17:7a:00:81 current 00:00:00:00:00:00
Apr  6 13:15:46 vitja-laptop kernel: [  187.214922]    did not try to join ibss
Apr  6 13:15:48 vitja-laptop kernel: [  189.212911] wlan0_rename:
sta_find_ibss (active_ibss=0)
Apr  6 13:15:48 vitja-laptop kernel: [  189.212926]    sta_find_ibss:
selected 82:02:00:00:00:00 current 00:00:00:00:00:00
Apr  6 13:15:48 vitja-laptop kernel: [  189.212931]    did not try to join ibss
Apr  6 13:15:50 vitja-laptop kernel: [  191.214194] wlan0_rename:
sta_find_ibss (active_ibss=0)
Apr  6 13:15:50 vitja-laptop kernel: [  191.214209]    sta_find_ibss:
selected 82:02:00:00:00:00 current 00:00:00:00:00:00
Apr  6 13:15:50 vitja-laptop kernel: [  191.214214]    did not try to join ibss
Apr  6 13:15:50 vitja-laptop kernel: [  191.214218] wlan0_rename:
Trigger new scan to find an IBSS to join
Apr  6 13:15:53 vitja-laptop kernel: [  192.312380] phy0: HW CONFIG: freq=2412
Apr  6 13:15:53 vitja-laptop kernel: [  192.312395] wlan0_rename:
sta_find_ibss (active_ibss=0)
Apr  6 13:15:53 vitja-laptop kernel: [  192.312430]    sta_find_ibss:
selected 80:04:17:7a:00:81 current 00:00:00:00:00:00
Apr  6 13:15:53 vitja-laptop kernel: [  192.312435]    did not try to join ibss
Apr  6 13:15:55 vitja-laptop kernel: [  194.314701] wlan0_rename:
sta_find_ibss (active_ibss=0)
Apr  6 13:15:55 vitja-laptop kernel: [  194.314716]    sta_find_ibss:
selected 82:02:00:00:00:00 current 00:00:00:00:00:00
Apr  6 13:15:55 vitja-laptop kernel: [  194.314720]    did not try to join ibss
Apr  6 13:15:55 vitja-laptop kernel: [  194.314724] wlan0_rename:
Trigger new scan to find an IBSS to join
Apr  6 13:15:57 vitja-laptop kernel: [  196.838333] phy0: HW CONFIG: freq=2412
Apr  6 13:15:57 vitja-laptop kernel: [  196.838346] wlan0_rename:
sta_find_ibss (active_ibss=0)
Apr  6 13:15:57 vitja-laptop kernel: [  196.838377]    sta_find_ibss:
selected 80:04:17:7a:00:81 current 00:00:00:00:00:00
Apr  6 13:15:57 vitja-laptop kernel: [  196.838382]    did not try to join ibss
Apr  6 13:15:59 vitja-laptop kernel: [  198.838993] wlan0_rename:
sta_find_ibss (active_ibss=0)
Apr  6 13:15:59 vitja-laptop kernel: [  198.839006]    sta_find_ibss:
selected 82:02:00:00:00:00 current 00:00:00:00:00:00
Apr  6 13:15:59 vitja-laptop kernel: [  198.839011]    did not try to join ibss
Apr  6 13:15:59 vitja-laptop kernel: [  198.839014] wlan0_rename:
Trigger new scan to find an IBSS to join
Apr  6 13:16:02 vitja-laptop kernel: [  202.856521] phy0: HW CONFIG: freq=2412
Apr  6 13:16:02 vitja-laptop kernel: [  202.856535] wlan0_rename:
sta_find_ibss (active_ibss=0)
Apr  6 13:16:02 vitja-laptop kernel: [  202.856575]    sta_find_ibss:
selected 80:04:17:7a:00:81 current 00:00:00:00:00:00
Apr  6 13:16:02 vitja-laptop kernel: [  202.856580]    did not try to join ibss
Apr  6 13:16:02 vitja-laptop kernel: [  202.856898] wlan0_rename:
Creating new IBSS network, BSSID 02:25:b0:b1:66:66
Apr  6 13:16:02 vitja-laptop kernel: [  202.859134] phy0: HW CONFIG: freq=2412
Apr  6 13:16:02 vitja-laptop kernel: [  202.859348] wlan0_rename:
Configured IBSS beacon template
Apr  6 13:16:32 vitja-laptop kernel: [  232.882977]
Apr  6 13:16:32 vitja-laptop kernel: [  232.882980]
=======================================================
Apr  6 13:16:32 vitja-laptop kernel: [  232.883132] [ INFO: possible
circular locking dependency detected ]
Apr  6 13:16:32 vitja-laptop kernel: [  232.883212] 2.6.25-rc8-wl #1
Apr  6 13:16:32 vitja-laptop kernel: [  232.883283]
-------------------------------------------------------
Apr  6 13:16:32 vitja-laptop kernel: [  232.883363] iwl3945/2393 is
trying to acquire lock:
Apr  6 13:16:32 vitja-laptop kernel: [  232.883439]
(rtnl_mutex){--..}, at: [_end+124024549/2125697968]
ieee80211_sta_expire+0x105/0x160 [mac80211]
Apr  6 13:16:32 vitja-laptop kernel: [  232.883779]
Apr  6 13:16:32 vitja-laptop kernel: [  232.883780] but task is
already holding lock:
Apr  6 13:16:32 vitja-laptop kernel: [  232.883920]
(&ifsta->work){--..}, at: [run_workqueue+246/544]
run_workqueue+0xf6/0x220
Apr  6 13:16:32 vitja-laptop kernel: [  232.884233]
Apr  6 13:16:32 vitja-laptop kernel: [  232.884235] which lock already
depends on the new lock.
Apr  6 13:16:32 vitja-laptop kernel: [  232.884237]
Apr  6 13:16:32 vitja-laptop kernel: [  232.884443]
Apr  6 13:16:32 vitja-laptop kernel: [  232.884445] the existing
dependency chain (in reverse order) is:
Apr  6 13:16:32 vitja-laptop kernel: [  232.884589]
Apr  6 13:16:32 vitja-laptop kernel: [  232.884590] -> #2 (&ifsta->work){--..}:
Apr  6 13:16:32 vitja-laptop kernel: [  232.884890]
[__lock_acquire+3875/4128] __lock_acquire+0xf23/0x1020
Apr  6 13:16:32 vitja-laptop kernel: [  232.885399]
[run_workqueue+246/544] run_workqueue+0xf6/0x220
Apr  6 13:16:32 vitja-laptop kernel: [  232.885906]
[_end+124048800/2125697968] ieee80211_sta_work+0x0/0x680 [mac80211]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886448]
[lock_acquire+87/128] lock_acquire+0x57/0x80
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[run_workqueue+246/544] run_workqueue+0xf6/0x220
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_spin_unlock_irq+36/48] _spin_unlock_irq+0x24/0x30
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[run_workqueue+314/544] run_workqueue+0x13a/0x220
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[trace_hardirqs_on+208/336] trace_hardirqs_on+0xd0/0x150
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+0/288] worker_thread+0x0/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+0/288] worker_thread+0x0/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+191/288] worker_thread+0xbf/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+0/288] worker_thread+0x0/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[kthread+75/128] kthread+0x4b/0x80
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[child_rip+10/18] child_rip+0xa/0x12
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[restore_args+0/48] restore_args+0x0/0x30
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[kthreadd+262/400] kthreadd+0x106/0x190
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[kthread+0/128] kthread+0x0/0x80
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[child_rip+0/18] child_rip+0x0/0x12
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[<ffffffffffffffff>] 0xffffffffffffffff
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903] -> #1 ((name)){--..}:
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[__lock_acquire+3875/4128] __lock_acquire+0xf23/0x1020
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[lock_acquire+87/128] lock_acquire+0x57/0x80
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[flush_workqueue+0/144] flush_workqueue+0x0/0x90
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[flush_workqueue+68/144] flush_workqueue+0x44/0x90
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+123993930/2125697968] ieee80211_stop+0x23a/0x450 [mac80211]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[dev_deactivate+180/256] dev_deactivate+0xb4/0x100
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[dev_close+83/112] dev_close+0x53/0x70
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[dev_change_flags+146/432] dev_change_flags+0x92/0x1b0
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[devinet_ioctl+1454/1888] devinet_ioctl+0x5ae/0x760
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[sock_ioctl+207/608] sock_ioctl+0xcf/0x260
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[vfs_ioctl+47/160] vfs_ioctl+0x2f/0xa0
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[do_vfs_ioctl+116/704] do_vfs_ioctl+0x74/0x2c0
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[trace_hardirqs_on+208/336] trace_hardirqs_on+0xd0/0x150
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[sys_ioctl+145/176] sys_ioctl+0x91/0xb0
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[<ffffffffffffffff>] 0xffffffffffffffff
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903] -> #0 (rtnl_mutex){--..}:
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[print_stack_trace+113/160] print_stack_trace+0x71/0xa0
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[__lock_acquire+3394/4128] __lock_acquire+0xd42/0x1020
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124024549/2125697968] ieee80211_sta_expire+0x105/0x160
[mac80211]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[lock_acquire+87/128] lock_acquire+0x57/0x80
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124024549/2125697968] ieee80211_sta_expire+0x105/0x160
[mac80211]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[mutex_lock_nested+159/640] mutex_lock_nested+0x9f/0x280
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124024549/2125697968] ieee80211_sta_expire+0x105/0x160
[mac80211]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124048800/2125697968] ieee80211_sta_work+0x0/0x680 [mac80211]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124049560/2125697968] ieee80211_sta_work+0x2f8/0x680 [mac80211]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124048800/2125697968] ieee80211_sta_work+0x0/0x680 [mac80211]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124048800/2125697968] ieee80211_sta_work+0x0/0x680 [mac80211]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[run_workqueue+320/544] run_workqueue+0x140/0x220
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+0/288] worker_thread+0x0/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+0/288] worker_thread+0x0/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+191/288] worker_thread+0xbf/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+0/288] worker_thread+0x0/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[kthread+75/128] kthread+0x4b/0x80
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[child_rip+10/18] child_rip+0xa/0x12
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[restore_args+0/48] restore_args+0x0/0x30
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[kthreadd+262/400] kthreadd+0x106/0x190
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[kthread+0/128] kthread+0x0/0x80
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[child_rip+0/18] child_rip+0x0/0x12
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[<ffffffffffffffff>] 0xffffffffffffffff
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903] other info that
might help us debug this:
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903] 2 locks held by
iwl3945/2393:
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]  #0:
((name)){--..}, at: [run_workqueue+246/544] run_workqueue+0xf6/0x220
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]  #1:
(&ifsta->work){--..}, at: [run_workqueue+246/544]
run_workqueue+0xf6/0x220
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903] stack backtrace:
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903] Pid: 2393, comm:
iwl3945 Not tainted 2.6.25-rc8-wl #1
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903] Call Trace:
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[print_circular_bug_tail+131/144] print_circular_bug_tail+0x83/0x90
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[print_stack_trace+113/160] print_stack_trace+0x71/0xa0
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[__lock_acquire+3394/4128] __lock_acquire+0xd42/0x1020
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124024549/2125697968] :mac80211:ieee80211_sta_expire+0x105/0x160
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[lock_acquire+87/128] lock_acquire+0x57/0x80
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124024549/2125697968] :mac80211:ieee80211_sta_expire+0x105/0x160
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[mutex_lock_nested+159/640] mutex_lock_nested+0x9f/0x280
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124024549/2125697968] :mac80211:ieee80211_sta_expire+0x105/0x160
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124048800/2125697968] :mac80211:ieee80211_sta_work+0x0/0x680
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124049560/2125697968] :mac80211:ieee80211_sta_work+0x2f8/0x680
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124048800/2125697968] :mac80211:ieee80211_sta_work+0x0/0x680
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[_end+124048800/2125697968] :mac80211:ieee80211_sta_work+0x0/0x680
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[run_workqueue+320/544] run_workqueue+0x140/0x220
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+0/288] worker_thread+0x0/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+0/288] worker_thread+0x0/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+191/288] worker_thread+0xbf/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[autoremove_wake_function+0/48] autoremove_wake_function+0x0/0x30
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[worker_thread+0/288] worker_thread+0x0/0x120
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]  [kthread+75/128]
kthread+0x4b/0x80
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]  [child_rip+10/18]
child_rip+0xa/0x12
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[restore_args+0/48] restore_args+0x0/0x30
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
[kthreadd+262/400] kthreadd+0x106/0x190
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]  [kthread+0/128]
kthread+0x0/0x80
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]  [child_rip+0/18]
child_rip+0x0/0x12
Apr  6 13:16:32 vitja-laptop kernel: [  232.886903]
Apr  6 13:16:32 vitja-laptop kernel: [  232.890948] wlan0_rename: No
active IBSS STAs - trying to scan for other IBSS networks with same
SSID (merge)
Apr  6 13:16:36 vitja-laptop kernel: [  235.512235] phy0: HW CONFIG: freq=2412
Apr  6 13:16:36 vitja-laptop kernel: [  235.512320] wlan0_rename:
sta_find_ibss (active_ibss=0)
Apr  6 13:16:36 vitja-laptop kernel: [  235.512403]
bssid=02:25:b0:b1:66:66 found
Apr  6 13:16:36 vitja-laptop kernel: [  235.512499]    sta_find_ibss:
selected 02:25:b0:b1:66:66 current 02:25:b0:b1:66:66
Apr  6 13:16:36 vitja-laptop kernel: [  235.512592]    did not try to join ibss

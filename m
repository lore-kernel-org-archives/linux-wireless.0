Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37026 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab3KGFxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 00:53:50 -0500
Received: from [50.54.140.2] (50-54-140-2.evrt.wa.frontiernet.net [50.54.140.2])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id rA75rncx017127
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 6 Nov 2013 21:53:49 -0800
Message-ID: <527B2AED.1070407@candelatech.com> (sfid-20131107_065355_862937_C6689297)
Date: Wed, 06 Nov 2013 21:53:49 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Hung tasks in 3.12.0-rc5 (ath tree).
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I saw this while testing ath10k patches.  Lots of station bouncing
and ath10k firmware crashing before this, but from the traces here I'm not
sure the problem lies in ath10k itself.

Might be that ath10k is holding locks for too long while timing
out calls to firmware...perhaps.



ath10k: Failed to set erp slot for VDEV: 6
ath10k: Failed to set preamble for VDEV: 6
ath10k: Failed to set beacon interval for VDEV: 7
ath10k: Failed to set CTS prot for VDEV: 7
ath10k: Failed to set erp slot for VDEV: 7
INFO: task kworker/0:2:215 blocked for more than 180 seconds.
       Tainted: G         C   3.12.0-rc5-wl+ #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:2     D ffff88020c2ea140     0   215      2 0x00000000
Workqueue: events linkwatch_event
  ffff88020b975ca8 0000000000000046 ffff88020c2ea140 ffff88020b975fd8
  0000000000013b80 ffff88020b975fd8 ffffffff81a14490 ffff88020c2ea140
  0000000000000000 ffff88020b974000 ffff88020b974000 0000000000000246
Call Trace:
  [<ffffffff8159052e>] schedule+0x60/0x62
  [<ffffffff81590720>] schedule_preempt_disabled+0x1f/0x27
  [<ffffffff8158e595>] mutex_lock_nested+0x215/0x403
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
  [<ffffffff814eb93e>] linkwatch_event+0x9/0x27
  [<ffffffff810b42d3>] process_one_work+0x1d7/0x303
  [<ffffffff810b4269>] ? process_one_work+0x16d/0x303
  [<ffffffff810b47d2>] worker_thread+0x12e/0x1fb
  [<ffffffff810b46a4>] ? rescuer_thread+0x27b/0x27b
  [<ffffffff810b9d61>] kthread+0x9d/0xa5
  [<ffffffff815916e3>] ? _raw_spin_unlock_irq+0x29/0x54
  [<ffffffff810b9cc4>] ? __kthread_parkme+0x60/0x60
  [<ffffffff8159674c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b9cc4>] ? __kthread_parkme+0x60/0x60
3 locks held by kworker/0:2/215:
  #0:  (events){.+.+.+}, at: [<ffffffff810b4269>] process_one_work+0x16d/0x303
  #1:  ((linkwatch_work).work){+.+.+.}, at: [<ffffffff810b4269>] process_one_work+0x16d/0x303
  #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
INFO: task chronyd:795 blocked for more than 180 seconds.
       Tainted: G         C   3.12.0-rc5-wl+ #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
chronyd         D ffff880210eb2140     0   795      1 0x00000080
  ffff880034615b38 0000000000000046 ffff880210eb2140 ffff880034615fd8
  0000000000013b80 ffff880034615fd8 ffff88020c2ea140 ffff880210eb2140
  0000000000000000 ffff880034614000 ffff880034614000 0000000000000246
Call Trace:
  [<ffffffff8159052e>] schedule+0x60/0x62
  [<ffffffff81590720>] schedule_preempt_disabled+0x1f/0x27
  [<ffffffff8158e595>] mutex_lock_nested+0x215/0x403
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
  [<ffffffff814e7d24>] rtnetlink_rcv+0x11/0x28
  [<ffffffff814ff9b1>] netlink_unicast+0xb0/0x131
  [<ffffffff814fffd2>] netlink_sendmsg+0x5a0/0x5e6
  [<ffffffff814c6f30>] __sock_sendmsg_nosec+0x25/0x27
  [<ffffffff814c9599>] sock_sendmsg+0x5a/0x7b
  [<ffffffff814c72b1>] ? copy_from_user+0x2a/0x2c
  [<ffffffff814c9fb1>] ? move_addr_to_kernel+0x37/0x64
  [<ffffffff814ca0e5>] SYSC_sendto+0x107/0x136
  [<ffffffff81596829>] ? sysret_check+0x22/0x5d
  [<ffffffff810efdad>] ? trace_hardirqs_on_caller+0x145/0x1a1
  [<ffffffff810e4e66>] ? current_kernel_time+0xd/0x31
  [<ffffffff814ca58f>] SyS_sendto+0x9/0xb
  [<ffffffff815967fd>] system_call_fastpath+0x1a/0x1f
1 lock held by chronyd/795:
  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
INFO: task gnuserver:1551 blocked for more than 180 seconds.
       Tainted: G         C   3.12.0-rc5-wl+ #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
gnuserver       D ffff88020d2ec280     0  1551   1524 0x00000080
  ffff88020d285cb8 0000000000000046 ffff88020d2ec280 ffff88020d285fd8
  0000000000013b80 ffff88020d285fd8 ffff8802162b8000 ffff88020d2ec280
  0000000000000000 ffff88020d284000 ffff88020d284000 0000000000000246
Call Trace:
  [<ffffffff8159052e>] schedule+0x60/0x62
  [<ffffffff81590720>] schedule_preempt_disabled+0x1f/0x27
  [<ffffffff8158e595>] mutex_lock_nested+0x215/0x403
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff8117d294>] ? full_name_hash+0x19/0x5b
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
  [<ffffffff814ed36c>] dev_ioctl+0x4c8/0x5f0
  [<ffffffff810ef949>] ? lock_acquire+0x94/0x9d
  [<ffffffff814c75fc>] sock_do_ioctl+0x36/0x41
  [<ffffffff814c7ab8>] sock_ioctl+0x210/0x21e
  [<ffffffff81183479>] vfs_ioctl+0x21/0x34
  [<ffffffff81183d56>] do_vfs_ioctl+0x409/0x44c
  [<ffffffff810c2b50>] ? should_resched+0x9/0x28
  [<ffffffff8118bbdb>] ? fget_light+0x39/0x99
  [<ffffffff81183deb>] SyS_ioctl+0x52/0x7f
  [<ffffffff810e4e66>] ? current_kernel_time+0xd/0x31
  [<ffffffff815967fd>] system_call_fastpath+0x1a/0x1f
1 lock held by gnuserver/1551:
  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
INFO: task btserver:1558 blocked for more than 180 seconds.
       Tainted: G         C   3.12.0-rc5-wl+ #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btserver        D ffff88020e7c2140     0  1558   1377 0x00000080
  ffff8800d1fd7b38 0000000000000046 ffff88020e7c2140 ffff8800d1fd7fd8
  0000000000013b80 ffff8800d1fd7fd8 ffff8802162a2140 ffff88020e7c2140
  0000000000000000 ffff8800d1fd6000 ffff8800d1fd6000 0000000000000246
Call Trace:
  [<ffffffff8159052e>] schedule+0x60/0x62
  [<ffffffff81590720>] schedule_preempt_disabled+0x1f/0x27
  [<ffffffff8158e595>] mutex_lock_nested+0x215/0x403
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
  [<ffffffff814e7d24>] rtnetlink_rcv+0x11/0x28
  [<ffffffff814ff9b1>] netlink_unicast+0xb0/0x131
  [<ffffffff814fffd2>] netlink_sendmsg+0x5a0/0x5e6
  [<ffffffff814c6f30>] __sock_sendmsg_nosec+0x25/0x27
  [<ffffffff814c9599>] sock_sendmsg+0x5a/0x7b
  [<ffffffff814c72b1>] ? copy_from_user+0x2a/0x2c
  [<ffffffff814c9fb1>] ? move_addr_to_kernel+0x37/0x64
  [<ffffffff814ca0e5>] SYSC_sendto+0x107/0x136
  [<ffffffff810eca6d>] ? trace_hardirqs_off_caller+0x37/0xa6
  [<ffffffff81591f5c>] ? retint_swapgs+0x13/0x1b
  [<ffffffff810efdad>] ? trace_hardirqs_on_caller+0x145/0x1a1
  [<ffffffff810e4e66>] ? current_kernel_time+0xd/0x31
  [<ffffffff81144b54>] ? spin_lock+0x9/0xb
  [<ffffffff814ca58f>] SyS_sendto+0x9/0xb
  [<ffffffff815967fd>] system_call_fastpath+0x1a/0x1f
1 lock held by btserver/1558:
  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
INFO: task wpa_supplicant:2012 blocked for more than 180 seconds.
       Tainted: G         C   3.12.0-rc5-wl+ #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
wpa_supplicant  D ffff88020d2b8000     0  2012      1 0x00000080
  ffff88021205f908 0000000000000046 ffff88020d2b8000 ffff88021205ffd8
  0000000000013b80 ffff88021205ffd8 ffff8802162b8000 ffff88020d2b8000
  0000000000000000 ffff88021205e000 ffff88021205e000 0000000000000246
Call Trace:
  [<ffffffff8159052e>] schedule+0x60/0x62
  [<ffffffff81590720>] schedule_preempt_disabled+0x1f/0x27
  [<ffffffff8158e595>] mutex_lock_nested+0x215/0x403
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff810ee4c2>] ? mark_lock+0x2d/0x212
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
  [<ffffffffa024035e>] nl80211_pre_doit+0x28/0x132 [cfg80211]
  [<ffffffff81501102>] genl_family_rcv_msg+0x240/0x29d
  [<ffffffff8150119c>] genl_rcv_msg+0x3d/0x60
  [<ffffffff8150115f>] ? genl_family_rcv_msg+0x29d/0x29d
  [<ffffffff815001d3>] netlink_rcv_skb+0x3d/0x8b
  [<ffffffff815003f7>] genl_rcv+0x24/0x34
  [<ffffffff814ff9b1>] netlink_unicast+0xb0/0x131
  [<ffffffff814fffd2>] netlink_sendmsg+0x5a0/0x5e6
  [<ffffffff810eecb0>] ? __lock_acquire+0x609/0xe7e
  [<ffffffff814c6f30>] __sock_sendmsg_nosec+0x25/0x27
  [<ffffffff814c9599>] sock_sendmsg+0x5a/0x7b
  [<ffffffff810ef887>] ? lock_release+0x153/0x181
  [<ffffffff81144f83>] ? might_fault+0x9b/0xa2
  [<ffffffff81144f3a>] ? might_fault+0x52/0xa2
  [<ffffffff814d3c5d>] ? verify_iovec+0x58/0xab
  [<ffffffff814c97bb>] ___sys_sendmsg+0x201/0x28e
  [<ffffffff810ef887>] ? lock_release+0x153/0x181
  [<ffffffff811a4d6f>] ? fsnotify+0x2a2/0x2f7
  [<ffffffff811a4b4e>] ? fsnotify+0x81/0x2f7
  [<ffffffff810ef887>] ? lock_release+0x153/0x181
  [<ffffffff8118bbdb>] ? fget_light+0x39/0x99
  [<ffffffff814ca79d>] __sys_sendmsg+0x3d/0x5b
  [<ffffffff814ca7c8>] SyS_sendmsg+0xd/0x19
  [<ffffffff815967fd>] system_call_fastpath+0x1a/0x1f
3 locks held by wpa_supplicant/2012:
  #0:  (cb_lock){++++++}, at: [<ffffffff815003e8>] genl_rcv+0x15/0x34
  #1:  (genl_mutex){+.+.+.}, at: [<ffffffff8150059f>] genl_lock+0x12/0x14
  #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
INFO: task wpa_supplicant:2077 blocked for more than 180 seconds.
       Tainted: G         C   3.12.0-rc5-wl+ #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
wpa_supplicant  D ffff8800d0f5c280     0  2077      1 0x00000080
  ffff880212035b38 0000000000000046 ffff8800d0f5c280 ffff880212035fd8
  0000000000013b80 ffff880212035fd8 ffff8802162a4280 ffff8800d0f5c280
  0000000000000000 ffff880212034000 ffff880212034000 0000000000000246
Call Trace:
  [<ffffffff8159052e>] schedule+0x60/0x62
  [<ffffffff81590720>] schedule_preempt_disabled+0x1f/0x27
  [<ffffffff8158e595>] mutex_lock_nested+0x215/0x403
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
  [<ffffffff814e7d24>] rtnetlink_rcv+0x11/0x28
  [<ffffffff814ff9b1>] netlink_unicast+0xb0/0x131
  [<ffffffff814fffd2>] netlink_sendmsg+0x5a0/0x5e6
  [<ffffffff810eea41>] ? __lock_acquire+0x39a/0xe7e
  [<ffffffff814c6f30>] __sock_sendmsg_nosec+0x25/0x27
  [<ffffffff814c9599>] sock_sendmsg+0x5a/0x7b
  [<ffffffff8118bbdb>] ? fget_light+0x39/0x99
  [<ffffffff814ca0e5>] SYSC_sendto+0x107/0x136
  [<ffffffff81177040>] ? __sb_end_write+0x73/0x78
  [<ffffffff81596829>] ? sysret_check+0x22/0x5d
  [<ffffffff810efdad>] ? trace_hardirqs_on_caller+0x145/0x1a1
  [<ffffffff810e4e66>] ? current_kernel_time+0xd/0x31
  [<ffffffff814ca58f>] SyS_sendto+0x9/0xb
  [<ffffffff815967fd>] system_call_fastpath+0x1a/0x1f
1 lock held by wpa_supplicant/2077:
  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
INFO: task sshd:2631 blocked for more than 180 seconds.
       Tainted: G         C   3.12.0-rc5-wl+ #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sshd            D ffff88020cad0000     0  2631   1046 0x00000084
  ffff8800d0edbb38 0000000000000046 ffff88020cad0000 ffff8800d0edbfd8
  0000000000013b80 ffff8800d0edbfd8 ffffffff81a14490 ffff88020cad0000
  0000000000000000 ffff8800d0eda000 ffff8800d0eda000 0000000000000246
Call Trace:
  [<ffffffff8159052e>] schedule+0x60/0x62
  [<ffffffff81590720>] schedule_preempt_disabled+0x1f/0x27
  [<ffffffff8158e595>] mutex_lock_nested+0x215/0x403
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] ? rtnl_lock+0x12/0x14
  [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
  [<ffffffff814e7d24>] rtnetlink_rcv+0x11/0x28
  [<ffffffff814ff9b1>] netlink_unicast+0xb0/0x131
  [<ffffffff814fffd2>] netlink_sendmsg+0x5a0/0x5e6
  [<ffffffff814c6f30>] __sock_sendmsg_nosec+0x25/0x27
  [<ffffffff814c9599>] sock_sendmsg+0x5a/0x7b
  [<ffffffff814c72b1>] ? copy_from_user+0x2a/0x2c
  [<ffffffff814c9fb1>] ? move_addr_to_kernel+0x37/0x64
  [<ffffffff814ca0e5>] SYSC_sendto+0x107/0x136
  [<ffffffff81596829>] ? sysret_check+0x22/0x5d
  [<ffffffff810efdad>] ? trace_hardirqs_on_caller+0x145/0x1a1
  [<ffffffff810e4e66>] ? current_kernel_time+0xd/0x31
  [<ffffffff814ca58f>] SyS_sendto+0x9/0xb
  [<ffffffff815967fd>] system_call_fastpath+0x1a/0x1f
1 lock held by sshd/2631:
  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814e7d11>] rtnl_lock+0x12/0x14
ath10k: Failed to set preamble for VDEV: 7
ath10k: Failed to set beacon interval for VDEV: 8


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


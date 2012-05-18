Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48434 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965099Ab2ERWpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 18:45:41 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q4IMjeHC022449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 18 May 2012 15:45:40 -0700
Message-ID: <4FB6D114.4050802@candelatech.com> (sfid-20120519_004545_759985_A66CEFC4)
Date: Fri, 18 May 2012 15:45:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: lockdep splat related to wifi regulatory in 3.3.6+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This appears to be this bug:

https://bugzilla.redhat.com/show_bug.cgi?id=734519

Test case was to create 40 (virtual) stations against an AP that can only handle
30, so the remaining 10 constantly try to re-associate, get DHCP if
they manage, etc....


cfg80211: Calling CRDA for country: US

======================================================
[ INFO: possible circular locking dependency detected ]
3.3.6+ #1 Tainted: G        WC O
-------------------------------------------------------
kworker/1:2/62 is trying to acquire lock:
  (cfg80211_mutex){+.+.+.}, at: [<ffffffffa00f7ced>] restore_regulatory_settings+0x2c/0x4af [cfg80211]

but task is already holding lock:
  ((reg_timeout).work){+.+...}, at: [<ffffffff8104c5c1>] process_one_work+0x1c2/0x35a

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 ((reg_timeout).work){+.+...}:
        [<ffffffff810799bb>] lock_acquire+0x64/0x81
        [<ffffffff8104e038>] wait_on_work+0x54/0xd3
        [<ffffffff8104e196>] __cancel_work_timer+0xdf/0x128
        [<ffffffff8104e1ec>] cancel_delayed_work_sync+0xd/0xf
        [<ffffffffa00f81f5>] reg_set_request_processed+0x4c/0x66 [cfg80211]
        [<ffffffffa00f9675>] set_regdom+0x5f8/0x69f [cfg80211]
        [<ffffffffa01069ab>] nl80211_set_reg+0x213/0x26c [cfg80211]
        [<ffffffff813da541>] genl_rcv_msg+0x1f4/0x239
        [<ffffffff813d921d>] netlink_rcv_skb+0x3e/0x8f
        [<ffffffff813da346>] genl_rcv+0x21/0x28
        [<ffffffff813d8ff8>] netlink_unicast+0xe9/0x152
        [<ffffffff813d9777>] netlink_sendmsg+0x1f8/0x216
        [<ffffffff813a5d3d>] __sock_sendmsg_nosec+0x5f/0x6a
        [<ffffffff813a5d85>] __sock_sendmsg+0x3d/0x48
        [<ffffffff813a662f>] sock_sendmsg+0xa3/0xbc
        [<ffffffff813a6e38>] __sys_sendmsg+0x20f/0x29c
        [<ffffffff813a702e>] sys_sendmsg+0x3d/0x5b
        [<ffffffff8147cd79>] system_call_fastpath+0x16/0x1b

-> #1 (reg_mutex){+.+.+.}:
        [<ffffffff810799bb>] lock_acquire+0x64/0x81
        [<ffffffff81475319>] __mutex_lock_common+0x64/0x4b5
        [<ffffffff81475851>] mutex_lock_nested+0x36/0x3b
        [<ffffffffa00f8bd3>] reg_todo+0x2d/0x4d7 [cfg80211]
        [<ffffffff8104c622>] process_one_work+0x223/0x35a
        [<ffffffff8104eac5>] worker_thread+0x136/0x255
        [<ffffffff810526be>] kthread+0x84/0x8c
        [<ffffffff8147e1b4>] kernel_thread_helper+0x4/0x10

-> #0 (cfg80211_mutex){+.+.+.}:
        [<ffffffff81079667>] __lock_acquire+0xade/0xdce
        [<ffffffff810799bb>] lock_acquire+0x64/0x81
        [<ffffffff81475319>] __mutex_lock_common+0x64/0x4b5
        [<ffffffff81475851>] mutex_lock_nested+0x36/0x3b
        [<ffffffffa00f7ced>] restore_regulatory_settings+0x2c/0x4af [cfg80211]
        [<ffffffffa00f818c>] reg_timeout_work+0x1c/0x1e [cfg80211]
        [<ffffffff8104c622>] process_one_work+0x223/0x35a
        [<ffffffff8104eac5>] worker_thread+0x136/0x255
        [<ffffffff810526be>] kthread+0x84/0x8c
        [<ffffffff8147e1b4>] kernel_thread_helper+0x4/0x10

other info that might help us debug this:

Chain exists of:
   cfg80211_mutex --> reg_mutex --> (reg_timeout).work

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock((reg_timeout).work);
                                lock(reg_mutex);
                                lock((reg_timeout).work);
   lock(cfg80211_mutex);

  *** DEADLOCK ***

2 locks held by kworker/1:2/62:
  #0:  (events){.+.+.+}, at: [<ffffffff8104c5c1>] process_one_work+0x1c2/0x35a
  #1:  ((reg_timeout).work){+.+...}, at: [<ffffffff8104c5c1>] process_one_work+0x1c2/0x35a

stack backtrace:
Pid: 62, comm: kworker/1:2 Tainted: G        WC O 3.3.6+ #1
Call Trace:
  [<ffffffff810779a6>] print_circular_bug+0x1ff/0x210
  [<ffffffff81079667>] __lock_acquire+0xade/0xdce
  [<ffffffff8105c5e0>] ? get_parent_ip+0x11/0x42
  [<ffffffff810799bb>] lock_acquire+0x64/0x81
  [<ffffffffa00f7ced>] ? restore_regulatory_settings+0x2c/0x4af [cfg80211]
  [<ffffffff8147af6a>] ? add_preempt_count+0xad/0xb1
  [<ffffffff81475319>] __mutex_lock_common+0x64/0x4b5
  [<ffffffffa00f7ced>] ? restore_regulatory_settings+0x2c/0x4af [cfg80211]
  [<ffffffff81078905>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffffa00f7ced>] ? restore_regulatory_settings+0x2c/0x4af [cfg80211]
  [<ffffffff81475851>] mutex_lock_nested+0x36/0x3b
  [<ffffffffa00f7ced>] restore_regulatory_settings+0x2c/0x4af [cfg80211]
  [<ffffffffa00f818c>] reg_timeout_work+0x1c/0x1e [cfg80211]
  [<ffffffff8104c622>] process_one_work+0x223/0x35a
  [<ffffffff8104c5c1>] ? process_one_work+0x1c2/0x35a
  [<ffffffffa00f8170>] ? restore_regulatory_settings+0x4af/0x4af [cfg80211]
  [<ffffffff8104eac5>] worker_thread+0x136/0x255
  [<ffffffff8104e98f>] ? manage_workers+0x191/0x191
  [<ffffffff810526be>] kthread+0x84/0x8c
  [<ffffffff8147e1b4>] kernel_thread_helper+0x4/0x10
  [<ffffffff81477fb8>] ? retint_restore_args+0x13/0x13
  [<ffffffff8105263a>] ? __init_kthread_worker+0x56/0x56
  [<ffffffff8147e1b0>] ? gs_change+0x13/0x13
cfg80211: Restoring regulatory settings including user preference


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


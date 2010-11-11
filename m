Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48693 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757401Ab0KKA5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 19:57:35 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oAB0vYOh004480
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 16:57:34 -0800
Message-ID: <4CDB3F7E.1000107@candelatech.com>
Date: Wed, 10 Nov 2010 16:57:34 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
References: <4CDB2488.4040802@candelatech.com>
In-Reply-To: <4CDB2488.4040802@candelatech.com>
Content-Type: multipart/mixed;
 boundary="------------020603070400030501070501"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020603070400030501070501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11/10/2010 03:02 PM, Ben Greear wrote:
> We started up our strenuous wifi testing again, with this morning's
> wireless-testing
> (plus some of our own non-wifi-related patches).
>
> We have a reproducible kernel hang when attempting to quickly
> create and configure 64 STA interfaces, no encryption, with
> an ath5k NIC.
>
> It appears to me that this may be a general mac80211 deadlock
> from the 'sysrq d' output below.
>
> We'll attempt to reproduce with a lesser-patched wireless-testing
> in the meantime.

We could reproduce it on the less hacked kernel.

I think the attached trace might be more useful.  It shows
the blocked tasks spammage that we saw in an earlier
run.

Thanks,
Ben

>
>
> Nov 10 14:54:33 localhost kernel: SysRq : Show Locks Held
> Nov 10 14:54:33 localhost kernel:
> Nov 10 14:54:33 localhost kernel: Showing all locks held in the system:
> Nov 10 14:54:33 localhost kernel: 3 locks held by kworker/0:0/4:
> Nov 10 14:54:33 localhost kernel: #0: (events){+.+.+.}, at: [<c0446ded>]
> process_one_work+0x13e/0x2bf
> Nov 10 14:54:33 localhost kernel: #1: ((linkwatch_work).work){+.+.+.},
> at: [<c0446ded>] process_one_work+0x13e/0x2bf
> Nov 10 14:54:33 localhost kernel: #2: (rtnl_mutex){+.+.+.}, at:
> [<c070220f>] rtnl_lock+0xf/0x11
> Nov 10 14:54:33 localhost kernel: 1 lock held by ntpd/1675:
> Nov 10 14:54:33 localhost kernel: #0: (rtnl_mutex){+.+.+.}, at:
> [<c070220f>] rtnl_lock+0xf/0x11
> Nov 10 14:54:33 localhost kernel: 1 lock held by bash/2182:
> Nov 10 14:54:33 localhost kernel: #0: (&tty->atomic_read_lock){+.+...},
> at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
> Nov 10 14:54:33 localhost kernel: 1 lock held by bash/2199:
> Nov 10 14:54:33 localhost kernel: #0: (&tty->atomic_read_lock){+.+...},
> at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
> Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2517:
> Nov 10 14:54:33 localhost kernel: #0: (&tty->atomic_read_lock){+.+...},
> at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
> Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2518:
> Nov 10 14:54:33 localhost kernel: #0: (&tty->atomic_read_lock){+.+...},
> at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
> Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2519:
> Nov 10 14:54:33 localhost kernel: #0: (&tty->atomic_read_lock){+.+...},
> at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
> Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2520:
> Nov 10 14:54:33 localhost kernel: #0: (&tty->atomic_read_lock){+.+...},
> at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
> Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2521:
> Nov 10 14:54:33 localhost kernel: #0: (&tty->atomic_read_lock){+.+...},
> at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
> Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2522:
> Nov 10 14:54:33 localhost kernel: #0: (&tty->atomic_read_lock){+.+...},
> at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
> Nov 10 14:54:33 localhost kernel: 1 lock held by bash/2679:
> Nov 10 14:54:33 localhost kernel: #0: (&tty->atomic_read_lock){+.+...},
> at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
> Nov 10 14:54:33 localhost kernel: 3 locks held by kworker/0:3/5698:
> Nov 10 14:54:33 localhost kernel: #0: (events){+.+.+.}, at: [<c0446ded>]
> process_one_work+0x13e/0x2bf
> Nov 10 14:54:33 localhost kernel: #1: (wireless_nlevent_work){+.+.+.},
> at: [<c0446ded>] process_one_work+0x13e/0x2bf
> Nov 10 14:54:33 localhost kernel: #2: (rtnl_mutex){+.+.+.}, at:
> [<c070220f>] rtnl_lock+0xf/0x11
> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6438:
> Nov 10 14:54:33 localhost kernel: #0: (rtnl_mutex){+.+.+.}, at:
> [<c070f78c>] netlink_dump+0x3a/0x16a
> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6441:
> Nov 10 14:54:33 localhost kernel: #0: (rtnl_mutex){+.+.+.}, at:
> [<c070220f>] rtnl_lock+0xf/0x11
> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6442:
> Nov 10 14:54:33 localhost kernel: #0: (rtnl_mutex){+.+.+.}, at:
> [<c070220f>] rtnl_lock+0xf/0x11
> Nov 10 14:54:33 localhost kernel: 1 lock held by iwconfig/6443:
> Nov 10 14:54:33 localhost kernel: #0: (rtnl_mutex){+.+.+.}, at:
> [<c070220f>] rtnl_lock+0xf/0x11
> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6444:
> Nov 10 14:54:33 localhost kernel: #0: (rtnl_mutex){+.+.+.}, at:
> [<c070220f>] rtnl_lock+0xf/0x11
> Nov 10 14:54:33 localhost kernel: 4 locks held by sh/6449:
> Nov 10 14:54:33 localhost kernel: #0: (&(&i->lock)->rlock){-.-...}, at:
> [<c0631760>] serial8250_interrupt+0x1e/0xe2
> Nov 10 14:54:33 localhost kernel: #1: (&port_lock_key){-.-...}, at:
> [<c06314e6>] serial8250_handle_port+0x10/0x26c
> Nov 10 14:54:33 localhost kernel: #2: (sysrq_key_table_lock){-.....},
> at: [<c061e912>] __handle_sysrq+0x18/0x11d
> Nov 10 14:54:33 localhost kernel: #3: (tasklist_lock){.+.+..}, at:
> [<c0459d53>] debug_show_all_locks+0x43/0x179
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------020603070400030501070501
Content-Type: text/plain;
 name="ath5k_crash.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ath5k_crash.txt"

Nov 10 13:26:23 localhost kernel: INFO: task kworker/0:1:19 blocked for more than 120 seconds.
Nov 10 13:26:23 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 13:26:23 localhost kernel: kworker/0:1   D c045a09d     0    19      2 0x00000000
Nov 10 13:26:23 localhost kernel: f512bebc 00000046 f512be8c c045a09d dc3302fb 00000043 c0a22380 f50b3ea0
Nov 10 13:26:23 localhost kernel: c0a22380 f50b411c f50b4118 f50b4118 c0a22380 c0a22380 00240083 00000000
Nov 10 13:26:23 localhost kernel: f146a000 00000043 f50b3ea0 c09a0db4 c09a0db4 f50b3ea0 c09a0db8 f512bf08
Nov 10 13:26:23 localhost kernel: Call Trace:
Nov 10 13:26:23 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:23 localhost kernel: [<c078fba3>] __mutex_lock_common+0x1de/0x2eb
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c078fd5c>] mutex_lock_nested+0x36/0x3b
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c0703840>] linkwatch_event+0x8/0x22
Nov 10 13:26:23 localhost kernel: [<c0446e5e>] process_one_work+0x1af/0x2bf
Nov 10 13:26:23 localhost kernel: [<c0446ded>] ? process_one_work+0x13e/0x2bf
Nov 10 13:26:23 localhost kernel: [<c0703838>] ? linkwatch_event+0x0/0x22
Nov 10 13:26:23 localhost kernel: [<c04485ac>] worker_thread+0xf9/0x1bf
Nov 10 13:26:23 localhost kernel: [<c04484b3>] ? worker_thread+0x0/0x1bf
Nov 10 13:26:23 localhost kernel: [<c044b0da>] kthread+0x62/0x67
Nov 10 13:26:23 localhost kernel: [<c044b078>] ? kthread+0x0/0x67
Nov 10 13:26:23 localhost kernel: [<c04036c6>] kernel_thread_helper+0x6/0x1a
Nov 10 13:26:23 localhost kernel: 3 locks held by kworker/0:1/19:
Nov 10 13:26:23 localhost kernel: #0:  (events){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
Nov 10 13:26:23 localhost kernel: #1:  ((linkwatch_work).work){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
Nov 10 13:26:23 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: INFO: task kworker/0:2:1095 blocked for more than 120 seconds.
Nov 10 13:26:23 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 13:26:23 localhost kernel: kworker/0:2   D c045a09d     0  1095      2 0x00000000
Nov 10 13:26:23 localhost kernel: f3b0fe80 00000046 00000001 c045a09d c0d25960 00000043 c0a22380 f476e860
Nov 10 13:26:23 localhost kernel: c0a22380 f476eadc f476ead8 f476ead8 c0a22380 c0a22380 00000813 00000000
Nov 10 13:26:23 localhost kernel: 00000000 00000043 f476e860 c09a0db4 c09a0db4 f476e860 c09a0db8 f3b0fecc
Nov 10 13:26:23 localhost kernel: Call Trace:
Nov 10 13:26:23 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:23 localhost kernel: [<c078fba3>] __mutex_lock_common+0x1de/0x2eb
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c078fd5c>] mutex_lock_nested+0x36/0x3b
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<f8494079>] cfg80211_conn_work+0x16/0x114 [cfg80211]
Nov 10 13:26:23 localhost kernel: [<c0446ded>] ? process_one_work+0x13e/0x2bf
Nov 10 13:26:23 localhost kernel: [<c0446e5e>] process_one_work+0x1af/0x2bf
Nov 10 13:26:23 localhost kernel: [<c0446ded>] ? process_one_work+0x13e/0x2bf
Nov 10 13:26:23 localhost kernel: [<f8494063>] ? cfg80211_conn_work+0x0/0x114 [cfg80211]
Nov 10 13:26:23 localhost kernel: [<c04485bd>] worker_thread+0x10a/0x1bf
Nov 10 13:26:23 localhost kernel: [<c04484b3>] ? worker_thread+0x0/0x1bf
Nov 10 13:26:23 localhost kernel: [<c044b0da>] kthread+0x62/0x67
Nov 10 13:26:23 localhost kernel: [<c044b078>] ? kthread+0x0/0x67
Nov 10 13:26:23 localhost kernel: [<c04036c6>] kernel_thread_helper+0x6/0x1a
Nov 10 13:26:23 localhost kernel: 3 locks held by kworker/0:2/1095:
Nov 10 13:26:23 localhost kernel: #0:  (events){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
Nov 10 13:26:23 localhost kernel: #1:  ((&rdev->conn_work)){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
Nov 10 13:26:23 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: INFO: task ntpd:1553 blocked for more than 120 seconds.
Nov 10 13:26:23 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 13:26:23 localhost kernel: ntpd          D c045a09d     0  1553      1 0x00000080
Nov 10 13:26:23 localhost kernel: f31a5e04 00200046 f31a5dd4 c045a09d 44b01aaf 00000044 c0a22380 f317c910
Nov 10 13:26:23 localhost kernel: c0a22380 f317cb8c f317cb88 f317cb88 c0a22380 c0a22380 00303df7 00000000
Nov 10 13:26:23 localhost kernel: f2013180 00000044 f317c910 c09a0db4 c09a0db4 f317c910 c09a0db8 f31a5e50
Nov 10 13:26:23 localhost kernel: Call Trace:
Nov 10 13:26:23 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:23 localhost kernel: [<c078fba3>] __mutex_lock_common+0x1de/0x2eb
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c078fd5c>] mutex_lock_nested+0x36/0x3b
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c06f9446>] dev_ioctl+0x21/0x53f
Nov 10 13:26:23 localhost kernel: [<c045a539>] ? trace_hardirqs_on+0xb/0xd
Nov 10 13:26:23 localhost kernel: [<c05a4986>] ? __raw_spin_lock_init+0x2d/0x4f
Nov 10 13:26:23 localhost kernel: [<c073f765>] ? udp_ioctl+0x0/0x5f
Nov 10 13:26:23 localhost kernel: [<c06e80d5>] sock_ioctl+0x1f6/0x202
Nov 10 13:26:23 localhost kernel: [<c04becf3>] ? fd_install+0x27/0xa9
Nov 10 13:26:23 localhost kernel: [<c06e7edf>] ? sock_ioctl+0x0/0x202
Nov 10 13:26:23 localhost kernel: [<c04cc0c1>] do_vfs_ioctl+0x56d/0x5c3
Nov 10 13:26:23 localhost kernel: [<c0790d14>] ? _raw_spin_unlock+0x1d/0x20
Nov 10 13:26:23 localhost kernel: [<c04bed6e>] ? fd_install+0xa2/0xa9
Nov 10 13:26:23 localhost kernel: [<c04c1365>] ? fcheck_files+0x9b/0xca
Nov 10 13:26:23 localhost kernel: [<c04c13c1>] ? fget_light+0x2d/0xb0
Nov 10 13:26:23 localhost kernel: [<c04cc15a>] sys_ioctl+0x43/0x62
Nov 10 13:26:23 localhost kernel: [<c04030dc>] sysenter_do_call+0x12/0x38
Nov 10 13:26:23 localhost kernel: 1 lock held by ntpd/1553:
Nov 10 13:26:23 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: INFO: task btserver:6012 blocked for more than 120 seconds.
Nov 10 13:26:23 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 13:26:23 localhost kernel: btserver      D c045a09d     0  6012   5903 0x00000080
Nov 10 13:26:23 localhost kernel: f1653ce4 00000046 f1653cb4 c045a09d 680a5a2f 00000044 c0a22380 f2069f50
Nov 10 13:26:23 localhost kernel: c0a22380 f206a1cc f206a1c8 f206a1c8 c0a22380 c0a22380 0022bd20 00000000
Nov 10 13:26:23 localhost kernel: f2013180 00000044 f2069f50 c09a0db4 c09a0db4 f2069f50 c09a0db8 f1653d30
Nov 10 13:26:23 localhost kernel: Call Trace:
Nov 10 13:26:23 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:23 localhost kernel: [<c078fba3>] __mutex_lock_common+0x1de/0x2eb
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c078fd5c>] mutex_lock_nested+0x36/0x3b
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c070221f>] rtnetlink_rcv+0xe/0x22
Nov 10 13:26:23 localhost kernel: [<c0710527>] netlink_unicast+0xbe/0x11a
Nov 10 13:26:23 localhost kernel: [<c06f07fc>] ? copy_from_user+0x8/0xa
Nov 10 13:26:23 localhost kernel: [<c07110f8>] netlink_sendmsg+0x23e/0x255
Nov 10 13:26:23 localhost kernel: [<c06eace8>] ? rcu_read_lock+0x0/0x35
Nov 10 13:26:23 localhost kernel: [<c06e81a4>] __sock_sendmsg+0x54/0x5b
Nov 10 13:26:23 localhost kernel: [<c06e866e>] sock_sendmsg+0x95/0xac
Nov 10 13:26:23 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:23 localhost kernel: [<c04a0180>] ? might_fault+0x90/0x96
Nov 10 13:26:23 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:23 localhost kernel: [<c0597708>] ? _copy_from_user+0x31/0x115
Nov 10 13:26:23 localhost kernel: [<c06e8429>] ? move_addr_to_kernel+0x3e/0x43
Nov 10 13:26:23 localhost kernel: [<c06e8c8c>] sys_sendto+0xaa/0xc6
Nov 10 13:26:23 localhost kernel: [<c045bcaa>] ? lock_release_non_nested+0x86/0x1ec
Nov 10 13:26:23 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:23 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:23 localhost kernel: [<c06e9d58>] sys_socketcall+0x169/0x289
Nov 10 13:26:23 localhost kernel: [<c04030dc>] sysenter_do_call+0x12/0x38
Nov 10 13:26:23 localhost kernel: 1 lock held by btserver/6012:
Nov 10 13:26:23 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: INFO: task kworker/0:3:7184 blocked for more than 120 seconds.
Nov 10 13:26:23 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 13:26:23 localhost kernel: kworker/0:3   D c045a09d     0  7184      2 0x00000080
Nov 10 13:26:23 localhost kernel: f1021ea8 00000046 00000001 c045a09d c0d2795a 00000043 c0a22380 f1008a70
Nov 10 13:26:23 localhost kernel: c0a22380 f1008cec f1008ce8 f1008ce8 c0a22380 c0a22380 0000058b 00000000
Nov 10 13:26:23 localhost kernel: 00000000 00000043 f1008a70 c09a0db4 c09a0db4 f1008a70 c09a0db8 f1021ef4
Nov 10 13:26:23 localhost kernel: Call Trace:
Nov 10 13:26:23 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:23 localhost kernel: [<c078fba3>] __mutex_lock_common+0x1de/0x2eb
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c078fd5c>] mutex_lock_nested+0x36/0x3b
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c0770025>] wireless_nlevent_process+0xd/0x69
Nov 10 13:26:23 localhost kernel: [<c0446e5e>] process_one_work+0x1af/0x2bf
Nov 10 13:26:23 localhost kernel: [<c0446ded>] ? process_one_work+0x13e/0x2bf
Nov 10 13:26:23 localhost kernel: [<c0770018>] ? wireless_nlevent_process+0x0/0x69
Nov 10 13:26:23 localhost kernel: [<c04485ac>] worker_thread+0xf9/0x1bf
Nov 10 13:26:23 localhost kernel: [<c04484b3>] ? worker_thread+0x0/0x1bf
Nov 10 13:26:23 localhost kernel: [<c044b0da>] kthread+0x62/0x67
Nov 10 13:26:23 localhost kernel: [<c044b078>] ? kthread+0x0/0x67
Nov 10 13:26:23 localhost kernel: [<c04036c6>] kernel_thread_helper+0x6/0x1a
Nov 10 13:26:23 localhost kernel: 3 locks held by kworker/0:3/7184:
Nov 10 13:26:23 localhost kernel: #0:  (events){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
Nov 10 13:26:23 localhost kernel: #1:  (wireless_nlevent_work){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
Nov 10 13:26:23 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: INFO: task ip:7601 blocked for more than 120 seconds.
Nov 10 13:26:23 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 13:26:23 localhost kernel: ip            D c045a09d     0  7601   7563 0x00000080
Nov 10 13:26:23 localhost kernel: ece15c54 00000046 ece15c24 c045a09d bda03dd5 00000043 c0a22380 f1009f50
Nov 10 13:26:23 localhost kernel: c0a22380 f100a1cc f100a1c8 f100a1c8 c0a22380 c0a22380 00024c02 00000000
Nov 10 13:26:23 localhost kernel: f1716c80 00000043 f1009f50 c09a0db4 c09a0db4 f1009f50 c09a0db8 ece15ca0
Nov 10 13:26:23 localhost kernel: Call Trace:
Nov 10 13:26:23 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:23 localhost kernel: [<c078fba3>] __mutex_lock_common+0x1de/0x2eb
Nov 10 13:26:23 localhost kernel: [<c070f78c>] ? netlink_dump+0x3a/0x16a
Nov 10 13:26:23 localhost kernel: [<c078fd5c>] mutex_lock_nested+0x36/0x3b
Nov 10 13:26:23 localhost kernel: [<c070f78c>] ? netlink_dump+0x3a/0x16a
Nov 10 13:26:23 localhost kernel: [<c070f78c>] netlink_dump+0x3a/0x16a
Nov 10 13:26:23 localhost kernel: [<c06eee50>] ? consume_skb+0x2a/0x2c
Nov 10 13:26:23 localhost kernel: [<c070fbfd>] netlink_recvmsg+0x16d/0x27d
Nov 10 13:26:23 localhost kernel: [<c06eaeaf>] ? rcu_read_unlock+0x17/0x19
Nov 10 13:26:23 localhost kernel: [<c06e7b97>] __sock_recvmsg_nosec+0x4a/0x52
Nov 10 13:26:23 localhost kernel: [<c06e81e8>] __sock_recvmsg+0x3d/0x44
Nov 10 13:26:23 localhost kernel: [<c06e8580>] sock_recvmsg+0x9d/0xb5
Nov 10 13:26:23 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:23 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:23 localhost kernel: [<c04a0180>] ? might_fault+0x90/0x96
Nov 10 13:26:23 localhost kernel: [<c06f07fc>] ? copy_from_user+0x8/0xa
Nov 10 13:26:23 localhost kernel: [<c06f0b47>] ? verify_iovec+0x3e/0x77
Nov 10 13:26:23 localhost kernel: [<c06e835c>] __sys_recvmsg+0xfb/0x18a
Nov 10 13:26:23 localhost kernel: [<c06e84e3>] ? sock_recvmsg+0x0/0xb5
Nov 10 13:26:23 localhost kernel: [<c04a247d>] ? __do_fault+0x32d/0x359
Nov 10 13:26:23 localhost kernel: [<c045bcaa>] ? lock_release_non_nested+0x86/0x1ec
Nov 10 13:26:23 localhost kernel: [<c04c1365>] ? fcheck_files+0x9b/0xca
Nov 10 13:26:23 localhost kernel: [<c04c13c1>] ? fget_light+0x2d/0xb0
Nov 10 13:26:23 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:23 localhost kernel: [<c06e8933>] sys_recvmsg+0x36/0x4d
Nov 10 13:26:23 localhost kernel: [<c06e9e2b>] sys_socketcall+0x23c/0x289
Nov 10 13:26:23 localhost kernel: [<c0790fae>] ? restore_all_notrace+0x0/0x18
Nov 10 13:26:23 localhost kernel: [<c04030dc>] sysenter_do_call+0x12/0x38
Nov 10 13:26:23 localhost kernel: 1 lock held by ip/7601:
Nov 10 13:26:23 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070f78c>] netlink_dump+0x3a/0x16a
Nov 10 13:26:23 localhost kernel: INFO: task ip:7602 blocked for more than 120 seconds.
Nov 10 13:26:23 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 13:26:23 localhost kernel: ip            D c045a09d     0  7602   7533 0x00000080
Nov 10 13:26:23 localhost kernel: f17efcc4 00000046 f17efc94 c045a09d 533f2e05 00000045 c0a22380 f100c910
Nov 10 13:26:23 localhost kernel: c0a22380 f100cb8c f100cb88 f100cb88 c0a22380 c0a22380 0007379a 00000000
Nov 10 13:26:23 localhost kernel: f146a000 00000045 f100c910 c09a0db4 c09a0db4 f100c910 c09a0db8 f17efd10
Nov 10 13:26:23 localhost kernel: Call Trace:
Nov 10 13:26:23 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:23 localhost kernel: [<c078fba3>] __mutex_lock_common+0x1de/0x2eb
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c078fd5c>] mutex_lock_nested+0x36/0x3b
Nov 10 13:26:23 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:23 localhost kernel: [<c070221f>] rtnetlink_rcv+0xe/0x22
Nov 10 13:26:24 localhost kernel: [<c0710527>] netlink_unicast+0xbe/0x11a
Nov 10 13:26:24 localhost kernel: [<c06f07fc>] ? copy_from_user+0x8/0xa
Nov 10 13:26:24 localhost kernel: [<c07110f8>] netlink_sendmsg+0x23e/0x255
Nov 10 13:26:24 localhost kernel: [<c06eace8>] ? rcu_read_lock+0x0/0x35
Nov 10 13:26:24 localhost kernel: [<c06e81a4>] __sock_sendmsg+0x54/0x5b
Nov 10 13:26:24 localhost kernel: [<c06e866e>] sock_sendmsg+0x95/0xac
Nov 10 13:26:24 localhost kernel: [<c04c1365>] ? fcheck_files+0x9b/0xca
Nov 10 13:26:24 localhost kernel: [<c04c13c1>] ? fget_light+0x2d/0xb0
Nov 10 13:26:24 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:24 localhost kernel: [<c06e86e0>] ? sockfd_lookup_light+0x16/0x46
Nov 10 13:26:24 localhost kernel: [<c06e8c8c>] sys_sendto+0xaa/0xc6
Nov 10 13:26:24 localhost kernel: [<c04a247d>] ? __do_fault+0x32d/0x359
Nov 10 13:26:24 localhost kernel: [<c045bcaa>] ? lock_release_non_nested+0x86/0x1ec
Nov 10 13:26:24 localhost kernel: [<c04a2d74>] ? handle_mm_fault+0x322/0x825
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c06e8cde>] sys_send+0x36/0x38
Nov 10 13:26:24 localhost kernel: [<c06e9d2b>] sys_socketcall+0x13c/0x289
Nov 10 13:26:24 localhost kernel: [<c0790fae>] ? restore_all_notrace+0x0/0x18
Nov 10 13:26:24 localhost kernel: [<c04030dc>] sysenter_do_call+0x12/0x38
Nov 10 13:26:24 localhost kernel: 1 lock held by ip/7602:
Nov 10 13:26:24 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:24 localhost kernel: INFO: task ip:7603 blocked for more than 120 seconds.
Nov 10 13:26:24 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 13:26:24 localhost kernel: ip            D 00428314     0  7603   7548 0x00000080
Nov 10 13:26:24 localhost kernel: f106b9d0 00000046 f1009403 00428314 533f1a80 00000045 c0a22380 f10094e0
Nov 10 13:26:24 localhost kernel: c0a22380 f100975c f1009758 f1009758 c0a22380 c0a22380 0014a3a9 00000000
Nov 10 13:26:24 localhost kernel: f23a4780 00000045 f10094e0 f106ba94 f106ba80 7fffffff f10094e0 f106ba14
Nov 10 13:26:24 localhost kernel: Call Trace:
Nov 10 13:26:24 localhost kernel: [<c078f4a3>] schedule_timeout+0x16/0x9f
Nov 10 13:26:24 localhost kernel: [<c045a2b1>] ? mark_held_locks+0x47/0x5f
Nov 10 13:26:24 localhost kernel: [<c0790ca6>] ? _raw_spin_unlock_irq+0x22/0x2b
Nov 10 13:26:24 localhost kernel: [<c045a50d>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 10 13:26:24 localhost kernel: [<c045a539>] ? trace_hardirqs_on+0xb/0xd
Nov 10 13:26:24 localhost kernel: [<c078f378>] wait_for_common+0xbb/0x101
Nov 10 13:26:24 localhost kernel: [<c0432063>] ? default_wake_function+0x0/0xd
Nov 10 13:26:24 localhost kernel: [<c078f441>] wait_for_completion+0x12/0x14
Nov 10 13:26:24 localhost kernel: [<c0447b6b>] flush_work+0x23/0x27
Nov 10 13:26:24 localhost kernel: [<c0446a5e>] ? wq_barrier_func+0x0/0xd
Nov 10 13:26:24 localhost kernel: [<f8c9e1e1>] ieee80211_do_stop+0x252/0x3b7 [mac80211]
Nov 10 13:26:24 localhost kernel: [<c043c184>] ? local_bh_enable_ip+0x8/0xa
Nov 10 13:26:24 localhost kernel: [<c0790c81>] ? _raw_spin_unlock_bh+0x25/0x28
Nov 10 13:26:24 localhost kernel: [<c0709401>] ? dev_deactivate+0x18/0xd1
Nov 10 13:26:24 localhost kernel: [<f8c9e358>] ieee80211_stop+0x12/0x16 [mac80211]
Nov 10 13:26:24 localhost kernel: [<c06f8131>] __dev_close+0x73/0x88
Nov 10 13:26:24 localhost kernel: [<c06f5c1e>] ? dev_set_rx_mode+0x22/0x26
Nov 10 13:26:24 localhost kernel: [<c06f5dc0>] __dev_change_flags+0xa5/0x11a
Nov 10 13:26:24 localhost kernel: [<c06f7fdc>] dev_change_flags+0x13/0x3f
Nov 10 13:26:24 localhost kernel: [<c0702855>] do_setlink+0x23a/0x525
Nov 10 13:26:24 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:24 localhost kernel: [<c0702e83>] rtnl_newlink+0x283/0x45c
Nov 10 13:26:24 localhost kernel: [<c0702c7e>] ? rtnl_newlink+0x7e/0x45c
Nov 10 13:26:24 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:24 localhost kernel: [<c04b5300>] ? slab_pad_check+0xb/0xf6
Nov 10 13:26:24 localhost kernel: [<c045a2b1>] ? mark_held_locks+0x47/0x5f
Nov 10 13:26:24 localhost kernel: [<c078fc95>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 10 13:26:24 localhost kernel: [<c045a50d>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 10 13:26:24 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:24 localhost kernel: [<c0702c00>] ? rtnl_newlink+0x0/0x45c
Nov 10 13:26:24 localhost kernel: [<c07023bb>] rtnetlink_rcv_msg+0x188/0x19e
Nov 10 13:26:24 localhost kernel: [<c0702233>] ? rtnetlink_rcv_msg+0x0/0x19e
Nov 10 13:26:24 localhost kernel: [<c0710708>] netlink_rcv_skb+0x30/0x77
Nov 10 13:26:24 localhost kernel: [<c070222c>] rtnetlink_rcv+0x1b/0x22
Nov 10 13:26:24 localhost kernel: [<c0710527>] netlink_unicast+0xbe/0x11a
Nov 10 13:26:24 localhost kernel: [<c06f07fc>] ? copy_from_user+0x8/0xa
Nov 10 13:26:24 localhost kernel: [<c07110f8>] netlink_sendmsg+0x23e/0x255
Nov 10 13:26:24 localhost kernel: [<c06eace8>] ? rcu_read_lock+0x0/0x35
Nov 10 13:26:24 localhost kernel: [<c06e81a4>] __sock_sendmsg+0x54/0x5b
Nov 10 13:26:24 localhost kernel: [<c06e866e>] sock_sendmsg+0x95/0xac
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c04a0180>] ? might_fault+0x90/0x96
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c0597708>] ? _copy_from_user+0x31/0x115
Nov 10 13:26:24 localhost kernel: [<c06f07fc>] ? copy_from_user+0x8/0xa
Nov 10 13:26:24 localhost kernel: [<c06f0b47>] ? verify_iovec+0x3e/0x77
Nov 10 13:26:24 localhost kernel: [<c06e8a97>] sys_sendmsg+0x14d/0x19a
Nov 10 13:26:24 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:24 localhost kernel: [<c04a247d>] ? __do_fault+0x32d/0x359
Nov 10 13:26:24 localhost kernel: [<c045bcaa>] ? lock_release_non_nested+0x86/0x1ec
Nov 10 13:26:24 localhost kernel: [<c04c1365>] ? fcheck_files+0x9b/0xca
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c04a0180>] ? might_fault+0x90/0x96
Nov 10 13:26:24 localhost kernel: [<c06e9e16>] sys_socketcall+0x227/0x289
Nov 10 13:26:24 localhost kernel: [<c0403111>] ? sysenter_exit+0xf/0x1a
Nov 10 13:26:24 localhost kernel: [<c04030dc>] sysenter_do_call+0x12/0x38
Nov 10 13:26:24 localhost kernel: 1 lock held by ip/7603:
Nov 10 13:26:24 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:24 localhost kernel: INFO: task ip:7610 blocked for more than 120 seconds.
Nov 10 13:26:24 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 13:26:24 localhost kernel: ip            D c045a09d     0  7610   7527 0x00000080
Nov 10 13:26:24 localhost kernel: f1047cc4 00000046 f1047c94 c045a09d bddb9412 00000043 c0a22380 f14094e0
Nov 10 13:26:24 localhost kernel: c0a22380 f140975c f1409758 f1409758 c0a22380 c0a22380 006c2f4d 00000000
Nov 10 13:26:24 localhost kernel: f146a280 00000043 f14094e0 c09a0db4 c09a0db4 f14094e0 c09a0db8 f1047d10
Nov 10 13:26:24 localhost kernel: Call Trace:
Nov 10 13:26:24 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:24 localhost kernel: [<c078fba3>] __mutex_lock_common+0x1de/0x2eb
Nov 10 13:26:24 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:24 localhost kernel: [<c078fd5c>] mutex_lock_nested+0x36/0x3b
Nov 10 13:26:24 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:24 localhost kernel: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:24 localhost kernel: [<c070221f>] rtnetlink_rcv+0xe/0x22
Nov 10 13:26:24 localhost kernel: [<c0710527>] netlink_unicast+0xbe/0x11a
Nov 10 13:26:24 localhost kernel: [<c06f07fc>] ? copy_from_user+0x8/0xa
Nov 10 13:26:24 localhost kernel: [<c07110f8>] netlink_sendmsg+0x23e/0x255
Nov 10 13:26:24 localhost kernel: [<c06eace8>] ? rcu_read_lock+0x0/0x35
Nov 10 13:26:24 localhost kernel: [<c06e81a4>] __sock_sendmsg+0x54/0x5b
Nov 10 13:26:24 localhost kernel: [<c06e866e>] sock_sendmsg+0x95/0xac
Nov 10 13:26:24 localhost kernel: [<c04c1365>] ? fcheck_files+0x9b/0xca
Nov 10 13:26:24 localhost kernel: [<c04c13c1>] ? fget_light+0x2d/0xb0
Nov 10 13:26:24 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:24 localhost kernel: [<c06e86e0>] ? sockfd_lookup_light+0x16/0x46
Nov 10 13:26:24 localhost kernel: [<c06e8c8c>] sys_sendto+0xaa/0xc6
Nov 10 13:26:24 localhost kernel: [<c04a247d>] ? __do_fault+0x32d/0x359
Nov 10 13:26:24 localhost kernel: [<c045bcaa>] ? lock_release_non_nested+0x86/0x1ec
Nov 10 13:26:24 localhost kernel: [<c04a2d74>] ? handle_mm_fault+0x322/0x825
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c06e8cde>] sys_send+0x36/0x38
Nov 10 13:26:24 localhost kernel: [<c06e9d2b>] sys_socketcall+0x13c/0x289
Nov 10 13:26:24 localhost kernel: [<c0790fae>] ? restore_all_notrace+0x0/0x18
Nov 10 13:26:24 localhost kernel: [<c04030dc>] sysenter_do_call+0x12/0x38
Nov 10 13:26:24 localhost kernel: [<c0790000>] ? __down_common+0x5/0xae
Nov 10 13:26:24 localhost kernel: 1 lock held by ip/7610:
Nov 10 13:26:24 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:24 localhost kernel: INFO: task ip:7611 blocked for more than 120 seconds.
Nov 10 13:26:24 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 13:26:24 localhost kernel: ip            D c045a09d     0  7611   7579 0x00000080
Nov 10 13:26:24 localhost kernel: ea7cdcc4 00000046 ea7cdc94 c045a09d be641762 00000043 c0a22380 f140d380
Nov 10 13:26:24 localhost kernel: c0a22380 f140d5fc f140d5f8 f140d5f8 c0a22380 c0a22380 003d63d2 00000000
Nov 10 13:26:24 localhost kernel: 00000000 00000043 f140d380 c09a0db4 c09a0db4 f140d380 c09a0db8 ea7cdd10
Nov 10 13:26:24 localhost kernel: Call Trace:
Nov 10 13:26:24 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:24 localhost kernel: [<c078fba3>] __mutex_lock_common+0x1de/0x2eb
Nov 10 13:26:24 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:24 localhost kernel: [<c078fd5c>] mutex_lock_nested+0x36/0x3b
Nov 10 13:26:24 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11
Nov 10 13:26:24 localhost kernel: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 13:26:24 localhost kernel: [<c070221f>] rtnetlink_rcv+0xe/0x22
Nov 10 13:26:24 localhost kernel: [<c0710527>] netlink_unicast+0xbe/0x11a
Nov 10 13:26:24 localhost kernel: [<c06f07fc>] ? copy_from_user+0x8/0xa
Nov 10 13:26:24 localhost kernel: [<c07110f8>] netlink_sendmsg+0x23e/0x255
Nov 10 13:26:24 localhost kernel: [<c06eace8>] ? rcu_read_lock+0x0/0x35
Nov 10 13:26:24 localhost kernel: [<c06e81a4>] __sock_sendmsg+0x54/0x5b
Nov 10 13:26:24 localhost kernel: [<c06e866e>] sock_sendmsg+0x95/0xac
Nov 10 13:26:24 localhost kernel: [<c04c1365>] ? fcheck_files+0x9b/0xca
Nov 10 13:26:24 localhost kernel: [<c04c13c1>] ? fget_light+0x2d/0xb0
Nov 10 13:26:24 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:24 localhost kernel: [<c06e86e0>] ? sockfd_lookup_light+0x16/0x46
Nov 10 13:26:24 localhost kernel: [<c06e8c8c>] sys_sendto+0xaa/0xc6
Nov 10 13:26:24 localhost kernel: [<c04a247d>] ? __do_fault+0x32d/0x359
Nov 10 13:26:24 localhost kernel: [<c045bcaa>] ? lock_release_non_nested+0x86/0x1ec
Nov 10 13:26:24 localhost kernel: [<c04a2d74>] ? handle_mm_fault+0x322/0x825
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c06e8cde>] sys_send+0x36/0x38
Nov 10 13:26:24 localhost kernel: [<c06e9d2b>] sys_socketcall+0x13c/0x289
Nov 10 13:26:24 localhost kernel: [<c0790fae>] ? restore_all_notrace+0x0/0x18
Nov 10 13:26:24 localhost kernel: [<c04030dc>] sysenter_do_call+0x12/0x38
Nov 10 13:26:24 localhost kernel: 1 lock held by ip/7611:
Nov 10 13:26:24 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11


--------------020603070400030501070501--

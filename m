Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57248 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2LLCSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 21:18:17 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id qBC2IG1W016502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 18:18:16 -0800
Message-ID: <50C7E968.7070601@candelatech.com> (sfid-20121212_031825_063591_60D73FFA)
Date: Tue, 11 Dec 2012 18:18:16 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Slowdown (almost deadlock) related to ifdown of STA and ath9k_flush.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is on kernel 3.7.0+ (proprietary tag comes from an un-used module,
and for what it's worth, I just made that thing GPL, after all these years,
so no more (P) shame for me!).

System has 3 radios, 200 virtual stations per radio.

In this particular case, it appears ath9k is trying to flush,
which can block for 200ms (see ath9k/main.c:1717 or so).

I think that must block the work-queue from making progress, which stops the
'ifdown' logic from making progress (due to flush_workqueue in mac80211_stop),
and it's holding RTNL.

At the least, this seems like a bad way to hold RTNL for way too
long.  My machine was basically worthless for any operation
that required RTNL for many minutes.  Things like 'ip link set foo down'
were taking minutes, as was starting dhclient, etc).

I'll be happy to test patches or to even try writing some if
someone has ideas...

Thanks,
Ben


Dec 11 17:07:37 localhost kernel: SysRq : Show Blocked State
Dec 11 17:07:37 localhost kernel:  task                        PC stack   pid father
Dec 11 17:07:37 localhost kernel: kworker/u:3     D 00000000000f4240     0 12847      2 0x00000080
Dec 11 17:07:37 localhost kernel: ffff88020bb9bc28 0000000000000046 ffff88021fb0e6d0 ffff88020bb9bc48
Dec 11 17:07:37 localhost kernel: ffff88020bb9a010 ffff88020cafae60 ffff88020bb9bfd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: 0000000000012b80 0000000000012b80 ffff88020bb9bfd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: Call Trace:
Dec 11 17:07:37 localhost kernel: [<ffffffff815237b6>] schedule+0x5f/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff81522aa9>] schedule_hrtimeout_range_clock+0xd3/0x103
Dec 11 17:07:37 localhost kernel: [<ffffffff810a3140>] ? update_rmtp+0x60/0x60
Dec 11 17:07:37 localhost kernel: [<ffffffff8108d465>] ? _local_bh_enable_ip+0x84/0x9f
Dec 11 17:07:37 localhost kernel: [<ffffffff81522ae7>] schedule_hrtimeout_range+0xe/0x10
Dec 11 17:07:37 localhost kernel: [<ffffffff81091fb3>] usleep_range+0x3b/0x3d
Dec 11 17:07:37 localhost kernel: [<ffffffffa039a9af>] ath9k_flush+0xb8/0x17f [ath9k]
Dec 11 17:07:37 localhost kernel: [<ffffffffa027a965>] ieee80211_mgd_probe_ap_send+0x130/0x144 [mac80211]
Dec 11 17:07:37 localhost kernel: [<ffffffff81522887>] ? __mutex_unlock_slowpath+0x10d/0x11f
Dec 11 17:07:37 localhost kernel: [<ffffffffa027aeda>] ieee80211_mgd_probe_ap+0x112/0x123 [mac80211]
Dec 11 17:07:37 localhost kernel: [<ffffffffa027af85>] ieee80211_sta_monitor_work+0x12/0x14 [mac80211]
Dec 11 17:07:37 localhost kernel: [<ffffffff8109a230>] process_one_work+0x1c3/0x27b
Dec 11 17:07:37 localhost kernel: [<ffffffffa027af73>] ? ieee80211_beacon_connection_loss_work+0x88/0x88 [mac80211]
Dec 11 17:07:37 localhost kernel: [<ffffffff8109c5c8>] worker_thread+0x158/0x255
Dec 11 17:07:37 localhost kernel: [<ffffffff8109c470>] ? manage_workers+0x26e/0x26e
Dec 11 17:07:37 localhost kernel: [<ffffffff8109ffa4>] kthread+0xbf/0xc7
Dec 11 17:07:37 localhost kernel: [<ffffffff815237b6>] ? schedule+0x5f/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff8109fee5>] ? __init_kthread_worker+0x37/0x37
Dec 11 17:07:37 localhost kernel: [<ffffffff8152953c>] ret_from_fork+0x7c/0xb0
Dec 11 17:07:37 localhost kernel: [<ffffffff8109fee5>] ? __init_kthread_worker+0x37/0x37
Dec 11 17:07:37 localhost kernel: kworker/0:3     D ffff88021fa12b80     0  3320      2 0x00000080
Dec 11 17:07:37 localhost kernel: ffff880213f3bcc8 0000000000000046 0000000000000003 0000000000000086
Dec 11 17:07:37 localhost kernel: ffff880213f3a010 ffff880023c38000 ffff880213f3bfd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: 0000000000012b80 0000000000012b80 ffff880213f3bfd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: Call Trace:
Dec 11 17:07:37 localhost kernel: [<ffffffff815237b6>] schedule+0x5f/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff81523ac6>] schedule_preempt_disabled+0x13/0x1f
Dec 11 17:07:37 localhost kernel: [<ffffffff81522507>] __mutex_lock_common+0x215/0x3d2
Dec 11 17:07:37 localhost kernel: [<ffffffff815226da>] __mutex_lock_slowpath+0x16/0x18
Dec 11 17:07:37 localhost kernel: [<ffffffff815226ed>] mutex_lock+0x11/0x22
Dec 11 17:07:37 localhost kernel: [<ffffffff81477f7d>] rtnl_lock+0x10/0x12
Dec 11 17:07:37 localhost kernel: [<ffffffff814f978f>] wireless_nlevent_process+0xc/0x64
Dec 11 17:07:37 localhost kernel: [<ffffffff8109a230>] process_one_work+0x1c3/0x27b
Dec 11 17:07:37 localhost kernel: [<ffffffff814f9783>] ? iw_handler_get_iwstats+0x43/0x43
Dec 11 17:07:37 localhost kernel: [<ffffffff8109c5c8>] worker_thread+0x158/0x255
Dec 11 17:07:37 localhost kernel: [<ffffffff8109c470>] ? manage_workers+0x26e/0x26e
Dec 11 17:07:37 localhost kernel: [<ffffffff8109ffa4>] kthread+0xbf/0xc7
Dec 11 17:07:37 localhost kernel: [<ffffffff815237b6>] ? schedule+0x5f/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff8109fee5>] ? __init_kthread_worker+0x37/0x37
Dec 11 17:07:37 localhost kernel: [<ffffffff8152953c>] ret_from_fork+0x7c/0xb0
Dec 11 17:07:37 localhost kernel: [<ffffffff8109fee5>] ? __init_kthread_worker+0x37/0x37
Dec 11 17:07:37 localhost kernel: gnuserver       D ffff880209530000     0 11753  11736 0x00000080
Dec 11 17:07:37 localhost kernel: ffff880147c67c78 0000000000000082 dead000000200200 ffff880147c67d40
Dec 11 17:07:37 localhost kernel: ffff880147c66010 ffff880209530000 ffff880147c67fd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: 0000000000012b80 0000000000012b80 ffff880147c67fd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: Call Trace:
Dec 11 17:07:37 localhost kernel: [<ffffffff815237b6>] schedule+0x5f/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff81523ac6>] schedule_preempt_disabled+0x13/0x1f
Dec 11 17:07:37 localhost kernel: [<ffffffff81522507>] __mutex_lock_common+0x215/0x3d2
Dec 11 17:07:37 localhost kernel: [<ffffffff815226da>] __mutex_lock_slowpath+0x16/0x18
Dec 11 17:07:37 localhost kernel: [<ffffffff815226ed>] mutex_lock+0x11/0x22
Dec 11 17:07:37 localhost kernel: [<ffffffff81477f7d>] rtnl_lock+0x10/0x12
Dec 11 17:07:37 localhost kernel: [<ffffffff814c79ea>] devinet_ioctl+0x110/0x50f
Dec 11 17:07:37 localhost kernel: [<ffffffff814c93ea>] inet_ioctl+0x8a/0xa2
Dec 11 17:07:37 localhost kernel: [<ffffffff81459252>] sock_do_ioctl+0x24/0x42
Dec 11 17:07:37 localhost kernel: [<ffffffff814596a9>] sock_ioctl+0x1fc/0x209
Dec 11 17:07:37 localhost kernel: [<ffffffff81155ef8>] do_vfs_ioctl+0x3f7/0x43d
Dec 11 17:07:37 localhost kernel: [<ffffffff81155f97>] sys_ioctl+0x59/0x7e
Dec 11 17:07:37 localhost kernel: [<ffffffff815295e9>] system_call_fastpath+0x16/0x1b
Dec 11 17:07:37 localhost kernel: kworker/0:0     D ffff8802093cdcc0     0 22008      2 0x00000080
Dec 11 17:07:37 localhost kernel: ffff88020a41bcd8 0000000000000046 0000000000012b80 0000000000012b80
Dec 11 17:07:37 localhost kernel: ffff88020a41a010 ffff8802093cdcc0 ffff88020a41bfd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: 0000000000012b80 0000000000012b80 ffff88020a41bfd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: Call Trace:
Dec 11 17:07:37 localhost kernel: [<ffffffff815237b6>] schedule+0x5f/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff81523ac6>] schedule_preempt_disabled+0x13/0x1f
Dec 11 17:07:37 localhost kernel: [<ffffffff81522507>] __mutex_lock_common+0x215/0x3d2
Dec 11 17:07:37 localhost kernel: [<ffffffff815226da>] __mutex_lock_slowpath+0x16/0x18
Dec 11 17:07:37 localhost kernel: [<ffffffff815226ed>] mutex_lock+0x11/0x22
Dec 11 17:07:37 localhost kernel: [<ffffffff81477f7d>] rtnl_lock+0x10/0x12
Dec 11 17:07:37 localhost kernel: [<ffffffff8147a08e>] linkwatch_event+0x9/0x27
Dec 11 17:07:37 localhost kernel: [<ffffffff8109a230>] process_one_work+0x1c3/0x27b
Dec 11 17:07:37 localhost kernel: [<ffffffff8147a085>] ? __linkwatch_run_queue+0x1c5/0x1c5
Dec 11 17:07:37 localhost kernel: [<ffffffff8109c5c8>] worker_thread+0x158/0x255
Dec 11 17:07:37 localhost kernel: [<ffffffff8109c470>] ? manage_workers+0x26e/0x26e
Dec 11 17:07:37 localhost kernel: [<ffffffff8109ffa4>] kthread+0xbf/0xc7
Dec 11 17:07:37 localhost kernel: [<ffffffff815237b6>] ? schedule+0x5f/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff8109fee5>] ? __init_kthread_worker+0x37/0x37
Dec 11 17:07:37 localhost kernel: [<ffffffff8152953c>] ret_from_fork+0x7c/0xb0
Dec 11 17:07:37 localhost kernel: [<ffffffff8109fee5>] ? __init_kthread_worker+0x37/0x37
Dec 11 17:07:37 localhost kernel: wpa_supplicant  D ffff880162767bb8     0 30552      1 0x00000080
Dec 11 17:07:37 localhost kernel: ffff880162767a78 0000000000000086 ffff880162767a58 ffffffff810098bc
Dec 11 17:07:37 localhost kernel: ffff880162766010 ffff88013518dcc0 ffff880162767fd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: 0000000000012b80 0000000000012b80 ffff880162767fd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: Call Trace:
Dec 11 17:07:37 localhost kernel: [<ffffffff810098bc>] ? __switch_to+0x24d/0x421
Dec 11 17:07:37 localhost kernel: [<ffffffff815237b6>] schedule+0x5f/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff81522006>] schedule_timeout+0x22/0xd5
Dec 11 17:07:37 localhost kernel: [<ffffffff81522fac>] wait_for_common+0xc2/0x13c
Dec 11 17:07:37 localhost kernel: [<ffffffff810ad326>] ? try_to_wake_up+0x20b/0x20b
Dec 11 17:07:37 localhost kernel: [<ffffffff815230c0>] wait_for_completion+0x18/0x1a
Dec 11 17:07:37 localhost kernel: [<ffffffff8109b899>] flush_workqueue+0x176/0x348
Dec 11 17:07:37 localhost kernel: [<ffffffffa0267dde>] ieee80211_do_stop+0x340/0x4ee [mac80211]
Dec 11 17:07:37 localhost kernel: [<ffffffff815243be>] ? _raw_spin_unlock_bh+0x1c/0x1e
Dec 11 17:07:37 localhost kernel: [<ffffffff814822bf>] ? dev_deactivate_many+0x106/0x143
Dec 11 17:07:37 localhost kernel: [<ffffffffa0267fa1>] ieee80211_stop+0x15/0x19 [mac80211]
Dec 11 17:07:37 localhost kernel: [<ffffffff8146c658>] __dev_close_many+0x7f/0xa7
Dec 11 17:07:37 localhost kernel: [<ffffffff8146c6a8>] __dev_close+0x28/0x39
Dec 11 17:07:37 localhost kernel: [<ffffffff8146a010>] __dev_change_flags+0xb9/0x13d
Dec 11 17:07:37 localhost kernel: [<ffffffff8146cf9b>] dev_change_flags+0x1c/0x51
Dec 11 17:07:37 localhost kernel: [<ffffffff814c7b3f>] devinet_ioctl+0x265/0x50f
Dec 11 17:07:37 localhost kernel: [<ffffffff814c93ea>] inet_ioctl+0x8a/0xa2
Dec 11 17:07:37 localhost kernel: [<ffffffff81459252>] sock_do_ioctl+0x24/0x42
Dec 11 17:07:37 localhost kernel: [<ffffffff814596a9>] sock_ioctl+0x1fc/0x209
Dec 11 17:07:37 localhost kernel: [<ffffffff81155ef8>] do_vfs_ioctl+0x3f7/0x43d
Dec 11 17:07:37 localhost kernel: [<ffffffff81155f97>] sys_ioctl+0x59/0x7e
Dec 11 17:07:37 localhost kernel: [<ffffffff815295e9>] system_call_fastpath+0x16/0x1b
Dec 11 17:07:37 localhost kernel: wpa_supplicant  D ffff88013518c590     0 30557      1 0x00000080
Dec 11 17:07:37 localhost kernel: ffff8801e09a9978 0000000000000086 ffff880217009c00 ffff88021fa92b80
Dec 11 17:07:37 localhost kernel: ffff8801e09a8010 ffff88013518c590 ffff8801e09a9fd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: 0000000000012b80 0000000000012b80 ffff8801e09a9fd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: Call Trace:
Dec 11 17:07:37 localhost kernel: [<ffffffff815237b6>] schedule+0x5f/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff81523ac6>] schedule_preempt_disabled+0x13/0x1f
Dec 11 17:07:37 localhost kernel: [<ffffffff81522507>] __mutex_lock_common+0x215/0x3d2
Dec 11 17:07:37 localhost kernel: [<ffffffff815226da>] __mutex_lock_slowpath+0x16/0x18
Dec 11 17:07:37 localhost kernel: [<ffffffff815226ed>] mutex_lock+0x11/0x22
Dec 11 17:07:37 localhost kernel: [<ffffffff8148bd83>] genl_lock+0x10/0x12
Dec 11 17:07:37 localhost kernel: [<ffffffff8148bd96>] genl_rcv+0x11/0x28
Dec 11 17:07:37 localhost kernel: [<ffffffff8148a55d>] netlink_unicast+0xe9/0x16f
Dec 11 17:07:37 localhost kernel: [<ffffffff8148ad3a>] netlink_sendmsg+0x25f/0x27d
Dec 11 17:07:37 localhost kernel: [<ffffffff81457b23>] __sock_sendmsg_nosec+0x58/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff81458abe>] __sock_sendmsg+0x3d/0x48
Dec 11 17:07:37 localhost kernel: [<ffffffff811567e6>] ? __pollwait+0xc7/0xc7
Dec 11 17:07:37 localhost kernel: [<ffffffff81458b32>] sock_sendmsg+0x69/0x82
Dec 11 17:07:37 localhost kernel: [<ffffffff81457df4>] ? copy_from_user+0x9/0xb
Dec 11 17:07:37 localhost kernel: [<ffffffff81457e30>] ? move_addr_to_kernel+0x2b/0x65
Dec 11 17:07:37 localhost kernel: [<ffffffff81463699>] ? copy_from_user+0x9/0xb
Dec 11 17:07:37 localhost kernel: [<ffffffff814639e6>] ? verify_iovec+0x4f/0xa3
Dec 11 17:07:37 localhost kernel: [<ffffffff811567e6>] ? __pollwait+0xc7/0xc7
Dec 11 17:07:37 localhost kernel: [<ffffffff81459c39>] __sys_sendmsg+0x1fe/0x280
Dec 11 17:07:37 localhost kernel: [<ffffffff811567e6>] ? __pollwait+0xc7/0xc7
Dec 11 17:07:37 localhost kernel: [<ffffffff81459e22>] sys_sendmsg+0x3d/0x5b
Dec 11 17:07:37 localhost kernel: [<ffffffff815295e9>] system_call_fastpath+0x16/0x1b
Dec 11 17:07:37 localhost kernel: wpa_supplicant  D ffff880215ddc590     0 30562      1 0x00000080
Dec 11 17:07:37 localhost kernel: ffff8801e29477e8 0000000000000082 000000000000037b 0000000000000400
Dec 11 17:07:37 localhost kernel: ffff8801e2946010 ffff880215ddc590 ffff8801e2947fd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: 0000000000012b80 0000000000012b80 ffff8801e2947fd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: Call Trace:
Dec 11 17:07:37 localhost kernel: [<ffffffff815237b6>] schedule+0x5f/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff81523ac6>] schedule_preempt_disabled+0x13/0x1f
Dec 11 17:07:37 localhost kernel: [<ffffffff81522507>] __mutex_lock_common+0x215/0x3d2
Dec 11 17:07:37 localhost kernel: [<ffffffff815226da>] __mutex_lock_slowpath+0x16/0x18
Dec 11 17:07:37 localhost kernel: [<ffffffff815226ed>] mutex_lock+0x11/0x22
Dec 11 17:07:37 localhost kernel: [<ffffffff81477f7d>] rtnl_lock+0x10/0x12
Dec 11 17:07:37 localhost kernel: [<ffffffffa01eefc8>] nl80211_pre_doit+0x2b/0x303 [cfg80211]
Dec 11 17:07:37 localhost kernel: [<ffffffff81293f65>] ? nla_parse+0x4f/0xc3
Dec 11 17:07:37 localhost kernel: [<ffffffff8148bfd9>] genl_rcv_msg+0x22c/0x288
Dec 11 17:07:37 localhost kernel: [<ffffffff8148bdad>] ? genl_rcv+0x28/0x28
Dec 11 17:07:37 localhost kernel: [<ffffffff8148a79f>] netlink_rcv_skb+0x3e/0x8f
Dec 11 17:07:37 localhost kernel: [<ffffffff8148bda6>] genl_rcv+0x21/0x28
Dec 11 17:07:37 localhost kernel: [<ffffffff8148a55d>] netlink_unicast+0xe9/0x16f
Dec 11 17:07:37 localhost kernel: [<ffffffff8148ad3a>] netlink_sendmsg+0x25f/0x27d
Dec 11 17:07:37 localhost kernel: [<ffffffff81457b23>] __sock_sendmsg_nosec+0x58/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff81458abe>] __sock_sendmsg+0x3d/0x48
Dec 11 17:07:37 localhost kernel: [<ffffffff811567e6>] ? __pollwait+0xc7/0xc7
Dec 11 17:07:37 localhost kernel: [<ffffffff81458b32>] sock_sendmsg+0x69/0x82
Dec 11 17:07:37 localhost kernel: [<ffffffff81457df4>] ? copy_from_user+0x9/0xb
Dec 11 17:07:37 localhost kernel: [<ffffffff81457e30>] ? move_addr_to_kernel+0x2b/0x65
Dec 11 17:07:37 localhost kernel: [<ffffffff81463699>] ? copy_from_user+0x9/0xb
Dec 11 17:07:37 localhost kernel: [<ffffffff814639e6>] ? verify_iovec+0x4f/0xa3
Dec 11 17:07:37 localhost kernel: [<ffffffff811567e6>] ? __pollwait+0xc7/0xc7
Dec 11 17:07:37 localhost kernel: [<ffffffff81459c39>] __sys_sendmsg+0x1fe/0x280
Dec 11 17:07:37 localhost kernel: [<ffffffff811567e6>] ? __pollwait+0xc7/0xc7
Dec 11 17:07:37 localhost kernel: [<ffffffff81459e22>] sys_sendmsg+0x3d/0x5b
Dec 11 17:07:37 localhost kernel: [<ffffffff815295e9>] system_call_fastpath+0x16/0x1b
Dec 11 17:07:37 localhost kernel: dhclient        D ffff880052da2e60     0 29679  11779 0x00000080
Dec 11 17:07:37 localhost kernel: ffff880189db5c78 0000000000000086 ffff880052da2e60 ffff8802081cc7d8
Dec 11 17:07:37 localhost kernel: ffff880189db4010 ffff880052da2e60 ffff880189db5fd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: 0000000000012b80 0000000000012b80 ffff880189db5fd8 0000000000012b80
Dec 11 17:07:37 localhost kernel: Call Trace:
Dec 11 17:07:37 localhost kernel: [<ffffffff815237b6>] schedule+0x5f/0x61
Dec 11 17:07:37 localhost kernel: [<ffffffff81523ac6>] schedule_preempt_disabled+0x13/0x1f
Dec 11 17:07:37 localhost kernel: [<ffffffff81522507>] __mutex_lock_common+0x215/0x3d2
Dec 11 17:07:37 localhost kernel: [<ffffffff815226da>] __mutex_lock_slowpath+0x16/0x18
Dec 11 17:07:37 localhost kernel: [<ffffffff815226ed>] mutex_lock+0x11/0x22
Dec 11 17:07:37 localhost kernel: [<ffffffff81477f7d>] rtnl_lock+0x10/0x12
Dec 11 17:07:37 localhost kernel: [<ffffffff814c79ea>] devinet_ioctl+0x110/0x50f
Dec 11 17:07:37 localhost kernel: [<ffffffff814c93ea>] inet_ioctl+0x8a/0xa2
Dec 11 17:07:37 localhost kernel: [<ffffffff81459252>] sock_do_ioctl+0x24/0x42
Dec 11 17:07:37 localhost kernel: [<ffffffff814596a9>] sock_ioctl+0x1fc/0x209
Dec 11 17:07:37 localhost kernel: [<ffffffff81155ef8>] do_vfs_ioctl+0x3f7/0x43d
Dec 11 17:07:37 localhost kernel: [<ffffffff81155f97>] sys_ioctl+0x59/0x7e
Dec 11 17:07:37 localhost kernel: [<ffffffff815295e9>] system_call_fastpath+0x16/0x1b
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35953 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0KJXCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 18:02:34 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oAAN2Wak027099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 15:02:33 -0800
Message-ID: <4CDB2488.4040802@candelatech.com>
Date: Wed, 10 Nov 2010 15:02:32 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath5k/mac80211:  Reproducible deadlock with 64-stations.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We started up our strenuous wifi testing again, with this morning's wireless-testing
(plus some of our own non-wifi-related patches).

We have a reproducible kernel hang when attempting to quickly
create and configure 64 STA interfaces, no encryption, with
an ath5k NIC.

It appears to me that this may be a general mac80211 deadlock
from the 'sysrq d' output below.

We'll attempt to reproduce with a lesser-patched wireless-testing
in the meantime.


Nov 10 14:54:33 localhost kernel: SysRq : Show Locks Held
Nov 10 14:54:33 localhost kernel:
Nov 10 14:54:33 localhost kernel: Showing all locks held in the system:
Nov 10 14:54:33 localhost kernel: 3 locks held by kworker/0:0/4:
Nov 10 14:54:33 localhost kernel: #0:  (events){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
Nov 10 14:54:33 localhost kernel: #1:  ((linkwatch_work).work){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
Nov 10 14:54:33 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 14:54:33 localhost kernel: 1 lock held by ntpd/1675:
Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 14:54:33 localhost kernel: 1 lock held by bash/2182:
Nov 10 14:54:33 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
Nov 10 14:54:33 localhost kernel: 1 lock held by bash/2199:
Nov 10 14:54:33 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2517:
Nov 10 14:54:33 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2518:
Nov 10 14:54:33 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2519:
Nov 10 14:54:33 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2520:
Nov 10 14:54:33 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2521:
Nov 10 14:54:33 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
Nov 10 14:54:33 localhost kernel: 1 lock held by mingetty/2522:
Nov 10 14:54:33 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
Nov 10 14:54:33 localhost kernel: 1 lock held by bash/2679:
Nov 10 14:54:33 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<c060f4a5>] n_tty_read+0x1d2/0x5ee
Nov 10 14:54:33 localhost kernel: 3 locks held by kworker/0:3/5698:
Nov 10 14:54:33 localhost kernel: #0:  (events){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
Nov 10 14:54:33 localhost kernel: #1:  (wireless_nlevent_work){+.+.+.}, at: [<c0446ded>] process_one_work+0x13e/0x2bf
Nov 10 14:54:33 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6438:
Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070f78c>] netlink_dump+0x3a/0x16a
Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6441:
Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6442:
Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 14:54:33 localhost kernel: 1 lock held by iwconfig/6443:
Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6444:
Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
Nov 10 14:54:33 localhost kernel: 4 locks held by sh/6449:
Nov 10 14:54:33 localhost kernel: #0:  (&(&i->lock)->rlock){-.-...}, at: [<c0631760>] serial8250_interrupt+0x1e/0xe2
Nov 10 14:54:33 localhost kernel: #1:  (&port_lock_key){-.-...}, at: [<c06314e6>] serial8250_handle_port+0x10/0x26c
Nov 10 14:54:33 localhost kernel: #2:  (sysrq_key_table_lock){-.....}, at: [<c061e912>] __handle_sysrq+0x18/0x11d
Nov 10 14:54:33 localhost kernel: #3:  (tasklist_lock){.+.+..}, at: [<c0459d53>] debug_show_all_locks+0x43/0x179

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


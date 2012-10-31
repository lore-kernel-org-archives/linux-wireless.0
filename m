Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40604 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760970Ab2JaXBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 19:01:54 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q9VN1ncJ026374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 16:01:50 -0700
Message-ID: <5091ADDD.4050407@candelatech.com> (sfid-20121101_000206_244719_62ADC7A2)
Date: Wed, 31 Oct 2012 16:01:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 'ip' blocking for long time trying to down station
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is on the 400 station test machine.  No more crashes, but I'm seeing long
pauses (10+ seconds) when trying to down station interfaces (and sometimes other
commands as well).  The system cannot stabilize (my user-space app times out
after a while due to blocking on system() calls such as the one below,
and gives up, causing endless loops of up/down, associate, dhcp, etc)
I'm going to tweak the user-space code more to try to bring up stations
in smaller batches, but it still seems like there is room for improvement
in the OS.

Using sysrq, I got this trace of the command.  I'm not sure it was blocked
in the same place the whole time, but it seems likely.  Any ideas for how
to speed this sort of thing up?

./local/sbin/ip link set sta140 down

ip              D ffff88010127b5d0     0 10059  30363 0x00000080
  ffff88010127b498 0000000000000086 ffff88010127b438 ffffffff8108742f
  ffff88010127a010 ffff8802183a1750 ffff88010127bfd8 0000000000012580
  0000000000012580 0000000000012580 ffff88010127bfd8 0000000000012580
Call Trace:
  [<ffffffff8108742f>] ? enqueue_task_fair+0x2e/0x129
  [<ffffffff814e2586>] schedule+0x5f/0x61
  [<ffffffff814e0dd6>] schedule_timeout+0x22/0xd5
  [<ffffffff8108256b>] ? try_to_wake_up+0x1f9/0x20b
  [<ffffffff814e1d7c>] wait_for_common+0xc2/0x13c
  [<ffffffff8108257d>] ? try_to_wake_up+0x20b/0x20b
  [<ffffffff814e1e90>] wait_for_completion+0x18/0x1a
  [<ffffffff81070e2e>] flush_work+0x2b/0x34
  [<ffffffff8106f857>] ? cwq_dec_nr_in_flight+0x76/0x76
  [<ffffffffa026a673>] ieee80211_do_stop+0x379/0x544 [mac80211]
  [<ffffffff814e31a6>] ? _raw_spin_unlock_bh+0x1c/0x1e
  [<ffffffff814432be>] ? dev_deactivate_many+0x112/0x158
  [<ffffffffa026a853>] ieee80211_stop+0x15/0x19 [mac80211]
  [<ffffffff8142d57f>] __dev_close_many+0x8b/0xbc
  [<ffffffff8142d5e1>] __dev_close+0x31/0x42
  [<ffffffff8142af45>] __dev_change_flags+0xb9/0x13c
  [<ffffffff8142df4e>] dev_change_flags+0x1c/0x51
  [<ffffffff81439cb0>] do_setlink+0x2e3/0x7f5
  [<ffffffff8143a50f>] rtnl_newlink+0x272/0x4cf
  [<ffffffff8143a34c>] ? rtnl_newlink+0xaf/0x4cf
  [<ffffffff81438ab2>] ? rtnl_dump_ifinfo+0x140/0x169
  [<ffffffff811e72bc>] ? security_capable+0x13/0x15
  [<ffffffff814393c1>] rtnetlink_rcv_msg+0x231/0x24e
  [<ffffffff81439190>] ? rtnetlink_rcv+0x28/0x28
  [<ffffffff8144b798>] netlink_rcv_skb+0x3e/0x8f
  [<ffffffff81439189>] rtnetlink_rcv+0x21/0x28
  [<ffffffff8144b556>] netlink_unicast+0xe4/0x16a
  [<ffffffff8144bd11>] netlink_sendmsg+0x23d/0x25b
  [<ffffffff8141995c>] __sock_sendmsg_nosec+0x5f/0x6a
  [<ffffffff814199a4>] __sock_sendmsg+0x3d/0x48
  [<ffffffff81419f86>] sock_sendmsg+0xa3/0xbc
  [<ffffffff8111cb75>] ? __mem_cgroup_commit_charge+0x221/0x250
  [<ffffffff810e16ce>] ? __lru_cache_add+0x84/0x96
  [<ffffffff810e1705>] ? lru_cache_add_lru+0x25/0x27
  [<ffffffff814193a2>] ? copy_from_user+0x9/0xb
  [<ffffffff81419c2e>] ? move_addr_to_kernel+0x2b/0x65
  [<ffffffff81424add>] ? copy_from_user+0x9/0xb
  [<ffffffff81424e2a>] ? verify_iovec+0x4f/0xa3
  [<ffffffff8141b1a8>] __sys_sendmsg+0x1fe/0x280
  [<ffffffff810f4b0d>] ? handle_mm_fault+0x1c7/0x1e1
  [<ffffffff814e62b8>] ? do_page_fault+0x2de/0x350
  [<ffffffff810f87b8>] ? do_brk+0x2a2/0x301
  [<ffffffff8141b387>] sys_sendmsg+0x3d/0x5b
  [<ffffffff814e8179>] system_call_fastpath+0x16/0x1b
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


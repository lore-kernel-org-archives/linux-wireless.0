Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46429 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1F3VWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 17:22:49 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p5ULMnG0002119
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 14:22:49 -0700
Message-ID: <4E0CE929.7040300@candelatech.com> (sfid-20110630_232253_480125_B86CAA5E)
Date: Thu, 30 Jun 2011 14:22:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Crash in mlme.c, wireless-testing 2.6.39-wl + hacks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We see occasional crashes in mlme.c when testing a certain
configuration:  30 stations, configured for in-kernel authentication,
re-configure them for supplicant, let them associate, delete one of
them.

I added a BUG_ON in __cfg80211_mlme_deauth to check for null
bssid and it hit.

Please note this is hacked code, so it's possible it's something
I am doing.  I'm going to add some extra checks in this method to
keep from crashing, but it may be a while until I can test against
clean upstream kernels for this particular config.


kernel BUG at /home/greearb/git/linux.wireless-testing-ct/net/wireless/mlme.c:606!
invalid opcode: 0000 [#1] PREEMPT
last sysfs file: /sys/devices/pci0000:00/0000:00:0c.0/net/sta0/flags
Modules linked in: padlock_aes aes_i586 aes_generic xt_TPROXY nf_tproxy_core xt_socket ip]

Pid: 28023, comm: ip Tainted: P            2.6.39-wlc3+ #44    /CN700-8237R+
EIP: 0060:[<f889e2d8>] EFLAGS: 00010202 CPU: 0
EIP is at __cfg80211_mlme_deauth+0x5a/0xfe [cfg80211]
EAX: 00000001 EBX: f69aac00 ECX: 00000000 EDX: efdf3408
ESI: f6bdc000 EDI: f5c19a04 EBP: f5c19a10 ESP: f5c199e0
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process ip (pid: 28023, ti=f5c18000 task=f12b5100 task.ti=f5c18000)
Stack:
  c08d6ee4 efdf3000 f6bdc000 efdf3408 00000000 00000000 00000000 00000000
  00000003 efdf3408 f6bdc000 efdf3000 f5c19a48 f88a1230 00000000 00000000
  00000003 00000000 efdf3434 00000009 00000003 0174586e 00000000 efdf3408
Call Trace:
  [<f88a1230>] __cfg80211_disconnect+0xf4/0x17a [cfg80211]
  [<f888f322>] cfg80211_netdev_notifier_call+0x275/0x4a4 [cfg80211]
  [<c07462c7>] ? _raw_spin_unlock_irqrestore+0x25/0x28
  [<c072a68e>] ? packet_notifier+0x14f/0x158
  [<c0748618>] notifier_call_chain+0x26/0x48
  [<c043ccd1>] raw_notifier_call_chain+0x1a/0x1c
  [<c06bba81>] call_netdevice_notifiers+0x44/0x4b
  [<c06bbadd>] __dev_close_many+0x55/0xb2
  [<c042a706>] ? _local_bh_enable_ip+0x74/0x76
  [<c042a710>] ? local_bh_enable_ip+0x8/0xa
  [<c06bbb59>] __dev_close+0x1f/0x2c
  [<c06b9b82>] __dev_change_flags+0xa6/0x11b
  [<c06bc2d3>] dev_change_flags+0x13/0x3f
  [<c06c627b>] do_setlink+0x256/0x653
  [<c06c6970>] rtnl_newlink+0x24f/0x48f
  [<c06c67c6>] ? rtnl_newlink+0xa5/0x48f
  [<c0746900>] ? page_fault+0x10/0x10
  [<c056d775>] ? might_fault+0x14/0x16
  [<c06c6721>] ? rtnl_setlink+0xa9/0xa9
  [<c06c5d58>] rtnetlink_rcv_msg+0x188/0x19e
  [<c06c5bd0>] ? rtnetlink_rcv+0x22/0x22
  [<c06d3636>] netlink_rcv_skb+0x30/0x76
  [<c06c5bc9>] rtnetlink_rcv+0x1b/0x22
  [<c06d3457>] netlink_unicast+0xc1/0x11d
  [<c06b55a8>] ? copy_from_user+0x8/0xa
  [<c06d3b32>] netlink_sendmsg+0x212/0x229
  [<c06ad2bb>] __sock_sendmsg+0x54/0x5b
  [<c06ad744>] sock_sendmsg+0x94/0xab
  [<c056d775>] ? might_fault+0x14/0x16
  [<c056d8ce>] ? _copy_from_user+0x31/0x115
  [<c06b55a8>] ? copy_from_user+0x8/0xa
  [<c06b58d7>] ? verify_iovec+0x3e/0x77
  [<c06adf89>] sys_sendmsg+0x14d/0x19a
  [<c0484be9>] ? __do_fault+0x2b2/0x2de
  [<c048559d>] ? handle_pte_fault+0x264/0x5bc
  [<c0485984>] ? handle_mm_fault+0x8f/0x9e
  [<c06ade33>] ? sys_recvmsg+0x44/0x4d
  [<c06af1a4>] sys_socketcall+0x227/0x289
  [<c0488a15>] ? sys_brk+0xd0/0xd8
  [<c0749c50>] sysenter_do_call+0x12/0x22

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:32889 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1KDVAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:00:53 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id pA4L0pBZ015232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 4 Nov 2011 14:00:52 -0700
Message-ID: <4EB45283.2090802@candelatech.com> (sfid-20111104_220100_185017_18603242)
Date: Fri, 04 Nov 2011 14:00:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: another wireless crash
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is what killed my system while I was away from the serial console.

I had around 135 virtual stations running, and they were idle so being
periodically disconnected from the AP for idle-ness.

This is mostly FYI.  I'll re-build with debugging and do some more
testing to try to track these down.


IP: [<f8c597ae>] ath_update_survey_stats+0x67/0x125 [ath9k]
*pde = 00000000
Oops: 0002 [#1] SMP
Modules linked in: bridge xt_CT iptable_raw veth ip_gre gre 8021q garp stp llc fuse macvlan pktgen corete]

Pid: 22389, comm: wpa_supplicant Tainted: G        W   3.1.0-wl+ #8 To Be Filled By O.E.M. To Be Filled B.
EIP: 0060:[<f8c597ae>] EFLAGS: 00210803 CPU: 0
EIP is at ath_update_survey_stats+0x67/0x125 [ath9k]
EAX: c2915c1c EBX: f4ab4000 ECX: 7a324810 EDX: 00000000
ESI: 8586b5b0 EDI: 00009c40 EBP: f0523b84 ESP: f0523b70
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process wpa_supplicant (pid: 22389, ti=f0522000 task=ee071ec0 task.ti=f0522000)
Stack:
  c2915c1c f4ab9260 f4ab9260 f4ab83a0 00000000 f0523ba4 f8c598a0 00200282
  f0523bd4 f4ab40a8 f8c5986c f4ab83a0 f8b7e9cc f0523bb4 f8b635e2 f1706600
  f0523bd4 f0523c1c f89682ac f0523bd4 f2975a80 ef07e001 f8b7e9cc 00000000
Call Trace:
  [<f8c598a0>] ath9k_get_survey+0x34/0x9f [ath9k]
  [<f8c5986c>] ? ath_update_survey_stats+0x125/0x125 [ath9k]
  [<f8b635e2>] ieee80211_dump_survey+0x40/0x44 [mac80211]
  [<f89682ac>] nl80211_dump_survey+0x73/0xe2 [cfg80211]
  [<c06efd5e>] ? __alloc_skb+0x53/0xf1
  [<c06ebafa>] ? sock_rmalloc+0x29/0x6c
  [<c070dbb1>] netlink_dump+0x56/0x176
  [<c070e468>] netlink_dump_start+0xc2/0xe4
  [<c070fb78>] genl_rcv_msg+0x104/0x203
  [<f8968239>] ? nl80211_send_survey.clone.4+0x1f3/0x1f3 [cfg80211]
  [<c0791029>] ? __mutex_lock_common+0x246/0x250
  [<c070fa74>] ? genl_rcv+0x22/0x22
  [<c070ecb4>] netlink_rcv_skb+0x30/0x76
  [<c070fa6d>] genl_rcv+0x1b/0x22
  [<c070eaf0>] netlink_unicast+0xc1/0x11c
  [<c070f185>] netlink_sendmsg+0x20c/0x224
  [<c06e852a>] __sock_sendmsg_nosec+0x3e/0x46
  [<c06e88cc>] __sock_sendmsg+0x2a/0x33
  [<c06e8dda>] sock_sendmsg+0x93/0xa7
  [<c04859ac>] ? __generic_file_aio_write+0x24c/0x27d
  [<c058b5dd>] ? _copy_from_user+0x31/0x118
  [<c06f0acc>] ? copy_from_user+0x8/0xa
  [<c06f0dc6>] ? verify_iovec+0x3e/0x78
  [<c06e97d8>] __sys_sendmsg+0x18d/0x20b
  [<c0513d92>] ? ext4_file_write+0x1cd/0x21b
  [<c044a9c9>] ? hrtimer_forward+0x10f/0x123
  [<c044e880>] ? timekeeping_get_ns+0x10/0x48
  [<c04b9c6b>] ? do_sync_write+0x8a/0xc5
  [<c04df4ae>] ? fsnotify+0x1ad/0x1c7
  [<c06e9955>] sys_sendmsg+0x2b/0x43
  [<c06ea7af>] sys_socketcall+0x161/0x1b6
  [<c07962d8>] sysenter_do_call+0x12/0x28

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57687 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1KDSQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 14:16:47 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id pA4IGiGl001762
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 4 Nov 2011 11:16:44 -0700
Message-ID: <4EB42C0C.40101@candelatech.com> (sfid-20111104_191656_642276_99C645ED)
Date: Fri, 04 Nov 2011 11:16:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: crash in wireless-next
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anyone seen a crash like this?  I was restarting my user-space
tools, and had just unloaded the drivers that had,
around 135 virtual stations created.  Just my disable-ht
patch series applied on top of yesterday's wireless-testing.

I'll dig into it more when I get a chance, but let me know
if someone is already working on this...

BUG: unable to handle kernel NULL pointer dereference at 00000006
IP: [<c076b7e7>] wext_handle_ioctl+0xd9/0x17e
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: ath5k arc4 ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 xt_CT iptable_raw bridge ]

Pid: 1335, comm: hald Tainted: G        W   3.1.0-wl+ #3 To Be Filled By O.E.M. To Be Filled By O.E.M./To.
EIP: 0060:[<c076b7e7>] EFLAGS: 00010297 CPU: 0
EIP is at wext_handle_ioctl+0xd9/0x17e
EAX: f06a5000 EBX: 00000001 ECX: 00008b01 EDX: 00000002
ESI: f40b1ed4 EDI: 000008d3 EBP: f40b1e8c ESP: f40b1e74
  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process hald (pid: 1335, ti=f40b0000 task=f48fb340 task.ti=f40b0000)
Stack:
  00008b01 00000001 00008b01 00000000 00008b01 c0a9c140 f40b1f08 c06f9523
  bfdc339c 0017a0b9 c06ecfaa 000000d0 f40b1eb0 c0556c1d f0477440 bfdc339c
  c06ed007 f40b1ee4 c04ad561 f15a2180 1b96bccf c0a3d9e4 00000020 00000000
Call Trace:
  [<c06f9523>] dev_ioctl+0x529/0x561
  [<c06ecfaa>] ? sk_prot_alloc+0x23/0xd1
  [<c0556c1d>] ? security_sk_alloc+0x10/0x13
  [<c06ed007>] ? sk_prot_alloc+0x80/0xd1
  [<c04ad561>] ? kmem_cache_alloc+0x24/0x9d
  [<c06e8e25>] ? kernel_sendmsg+0x37/0x37
  [<c06e9000>] sock_ioctl+0x1db/0x1e7
  [<c06e8e25>] ? kernel_sendmsg+0x37/0x37
  [<c04c5996>] do_vfs_ioctl+0x464/0x4a9
  [<c07919ac>] ? _raw_spin_unlock+0x8/0xa
  [<c04b86a4>] ? fd_install+0x44/0x4a
  [<c06e9d75>] ? sock_map_fd+0x1f/0x25
  [<c06ea637>] ? sys_socket+0x43/0x5a
  [<c06ea6c5>] ? sys_socketcall+0x77/0x1b6
  [<c04c5a1c>] sys_ioctl+0x41/0x61
  [<c07962d8>] sysenter_do_call+0x12/0x28
Code: 75 06 85 db 74 51 89 da 0f b7 7a 04 8d 99 00 75 ff ff 39 fb 73 04 8b 12 eb 11 0f b7 7a 06 8d 99 20
EIP: [<c076b7e7>] wext_handle_ioctl+0xd9/0x17e SS:ESP 0068:f40b1e74
CR2: 0000000000000006

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


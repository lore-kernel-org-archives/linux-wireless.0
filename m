Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outrelay03.libero.it ([212.52.84.103]:47479 "EHLO
	outrelay03.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3KBBMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 21:12:42 -0400
Message-ID: <1175475492.2023361383354760278.JavaMail.defaultUser@defaultHost> (sfid-20131102_021246_656733_7464E2E8)
Date: Sat, 2 Nov 2013 02:12:40 +0100 (CET)
From: Fabio Rossi <rossi.f@inwind.it>
Reply-To: Fabio Rossi <rossi.f@inwind.it>
To: <marcel@holtmann.org>
Subject: Re: BUG in rfcomm_sock_getsockopt+0x128/0x200
Cc: "linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org development"
	<linux-bluetooth@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>can you quickly test a kernel build from bluetooth-next tree. I would like to 
see if that crashes as well. Since I have been running that one for weeks and 
never saw this bug.
>
>Regards
>
>Marcel

Hi Marcel,
here is the same problem with bluetooth-next.git

BUG: unable to handle kernel paging request at 00000009dd503502
IP: [<ffffffff815b1868>] rfcomm_sock_getsockopt+0x128/0x200
PGD 0
Oops: 0000 [#1] SMP
Modules linked in: ath5k ath mac80211 cfg80211
CPU: 2 PID: 1459 Comm: bluetoothd Not tainted 3.11.0-133163-gcebd830 #2
Hardware name: System manufacturer System Product Name/P6T DELUXE V2, BIOS 
1202    12/22/2010
task: ffff8803304106a0 ti: ffff88033046a000 task.ti: ffff88033046a000
RIP: 0010:[<ffffffff815b1868>]  [<ffffffff815b1868>] 
rfcomm_sock_getsockopt+0x128/0x200
RSP: 0018:ffff88033046bed8  EFLAGS: 00010246
RAX: 00000009dd503502 RBX: 0000000000000003 RCX: 00007fffa2ed5548
RDX: 0000000000000003 RSI: 0000000000000012 RDI: ffff88032fd37480
RBP: ffff88033046bf28 R08: 00007fffa2ed554c R09: ffff88032f5707d8
R10: 00007fffa2ed5548 R11: 0000000000000202 R12: ffff880330bbd000
R13: 00007fffa2ed5548 R14: 0000000000000003 R15: 00007fffa2ed554c
FS:  00007fc44cfac700(0000) GS:ffff88033fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000009dd503502 CR3: 00000003304c2000 CR4: 00000000000007e0
Stack:
 ffff88033046bf28 ffffffff815b0f2f ffff88033046bf18 0002ffff81105ef6
 0000000600000000 ffff88032fd37480 0000000000000012 00007fffa2ed5548
 0000000000000003 00007fffa2ed554c ffff88033046bf78 ffffffff814c0380
Call Trace:
 [<ffffffff815b0f2f>] ? rfcomm_sock_setsockopt+0x5f/0x190
 [<ffffffff814c0380>] SyS_getsockopt+0x60/0xb0
 [<ffffffff815e0852>] system_call_fastpath+0x16/0x1b
Code: 02 00 00 00 0f 47 d0 4c 89 ef e8 74 13 cd ff 83 f8 01 19 c9 f7 d1 83 e1 
f2 e9 4b ff ff ff 0f 1f 44 00 00 49 8b 84 24 70 02 00 00 <4c> 8b 30 4c 89 c0 e8 
2d 19 cd ff 85 c0 49 89 d7 b9 f2 ff ff ff
RIP  [<ffffffff815b1868>] rfcomm_sock_getsockopt+0x128/0x200
 RSP <ffff88033046bed8>
CR2: 00000009dd503502
---[ end trace 719ace9ee57b7a58 ]---

Regards,
Fabio

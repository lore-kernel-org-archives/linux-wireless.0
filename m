Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:36118 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KANah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:30:37 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1816\))
Subject: Re: BUG in rfcomm_sock_getsockopt+0x128/0x200
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <376684294.1810371383311879389.JavaMail.defaultUser@defaultHost>
Date: Fri, 1 Nov 2013 14:30:31 +0100
Cc: "linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org development"
	<linux-bluetooth@vger.kernel.org>
Message-Id: <58B3B295-2A6F-4BA9-9CDD-E5B1E08C37E2@holtmann.org> (sfid-20131101_143041_098866_873D8628)
References: <376684294.1810371383311879389.JavaMail.defaultUser@defaultHost>
To: Fabio Rossi <rossi.f@inwind.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fabio,

> I'm using the latest wireless-testing.git and I have found a problem, I get the 
> following kernel trace:
> 
> BUG: unable to handle kernel paging request at 
> 00000009dd50350a                                                                                                                     
> IP: [<ffffffff815b6768>] 
> rfcomm_sock_getsockopt+0x128/0x200                                                                                                                         
> PGD 
> 0                                                                                                                                                                               
> Oops: 0000 [#1] SMP 
> Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) fglrx(PO) 
> ath5k ath mac80211 cfg80211
> CPU: 2 PID: 1475 Comm: bluetoothd Tainted: P           O 3.12.0-rc5-wl #4
> Hardware name: System manufacturer System Product Name/P6T DELUXE V2, BIOS 
> 1202    12/22/2010
> task: ffff88032e9ce360 ti: ffff880330654000 task.ti: ffff880330654000
> RIP: 0010:[<ffffffff815b6768>]  [<ffffffff815b6768>] 
> rfcomm_sock_getsockopt+0x128/0x200
> RSP: 0018:ffff880330655ed8  EFLAGS: 00010246
> RAX: 00000009dd503502 RBX: 0000000000000003 RCX: 00007fff7b30e298
> RDX: 0000000000000003 RSI: 0000000000000012 RDI: ffff8800bad88f00
> RBP: ffff880330655f28 R08: 00007fff7b30e29c R09: ffff8803306734d8
> R10: 00007fff7b30e298 R11: 0000000000000202 R12: ffff8800ba83ec00
> R13: 00007fff7b30e298 R14: 0000000000000003 R15: 00007fff7b30e29c
> FS:  00007f31c1d9d700(0000) GS:ffff88033fc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000009dd50350a CR3: 000000033048a000 CR4: 00000000000007e0
> Stack:
> ffff880330655f28 ffffffff815b5e2f ffff880330655f18 0002ffff81107bb6
> 0000000600000000 ffff8800bad88f00 0000000000000012 00007fff7b30e298
> 0000000000000003 00007fff7b30e29c ffff880330655f78 ffffffff814c6260
> Call Trace:
> [<ffffffff815b5e2f>] ? rfcomm_sock_setsockopt+0x5f/0x190
> [<ffffffff814c6260>] SyS_getsockopt+0x60/0xb0
> [<ffffffff815e5ba2>] system_call_fastpath+0x16/0x1b
> Code: 02 00 00 00 0f 47 d0 4c 89 ef e8 94 f0 cc ff 83 f8 01 19 c9 f7 d1 83 e1 
> f2 e9 4b ff ff ff 0f 1f 44 00 00 49 8b 84 24 70 02 00 00 <4c> 8b 70 08 4c 89 c0 
> e8 4c f6 cc ff 85 c0 49 89 d7 b9 f2 ff ff 
> RIP  [<ffffffff815b6768>] rfcomm_sock_getsockopt+0x128/0x200
> RSP <ffff880330655ed8>
> CR2: 00000009dd50350a
> ---[ end trace 6e62d73375e99d69 ]—

what socket option is your client program setting? Do you happen to know that. Would make it a lot easier to track this down.

Regards

Marcel


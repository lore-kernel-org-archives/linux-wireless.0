Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:52118 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZGETQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 15:16:38 -0400
Received: by bwz25 with SMTP id 25so587118bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jul 2009 12:16:40 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
Date: Sun, 5 Jul 2009 23:16:29 +0400
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200907040053.05654.chunkeey@web.de> <200907050457.00689.jcmvbkbc@gmail.com> <200907051600.55958.chunkeey@web.de>
In-Reply-To: <200907051600.55958.chunkeey@web.de>
MIME-Version: 1.0
Message-Id: <200907052316.30207.jcmvbkbc@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> hmm, looks like someone tries to skb_push on a NULL skb. hmmmm,
> can you please enable ksym, it's a bit hard to see the obvious bug here.

Now it looks so:

[ 1612.708129] p54spi_work                                                
[ 1612.708221] p54spi_rx                                                  
[ 1612.708251] p54spi_wakeup                                              
[ 1612.708312] p54spi_wait_bit                                            
[ 1612.708465] skb_over_panic: text:bf000544 len:88 put:88 head:c78f4000 data:c78f4020 tail:0xc78f4078 end:0xc78f4020 dev:<NULL>
[ 1612.721405] kernel BUG at net/core/skbuff.c:127!                                                                             
[ 1612.728210] Unable to handle kernel NULL pointer dereference at virtual address 00000000                                     
[ 1612.735687] pgd = c0004000                                                                                                   
[ 1612.743225] [00000000] *pgd=00000000                                                                                         
[ 1612.750946] Internal error: Oops: 817 [#1]                                                                                   
[ 1612.758789] Modules linked in: p54spi                                                                                        
[ 1612.766815] CPU: 0    Not tainted  (2.6.31-rc1-omap1-wl #5)                                                                  
[ 1612.775207] PC is at __bug+0x20/0x2c                                                                                         
[ 1612.783721] LR is at release_console_sem+0x1b8/0x1ec
[ 1612.792510] pc : [<c002fb74>]    lr : [<c0052dd4>]    psr: 60000113
[ 1612.792541] sp : c7aebec8  ip : c7aebdf8  fp : c7aebed4
[ 1612.810119] r10: bf000904  r9 : 00000000  r8 : c7aebf30
[ 1612.818817] r7 : c78f4020  r6 : c78f4078  r5 : c78f4020  r4 : c78f4000
[ 1612.827545] r3 : 00000000  r2 : 60000113  r1 : 0000541c  r0 : 0000003a
[ 1612.836334] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[ 1612.845245] Control: 00c5387d  Table: 87fec000  DAC: 00000017
[ 1612.854125] Process phy0 (pid: 400, stack limit = 0xc7aea268)
[ 1612.862976] Stack: (0xc7aebec8 to 0xc7aec000)
[ 1612.871673] bec0:                   c7aebf0c c7aebed8 c01f5620 c002fb60 c78f4000 c78f4020
[ 1612.881011] bee0: c78f4078 c78f4020 c031c14c 00000000 c784abc0 c78f4020 bf000544 c7be3b34
[ 1612.890411] bf00: c7aebf2c c7aebf10 c01f6878 c01f55d0 c7be3940 c7be3940 00000058 c784abc0
[ 1612.899810] bf20: c7aebf5c c7aebf30 bf000544 c01f6824 00000000 00583680 c7be3afc c7be3afc
[ 1612.909179] bf40: c7be3940 50000000 c7be3b0c c7843680 c7aebf84 c7aebf60 bf000a08 bf000438
[ 1612.918395] bf60: c7abf458 10000000 c7aebf98 c7be3afc c795f780 c7aea000 c7aebfc4 c7aebf88
[ 1612.927368] bf80: c006318c bf000910 c7cccae0 00000000 c7843680 c0066778 c7aebf98 c7aebf98
[ 1612.936370] bfa0: c7aebfcc c7bf5ca0 c795f780 c0063000 00000000 00000000 c7aebff4 c7aebfc8
[ 1612.945190] bfc0: c00664ac c006300c 00000000 00000000 c7aebfd0 c7aebfd0 00000000 00000000
[ 1612.953918] bfe0: 00000000 00000000 00000000 c7aebff8 c0055270 c0066438 804b2021 804b2421
[ 1612.962829] Backtrace:
[ 1612.971343] [<c002fb54>] (__bug+0x0/0x2c) from [<c01f5620>] (skb_over_panic+0x5c/0x68)
[ 1612.980621] [<c01f55c4>] (skb_over_panic+0x0/0x68) from [<c01f6878>] (skb_put+0x60/0x70)
[ 1612.989990]  r7:c7be3b34 r6:bf000544 r5:c78f4020 r4:c784abc0
[ 1612.999359] [<c01f6818>] (skb_put+0x0/0x70) from [<bf000544>] (p54spi_rx+0x118/0x190 [p54spi])
[ 1613.009246]  r6:c784abc0 r5:00000058 r4:c7be3940
[ 1613.018920] [<bf00042c>] (p54spi_rx+0x0/0x190 [p54spi]) from [<bf000a08>] (p54spi_work+0x104/0x2ec [p54spi])
[ 1613.039001]  r8:c7843680 r7:c7be3b0c r6:50000000 r5:c7be3940 r4:c7be3afc
[ 1613.049591] [<bf000904>] (p54spi_work+0x0/0x2ec [p54spi]) from [<c006318c>] (worker_thread+0x18c/0x20c)
[ 1613.070922]  r7:c7aea000 r6:c795f780 r5:c7be3afc r4:c7aebf98
[ 1613.081756] [<c0063000>] (worker_thread+0x0/0x20c) from [<c00664ac>] (kthread+0x80/0x84)
[ 1613.092926] [<c006642c>] (kthread+0x0/0x84) from [<c0055270>] (do_exit+0x0/0x5ac)
[ 1613.104125]  r7:00000000 r6:00000000 r5:00000000 r4:00000000
[ 1613.115203] Code: e1a01000 e59f000c eb008e3c e3a03000 (e5833000)
[ 1613.126403] ---[ end trace 1e6c70a2c1a5ece6 ]---
 
Thanks.
-- Max

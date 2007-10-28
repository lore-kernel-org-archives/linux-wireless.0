Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:56214 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbXJ1UQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 16:16:33 -0400
Received: from p57aa56fb.dip.t-dialin.net ([87.170.86.251] helo=[192.168.1.8])
	by john.hrz.tu-chemnitz.de with esmtpa (Exim 4.66)
	(envelope-from <jenslang@yahoo.de>)
	id 1ImEYi-00038Q-HP
	for linux-wireless@vger.kernel.org; Sun, 28 Oct 2007 21:16:32 +0100
Message-ID: <4724EE1F.1020704@yahoo.de> (sfid-20071028_201636_935427_4A20D32E)
Date: Sun, 28 Oct 2007 21:16:31 +0100
From: Jens Lang <jenslang@yahoo.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: bcm43xx: 100 % CPU load due to ksoftirqd
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I recently bought a Compaq 6715s laptop with a Broadcom 4312 wifi chip.
Unfortunately it doesn't work with my Ubuntu Gutsy Gibbon.

When the module is loaded it constantly produces the error
bcm43xx_irq_xmit_error. The ksoftirqd uses 100 % of my CPU time. When I
remove the module from the kernel the computer freezes. Before that it
produced the following output:

Call Trace:
<IRQ> [<ffffffff8023b5b9>] __do_softirq+0x69/0xe0
[<ffffffff8020b01c>] call_softirq+0x1c/0x30
<EOI> [<ffffffff8023b3bb>] local_bh_enabl +0x5b/0xa0
[<ffffffff803ae47b>] lock_sock_nested+0xcb/0xe0
[...] sys_sendto+0x146/0x1b0
[...] sock_fasync+0x82/0x10a0
[...] sock_close+0x15/0x40
      __fput+0xc10x1e0
filp_close+0x54/0x90
sys_close+0x96/0xf0
system_call+0x7e/083

Code: 48 8b 2b 90 0f ba 08 01 19 c0 74 c7 fa 65 48 8b 04

RIP [<ffffffff8023b6a8<] tasklet_action+0x58/0xb0
 RSP <ffffffff805d7f68>

Unfortunately I cannot provide a patch but maybe this will help you
further improving the driver.


Jens

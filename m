Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:33442 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbXJ1U5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 16:57:07 -0400
Message-ID: <4724F79B.10008@lwfinger.net> (sfid-20071028_205711_629535_0A0174A2)
Date: Sun, 28 Oct 2007 15:56:59 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jens Lang <jenslang@yahoo.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: bcm43xx: 100 % CPU load due to ksoftirqd
References: <4724EE1F.1020704@yahoo.de>
In-Reply-To: <4724EE1F.1020704@yahoo.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jens Lang wrote:
> Hi,
> 
> I recently bought a Compaq 6715s laptop with a Broadcom 4312 wifi chip.
> Unfortunately it doesn't work with my Ubuntu Gutsy Gibbon.
> 
> When the module is loaded it constantly produces the error
> bcm43xx_irq_xmit_error. The ksoftirqd uses 100 % of my CPU time. When I
> remove the module from the kernel the computer freezes. Before that it
> produced the following output:
> 
> Call Trace:
> <IRQ> [<ffffffff8023b5b9>] __do_softirq+0x69/0xe0
> [<ffffffff8020b01c>] call_softirq+0x1c/0x30
> <EOI> [<ffffffff8023b3bb>] local_bh_enabl +0x5b/0xa0
> [<ffffffff803ae47b>] lock_sock_nested+0xcb/0xe0
> [...] sys_sendto+0x146/0x1b0
> [...] sock_fasync+0x82/0x10a0
> [...] sock_close+0x15/0x40
>       __fput+0xc10x1e0
> filp_close+0x54/0x90
> sys_close+0x96/0xf0
> system_call+0x7e/083
> 
> Code: 48 8b 2b 90 0f ba 08 01 19 c0 74 c7 fa 65 48 8b 04
> 
> RIP [<ffffffff8023b6a8<] tasklet_action+0x58/0xb0
>  RSP <ffffffff805d7f68>
> 
> Unfortunately I cannot provide a patch but maybe this will help you
> further improving the driver.

What other bcm43xx messages are in the dmesg output?

Larry

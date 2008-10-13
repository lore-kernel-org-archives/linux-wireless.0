Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:51064 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbYJMVoY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 17:44:24 -0400
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chr <chunkeey@web.de>, wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48EE20FB.4060700@lwfinger.net>
References: <48EE20FB.4060700@lwfinger.net>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 17:44:21 -0400
Message-Id: <1223934261.26245.4.camel@dv> (sfid-20081013_234428_358947_F23DF3A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-10-09 at 08:19 -0700, Larry Finger wrote:
> This patch is meant for testing on big-endian hardware. Every indication
> is that the data in the bootrec structure is little endian. This patch fixes
> a usage of the u32 data array as a string of u8's.

I'm sorry, I didn't test your patch yet, but I could capture the output
on the serial console.  It doesn't appear to be related to p54 specific
data structures.  The driver is initialized correctly.  I can bring the
interface up.  But once I try scanning, I get a sequence of the
following messages in the kernel log:

Badness at /home/proski/src/linux-2.6/net/mac80211/rx.c:2200
NIP: c02bc850 LR: c02ab268 CTR: 00000000
REGS: ef01fcc0 TRAP: 0700   Tainted: G        W  (2.6.27-wl)
MSR: 00029032 <EE,ME,IR,DR>  CR: 22004084  XER: 20000000
TASK = c1a58800[1778] 'p54pci' THREAD: ef01e000
GPR00: 00000008 ef01fd70 c1a58800 c1a51180 ef082cc0 ef01fdb8 ef01fddc 0000000c 
GPR08: 00000080 c1a51044 f103a6d0 0000000c 42004082 00000000 01729138 000000db 
GPR16: 0172920c 41400000 0173dba4 00241678 c03b237c ef84dfb0 ef84dfac 00000000 
GPR24: c041dde0 c0420a8c c1a51254 00000000 c1a51180 ef01fdb8 c1a51180 ef082cc0 
NIP [c02bc850] __ieee80211_rx+0x17c/0x638
LR [c02ab268] ieee80211_tasklet_handler+0x104/0x120
Call Trace:
[ef01fd70] [c1a0c020] 0xc1a0c020 (unreliable)
[ef01fdb0] [c02ab268] ieee80211_tasklet_handler+0x104/0x120
[ef01fe00] [c002e318] tasklet_action+0x80/0xfc
[ef01fe20] [c002ebf8] __do_softirq+0x8c/0xfc
[ef01fe50] [c00062ac] do_softirq+0x58/0x5c
[ef01fe60] [c002eaf8] irq_exit+0x84/0x88
[ef01fe70] [c0006320] do_IRQ+0x70/0xc8
[ef01fe80] [c00106fc] ret_from_except+0x0/0x14
--- Exception: 501 at ieee80211_hw_config+0xac/0xbc
    LR = ieee80211_hw_config+0xa0/0xbc
[ef01ff50] [c02b04f0] ieee80211_scan_work+0x144/0x1b8
[ef01ff60] [c003b26c] run_workqueue+0xc4/0x160
[ef01ff90] [c003b850] worker_thread+0x54/0xb8
[ef01ffd0] [c003f788] kthread+0x50/0x88
[ef01fff0] [c000fe88] kernel_thread+0x44/0x60
Instruction dump:
6c09ffff 2f898800 419e0244 80010044 7f83e378 7f04c378 7fa5eb78 7ea6ab78 
baa10014 7c0803a6 38210040 4bfff4d4 <0fe00000> 80010044 baa10014 38210040 

That's the current wireless-testing.

If the patch makes any difference, I'll report it separately.

-- 
Regards,
Pavel Roskin

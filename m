Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab0BCU3y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 15:29:54 -0500
Subject: Re: [PATCH] libertas: cfg80211 support
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <201002031632.10425.holgerschurig@gmail.com>
References: <20100202000934.GA19847@sortiz.org>
	 <201002031031.22805.holgerschurig@gmail.com>
	 <20100203120406.GA3498@sortiz.org>
	 <201002031632.10425.holgerschurig@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 12:30:00 -0800
Message-ID: <1265229000.21707.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-02-03 at 16:32 +0100, Holger Schurig wrote:
> Hmm, there are also still some bugs lurking in the code. Just 
> 
> I had an application running that was pinging and showed the
> signal level. Then I moved out-of-reach of the AP.
> This happened:

The command timeout code is just screwed all around.  We've already seen
that some commands just take longer than we're expecting them to.  I
think we should just get rid of the command retry stuff completely and
return EBUSY when trying to submit additional commands if the firmware
hasn't replied yet.

I don't think I've *ever* seen recovery from this situation unless the
firmware finally sends the command reply back, which has happened in
some cases with SD8686.  IMHO the command retry stuff causes more
problems than it's worth, given that it never actually fixes anything or
recovers from the timeout.

If the firmware is hung, the only way to get the device back is to
power-cycle it or possibly do a USB reset.  Retrying a command just
doesn't work.

Dan

> libertas: PREP_CMD: command 0x001f failed: 1
> libertas: PREP_CMD: command 0x001f failed: 1
> libertas: PREP_CMD: command 0x001f failed: 1
> libertas: PREP_CMD: command 0x001f failed: 1
> libertas: PREP_CMD: command 0x001f failed: 1
> libertas: PREP_CMD: command 0x001f failed: 1
> libertas: PREP_CMD: command 0x001f failed: 1
> libertas: PREP_CMD: command 0x001f failed: 1
> libertas: PREP_CMD: command 0x001f failed: 1
> libertas: PREP_CMD: command 0x001f failed: 1
> libertas: command 0x001f timed out
> libertas: requeueing command 0x001f due to timeout (#1)
> libertas: command 0x001f timed out
> libertas: requeueing command 0x001f due to timeout (#2)
> libertas: command 0x001f timed out
> libertas: requeueing command 0x001f due to timeout (#3)
> ------------[ cut here ]------------
> WARNING: at net/sched/sch_generic.c:261 dev_watchdog+0x19c/0x290()
> NETDEV WATCHDOG: wlan0 (libertas_cs): transmit queue 0 timed out
> Modules linked in: libertas_cs libertas cfg80211 compat_firmware_class [last unloaded: cfg80211]
> Backtrace:
> [<c0029464>] (dump_backtrace+0x0/0x100) from [<c002957c>] (dump_stack+0x18/0x1c)
>  r7:c0221e24 r6:c0170694 r5:c020aa78 r4:00000105
> [<c0029564>] (dump_stack+0x0/0x1c) from [<c00353a8>] (warn_slowpath_common+0x4c/0x64)
> [<c003535c>] (warn_slowpath_common+0x0/0x64) from [<c003540c>] (warn_slowpath_fmt+0x30/0x38)
>  r7:00000000 r6:00000001 r5:00000001 r4:c3b4f800
> [<c00353dc>] (warn_slowpath_fmt+0x0/0x38) from [<c0170694>] (dev_watchdog+0x19c/0x290)
>  r3:c3b4f800 r2:c020aa38
> [<c01704f8>] (dev_watchdog+0x0/0x290) from [<c003ea28>] (run_timer_softirq+0x190/0x1f0)
>  r8:c0221ebc r7:c01704f8 r6:00000100 r5:c023c0e0 r4:c0220000
> [<c003e898>] (run_timer_softirq+0x0/0x1f0) from [<c0039d94>] (__do_softirq+0x8c/0x140)
> [<c0039d08>] (__do_softirq+0x0/0x140) from [<c003a0a4>] (irq_exit+0x40/0x88)
> [<c003a064>] (irq_exit+0x0/0x88) from [<c0025070>] (asm_do_IRQ+0x70/0x84)
>  r4:0000001a
> [<c0025000>] (asm_do_IRQ+0x0/0x84) from [<c0025a84>] (__irq_svc+0x24/0xa0)
> Exception stack(0xc0221f58 to 0xc0221fa0)
> 1f40:                                                       00000001 08eff847
> 1f60: 00000000 60000013 c0220000 c02388e4 c0018ca0 c0223dd4 a00178e0 69052d06
> 1f80: a0017878 c0221fac c0221fb0 c0221fa0 c00269e8 c00269f4 60000013 ffffffff
>  r6:04000000 r5:f2d00000 r4:ffffffff
> [<c00269c8>] (default_idle+0x0/0x30) from [<c0026a64>] (cpu_idle+0x6c/0xa8)
> [<c00269f8>] (cpu_idle+0x0/0xa8) from [<c01b03c0>] (rest_init+0x58/0x6c)
>  r4:c0249774
> [<c01b0368>] (rest_init+0x0/0x6c) from [<c00088f0>] (start_kernel+0x220/0x27c)
> [<c00086d0>] (start_kernel+0x0/0x27c) from [<a0008034>] (0xa0008034)
> ---[ end trace 54aeef8ca4684eee ]---
> libertas: tx watch dog timeout
> libertas: command 0x001f timed out
> libertas: Excessive timeouts submitting command 0x001f
> libertas: PREP_CMD: command 0x001f failed: -110
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



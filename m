Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44655 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaJ2Kuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 06:50:32 -0400
Received: by mail-wg0-f43.google.com with SMTP id n12so1560686wgh.16
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 03:50:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951821B47FD7@SC-VEXCH1.marvell.com>
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
	<CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
	<CAAfyv35E2HUReFpnpdsebPETKk9VPA_hfQHUEJmoJfQt6Q-Puw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936285@SC-VEXCH1.marvell.com>
	<CAAfyv34UXMNwHf+kYCWEn+bcfGda_gA7uroLRLvhTEGGC5R57w@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936BBC@SC-VEXCH1.marvell.com>
	<CAAfyv36s+stSKU7Oi372EjsvUi+S6PSbg1wVTD1dJrMrerBPXg@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936F03@SC-VEXCH1.marvell.com>
	<CAAfyv34ivLF-B0ip+uhCah0PsiRsP1QOD0qW8F73n7KERqgM2w@mail.gmail.com>
	<CAAfyv37uyPwED3tzX_4RjeTuf8LXqtL3zH4f-cNOLuRB+w=z6Q@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821545AE6@SC-VEXCH1.marvell.com>
	<CAAfyv35G=9WyYxQZjt3EYfGC+u0z81ktXrO7LEUrADxKX3XDNA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821B47FD7@SC-VEXCH1.marvell.com>
Date: Wed, 29 Oct 2014 11:50:31 +0100
Message-ID: <CAAfyv35oXYBqQsPzLWz4k6cM44+GSmPC6TTgVoELEjM_FAoYQw@mail.gmail.com> (sfid-20141029_115042_748147_A185D910)
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to 5GHz
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amitkumar,

On Wed, Oct 29, 2014 at 10:54 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Marek,
>
> We have one fix in Rx reorder logic and have handled dev_alloc_skb failure by resubmitting the urbs.
> Could you please test attached experimental patches?
I tested both patches and I can still reproduce issue. With
0001-mwifiex-resubmit-Rx-data-URBS-when-dev_alloc_skb-fai.patch
I get kernel crash when allocation fails happens:
[  118.904307] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  118.911431] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  118.918328] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  118.925204] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  118.932291] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  118.939403] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  120.171372] ------------[ cut here ]------------
[  120.176288] WARNING: at drivers/usb/core/urb.c:327 usb_submit_urb+0x35/0x4c()
[  120.183776] URB ce411840 submitted while active
[  120.188528] Modules linked in: mwifiex_usb mwifiex btusb
beo_hh1_misc(O) beo_hh1_lsl(O) beo_hh1_summit(O) beo_hh1_tunnel(O)
beo_hh1_rtc(O) beo_hh1_power(O) beo_hh1_dsp(O) beo_hh1_fwupdate(O)
beo_hh1_input(O) beo_hh1_leds(O) beo_hh1_fep(O) beo_ase_fephw(O)
beo_ase_dsp(]
[  120.217461] [<c000ff19>] (unwind_backtrace+0x1/0x98) from
[<c0026e17>] (warn_slowpath_common+0x33/0x4c)
[  120.227332] [<c0026e17>] (warn_slowpath_common+0x33/0x4c) from
[<c0026e89>] (warn_slowpath_fmt+0x1d/0x28)
[  120.237386] [<c0026e89>] (warn_slowpath_fmt+0x1d/0x28) from
[<c022fd4d>] (usb_submit_urb+0x35/0x4c)
[  120.246907] [<c022fd4d>] (usb_submit_urb+0x35/0x4c) from
[<bf8a321b>] (mwifiex_usb_submit_rx_urb+0x72/0x10c [mwifiex_usb])
[  120.258592] [<bf8a321b>] (mwifiex_usb_submit_rx_urb+0x72/0x10c
[mwifiex_usb]) from [<bf8a34a9>] (mwifiex_usb_rx_complete+0xe0/0x2b0
[mwifiex_usb])
[  120.272388] [<bf8a34a9>] (mwifiex_usb_rx_complete+0xe0/0x2b0
[mwifiex_usb]) from [<c022dfd5>] (usb_hcd_giveback_urb+0x29/0x74)
[  120.284360] [<c022dfd5>] (usb_hcd_giveback_urb+0x29/0x74) from
[<c024730b>] (musb_giveback+0x23/0x2c)
[  120.294051] [<c024730b>] (musb_giveback+0x23/0x2c) from
[<c0247f21>] (musb_advance_schedule+0x35/0x16c)
[  120.303922] [<c0247f21>] (musb_advance_schedule+0x35/0x16c) from
[<c0246605>] (musb_interrupt+0x61/0x5e0)
[  120.313974] [<c0246605>] (musb_interrupt+0x61/0x5e0) from
[<c02492b5>] (dsps_interrupt+0x17d/0x234)
[  120.323492] [<c02492b5>] (dsps_interrupt+0x17d/0x234) from
[<c005cc73>] (handle_irq_event_percpu+0x33/0x11c)
[  120.333819] [<c005cc73>] (handle_irq_event_percpu+0x33/0x11c) from
[<c005cd85>] (handle_irq_event+0x29/0x3c)
[  120.344144] [<c005cd85>] (handle_irq_event+0x29/0x3c) from
[<c005e2f3>] (handle_level_irq+0x4f/0x88)
[  120.353738] [<c005e2f3>] (handle_level_irq+0x4f/0x88) from
[<c005c80f>] (generic_handle_irq+0x13/0x1c)
[  120.363525] [<c005c80f>] (generic_handle_irq+0x13/0x1c) from
[<c000d595>] (handle_IRQ+0x1d/0x54)
[  120.372758] [<c000d595>] (handle_IRQ+0x1d/0x54) from [<c0008495>]
(omap3_intc_handle_irq+0x5d/0x68)
[  120.382262] [<c0008495>] (omap3_intc_handle_irq+0x5d/0x68) from
[<c000c7ff>] (__irq_svc+0x3f/0x64)
[  120.391666] Exception stack(0xce569d68 to 0xce569db0)
[  120.396977] 9d60:                   00000001 ce122f98 00000000
00000001 a0000013 cf31e010
[  120.405567] 9d80: a0000013 00000000 cf00e480 ce015b04 ce411ac0
00000020 ce122b40 ce569db0
[  120.414151] 9da0: c0050b97 c037e914 40000033 ffffffff
[  120.419473] [<c000c7ff>] (__irq_svc+0x3f/0x64) from [<c037e914>]
(_raw_spin_unlock_irqrestore+0x24/0x30)
[  120.429435] [<c037e914>] (_raw_spin_unlock_irqrestore+0x24/0x30)
from [<c0247a4d>] (musb_urb_enqueue+0x4d/0x3b8)
[  120.440128] [<c0247a4d>] (musb_urb_enqueue+0x4d/0x3b8) from
[<c022e9d7>] (usb_hcd_submit_urb+0x6f/0x57c)
[  120.450094] [<c022e9d7>] (usb_hcd_submit_urb+0x6f/0x57c) from
[<bf8a321b>] (mwifiex_usb_submit_rx_urb+0x72/0x10c [mwifiex_usb])
[  120.462229] [<bf8a321b>] (mwifiex_usb_submit_rx_urb+0x72/0x10c
[mwifiex_usb]) from [<bf87ec27>] (mwifiex_main_process+0x2a2/0x3ac
[mwifiex])
[  120.475507] [<bf87ec27>] (mwifiex_main_process+0x2a2/0x3ac
[mwifiex]) from [<bf87ed3f>] (mwifiex_main_work_queue+0xe/0x10
[mwifiex])
[  120.488049] [<bf87ed3f>] (mwifiex_main_work_queue+0xe/0x10
[mwifiex]) from [<c0036cef>] (process_one_work+0x117/0x2b4)
[  120.499289] [<c0036cef>] (process_one_work+0x117/0x2b4) from
[<c00370e1>] (worker_thread+0xd9/0x280)
[  120.508893] [<c00370e1>] (worker_thread+0xd9/0x280) from
[<c003a1cf>] (kthread+0x6b/0x74)
[  120.517487] [<c003a1cf>] (kthread+0x6b/0x74) from [<c000cd95>]
(ret_from_fork+0x11/0x3c)
[  120.525978] ---[ end trace 67ca4bd7a80b7c08 ]---
[  120.530838] usb 1-1: usb_submit_urb failed

>
>>[   76.769662] usb 1-1: Received between 2 BAR:2918
>>[   76.775047] usb 1-1: Networking send size:2914
>>[   77.067491] usb 1-1: rx_pending:10155
>>[   77.177524] usb 1-1: rx_pending kernel:10383
>>According log it seems rx_pending is slowly increasing until allocation
>>fails. Code hacks are attached.
>
> I am checking your hacks. The reason for huge rx_pending count is we might have missed to decrement the count at some place. The difference between " Received between 2 BAR" and "Networking send size" could be genuine leaks. We will look into this.
Thanks.
>
> Regards,
> Amit
>
>

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f195.google.com ([209.85.214.195]:36203 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbcDMUmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 16:42:52 -0400
MIME-Version: 1.0
In-Reply-To: <20160412183202.GC13637@wunner.de>
References: <E1akxli-00030z-BC@bombadil.infradead.org>
	<CA+Y=x3=cLDHc7PK5h9n=ixdgVKWdVSu_v+-7jHJ-vBnDrv4sgg@mail.gmail.com>
	<20160403114912.GA11540@wunner.de>
	<CA+Y=x3nfe7CniNhruOhGmdxY3g4B1n3YRVWChoVYJns7D8pNEg@mail.gmail.com>
	<CA+Y=x3mVrSKMgzy74xtO5ZOc5kYLYU=iKZgqyjn0j94bXoebjg@mail.gmail.com>
	<20160412183202.GC13637@wunner.de>
Date: Thu, 14 Apr 2016 06:42:50 +1000
Message-ID: <CA+Y=x3mBm6==ffohf+aH2tHm9m+RSa7mZBJkDSvSmdCmEDdkNQ@mail.gmail.com> (sfid-20160413_224256_422856_0376BC27)
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
From: Andrew Worsley <amworsley@gmail.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: b43-dev@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank-you very much for your comments in your reply.

Actually the patch did work - I confirmed it was run and the iomap
call was successful by adding a pr_info() after the pci_iomap()
success branch.

The only time I am getting the IRQ 17 nobody cared message is on
suspend / resume. A fresh boot always had below the 100k interrupt
threshold level.

I tried your new patch and the number is even lower < 30,000 over two boots.

BUT on suspend resume again 126856.

Have you any insights on fixing suspend to disk  / resume paths which
presumably face the same issue of being passed live hardware on boot
up?


On 13 April 2016 at 04:32, Lukas Wunner <lukas@wunner.de> wrote:
> Hi Andrew,
>
> thank you for the extensive testing.
>
> On Sun, Apr 10, 2016 at 08:09:29PM +1000, Andrew Worsley wrote:
>> Further testing Broadcom 4331 reset quirk to prevent IRQ storm patch
>> testing reveals that:
>>   1. quirk is run on initial boot up and this time appears to have
>> vastly reduced the interrupts (only 81 this time):
>> cat /proc/interrupts| grep 17
>>  17:         81          0          0          0          0          0
>>          0          0   IO-APIC-fasteoi   snd_hda_intel
>
> Something in the ballpark of 81 interrupt requests is fine.
>
> The kernel will print the error message about spurious interrupts and
> switch to polling at 100000 requests. But even 20000 is way too much.
> This just means that b43 loaded quickly enough to stop the interrupts
> before the kernel limit of 100000 was reached, but the wireless card
> wasn't reset early on as it should have been.
>
> It looks like the patch didn't work at all on your machine for some
> reason. Do you see a message "cannot iomap device, IRQ storm ahead"
> in dmesg?

Result from two reboots with my 3.16 kernel and your new patch

Three full boots (all below 30k interrupts):
 17:      23978          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel
 17:      30088          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel
 17:      26853          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel


dmesg output showing quirk running
dmesg | grep -C 5 quirk
[    3.270315] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    3.270323] pci 0000:00:1c.0:   bridge window [mem 0xc1a00000-0xc1afffff]
[    3.270331] pci 0000:00:1c.0:   bridge window [mem
0xc1800000-0xc18fffff 64bit pref]
[    3.270463] pci 0000:04:00.0: [14e4:4331] type 00 class 0x028000
[    3.270495] pci 0000:04:00.0: reg 0x10: [mem 0xc1900000-0xc1903fff 64bit]
[    3.270574] pci 0000:04:00.0: b43 quirk: resetting controller
[    3.270711] pci 0000:04:00.0: supports D1 D2
[    3.270712] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    3.270759] pci 0000:04:00.0: System wakeup disabled by ACPI
[    3.278239] pci 0000:00:1c.1: PCI bridge to [bus 04]
[    3.278251] pci 0000:00:1c.1:   bridge window [mem 0xc1900000-0xc19fffff]

Output after resume.  Note: Some times it looks it can happen on the
suspend to disk? But a new one is always present after the resume.

 17:     126856          0          0          0          0          0
         0          0   IO-APIC-fasteoi   snd_hda_intel
[   53.404157] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
with disabled ep ffff88045d495540
[   53.468249] irq 17: nobody cared (try booting with the "irqpoll" option)
[   53.468253] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G         C O
3.16.7-ckt25-3.16-bcm4331-patch2 #7
[   53.468254] Hardware name: Apple Inc.
MacBookPro10,1/Mac-C3EC7CD22292981F, BIOS
MBP101.88Z.00EE.B00.1205101839 05/10/2012
[   53.468259]  0000000000000000 ffffffff81520370 ffff88045a8a8c00
ffff88045a8a8cc4
[   53.468262]  ffffffff810bfe7d ffff88045a8a8c00 0000000000000000
0000000000000011
[   53.468264]  ffffffff810c022f 0000000000000000 0000000000000011
0000000000000000
[   53.468265] Call Trace:
[   53.468275]  <IRQ>  [<ffffffff81520370>] ? dump_stack+0x5d/0x78
[   53.468282]  [<ffffffff810bfe7d>] ? __report_bad_irq+0x2d/0xd0
[   53.468286]  [<ffffffff810c022f>] ? note_interrupt+0x25f/0x2b0
[   53.468290]  [<ffffffff810bd9c1>] ? handle_irq_event_percpu+0x121/0x190
[   53.468294]  [<ffffffff810bda68>] ? handle_irq_event+0x38/0x50
[   53.468296]  [<ffffffff810c0d5f>] ? handle_fasteoi_irq+0x7f/0x150
[   53.468302]  [<ffffffff810153ad>] ? handle_irq+0x1d/0x30
[   53.468307]  [<ffffffff81529118>] ? do_IRQ+0x48/0xe0
[   53.468311]  [<ffffffff81526f6d>] ? common_interrupt+0x6d/0x6d
[   53.468317]  <EOI>  [<ffffffff813ef54c>] ? cpuidle_enter_state+0x4c/0xc0
[   53.468320]  [<ffffffff813ef542>] ? cpuidle_enter_state+0x42/0xc0
[   53.468323]  [<ffffffff810aaa6a>] ? cpu_startup_entry+0x33a/0x460
[   53.468326]  [<ffffffff81911f34>] ? start_kernel+0x473/0x47b
[   53.468331]  [<ffffffff81911120>] ? early_idt_handler_array+0x120/0x120
[   53.468335]  [<ffffffff81911608>] ? x86_64_start_kernel+0x14d/0x15c
[   53.468336] handlers:
[   53.468367] [<ffffffffa02ce740>] azx_interrupt [snd_hda_controller]
[   53.468368] Disabling IRQ #17
[   53.513740] usb 3-1: reset high-speed USB device number 2 using xhci_hcd
[   53.633633] usb 1-1.1: reset high-speed USB device number 3 using ehci-pci
[   53.633646] usb 2-1.8: reset high-speed USB device number 3 using ehci-pci

  Sorry for the old kernel - I want to run debian stable rather than
hand buit kernels so my other packages.

I don't see any newer kernels when I do
apt-cache search "^linux-source"

so perhaps I have to add backports or testing into my repository list?
If you think it is worth it I can do that.

What other boot loaders do people use on a MacBook beside grub?

I think the setpci commands in grub might fix the problem for me for
suspend/resume as well as boot. Can you can easily point me to how to
translate the numbers from your patch:

Would it be:

setpci -s "04:00.0" 1800.l=1

Do you have another pointer to where to fix the suspend resume?

Thanks very much again

Andrew

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36283 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbcDGMEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 08:04:06 -0400
MIME-Version: 1.0
In-Reply-To: <20160403114912.GA11540@wunner.de>
References: <E1akxli-00030z-BC@bombadil.infradead.org>
	<CA+Y=x3=cLDHc7PK5h9n=ixdgVKWdVSu_v+-7jHJ-vBnDrv4sgg@mail.gmail.com>
	<20160403114912.GA11540@wunner.de>
Date: Thu, 7 Apr 2016 22:04:05 +1000
Message-ID: <CA+Y=x3nfe7CniNhruOhGmdxY3g4B1n3YRVWChoVYJns7D8pNEg@mail.gmail.com> (sfid-20160407_140412_075283_D82CADC0)
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
From: Andrew Worsley <amworsley@gmail.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: b43-dev@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry but testing the patch shows no difference.

I have just compiled debian jessie kernel 3.16.7-ckt25 and booted it
and hibernated it twice, then did the same with your patch applied.
There appeared to be no difference

On first boot I didn't get the nobody card disabling  problem but
after each hibernate I got the problem. But I did get 51130 IRQ 17
interrupts on the first boot but after the hibernate restore  each
time I got 100000 extra interrupts in /proc/interrupts and the irq 17:
nobody cared message.

I could not see any difference with or with out the patch.
I boot with grub-efi using the linux/initrd commands

So perhaps the hibernate-restore needs the fix?

Andrew



On 3 April 2016 at 21:49, Lukas Wunner <lukas@wunner.de> wrote:
> Hi Andrew,
>
> On Sat, Apr 02, 2016 at 10:40:41PM +1100, Andrew Worsley wrote:
>> On 30 March 2016 at 04:41, Lukas Wunner <lukas@wunner.de> wrote:
>> > Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
>> > on boot until they are reset, causing spurious interrupts if the IRQ is
>> > shared. Apparently the EFI bootloader enables the device and does not
>> > disable it before passing control to the OS. The bootloader contains a
>> > driver for the wireless card which allows it to phone home to Cupertino.
>> > This is used for Internet Recovery (download and install OS X images)
>> > and probably also for Back to My Mac (remote access, RFC 6281) and to
>> > discover stolen hardware.
>> >
>> > The issue is most pronounced on 2011 and 2012 MacBook Pros where the IRQ
>> > is shared with 3 other devices (Light Ridge Thunderbolt controller, SDXC
>> > reader, HDA card on discrete GPU). As soon as an interrupt handler is
>> > installed for one of these devices, the ensuing storm of spurious IRQs
>> > causes the kernel to disable the IRQ and switch to polling. This lasts
>> > until the b43 driver loads and resets the device.
>> >
>> > Loading the b43 driver first is not always an option, in particular with
>> > the Light Ridge Thunderbolt controller: The PCI hotplug IRQ handler gets
>> > installed early on because it is built in, unlike b43 which is usually
>> > a module.
>> >
>> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79301
>> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=895951
>> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1009819
>> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1149632
>>
>> I do see an irq 17 problem on my macbook, but I thought grub is
>> supposed to stop the boardcom wireless?
>>
>> Investigating grub2 git://git.savannah.gnu.org/grub.git I see this
>> patch  rev 9d34bb8 which says it disables Broadcom wireless hardware
>> on Apples:
>
> Thanks for the pointer to the grub2 commit, I wasn't aware of that.
>
> The commit puts the wireless card in power state D3hot but that doesn't
> stop it from sending interrupts. I have just tested that. So it's
> perfectly plausible that you're still seeing spurious interrupts
> despite using grub. Please test the patch I've posted, the spurious
> interrupts should disappear. If you "cat /proc/interrupts", you should
> then only see a few hundred interrupts on IRQ 17. Without the patch it
> should be in the 100000+ range.
>
> Best regards,
>
> Lukas
>
>>
>> * commit 9d34bb8
>> | Author: Matthew Garrett <mjg@redhat.com>
>> | Date:   Thu May 3 17:26:55 2012 +0200
>> |
>> |       Suspend broadcom cards in order to stop their DMA.
>> |
>> |       * grub-core/Makefile.am (KERNEL_HEADER_FILES): Add pci.h on x86 EFI.
>> |       * grub-core/Makefile.core.def (kernel): Add pci.c on x86 EFI.
>> |       (pci): Don't build on x86 EFI.
>> |       * grub-core/bus/pci.c (grub_pci_find_capability): New function.
>> |       * grub-core/kern/efi/mm.c (stop_broadcom) [__i386__ || __x86_64__]:
>> |       New function.
>> |       (grub_efi_finish_boot_services) [__i386__ || __x86_64__]: Call
>> |       stop_broadcom if running on EFI.
>> |       * include/grub/pci.h (GRUB_PCI_CLASS_NETWORK): New enum value.
>> |       (GRUB_PCI_CAP_POWER_MANAGEMENT): Likewise.
>> |       (GRUB_PCI_VENDOR_BROADCOM): Likewise.
>> |       (grub_pci_find_capability): New proto.
>> |
>> |       Also-By: Vladimir Serbinenko <phcoder@gmail.com>
>> |
>> | M     ChangeLog
>> | M     grub-core/Makefile.am
>> | M     grub-core/Makefile.core.def
>> | M     grub-core/bus/pci.c
>> | M     grub-core/kern/efi/mm.c
>> | M     include/grub/pci.h
>>
>> But I run debian grub2-common 2.02~beta2-22+deb8u1 which has this fix
>> and I *still* get this irq issue
>>
>> ....
>> [  608.242849] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
>> with disabled ep ffff88008a19df48
>> [  608.242851] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called
>> with disabled ep ffff88008a19df90
>> [  608.254975] irq 17: nobody cared (try booting with the "irqpoll" option)
>> [  608.254979] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G         C O
>> 3.16.0-4-amd64 #1 Debian 3.16.7-ckt20-1+deb8u4
>> [  608.254981] Hardware name: Apple Inc.
>> MacBookPro10,1/Mac-C3EC7CD22292981F, BIOS
>> MBP101.88Z.00EE.B00.1205101839 05/10/2012
>> [  608.254985]  ffff88045a85bac4 ffffffff8150dcff ffff88045a85ba00
>> ffffffff810bd3ad
>> [  608.254987]  ffff88045a85ba00 0000000000000011 0000000000000000
>> ffffffff810bd8d1
>> [  608.254989]  0000000000000000 0000000000000000 0000000000000011
>> 0000000000000000
>> [  608.254990] Call Trace:
>> [  608.254999]  <IRQ>  [<ffffffff8150dcff>] ? dump_stack+0x41/0x51
>> [  608.255006]  [<ffffffff810bd3ad>] ? __report_bad_irq+0x2d/0xc0
>> [  608.255010]  [<ffffffff810bd8d1>] ? note_interrupt+0x241/0x290
>> [  608.255013]  [<ffffffff810bb0f1>] ? handle_irq_event_percpu+0xa1/0x190
>> [  608.255017]  [<ffffffff810bb218>] ? handle_irq_event+0x38/0x60
>> [  608.255020]  [<ffffffff810be413>] ? handle_fasteoi_irq+0x83/0x150
>> [  608.255025]  [<ffffffff810150cd>] ? handle_irq+0x1d/0x30
>> [  608.255029]  [<ffffffff81516cd9>] ? do_IRQ+0x49/0xe0
>> [  608.255033]  [<ffffffff81514b2d>] ? common_interrupt+0x6d/0x6d
>> [  608.255037]  <EOI>  [<ffffffff8108aded>] ?
>> __hrtimer_start_range_ns+0x1cd/0x390
>> [  608.255041]  [<ffffffff813dfd42>] ? cpuidle_enter_state+0x52/0xc0
>> [  608.255044]  [<ffffffff813dfd38>] ? cpuidle_enter_state+0x48/0xc0
>> [  608.255047]  [<ffffffff810a80d8>] ? cpu_startup_entry+0x2f8/0x400
>> [  608.255051]  [<ffffffff81903076>] ? start_kernel+0x497/0x4a2
>> [  608.255054]  [<ffffffff81902a04>] ? set_init_arg+0x4e/0x4e
>> [  608.255057]  [<ffffffff81902120>] ? early_idt_handler_array+0x120/0x120
>> [  608.255060]  [<ffffffff8190271f>] ? x86_64_start_kernel+0x14d/0x15c
>> [  608.255061] handlers:
>> [  608.255088] [<ffffffffa0645730>] azx_interrupt [snd_hda_controller]
>> [  608.255089] Disabling IRQ #17
>> [  608.354706] usb 1-2: reset high-speed USB device number 3 using xhci_hcd
>> ...

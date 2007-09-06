Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:24773 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXIFDyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 23:54:00 -0400
Received: by wa-out-1112.google.com with SMTP id v27so40064wah
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2007 20:54:00 -0700 (PDT)
Message-ID: <6b8cef970709052053l2711f3f6ye3704f0da569b86d@mail.gmail.com>
Date: Wed, 5 Sep 2007 23:53:59 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Kernel panic with rt2500pci built-in
In-Reply-To: <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, config can be found here:
http://www.healthcarelinen.com/misc/.config

On 9/5/07, Rob Hussey <robjhussey@gmail.com> wrote:
> Sorry hit enter before I was done typing, message continues:
>
> On 9/5/07, Rob Hussey <robjhussey@gmail.com> wrote:
> > I receive a kernel panic with rt2500pci built-in, but if built as a
> > module, I can insmod it without problem. I don't have a serial
> > console, and I tried to capture the panic with netconsole (using a
> > different interface of course) but the panic happens immediately after
> > rt2500pci is initialized, or in other words, too soon for netconsole.
> >
> > I'd rather not copy over everything unless necessary. Here's the first portion:
> >
> > ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 22 (level, low) -> IRQ 18
> > phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 0201, rf: 0003,
> > rev: 00000004
> > WARNING: at lib/kref.c:33 kref_get()
> > [<c0229da9>] kref_get+0x3d/0x44
>                             kobject_get
>                             kobject_shadow
>                             kobject_set_name
>                             device_add
>                             wiphy_register
>                             ieee80211_register_hw
>                             rt2x00lib_probe_dev
>                             rt2x00pci_probe
>                             pci_match_device
>                             pci_device_probe
>                             driver_probe_device
>                             klist_next
>                             __driver_attach
>                             bus_for_each_dev
>                             driver_attach
>                             __driver_attach
>                             bus_add_driver
>                             __pci_register_driver
>                             kernel_init
>
> ... can't type everything... skipping
>
> BUG: unable to handle kernel NULL pointer dereference at virtual
> address 00000024
> printing eip:
> c01a9966
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT SMP
> Modules linked in:
> CPU: 1
> EIP: 0060:[<c01a9966>] Not tainted VLI
> EIP is at sysfs_addrm_start+0x21/0x87
>
> skipping...
>
> Call Trace:
> create_dir
> sysfs_create_dir
> kobject_get
> kobject_shadow_add
> kobject_set_name
> device_add
> wiphy_register
> ieee80211_register_hw
> rt2x00lib_prove_dev
> rt2x00pci_probe
> pci_match_device
> pci_device_probe
> driver_probe_device
> klist_next
> __driver_attach
> bus_for_each_dev
> driver_attach
> __driver_attach
> bus_add_driver
> __pci_register_driver
> kernel_init
> schedule_tail
> ret_from_fork
> kernel_init
> kernel_init
> kernel_thread_helper
>
> ...
>
> Kernel panic - not syncing: Attempting to kill init!
>
>
> I likely left out important parts, if so, just tell me and I'll try to
> post them.
>

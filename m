Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426AbYDOJBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 05:01:07 -0400
Date: Tue, 15 Apr 2008 02:01:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	linux-acpi@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10455] New: Kernel lockup when iwl3945 modules
 is loaded after a few hours
Message-Id: <20080415020103.cd8e17f4.akpm@linux-foundation.org> (sfid-20080415_100112_538100_D09E6FDD)
In-Reply-To: <e2e108260804150139kf816be5m91e6206853a0d755@mail.gmail.com>
References: <bug-10455-10286@http.bugzilla.kernel.org/>
	<20080415013251.e90e5abd.akpm@linux-foundation.org>
	<e2e108260804150139kf816be5m91e6206853a0d755@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 15 Apr 2008 10:39:17 +0200 "Bart Van Assche" <bart.vanassche@gmail.com> wrote:

> On Tue, Apr 15, 2008 at 10:32 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >  > Latest working kernel version: (not known)
> >  > Earliest failing kernel version: 2.6.25-rc9
> >
> >  hm, why?  Has this machine never run earlier kernels?
> 
> 2.6.22-14 works fine on the same hardware. This is the kernel provided
> by Ubuntu.

OK, thanks, so it's a regression but we don't know if it's a post-2.6.25
regression.

> >  > Apr 14 21:06:00 localhost kernel: ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19
> >  > (level, low) -> IRQ 19
> >  > Apr 14 21:06:00 localhost kernel: ACPI: PCI interrupt for device 0000:05:00.0
> >  > disabled
> >
> >  Yes, that does look like an ACPI problem.  But one would expect it to kill
> >  the interface immediately, not several hours later.
> >
> >  Can you send the /proc/interrupts contents?
> 
> Here it is:
> 
>            CPU0       CPU1
>   0:     996478          0   IO-APIC-edge      timer
>   1:         30          0   IO-APIC-edge      i8042
>   8:          7          0   IO-APIC-edge      rtc
>   9:      57710          0   IO-APIC-fasteoi   acpi
>  12:        132          0   IO-APIC-edge      i8042
>  14:      31294      11519   IO-APIC-edge      ata_piix
>  15:      69158          0   IO-APIC-edge      ata_piix
>  16:      85016          0   IO-APIC-fasteoi   uhci_hcd:usb4,
> i915@pci:0000:00:02.0
>  18:      15921          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
>  21:      79770      60509   IO-APIC-fasteoi   eth0
>  22:       5811          0   IO-APIC-fasteoi   HDA Intel
>  23:          3          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5
> NMI:          0          0   Non-maskable interrupts
> LOC:        509     996926   Local timer interrupts
> RES:      29774      84400   Rescheduling interrupts
> CAL:         62      28154   function call interrupts
> TLB:        868       1262   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> SPU:          0          0   Spurious interrupts
> ERR:          0
> MIS:          0

hm, OK.

I'd suggest that you raise a separate report against
acpi_config-interrupts@kernel-bugs.osdl.org for this one - it does appear
to be unrelated, I think.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:2720 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYDOIjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 04:39:19 -0400
Received: by fg-out-1718.google.com with SMTP id l27so1912929fgb.17
        for <linux-wireless@vger.kernel.org>; Tue, 15 Apr 2008 01:39:18 -0700 (PDT)
Message-ID: <e2e108260804150139kf816be5m91e6206853a0d755@mail.gmail.com> (sfid-20080415_093925_598825_B3AB062E)
Date: Tue, 15 Apr 2008 10:39:17 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 10455] New: Kernel lockup when iwl3945 modules is loaded after a few hours
Cc: bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	linux-acpi@vger.kernel.org
In-Reply-To: <20080415013251.e90e5abd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <bug-10455-10286@http.bugzilla.kernel.org/>
	 <20080415013251.e90e5abd.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 15, 2008 at 10:32 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  > Latest working kernel version: (not known)
>  > Earliest failing kernel version: 2.6.25-rc9
>
>  hm, why?  Has this machine never run earlier kernels?

2.6.22-14 works fine on the same hardware. This is the kernel provided
by Ubuntu.

>  > Apr 14 21:06:00 localhost kernel: ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19
>  > (level, low) -> IRQ 19
>  > Apr 14 21:06:00 localhost kernel: ACPI: PCI interrupt for device 0000:05:00.0
>  > disabled
>
>  Yes, that does look like an ACPI problem.  But one would expect it to kill
>  the interface immediately, not several hours later.
>
>  Can you send the /proc/interrupts contents?

Here it is:

           CPU0       CPU1
  0:     996478          0   IO-APIC-edge      timer
  1:         30          0   IO-APIC-edge      i8042
  8:          7          0   IO-APIC-edge      rtc
  9:      57710          0   IO-APIC-fasteoi   acpi
 12:        132          0   IO-APIC-edge      i8042
 14:      31294      11519   IO-APIC-edge      ata_piix
 15:      69158          0   IO-APIC-edge      ata_piix
 16:      85016          0   IO-APIC-fasteoi   uhci_hcd:usb4,
i915@pci:0000:00:02.0
 18:      15921          0   IO-APIC-fasteoi   uhci_hcd:usb3
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 21:      79770      60509   IO-APIC-fasteoi   eth0
 22:       5811          0   IO-APIC-fasteoi   HDA Intel
 23:          3          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5
NMI:          0          0   Non-maskable interrupts
LOC:        509     996926   Local timer interrupts
RES:      29774      84400   Rescheduling interrupts
CAL:         62      28154   function call interrupts
TLB:        868       1262   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0

Bart.

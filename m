Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38292 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaIIUAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 16:00:54 -0400
Message-ID: <1410292835.4077.21.camel@hadess.net> (sfid-20140909_220059_527327_F8686903)
Subject: Re: Realtek GPIO chipset, for Baytrail?
From: Bastien Nocera <hadess@hadess.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 09 Sep 2014 22:00:35 +0200
In-Reply-To: <540F54B1.8040409@lwfinger.net>
References: <1410256608.4077.7.camel@hadess.net>
	 <540F54B1.8040409@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-09-09 at 14:27 -0500, Larry Finger wrote:
> On 09/09/2014 04:56 AM, Bastien Nocera wrote:
> > Hey,
> >
> > I have a tablet that seems to be using Realtek chips to do wireless
> > communications (hopefully, this time I won't be wrong[1]).
> >
> > The device, under the gpio class in /sys, shows with a modalias of
> > "acpi:OBDA8723:" (that's on "O", not "0"). This seems to correspond to a
> > Realtek chipset (Larry tells me it matches the PCI ID of 0bda:8723 for
> > the RTL8723AE chipset).
> >
> > It shows up under:
> > /sys/devices/platform/80860F0A:00/subsystem/devices
> >
> > Does anyone have details on how this chipset is actually hooked up? Can
> > a portion of the existing RTL8723AE driver code be reused?
> 
> Bastien,
> 
>  From the previous response, it seems unlikely that GPIO is used to control the 
> device. That is what I expected. Working at that primitive level would be 
> extremely difficult timing.

Right.

> I assume that you have checked both 'lspci' and 'lsusb' for any mention of the 
> wireless device.

No mentions at all in there.

>  I am not aware of a similar utility to scan an SDIO bus, but 
> perhaps someone on this list will know.

They would show up under /sys/bus/sdio/devices/ and there's nothing in
there except the SD card reader.

>  In addition, a full listing of 'lspci 
> -nnv' will give a clue regarding what adapters are on the device.

Here it is, I doubt that's much help.

00:00.0 Host bridge [0600]: Intel Corporation Atom Processor Z36xxx/Z37xxx Series SoC Transaction Register [8086:0f00] (rev 0d) 
        Subsystem: Intel Corporation Device [8086:0f31]
        Flags: bus master, fast devsel, latency 0
        Kernel driver in use: iosf_mbi_pci
        Kernel modules: iosf_mbi

00:02.0 VGA compatible controller [0300]: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Graphics & Display [8086:0f31] (rev 0d) (prog-if 00 [VGA controller])
        Subsystem: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Graphics & Display [8086:0f31]
        Flags: bus master, fast devsel, latency 0, IRQ 106 
        Memory at a0000000 (32-bit, non-prefetchable) [size=4M]
        Memory at 80000000 (32-bit, prefetchable) [size=512M]
        I/O ports at 1000 [size=8]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: <access denied>
        Kernel driver in use: i915
        Kernel modules: i915

00:14.0 USB controller [0c03]: Intel Corporation Atom Processor Z36xxx/Z37xxx Series USB xHCI [8086:0f35] (rev 0d) (prog-if 30 [XHCI])
        Subsystem: Intel Corporation Atom Processor Z36xxx/Z37xxx Series USB xHCI [8086:0f35]
        Flags: bus master, medium devsel, latency 0, IRQ 104 
        Memory at a0800000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: <access denied>
        Kernel driver in use: xhci_hcd

00:1a.0 Encryption controller [1080]: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Trusted Execution Engine [8086:0f18] (rev 0d) 
        Subsystem: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Trusted Execution Engine [8086:0f18]
        Flags: bus master, fast devsel, latency 0, IRQ 107 
        Memory at a0700000 (32-bit, non-prefetchable) [size=1M]
        Memory at a0600000 (32-bit, non-prefetchable) [size=1M]
        Capabilities: <access denied>
        Kernel driver in use: mei_txe
        Kernel modules: mei_txe

00:1f.0 ISA bridge [0601]: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Power Control Unit [8086:0f1c] (rev 0d) 
        Subsystem: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Power Control Unit [8086:0f1c]
        Flags: bus master, medium devsel, latency 0
        Capabilities: <access denied>
        Kernel driver in use: pmc_atom
        Kernel modules: lpc_ich


> If the device were used with SDIO, then it would be known as the RTL8723AS. I 
> could not find that chip, but there is an RTL8723BS with a 32-bit driver for 
> Windows 8.1.

That sounds like it could be that one then. This is the only info I
have, the (very generic) driver set for Windows (which seems to have
support for every variant) and the DSDT:
https://bugzilla.kernel.org/attachment.cgi?id=149331

The Bluetooth device has a firmware named "rtl8723b_config.bin"

> What specific Baytrail tablet do you have?

The Onda v975w. It came with Windows 8.1 32-bit.

I guess that the device is probably a PCI one, but the enumeration is
done through ACPI instead of "normal" PCI.

Cheers


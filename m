Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41980 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaIIVWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 17:22:12 -0400
References: <1410256608.4077.7.camel@hadess.net> <540F54B1.8040409@lwfinger.net> <1410292835.4077.21.camel@hadess.net> <540F61FE.2050404@lwfinger.net>
Mime-Version: 1.0 (1.0)
In-Reply-To: <540F61FE.2050404@lwfinger.net>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <7234781D-5B78-404A-B945-D090938777C7@hadess.net> (sfid-20140909_232217_167464_F18D2B39)
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Bastien Nocera <hadess@hadess.net>
Subject: Re: Realtek GPIO chipset, for Baytrail?
Date: Tue, 9 Sep 2014 23:22:06 +0200
To: Larry Finger <Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On 9 Sep 2014, at 22:24, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> On 09/09/2014 03:00 PM, Bastien Nocera wrote:
>>> On Tue, 2014-09-09 at 14:27 -0500, Larry Finger wrote:
>>>> On 09/09/2014 04:56 AM, Bastien Nocera wrote:
>>>> Hey,
>>>> 
>>>> I have a tablet that seems to be using Realtek chips to do wireless
>>>> communications (hopefully, this time I won't be wrong[1]).
>>>> 
>>>> The device, under the gpio class in /sys, shows with a modalias of
>>>> "acpi:OBDA8723:" (that's on "O", not "0"). This seems to correspond to a
>>>> Realtek chipset (Larry tells me it matches the PCI ID of 0bda:8723 for
>>>> the RTL8723AE chipset).
>>>> 
>>>> It shows up under:
>>>> /sys/devices/platform/80860F0A:00/subsystem/devices
>>>> 
>>>> Does anyone have details on how this chipset is actually hooked up? Can
>>>> a portion of the existing RTL8723AE driver code be reused?
>>> 
>>> Bastien,
>>> 
>>>  From the previous response, it seems unlikely that GPIO is used to control the
>>> device. That is what I expected. Working at that primitive level would be
>>> extremely difficult timing.
>> 
>> Right.
>> 
>>> I assume that you have checked both 'lspci' and 'lsusb' for any mention of the
>>> wireless device.
>> 
>> No mentions at all in there.
>> 
>>>  I am not aware of a similar utility to scan an SDIO bus, but
>>> perhaps someone on this list will know.
>> 
>> They would show up under /sys/bus/sdio/devices/ and there's nothing in
>> there except the SD card reader.
>> 
>>>  In addition, a full listing of 'lspci
>>> -nnv' will give a clue regarding what adapters are on the device.
>> 
>> Here it is, I doubt that's much help.
>> 
>> 00:00.0 Host bridge [0600]: Intel Corporation Atom Processor Z36xxx/Z37xxx Series SoC Transaction Register [8086:0f00] (rev 0d)
>>         Subsystem: Intel Corporation Device [8086:0f31]
>>         Flags: bus master, fast devsel, latency 0
>>         Kernel driver in use: iosf_mbi_pci
>>         Kernel modules: iosf_mbi
>> 
>> 00:02.0 VGA compatible controller [0300]: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Graphics & Display [8086:0f31] (rev 0d) (prog-if 00 [VGA controller])
>>         Subsystem: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Graphics & Display [8086:0f31]
>>         Flags: bus master, fast devsel, latency 0, IRQ 106
>>         Memory at a0000000 (32-bit, non-prefetchable) [size=4M]
>>         Memory at 80000000 (32-bit, prefetchable) [size=512M]
>>         I/O ports at 1000 [size=8]
>>         Expansion ROM at <unassigned> [disabled]
>>         Capabilities: <access denied>
>>         Kernel driver in use: i915
>>         Kernel modules: i915
>> 
>> 00:14.0 USB controller [0c03]: Intel Corporation Atom Processor Z36xxx/Z37xxx Series USB xHCI [8086:0f35] (rev 0d) (prog-if 30 [XHCI])
>>         Subsystem: Intel Corporation Atom Processor Z36xxx/Z37xxx Series USB xHCI [8086:0f35]
>>         Flags: bus master, medium devsel, latency 0, IRQ 104
>>         Memory at a0800000 (64-bit, non-prefetchable) [size=64K]
>>         Capabilities: <access denied>
>>         Kernel driver in use: xhci_hcd
>> 
>> 00:1a.0 Encryption controller [1080]: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Trusted Execution Engine [8086:0f18] (rev 0d)
>>         Subsystem: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Trusted Execution Engine [8086:0f18]
>>         Flags: bus master, fast devsel, latency 0, IRQ 107
>>         Memory at a0700000 (32-bit, non-prefetchable) [size=1M]
>>         Memory at a0600000 (32-bit, non-prefetchable) [size=1M]
>>         Capabilities: <access denied>
>>         Kernel driver in use: mei_txe
>>         Kernel modules: mei_txe
>> 
>> 00:1f.0 ISA bridge [0601]: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Power Control Unit [8086:0f1c] (rev 0d)
>>         Subsystem: Intel Corporation Atom Processor Z36xxx/Z37xxx Series Power Control Unit [8086:0f1c]
>>         Flags: bus master, medium devsel, latency 0
>>         Capabilities: <access denied>
>>         Kernel driver in use: pmc_atom
>>         Kernel modules: lpc_ich
>> 
>> 
>>> If the device were used with SDIO, then it would be known as the RTL8723AS. I
>>> could not find that chip, but there is an RTL8723BS with a 32-bit driver for
>>> Windows 8.1.
>> 
>> That sounds like it could be that one then. This is the only info I
>> have, the (very generic) driver set for Windows (which seems to have
>> support for every variant) and the DSDT:
>> https://bugzilla.kernel.org/attachment.cgi?id=149331
>> 
>> The Bluetooth device has a firmware named "rtl8723b_config.bin"
>> 
>>> What specific Baytrail tablet do you have?
>> 
>> The Onda v975w. It came with Windows 8.1 32-bit.
>> 
>> I guess that the device is probably a PCI one, but the enumeration is
>> done through ACPI instead of "normal" PCI.
> 
> In http://www.onda-tablet.com/onda-v975w-quad-core-win-8-tablet-9-7-inch-retina-screen-ram-2gb-wifi-32gb.html, someone is specifically looking for an RTL8723BS driver.

That's helpful.

> I will see if my contact at Realtek knows who has worked on drivers for this device, and if it would be possible to use rtl8723be if we were to supply an SDIO frontend.

I'm not sure why the device doesn't show up in the sysfs tree, but maybe it needs a driver bound to it to show up.

> If I were to find code, do you have the possibility to build drivers for the device?

Certainly. I've already made attempts at getting a working touchscreen driver and I have a patch for the accelerometer.

Thanks for the detective work :)

Cheers
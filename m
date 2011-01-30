Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62020 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1A3Sux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 13:50:53 -0500
Message-ID: <4D45B338.8010802@lwfinger.net>
Date: Sun, 30 Jan 2011 12:51:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: linux-wireless@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: Rfkill always soft/hard blocked upon boot
References: <4D455DC1.6010909@pardus.org.tr>
In-Reply-To: <4D455DC1.6010909@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2011 06:46 AM, Ozan Çağlayan wrote:
> Hi,
> 
> How to fix or debug the $subject? You always have to press Fn+F2 to hard
> unblock the rfkill after every boot on a local brand laptop.
> 
> If the rfkill switch is really a switch which can be toggled on/off,
> this makes sense. If you keep it Off, it will come as blocked. But it
> seems that on this machine Fn+F2 controls the hard block state.
> 
> It should either be saved in somewhere (I've read that there is a
> persistent knob for rfkill drivers in sysfs which tells whether the
> state is kept in a non-volatile space across boots or not) or all soft
> and this kind of Fn+Fx hard blocks should be explicitly disabled by
> kernel during boots.
> 
> I don't have direct access to the machine but the owner will help if you
> need any output, etc.
> 
> After booting:
> 
> 0: hci0: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 1: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: yes
> 
> After pressing Fn+F2:
> 0: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 1: hci0: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 
> 03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless
> Network Adapter (PCI-Express) (rev 01)
>         Subsystem: Device 1a3b:1089
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at f1d00000 (64-bit, non-prefetchable) [size=64K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
>         Capabilities: [60] Express Legacy Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Virtual Channel
>         Capabilities: [160] Device Serial Number 00-15-17-ff-ff-24-14-12
>         Capabilities: [170] Power Budgeting <?>
>         Kernel driver in use: ath9k
>         Kernel modules: ath9k
> 
> This is on 2.6.37. I'm waiting for the dmesg output.

The nature of that Fn-F2 key depends on how the motherboard manufacturer coded
their BIOS. Most do it as a toggle and use some WMI (Windows Management
Interface) code to initialize it on boot up. As this no-name laptop is unlikely
to have a WMI driver the way that name brands do, it probably generates a
keystroke. That is easy to check - Use CTRL-ALT-F1 to switch to a console, log
in, and issue the command "showkey". Is a keycode returned when Fn-F2 is pressed?

If the button does generate a key event, then adding a command to generate this
key in a script that is executed after bootup should solve the problem. I don't
know the command you need, but I'm sure someone will. Where to put that command
will depend on your distro.

Larry

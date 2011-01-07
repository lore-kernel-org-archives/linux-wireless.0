Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47997 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1AGLEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 06:04:46 -0500
Received: by qwa26 with SMTP id 26so17669897qwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 03:04:46 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTik8nfAFF=OhG1EqzJYkYMh+ds1igRgngLArVswC@mail.gmail.com>
References: <AANLkTimekYjYh7uZ3enOQ+zX2_dpA25Zy0aATCDzw521@mail.gmail.com>
	<AANLkTimYBb-hqWWtPpQVnVQ2ifemQbAvOBnKSUxM_jsJ@mail.gmail.com>
	<AANLkTik8nfAFF=OhG1EqzJYkYMh+ds1igRgngLArVswC@mail.gmail.com>
Date: Fri, 7 Jan 2011 12:04:45 +0100
Message-ID: <AANLkTikqJfYgsv=z62bwESeccnYydsbJ842sk3+XBgcB@mail.gmail.com>
Subject: Re: Question about ep-n8508
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Damian Minkov <damencho@sip-communicator.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 7, 2011 at 11:32 AM, Damian Minkov
<damencho@sip-communicator.org> wrote:
> Hi,
>
> On Fri, Jan 7, 2011 at 11:11 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> On Fri, Jan 7, 2011 at 9:06 AM, Damian Minkov
>> <damencho@sip-communicator.org> wrote:
>>> Hi,
>>>
>>> I recently bought the device EDUP ep-n8508 but I have problems running
>>> it under Ubuntu 10.10, kernel: 2.6.35-24-generic x86_64.
>>> I tried with the drivers provided on the CD coming with the device
>>> (rtl8192CU_linux_v2.0.939.20100726) have no problem compiling and
>>> installing. But after loading the module no network device appears and
>>> a lot of "usb write TimeOut!" in the messages.
>>> Then I tried with latest driver edition from realtek website -
>>> rtl8192CU_linux_v2.0.1212.20101208. Again with same result.
>>> Here is all the output: http://pastebin.com/7xhkzYNC.
>>> I saw there is a similar thread, with similar problems "Question about
>>> Edimax 7811Un", but as I'm new to the list didn't manage to continue
>>> that thread.
>>>
>>> Seems a problem with amd64 systems. Is there any workaround? Anything
>>> I can further test to help figuring this out?
>>>
>>> Thanks in advance
>>> damencho
>>
>> First of all, please do not refer to pastebin-URLs as they have a
>> limited life-cycle.
>> A full dmesg and an output of lspci is much more appreciated, so
>> interested people can look at it.
>>
>> - Sedat -
>>
>
> sorry for the pastebin, here are lspci and dmesg prints:
>
> # lspci
> 00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory
> Controller Hub (rev 03)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile
> GM965/GL960 Integrated Graphics Controller (rev 03)
> 00:02.1 Display controller: Intel Corporation Mobile GM965/GL960
> Integrated Graphics Controller (rev 03)
> 00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
> UHCI Controller #4 (rev 03)
> 00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
> UHCI Controller #5 (rev 03)
> 00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
> EHCI Controller #2 (rev 03)
> 00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
> Controller (rev 03)
> 00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
> Port 1 (rev 03)
> 00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
> Port 5 (rev 03)
> 00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
> Port 6 (rev 03)
> 00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
> UHCI Controller #1 (rev 03)
> 00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
> UHCI Controller #2 (rev 03)
> 00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
> UHCI Controller #3 (rev 03)
> 00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
> EHCI Controller #1 (rev 03)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
> 00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface
> Controller (rev 03)
> 00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
> IDE Controller (rev 03)
> 00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
> SATA IDE Controller (rev 03)
> 00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
> 02:00.0 Network controller: Broadcom Corporation BCM4321 802.11a/b/g/n (rev 03)
> 03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8058
> PCI-E Gigabit Ethernet Controller (rev 13)
> 04:03.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 61)
>

lspci shows BCM4321 device but no rtl8192CU.
Is that USB?
Then try with lsusb command and check by yourself (by reading the
output) if there is EDUP ep-n8508 (rtl8192CU) listed or not.
People on this list are interested in the vendor-id and product-id/modell-id.
In my case it is: 168c (vendor-id) and 1014 (product-id).

$ lspci -nnvv | grep "Ethernet controller" | grep Atheros
02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
802.11abg NIC [168c:1014] (rev 01)

"Full dmesg" means give us the output from the very first lines where
your kernel boots up, not truncated or extracted.

You should see sth. like this (first 10 lines, your output might differ):

$ dmesg | head -10
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.37-next20110107.dileks.1-686-iniza
(Debian 2.6.37-2~next20110107.dileks.1) (sedat.dilek@gmail.com) (gcc
version 4.5.2 (Debian 4.5.2-1) ) #1 SMP Fri Jan 7 07:52:57 CET 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ff60000 (usable)
[    0.000000]  BIOS-e820: 000000003ff60000 - 000000003ff77000 (ACPI data)

Best is you reboot and do 'dmesg > /tmp/dmesg.txt'.

- Sedat -

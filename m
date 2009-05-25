Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60952 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751519AbZEYUez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 16:34:55 -0400
Message-ID: <4A1B00E7.5070801@gmx.net>
Date: Mon, 25 May 2009 22:34:47 +0200
From: Barkle <barkle@gmx.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL 8185
References: <4A199FED.7000609@gmx.net> <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>
In-Reply-To: <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010105060603010809080408"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010105060603010809080408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hin-Tak Leung schrieb:
> On Sun, May 24, 2009 at 8:28 PM, Barkle <barkle@gmx.net> wrote:
>   
>> Hi,
>>
>> I have a pci-card with a RTL8185 chip.
>> [01:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8185 IEEE
>> 802.11a/b/g Wireless LAN Controller (rev 20)]
>>
>> Base on a Debian Lenny with
>> kernel 2.6.30-rc5
>> wpasupplicant v0.6.9
>> wireless_tools 30
>>
>> I can change some parameter on the card with iwconfig, for example the
>> channel, but every time I try to get the card to work, the kernel freeze.
>>
>> Now I´m not sure, if this mailinglist is the right one, because it may be a
>> problem of the hardware, the kernel or some userland tools.
>>
>> If you need any additional information, please ask me an I try to answer
>> asap.
>>     
>
> Yes, this is the right list - a few things:
> 1) dmesg should show a few line of info, including a line like this:
>
> wlan0: hwaddr XX:XX:XX:XX;XX:XX <chip_name> + <rf_type>
>
> we need at least that line, and anything else that's relevant in dmesg.
>   

Have a look in the appended file "dmesg_2009-05-25.txt" and it's not 
wlan0, it's phy0.
I hope, I haven't cut off too much .

> 2) what do you mean by 'kernel freeze'?

There is no more reaktion, no change by pressing num-lock, caps-lock or 
scroll-lock. No answer on a ping. What I didn't tested is the "magic SysRq".

The computer should work as a server, only with the minimalistic program 
installt. So there is no X11

> do you get a pile of cryptic messages before

No, just no reaktion.

> Also, describe what exactly did you try to do, step by step.
>   

After booting the system a call of the following line is enough:

wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf 
-W -dd

The result is:
***************************************
~# wpa_supplicant -Dwext -iwlan0 
-c/etc/wpa_supplicant/wpa_supplicant.conf -W -dd
Initializing interface 'wlan0' conf 
'/etc/wpa_supplicant/wpa_supplicant.conf' driver 'wext' ctrl_interface 
'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant/wpa_supplicant.conf' -> 
'/etc/wpa_supplicant/wpa_supplicant.conf'
Reading configuration file '/etc/wpa_supplicant/wpa_supplicant.conf'
ctrl_interface='/var/run/wpa_supplicant'
ctrl_interface_group='0'
eapol_version=2
Line: 7 - start of a new network block
ssid - hexdump_ascii(len=10):
     54 65 73 74 5f 44 75 6d 6d 79                     Test_Dummy
mode=1 (0x1)
key_mgmt: 0x4
Priority group 0
   id=0 ssid='Test_Dummy'
Initializing interface (2) 'wlan0'
***************************************

And the the system doesn't react anymore. It the same as when the 
inteface is brought up by the ifupdown.

No entry in the syslog
***************************************
May 25 21:17:26 feta dhclient: DHCPREQUEST on eth0 to 192.168.42.25 port 67
May 25 21:17:26 feta dhclient: DHCPACK from 192.168.42.25
May 25 21:17:26 feta dhclient: bound to 192.168.42.29 -- renewal in 
14223 seconds.
May 25 22:20:15 feta kernel: imklog 3.18.6, log source = /proc/kmsg started.
May 25 22:20:15 feta kernel: Linux version 2.6.30-rc5-1 (root@feta) (gcc 
version 4.3.2 (Debian 4.3.2-1.1) ) #1 PREEMPT Mon May 11 00:13:36 CEST 2009
May 25 22:20:15 feta kernel: KERNEL supported cpus:
May 25 22:20:15 feta kernel:  Intel GenuineIntel
***************************************


> 3) have you tried compat-wireless? compat-wireless is ahead of
> 2.6.30-rcX and occasionally have fixes to bugs which creeps into the
> rc's..


OK, no I didn't tried the compat-wireless so far..
It will take a while, when I got an result of the change.


Thanks so long

--------------010105060603010809080408
Content-Type: text/plain;
 name="dmesg_2009-05-25.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_2009-05-25.txt"

Linux version 2.6.30-rc5-1 (root@feta) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 PREEMPT Mon May 11 00:13:36 CEST 2009
[...]
Using APIC driver default
ACPI: PM-Timer IO Port: 0xf008
Local APIC disabled by BIOS -- you can enable it with "lapic"
nr_irqs_gsi: 16
Allocating PCI resources starting at 20000000 (gap: 10000000:eff00000)
[...]
ACPI: Core revision 20090320
ACPI: setting ELCR to 0200 (from 0e80)
net_namespace: 520 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd96e, last bus=1
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xf8000000-0xfbffffff]
pci 0000:00:02.0: reg 14 32bit mmio: [0xf4000000-0xf407ffff]
pci 0000:00:1f.0: quirk: region f000-f07f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region f180-f1bf claimed by ICH4 GPIO
pci 0000:00:1f.1: reg 20 io port: [0x1000-0x100f]
pci 0000:00:1f.2: reg 20 io port: [0x1400-0x141f]
pci 0000:00:1f.3: reg 20 io port: [0x1800-0x180f]
pci 0000:01:07.0: reg 10 io port: [0x2000-0x20ff]
pci 0000:01:07.0: reg 14 32bit mmio: [0xf4100000-0xf41001ff]
pci 0000:01:07.0: supports D1 D2
pci 0000:01:07.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:01:07.0: PME# disabled
pci 0000:01:09.0: reg 10 io port: [0x2400-0x247f]
pci 0000:01:09.0: reg 14 32bit mmio: [0xf4100400-0xf410047f]
pci 0000:01:09.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:09.0: supports D1 D2
pci 0000:01:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:09.0: PME# disabled
pci 0000:01:0b.0: reg 10 32bit mmio: [0xf5000000-0xf5ffffff]
pci 0000:01:0b.2: reg 10 32bit mmio: [0xf6000000-0xf6ffffff]
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xf4100000-0xf6ffffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIH._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0xf000-0xf07f has been reserved
system 00:02: ioport range 0xf100-0xf10f has been reserved
system 00:02: ioport range 0xf180-0xf1bf has been reserved
system 00:02: ioport range 0x800-0x87f has been reserved
system 00:02: ioport range 0xf820-0xf82f has been reserved
system 00:02: ioport range 0xfe00-0xfe00 has been reserved
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
pci 0000:00:1e.0:   MEM window: 0xf4100000-0xf6ffffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000020000000-0x000000200fffff
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:01: resource 1 mem: [0xf4100000-0xf6ffffff]
pci_bus 0000:01: resource 2 pref mem [0x20000000-0x200fffff]
pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffff]
[..]
TCP cubic registered
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
Using IPI Shortcut mode
[...]
NET: Registered protocol family 1
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 7
PCI: setting IRQ 7 as level-triggered
3c59x 0000:01:09.0: PCI INT A -> Link[LNKC] -> GSI 7 (level, low) -> IRQ 7
3c59x: Donald Becker and others.
0000:01:09.0: 3Com PCI 3c905C Tornado at d0776400.
ide-cd driver 5.00
ide-cd: hdc: ATAPI 48X CD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
rtl8180 0000:01:07.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
phy0: Selected rate control algorithm 'minstrel'
phy0: hwaddr 00:0e:2e:e9:b5:fd, RTL8185vD + rtl8225z2
[...]
eth0:  setting full-duplex.
NET: Registered protocol family 17

--------------010105060603010809080408
Content-Type: text/plain;
 name="wpa_supplicant.conf_2009-05-25"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wpa_supplicant.conf_2009-05-25"

ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=0
eapol_version=2
network={
  ssid="Test_Dummy"
  mode=1
  key_mgmt=NONE
}

--------------010105060603010809080408--

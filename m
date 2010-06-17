Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45419 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab0FQMNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 08:13:46 -0400
Received: by bwz7 with SMTP id 7so3372047bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 05:13:45 -0700 (PDT)
Message-ID: <4C1A1175.7010708@googlemail.com>
Date: Thu, 17 Jun 2010 14:13:41 +0200
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Subject: Re: "ressource temporarily unavailable" on 2.4 GHz, not on 5GHz
References: <4C18DA3D.1030303@googlemail.com> <AANLkTimtZBRfkAOnz2vPXp71Z03DfPQniY2qFHCsgI44@mail.gmail.com>
In-Reply-To: <AANLkTimtZBRfkAOnz2vPXp71Z03DfPQniY2qFHCsgI44@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050402070403060300060600"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050402070403060300060600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hey guys!

I just reproduced the error with a transmit frequency of 4ms and dmesg
doesn't show up with any new output. I will append dmesg to this mail
anyway.

Apart from that, I will go ahead and search for handling EAGAIN.

Kind regards,
Dennis


Bob Copeland schrieb:
> On Wed, Jun 16, 2010 at 10:05 AM, Dennis Borgmann
> <dennis.borgmann@googlemail.com> wrote:
>   
>> Hello wireless-list!
>> Hello hostapd-list!
>>
>> I am using ath5k with hostapd-0.6.9 on a debian running kernel 2.6.34
>> and I am observing a "ressource temporarily unavailable" - error code 11
>>     
> [...]
>   
>> What could be the problem? Is this due to backoff-times in 2.4 GHz, that
>> don't occur on 5 GHz? Or could this be a bug?
>>     
>
> Does dmesg report any error (e.g. no available txbuf)?
>
> My guess is you have more frequent successful delivery in 5 GHz than in
> ISM band so you aren't running out of send buffers somewhere in the stack.
>
> Of course, your program should expect and handle EAGAIN if you are
> using MSG_DONTWAIT.
>
>   


--------------050402070403060300060600
Content-Type: text/plain;
 name="dmesg_output"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_output"

Linux version 2.6.34 (root@debian_DEV) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 PREEMPT Tue Jun 15 15:51:31 CEST 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
 BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000ffc0000 (usable)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
DMI not present or invalid.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0xffc0 max_arch_pfn = 0x100000
initial memory mapped : 0 - 00800000
init_memory_mapping: 0000000000000000-000000000ffc0000
 0000000000 - 0000400000 page 4k
 0000400000 - 000fc00000 page 2M
 000fc00000 - 000ffc0000 page 4k
kernel direct mapping tables up to ffc0000 @ 7000-c000
RAMDISK: 0be27000 - 0c010000
255MB LOWMEM available.
  mapped low ram: 0 - 0ffc0000
  low ram: 0 - 0ffc0000
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  Normal   0x00001000 -> 0x0000ffc0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000001 -> 0x0000009e
    0: 0x00000100 -> 0x0000ffc0
On node 0 totalpages: 65373
free_area_init_node: node 0, pgdat c03ff584, node_mem_map c1000020
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3965 pages, LIFO batch:0
  Normal zone: 480 pages used for memmap
  Normal zone: 60896 pages, LIFO batch:15
Using APIC driver default
No local APIC present or hardware disabled
APIC: disable apic facility
APIC: switched to apic NOOP
nr_irqs_gsi: 16
Allocating PCI resources starting at ffc0000 (gap: ffc0000:f0030000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64861
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.34 root=UUID=a085012f-0fc3-4a20-901c-0b4794889335 ro
PID hash table entries: 1024 (order: 0, 4096 bytes)
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Initializing CPU#0
Subtract (21 early reservations)
  #0 [0000100000 - 000045ece0]   TEXT DATA BSS
  #1 [000be27000 - 000c010000]         RAMDISK
  #2 [000009e000 - 0000100000]   BIOS reserved
  #3 [000045f000 - 0000461000]             BRK
  #4 [0000007000 - 0000008000]         PGTABLE
  #5 [0001000000 - 0001200000]         BOOTMEM
  #6 [0001200000 - 0001200004]         BOOTMEM
  #7 [0001200040 - 00012000c0]         BOOTMEM
  #8 [00012000c0 - 00012000d8]         BOOTMEM
  #9 [0001200100 - 0001200900]         BOOTMEM
  #10 [0001200900 - 00012009a8]         BOOTMEM
  #11 [00012009c0 - 0001200a00]         BOOTMEM
  #12 [0001200a00 - 0001200a40]         BOOTMEM
  #13 [0001200a40 - 0001200a80]         BOOTMEM
  #14 [0001200a80 - 0001200ac0]         BOOTMEM
  #15 [0001200ac0 - 0001200b00]         BOOTMEM
  #16 [0001200b00 - 0001200b52]         BOOTMEM
  #17 [0001200b80 - 0001200bd2]         BOOTMEM
  #18 [0001200c00 - 0001201c00]         BOOTMEM
  #19 [0001201c00 - 0001221c00]         BOOTMEM
  #20 [0001221c00 - 0001231c00]         BOOTMEM
Memory: 253824k/261888k available (2172k kernel code, 7668k reserved, 909k data, 240k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa4000 - 0xfffff000   ( 364 kB)
    vmalloc : 0xd07c0000 - 0xfffa2000   ( 759 MB)
    lowmem  : 0xc0000000 - 0xcffc0000   ( 255 MB)
      .init : 0xc0403000 - 0xc043f000   ( 240 kB)
      .data : 0xc031f2e1 - 0xc04027c0   ( 909 kB)
      .text : 0xc0100000 - 0xc031f2e1   (2172 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Experimental preemptable hierarchical RCU implementation.
NR_IRQS:288
Console: colour dummy device 80x25
console [tty0] enabled
Fast TSC calibration using PIT
Detected 498.049 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 996.09 BogoMIPS (lpj=498049)
Mount-cache hash table entries: 512
Performance Events: no PMU driver, software events only.
CPU: Geode(TM) Integrated Processor by AMD PCS stepping 02
Checking 'hlt' instruction... OK.
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfafc0, last bus=0
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:01.0: reg 10: [io  0xac1c-0xac1f]
pci 0000:00:01.2: reg 10: [mem 0xefff8000-0xefffbfff]
pci 0000:00:09.0: reg 10: [io  0xfc00-0xfcff]
pci 0000:00:09.0: reg 14: [mem 0xeffff000-0xeffff0ff]
pci 0000:00:09.0: supports D1 D2
pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0c.0: reg 10: [mem 0xeffe0000-0xeffeffff]
pci 0000:00:0f.0: reg 10: [io  0x6000-0x6007]
pci 0000:00:0f.0: reg 14: [io  0x6100-0x61ff]
pci 0000:00:0f.0: reg 18: [io  0x6200-0x623f]
pci 0000:00:0f.0: reg 1c: [io  0x0000-0x001f]
pci 0000:00:0f.0: reg 20: [io  0x9d00-0x9d7f]
pci 0000:00:0f.0: reg 24: [io  0x9c00-0x9c3f]
pci 0000:00:0f.2: reg 20: [io  0xff00-0xff0f]
pci 0000:00:0f.3: reg 10: [io  0xfe00-0xfe7f]
pci 0000:00:0f.4: reg 10: [mem 0xefffe000-0xefffefff]
pci 0000:00:0f.4: PME# supported from D0 D3hot D3cold
pci 0000:00:0f.4: PME# disabled
pci 0000:00:0f.5: reg 10: [mem 0xefffd000-0xefffdfff]
pci 0000:00:0f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:0f.5: PME# disabled
PCI: pci_cache_line_size set to 32 bytes
reserve RAM buffer: 000000000009e800 - 000000000009ffff 
reserve RAM buffer: 000000000ffc0000 - 000000000fffffff 
Switching to clocksource tsc
pci 0000:00:0f.0: BAR 3: assigned [io  0x1000-0x101f]
pci 0000:00:0f.0: BAR 3: set to [io  0x1000-0x101f] (PCI address [0x1000-0x101f]
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
PCI: CLS 32 bytes, default 32
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 1956k freed
platform rtc_cmos: registered platform RTC device (no PNP device found)
msgmni has been set to 499
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler cfq registered (default)
Serial: 8250/16550 driver, 2 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:0f.2: UDMA100 controller
amd74xx 0000:00:0f.2: IDE controller (0x1022:0x209a rev 0x01)
amd74xx 0000:00:0f.2: IDE port disabled
amd74xx 0000:00:0f.2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xff00-0xff07
Probing IDE interface ide0...
hda: CF CARD 2GB, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO2
hda: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 128KiB
hda: 3964464 sectors (2029 MB) w/1KiB Cache, CHS=3933/16/63
 hda: hda1 hda2
ide-cd driver 5.00
i8042.c: Can't read CTR while initializing i8042.
i8042: probe of i8042 failed with error -5
mice: PS/2 mouse device common for all mice
padlock: VIA PadLock not detected.
padlock: VIA PadLock Hash Engine not detected.
geode-aes: GEODE AES engine enabled.
TCP cubic registered
NET: Registered protocol family 17
Bridge firewalling registered
Using IPI Shortcut mode
Freeing unused kernel memory: 240k freed
Clocksource tsc unstable (delta = 878871247 ns)
Switching to clocksource pit
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
via-rhine 0000:00:09.0: setting latency timer to 64
eth0: VIA Rhine III (Management Adapter) at 0xeffff000, 00:0d:b9:19:98:b4, IRQ 11.
eth0: MII PHY found at address 1, status 0x7869 advertising 05e1 Link 45e1.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:0f.5: setting latency timer to 64
ehci_hcd 0000:00:0f.5: EHCI Host Controller
ehci_hcd 0000:00:0f.5: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0f.5: irq 5, io mem 0xefffd000
ehci_hcd 0000:00:0f.5: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:0f.4: setting latency timer to 64
ohci_hcd 0000:00:0f.4: OHCI Host Controller
ohci_hcd 0000:00:0f.4: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0f.4: irq 5, io mem 0xefffe000
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
udev: renamed network interface eth0 to eth1
udevd version 125 started
cs5535_gpio: base=0x6100 mask=0xb003c66 major=254
cfg80211: Calling CRDA to update world regulatory domain
ath5k 0000:00:0c.0: registered as 'phy0'
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
phy0: Selected rate control algorithm 'minstrel'
ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
cfg80211: Calling CRDA for country: US
cs5535audio 0000:00:0f.3: setting latency timer to 64
udev: renamed network interface wlan0 to wlan2
cfg80211: Regulatory domain changed to country: US
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
    (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
EXT2-fs (hda1): warning: mounting unchecked fs, running e2fsck is recommended
EXT2-fs (hda1): error: ext2_lookup: deleted inode referenced: 15608
EXT2-fs (hda1): error: ext2_lookup: deleted inode referenced: 15608
EXT2-fs (hda1): error: ext2_lookup: deleted inode referenced: 15608
EXT2-fs (hda1): error: ext2_lookup: deleted inode referenced: 15608
EXT2-fs (hda1): error: ext2_lookup: deleted inode referenced: 15608
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
eth1: no IPv6 routers present
wlan2: no IPv6 routers present
EXT2-fs (hda1): error: ext2_check_page: bad entry in directory #108731: : unaligned directory entry - offset=0, inode=2940091001, rec_len=24170, name_len=245
EXT2-fs (hda1): error: ext2_readdir: bad page in #108731
EXT2-fs (hda1): error: ext2_check_page: bad entry in directory #108738: : unaligned directory entry - offset=0, inode=944130375, rec_len=24889, name_len=63
EXT2-fs (hda1): error: ext2_readdir: bad page in #108738
EXT2-fs (hda1): error: ext2_check_page: bad entry in directory #108837: : unaligned directory entry - offset=0, inode=1768693795, rec_len=24930, name_len=115
EXT2-fs (hda1): error: ext2_readdir: bad page in #108837

--------------050402070403060300060600--

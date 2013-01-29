Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:34172 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3A2Tjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 14:39:48 -0500
Received: by mail-we0-f179.google.com with SMTP id x43so607669wey.10
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2013 11:39:46 -0800 (PST)
From: Maciek Zarzycki <zarzych@gmail.com>
To: sedat.dilek@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: Possible bug in iwlwifi
Date: Tue, 29 Jan 2013 20:32:32 +0100
Message-ID: <1744761.JWV8cuMCn5@zarzych> (sfid-20130129_203955_993066_3A06B3E8)
In-Reply-To: <CA+icZUX8u3_7EVWN7sJR5kCk=LgZvNjhuLmn=aFkm7akcmpBKA@mail.gmail.com>
References: <2709103.3nEV2q8lKr@zarzych> <5643712.YXEVgUjzFG@zarzych> <CA+icZUX8u3_7EVWN7sJR5kCk=LgZvNjhuLmn=aFkm7akcmpBKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4805672.WRqRiluFoo"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart4805672.WRqRiluFoo
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday 27 of January 2013 22:59:48 Sedat Dilek wrote:
> For quick testing of patches I would suggest you to do a
> localmodconfig-ed kernel-setup.
> Here on a Intel sandybridge CPU it's approx. 10-12min with 'make -j4'.

Hi again,
I've tested both the newest stable vanilla (3.7.5) and stable vanilla with the iwlwifi fix patch applied. Unfortunatelly neither fixed the problem...

The bug appears after a sleep/resume cycle while on AC power. It does *not* appear after a sleep/resume cycle while on battery.

Below is the all information as requested by the reporting bugs section on wireless.kernel.org.

Kernel: 3.7.5 vanilla
Wifi card: Intel Centrino Ultimate 6300 

# lspci -nnv                                                                               
00:00.0 Host bridge [0600]: Intel Corporation 3rd Gen Core processor DRAM Controller [8086:0154] (rev 09)  
        Subsystem: Lenovo Device [17aa:21f3]                                                               
        Flags: bus master, fast devsel, latency 0                                                          
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>                                         
                                                                                                           
00:02.0 VGA compatible controller [0300]: Intel Corporation 3rd Gen Core processor Graphics Controller [8086:0166] (rev 09) (prog-if 00 [VGA controller])                                                             
        Subsystem: Lenovo Device [17aa:21f4]                                                               
        Flags: bus master, fast devsel, latency 0, IRQ 48                                                  
        Memory at f0000000 (64-bit, non-prefetchable) [size=4M]                                            
        Memory at e0000000 (64-bit, prefetchable) [size=256M]                                              
        I/O ports at 5000 [size=64]                                                                        
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [d0] Power Management version 2
        Capabilities: [a4] PCI Advanced Features
        Kernel driver in use: i915

00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04) (prog-if 30 [XHCI])
        Subsystem: Lenovo Device [17aa:21f3]
        Flags: bus master, medium devsel, latency 0, IRQ 43
        Memory at f2520000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [70] Power Management version 2
        Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
        Kernel driver in use: xhci_hcd

00:16.0 Communication controller [0780]: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 [8086:1e3a] (rev 04)
        Subsystem: Lenovo Device [17aa:21f3]
        Flags: bus master, fast devsel, latency 0, IRQ 46
        Memory at f2535000 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
        Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Kernel driver in use: mei

00:19.0 Ethernet controller [0200]: Intel Corporation 82579LM Gigabit Network Connection [8086:1502] (rev 04)
        Subsystem: Lenovo Device [17aa:21f3]
        Flags: fast devsel, IRQ 20
        Memory at f2500000 (32-bit, non-prefetchable) [disabled] [size=128K]
        Memory at f253b000 (32-bit, non-prefetchable) [disabled] [size=4K]
        I/O ports at 5080 [disabled] [size=32]
        Capabilities: [c8] Power Management version 2
        Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [e0] PCI Advanced Features
        Kernel driver in use: e1000e

00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04) (prog-if 20 [EHCI])
        Subsystem: Lenovo Device [17aa:21f3]
        Flags: bus master, medium devsel, latency 0, IRQ 16
        Memory at f253a000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
        Kernel driver in use: ehci_hcd

00:1b.0 Audio device [0403]: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller [8086:1e20] (rev 04)
        Subsystem: Lenovo Device [17aa:21f3]
        Flags: bus master, fast devsel, latency 0, IRQ 45
        Memory at f2530000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
        Capabilities: [100] Virtual Channel
        Capabilities: [130] Root Complex Link
        Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 [8086:1e10] (rev c4) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: f1d00000-f24fffff
        Prefetchable memory behind bridge: 00000000f0400000-00000000f0bfffff
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [90] Subsystem: Lenovo Device [17aa:21f3]
        Capabilities: [a0] Power Management version 2
        Kernel driver in use: pcieport

00:1c.1 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 2 [8086:1e12] (rev c4) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        Memory behind bridge: f1c00000-f1cfffff
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [90] Subsystem: Lenovo Device [17aa:21f3]
        Capabilities: [a0] Power Management version 2
        Kernel driver in use: pcieport

00:1c.2 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3 [8086:1e14] (rev c4) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=04, subordinate=0b, sec-latency=0
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: f1400000-f1bfffff
        Prefetchable memory behind bridge: 00000000f0c00000-00000000f13fffff
        Capabilities: [40] Express Root Port (Slot+), MSI 00
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
        Capabilities: [90] Subsystem: Lenovo Device [17aa:21f3]
        Capabilities: [a0] Power Management version 2
        Kernel driver in use: pcieport

00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04) (prog-if 20 [EHCI])
        Subsystem: Lenovo Device [17aa:21f3]
        Flags: bus master, medium devsel, latency 0, IRQ 23
        Memory at f2539000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
        Kernel driver in use: ehci_hcd

00:1f.0 ISA bridge [0601]: Intel Corporation QM77 Express Chipset LPC Controller [8086:1e55] (rev 04)
        Subsystem: Lenovo Device [17aa:21f3]
        Flags: bus master, medium devsel, latency 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: lpc_ich

00:1f.2 SATA controller [0106]: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] [8086:1e03] (rev 04) (prog-if 01 [AHCI 1.0])
        Subsystem: Lenovo Device [17aa:21f3]
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 42
        I/O ports at 50a8 [size=8]
        I/O ports at 50b4 [size=4]
        I/O ports at 50a0 [size=8]
        I/O ports at 50b0 [size=4]
        I/O ports at 5060 [size=32]
        Memory at f2538000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [70] Power Management version 3
        Capabilities: [a8] SATA HBA v1.0
        Capabilities: [b0] PCI Advanced Features
        Kernel driver in use: ahci

00:1f.3 SMBus [0c05]: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller [8086:1e22] (rev 04)
        Subsystem: Lenovo Device [17aa:21f3]
        Flags: medium devsel, IRQ 18
        Memory at f2534000 (64-bit, non-prefetchable) [size=256]
        I/O ports at efa0 [size=32]
        Kernel driver in use: i801_smbus

02:00.0 System peripheral [0880]: Ricoh Co Ltd PCIe SDXC/MMC Host Controller [1180:e823] (rev 07) (prog-if 01)
        Subsystem: Lenovo Device [17aa:21f3]
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at f1d00000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [78] Power Management version 3
        Capabilities: [80] Express Endpoint, MSI 00
        Capabilities: [100] Virtual Channel
        Capabilities: [800] Advanced Error Reporting
        Kernel driver in use: sdhci-pci

03:00.0 Network controller [0280]: Intel Corporation Centrino Ultimate-N 6300 [8086:4238] (rev 3e)
        Subsystem: Intel Corporation Centrino Ultimate-N 6300 3x3 AGN [8086:1111]
        Flags: bus master, fast devsel, latency 0, IRQ 47
        Memory at f1c00000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [c8] Power Management version 3
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
        Capabilities: [e0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Device Serial Number 24-77-03-ff-ff-ce-7f-c8
        Kernel driver in use: iwlwifi

# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.5-vanilla-ARCH (zarzych@zarzych) (gcc version 4.7.2 (GCC) ) #4 SMP PREEMPT Tue Jan 29 19:54:34 CET 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.7.5-vanilla root=UUID=f8884e04-119a-4ef0-84ec-3ca8bf9ad742 ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c000-0x000000000009cfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x00000000000bffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000cfe3ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfe40000-0x00000000d0041fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d0042000-0x00000000d6a04fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d6a05000-0x00000000dae9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dae9f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021e5fffff] usable
[    0.000000] BIOS-e820: [mem 0x000000021e600000-0x000000021e7fffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by Lenovo
[    0.000000] efi:  ACPI 2.0=0xdaffe014  ACPI=0xdaffe000  SMBIOS=0xdae9e000 
[    0.000000] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x0000000000087000) (0MB)
[    0.000000] efi: mem01: type=4, attr=0xf, range=[0x0000000000087000-0x0000000000088000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000088000-0x000000000009c000) (0MB)
[    0.000000] efi: mem03: type=0, attr=0xf, range=[0x000000000009c000-0x000000000009d000) (0MB)
[    0.000000] efi: mem04: type=4, attr=0xf, range=[0x000000000009d000-0x000000000009e000) (0MB)
[    0.000000] efi: mem05: type=0, attr=0xf, range=[0x000000000009e000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem06: type=2, attr=0xf, range=[0x0000000000100000-0x0000000000fda000) (14MB)
[    0.000000] efi: mem07: type=7, attr=0xf, range=[0x0000000000fda000-0x0000000020000000) (496MB)
[    0.000000] efi: mem08: type=0, attr=0xf, range=[0x0000000020000000-0x0000000020200000) (2MB)
[    0.000000] efi: mem09: type=7, attr=0xf, range=[0x0000000020200000-0x0000000037a6a000) (376MB)
[    0.000000] efi: mem10: type=2, attr=0xf, range=[0x0000000037a6a000-0x0000000037d2d000) (2MB)
[    0.000000] efi: mem11: type=7, attr=0xf, range=[0x0000000037d2d000-0x0000000040004000) (130MB)
[    0.000000] efi: mem12: type=0, attr=0xf, range=[0x0000000040004000-0x0000000040005000) (0MB)
[    0.000000] efi: mem13: type=7, attr=0xf, range=[0x0000000040005000-0x0000000099008000) (1424MB)
[    0.000000] efi: mem14: type=2, attr=0xf, range=[0x0000000099008000-0x00000000cd811000) (840MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x00000000cd811000-0x00000000cd831000) (0MB)
[    0.000000] efi: mem16: type=7, attr=0xf, range=[0x00000000cd831000-0x00000000cfe2a000) (37MB)
[    0.000000] efi: mem17: type=4, attr=0xf, range=[0x00000000cfe2a000-0x00000000cfe40000) (0MB)
[    0.000000] efi: mem18: type=0, attr=0xf, range=[0x00000000cfe40000-0x00000000d0042000) (2MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x00000000d0042000-0x00000000d0801000) (7MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x00000000d0801000-0x00000000d09f3000) (1MB)
[    0.000000] efi: mem21: type=1, attr=0xf, range=[0x00000000d09f3000-0x00000000d0a10000) (0MB)
[    0.000000] efi: mem22: type=7, attr=0xf, range=[0x00000000d0a10000-0x00000000d27c3000) (29MB)
[    0.000000] efi: mem23: type=4, attr=0xf, range=[0x00000000d27c3000-0x00000000d4693000) (30MB)
[    0.000000] efi: mem24: type=7, attr=0xf, range=[0x00000000d4693000-0x00000000d46a4000) (0MB)
[    0.000000] efi: mem25: type=4, attr=0xf, range=[0x00000000d46a4000-0x00000000d6005000) (25MB)
[    0.000000] efi: mem26: type=7, attr=0xf, range=[0x00000000d6005000-0x00000000d6569000) (5MB)
[    0.000000] efi: mem27: type=2, attr=0xf, range=[0x00000000d6569000-0x00000000d6572000) (0MB)
[    0.000000] efi: mem28: type=3, attr=0xf, range=[0x00000000d6572000-0x00000000d6a05000) (4MB)
[    0.000000] efi: mem29: type=5, attr=0x800000000000000f, range=[0x00000000d6a05000-0x00000000d6ae0000) (0MB)
[    0.000000] efi: mem30: type=5, attr=0x800000000000000f, range=[0x00000000d6ae0000-0x00000000d6c05000) (1MB)
[    0.000000] efi: mem31: type=6, attr=0x800000000000000f, range=[0x00000000d6c05000-0x00000000d77af000) (11MB)
[    0.000000] efi: mem32: type=6, attr=0x800000000000000f, range=[0x00000000d77af000-0x00000000da655000) (46MB)
[    0.000000] efi: mem33: type=0, attr=0xf, range=[0x00000000da655000-0x00000000dabf0000) (5MB)
[    0.000000] efi: mem34: type=0, attr=0xf, range=[0x00000000dabf0000-0x00000000dae9b000) (2MB)
[    0.000000] efi: mem35: type=0, attr=0xf, range=[0x00000000dae9b000-0x00000000dae9d000) (0MB)
[    0.000000] efi: mem36: type=0, attr=0xf, range=[0x00000000dae9d000-0x00000000dae9f000) (0MB)
[    0.000000] efi: mem37: type=10, attr=0xf, range=[0x00000000dae9f000-0x00000000daef5000) (0MB)
[    0.000000] efi: mem38: type=10, attr=0xf, range=[0x00000000daef5000-0x00000000daf9f000) (0MB)
[    0.000000] efi: mem39: type=9, attr=0xf, range=[0x00000000daf9f000-0x00000000dafd8000) (0MB)
[    0.000000] efi: mem40: type=9, attr=0xf, range=[0x00000000dafd8000-0x00000000dafff000) (0MB)
[    0.000000] efi: mem41: type=4, attr=0xf, range=[0x00000000dafff000-0x00000000db000000) (0MB)
[    0.000000] efi: mem42: type=7, attr=0xf, range=[0x0000000100000000-0x000000021e600000) (4582MB)
[    0.000000] efi: mem43: type=0, attr=0x0, range=[0x00000000000a0000-0x00000000000c0000) (0MB)
[    0.000000] efi: mem44: type=0, attr=0x0, range=[0x00000000db000000-0x00000000dfa00000) (74MB)
[    0.000000] efi: mem45: type=11, attr=0x8000000000000001, range=[0x00000000f80f8000-0x00000000f80f9000) (0MB)
[    0.000000] efi: mem46: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem47: type=0, attr=0x0, range=[0x000000021e600000-0x000000021e800000) (2MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: LENOVO 2342CTO/2342CTO, BIOS G1ET91WW (2.51 ) 01/09/2013
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x21e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask F00000000 write-back
[    0.000000]   7 base 200000000 mask FE0000000 write-back
[    0.000000]   8 base 21F000000 mask FFF000000 uncachable
[    0.000000]   9 base 21E800000 mask FFF800000 uncachable
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0xdaffffff]
[    0.000000]  [mem 0x00000000-0xdaffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0xdaffffff @ [mem 0x1fffb000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x21e5fffff]
[    0.000000]  [mem 0x100000000-0x21e5fffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x21e5fffff @ [mem 0xd656c000-0xd6571fff]
[    0.000000] RAMDISK: [mem 0x37a6a000-0x37d2cfff]
[    0.000000] ACPI: RSDP 00000000daffe014 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000daffe170 000CC (v01 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: FACP 00000000dafe7000 0010C (v05 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000dafe9000 0FE86 (v01 LENOVO TP-G1    00002510 INTL 20061109)
[    0.000000] ACPI: FACS 00000000daf5a000 00040
[    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 LENOVO TP-G1    00002510 PTL  00000001)
[    0.000000] ACPI: TCPA 00000000daffc000 00032 (v02    PTL   LENOVO 06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 00000000daffb000 00408 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daffa000 00033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000daff9000 00797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 00000000dafe5000 00038 (v01 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: APIC 00000000dafe4000 00098 (v01 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dafe3000 0003C (v01 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: ECDT 00000000dafe2000 00052 (v01 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: FPDT 00000000dafe1000 00064 (v01 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: ASF! 00000000dafe8000 000A5 (v32 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafe0000 0003E (v01 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dafdf000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: POAT 00000000dafde000 00055 (v03 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: SSDT 00000000dafdd000 00C51 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000dafdc000 00A83 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: DMAR 00000000dafdb000 000B8 (v01 INTEL      SNB  00000001 INTL 00000001)
[    0.000000] ACPI: UEFI 00000000dafda000 002A6 (v01 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: DBG2 00000000dafd9000 000E9 (v00 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: BGRT 00000000dafd8000 00038 (v00 LENOVO TP-G1    00002510 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x21e5fffff]
[    0.000000]   NODE_DATA [mem 0x21e5fc000-0x21e5fffff]
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880215c00000-ffff88021dbfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009bfff]
[    0.000000]   node   0: [mem 0x0009d000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xcfe3ffff]
[    0.000000]   node   0: [mem 0xd0042000-0xd6a04fff]
[    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x21e5fffff]
[    0.000000] On node 0 totalpages: 2050960
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 9 pages reserved
[    0.000000]   DMA zone: 3908 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 857667 pages, LIFO batch:31
[    0.000000]   Normal zone: 18328 pages used for memmap
[    0.000000]   Normal zone: 1154664 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 000000000009d000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000c0000
[    0.000000] PM: Registered nosave memory: 00000000000c0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040004000 - 0000000040005000
[    0.000000] PM: Registered nosave memory: 00000000cfe40000 - 00000000d0042000
[    0.000000] PM: Registered nosave memory: 00000000d6a05000 - 00000000dae9f000
[    0.000000] PM: Registered nosave memory: 00000000dae9f000 - 00000000daf9f000
[    0.000000] PM: Registered nosave memory: 00000000daf9f000 - 00000000dafff000
[    0.000000] PM: Registered nosave memory: 00000000db000000 - 00000000dfa00000
[    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f80f8000
[    0.000000] PM: Registered nosave memory: 00000000f80f8000 - 00000000f80f9000
[    0.000000] PM: Registered nosave memory: 00000000f80f9000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 0000000100000000
[    0.000000] e820: [mem 0xdfa00000-0xf80f7fff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88021e200000 s84608 r8192 d21888 u262144
[    0.000000] pcpu-alloc: s84608 r8192 d21888 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2016239
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.7.5-vanilla root=UUID=f8884e04-119a-4ef0-84ec-3ca8bf9ad742 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7921280k/8886272k available (4692k kernel code, 682432k absent, 282560k reserved, 4203k data, 800k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 33554432 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 2793.768 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 5589.35 BogoMIPS (lpj=9312560)
[    0.000004] pid_max: default: 32768 minimum: 301
[    0.018707] Security Framework initialized
[    0.018714] AppArmor: AppArmor disabled by boot time parameter
[    0.019097] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.020838] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.021609] Mount-cache hash table entries: 256
[    0.021752] Initializing cgroup subsys cpuacct
[    0.021753] Initializing cgroup subsys memory
[    0.021759] Initializing cgroup subsys devices
[    0.021760] Initializing cgroup subsys freezer
[    0.021761] Initializing cgroup subsys net_cls
[    0.021762] Initializing cgroup subsys blkio
[    0.021782] CPU: Physical Processor ID: 0
[    0.021782] CPU: Processor Core ID: 0
[    0.021786] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.022103] mce: CPU supports 7 MCE banks
[    0.022112] CPU0: Thermal monitoring enabled (TM1)
[    0.022118] process: using mwait in idle threads
[    0.022121] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 1
[    0.022258] Freeing SMP alternatives: 16k freed
[    0.023037] ACPI: Core revision 20120913
[    0.030286] ftrace: allocating 18110 entries in 71 pages
[    0.037447] dmar: Host address width 36
[    0.037449] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.037455] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.037456] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.037461] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.037462] dmar: RMRR base: 0x000000da470000 end: 0x000000da486fff
[    0.037463] dmar: RMRR base: 0x000000db800000 end: 0x000000df9fffff
[    0.037533] IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.037534] HPET id 0 under DRHD base 0xfed91000
[    0.037657] Enabled IRQ remapping in x2apic mode
[    0.037658] Enabling x2apic
[    0.037659] Enabled x2apic
[    0.037664] Switched APIC routing to cluster x2apic.
[    0.038071] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.071027] smpboot: CPU0: Intel(R) Core(TM) i5-3360M CPU @ 2.80GHz (fam: 06, model: 3a, stepping: 09)
[    0.176749] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Intel PMU driver.
[    0.176754] ... version:                3
[    0.176755] ... bit width:              48
[    0.176756] ... generic registers:      4
[    0.176757] ... value mask:             0000ffffffffffff
[    0.176757] ... max period:             000000007fffffff
[    0.176758] ... fixed-purpose events:   3
[    0.176759] ... event mask:             000000070000000f
[    0.216910] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.203437] smpboot: Booting Node   0, Processors  #1 #2 #3
[    0.256796] Brought up 4 CPUs
[    0.256799] smpboot: Total of 4 processors activated (22359.40 BogoMIPS)
[    0.259621] devtmpfs: initialized
[    0.260597] PM: Registering ACPI NVS region [mem 0xdae9f000-0xdaf9efff] (1048576 bytes)
[    0.261159] NET: Registered protocol family 16
[    0.261250] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.261252] ACPI: bus type pci registered
[    0.261421] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.261423] PCI: not using MMCONFIG
[    0.261424] PCI: Using configuration type 1 for base access
[    0.261838] bio: create slab <bio-0> at 0
[    0.261878] ACPI: Added _OSI(Module Device)
[    0.261879] ACPI: Added _OSI(Processor Device)
[    0.261880] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.261881] ACPI: Added _OSI(Processor Aggregator Device)
[    0.263086] ACPI: EC: EC description table is found, configuring boot EC
[    0.266606] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.279253] ACPI: SSDT 00000000dae3a018 00A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.279557] ACPI: Dynamic OEM Table Load:
[    0.279559] ACPI: SSDT           (null) 00A01 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.286940] ACPI: SSDT 00000000dae3ba98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.287262] ACPI: Dynamic OEM Table Load:
[    0.287264] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.306815] ACPI: SSDT 00000000dae39d98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.307112] ACPI: Dynamic OEM Table Load:
[    0.307114] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.327149] ACPI: Interpreter enabled
[    0.327152] ACPI: (supports S0 S3 S4 S5)
[    0.327165] ACPI: Using IOAPIC for interrupt routing
[    0.327178] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.327492] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.335534] ACPI: Power Resource [PUBS] (on)
[    0.337948] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.338550] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.338553] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.338611] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.338651] PCI host bridge to bus 0000:00
[    0.338653] pci_bus 0000:00: root bus resource [bus 00-3f]
[    0.338655] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.338656] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.338658] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.338659] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.338660] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.338662] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.338663] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    0.338664] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.338665] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.338667] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.338668] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.338669] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.338671] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.338672] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.338673] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.338675] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfebfffff]
[    0.338676] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.338683] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.338714] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.338723] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.338729] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.338733] pci 0000:00:02.0: reg 20: [io  0x5000-0x503f]
[    0.338781] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.338801] pci 0000:00:14.0: reg 10: [mem 0xf2520000-0xf252ffff 64bit]
[    0.338870] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.338891] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.338910] pci 0000:00:16.0: reg 10: [mem 0xf2535000-0xf253500f 64bit]
[    0.338971] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.338999] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.339016] pci 0000:00:19.0: reg 10: [mem 0xf2500000-0xf251ffff]
[    0.339024] pci 0000:00:19.0: reg 14: [mem 0xf253b000-0xf253bfff]
[    0.339032] pci 0000:00:19.0: reg 18: [io  0x5080-0x509f]
[    0.339092] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.339117] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.339136] pci 0000:00:1a.0: reg 10: [mem 0xf253a000-0xf253a3ff]
[    0.339222] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.339246] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.339260] pci 0000:00:1b.0: reg 10: [mem 0xf2530000-0xf2533fff 64bit]
[    0.339323] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.339346] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.339421] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.339447] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    0.339522] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.339546] pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
[    0.339621] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.339652] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.339672] pci 0000:00:1d.0: reg 10: [mem 0xf2539000-0xf25393ff]
[    0.339758] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.339783] pci 0000:00:1f.0: [8086:1e55] type 00 class 0x060100
[    0.339902] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.339920] pci 0000:00:1f.2: reg 10: [io  0x50a8-0x50af]
[    0.339927] pci 0000:00:1f.2: reg 14: [io  0x50b4-0x50b7]
[    0.339935] pci 0000:00:1f.2: reg 18: [io  0x50a0-0x50a7]
[    0.339943] pci 0000:00:1f.2: reg 1c: [io  0x50b0-0x50b3]
[    0.339950] pci 0000:00:1f.2: reg 20: [io  0x5060-0x507f]
[    0.339958] pci 0000:00:1f.2: reg 24: [mem 0xf2538000-0xf25387ff]
[    0.340004] pci 0000:00:1f.2: PME# supported from D3hot
[    0.340021] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.340036] pci 0000:00:1f.3: reg 10: [mem 0xf2534000-0xf25340ff 64bit]
[    0.340056] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.340348] pci 0000:02:00.0: [1180:e823] type 00 class 0x088001
[    0.340366] pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[    0.340393] pci 0000:02:00.0: reg 10: [mem 0xf1d00000-0xf1d000ff]
[    0.340595] pci 0000:02:00.0: supports D1 D2
[    0.340596] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.346805] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.346809] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.346813] pci 0000:00:1c.0:   bridge window [mem 0xf1d00000-0xf24fffff]
[    0.346819] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.346900] pci 0000:03:00.0: [8086:4238] type 00 class 0x028000
[    0.346946] pci 0000:03:00.0: reg 10: [mem 0xf1c00000-0xf1c01fff 64bit]
[    0.347171] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.353329] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.353340] pci 0000:00:1c.1:   bridge window [mem 0xf1c00000-0xf1cfffff]
[    0.353403] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.353407] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.353411] pci 0000:00:1c.2:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.353417] pci 0000:00:1c.2:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.353433] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.353489] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.353509] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.353527] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.353596]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.353664]  pci0000:00: ACPI _OSC request failed (AE_SUPPORT), returned control mask: 0x0d
[    0.353665] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.354999] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.355034] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.355067] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.355099] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.355130] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.355162] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.355194] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.355225] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
[    0.355295] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=mem,locks=none
[    0.355298] vgaarb: loaded
[    0.355299] vgaarb: bridge control possible 0000:00:02.0
[    0.355326] PCI: Using ACPI for IRQ routing
[    0.356835] PCI: pci_cache_line_size set to 64 bytes
[    0.357014] e820: reserve RAM buffer [mem 0x0009c000-0x0009ffff]
[    0.357016] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.357017] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.357018] e820: reserve RAM buffer [mem 0xcfe40000-0xcfffffff]
[    0.357019] e820: reserve RAM buffer [mem 0xd6a05000-0xd7ffffff]
[    0.357020] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.357021] e820: reserve RAM buffer [mem 0x21e600000-0x21fffffff]
[    0.357085] NetLabel: Initializing
[    0.357086] NetLabel:  domain hash size = 128
[    0.357086] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.357095] NetLabel:  unlabeled traffic allowed by default
[    0.357108] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.357111] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.359118] Switching to clocksource hpet
[    0.362246] pnp: PnP ACPI init
[    0.362257] ACPI: bus type pnp registered
[    0.362476] pnp 00:00: [mem 0x00000000-0x0009ffff]
[    0.362478] pnp 00:00: [mem 0x000c0000-0x000bffff disabled]
[    0.362479] pnp 00:00: [mem 0x000c4000-0x000c3fff disabled]
[    0.362481] pnp 00:00: [mem 0x000c8000-0x000c7fff disabled]
[    0.362482] pnp 00:00: [mem 0x000cc000-0x000cbfff disabled]
[    0.362483] pnp 00:00: [mem 0x000d0000-0x000cffff disabled]
[    0.362484] pnp 00:00: [mem 0x000d4000-0x000d3fff disabled]
[    0.362486] pnp 00:00: [mem 0x000d8000-0x000d7fff disabled]
[    0.362488] pnp 00:00: [mem 0x000dc000-0x000dbfff disabled]
[    0.362490] pnp 00:00: [mem 0x000e0000-0x000dffff disabled]
[    0.362491] pnp 00:00: [mem 0x000e4000-0x000e3fff disabled]
[    0.362492] pnp 00:00: [mem 0x000e8000-0x000e7fff disabled]
[    0.362494] pnp 00:00: [mem 0x000ec000-0x000ebfff disabled]
[    0.362495] pnp 00:00: [mem 0x000f0000-0x000fffff]
[    0.362496] pnp 00:00: [mem 0x00100000-0xdf9fffff]
[    0.362497] pnp 00:00: [mem 0xfec00000-0xfed3ffff]
[    0.362499] pnp 00:00: [mem 0xfed4c000-0xffffffff]
[    0.362531] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.362534] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.362536] system 00:00: [mem 0x00100000-0xdf9fffff] could not be reserved
[    0.362537] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.362539] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.362542] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.362555] pnp 00:01: [bus 00-3f]
[    0.362557] pnp 00:01: [io  0x0cf8-0x0cff]
[    0.362558] pnp 00:01: [io  0x0000-0x0cf7 window]
[    0.362560] pnp 00:01: [io  0x0d00-0xffff window]
[    0.362561] pnp 00:01: [mem 0x000a0000-0x000bffff window]
[    0.362563] pnp 00:01: [mem 0x000c0000-0x000c3fff window]
[    0.362564] pnp 00:01: [mem 0x000c4000-0x000c7fff window]
[    0.362565] pnp 00:01: [mem 0x000c8000-0x000cbfff window]
[    0.362566] pnp 00:01: [mem 0x000cc000-0x000cffff window]
[    0.362568] pnp 00:01: [mem 0x000d0000-0x000d3fff window]
[    0.362569] pnp 00:01: [mem 0x000d4000-0x000d7fff window]
[    0.362570] pnp 00:01: [mem 0x000d8000-0x000dbfff window]
[    0.362572] pnp 00:01: [mem 0x000dc000-0x000dffff window]
[    0.362573] pnp 00:01: [mem 0x000e0000-0x000e3fff window]
[    0.362574] pnp 00:01: [mem 0x000e4000-0x000e7fff window]
[    0.362575] pnp 00:01: [mem 0x000e8000-0x000ebfff window]
[    0.362577] pnp 00:01: [mem 0x000ec000-0x000effff window]
[    0.362578] pnp 00:01: [mem 0xdfa00000-0xfebfffff window]
[    0.362579] pnp 00:01: [mem 0xfed40000-0xfed4bfff window]
[    0.362602] pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.362642] pnp 00:02: [io  0x0010-0x001f]
[    0.362643] pnp 00:02: [io  0x0090-0x009f]
[    0.362645] pnp 00:02: [io  0x0024-0x0025]
[    0.362646] pnp 00:02: [io  0x0028-0x0029]
[    0.362647] pnp 00:02: [io  0x002c-0x002d]
[    0.362648] pnp 00:02: [io  0x0030-0x0031]
[    0.362649] pnp 00:02: [io  0x0034-0x0035]
[    0.362651] pnp 00:02: [io  0x0038-0x0039]
[    0.362652] pnp 00:02: [io  0x003c-0x003d]
[    0.362653] pnp 00:02: [io  0x00a4-0x00a5]
[    0.362654] pnp 00:02: [io  0x00a8-0x00a9]
[    0.362655] pnp 00:02: [io  0x00ac-0x00ad]
[    0.362656] pnp 00:02: [io  0x00b0-0x00b5]
[    0.362658] pnp 00:02: [io  0x00b8-0x00b9]
[    0.362660] pnp 00:02: [io  0x00bc-0x00bd]
[    0.362661] pnp 00:02: [io  0x0050-0x0053]
[    0.362662] pnp 00:02: [io  0x0072-0x0077]
[    0.362663] pnp 00:02: [io  0x0400-0x047f]
[    0.362665] pnp 00:02: [io  0x0500-0x057f]
[    0.362666] pnp 00:02: [io  0x0800-0x080f]
[    0.362667] pnp 00:02: [io  0x15e0-0x15ef]
[    0.362668] pnp 00:02: [io  0x1600-0x167f]
[    0.362669] pnp 00:02: [mem 0xf8000000-0xfbffffff]
[    0.362671] pnp 00:02: [mem 0xfffff000-0xffffffff]
[    0.362672] pnp 00:02: [mem 0xfed1c000-0xfed1ffff]
[    0.362673] pnp 00:02: [mem 0xfed10000-0xfed13fff]
[    0.362674] pnp 00:02: [mem 0xfed18000-0xfed18fff]
[    0.362676] pnp 00:02: [mem 0xfed19000-0xfed19fff]
[    0.362677] pnp 00:02: [mem 0xfed45000-0xfed4bfff]
[    0.362707] system 00:02: [io  0x0400-0x047f] has been reserved
[    0.362708] system 00:02: [io  0x0500-0x057f] has been reserved
[    0.362711] system 00:02: [io  0x0800-0x080f] has been reserved
[    0.362712] system 00:02: [io  0x15e0-0x15ef] has been reserved
[    0.362714] system 00:02: [io  0x1600-0x167f] has been reserved
[    0.362716] system 00:02: [mem 0xf8000000-0xfbffffff] could not be reserved
[    0.362717] system 00:02: [mem 0xfffff000-0xffffffff] has been reserved
[    0.362719] system 00:02: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.362721] system 00:02: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.362722] system 00:02: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.362724] system 00:02: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.362725] system 00:02: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.362727] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.362756] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.362769] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.362775] pnp 00:04: [io  0x0000-0x000f]
[    0.362776] pnp 00:04: [io  0x0080-0x008f]
[    0.362777] pnp 00:04: [io  0x00c0-0x00df]
[    0.362779] pnp 00:04: [dma 4]
[    0.362792] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.362797] pnp 00:05: [io  0x0061]
[    0.362809] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.362813] pnp 00:06: [io  0x00f0]
[    0.362824] pnp 00:06: [irq 13]
[    0.362840] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.362845] pnp 00:07: [io  0x0070-0x0071]
[    0.362850] pnp 00:07: [irq 8]
[    0.362862] pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.362867] pnp 00:08: [io  0x0060]
[    0.362868] pnp 00:08: [io  0x0064]
[    0.362874] pnp 00:08: [irq 1]
[    0.362887] pnp 00:08: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
[    0.362896] pnp 00:09: [irq 12]
[    0.362908] pnp 00:09: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.362929] pnp 00:0a: [mem 0xfed40000-0xfed44fff]
[    0.362944] pnp 00:0a: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.363243] pnp: PnP ACPI: found 11 devices
[    0.363244] ACPI: ACPI bus type pnp unregistered
[    0.369219] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.369223] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.369228] pci 0000:00:1c.0:   bridge window [mem 0xf1d00000-0xf24fffff]
[    0.369233] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.369239] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.369244] pci 0000:00:1c.1:   bridge window [mem 0xf1c00000-0xf1cfffff]
[    0.369251] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.369254] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.369259] pci 0000:00:1c.2:   bridge window [mem 0xf1400000-0xf1bfffff]
[    0.369263] pci 0000:00:1c.2:   bridge window [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.369294] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.369296] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.369297] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.369298] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.369300] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.369301] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.369302] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    0.369304] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.369305] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.369307] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.369308] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    0.369309] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.369311] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.369312] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
[    0.369313] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
[    0.369315] pci_bus 0000:00: resource 19 [mem 0xdfa00000-0xfebfffff]
[    0.369316] pci_bus 0000:00: resource 20 [mem 0xfed40000-0xfed4bfff]
[    0.369318] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    0.369319] pci_bus 0000:02: resource 1 [mem 0xf1d00000-0xf24fffff]
[    0.369320] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.369322] pci_bus 0000:03: resource 1 [mem 0xf1c00000-0xf1cfffff]
[    0.369323] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    0.369325] pci_bus 0000:04: resource 1 [mem 0xf1400000-0xf1bfffff]
[    0.369326] pci_bus 0000:04: resource 2 [mem 0xf0c00000-0xf13fffff 64bit pref]
[    0.369350] NET: Registered protocol family 2
[    0.369756] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.370671] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.370776] TCP: Hash tables configured (established 524288 bind 65536)
[    0.370792] TCP: reno registered
[    0.370800] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.370821] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.370887] NET: Registered protocol family 1
[    0.370897] pci 0000:00:02.0: Boot video device
[    0.371235] PCI: CLS 64 bytes, default 64
[    0.371267] Unpacking initramfs...
[    0.411764] Freeing initrd memory: 2828k freed
[    0.412042] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.412046] software IO TLB [mem 0xc9811000-0xcd810fff] (64MB) mapped at [ffff8800c9811000-ffff8800cd810fff]
[    0.412334] audit: initializing netlink socket (disabled)
[    0.412346] type=2000 audit(1359486420.286:1): initialized
[    0.422245] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.423409] VFS: Disk quotas dquot_6.5.2
[    0.423438] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.423532] msgmni has been set to 15614
[    0.423724] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.423753] io scheduler noop registered
[    0.423755] io scheduler deadline registered
[    0.423775] io scheduler cfq registered (default)
[    0.423998] efifb: probing for efifb
[    0.424650] efifb: framebuffer at 0xe0000000, mapped to 0xffffc90005600000, using 5632k, total 5632k
[    0.424651] efifb: mode is 1600x900x32, linelength=6400, pages=1
[    0.424652] efifb: scrolling: redraw
[    0.424653] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.427953] Console: switching to colour frame buffer device 200x56
[    0.431175] fb0: EFI VGA frame buffer device
[    0.431179] intel_idle: MWAIT substates: 0x21120
[    0.431180] intel_idle: v0.4 model 0x3A
[    0.431181] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.431213] GHES: HEST is not enabled!
[    0.431248] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.431559] Linux agpgart interface v0.103
[    0.431609] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.433250] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.433258] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.433338] mousedev: PS/2 mouse device common for all mice
[    0.433392] rtc_cmos 00:07: RTC can wake from S4
[    0.433512] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.433546] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.433609] cpuidle: using governor ladder
[    0.433700] cpuidle: using governor menu
[    0.433765] drop_monitor: Initializing network drop monitor service
[    0.433825] TCP: cubic registered
[    0.433890] NET: Registered protocol family 10
[    0.433995] NET: Registered protocol family 17
[    0.434013] Key type dns_resolver registered
[    0.434192] PM: Hibernation image not present or could not be loaded.
[    0.434199] registered taskstats version 1
[    0.434465] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.434862] rtc_cmos 00:07: setting system clock to 2013-01-29 19:07:01 UTC (1359486421)
[    0.435958] Freeing unused kernel memory: 800k freed
[    0.436037] Write protecting the kernel read-only data: 8192k
[    0.439344] Freeing unused kernel memory: 1440k freed
[    0.440768] Freeing unused kernel memory: 632k freed
[    0.446207] systemd-udevd[58]: starting version 197
[    0.465160] sdhci: Secure Digital Host Controller Interface driver
[    0.465162] sdhci: Copyright(c) Pierre Ossman
[    0.465310] ACPI: bus type usb registered
[    0.465390] usbcore: registered new interface driver usbfs
[    0.465545] sdhci-pci 0000:02:00.0: SDHCI controller found [1180:e823] (rev 4)
[    0.466069] Registered led device: mmc0::
[    0.466330] usbcore: registered new interface driver hub
[    0.466483] SCSI subsystem initialized
[    0.466527] usbcore: registered new device driver usb
[    0.467508] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    0.467513] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.467522] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    0.467609] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.467614] xhci_hcd 0000:00:14.0: irq 16, io mem 0xf2520000
[    0.467658] xhci_hcd 0000:00:14.0: irq 42 for MSI/MSI-X
[    0.467852] xHCI xhci_add_endpoint called for root hub
[    0.467853] xHCI xhci_check_bandwidth called for root hub
[    0.467906] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.468136] ACPI: bus type scsi registered
[    0.468167] hub 1-0:1.0: USB hub found
[    0.468177] hub 1-0:1.0: 4 ports detected
[    0.468374] libata version 3.00 loaded.
[    0.468650] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.468653] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    0.468738] xHCI xhci_add_endpoint called for root hub
[    0.468739] xHCI xhci_check_bandwidth called for root hub
[    0.468757] hub 2-0:1.0: USB hub found
[    0.468763] hub 2-0:1.0: 4 ports detected
[    0.475715] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.475721] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.475766] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.475781] ehci_hcd 0000:00:1a.0: debug port 2
[    0.479671] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.479681] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf253a000
[    0.488975] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.489223] hub 3-0:1.0: USB hub found
[    0.489226] hub 3-0:1.0: 3 ports detected
[    0.489385] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.489388] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.489392] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    0.489405] ehci_hcd 0000:00:1d.0: debug port 2
[    0.493289] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.493305] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf2539000
[    0.495625] mmc0: SDHCI controller on PCI [0000:02:00.0] using DMA
[    0.502284] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.502460] hub 4-0:1.0: USB hub found
[    0.502465] hub 4-0:1.0: 3 ports detected
[    0.502590] ahci 0000:00:1f.2: version 3.0
[    0.502678] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    0.502721] ahci: SSS flag set, parallel bus scan disabled
[    0.515637] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x17 impl SATA mode
[    0.515640] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pio slum part ems sxs apst 
[    0.515644] ahci 0000:00:1f.2: setting latency timer to 64
[    0.536098] scsi0 : ahci
[    0.536176] scsi1 : ahci
[    0.536239] scsi2 : ahci
[    0.536304] scsi3 : ahci
[    0.536374] scsi4 : ahci
[    0.536435] scsi5 : ahci
[    0.536478] ata1: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538100 irq 43
[    0.536483] ata2: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538180 irq 43
[    0.536486] ata3: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538200 irq 43
[    0.536488] ata4: DUMMY
[    0.536491] ata5: SATA max UDMA/133 abar m2048@0xf2538000 port 0xf2538300 irq 43
[    0.536492] ata6: DUMMY
[    0.795205] usb 3-1: new high-speed USB device number 2 using ehci_hcd
[    0.855120] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.856259] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.856278] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.857232] ata1.00: ATA-8: HITACHI HTS725050A7E630, GH2ZB390, max UDMA/133
[    0.857251] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.858484] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    0.858502] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    0.859456] ata1.00: configured for UDMA/133
[    0.859652] scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS72505 GH2Z PQ: 0 ANSI: 5
[    0.919551] hub 3-1:1.0: USB hub found
[    0.919757] hub 3-1:1.0: 6 ports detected
[    1.028166] usb 4-1: new high-speed USB device number 2 using ehci_hcd
[    1.152014] hub 4-1:1.0: USB hub found
[    1.152099] hub 4-1:1.0: 8 ports detected
[    1.177974] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.180458] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    1.180792] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    1.182398] ata2.00: ATAPI: Optiarc DVD RW AD-7740H, 1.S1, max UDMA/100
[    1.185452] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[    1.185791] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[    1.187401] ata2.00: configured for UDMA/100
[    1.188646] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7740H  1.S1 PQ: 0 ANSI: 5
[    0.859943] ACPI: Invalid Power Resource to register!
[    1.188963] ACPI: Invalid Power Resource to register!
[    1.231525] usb 3-1.1: new full-speed USB device number 3 using ehci_hcd
[    1.387984] usb 3-1.4: new full-speed USB device number 4 using ehci_hcd
[    1.410948] tsc: Refined TSC clocksource calibration: 2793.653 MHz
[    1.410952] Switching to clocksource tsc
[    1.507472] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.507853] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.507860] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.508262] ata3.00: ATA-9: SanDisk SSD U100 16GB, 10.52.01, max UDMA/133
[    1.508264] ata3.00: 31277232 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    1.508733] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[    1.508740] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[    1.508935] ata3.00: configured for UDMA/133
[    1.509025] scsi 2:0:0:0: Direct-Access     ATA      SanDisk SSD U100 10.5 PQ: 0 ANSI: 5
[    1.554280] usb 3-1.6: new high-speed USB device number 5 using ehci_hcd
[    1.826996] ata5: SATA link down (SStatus 0 SControl 300)
[    1.830150] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.830154] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.830182] sd 0:0:0:0: [sda] Write Protect is off
[    1.830184] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.830195] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.830315] sd 2:0:0:0: [sdb] 31277232 512-byte logical blocks: (16.0 GB/14.9 GiB)
[    1.830366] sd 2:0:0:0: [sdb] Write Protect is off
[    1.830369] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.830387] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.830812]  sdb: sdb1 sdb2
[    1.831048] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.832791] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.832795] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.832957] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.900809]  sda: sda1 sda2 sda3
[    1.901244] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.238580] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    2.785650] systemd[1]: systemd 197 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    2.795825] systemd[1]: Set hostname to <zarzych>.
[    3.185406] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    3.185442] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    3.185451] systemd[1]: Starting Syslog Socket.
[    3.185479] systemd[1]: Listening on Syslog Socket.
[    3.185486] systemd[1]: Starting Remote File Systems.
[    3.185493] systemd[1]: Reached target Remote File Systems.
[    3.185499] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    3.185514] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    3.185520] systemd[1]: Starting Delayed Shutdown Socket.
[    3.185533] systemd[1]: Listening on Delayed Shutdown Socket.
[    3.185541] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    3.185563] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    3.185585] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    3.185658] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    3.185665] systemd[1]: Starting Encrypted Volumes.
[    3.185672] systemd[1]: Reached target Encrypted Volumes.
[    3.185713] systemd[1]: Starting udev Kernel Socket.
[    3.185729] systemd[1]: Listening on udev Kernel Socket.
[    3.185760] systemd[1]: Starting udev Control Socket.
[    3.185777] systemd[1]: Listening on udev Control Socket.
[    3.185783] systemd[1]: Starting Swap.
[    3.185789] systemd[1]: Reached target Swap.
[    3.185795] systemd[1]: Expecting device dev-sda3.device...
[    3.185803] systemd[1]: Starting Journal Socket.
[    3.185826] systemd[1]: Listening on Journal Socket.
[    3.185837] systemd[1]: Started File System Check on Root Device.
[    3.185843] systemd[1]: Starting Remount Root and Kernel File Systems...
[    3.188594] systemd[1]: Mounting Temporary Directory...
[    3.211801] systemd[1]: Starting udev Coldplug all Devices...
[    3.252632] systemd[1]: Starting Load Kernel Modules...
[    3.290611] systemd[1]: Starting Apply Kernel Variables...
[    3.298314] systemd[1]: Mounting Debug File System...
[    3.321539] systemd[1]: Starting udev Kernel Device Manager...
[    3.331579] systemd[1]: Mounting Huge Pages File System...
[    3.338508] systemd[1]: Starting Setup Virtual Console...
[    3.344871] systemd[1]: Mounting POSIX Message Queue File System...
[    3.377439] systemd[1]: Started Set Up Additional Binary Formats.
[    3.377457] systemd[1]: Starting Journal Service...
[    3.378298] systemd[1]: Started Journal Service.
[    3.378323] systemd[1]: Starting Syslog.
[    3.378331] systemd[1]: Reached target Syslog.
[    3.627762] systemd-udevd[135]: starting version 197
[    3.786220] EXT4-fs (sda2): re-mounted. Opts: data=ordered
[    4.441558] microcode: CPU0 sig=0x306a9, pf=0x10, revision=0x16
[    4.462852] microcode: CPU1 sig=0x306a9, pf=0x10, revision=0x16
[    4.463356] microcode: CPU2 sig=0x306a9, pf=0x10, revision=0x16
[    4.463816] microcode: CPU3 sig=0x306a9, pf=0x10, revision=0x16
[    4.464315] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    4.537160] ACPI: Requesting acpi_cpufreq
[    4.624199] ACPI: AC Adapter [AC] (on-line)
[    4.624572] thermal LNXTHERM:00: registered as thermal_zone0
[    4.624575] ACPI: Thermal Zone [THM0] (54 C)
[    4.639724] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    4.639825] ACPI: Lid Switch [LID]
[    4.639861] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    4.639865] ACPI: Sleep Button [SLPB]
[    4.639906] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    4.639908] ACPI: Power Button [PWRF]
[    4.729516] mei 0000:00:16.0: setting latency timer to 64
[    4.729602] mei 0000:00:16.0: irq 44 for MSI/MSI-X
[    4.730475] wmi: Mapper loaded
[    4.731655] e1000e: Intel(R) PRO/1000 Network Driver - 2.1.4-k
[    4.731657] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    4.734795] e1000e 0000:00:19.0: setting latency timer to 64
[    4.734865] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    4.734896] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[    4.777962] Non-volatile memory driver v1.3
[    4.830410] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    4.909856] ACPI: Battery Slot [BAT0] (battery present)
[    4.930859] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:21:cc:d3:14:02
[    4.930862] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.930900] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: 1000FF-0FF
[    1.509376] ACPI: Invalid Power Resource to register!
[    4.930956] ACPI Warning: 
[    4.930959] 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \_SB_.PCI0.LPC_.PMIO 1 (20120913/utaddress-251)
[    4.930962] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.930966] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20120913/utaddress-251)
[    4.930969] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.930970] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_SB_.PCI0.LPC_.LPIO 1 (20120913/utaddress-251)
[    4.930972] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.930974] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    4.931105] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    4.961788] tpm_tis 00:0a: 1.2 TPM (device-id 0x0, rev-id 78)
[    5.006999] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input5
[    5.010223] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[    5.010225] thinkpad_acpi: http://ibm-acpi.sf.net/
[    5.010226] thinkpad_acpi: ThinkPad BIOS G1ET91WW (2.51 ), EC unknown
[    5.010227] thinkpad_acpi: Lenovo ThinkPad T430, model 2342CTO
[    5.010683] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[    5.010788] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    5.010798] thinkpad_acpi: radio switch found; radios are enabled
[    5.010946] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    5.010947] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    5.011009] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[    5.011108] input: HDA Intel PCH Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[    5.011170] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[    5.012503] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[    5.012841] Registered led device: tpacpi::thinklight
[    5.013018] Registered led device: tpacpi::power
[    5.013041] Registered led device: tpacpi::standby
[    5.013729] Registered led device: tpacpi::thinkvantage
[    5.013738] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[    5.014871] cfg80211: Calling CRDA to update world regulatory domain
[    5.014936] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    5.015641] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input10
[    5.028906] tpm_tis 00:0a: TPM is disabled/deactivated (0x6)
[    5.216057] iTCO_vendor_support: vendor-support=0
[    5.378667] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    5.378669] Copyright(c) 2003-2012 Intel Corporation
[    5.378752] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[    5.378754] iwlwifi 0000:03:00.0: pci_resource_base = ffffc90005bb8000
[    5.378755] iwlwifi 0000:03:00.0: HW Revision ID = 0x3E
[    5.378856] iwlwifi 0000:03:00.0: irq 47 for MSI/MSI-X
[    5.400464] [drm] Initialized drm 1.1.0 20060810
[    5.464124] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    5.464170] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    5.464307] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.929760] media: Linux media interface: v0.10
[    5.957111] Linux video capture interface: v2.00
[    5.988811] i915 0000:00:02.0: enabling device (0006 -> 0007)
[    5.988964] pci 0000:00:00.0: Intel Ivybridge Chipset
[    5.989050] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    5.989746] pci 0000:00:00.0: detected 65536K stolen memory
[    5.989780] checking generic (e0000000 580000) vs hw (e0000000 10000000)
[    5.989782] fb: conflicting fb hw usage inteldrmfb vs EFI VGA - removing generic driver
[    5.989794] Console: switching to colour dummy device 80x25
[    5.989881] i915 0000:00:02.0: setting latency timer to 64
[    6.020699] [drm:__gen6_gt_force_wake_mt_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[    6.020814] i915 0000:00:02.0: irq 48 for MSI/MSI-X
[    6.020820] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.020820] [drm] Driver supports precise vblank timestamp query.
[    6.020846] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=mem
[    6.068248] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b2db)
[    6.070273] input: Integrated Camera as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.6/3-1.6:1.0/input/input11
[    6.070317] usbcore: registered new interface driver uvcvideo
[    6.070317] USB Video Class driver (1.1.1)
[    6.150468] psmouse serio1: synaptics: Touchpad model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd047b3/0xb40000/0xa0000, board id: 71, fw id: 920262
[    6.150474] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
[    6.173170] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    6.186192] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input12
[    6.191298] Bluetooth: Core ver 2.16
[    6.191316] NET: Registered protocol family 31
[    6.191317] Bluetooth: HCI device and connection manager initialized
[    6.191323] Bluetooth: HCI socket layer initialized
[    6.191325] Bluetooth: L2CAP socket layer initialized
[    6.191330] Bluetooth: SCO socket layer initialized
[    6.320818] fbcon: inteldrmfb (fb0) is primary device
[    6.322006] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1 build 25532
[    6.522740] usbcore: registered new interface driver btusb
[    6.633208] iwldvm: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    6.633209] iwldvm: Copyright(c) 2003-2012 Intel Corporation
[    6.633221] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    6.633221] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    6.633222] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[    6.633222] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    6.633223] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[    6.633224] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
[    6.633264] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    6.639838] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[    6.648786] iwlwifi 0000:03:00.0: device EEPROM VER=0x43a, CALIB=0x6
[    6.648787] iwlwifi 0000:03:00.0: Device SKU: 0x1F0
[    6.648787] iwlwifi 0000:03:00.0: Valid Tx ant: 0x7, Valid Rx ant: 0x7
[    6.648831] Registered led device: phy0-led
[    6.681646] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    7.129151] Console: switching to colour frame buffer device 200x56
[    7.137217] fb0: inteldrmfb frame buffer device
[    7.137218] drm: registered panic notifier
[    7.161482] acpi device:00: registered as cooling_device4
[    7.161548] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    7.161582] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input13
[    7.161709] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    7.171104] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: data=ordered
[    7.325548] systemd-journald[139]: Received SIGUSR1
[    8.543626] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3cold
[    8.570262] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3cold
[    8.606048] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    8.706789] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    8.780139] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[    8.883181] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    9.443445] e1000e 0000:00:19.0 eth0: Error reading PHY register
[    9.712748] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    9.712755] Bluetooth: BNEP socket layer initialized
[    9.820371] Bluetooth: RFCOMM TTY layer initialized
[    9.820379] Bluetooth: RFCOMM socket layer initialized
[    9.820381] Bluetooth: RFCOMM ver 1.11
[   10.244992] e1000e 0000:00:19.0 eth0: Error reading PHY register
[   11.032539] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   11.046466] e1000e 0000:00:19.0 eth0: Error reading PHY register
[   11.226685] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input14
[   11.847820] e1000e 0000:00:19.0 eth0: Error reading PHY register
[   12.649262] e1000e 0000:00:19.0 eth0: Error reading PHY register
[   13.450689] e1000e 0000:00:19.0 eth0: Error reading PHY register
[   14.252236] e1000e 0000:00:19.0 eth0: Error reading PHY register
[   15.053788] e1000e 0000:00:19.0 eth0: Error reading PHY register
[   15.855379] e1000e 0000:00:19.0 eth0: Error reading PHY register
[   16.656944] e1000e 0000:00:19.0 eth0: Error reading PHY register
[   17.373929] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   17.477218] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[   17.477964] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   17.481914] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   17.488604] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[   17.856950] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   17.863608] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[   18.108968] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   30.226569] EXT4-fs (sda2): re-mounted. Opts: data=ordered,commit=0
[   30.529254] EXT4-fs (sda3): re-mounted. Opts: data=ordered,commit=0
[   46.718370] wlan0: authenticate with 50:67:f0:85:97:19
[   46.740134] wlan0: send auth to 50:67:f0:85:97:19 (try 1/3)
[   46.741988] wlan0: authenticated
[   46.742116] wlan0: waiting for beacon from 50:67:f0:85:97:19
[   46.799965] wlan0: associate with 50:67:f0:85:97:19 (try 1/3)
[   46.803784] wlan0: RX AssocResp from 50:67:f0:85:97:19 (capab=0x411 status=0 aid=2)
[   46.806005] wlan0: associated
[   46.806036] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   46.809956] wlan0: dropped frame to 50:67:f0:85:97:19 (unauthorized port)
[   46.815070] wlan0: Rx A-MPDU request on tid 0 result 0
[  121.821793] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  122.364139] wlan0: deauthenticating from 50:67:f0:85:97:19 by local choice (reason=3)
[  122.364156] wlan0: Rx BA session stop requested for 50:67:f0:85:97:19 tid 0 recipient reason: 36
[  122.409558] cfg80211: Calling CRDA to update world regulatory domain
[  122.613812] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  122.717019] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  122.717703] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[  122.719482] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  122.727225] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[  122.993645] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  122.507580] PM: Syncing filesystems ... done.
[  123.143950] PM: Preparing system for mem sleep
[  123.245498] Freezing user space processes ... (elapsed 0.10 seconds) done.
[  123.352725] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  123.366087] PM: Entering mem sleep
[  123.366178] Suspending console(s) (use no_console_suspend to debug)
[  123.609445] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[  123.609626] sd 2:0:0:0: [sdb] Stopping disk
[  123.609735] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  123.609916] sd 0:0:0:0: [sda] Stopping disk
[  123.879204] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[  124.124848] i915 0000:00:02.0: power state changed by ACPI to D3hot
[  124.124924] PM: suspend of devices complete after 732.964 msecs
[  124.125285] PM: late suspend of devices complete after 0.358 msecs
[  124.138255] ehci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[  124.151414] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D3hot
[  124.151570] ehci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
[  124.164716] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D3hot
[  124.178088] xhci_hcd 0000:00:14.0: wake-up capability enabled by ACPI
[  124.191338] xhci_hcd 0000:00:14.0: power state changed by ACPI to D3hot
[  124.191438] PM: noirq suspend of devices complete after 66.248 msecs
[  124.191879] ACPI: Preparing to enter system sleep state S3
[  124.341152] PM: Saving platform NVS memory
[  124.347838] Disabling non-boot CPUs ...
[  124.349362] smpboot: CPU 1 is now offline
[  124.351345] smpboot: CPU 2 is now offline
[  124.454274] smpboot: CPU 3 is now offline
[  124.454674] Extended CMOS year: 2000
[  124.455789] ACPI: Low-level resume complete
[  124.455829] PM: Restoring platform NVS memory
[  124.456230] Extended CMOS year: 2000
[  124.456279] Enabling non-boot CPUs ...
[  124.459695] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  124.525808] CPU1 is up
[  124.525866] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  124.592378] CPU2 is up
[  124.592448] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  124.658974] CPU3 is up
[  124.662389] ACPI: Waking up from system sleep state S3
[  124.948577] i915 0000:00:02.0: power state changed by ACPI to D0
[  124.961784] xhci_hcd 0000:00:14.0: power state changed by ACPI to D0
[  124.975148] xhci_hcd 0000:00:14.0: wake-up capability disabled by ACPI
[  125.001751] ehci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[  125.015072] ehci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
[  125.028659] ehci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[  125.041695] ehci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[  125.068493] sdhci-pci 0000:02:00.0: MMC controller base frequency changed to 50Mhz.
[  125.081570] iwlwifi 0000:03:00.0: Refused to change power state, currently in D3
[  125.141977] PM: noirq resume of devices complete after 193.808 msecs
[  125.142135] PM: early resume of devices complete after 0.110 msecs
[  125.142148] i915 0000:00:02.0: setting latency timer to 64
[  125.142163] xhci_hcd 0000:00:14.0: setting latency timer to 64
[  125.142204] mei 0000:00:16.0: irq 44 for MSI/MSI-X
[  125.142218] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[  125.142247] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  125.142277] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[  125.142313] ahci 0000:00:1f.2: setting latency timer to 64
[  125.142323] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  125.142469] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[  125.178078] [drm:__gen6_gt_force_wake_mt_get] *ERROR* Timed out waiting for forcewake old ack to clear.
[  125.178119] tpm_tis 00:0a: TPM is disabled/deactivated (0x6)
[  125.178700] Extended CMOS year: 2000
[  125.179436] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[  125.381320] usb 3-1.6: reset high-speed USB device number 5 using ehci_hcd
[  125.474423] ata5: SATA link down (SStatus 0 SControl 300)
[  125.481058] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  125.483991] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[  125.484320] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[  125.487727] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  125.487783] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  125.490057] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 (IDLE) succeeded
[  125.490091] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  125.490100] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  125.490223] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  125.490229] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  125.490380] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 (IDLE) succeeded
[  125.491496] ata3.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  125.491503] ata3.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  125.491670] ata3.00: configured for UDMA/133
[  125.491956] ata2.00: configured for UDMA/100
[  125.493262] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
[  125.493269] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
[  125.494222] ata1.00: configured for UDMA/133
[  125.504494] sd 2:0:0:0: [sdb] Starting disk
[  125.507804] sd 0:0:0:0: [sda] Starting disk
[  125.547892] usb 3-1.1: reset full-speed USB device number 3 using ehci_hcd
[  125.697761] usb 3-1.4: reset full-speed USB device number 4 using ehci_hcd
[  125.783063] btusb 3-1.4:1.0: no reset_resume for driver btusb?
[  125.783066] btusb 3-1.4:1.1: no reset_resume for driver btusb?
[  125.783425] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  125.803679] ------------[ cut here ]------------
[  125.803696] WARNING: at drivers/net/wireless/iwlwifi/iwl-io.c:150 iwl_grab_nic_access+0x7f/0xf0 [iwlwifi]()
[  125.803697] Hardware name: 2342CTO
[  125.803699] Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
[  125.803757] Modules linked in: rfcomm bnep arc4 iwldvm mac80211 btusb joydev bluetooth uvcvideo videobuf2_vmalloc i915 videobuf2_memops videobuf2_core videodev media coretemp kvm_intel kvm i2c_algo_bit intel_agp intel_gtt crc32c_intel ghash_clmulni_intel aesni_intel iTCO_wdt xts drm_kms_helper drm psmouse iwlwifi aes_x86_64 acpi_cpufreq iTCO_vendor_support cfg80211 thinkpad_acpi snd_hda_codec_realtek serio_raw i2c_i801 tpm_tis tpm lrw battery mperf tpm_bios snd_hda_intel snd_hda_codec snd_hwdep snd_pcm evdev i2c_core pcspkr lpc_ich snd_page_alloc gf128mul nvram snd_timer snd rfkill soundcore e1000e wmi mei mfd_core button video thermal ac ablk_helper processor cryptd microcode ext4 crc16 jbd2 mbcache sr_mod cdrom sd_mod ahci libahci libata ehci_hcd xhci_hcd sdhci_pci scsi_mod sdhci mmc_core usbcore
[  125.803759]  usb_common
[  125.803762] Pid: 2026, comm: systemd-sleep Not tainted 3.7.5-vanilla-ARCH #4
[  125.803763] Call Trace:
[  125.803771]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[  125.803774]  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
[  125.803782]  [<ffffffffa0328838>] ? iwl_grab_nic_access_silent+0x188/0x200 [iwlwifi]
[  125.803787]  [<ffffffffa032892f>] iwl_grab_nic_access+0x7f/0xf0 [iwlwifi]
[  125.803792]  [<ffffffffa032961b>] iwl_write_prph+0x3b/0x190 [iwlwifi]
[  125.803798]  [<ffffffffa0334186>] iwl_apm_init+0x136/0x1e0 [iwlwifi]
[  125.803803]  [<ffffffffa0334ddc>] iwl_trans_pcie_start_fw+0xec/0x15a0 [iwlwifi]
[  125.803810]  [<ffffffff810145b3>] ? __switch_to+0x163/0x4e0
[  125.803818]  [<ffffffff814898b5>] ? _raw_spin_unlock_bh+0x25/0x30
[  125.803825]  [<ffffffffa032b501>] ? iwl_init_notification_wait+0x71/0xb0 [iwlwifi]
[  125.803835]  [<ffffffffa0506be3>] iwl_load_ucode_wait_alive+0x93/0x4b0 [iwldvm]
[  125.803844]  [<ffffffffa050e568>] ? iwl_sta_alloc_lq+0x68/0xb0 [iwldvm]
[  125.803852]  [<ffffffffa05064b0>] ? iwl_alloc_all+0x30/0x30 [iwldvm]
[  125.803859]  [<ffffffffa05059aa>] iwlagn_mac_start+0x13a/0x220 [iwldvm]
[  125.803875]  [<ffffffffa0499799>] ieee80211_reconfig+0x199/0x1560 [mac80211]
[  125.803890]  [<ffffffffa048b03d>] ieee80211_resume+0x2d/0x70 [mac80211]
[  125.803901]  [<ffffffffa02fd111>] wiphy_resume+0xa1/0xb0 [cfg80211]
[  125.803909]  [<ffffffffa02fd070>] ? wiphy_suspend+0x80/0x80 [cfg80211]
[  125.803914]  [<ffffffff813440d8>] dpm_run_callback+0x58/0x90
[  125.803918]  [<ffffffff813441bc>] device_resume+0xac/0x1a0
[  125.803921]  [<ffffffff81345824>] dpm_resume+0x104/0x230
[  125.803925]  [<ffffffff81345b75>] dpm_resume_end+0x15/0x30
[  125.803931]  [<ffffffff812c2fb9>] ? acpi_suspend_begin_old+0x2d/0x2d
[  125.803937]  [<ffffffff8109f856>] suspend_devices_and_enter+0xb6/0x340
[  125.803941]  [<ffffffff8109fc9a>] pm_suspend+0x1ba/0x230
[  125.803945]  [<ffffffff8109ef65>] state_store+0xa5/0xc0
[  125.803948]  [<ffffffff812660ef>] kobj_attr_store+0xf/0x20
[  125.803953]  [<ffffffff811f5e6d>] sysfs_write_file+0xcd/0x140
[  125.803959]  [<ffffffff81182ed8>] vfs_write+0xa8/0x180
[  125.803963]  [<ffffffff81183222>] sys_write+0x52/0xa0
[  125.803966]  [<ffffffff8148d65e>] ? do_page_fault+0xe/0x10
[  125.803971]  [<ffffffff8149159d>] system_call_fastpath+0x1a/0x1f
[  125.803973] ---[ end trace fa05d5aae4037a4e ]---
[  125.844528] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[  131.575338] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
[  131.575342] iwlwifi 0000:03:00.0: Could not load the [0] uCode section
[  131.575356] iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
[  131.987481] iwlwifi 0000:03:00.0: Unable to initialize device.
[  131.987481] ------------[ cut here ]------------
[  131.987489] WARNING: at net/mac80211/util.c:1348 ieee80211_reconfig+0x63c/0x1560 [mac80211]()
[  131.987490] Hardware name: 2342CTO
[  131.987490] Hardware became unavailable upon resume. This could be a software issue prior to suspend or a hardware issue.
[  131.987525] Modules linked in: rfcomm bnep arc4 iwldvm mac80211 btusb joydev bluetooth uvcvideo videobuf2_vmalloc i915 videobuf2_memops videobuf2_core videodev media coretemp kvm_intel kvm i2c_algo_bit intel_agp intel_gtt crc32c_intel ghash_clmulni_intel aesni_intel iTCO_wdt xts drm_kms_helper drm psmouse iwlwifi aes_x86_64 acpi_cpufreq iTCO_vendor_support cfg80211 thinkpad_acpi snd_hda_codec_realtek serio_raw i2c_i801 tpm_tis tpm lrw battery mperf tpm_bios snd_hda_intel snd_hda_codec snd_hwdep snd_pcm evdev i2c_core pcspkr lpc_ich snd_page_alloc gf128mul nvram snd_timer snd rfkill soundcore e1000e wmi mei mfd_core button video thermal ac ablk_helper processor cryptd microcode ext4 crc16 jbd2 mbcache sr_mod cdrom sd_mod ahci libahci libata ehci_hcd xhci_hcd sdhci_pci scsi_mod sdhci mmc_core usbcore
[  131.987526]  usb_common
[  131.987527] Pid: 2026, comm: systemd-sleep Tainted: G        W    3.7.5-vanilla-ARCH #4
[  131.987528] Call Trace:
[  131.987532]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[  131.987533]  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
[  131.987536]  [<ffffffffa0499c3c>] ieee80211_reconfig+0x63c/0x1560 [mac80211]
[  131.987540]  [<ffffffffa048b03d>] ieee80211_resume+0x2d/0x70 [mac80211]
[  131.987543]  [<ffffffffa02fd111>] wiphy_resume+0xa1/0xb0 [cfg80211]
[  131.987545]  [<ffffffffa02fd070>] ? wiphy_suspend+0x80/0x80 [cfg80211]
[  131.987548]  [<ffffffff813440d8>] dpm_run_callback+0x58/0x90
[  131.987549]  [<ffffffff813441bc>] device_resume+0xac/0x1a0
[  131.987550]  [<ffffffff81345824>] dpm_resume+0x104/0x230
[  131.987551]  [<ffffffff81345b75>] dpm_resume_end+0x15/0x30
[  131.987554]  [<ffffffff812c2fb9>] ? acpi_suspend_begin_old+0x2d/0x2d
[  131.987556]  [<ffffffff8109f856>] suspend_devices_and_enter+0xb6/0x340
[  131.987557]  [<ffffffff8109fc9a>] pm_suspend+0x1ba/0x230
[  131.987558]  [<ffffffff8109ef65>] state_store+0xa5/0xc0
[  131.987560]  [<ffffffff812660ef>] kobj_attr_store+0xf/0x20
[  131.987561]  [<ffffffff811f5e6d>] sysfs_write_file+0xcd/0x140
[  131.987564]  [<ffffffff81182ed8>] vfs_write+0xa8/0x180
[  131.987565]  [<ffffffff81183222>] sys_write+0x52/0xa0
[  131.987568]  [<ffffffff8148d65e>] ? do_page_fault+0xe/0x10
[  131.987570]  [<ffffffff8149159d>] system_call_fastpath+0x1a/0x1f
[  131.987570] ---[ end trace fa05d5aae4037a4f ]---
[  131.987573] dpm_run_callback(): wiphy_resume+0x0/0xb0 [cfg80211] returns -110
[  131.987575] PM: Device phy0 failed to resume: error -110
[  131.987599] PM: resume of devices complete after 6855.660 msecs
[  132.002057] PM: Finishing wakeup.
[  132.002060] Restarting tasks ... done.
[  132.020880] video LNXVIDEO:00: Restoring backlight state
[  132.063375] ------------[ cut here ]------------
[  132.063387] WARNING: at net/mac80211/driver-ops.h:12 ieee80211_do_stop+0x6fb/0x730 [mac80211]()
[  132.063389] Hardware name: 2342CTO
[  132.063390] wlan0:  Failed check-sdata-in-driver check, flags: 0x4
[  132.063391] Modules linked in: rfcomm bnep arc4 iwldvm mac80211 btusb joydev bluetooth uvcvideo videobuf2_vmalloc i915 videobuf2_memops videobuf2_core videodev media coretemp kvm_intel kvm i2c_algo_bit intel_agp intel_gtt crc32c_intel ghash_clmulni_intel aesni_intel iTCO_wdt xts drm_kms_helper drm psmouse iwlwifi aes_x86_64 acpi_cpufreq iTCO_vendor_support cfg80211 thinkpad_acpi snd_hda_codec_realtek serio_raw i2c_i801 tpm_tis tpm lrw battery mperf tpm_bios snd_hda_intel snd_hda_codec snd_hwdep snd_pcm evdev i2c_core pcspkr lpc_ich snd_page_alloc gf128mul nvram snd_timer snd rfkill soundcore e1000e wmi mei mfd_core button video thermal ac ablk_helper processor cryptd microcode ext4 crc16 jbd2 mbcache sr_mod cdrom sd_mod ahci libahci libata ehci_hcd xhci_hcd sdhci_pci scsi_mod sdhci mmc_core usbcore
[  132.063438]  usb_common
[  132.063440] Pid: 958, comm: NetworkManager Tainted: G        W    3.7.5-vanilla-ARCH #4
[  132.063442] Call Trace:
[  132.063447]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[  132.063450]  [<ffffffff81057606>] warn_slowpath_fmt+0x46/0x50
[  132.063457]  [<ffffffffa049750c>] ? ieee80211_free_keys+0x7c/0x90 [mac80211]
[  132.063462]  [<ffffffffa0483c5b>] ieee80211_do_stop+0x6fb/0x730 [mac80211]
[  132.063466]  [<ffffffff813ba531>] ? dev_deactivate_many+0x201/0x250
[  132.063470]  [<ffffffffa0483caa>] ieee80211_stop+0x1a/0x20 [mac80211]
[  132.063473]  [<ffffffff8139bb95>] __dev_close_many+0x75/0xc0
[  132.063475]  [<ffffffff8139bc0d>] __dev_close+0x2d/0x40
[  132.063478]  [<ffffffff813a0581>] __dev_change_flags+0xa1/0x180
[  132.063480]  [<ffffffff813a0718>] dev_change_flags+0x28/0x70
[  132.063483]  [<ffffffff813ad70a>] do_setlink+0x38a/0xa20
[  132.063487]  [<ffffffff81280261>] ? nla_parse+0x31/0xe0
[  132.063490]  [<ffffffff81280261>] ? nla_parse+0x31/0xe0
[  132.063492]  [<ffffffff813aee7e>] rtnl_newlink+0x36e/0x590
[  132.063496]  [<ffffffff813ae6a4>] rtnetlink_rcv_msg+0x114/0x300
[  132.063498]  [<ffffffff813ae590>] ? __rtnl_unlock+0x20/0x20
[  132.063502]  [<ffffffff813c4e11>] netlink_rcv_skb+0xb1/0xc0
[  132.063504]  [<ffffffff813acca5>] rtnetlink_rcv+0x25/0x40
[  132.063506]  [<ffffffff813c474b>] netlink_unicast+0x19b/0x220
[  132.063508]  [<ffffffff813c4bb9>] netlink_sendmsg+0x329/0x3a0
[  132.063512]  [<ffffffff813855fa>] sock_sendmsg+0xda/0xf0
[  132.063515]  [<ffffffff813859e1>] __sys_sendmsg+0x371/0x380
[  132.063518]  [<ffffffff8119ea67>] ? fget_light+0x97/0x100
[  132.063521]  [<ffffffff81388cd9>] sys_sendmsg+0x49/0x90
[  132.063525]  [<ffffffff8149159d>] system_call_fastpath+0x1a/0x1f
[  132.063527] ---[ end trace fa05d5aae4037a50 ]---
[  132.063529] ------------[ cut here ]------------
[  132.063533] WARNING: at drivers/net/wireless/iwlwifi/dvm/mac80211.c:1424 iwlagn_mac_remove_interface+0x11b/0x1b0 [iwldvm]()
[  132.063534] Hardware name: 2342CTO
[  132.063535] Modules linked in: rfcomm bnep arc4 iwldvm mac80211 btusb joydev bluetooth uvcvideo videobuf2_vmalloc i915 videobuf2_memops videobuf2_core videodev media coretemp kvm_intel kvm i2c_algo_bit intel_agp intel_gtt crc32c_intel ghash_clmulni_intel aesni_intel iTCO_wdt xts drm_kms_helper drm psmouse iwlwifi aes_x86_64 acpi_cpufreq iTCO_vendor_support cfg80211 thinkpad_acpi snd_hda_codec_realtek serio_raw i2c_i801 tpm_tis tpm lrw battery mperf tpm_bios snd_hda_intel snd_hda_codec snd_hwdep snd_pcm evdev i2c_core pcspkr lpc_ich snd_page_alloc gf128mul nvram snd_timer snd rfkill soundcore e1000e wmi mei mfd_core button video thermal ac ablk_helper processor cryptd microcode ext4 crc16 jbd2 mbcache sr_mod cdrom sd_mod ahci libahci libata ehci_hcd xhci_hcd sdhci_pci scsi_mod sdhci mmc_core usbcore
[  132.063572]  usb_common
[  132.063574] Pid: 958, comm: NetworkManager Tainted: G        W    3.7.5-vanilla-ARCH #4
[  132.063575] Call Trace:
[  132.063577]  [<ffffffff8105750f>] warn_slowpath_common+0x7f/0xc0
[  132.063579]  [<ffffffff8105756a>] warn_slowpath_null+0x1a/0x20
[  132.063582]  [<ffffffffa0504efb>] iwlagn_mac_remove_interface+0x11b/0x1b0 [iwldvm]
[  132.063587]  [<ffffffffa048394f>] ieee80211_do_stop+0x3ef/0x730 [mac80211]
[  132.063589]  [<ffffffff813ba531>] ? dev_deactivate_many+0x201/0x250
[  132.063594]  [<ffffffffa0483caa>] ieee80211_stop+0x1a/0x20 [mac80211]
[  132.063596]  [<ffffffff8139bb95>] __dev_close_many+0x75/0xc0
[  132.063598]  [<ffffffff8139bc0d>] __dev_close+0x2d/0x40
[  132.063600]  [<ffffffff813a0581>] __dev_change_flags+0xa1/0x180
[  132.063603]  [<ffffffff813a0718>] dev_change_flags+0x28/0x70
[  132.063605]  [<ffffffff813ad70a>] do_setlink+0x38a/0xa20
[  132.063608]  [<ffffffff81280261>] ? nla_parse+0x31/0xe0
[  132.063610]  [<ffffffff81280261>] ? nla_parse+0x31/0xe0
[  132.063613]  [<ffffffff813aee7e>] rtnl_newlink+0x36e/0x590
[  132.063615]  [<ffffffff813ae6a4>] rtnetlink_rcv_msg+0x114/0x300
[  132.063618]  [<ffffffff813ae590>] ? __rtnl_unlock+0x20/0x20
[  132.063620]  [<ffffffff813c4e11>] netlink_rcv_skb+0xb1/0xc0
[  132.063622]  [<ffffffff813acca5>] rtnetlink_rcv+0x25/0x40
[  132.063625]  [<ffffffff813c474b>] netlink_unicast+0x19b/0x220
[  132.063627]  [<ffffffff813c4bb9>] netlink_sendmsg+0x329/0x3a0
[  132.063630]  [<ffffffff813855fa>] sock_sendmsg+0xda/0xf0
[  132.063633]  [<ffffffff813859e1>] __sys_sendmsg+0x371/0x380
[  132.063636]  [<ffffffff8119ea67>] ? fget_light+0x97/0x100
[  132.063639]  [<ffffffff81388cd9>] sys_sendmsg+0x49/0x90
[  132.063642]  [<ffffffff8149159d>] system_call_fastpath+0x1a/0x1f
[  132.063643] ---[ end trace fa05d5aae4037a51 ]---
[  132.063647] iwlwifi 0000:03:00.0: ctx->vif =           (null), vif = ffff8802110d6f78
[  132.063650] iwlwifi 0000:03:00.0: 	ID = 0:	ctx = ffff88020924add8	ctx->vif =           (null)
[  132.212683] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  132.314352] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  132.315043] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[  132.316038] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  132.366840] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[  138.085577] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
[  138.085586] iwlwifi 0000:03:00.0: Could not load the [0] uCode section
[  138.085593] iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
[  138.498302] iwlwifi 0000:03:00.0: Unable to initialize device.
[  138.500501] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  138.562605] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[  144.296319] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
[  144.296329] iwlwifi 0000:03:00.0: Could not load the [0] uCode section
[  144.296336] iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
[  144.710847] iwlwifi 0000:03:00.0: Unable to initialize device.
[  144.711506] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  144.773563] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[  150.507086] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
[  150.507096] iwlwifi 0000:03:00.0: Could not load the [0] uCode section
[  150.507104] iwlwifi 0000:03:00.0: Failed to start RT ucode: -110
[  150.919888] iwlwifi 0000:03:00.0: Unable to initialize device.

# iw event -t
1359486504.070732: wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5600 5620 5640 5660 5680 5700 5745 5765 5785 5805 5825, ""
1359486504.071000: wlan0 (phy #0): connection quality monitor event: RSSI went below threshold
1359486541.189039: wlan0 (phy #0): scan started
1359486543.613952: wlan0: del station 50:67:f0:85:97:19
1359486543.651883: wlan0 (phy #0): deauth 24:77:03:ce:7f:c8 -> 50:67:f0:85:97:19 reason 3: Deauthenticated because sending station is leaving (or has left) the IBSS or ESS
1359486543.652027: wlan0 (phy #0): disconnected (local request)
1359486543.652214: wlan0 (phy #0): scan aborted: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5600 5620 5640 5660 5680 5700 5745 5765 5785 5805 5825, ""
1359486544.271577: wlan0 (phy #0): scan started
1359486563.560552: wlan0 (phy #0): scan aborted: 2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472 5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 5580 5600 5620 5640 5660 5680 5700 5745 5765 5785 5805 5825, ""

Thanks,

-- 
Maciek Zarzycki
--nextPart4805672.WRqRiluFoo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJRCCPUAAoJELQoTSk9p7WNrRkH/jIRTCBdmBeMe7f0pgh1VHiR
qLqgkbehty4p+LZ/zENU6DlK6bxHrfXVJFTzsURzd4EktmkR26ej+t+0h2c+1fCR
CZ2iV8gV9q/k11u0jIxKQG3JHZVGuTBvwLfSfJAHSsEu0j8tvoXBix3Zv7ppmAAO
EjgPNMh2u6C+AWxh0iavzIkqyn1ye+59kK6CIIHmx2P75yVIF6Q+zN+1/o+y4MDC
py77kSCGYB1ez881sbBfpHuQWbpe2O39rF2jhEUGKov8MzVi5T0Kw9yI5QppIqIx
Zy94ECeSiYnUvjHJkAv9Xw44MZ7gk5zjig52TA4izDzGGnmdV9cXFOzMz1agSKg=
=GMfQ
-----END PGP SIGNATURE-----

--nextPart4805672.WRqRiluFoo--


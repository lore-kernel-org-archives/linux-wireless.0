Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from daemonizer.de ([178.77.74.210]:60849 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423388Ab3FUSfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 14:35:53 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: brcm80211-dev-list@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: Poor wireless reception on BCM4313
Date: Fri, 21 Jun 2013 20:26:25 +0200
Message-ID: <1624172.s6pnfBcJL7@fuchs> (sfid-20130621_203600_615005_BBC24A0F)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1667363.A4eKZJKYcg"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1667363.A4eKZJKYcg
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hello developers,

I'm having problems with the reception performance of my BCM4313 wireless 
card. The card is basically working fine, but the reception is quite bad 
compared to other wifi equipment. I first suspected a hardware problem, but 
after I tried Windows 7 with the same hardware and having no problem there I'm 
quite sure this is a software issue.


Here is a more detailed explanation of a test setup I performed to show the 
problem:

I have an AP in about 2m distance and I connected to it by my BCM4313 card and 
by a USB dongle (TP-Link TL-WN821N, using ath9k_htc). Both connections work 
and I can ping the AP using both cards.

iw dev $DEV link shows a signal of about -68 dBm for the broadcom card and 
about -51 dBm for the atheros dongle. I have no idea in how far one can trust 
these values, but the difference between these two cards mostly seems to be 
20-30 dB, also in my further experiments (greater distance from the AP).

Now with both dongles being connected I move my laptop away from the AP and of 
course the signal is getting weaker. However at some point the broadcom card 
looses the connection to the AP while the USB dongle still has good connection 
(at this point the signal strength of the broadcom card is about -90dBm and 
-60dBm for the USB dongle). In my test with the Windows driver at that point 
the connection was still good and maximum distance till I lost the connection 
was much larger. So I don't think is a hardware problem.

In general I can say my BCM4313 card is only usable when I'm in vicinity of 
the AP. If I move further away the connection becomes unusable slow or is 
lost, while it is still working well using other cards/drivers.


I'm currently using a 3.10-rc5 kernel with Debian jessie (kernel is from 
experimental, but the same behavior has been there with kernel 3.9, 3.8 (and 
older)). The driver used for the broadcom card is brcmsmac.


I did a search non the Internet regarding this issue and found some other 
people having the same problem but no real solution to this. There is a 
workaround some Ubuntu related sites, which consists of blacklisting the 
brcmsmac driver and installing the wl driver. With the wl driver this problem 
seems to be fixed according to the web (I didn't try it myself).

As I have no idea where this problem could be and how I can debug it, so I'm 
writing this mail now. If you need any addition information I'm happy to 
provide it.
>From the numbers shown above it seems like there is an attenuator of 20-30dB 
active on the receiver of the broadcom card.


Here is some additional information about my system:

$ lspci -vvv -n -s02:00.0
02:00.0 0280: 14e4:4727 (rev 01)
        Subsystem: 14e4:0608
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f0200000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>
        Kernel driver in use: bcma-pci-bridge

$ ethtool -i wlan0
driver: brcmsmac
version: 3.10-rc5-amd64
firmware-version: 610.812
bus-info: bcma0:0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

$ iw dev wlan0 info
Interface wlan0
        ifindex 3
        type managed
        wiphy 0

$ iw phy phy0 info
Wiphy phy0
        Band 1:
                Capabilities: 0x70
                        HT20
                        Static SM Power Save
                        RX Greenfield
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 3839 bytes
                        No DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT TX/RX MCS rate indexes supported: 0-7
                Frequencies:
                        * 2412 MHz [1] (20.0 dBm)
                        * 2417 MHz [2] (20.0 dBm)
                        * 2422 MHz [3] (20.0 dBm)
                        * 2427 MHz [4] (20.0 dBm)
                        * 2432 MHz [5] (20.0 dBm)
                        * 2437 MHz [6] (20.0 dBm)
                        * 2442 MHz [7] (20.0 dBm)
                        * 2447 MHz [8] (20.0 dBm)
                        * 2452 MHz [9] (20.0 dBm)
                        * 2457 MHz [10] (20.0 dBm)
                        * 2462 MHz [11] (20.0 dBm)
                        * 2467 MHz [12] (20.0 dBm) (passive scanning, no IBSS)
                        * 2472 MHz [13] (20.0 dBm) (passive scanning, no IBSS)
                        * 2484 MHz [14] (disabled)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        max scan IEs length: 2257 bytes
        Coverage class: 0 (up to 0m)
        Supported Ciphers:
                * WEP40 (00-0f-ac:1)
                * WEP104 (00-0f-ac:5)
                * TKIP (00-0f-ac:2)
                * CCMP (00-0f-ac:4)
        Available Antennas: TX 0 RX 0
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * monitor
        software interface modes (can always be added):
                 * AP/VLAN
                 * monitor
        interface combinations are not supported
        Supported commands:
                 * new_interface
                 * set_interface
                 * new_key
                 * new_beacon
                 * new_station
                 * new_mpath
                 * set_mesh_params
                 * set_bss
                 * authenticate
                 * associate
                 * deauthenticate
                 * disassociate
                 * join_ibss
                 * join_mesh
                 * set_tx_bitrate_mask
                 * action
                 * frame_wait_cancel
                 * set_wiphy_netns
                 * set_channel
                 * set_wds_peer
                 * Unknown command (84)
                 * Unknown command (87)
                 * Unknown command (85)
                 * Unknown command (89)
                 * Unknown command (92)
                 * connect
                 * disconnect
        Supported TX frame types:
                 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 
0xb0 0xc0 0xd0 0xe0 0xf0
                 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * Unknown mode (10): 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
        Supported RX frame types:
                 * IBSS: 0x40 0xb0 0xc0 0xd0
                 * managed: 0x40 0xd0
                 * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
                 * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
                 * mesh point: 0xb0 0xc0 0xd0
                 * P2P-client: 0x40 0xd0
                 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
                 * Unknown mode (10): 0x40 0xd0
        Device supports RSN-IBSS.
        HT Capability overrides:
                 * MCS: ff ff ff ff ff ff ff ff ff ff
                 * maximum A-MSDU length
                 * supported channel width
                 * short GI for 40 MHz
                 * max A-MPDU length exponent
                 * min MPDU start spacing
        Device supports TX status socket option.
        Device supports HT-IBSS.

$ iw dev wlan0 link
Connected to XX:XX:XX:XX:XX:XX (on wlan0)
        SSID: stustafunk
        freq: 2462
        RX: 1865437 bytes (31687 packets)
        TX: 221621 bytes (1896 packets)
        signal: -68 dBm
        tx bitrate: 24.0 MBit/s

        bss flags:      short-slot-time
        dtim period:    0
        beacon int:     100

$ dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10-rc5-amd64 (debian-kernel@lists.debian.org) 
(gcc version 4.7.2 (Debian 4.7.2-5) ) #1 SMP Debian 3.10~rc5-1~exp1 
(2013-06-11)
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.10-rc5-amd64 
root=/dev/mapper/fuchs--vg-root ro quiet thinkpad-acpi.brightness_enable=1 
acpi_backlight=vendor
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009e7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000d381ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d3820000-0x00000000ded02fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ded03000-0x00000000dee32fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dee33000-0x00000000deeb2fff] ACPI 
data
[    0.000000] BIOS-e820: [mem 0x00000000deeb3000-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fecfffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed80fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000206ffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: LENOVO 335963G/335963G, BIOS HMET19WW (1.05 ) 07/05/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x207000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 207000000 mask FFF000000 uncachable
[    0.000000]   4 base 208000000 mask FF8000000 uncachable
[    0.000000]   5 base 0FED80000 mask FFFFFF000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000] TOM2: 000000021f000000 aka 8688M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] e820: last_pfn = 0xd3820 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fa8f0-0x000fa8ff] mapped at 
[ffff8800000fa8f0]
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0186e000, 0x0186efff] PGTABLE
[    0.000000] BRK [0x0186f000, 0x0186ffff] PGTABLE
[    0.000000] BRK [0x01870000, 0x01870fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x206e00000-0x206ffffff]
[    0.000000]  [mem 0x206e00000-0x206ffffff] page 2M
[    0.000000] BRK [0x01871000, 0x01871fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x204000000-0x206dfffff]
[    0.000000]  [mem 0x204000000-0x206dfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x203ffffff]
[    0.000000]  [mem 0x200000000-0x203ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xd381ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xd37fffff] page 2M
[    0.000000]  [mem 0xd3800000-0xd381ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x36504000-0x37279fff]
[    0.000000] ACPI: RSDP 00000000000f0120 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000deeb2170 00084 (v01 LENOVO TP-HM    00001050 
PTL  00000002)
[    0.000000] ACPI: FACP 00000000deea0000 000F4 (v04 LENOVO TP-HM    00001050 
PTL  00000002)
[    0.000000] ACPI: DSDT 00000000deea2000 0F858 (v01 LENOVO      AMD 00001000 
INTL 20061109)
[    0.000000] ACPI: FACS 00000000dee1a000 00040
[    0.000000] ACPI: HPET 00000000dee9f000 00038 (v01 LENOVO TP-HM    00001050 
PTL  00000002)
[    0.000000] ACPI: APIC 00000000dee9e000 0007A (v02 LENOVO TP-HM    00001050 
PTL  00000002)
[    0.000000] ACPI: MCFG 00000000dee9d000 0003C (v01 LENOVO TP-HM    00001050 
PTL  00000002)
[    0.000000] ACPI: SBST 00000000dee9c000 00030 (v01 LENOVO TP-HM    00001050 
PTL  00000002)
[    0.000000] ACPI: FPDT 00000000dee9b000 00054 (v01 LENOVO TP-HM    00001050 
PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dee9a000 0003E (v01 LENOVO TP-HM    00001050 
PTL  00000002)
[    0.000000] ACPI: UEFI 00000000dee99000 00042 (v01 PTL      COMBUF 00000001 
PTL  00000001)
[    0.000000] ACPI: POAT 00000000dee98000 00055 (v03 LENOVO TP-HM    00001050 
PTL  00000002)
[    0.000000] ACPI: SSDT 00000000dee97000 003DE (v01 AMD    POWERNOW 00000001 
AMD  00000001)
[    0.000000] ACPI: SSDT 00000000dee95000 016E4 (v02    AMD     ALIB 00000001 
MSFT 04000000)
[    0.000000] ACPI: UEFI 00000000dee94000 00292 (v01 LENOVO TP-HM    00001050 
PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000206ffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x206ffffff]
[    0.000000]   NODE_DATA [mem 0x206ffa000-0x206ffdfff]
[    0.000000]  [ffffea0000000000-ffffea00071fffff] PMD -> [ffff8801fee00000-
ffff8802057fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x206ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xd381ffff]
[    0.000000]   node   0: [mem 0x100000000-0x206ffffff]
[    0.000000] On node 0 totalpages: 1943485
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11789 pages used for memmap
[    0.000000]   DMA32 zone: 862240 pages, LIFO batch:31
[    0.000000]   Normal zone: 14728 pages used for memmap
[    0.000000]   Normal zone: 1077248 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 
000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000d3820000 - 
00000000ded03000
[    0.000000] PM: Registered nosave memory: 00000000ded03000 - 
00000000dee33000
[    0.000000] PM: Registered nosave memory: 00000000dee33000 - 
00000000deeb3000
[    0.000000] PM: Registered nosave memory: 00000000deeb3000 - 
00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 
00000000fed80000
[    0.000000] PM: Registered nosave memory: 00000000fed80000 - 
00000000fed81000
[    0.000000] PM: Registered nosave memory: 00000000fed81000 - 
00000000ffc00000
[    0.000000] PM: Registered nosave memory: 00000000ffc00000 - 
0000000100000000
[    0.000000] e820: [mem 0xe0000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 
nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880206c00000 s85184 r8192 
d21312 u524288
[    0.000000] pcpu-alloc: s85184 r8192 d21312 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 1916891
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.10-rc5-amd64 
root=/dev/mapper/fuchs--vg-root ro quiet thinkpad-acpi.brightness_enable=1 
acpi_backlight=vendor
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 7576104k/8503296k available (3708k kernel code, 729356k 
absent, 197836k reserved, 3062k data, 920k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 1696.964 MHz processor
[    0.000006] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 3393.92 BogoMIPS (lpj=6787856)
[    0.000012] pid_max: default: 32768 minimum: 301
[    0.000085] Security Framework initialized
[    0.000094] AppArmor: AppArmor disabled by boot time parameter
[    0.000096] Yama: becoming mindful.
[    0.001185] Dentry cache hash table entries: 1048576 (order: 11, 8388608 
bytes)
[    0.006294] Inode-cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.008601] Mount-cache hash table entries: 256
[    0.008962] Initializing cgroup subsys memory
[    0.008998] Initializing cgroup subsys devices
[    0.009002] Initializing cgroup subsys freezer
[    0.009007] Initializing cgroup subsys net_cls
[    0.009010] Initializing cgroup subsys blkio
[    0.009013] Initializing cgroup subsys perf_event
[    0.009071] tseg: 00dfc00000
[    0.009077] CPU: Physical Processor ID: 0
[    0.009079] CPU: Processor Core ID: 0
[    0.009083] mce: CPU supports 6 MCE banks
[    0.009101] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.009101] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.009101] tlb_flushall_shift: 5
[    0.009256] Freeing SMP alternatives: 12k freed
[    0.010030] ACPI: Core revision 20130328
[    0.023132] ACPI: All ACPI Tables successfully acquired
[    0.228829] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.268494] smpboot: CPU0: AMD E2-1800 APU with Radeon(tm) HD Graphics 
(fam: 14, model: 02, stepping: 00)
[    0.374976] Performance Events: AMD PMU driver.
[    0.374985] ... version:                0
[    0.374988] ... bit width:              48
[    0.374990] ... generic registers:      4
[    0.374993] ... value mask:             0000ffffffffffff
[    0.374996] ... max period:             00007fffffffffff
[    0.374998] ... fixed-purpose events:   0
[    0.375000] ... event mask:             000000000000000f
[    0.375503] NMI watchdog: enabled on all CPUs, permanently consumes one hw-
PMU counter.
[    0.375736] smpboot: Booting Node   0, Processors  #1
[    0.388829] Brought up 2 CPUs
[    0.388834] smpboot: Total of 2 processors activated (6787.85 BogoMIPS)
[    0.391306] devtmpfs: initialized
[    0.397568] PM: Registering ACPI NVS region [mem 0xded03000-0xdee32fff] 
(1245184 bytes)
[    0.398103] regulator-dummy: no parameters
[    0.398231] NET: Registered protocol family 16
[    0.398603] ACPI: bus type PCI registered
[    0.398608] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.398748] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.398753] PCI: not using MMCONFIG
[    0.398757] PCI: Using configuration type 1 for base access
[    0.398759] PCI: Using configuration type 1 for extended access
[    0.400509] bio: create slab <bio-0> at 0
[    0.400770] ACPI: Added _OSI(Module Device)
[    0.400774] ACPI: Added _OSI(Processor Device)
[    0.400778] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.400782] ACPI: Added _OSI(Processor Aggregator Device)
[    0.404142] ACPI: EC: Look up EC in DSDT
[    0.423234] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.442175] ACPI: Interpreter enabled
[    0.442196] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State 
[\_S1_] (20130328/hwxface-568)
[    0.442205] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State 
[\_S2_] (20130328/hwxface-568)
[    0.442235] ACPI: (supports S0 S3 S4 S5)
[    0.442239] ACPI: Using IOAPIC for interrupt routing
[    0.442512] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 
0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.443135] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI 
motherboard resources
[    0.448345] PCI: Using host bridge windows from ACPI; if necessary, use 
"pci=nocrs" and report a bug
[    0.449398] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial 
brightness
[    0.449432] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial 
brightness
[    0.470020] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial 
brightness
[    0.470073] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial 
brightness
[    0.476975] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.479548] acpi PNP0A08:00: ignoring host bridge window [mem 
0x000ce000-0x000cffff] (conflicts with Video ROM [mem 0x000c0000-0x000cedff])
[    0.479568] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 
00-3f] only partially covers this bridge
[    0.479857] PCI host bridge to bus 0000:00
[    0.479864] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.479870] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.479875] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c1fff]
[    0.479880] pci_bus 0000:00: root bus resource [mem 0x000c2000-0x000c3fff]
[    0.479884] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c5fff]
[    0.479889] pci_bus 0000:00: root bus resource [mem 0x000c6000-0x000c7fff]
[    0.479894] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000c9fff]
[    0.479898] pci_bus 0000:00: root bus resource [mem 0x000ca000-0x000cbfff]
[    0.479903] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cdfff]
[    0.479907] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d1fff]
[    0.479912] pci_bus 0000:00: root bus resource [mem 0x000d2000-0x000d3fff]
[    0.479916] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d5fff]
[    0.479921] pci_bus 0000:00: root bus resource [mem 0x000d6000-0x000d7fff]
[    0.479925] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000d9fff]
[    0.479929] pci_bus 0000:00: root bus resource [mem 0x000da000-0x000dbfff]
[    0.479934] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000ddfff]
[    0.479938] pci_bus 0000:00: root bus resource [mem 0x000de000-0x000dffff]
[    0.479943] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e1fff]
[    0.479947] pci_bus 0000:00: root bus resource [mem 0x000e2000-0x000e3fff]
[    0.479951] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e5fff]
[    0.479956] pci_bus 0000:00: root bus resource [mem 0x000e6000-0x000e7fff]
[    0.479960] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000e9fff]
[    0.479965] pci_bus 0000:00: root bus resource [mem 0x000ea000-0x000ebfff]
[    0.479969] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000edfff]
[    0.479973] pci_bus 0000:00: root bus resource [mem 0x000ee000-0x000effff]
[    0.479978] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xf7ffffff]
[    0.479983] pci_bus 0000:00: root bus resource [mem 0xfc000000-0xfdffffff]
[    0.479987] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.479992] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.479996] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.480013] pci 0000:00:00.0: [1022:1510] type 00 class 0x060000
[    0.480206] pci 0000:00:01.0: [1002:9808] type 00 class 0x030000
[    0.480223] pci 0000:00:01.0: reg 10: [mem 0xe0000000-0xefffffff pref]
[    0.480234] pci 0000:00:01.0: reg 14: [io  0x3000-0x30ff]
[    0.480244] pci 0000:00:01.0: reg 18: [mem 0xf0300000-0xf033ffff]
[    0.480307] pci 0000:00:01.0: supports D1 D2
[    0.480469] pci 0000:00:01.1: [1002:1314] type 00 class 0x040300
[    0.480484] pci 0000:00:01.1: reg 10: [mem 0xf0344000-0xf0347fff]
[    0.480556] pci 0000:00:01.1: supports D1 D2
[    0.480721] pci 0000:00:05.0: [1022:1513] type 01 class 0x060400
[    0.480806] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.480855] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.480931] pci 0000:00:06.0: [1022:1514] type 01 class 0x060400
[    0.481007] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.481057] pci 0000:00:06.0: System wakeup disabled by ACPI
[    0.481131] pci 0000:00:07.0: [1022:1515] type 01 class 0x060400
[    0.481207] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.481257] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.481369] pci 0000:00:10.0: [1022:7812] type 00 class 0x0c0330
[    0.481396] pci 0000:00:10.0: reg 10: [mem 0xf0348000-0xf0349fff 64bit]
[    0.481519] pci 0000:00:10.0: PME# supported from D0 D3hot D3cold
[    0.481607] pci 0000:00:10.0: System wakeup disabled by ACPI
[    0.481696] pci 0000:00:11.0: [1022:7801] type 00 class 0x010601
[    0.481722] pci 0000:00:11.0: reg 10: [io  0x3118-0x311f]
[    0.481736] pci 0000:00:11.0: reg 14: [io  0x3124-0x3127]
[    0.481749] pci 0000:00:11.0: reg 18: [io  0x3110-0x3117]
[    0.481762] pci 0000:00:11.0: reg 1c: [io  0x3120-0x3123]
[    0.481775] pci 0000:00:11.0: reg 20: [io  0x3100-0x310f]
[    0.481788] pci 0000:00:11.0: reg 24: [mem 0xf034d000-0xf034d7ff]
[    0.481986] pci 0000:00:12.0: [1022:7807] type 00 class 0x0c0310
[    0.482006] pci 0000:00:12.0: reg 10: [mem 0xf034c000-0xf034cfff]
[    0.482137] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.482235] pci 0000:00:12.2: [1022:7808] type 00 class 0x0c0320
[    0.482261] pci 0000:00:12.2: reg 10: [mem 0xf034d900-0xf034d9ff]
[    0.482359] pci 0000:00:12.2: supports D1 D2
[    0.482363] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.482512] pci 0000:00:13.0: [1022:7807] type 00 class 0x0c0310
[    0.482531] pci 0000:00:13.0: reg 10: [mem 0xf034b000-0xf034bfff]
[    0.482670] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.482748] pci 0000:00:13.2: [1022:7808] type 00 class 0x0c0320
[    0.482773] pci 0000:00:13.2: reg 10: [mem 0xf034d800-0xf034d8ff]
[    0.482872] pci 0000:00:13.2: supports D1 D2
[    0.482876] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.482961] pci 0000:00:13.2: System wakeup disabled by ACPI
[    0.483058] pci 0000:00:14.0: [1022:780b] type 00 class 0x0c0500
[    0.483279] pci 0000:00:14.2: [1022:780d] type 00 class 0x040300
[    0.483307] pci 0000:00:14.2: reg 10: [mem 0xf0340000-0xf0343fff 64bit]
[    0.483387] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.483462] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.483544] pci 0000:00:14.3: [1022:780e] type 00 class 0x060100
[    0.483752] pci 0000:00:14.4: [1022:780f] type 01 class 0x060401
[    0.483877] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.483960] pci 0000:00:14.5: [1022:7809] type 00 class 0x0c0310
[    0.483979] pci 0000:00:14.5: reg 10: [mem 0xf034a000-0xf034afff]
[    0.484131] pci 0000:00:14.5: System wakeup disabled by ACPI
[    0.484223] pci 0000:00:18.0: [1022:1700] type 00 class 0x060000
[    0.484402] pci 0000:00:18.1: [1022:1701] type 00 class 0x060000
[    0.484575] pci 0000:00:18.2: [1022:1702] type 00 class 0x060000
[    0.484763] pci 0000:00:18.3: [1022:1703] type 00 class 0x060000
[    0.484952] pci 0000:00:18.4: [1022:1704] type 00 class 0x060000
[    0.485126] pci 0000:00:18.5: [1022:1718] type 00 class 0x060000
[    0.485299] pci 0000:00:18.6: [1022:1716] type 00 class 0x060000
[    0.485473] pci 0000:00:18.7: [1022:1719] type 00 class 0x060000
[    0.485845] pci 0000:02:00.0: [14e4:4727] type 00 class 0x028000
[    0.485873] pci 0000:02:00.0: reg 10: [mem 0xf0200000-0xf0203fff 64bit]
[    0.485995] pci 0000:02:00.0: supports D1 D2
[    0.486000] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.493011] pci 0000:00:05.0: PCI bridge to [bus 02]
[    0.493033] pci 0000:00:05.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.493222] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.493245] pci 0000:03:00.0: reg 10: [io  0x2000-0x20ff]
[    0.493276] pci 0000:03:00.0: reg 18: [mem 0xf0004000-0xf0004fff 64bit 
pref]
[    0.493297] pci 0000:03:00.0: reg 20: [mem 0xf0000000-0xf0003fff 64bit 
pref]
[    0.493379] pci 0000:03:00.0: supports D1 D2
[    0.493383] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.500962] pci 0000:00:06.0: PCI bridge to [bus 03]
[    0.500986] pci 0000:00:06.0:   bridge window [io  0x2000-0x2fff]
[    0.501005] pci 0000:00:06.0:   bridge window [mem 0xf0000000-0xf00fffff 
64bit pref]
[    0.501237] pci 0000:04:00.0: [10ec:5209] type 00 class 0xff0000
[    0.501262] pci 0000:04:00.0: reg 10: [mem 0xf0100000-0xf0100fff]
[    0.501330] pci 0000:04:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    0.501396] pci 0000:04:00.0: supports D1 D2
[    0.501401] pci 0000:04:00.0: PME# supported from D1 D2 D3hot
[    0.508959] pci 0000:00:07.0: PCI bridge to [bus 04]
[    0.508987] pci 0000:00:07.0:   bridge window [mem 0xf0100000-0xf01fffff]
[    0.509174] pci 0000:00:14.4: PCI bridge to [bus 05] (subtractive decode)
[    0.509189] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] 
(subtractive decode)
[    0.509194] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000c1fff] 
(subtractive decode)
[    0.509199] pci 0000:00:14.4:   bridge window [mem 0x000c2000-0x000c3fff] 
(subtractive decode)
[    0.509204] pci 0000:00:14.4:   bridge window [mem 0x000c4000-0x000c5fff] 
(subtractive decode)
[    0.509208] pci 0000:00:14.4:   bridge window [mem 0x000c6000-0x000c7fff] 
(subtractive decode)
[    0.509213] pci 0000:00:14.4:   bridge window [mem 0x000c8000-0x000c9fff] 
(subtractive decode)
[    0.509217] pci 0000:00:14.4:   bridge window [mem 0x000ca000-0x000cbfff] 
(subtractive decode)
[    0.509222] pci 0000:00:14.4:   bridge window [mem 0x000cc000-0x000cdfff] 
(subtractive decode)
[    0.509226] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d1fff] 
(subtractive decode)
[    0.509230] pci 0000:00:14.4:   bridge window [mem 0x000d2000-0x000d3fff] 
(subtractive decode)
[    0.509235] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d5fff] 
(subtractive decode)
[    0.509241] pci 0000:00:14.4:   bridge window [mem 0x000d6000-0x000d7fff] 
(subtractive decode)
[    0.509246] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000d9fff] 
(subtractive decode)
[    0.509250] pci 0000:00:14.4:   bridge window [mem 0x000da000-0x000dbfff] 
(subtractive decode)
[    0.509255] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000ddfff] 
(subtractive decode)
[    0.509260] pci 0000:00:14.4:   bridge window [mem 0x000de000-0x000dffff] 
(subtractive decode)
[    0.509264] pci 0000:00:14.4:   bridge window [mem 0x000e0000-0x000e1fff] 
(subtractive decode)
[    0.509269] pci 0000:00:14.4:   bridge window [mem 0x000e2000-0x000e3fff] 
(subtractive decode)
[    0.509273] pci 0000:00:14.4:   bridge window [mem 0x000e4000-0x000e5fff] 
(subtractive decode)
[    0.509278] pci 0000:00:14.4:   bridge window [mem 0x000e6000-0x000e7fff] 
(subtractive decode)
[    0.509282] pci 0000:00:14.4:   bridge window [mem 0x000e8000-0x000e9fff] 
(subtractive decode)
[    0.509286] pci 0000:00:14.4:   bridge window [mem 0x000ea000-0x000ebfff] 
(subtractive decode)
[    0.509291] pci 0000:00:14.4:   bridge window [mem 0x000ec000-0x000edfff] 
(subtractive decode)
[    0.509295] pci 0000:00:14.4:   bridge window [mem 0x000ee000-0x000effff] 
(subtractive decode)
[    0.509300] pci 0000:00:14.4:   bridge window [mem 0xe0000000-0xf7ffffff] 
(subtractive decode)
[    0.509305] pci 0000:00:14.4:   bridge window [mem 0xfc000000-0xfdffffff] 
(subtractive decode)
[    0.509309] pci 0000:00:14.4:   bridge window [mem 0xfed40000-0xfed44fff] 
(subtractive decode)
[    0.509314] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] 
(subtractive decode)
[    0.509319] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] 
(subtractive decode)
[    0.509671] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.510367] acpi PNP0A08:00: ACPI _OSC control (0x19) granted
[    0.511384] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0
[    0.511557] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0
[    0.511717] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0
[    0.511877] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0
[    0.512022] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0
[    0.512144] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0
[    0.512266] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0
[    0.512387] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0
[    0.514983] ACPI: Enabled 2 GPEs in block 00 to 1F
[    0.515004] acpi root: \_SB_.PCI0 notify handler is installed
[    0.515126] Found 1 acpi root devices
[    0.515280] ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.515581] ACPI: No dock devices found.
[    0.515987] vgaarb: device added: 
PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.516006] vgaarb: loaded
[    0.516009] vgaarb: bridge control possible 0000:00:01.0
[    0.516146] PCI: Using ACPI for IRQ routing
[    0.518439] PCI: pci_cache_line_size set to 64 bytes
[    0.518629] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
[    0.518634] e820: reserve RAM buffer [mem 0xd3820000-0xd3ffffff]
[    0.518637] e820: reserve RAM buffer [mem 0x207000000-0x207ffffff]
[    0.518902] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.518910] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.520942] Switching to clocksource hpet
[    0.524567] pnp: PnP ACPI init
[    0.524601] ACPI: bus type PNP registered
[    0.524964] system 00:00: [io  0x0f50-0x0f51] has been reserved
[    0.524975] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.524981] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.524986] system 00:00: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.524996] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.525807] pnp 00:01: [dma 4]
[    0.525869] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.525967] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.526060] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.526129] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.526221] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.526329] pnp 00:06: Plug and Play ACPI device, IDs LEN0026 PNP0f13 
(active)
[    0.526469] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.526476] system 00:07: [io  0x0530-0x0537] has been reserved
[    0.526482] system 00:07: [io  0x0800-0x0827] has been reserved
[    0.526489] system 00:07: [io  0x0830] has been reserved
[    0.526494] system 00:07: [io  0x0840-0x0847] has been reserved
[    0.526499] system 00:07: [io  0x0b00-0x0b1f] has been reserved
[    0.526505] system 00:07: [io  0x0b20-0x0b3f] has been reserved
[    0.526510] system 00:07: [io  0x0c00-0x0c01] has been reserved
[    0.526515] system 00:07: [io  0x0c14] has been reserved
[    0.526521] system 00:07: [io  0x0c50-0x0c52] has been reserved
[    0.526526] system 00:07: [io  0x0cd0-0x0cd1] has been reserved
[    0.526531] system 00:07: [io  0x0cd2-0x0cd3] has been reserved
[    0.526536] system 00:07: [io  0x0cd4-0x0cd5] has been reserved
[    0.526542] system 00:07: [io  0x0cd6-0x0cd7] has been reserved
[    0.526547] system 00:07: [io  0x0cd8-0x0cdf] has been reserved
[    0.526553] system 00:07: [io  0x0cf9] could not be reserved
[    0.526558] system 00:07: [io  0x8100-0x81ff window] has been reserved
[    0.526564] system 00:07: [io  0x8200-0x82ff window] has been reserved
[    0.526572] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.526754] pnp 00:08: [Firmware Bug]: [mem 0x00000000-0xffffffffffffffff 
disabled] covers only part of AMD MMCONFIG area [mem 0xf8000000-0xfbffffff]; 
adding more reservations
[    0.526814] system 00:08: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.526820] system 00:08: [mem 0xffe00000-0xffffffff] has been reserved
[    0.526826] system 00:08: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.526831] system 00:08: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.526837] system 00:08: [mem 0xfed61000-0xfed613ff] has been reserved
[    0.526842] system 00:08: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.526849] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.527995] pnp: PnP ACPI: found 9 devices
[    0.528004] ACPI: bus type PNP unregistered
[    0.538522] pci 0000:04:00.0: no compatible bridge window for [mem 
0xffff0000-0xffffffff pref]
[    0.538583] pci 0000:00:07.0: bridge window [io  0x1000-0x0fff] to [bus 04] 
add_size 1000
[    0.538591] pci 0000:00:07.0: bridge window [mem 0x00100000-0x001fffff 
pref] to [bus 04] add_size 200000
[    0.538614] pci 0000:00:07.0: res[15]=[mem 0x00100000-0x001fffff pref] 
get_res_add_size add_size 200000
[    0.538619] pci 0000:00:07.0: res[13]=[io  0x1000-0x0fff] get_res_add_size 
add_size 1000
[    0.538642] pci 0000:00:07.0: BAR 15: assigned [mem 0xf0400000-0xf06fffff 
pref]
[    0.538653] pci 0000:00:07.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.538660] pci 0000:00:05.0: PCI bridge to [bus 02]
[    0.538669] pci 0000:00:05.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.538679] pci 0000:00:06.0: PCI bridge to [bus 03]
[    0.538685] pci 0000:00:06.0:   bridge window [io  0x2000-0x2fff]
[    0.538694] pci 0000:00:06.0:   bridge window [mem 0xf0000000-0xf00fffff 
64bit pref]
[    0.538704] pci 0000:04:00.0: BAR 6: assigned [mem 0xf0400000-0xf040ffff 
pref]
[    0.538709] pci 0000:00:07.0: PCI bridge to [bus 04]
[    0.538714] pci 0000:00:07.0:   bridge window [io  0x1000-0x1fff]
[    0.538721] pci 0000:00:07.0:   bridge window [mem 0xf0100000-0xf01fffff]
[    0.538727] pci 0000:00:07.0:   bridge window [mem 0xf0400000-0xf06fffff 
pref]
[    0.538736] pci 0000:00:14.4: PCI bridge to [bus 05]
[    0.539996] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    0.540001] pci_bus 0000:00: resource 5 [mem 0x000c0000-0x000c1fff]
[    0.540006] pci_bus 0000:00: resource 6 [mem 0x000c2000-0x000c3fff]
[    0.540010] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c5fff]
[    0.540014] pci_bus 0000:00: resource 8 [mem 0x000c6000-0x000c7fff]
[    0.540018] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000c9fff]
[    0.540023] pci_bus 0000:00: resource 10 [mem 0x000ca000-0x000cbfff]
[    0.540027] pci_bus 0000:00: resource 11 [mem 0x000cc000-0x000cdfff]
[    0.540031] pci_bus 0000:00: resource 12 [mem 0x000d0000-0x000d1fff]
[    0.540035] pci_bus 0000:00: resource 13 [mem 0x000d2000-0x000d3fff]
[    0.540039] pci_bus 0000:00: resource 14 [mem 0x000d4000-0x000d5fff]
[    0.540043] pci_bus 0000:00: resource 15 [mem 0x000d6000-0x000d7fff]
[    0.540048] pci_bus 0000:00: resource 16 [mem 0x000d8000-0x000d9fff]
[    0.540052] pci_bus 0000:00: resource 17 [mem 0x000da000-0x000dbfff]
[    0.540056] pci_bus 0000:00: resource 18 [mem 0x000dc000-0x000ddfff]
[    0.540060] pci_bus 0000:00: resource 19 [mem 0x000de000-0x000dffff]
[    0.540064] pci_bus 0000:00: resource 20 [mem 0x000e0000-0x000e1fff]
[    0.540068] pci_bus 0000:00: resource 21 [mem 0x000e2000-0x000e3fff]
[    0.540072] pci_bus 0000:00: resource 22 [mem 0x000e4000-0x000e5fff]
[    0.540077] pci_bus 0000:00: resource 23 [mem 0x000e6000-0x000e7fff]
[    0.540081] pci_bus 0000:00: resource 24 [mem 0x000e8000-0x000e9fff]
[    0.540085] pci_bus 0000:00: resource 25 [mem 0x000ea000-0x000ebfff]
[    0.540089] pci_bus 0000:00: resource 26 [mem 0x000ec000-0x000edfff]
[    0.540093] pci_bus 0000:00: resource 27 [mem 0x000ee000-0x000effff]
[    0.540097] pci_bus 0000:00: resource 28 [mem 0xe0000000-0xf7ffffff]
[    0.540102] pci_bus 0000:00: resource 29 [mem 0xfc000000-0xfdffffff]
[    0.540106] pci_bus 0000:00: resource 30 [mem 0xfed40000-0xfed44fff]
[    0.540110] pci_bus 0000:00: resource 31 [io  0x0000-0x0cf7]
[    0.540114] pci_bus 0000:00: resource 32 [io  0x0d00-0xffff]
[    0.540119] pci_bus 0000:02: resource 1 [mem 0xf0200000-0xf02fffff]
[    0.540123] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.540128] pci_bus 0000:03: resource 2 [mem 0xf0000000-0xf00fffff 64bit 
pref]
[    0.540133] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.540136] pci_bus 0000:04: resource 1 [mem 0xf0100000-0xf01fffff]
[    0.540141] pci_bus 0000:04: resource 2 [mem 0xf0400000-0xf06fffff pref]
[    0.540146] pci_bus 0000:05: resource 4 [mem 0x000a0000-0x000bffff]
[    0.540150] pci_bus 0000:05: resource 5 [mem 0x000c0000-0x000c1fff]
[    0.540154] pci_bus 0000:05: resource 6 [mem 0x000c2000-0x000c3fff]
[    0.540158] pci_bus 0000:05: resource 7 [mem 0x000c4000-0x000c5fff]
[    0.540162] pci_bus 0000:05: resource 8 [mem 0x000c6000-0x000c7fff]
[    0.540166] pci_bus 0000:05: resource 9 [mem 0x000c8000-0x000c9fff]
[    0.540170] pci_bus 0000:05: resource 10 [mem 0x000ca000-0x000cbfff]
[    0.540174] pci_bus 0000:05: resource 11 [mem 0x000cc000-0x000cdfff]
[    0.540178] pci_bus 0000:05: resource 12 [mem 0x000d0000-0x000d1fff]
[    0.540182] pci_bus 0000:05: resource 13 [mem 0x000d2000-0x000d3fff]
[    0.540187] pci_bus 0000:05: resource 14 [mem 0x000d4000-0x000d5fff]
[    0.540191] pci_bus 0000:05: resource 15 [mem 0x000d6000-0x000d7fff]
[    0.540195] pci_bus 0000:05: resource 16 [mem 0x000d8000-0x000d9fff]
[    0.540199] pci_bus 0000:05: resource 17 [mem 0x000da000-0x000dbfff]
[    0.540203] pci_bus 0000:05: resource 18 [mem 0x000dc000-0x000ddfff]
[    0.540207] pci_bus 0000:05: resource 19 [mem 0x000de000-0x000dffff]
[    0.540212] pci_bus 0000:05: resource 20 [mem 0x000e0000-0x000e1fff]
[    0.540216] pci_bus 0000:05: resource 21 [mem 0x000e2000-0x000e3fff]
[    0.540220] pci_bus 0000:05: resource 22 [mem 0x000e4000-0x000e5fff]
[    0.540224] pci_bus 0000:05: resource 23 [mem 0x000e6000-0x000e7fff]
[    0.540228] pci_bus 0000:05: resource 24 [mem 0x000e8000-0x000e9fff]
[    0.540232] pci_bus 0000:05: resource 25 [mem 0x000ea000-0x000ebfff]
[    0.540236] pci_bus 0000:05: resource 26 [mem 0x000ec000-0x000edfff]
[    0.540241] pci_bus 0000:05: resource 27 [mem 0x000ee000-0x000effff]
[    0.540245] pci_bus 0000:05: resource 28 [mem 0xe0000000-0xf7ffffff]
[    0.540249] pci_bus 0000:05: resource 29 [mem 0xfc000000-0xfdffffff]
[    0.540253] pci_bus 0000:05: resource 30 [mem 0xfed40000-0xfed44fff]
[    0.540257] pci_bus 0000:05: resource 31 [io  0x0000-0x0cf7]
[    0.540262] pci_bus 0000:05: resource 32 [io  0x0d00-0xffff]
[    0.540406] NET: Registered protocol family 2
[    0.540967] TCP established hash table entries: 65536 (order: 8, 1048576 
bytes)
[    0.541667] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.542196] TCP: Hash tables configured (established 65536 bind 65536)
[    0.542295] TCP: reno registered
[    0.542328] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.542423] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.542752] NET: Registered protocol family 1
[    0.542789] pci 0000:00:01.0: Boot video device
[    0.757617] PCI: CLS 32 bytes, default 64
[    0.757724] Unpacking initramfs...
[    1.248197] Freeing initrd memory: 13784k freed
[    1.255853] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.255864] software IO TLB [mem 0xcf820000-0xd3820000] (64MB) mapped at 
[ffff8800cf820000-ffff8800d381ffff]
[    1.256179] LVT offset 0 assigned for vector 0x400
[    1.256267] perf: AMD IBS detected (0x000000ff)
[    1.256856] audit: initializing netlink socket (disabled)
[    1.256884] type=2000 audit(1371838104.948:1): initialized
[    1.286973] bounce pool size: 64 pages
[    1.286986] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.288528] VFS: Disk quotas dquot_6.5.2
[    1.288598] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.288794] msgmni has been set to 14824
[    1.289379] alg: No test for stdrng (krng)
[    1.289458] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
252)
[    1.289535] io scheduler noop registered
[    1.289539] io scheduler deadline registered
[    1.289560] io scheduler cfq registered (default)
[    1.289841] pcieport 0000:00:07.0: irq 40 for MSI/MSI-X
[    1.289993] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.290105] pciehp 0000:00:07.0:pcie04: HPC vendor_id 1022 device_id 1515 
ss_vid 1022 ss_did 1234
[    1.290188] pciehp 0000:00:07.0:pcie04: service driver pciehp loaded
[    1.290202] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.290388] GHES: HEST is not enabled!
[    1.290625] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.291604] Linux agpgart interface v0.103
[    1.291886] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 
0x60,0x64 irq 1,12
[    1.295744] i8042: Detected active multiplexing controller, rev 1.1
[    1.296559] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.296574] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.296629] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.296677] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.296719] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.297240] mousedev: PS/2 mouse device common for all mice
[    1.297373] rtc_cmos 00:03: RTC can wake from S4
[    1.297564] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.297623] rtc_cmos 00:03: alarms up to one month, 114 bytes nvram, hpet 
irqs
[    1.297643] cpuidle: using governor ladder
[    1.297647] cpuidle: using governor menu
[    1.297720] drop_monitor: Initializing network drop monitor service
[    1.297848] TCP: cubic registered
[    1.297927] NET: Registered protocol family 10
[    1.298299] mip6: Mobile IPv6
[    1.298304] NET: Registered protocol family 17
[    1.298916] PM: Hibernation image not present or could not be loaded.
[    1.298940] registered taskstats version 1
[    1.300321] rtc_cmos 00:03: setting system clock to 2013-06-21 18:08:26 UTC 
(1371838106)
[    1.302389] Freeing unused kernel memory: 920k freed
[    1.302871] Write protecting the kernel read-only data: 6144k
[    1.305526] Freeing unused kernel memory: 376k freed
[    1.308250] Freeing unused kernel memory: 480k freed
[    1.338483] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input0
[    1.467837] udevd[60]: starting version 175
[    1.573573] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.573937] r8169 0000:03:00.0: irq 41 for MSI/MSI-X
[    1.574267] r8169 0000:03:00.0 eth0: RTL8168evl/8111evl at 
0xffffc90000c16000, XX:XX:XX:XX:XX:XX, XID 0c900800 IRQ 41
[    1.574273] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes, tx 
checksumming: ko]
[    1.574394] SCSI subsystem initialized
[    1.588330] ACPI: bus type ATA registered
[    1.594868] ACPI: bus type USB registered
[    1.594932] usbcore: registered new interface driver usbfs
[    1.594958] usbcore: registered new interface driver hub
[    1.598883] rtsx_pci 0000:04:00.0: irq 42 for MSI/MSI-X
[    1.598910] rtsx_pci 0000:04:00.0: rtsx_pci_acquire_irq: pcr->msi_en = 1, 
pci->irq = 42
[    1.599066] libata version 3.00 loaded.
[    1.599239] usbcore: registered new device driver usb
[    1.600028] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.600459] ehci-pci: EHCI PCI platform driver
[    1.600727] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.600956] ehci-pci 0000:00:12.2: EHCI Host Controller
[    1.600971] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus 
number 1
[    1.600990] QUIRK: Enable AMD PLL fix
[    1.600994] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI 
dummy qh workaround
[    1.601023] ehci-pci 0000:00:12.2: debug port 1
[    1.601091] ehci-pci 0000:00:12.2: irq 17, io mem 0xf034d900
[    1.607991] thermal LNXTHERM:00: registered as thermal_zone0
[    1.608000] ACPI: Thermal Zone [THZ0] (70 C)
[    1.612277] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.612346] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.612351] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.612356] usb usb1: Product: EHCI Host Controller
[    1.612361] usb usb1: Manufacturer: Linux 3.10-rc5-amd64 ehci_hcd
[    1.612365] usb usb1: SerialNumber: 0000:00:12.2
[    1.612631] hub 1-0:1.0: USB hub found
[    1.612648] hub 1-0:1.0: 5 ports detected
[    1.613386] ehci-pci 0000:00:13.2: EHCI Host Controller
[    1.613399] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus 
number 2
[    1.613412] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI 
dummy qh workaround
[    1.613441] ehci-pci 0000:00:13.2: debug port 1
[    1.613491] ehci-pci 0000:00:13.2: irq 17, io mem 0xf034d800
[    1.624862] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.624922] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.624927] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.624932] usb usb2: Product: EHCI Host Controller
[    1.624936] usb usb2: Manufacturer: Linux 3.10-rc5-amd64 ehci_hcd
[    1.624940] usb usb2: SerialNumber: 0000:00:13.2
[    1.625230] hub 2-0:1.0: USB hub found
[    1.625242] hub 2-0:1.0: 5 ports detected
[    1.626298] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.626318] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus 
number 3
[    1.626385] ohci_hcd 0000:00:12.0: irq 18, io mem 0xf034c000
[    1.678037] microcode: CPU0: patch_level=0x0500010d
[    1.678109] platform microcode: firmware: agent loaded amd-
ucode/microcode_amd.bin into memory
[    1.678162] microcode: CPU1: patch_level=0x0500010d
[    1.678261] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.684660] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.684669] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.684674] usb usb3: Product: OHCI Host Controller
[    1.684678] usb usb3: Manufacturer: Linux 3.10-rc5-amd64 ohci_hcd
[    1.684682] usb usb3: SerialNumber: 0000:00:12.0
[    1.685108] hub 3-0:1.0: USB hub found
[    1.685136] hub 3-0:1.0: 5 ports detected
[    1.685619] ahci 0000:00:11.0: version 3.0
[    1.686122] ahci 0000:00:11.0: irq 43 for MSI/MSI-X
[    1.686196] ahci 0000:00:11.0: AHCI 0001.0300 32 slots 1 ports 6 Gbps 0x1 
impl SATA mode
[    1.686203] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp 
pio slum part 
[    1.686644] scsi0 : ahci
[    1.686774] ata1: SATA max UDMA/133 abar m2048@0xf034d000 port 0xf034d100 
irq 43
[    1.687303] xhci_hcd 0000:00:10.0: xHCI Host Controller
[    1.687317] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus 
number 4
[    1.687568] xhci_hcd 0000:00:10.0: irq 44 for MSI/MSI-X
[    1.687580] xhci_hcd 0000:00:10.0: irq 45 for MSI/MSI-X
[    1.687591] xhci_hcd 0000:00:10.0: irq 46 for MSI/MSI-X
[    1.687732] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    1.687738] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.687742] usb usb4: Product: xHCI Host Controller
[    1.687746] usb usb4: Manufacturer: Linux 3.10-rc5-amd64 xhci_hcd
[    1.687750] usb usb4: SerialNumber: 0000:00:10.0
[    1.687930] xHCI xhci_add_endpoint called for root hub
[    1.687934] xHCI xhci_check_bandwidth called for root hub
[    1.687998] hub 4-0:1.0: USB hub found
[    1.688012] hub 4-0:1.0: 2 ports detected
[    1.688200] xhci_hcd 0000:00:10.0: xHCI Host Controller
[    1.688209] xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus 
number 5
[    1.690941] usb usb5: New USB device found, idVendor=1d6b, idProduct=0003
[    1.690946] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.690950] usb usb5: Product: xHCI Host Controller
[    1.690953] usb usb5: Manufacturer: Linux 3.10-rc5-amd64 xhci_hcd
[    1.690957] usb usb5: SerialNumber: 0000:00:10.0
[    1.691099] xHCI xhci_add_endpoint called for root hub
[    1.691103] xHCI xhci_check_bandwidth called for root hub
[    1.691157] hub 5-0:1.0: USB hub found
[    1.691179] hub 5-0:1.0: 2 ports detected
[    1.702517] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.702536] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus 
number 6
[    1.702590] ohci_hcd 0000:00:13.0: irq 18, io mem 0xf034b000
[    1.760351] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.760360] usb usb6: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.760365] usb usb6: Product: OHCI Host Controller
[    1.760370] usb usb6: Manufacturer: Linux 3.10-rc5-amd64 ohci_hcd
[    1.760374] usb usb6: SerialNumber: 0000:00:13.0
[    1.760871] hub 6-0:1.0: USB hub found
[    1.760903] hub 6-0:1.0: 5 ports detected
[    1.761653] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.761666] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus 
number 7
[    1.761700] ohci_hcd 0000:00:14.5: irq 18, io mem 0xf034a000
[    1.820315] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.820324] usb usb7: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.820329] usb usb7: Product: OHCI Host Controller
[    1.820333] usb usb7: Manufacturer: Linux 3.10-rc5-amd64 ohci_hcd
[    1.820337] usb usb7: SerialNumber: 0000:00:14.5
[    1.820770] hub 7-0:1.0: USB hub found
[    1.820787] hub 7-0:1.0: 2 ports detected
[    2.180092] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.183146] ata1.00: ATA-8: ST320LT007-9ZV142, 0004LVM1, max UDMA/133
[    2.183161] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.186615] ata1.00: configured for UDMA/133
[    2.187126] scsi 0:0:0:0: Direct-Access     ATA      ST320LT007-9ZV14 0004 
PQ: 0 ANSI: 5
[    2.194471] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 
GB/298 GiB)
[    2.194480] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.195035] sd 0:0:0:0: [sda] Write Protect is off
[    2.195046] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.195193] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    2.195858] usb 2-4: new high-speed USB device number 3 using ehci-pci
[    2.205904]  sda: sda1 sda2
[    2.207135] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.211082] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.251992] tsc: Refined TSC clocksource calibration: 1696.913 MHz
[    2.252015] Switching to clocksource tsc
[    2.339530] usb 2-4: New USB device found, idVendor=5986, idProduct=0299
[    2.339546] usb 2-4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    2.339555] usb 2-4: Product: Integrated Camera
[    2.339563] usb 2-4: Manufacturer: Vimicro corp.
[    2.501531] device-mapper: uevent: version 1.0.3
[    2.501682] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: 
dm-devel@redhat.com
[    2.603708] usb 6-3: new full-speed USB device number 2 using ohci_hcd
[    2.778480] usb 6-3: New USB device found, idVendor=0a5c, idProduct=21f4
[    2.778496] usb 6-3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    2.778505] usb 6-3: Product: BCM20702A0
[    2.778513] usb 6-3: Manufacturer: Broadcom Corp
[    2.778521] usb 6-3: SerialNumber: C0143DC1809E
[    7.595791] bio: create slab <bio-1> at 1
[    7.866355] bio: create slab <bio-1> at 1
[    8.573937] EXT4-fs (dm-1): mounted filesystem with ordered data mode. 
Opts: (null)
[   11.247624] udevd[457]: starting version 175
[   12.889596] bcma: bus0: Found chip with id 0x4313, rev 0x01 and package 
0x08
[   12.889623] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, 
rev 0x24, class 0x0)
[   12.889643] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, 
rev 0x18, class 0x0)
[   12.889678] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 
0x11, class 0x0)
[   12.902441] bcma: bus0: Bus registered
[   13.048107] wmi: Mapper loaded
[   13.085930] ACPI: AC Adapter [ACAD] (on-line)
[   13.086780] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[   13.087034] ACPI: Power Button [PWRB]
[   13.087223] input: Lid Switch as 
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[   13.090828] ACPI: Lid Switch [LID]
[   13.090994] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   13.091104] ACPI: Power Button [PWRF]
[   13.103458] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   13.117765] ACPI: acpi_idle registered with cpuidle
[   13.122241] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial 
brightness
[   13.122331] ACPI: Video Device [VGA1] (multi-head: yes  rom: no  post: no)
[   13.122470] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input5
[   13.184631] kvm: Nested Virtualization enabled
[   13.184642] kvm: Nested Paging enabled
[   13.240908] ACPI: Battery Slot [BAT1] (battery present)
[   13.348769] ACPI Warning: 0x0000000000000b00-0x0000000000000b07 SystemIO 
conflicts with Region \_SB_.PCI0.SMB_.SMB0 1 (20130328/utaddress-251)
[   13.348784] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[   13.395080] Non-volatile memory driver v1.3
[   13.404793] media: Linux media interface: v0.10
[   13.417163] Bluetooth: Core ver 2.16
[   13.417229] NET: Registered protocol family 31
[   13.417233] Bluetooth: HCI device and connection manager initialized
[   13.417250] Bluetooth: HCI socket layer initialized
[   13.417255] Bluetooth: L2CAP socket layer initialized
[   13.417274] Bluetooth: SCO socket layer initialized
[   13.419553] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   13.419560] thinkpad_acpi: http://ibm-acpi.sf.net/
[   13.419564] thinkpad_acpi: ThinkPad BIOS HMET19WW (1.05 ), EC unknown
[   13.419567] thinkpad_acpi: Lenovo ThinkPad Edge E135, model 335963G
[   13.420277] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   13.424076] thinkpad_acpi: radio switch found; radios are enabled
[   13.424110] thinkpad_acpi: possible tablet mode switch found; ThinkPad in 
laptop mode
[   13.449845] Linux video capture interface: v2.00
[   13.500109] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is 
unblocked
[   13.500432] usbcore: registered new interface driver btusb
[   13.503572] [drm] Initialized drm 1.1.0 20060810
[   13.512455] thinkpad_acpi: Console audio control enabled, mode: monitor 
(read only)
[   13.515257] input: ThinkPad Extra Buttons as 
/devices/platform/thinkpad_acpi/input/input6
[   13.523301] acpi-cpufreq: overriding BIOS provided _PSD data
[   13.640662] cfg80211: Calling CRDA to update world regulatory domain
[   13.707413] [drm] radeon kernel modesetting enabled.
[   13.752161] [drm] initializing kernel modesetting (PALM 0x1002:0x9808 
0x17AA:0x5105).
[   13.752257] [drm] register mmio base: 0xF0300000
[   13.752263] [drm] register mmio size: 262144
[   13.752581] ATOM BIOS: Lenovo
[   13.752684] radeon 0000:00:01.0: VRAM: 384M 0x0000000000000000 - 
0x0000000017FFFFFF (384M used)
[   13.752695] radeon 0000:00:01.0: GTT: 512M 0x0000000018000000 - 
0x0000000037FFFFFF
[   13.753074] [drm] Detected VRAM RAM=384M, BAR=256M
[   13.753087] [drm] RAM width 32bits DDR
[   13.753326] [TTM] Zone  kernel: Available graphics memory: 3795838 kiB
[   13.753334] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[   13.753339] [TTM] Initializing pool allocator
[   13.753356] [TTM] Initializing DMA pool allocator
[   13.753443] [drm] radeon: 384M of VRAM memory ready
[   13.753450] [drm] radeon: 512M of GTT memory ready.
[   13.820282] brcmsmac bcma0:0: mfg 4bf core 812 rev 24 class 0 irq 17
[   13.822340] psmouse serio4: synaptics: Touchpad model: 1, fw: 8.1, id: 
0x1e2b1, caps: 0xd002a3/0x940300/0x126c00, board id: 2290, fw id: 1212745
[   13.822371] psmouse serio4: synaptics: serio: Synaptics pass-through port 
at isa0060/serio4/input0
[   13.830102] uvcvideo: Found UVC 1.00 device Integrated Camera (5986:0299)
[   13.832506] input: Integrated Camera as 
/devices/pci0000:00/0000:00:13.2/usb2/2-4/2-4:1.0/input/input7
[   13.833071] usbcore: registered new interface driver uvcvideo
[   13.833077] USB Video Class driver (1.1.1)
[   13.868604] input: SynPS/2 Synaptics TouchPad as 
/devices/platform/i8042/serio4/input/input8
[   13.977004] platform radeon_uvd.0: firmware: agent aborted loading 
radeon/SUMO_uvd.bin (not found?)
[   13.977252] radeon 0000:00:01.0: radeon_uvd: Can't load firmware 
"radeon/SUMO_uvd.bin"
[   13.977394] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   13.980585] [drm] Loading PALM Microcode
[   14.018838] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   14.115519] platform radeon_cp.0: firmware: agent loaded 
radeon/PALM_pfp.bin into memory
[   14.127942] platform radeon_cp.0: firmware: agent loaded radeon/PALM_me.bin 
into memory
[   14.145810] platform radeon_cp.0: firmware: agent loaded 
radeon/SUMO_rlc.bin into memory
[   14.159352] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[   14.159705] radeon 0000:00:01.0: WB enabled
[   14.159720] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr 
0x0000000018000c00 and cpu addr 0xffff8801fdad5c00
[   14.159731] radeon 0000:00:01.0: fence driver on ring 3 use gpu addr 
0x0000000018000c0c and cpu addr 0xffff8801fdad5c0c
[   14.159743] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   14.159748] [drm] Driver supports precise vblank timestamp query.
[   14.159806] radeon 0000:00:01.0: irq 47 for MSI/MSI-X
[   14.159846] radeon 0000:00:01.0: radeon: using MSI.
[   14.159914] [drm] radeon: irq initialized.
[   14.177995] [drm] ring test on 0 succeeded in 1 usecs
[   14.178081] [drm] ring test on 3 succeeded in 1 usecs
[   14.179450] [drm] Enabling audio support
[   14.179510] [drm] ib test on ring 0 succeeded in 0 usecs
[   14.179549] [drm] ib test on ring 3 succeeded in 0 usecs
[   14.238965] [drm] radeon atom DIG backlight initialized
[   14.238984] [drm] Radeon Display Connectors
[   14.238990] [drm] Connector 0:
[   14.238998] [drm]   LVDS-1
[   14.239003] [drm]   HPD1
[   14.239011] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 
0x643c
[   14.239016] [drm]   Encoders:
[   14.239021] [drm]     LCD1: INTERNAL_UNIPHY
[   14.239026] [drm] Connector 1:
[   14.239031] [drm]   HDMI-A-1
[   14.239034] [drm]   HPD2
[   14.239210] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 
0x644c
[   14.239216] [drm]   Encoders:
[   14.239220] [drm]     DFP1: INTERNAL_UNIPHY
[   14.239224] [drm] Connector 2:
[   14.239229] [drm]   VGA-1
[   14.239236] [drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0 0x64e4 
0x64e4
[   14.239240] [drm]   Encoders:
[   14.239245] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   14.239367] [drm] Internal thermal controller without fan control
[   14.239562] [drm] radeon: power management initialized
[   14.674704] [drm] fb mappable at 0xE0142000
[   14.674715] [drm] vram apper at 0xE0000000
[   14.674721] [drm] size 4325376
[   14.674726] [drm] fb depth is 24
[   14.674731] [drm]    pitch is 5632
[   14.675148] fbcon: radeondrmfb (fb0) is primary device
[   14.707157] cfg80211: World regulatory domain updated:
[   14.707161] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   14.707169] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[   14.707173] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 
2000 mBm)
[   14.707177] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 
2000 mBm)
[   14.707180] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[   14.707184] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[   14.707542] cfg80211: Calling CRDA for country: DE
[   14.758242] cfg80211: Regulatory domain changed to country: DE
[   14.758245] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   14.758251] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 
mBm)
[   14.758255] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 
mBm)
[   14.758258] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 
mBm)
[   14.758261] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 
mBm)
[   15.239262] Console: switching to colour frame buffer device 170x48
[   15.252123] radeon 0000:00:01.0: fb0: radeondrmfb frame buffer device
[   15.252130] radeon 0000:00:01.0: registered panic notifier
[   15.253867] [drm] Initialized radeon 2.33.0 20080528 for 0000:00:01.0 on 
minor 0
[   15.254921] snd_hda_intel 0000:00:01.1: irq 48 for MSI/MSI-X
[   15.293269] input: HD-Audio Generic HDMI/DP,pcm=3 as 
/devices/pci0000:00/0000:00:01.1/sound/card0/input9
[   15.368276] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:14.2/input/input10
[   15.374324] input: HD-Audio Generic Headphone as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input11
[   15.374693] input: HD-Audio Generic Mic as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input12
[   17.229446] psmouse serio5: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 
00 64
[   17.561817] EXT4-fs (dm-1): re-mounted. Opts: (null)
[   18.109811] EXT4-fs (dm-1): re-mounted. Opts: errors=remount-ro
[   18.682340] psmouse serio5: trackpoint: IBM TrackPoint firmware: 0x0e, 
buttons: 3/3
[   18.914628] input: TPPS/2 IBM TrackPoint as 
/devices/platform/i8042/serio4/serio5/input/input13
[   19.101611] fuse init (API version 7.22)
[   19.187896] loop: module loaded
[   21.227033] EXT4-fs (sda1): mounted filesystem with ordered data mode. 
Opts: (null)
[   21.281095] EXT4-fs (dm-5): mounted filesystem with ordered data mode. 
Opts: (null)
[   21.326572] EXT4-fs (dm-4): mounted filesystem with ordered data mode. 
Opts: (null)
[   21.409835] EXT4-fs (dm-2): mounted filesystem with ordered data mode. 
Opts: (null)
[   21.505185] EXT4-fs (dm-3): mounted filesystem with ordered data mode. 
Opts: (null)
[   25.326536] RPC: Registered named UNIX socket transport module.
[   25.326544] RPC: Registered udp transport module.
[   25.326577] RPC: Registered tcp transport module.
[   25.326580] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   25.356511] FS-Cache: Loaded
[   25.370980] Key type dns_resolver registered
[   25.465228] FS-Cache: Netfs 'nfs' registered for caching
[   25.579273] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   28.727841] ip_tables: (C) 2000-2006 Netfilter Core Team
[   29.083457] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   29.399924] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   29.840431] input: ACPI Virtual Keyboard Device as 
/devices/virtual/input/input14
[   33.049437] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   33.049450] Bluetooth: BNEP filters: protocol multicast
[   33.049481] Bluetooth: BNEP socket layer initialized
[   33.075344] Bluetooth: RFCOMM TTY layer initialized
[   33.075387] Bluetooth: RFCOMM socket layer initialized
[   33.075395] Bluetooth: RFCOMM ver 1.11
[   33.712584] lp: driver loaded but no devices found
[   33.823197] ppdev: user-space parallel port driver
[   50.849280] brcmsmac bcma0:0: firmware: agent loaded brcm/bcm43xx-0.fw into 
memory
[   50.858693] brcmsmac bcma0:0: firmware: agent loaded brcm/bcm43xx_hdr-0.fw 
into memory
[   50.908227] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: 
false (implement)
[   50.908414] brcmsmac bcma0:0: brcms_ops_config: change power-save mode: 
false (implement)
[   50.909187] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   58.086404] wlan0: authenticate with XX:XX:XX:XX:XX:XX
[   58.090726] wlan0: send auth to XX:XX:XX:XX:XX:XX (try 1/3)
[   58.094508] wlan0: authenticated
[   58.098329] wlan0: associate with XX:XX:XX:XX:XX:XX (try 1/3)
[   58.102206] wlan0: RX AssocResp from XX:XX:XX:XX:XX:XX (capab=0x401 
status=0 aid=1)
[   58.103257] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: 
associated
[   58.103423] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true 
(implement)
[   58.103612] wlan0: associated
[   58.103642] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   58.103877] cfg80211: Calling CRDA for country: DE
[   58.128934] cfg80211: Regulatory domain changed to country: DE
[   58.128949] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   58.128958] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 
mBm)
[   58.128965] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 
mBm)
[   58.128972] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 
mBm)
[   58.128978] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 
mBm)


Greetings and thanks for your help,
Maxi
--nextPart1667363.A4eKZJKYcg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAABCgAGBQJRxJrVAAoJEIHqZH0kK9IVGX0P/2A8HCX89JiqfVY1KuuQyTPs
MlltIZUZ3SujALOJIEUADKgOzyg50QLn7pf4xXFsJit+zMd2Q26IE554MYS9MUjR
Msdnlo1telx951Tne9aGkpjwbKpVNHbVQg5u+hRX4jj94iyQPJQ9jYeKUeA+4iCW
rqFxQ/RXqowDEN6LiSZygQGDcSVZy97r0hGyd3Mnkm35hIGOQwcJ2hnobeyH1Ice
vpMgPscbSF0EcDXvmkmF52B/wDHJ0QI3jr7dSKETwzyQYZFXTo0EEyKqNN/GKw83
r/TLZfTVvZ+POX0po+bgkqI2JxNYdqsRO9wOpYviqxdz29uW5ApIYSF9LkYS4iBh
Amdi3OZe7NLSZXQNxi6Il09eW4IVQzNkjszSiz88/tYXEoxd7Q7lP83U1sLPePSX
GP63O2zkKUBS58V/RWgtdtzFy+mNZy4Zvc71rVbj2yoRe7JrYaxnTmlYvNJuJbOf
99JXkNvSGc3lnceHOv5G5NcEz225IUVxrag8E5grBBhRGYpmpMFp+trC9T4uLPFT
Ysj15CSbWcW9oIIoQPqZIIgtSwJx1itIy8WBT8FgVaMghKYzD92pUqYU8tQJKnR9
C3FC5ez4X7PYpT6rWdCLnWpOrMd1lZkoD6kw8WrpG4Dyyfsw74QNwhVQasY/lAW0
aTe/iiXq3PvXfLRfBb8e
=9Mi5
-----END PGP SIGNATURE-----

--nextPart1667363.A4eKZJKYcg--


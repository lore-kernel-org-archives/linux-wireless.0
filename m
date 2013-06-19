Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from idun.ftbfs.de ([78.47.2.106]:43293 "EHLO idun.ftbfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935012Ab3FSVnv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 17:43:51 -0400
Date: Wed, 19 Jun 2013 23:34:15 +0200
From: Martin Zobel-Helas <zobel@ftbfs.de>
To: linux-wireless@vger.kernel.org
Cc: zobel@ftbfs.de
Subject: strange b43 problem // 3.9 regression?
Message-ID: <20130619213413.GA8185@ftbfs.de> (sfid-20130619_234358_640425_7500520F)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

i run Debian unstable on my MacBookPro8,2. Since the update to Debian's
3.9 kernel i run into strange problems with my b43 wireless. Still works
perfect with Debian's latest 3.8 kernel from snapshot.debian.org.

Scenario:
Fresh reboot into Linux 3.9 kernel, without loading any wireless driver.

# cat /proc/version 
Linux version 3.9-1-amd64 (debian-kernel@lists.debian.org) (gcc version 4.7.2 (Debian 4.7.2-5) ) #1 SMP Debian 3.9.5-1

Kernel 3.8.13 that stills works perfectly:
# dpkg -l linux-image-3.8-2-amd64 | grep ^ii
ii  linux-image-3.8-2-amd64                3.8.13-1     amd64        Linux 3.8 for 64-bit PCs


# lspci -nn | grep 802
03:00.0 Network controller [0280]: Broadcom Corporation BCM4331 802.11a/b/g/n [14e4:4331] (rev 02)

firmware install as per http://homepage.uibk.ac.at/~c705283/archives/2011/09/04/linux_support_for_broadcom_4331_wireless_chip_macbook_pro_81/index.html

# modprobe b43
# iwlist scan
...
wlan0     No scan results

# iwlist wlan0 scan
...
wlan0     No scan results
# 

also NetworkManager does not detect any SSID at this point. I wait for
several minutes, still no results.

Now i plug in my wireless USB wlan token from TP-Link
# lsusb | grep TP-Link
Bus 001 Device 028: ID 0cf3:7015 Atheros Communications, Inc. TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]
# iwlist wlan1 scan | grep Cell
          Cell 01 - Address: C4:0A:CB:DE:8C:B0
          Cell 02 - Address: C4:0A:CB:DE:8C:B1
          Cell 03 - Address: C4:0A:CB:DE:8C:B2

# iwlist wlan0 scan | grep Cell
#

So still no results here. But the interesting part starts now:
If i now do the following:
# iwlist scan | grep Cell
          Cell 01 - Address: C4:0A:CB:DE:8C:B0
          Cell 02 - Address: C4:0A:CB:DE:8C:B2
          Cell 03 - Address: C4:0A:CB:DE:8C:B1
          Cell 01 - Address: C4:0A:CB:DE:8C:B0
          Cell 02 - Address: C4:0A:CB:DE:8C:B2
          Cell 03 - Address: C4:0A:CB:DE:8C:B1
# iwlist wlan0 scan | grep Cell
          Cell 01 - Address: C4:0A:CB:DE:8C:B0
          Cell 02 - Address: C4:0A:CB:DE:8C:B1
          Cell 03 - Address: C4:0A:CB:DE:8C:B2

and NetworkManager immediately sees SSIDs on my wireless wlan0
interface. Running "iwlist wlan0 scan" from now on shows me my SSIDs on
the b43 interface.

Doing the above procedure, works reliable reproducable for me.

"iwlist scan" first scans my wlan1 interface (TP-Link) and then wlan0
(Broadcom). I therefor wonder if this is somewhat a timing problem in 
the wireless stack.

I attached detailed information about my hardware of my system to this
mail. If you need any more information, i will provide the needed
information. I need to admit that i am not that deeply involved into
linux kernel.

Cheers,
Martin
-- 
 Martin Zobel-Helas <zobel@ftbfs.de>
 GPG Fingerprint:  6B18 5642 8E41 EC89 3D5D  BDBB 53B1 AC6D B11B 627B 

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lshw

kvasir
    description: Notebook
    product: MacBookPro8,2 (System SKU#)
    vendor: Apple Inc.
    version: 1.0
    serial: C02FK23WDF8Y
    width: 64 bits
    capabilities: smbios-2.4 dmi-2.4 vsyscall32
    configuration: boot=normal chassis=notebook family=MacBook Pro sku=System SKU# uuid=A712F2DF-2839-805E-AEB8-1E1682E1322F
  *-core
       description: Motherboard
       product: Mac-94245A3940C91C80
       vendor: Apple Inc.
       physical id: 0
       version: MacBookPro8,2
       serial: C02115500D8DMNVA2
       slot: Part Component
     *-cpu:0
          description: CPU
          product: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
          vendor: Intel Corp.
          physical id: 0
          bus info: cpu@0
          version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
          slot: U2E1
          size: 1200MHz
          capacity: 1200MHz
          width: 64 bits
          capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp x86-64 constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid cpufreq
        *-cache:0
             description: L1 cache
             physical id: 2
             slot: Unknown
             size: 32KiB
             capacity: 32KiB
             capabilities: asynchronous internal write-back
        *-cache:1
             description: L2 cache
             physical id: 3
             slot: Unknown
             size: 256KiB
             capacity: 256KiB
             capabilities: asynchronous internal write-back instruction
        *-cache:2
             description: L3 cache
             physical id: 4
             slot: Unknown
             size: 6KiB
             capacity: 6KiB
             capabilities: asynchronous internal write-back instruction
     *-cache:0
          description: L1 cache
          physical id: 1
          slot: Unknown
          size: 32KiB
          capacity: 32KiB
          capabilities: asynchronous internal write-back
     *-cpu:1
          description: CPU
          vendor: Intel(R) Corporation
          physical id: 5
          bus info: cpu@1
          version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
          slot: U2E1
          size: 800MHz
          capacity: 800MHz
          capabilities: cpufreq
        *-cache:0
             description: L1 cache
             physical id: 7
             slot: Unknown
             size: 32KiB
             capacity: 32KiB
             capabilities: asynchronous internal write-back
        *-cache:1
             description: L2 cache
             physical id: 8
             slot: Unknown
             size: 256KiB
             capacity: 256KiB
             capabilities: asynchronous internal write-back instruction
        *-cache:2
             description: L3 cache
             physical id: 9
             slot: Unknown
             size: 6KiB
             capacity: 6KiB
             capabilities: asynchronous internal write-back instruction
     *-cache:1
          description: L1 cache
          physical id: 6
          slot: Unknown
          size: 32KiB
          capacity: 32KiB
          capabilities: asynchronous internal write-back
     *-cpu:2
          description: CPU
          vendor: Intel(R) Corporation
          physical id: a
          bus info: cpu@2
          version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
          slot: U2E1
          size: 800MHz
          capacity: 800MHz
          capabilities: cpufreq
        *-cache:0
             description: L1 cache
             physical id: c
             slot: Unknown
             size: 32KiB
             capacity: 32KiB
             capabilities: asynchronous internal write-back
        *-cache:1
             description: L2 cache
             physical id: d
             slot: Unknown
             size: 256KiB
             capacity: 256KiB
             capabilities: asynchronous internal write-back instruction
        *-cache:2
             description: L3 cache
             physical id: e
             slot: Unknown
             size: 6KiB
             capacity: 6KiB
             capabilities: asynchronous internal write-back instruction
     *-cache:2
          description: L1 cache
          physical id: b
          slot: Unknown
          size: 32KiB
          capacity: 32KiB
          capabilities: asynchronous internal write-back
     *-cpu:3
          description: CPU
          vendor: Intel(R) Corporation
          physical id: f
          bus info: cpu@3
          version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
          slot: U2E1
          size: 800MHz
          capacity: 800MHz
          capabilities: cpufreq
        *-cache:0
             description: L1 cache
             physical id: 11
             slot: Unknown
             size: 32KiB
             capacity: 32KiB
             capabilities: asynchronous internal write-back
        *-cache:1
             description: L2 cache
             physical id: 12
             slot: Unknown
             size: 256KiB
             capacity: 256KiB
             capabilities: asynchronous internal write-back instruction
        *-cache:2
             description: L3 cache
             physical id: 13
             slot: Unknown
             size: 6KiB
             capacity: 6KiB
             capabilities: asynchronous internal write-back instruction
     *-cache:3
          description: L1 cache
          physical id: 10
          slot: Unknown
          size: 32KiB
          capacity: 32KiB
          capabilities: asynchronous internal write-back
     *-cpu:4
          description: CPU
          vendor: Intel(R) Corporation
          physical id: 14
          bus info: cpu@4
          version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
          slot: U2E1
          size: 800MHz
          capacity: 800MHz
          capabilities: cpufreq
        *-cache:0
             description: L1 cache
             physical id: 16
             slot: Unknown
             size: 32KiB
             capacity: 32KiB
             capabilities: asynchronous internal write-back
        *-cache:1
             description: L2 cache
             physical id: 17
             slot: Unknown
             size: 256KiB
             capacity: 256KiB
             capabilities: asynchronous internal write-back instruction
        *-cache:2
             description: L3 cache
             physical id: 18
             slot: Unknown
             size: 6KiB
             capacity: 6KiB
             capabilities: asynchronous internal write-back instruction
     *-cache:4
          description: L1 cache
          physical id: 15
          slot: Unknown
          size: 32KiB
          capacity: 32KiB
          capabilities: asynchronous internal write-back
     *-cpu:5
          description: CPU
          vendor: Intel(R) Corporation
          physical id: 19
          bus info: cpu@5
          version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
          slot: U2E1
          size: 800MHz
          capacity: 800MHz
          capabilities: cpufreq
        *-cache:0
             description: L1 cache
             physical id: 1b
             slot: Unknown
             size: 32KiB
             capacity: 32KiB
             capabilities: asynchronous internal write-back
        *-cache:1
             description: L2 cache
             physical id: 1c
             slot: Unknown
             size: 256KiB
             capacity: 256KiB
             capabilities: asynchronous internal write-back instruction
        *-cache:2
             description: L3 cache
             physical id: 1d
             slot: Unknown
             size: 6KiB
             capacity: 6KiB
             capabilities: asynchronous internal write-back instruction
     *-cache:5
          description: L1 cache
          physical id: 1a
          slot: Unknown
          size: 32KiB
          capacity: 32KiB
          capabilities: asynchronous internal write-back
     *-cpu:6
          description: CPU
          vendor: Intel(R) Corporation
          physical id: 1e
          bus info: cpu@6
          version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
          slot: U2E1
          size: 800MHz
          capacity: 800MHz
          capabilities: cpufreq
        *-cache:0
             description: L1 cache
             physical id: 20
             slot: Unknown
             size: 32KiB
             capacity: 32KiB
             capabilities: asynchronous internal write-back
        *-cache:1
             description: L2 cache
             physical id: 21
             slot: Unknown
             size: 256KiB
             capacity: 256KiB
             capabilities: asynchronous internal write-back instruction
        *-cache:2
             description: L3 cache
             physical id: 22
             slot: Unknown
             size: 6KiB
             capacity: 6KiB
             capabilities: asynchronous internal write-back instruction
     *-cache:6
          description: L1 cache
          physical id: 1f
          slot: Unknown
          size: 32KiB
          capacity: 32KiB
          capabilities: asynchronous internal write-back
     *-cpu:7
          description: CPU
          vendor: Intel(R) Corporation
          physical id: 23
          bus info: cpu@7
          version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
          slot: U2E1
          size: 800MHz
          capacity: 800MHz
          capabilities: cpufreq
        *-cache:0
             description: L1 cache
             physical id: 25
             slot: Unknown
             size: 32KiB
             capacity: 32KiB
             capabilities: asynchronous internal write-back
        *-cache:1
             description: L2 cache
             physical id: 26
             slot: Unknown
             size: 256KiB
             capacity: 256KiB
             capabilities: asynchronous internal write-back instruction
        *-cache:2
             description: L3 cache
             physical id: 27
             slot: Unknown
             size: 6KiB
             capacity: 6KiB
             capabilities: asynchronous internal write-back instruction
     *-cache:7
          description: L1 cache
          physical id: 24
          slot: Unknown
          size: 32KiB
          capacity: 32KiB
          capabilities: asynchronous internal write-back
     *-memory
          description: System Memory
          physical id: 28
          slot: System board or motherboard
          size: 8GiB
        *-bank:0
             description: SODIMM DDR3 Synchronous 1333 MHz (0.8 ns)
             product: 9905428-012.A00LF
             vendor: AMD
             physical id: 0
             serial: 0x6D22E49C
             slot: DIMM0
             size: 4GiB
             clock: 1333MHz (0.8ns)
        *-bank:1
             description: SODIMM DDR3 Synchronous 1333 MHz (0.8 ns)
             product: 9905428-012.A00LF
             vendor: AMD
             physical id: 1
             serial: 0x651F7A5B
             slot: DIMM0
             size: 4GiB
             clock: 1333MHz (0.8ns)
     *-firmware
          description: BIOS
          vendor: Apple Inc.
          physical id: 2e
          version: MBP81.88Z.0047.B27.1201241646
          date: 01/24/12
          size: 1MiB
          capacity: 8128KiB
          capabilities: pci upgrade shadowing cdboot bootselect acpi ieee1394boot smartbattery netboot
     *-pci
          description: Host bridge
          product: 2nd Generation Core Processor Family DRAM Controller
          vendor: Intel Corporation
          physical id: 100
          bus info: pci@0000:00:00.0
          version: 09
          width: 32 bits
          clock: 33MHz
        *-pci:0
             description: PCI bridge
             product: Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port
             vendor: Intel Corporation
             physical id: 1
             bus info: pci@0000:00:01.0
             version: 09
             width: 32 bits
             clock: 33MHz
             capabilities: pci pm msi pciexpress normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:40 ioport:2000(size=4096) memory:b0800000-b08fffff ioport:90000000(size=268435456)
           *-display
                description: VGA compatible controller
                product: Seymour [Radeon HD 6400M/7400M Series]
                vendor: Advanced Micro Devices, Inc. [AMD/ATI]
                physical id: 0
                bus info: pci@0000:01:00.0
                version: 00
                width: 64 bits
                clock: 33MHz
                capabilities: pm pciexpress msi vga_controller bus_master cap_list rom
                configuration: driver=fglrx_pci latency=0
                resources: irq:54 memory:90000000-9fffffff memory:b0800000-b081ffff ioport:2000(size=256) memory:b0820000-b083ffff
           *-multimedia
                description: Audio device
                product: Caicos HDMI Audio [Radeon HD 6400 Series]
                vendor: Advanced Micro Devices, Inc. [AMD/ATI]
                physical id: 0.1
                bus info: pci@0000:01:00.1
                version: 00
                width: 64 bits
                clock: 33MHz
                capabilities: pm pciexpress msi bus_master cap_list
                configuration: driver=snd_hda_intel latency=0
                resources: irq:47 memory:b0840000-b0843fff
        *-pci:1
             description: PCI bridge
             product: Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port
             vendor: Intel Corporation
             physical id: 1.1
             bus info: pci@0000:00:01.1
             version: 09
             width: 32 bits
             clock: 33MHz
             capabilities: pci pm msi pciexpress normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:41 ioport:4000(size=4096) memory:b0a00000-b4efffff ioport:b4f00000(size=67108864)
        *-communication
             description: Communication controller
             product: 6 Series/C200 Series Chipset Family MEI Controller #1
             vendor: Intel Corporation
             physical id: 16
             bus info: pci@0000:00:16.0
             version: 04
             width: 64 bits
             clock: 33MHz
             capabilities: pm msi bus_master cap_list
             configuration: driver=mei latency=0
             resources: irq:45 memory:b0907100-b090710f
        *-usb:0
             description: USB controller
             product: 6 Series/C200 Series Chipset Family USB Universal Host Controller #5
             vendor: Intel Corporation
             physical id: 1a
             bus info: pci@0000:00:1a.0
             version: 05
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master cap_list
             configuration: driver=uhci_hcd latency=0
             resources: irq:21 ioport:3120(size=32)
        *-usb:1
             description: USB controller
             product: 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2
             vendor: Intel Corporation
             physical id: 1a.7
             bus info: pci@0000:00:1a.7
             version: 05
             width: 32 bits
             clock: 33MHz
             capabilities: pm debug ehci bus_master cap_list
             configuration: driver=ehci-pci latency=0
             resources: irq:23 memory:b0906c00-b0906fff
        *-multimedia
             description: Audio device
             product: 6 Series/C200 Series Chipset Family High Definition Audio Controller
             vendor: Intel Corporation
             physical id: 1b
             bus info: pci@0000:00:1b.0
             version: 05
             width: 64 bits
             clock: 33MHz
             capabilities: pm msi pciexpress bus_master cap_list
             configuration: driver=snd_hda_intel latency=0
             resources: irq:46 memory:b0900000-b0903fff
        *-pci:2
             description: PCI bridge
             product: 6 Series/C200 Series Chipset Family PCI Express Root Port 1
             vendor: Intel Corporation
             physical id: 1c
             bus info: pci@0000:00:1c.0
             version: b5
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:42 memory:b0700000-b07fffff ioport:b0400000(size=1048576)
           *-network
                description: Ethernet interface
                product: NetXtreme BCM57765 Gigabit Ethernet PCIe
                vendor: Broadcom Corporation
                physical id: 0
                bus info: pci@0000:02:00.0
                logical name: eth0
                version: 10
                serial: c8:2a:14:2e:76:a7
                capacity: 1Gbit/s
                width: 64 bits
                clock: 33MHz
                capabilities: pm msi msix pciexpress bus_master cap_list ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd 1000bt 1000bt-fd autonegotiation
                configuration: autonegotiation=on broadcast=yes driver=tg3 driverversion=3.130 firmware=57765-v1.37 latency=0 link=no multicast=yes port=twisted pair
                resources: irq:16 memory:b0400000-b040ffff memory:b0410000-b041ffff
           *-generic
                description: SD Host controller
                product: NetXtreme BCM57765 Memory Card Reader
                vendor: Broadcom Corporation
                physical id: 0.1
                bus info: pci@0000:02:00.1
                version: 10
                width: 64 bits
                clock: 33MHz
                capabilities: pm msi pciexpress bus_master cap_list
                configuration: driver=sdhci-pci latency=0
                resources: irq:17 memory:b0420000-b042ffff
        *-pci:3
             description: PCI bridge
             product: 6 Series/C200 Series Chipset Family PCI Express Root Port 2
             vendor: Intel Corporation
             physical id: 1c.1
             bus info: pci@0000:00:1c.1
             version: b5
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:43 memory:b0600000-b06fffff
           *-network
                description: Network controller
                product: BCM4331 802.11a/b/g/n
                vendor: Broadcom Corporation
                physical id: 0
                bus info: pci@0000:03:00.0
                version: 02
                width: 64 bits
                clock: 33MHz
                capabilities: pm msi pciexpress bus_master cap_list
                configuration: driver=bcma-pci-bridge latency=0
                resources: irq:17 memory:b0600000-b0603fff
        *-pci:4
             description: PCI bridge
             product: 6 Series/C200 Series Chipset Family PCI Express Root Port 3
             vendor: Intel Corporation
             physical id: 1c.2
             bus info: pci@0000:00:1c.2
             version: b5
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:44 memory:b0500000-b05fffff
           *-firewire
                description: FireWire (IEEE 1394)
                product: FW643 [TrueFire] PCIe 1394b Controller
                vendor: LSI Corporation
                physical id: 0
                bus info: pci@0000:04:00.0
                version: 08
                width: 64 bits
                clock: 33MHz
                capabilities: pm msi pciexpress ohci bus_master cap_list
                configuration: driver=firewire_ohci latency=0
                resources: irq:48 memory:b0500000-b0500fff
        *-usb:2
             description: USB controller
             product: 6 Series/C200 Series Chipset Family USB Universal Host Controller #1
             vendor: Intel Corporation
             physical id: 1d
             bus info: pci@0000:00:1d.0
             version: 05
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master cap_list
             configuration: driver=uhci_hcd latency=0
             resources: irq:19 ioport:30c0(size=32)
        *-usb:3
             description: USB controller
             product: 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1
             vendor: Intel Corporation
             physical id: 1d.7
             bus info: pci@0000:00:1d.7
             version: 05
             width: 32 bits
             clock: 33MHz
             capabilities: pm debug ehci bus_master cap_list
             configuration: driver=ehci-pci latency=0
             resources: irq:22 memory:b0906800-b0906bff
        *-isa
             description: ISA bridge
             product: HM65 Express Chipset Family LPC Controller
             vendor: Intel Corporation
             physical id: 1f
             bus info: pci@0000:00:1f.0
             version: 05
             width: 32 bits
             clock: 33MHz
             capabilities: isa bus_master cap_list
             configuration: driver=lpc_ich latency=0
             resources: irq:0
        *-ide
             description: IDE interface
             product: 6 Series/C200 Series Chipset Family 4 port SATA IDE Controller
             vendor: Intel Corporation
             physical id: 1f.2
             bus info: pci@0000:00:1f.2
             version: 05
             width: 32 bits
             clock: 66MHz
             capabilities: ide pm bus_master cap_list
             configuration: driver=ata_piix latency=0
             resources: irq:19 ioport:3148(size=8) ioport:315c(size=4) ioport:3140(size=8) ioport:3158(size=4) ioport:3060(size=16) ioport:ffe0(size=16)
        *-serial UNCLAIMED
             description: SMBus
             product: 6 Series/C200 Series Chipset Family SMBus Controller
             vendor: Intel Corporation
             physical id: 1f.3
             bus info: pci@0000:00:1f.3
             version: 05
             width: 64 bits
             clock: 33MHz
             configuration: latency=0
             resources: memory:b0907000-b09070ff ioport:efa0(size=32)
     *-scsi:0
          physical id: 2
          logical name: scsi0
          capabilities: emulated
        *-disk
             description: ATA Disk
             product: OCZ-VERTEX4
             physical id: 0.0.0
             bus info: scsi@0:0.0.0
             logical name: /dev/sda
             version: 1.5
             serial: OCZ-C5YY451Z33Z6FL19
             size: 476GiB (512GB)
             capabilities: partitioned partitioned:dos
             configuration: ansiversion=5 sectorsize=512
           *-volume:0 UNCLAIMED
                description: EFI GPT partition
                physical id: 1
                bus info: scsi@0:0.0.0,1
                capacity: 200MiB
                capabilities: primary nofs
           *-volume:1
                description: Darwin/OS X HFS+ partition
                vendor: Mac OS X (journaled)
                physical id: 2
                bus info: scsi@0:0.0.0,2
                logical name: /dev/sda2
                version: 5
                serial: 237c0928-277c-1a34-0000-0000003ba000
                size: 119GiB
                capacity: 119GiB
                capabilities: primary hfsx journaled bootable osx hfsplus initialized
                configuration: boot=osx checked=2012-12-07 21:32:57 created=2012-12-07 12:32:57 filesystem=hfsplus lastmountedby=HFSJ modified=2013-06-11 20:22:44 state=clean
           *-volume:2
                description: EXT4 volume
                vendor: Linux
                physical id: 3
                bus info: scsi@0:0.0.0,3
                logical name: /dev/sda3
                logical name: /boot
                version: 1.0
                serial: 82c5c784-30b6-4db0-bf22-f34c41754f3c
                size: 243MiB
                capacity: 243MiB
                capabilities: primary journaled extended_attributes huge_files dir_nlink recover extents ext4 ext2 initialized
                configuration: created=2012-12-08 00:01:57 filesystem=ext4 lastmountpoint=/boot modified=2013-06-17 20:10:12 mount.fstype=ext4 mount.options=rw,relatime,data=ordered mounted=2013-06-17 20:10:12 state=mounted
           *-volume:3
                description: W95 FAT32 partition
                physical id: 4
                bus info: scsi@0:0.0.0,4
                logical name: /dev/sda4
                serial: 9be96758-3dfc-4139-87d6-80bff2c11abd
                size: 357GiB
                capacity: 357GiB
                width: 512 bits
                capabilities: primary bootable encrypted luks initialized
                configuration: bits=512 cipher=aes filesystem=luks hash=sha1 mode=xts-plain64 version=1
     *-scsi:1
          physical id: 3
          logical name: scsi1
          capabilities: emulated
        *-cdrom
             description: DVD writer
             product: DVD-R   UJ-898
             vendor: MATSHITA
             physical id: 0.0.0
             bus info: scsi@1:0.0.0
             logical name: /dev/cdrom
             logical name: /dev/cdrw
             logical name: /dev/dvd
             logical name: /dev/dvdrw
             logical name: /dev/sr0
             version: HE13
             capabilities: removable audio cd-r cd-rw dvd dvd-r
             configuration: ansiversion=5 status=open
  *-battery
       product: Unknown
       vendor: Unknown
       physical id: 1
       version: Unknown
       serial: Unknown
       slot: Unknown
  *-network:0
       description: Wireless interface
       physical id: 2
       bus info: usb@1:1.3
       logical name: wlan1
       serial: 64:70:02:24:ec:2e
       capabilities: ethernet physical wireless
       configuration: broadcast=yes driver=ath9k_htc driverversion=3.9-1-amd64 firmware=1.3 ip=10.9.14.117 link=yes multicast=yes wireless=IEEE 802.11bgn
  *-network:1
       description: Wireless interface
       physical id: 3
       logical name: wlan0
       serial: e4:ce:8f:0a:f0:72
       capabilities: ethernet physical wireless
       configuration: broadcast=yes driver=b43 driverversion=3.9-1-amd64 firmware=666.2 ip=10.9.14.10 link=yes multicast=yes wireless=IEEE 802.11bg

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lsmod

Module                  Size  Used by
b43                   326938  0 
ssb                    49391  1 b43
brcmsmac              443147  0 
cordic                 12352  1 brcmsmac
brcmutil               12824  1 brcmsmac
ath9k_htc              52702  0 
ath9k_common           12728  1 ath9k_htc
ath9k_hw              345710  2 ath9k_common,ath9k_htc
ath                    21417  3 ath9k_common,ath9k_htc,ath9k_hw
bcma                   33422  2 b43,brcmsmac
lib80211               12941  0 
rng_core               12761  1 b43
pcmcia                 32769  2 b43,ssb
pcmcia_core            18471  1 pcmcia
tun                    22518  2 
ufs                    58989  0 
qnx4                   13069  0 
hfsplus                81767  0 
hfs                    45904  0 
minix                  27669  0 
ntfs                  161077  0 
vfat                   17365  0 
msdos                  17077  0 
fat                    46078  2 vfat,msdos
jfs                   137973  0 
xfs                   623636  0 
reiserfs              193545  0 
ext3                  162558  0 
jbd                    57997  1 ext3
ext2                   59601  0 
efivars                22834  0 
cpuid                  12708  0 
arc4                   12543  4 
mac80211              390921  3 b43,brcmsmac,ath9k_htc
cfg80211              366201  5 b43,ath,brcmsmac,mac80211,ath9k_htc
ip6table_filter        12540  0 
ip6_tables             22050  1 ip6table_filter
ipt_MASQUERADE         12594  3 
iptable_nat            12646  1 
nf_nat_ipv4            12950  1 iptable_nat
nf_nat                 18378  3 ipt_MASQUERADE,nf_nat_ipv4,iptable_nat
nf_conntrack_ipv4      18549  2 
nf_defrag_ipv4         12483  1 nf_conntrack_ipv4
xt_conntrack           12681  1 
nf_conntrack           59734  6 ipt_MASQUERADE,nf_nat,nf_nat_ipv4,xt_conntrack,iptable_nat,nf_conntrack_ipv4
ipt_REJECT             12502  2 
xt_CHECKSUM            12471  1 
iptable_mangle         12536  1 
xt_tcpudp              12570  5 
iptable_filter         12536  1 
ip_tables              22036  3 iptable_filter,iptable_mangle,iptable_nat
x_tables               19041  10 ip6table_filter,xt_CHECKSUM,ip_tables,xt_tcpudp,ipt_MASQUERADE,xt_conntrack,iptable_filter,ipt_REJECT,iptable_mangle,ip6_tables
bridge                 77397  0 
stp                    12437  1 bridge
llc                    12822  2 stp,bridge
parport_pc             22409  0 
ppdev                  12763  0 
lp                     13064  0 
parport                31901  3 lp,ppdev,parport_pc
rfcomm                 33696  14 
bnep                   17574  2 
pci_stub               12429  1 
vboxpci                19094  0 
vboxnetadp             25443  0 
vboxnetflt             23648  0 
vboxdrv               217306  3 vboxnetadp,vboxnetflt,vboxpci
binfmt_misc            12957  1 
uinput                 17478  3 
deflate                12551  0 
ctr                    12927  0 
twofish_generic        16569  0 
twofish_avx_x86_64     45909  0 
twofish_x86_64_3way    25556  1 twofish_avx_x86_64
twofish_x86_64         12541  2 twofish_avx_x86_64,twofish_x86_64_3way
twofish_common         20585  4 twofish_generic,twofish_avx_x86_64,twofish_x86_64_3way,twofish_x86_64
camellia_generic       29068  0 
camellia_x86_64        50595  0 
serpent_avx_x86_64     46053  0 
serpent_sse2_x86_64    50185  0 
serpent_generic        25044  2 serpent_sse2_x86_64,serpent_avx_x86_64
glue_helper            12672  5 camellia_x86_64,serpent_sse2_x86_64,serpent_avx_x86_64,twofish_avx_x86_64,twofish_x86_64_3way
blowfish_generic       12464  0 
blowfish_x86_64        21132  0 
blowfish_common        16487  2 blowfish_generic,blowfish_x86_64
cast5_generic          20813  0 
cast_common            12313  1 cast5_generic
des_generic            20851  0 
cbc                    12696  0 
xcbc                   12759  0 
rmd160                 16640  0 
sha512_generic         12625  0 
sha256_generic         16797  0 
sha1_ssse3             16872  0 
sha1_generic           12582  1 sha1_ssse3
hmac                   12921  0 
crypto_null            12732  0 
af_key                 31798  0 
xfrm_algo              13064  1 af_key
loop                   22908  0 
fuse                   67160  3 
snd_hda_codec_hdmi     31576  1 
snd_hda_codec_cirrus    13281  1 
snd_hda_intel          35753  11 
snd_hda_codec         122569  3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec_cirrus
snd_hwdep              13189  1 snd_hda_codec
snd_pcm_oss            37079  0 
snd_mixer_oss          18035  3 snd_pcm_oss
snd_pcm                68523  4 snd_pcm_oss,snd_hda_codec_hdmi,snd_hda_codec,snd_hda_intel
snd_page_alloc         13018  2 snd_pcm,snd_hda_intel
acpi_cpufreq           13317  -1 
mperf                  12453  1 acpi_cpufreq
snd_seq_midi           12848  0 
snd_seq_midi_event     13316  1 snd_seq_midi
joydev                 17317  0 
snd_rawmidi            23034  1 snd_seq_midi
fglrx                5171661  117 
uvcvideo               70884  0 
btusb                  17553  0 
videobuf2_vmalloc      12860  1 uvcvideo
videobuf2_memops       12519  1 videobuf2_vmalloc
videobuf2_core         31098  1 uvcvideo
bluetooth             168899  24 bnep,btusb,rfcomm
videodev               92442  2 uvcvideo,videobuf2_core
rfkill                 19159  6 cfg80211,bluetooth
media                  18184  2 uvcvideo,videodev
bcm5974                12886  0 
iTCO_wdt               12831  0 
evdev                  17650  22 
snd_seq                45225  2 snd_seq_midi_event,snd_seq_midi
iTCO_vendor_support    12704  1 iTCO_wdt
coretemp               12854  0 
kvm_intel             119055  0 
snd_seq_device         13176  3 snd_seq,snd_rawmidi,snd_seq_midi
snd_timer              22812  2 snd_pcm,snd_seq
kvm                   316100  1 kvm_intel
snd                    53077  30 snd_pcm_oss,snd_hwdep,snd_timer,snd_hda_codec_hdmi,snd_pcm,snd_seq,snd_rawmidi,snd_hda_codec,snd_hda_intel,snd_seq_device,snd_mixer_oss,snd_hda_codec_cirrus
mei                    37192  0 
i2c_i801               17045  0 
lpc_ich                16757  0 
i2c_core               24040  2 i2c_i801,videodev
mfd_core               12601  1 lpc_ich
apple_gmux             13057  0 
applesmc               18571  0 
input_polldev          12906  1 applesmc
soundcore              13026  3 snd
processor              28422  1 acpi_cpufreq
video                  17686  1 apple_gmux
thermal_sys            22879  2 video,processor
pcspkr                 12632  0 
battery                13146  0 
apple_bl               12872  1 apple_gmux
ac                     12624  0 
button                 12944  1 fglrx
ext4                  410146  9 
crc16                  12343  2 ext4,bluetooth
jbd2                   80811  1 ext4
mbcache                13082  3 ext2,ext3,ext4
btrfs                 652178  0 
xor                    16985  1 btrfs
zlib_deflate           25638  2 deflate,btrfs
raid6_pq               95431  1 btrfs
libcrc32c              12426  2 xfs,btrfs
dm_crypt               18372  1 
dm_mod                 64002  38 dm_crypt
sg                     26095  0 
sr_mod                 21988  0 
sd_mod                 40549  3 
cdrom                  35212  1 sr_mod
crc_t10dif             12348  1 sd_mod
ata_generic            12490  0 
hid_generic            12393  0 
hid_apple              12633  0 
usbhid                 40792  0 
hid                    81763  3 hid_generic,usbhid,hid_apple
crc32c_intel           21850  1 
ghash_clmulni_intel    13062  0 
aesni_intel            50700  7 
aes_x86_64             16719  1 aesni_intel
sdhci_pci              17847  0 
ablk_helper            12572  4 serpent_sse2_x86_64,aesni_intel,serpent_avx_x86_64,twofish_avx_x86_64
sdhci                  27242  1 sdhci_pci
cryptd                 14560  4 ghash_clmulni_intel,aesni_intel,ablk_helper
xts                    12722  6 camellia_x86_64,serpent_sse2_x86_64,aesni_intel,serpent_avx_x86_64,twofish_avx_x86_64,twofish_x86_64_3way
lrw                    12871  6 camellia_x86_64,serpent_sse2_x86_64,aesni_intel,serpent_avx_x86_64,twofish_avx_x86_64,twofish_x86_64_3way
ata_piix               29671  2 
gf128mul               13047  2 lrw,xts
firewire_ohci          31931  0 
firewire_core          49206  1 firewire_ohci
crc_itu_t              12347  1 firewire_core
uhci_hcd               26976  0 
ehci_pci               12472  0 
microcode              30413  0 
ehci_hcd               40464  1 ehci_pci
mmc_core               77725  4 b43,ssb,sdhci,sdhci_pci
tg3                   128907  0 
ptp                    13403  1 tg3
pps_core               13271  1 ptp
libphy                 23687  1 tg3
libata                141721  2 ata_generic,ata_piix
scsi_mod              162613  4 sg,libata,sd_mod,sr_mod
usbcore               134791  8 btusb,uhci_hcd,uvcvideo,ehci_hcd,ehci_pci,usbhid,ath9k_htc,bcm5974
usb_common             12354  1 usbcore

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge [0600]: Intel Corporation 2nd Generation Core Processor Family DRAM Controller [8086:0104] (rev 09)
00:01.0 PCI bridge [0604]: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port [8086:0101] (rev 09)
00:01.1 PCI bridge [0604]: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port [8086:0105] (rev 09)
00:16.0 Communication controller [0780]: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 [8086:1c3a] (rev 04)
00:1a.0 USB controller [0c03]: Intel Corporation 6 Series/C200 Series Chipset Family USB Universal Host Controller #5 [8086:1c2c] (rev 05)
00:1a.7 USB controller [0c03]: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 [8086:1c2d] (rev 05)
00:1b.0 Audio device [0403]: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller [8086:1c20] (rev 05)
00:1c.0 PCI bridge [0604]: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 [8086:1c10] (rev b5)
00:1c.1 PCI bridge [0604]: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 [8086:1c12] (rev b5)
00:1c.2 PCI bridge [0604]: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 [8086:1c14] (rev b5)
00:1d.0 USB controller [0c03]: Intel Corporation 6 Series/C200 Series Chipset Family USB Universal Host Controller #1 [8086:1c27] (rev 05)
00:1d.7 USB controller [0c03]: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 [8086:1c26] (rev 05)
00:1f.0 ISA bridge [0601]: Intel Corporation HM65 Express Chipset Family LPC Controller [8086:1c49] (rev 05)
00:1f.2 IDE interface [0101]: Intel Corporation 6 Series/C200 Series Chipset Family 4 port SATA IDE Controller [8086:1c01] (rev 05)
00:1f.3 SMBus [0c05]: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller [8086:1c22] (rev 05)
01:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Seymour [Radeon HD 6400M/7400M Series] [1002:6760]
01:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Caicos HDMI Audio [Radeon HD 6400 Series] [1002:aa98]
02:00.0 Ethernet controller [0200]: Broadcom Corporation NetXtreme BCM57765 Gigabit Ethernet PCIe [14e4:16b4] (rev 10)
02:00.1 SD Host controller [0805]: Broadcom Corporation NetXtreme BCM57765 Memory Card Reader [14e4:16bc] (rev 10)
03:00.0 Network controller [0280]: Broadcom Corporation BCM4331 802.11a/b/g/n [14e4:4331] (rev 02)
04:00.0 FireWire (IEEE 1394) [0c00]: LSI Corporation FW643 [TrueFire] PCIe 1394b Controller [11c1:5901] (rev 08)

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lsusb

Bus 001 Device 002: ID 0424:2513 Standard Microsystems Corp. 2.0 Hub
Bus 001 Device 003: ID 05ac:8509 Apple, Inc. FaceTime HD Camera
Bus 002 Device 002: ID 0424:2513 Standard Microsystems Corp. 2.0 Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 004: ID 0a5c:4500 Broadcom Corp. BCM2046B1 USB 2.0 Hub (part of BCM2046 Bluetooth)
Bus 001 Device 005: ID 05ac:0246 Apple, Inc. Internal Keyboard/Trackpad (ISO)
Bus 001 Device 028: ID 0cf3:7015 Atheros Communications, Inc. TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]
Bus 002 Device 003: ID 05ac:8242 Apple, Inc. Built-in IR Receiver
Bus 001 Device 008: ID 05ac:821a Apple, Inc. Bluetooth Host Controller

--MGYHOYXEY6WxJCY8
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="kernlog.gz"
Content-Transfer-Encoding: base64

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
5+dwOOT0we4C5OzB7izSThvs/g/KDmZurE4EAA==

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmidecode

# dmidecode 2.12
SMBIOS 2.4 present.
82 structures occupying 3976 bytes.
Table at 0x000E0000.

Handle 0x0000, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: Other
	Manufacturer: Intel(R) Corporation
	ID: A7 06 02 00 FF FB EB BF
	Version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Voltage: 0.0 V
	External Clock: Unknown
	Max Speed: 2000 MHz
	Current Speed: 2033 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0002
	L2 Cache Handle: 0x0003
	L3 Cache Handle: 0x0004
	Serial Number: Not Specified
	Asset Tag: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Part Number: Not Specified

Handle 0x0001, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Other
	Associativity: 16-way Set-associative

Handle 0x0002, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unknown
	Associativity: 16-way Set-associative

Handle 0x0003, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 16-way Set-associative

Handle 0x0004, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 6 kB
	Maximum Size: 6 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 48-way Set-associative

Handle 0x0005, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: Other
	Manufacturer: Intel(R) Corporation
	ID: A7 06 02 00 FF FB EB BF
	Version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Voltage: 0.0 V
	External Clock: Unknown
	Max Speed: 2000 MHz
	Current Speed: 2027 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0007
	L2 Cache Handle: 0x0008
	L3 Cache Handle: 0x0009
	Serial Number: Not Specified
	Asset Tag: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Part Number: Not Specified

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Other
	Associativity: 16-way Set-associative

Handle 0x0007, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unknown
	Associativity: 16-way Set-associative

Handle 0x0008, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 16-way Set-associative

Handle 0x0009, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 6 kB
	Maximum Size: 6 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 48-way Set-associative

Handle 0x000A, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: Other
	Manufacturer: Intel(R) Corporation
	ID: A7 06 02 00 FF FB EB BF
	Version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Voltage: 0.0 V
	External Clock: Unknown
	Max Speed: 2000 MHz
	Current Speed: 2040 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x000C
	L2 Cache Handle: 0x000D
	L3 Cache Handle: 0x000E
	Serial Number: Not Specified
	Asset Tag: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Part Number: Not Specified

Handle 0x000B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Other
	Associativity: 16-way Set-associative

Handle 0x000C, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unknown
	Associativity: 16-way Set-associative

Handle 0x000D, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 16-way Set-associative

Handle 0x000E, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 6 kB
	Maximum Size: 6 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 48-way Set-associative

Handle 0x000F, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: Other
	Manufacturer: Intel(R) Corporation
	ID: A7 06 02 00 FF FB EB BF
	Version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Voltage: 0.0 V
	External Clock: Unknown
	Max Speed: 2000 MHz
	Current Speed: 2033 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0011
	L2 Cache Handle: 0x0012
	L3 Cache Handle: 0x0013
	Serial Number: Not Specified
	Asset Tag: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Part Number: Not Specified

Handle 0x0010, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Other
	Associativity: 16-way Set-associative

Handle 0x0011, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unknown
	Associativity: 16-way Set-associative

Handle 0x0012, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 16-way Set-associative

Handle 0x0013, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 6 kB
	Maximum Size: 6 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 48-way Set-associative

Handle 0x0014, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: Other
	Manufacturer: Intel(R) Corporation
	ID: A7 06 02 00 FF FB EB BF
	Version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Voltage: 0.0 V
	External Clock: Unknown
	Max Speed: 2000 MHz
	Current Speed: 2031 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0016
	L2 Cache Handle: 0x0017
	L3 Cache Handle: 0x0018
	Serial Number: Not Specified
	Asset Tag: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Part Number: Not Specified

Handle 0x0015, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Other
	Associativity: 16-way Set-associative

Handle 0x0016, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unknown
	Associativity: 16-way Set-associative

Handle 0x0017, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 16-way Set-associative

Handle 0x0018, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 6 kB
	Maximum Size: 6 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 48-way Set-associative

Handle 0x0019, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: Other
	Manufacturer: Intel(R) Corporation
	ID: A7 06 02 00 FF FB EB BF
	Version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Voltage: 0.0 V
	External Clock: Unknown
	Max Speed: 2000 MHz
	Current Speed: 40624 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x001B
	L2 Cache Handle: 0x001C
	L3 Cache Handle: 0x001D
	Serial Number: Not Specified
	Asset Tag: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Part Number: Not Specified

Handle 0x001A, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Other
	Associativity: 16-way Set-associative

Handle 0x001B, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unknown
	Associativity: 16-way Set-associative

Handle 0x001C, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 16-way Set-associative

Handle 0x001D, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 6 kB
	Maximum Size: 6 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 48-way Set-associative

Handle 0x001E, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: Other
	Manufacturer: Intel(R) Corporation
	ID: A7 06 02 00 FF FB EB BF
	Version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Voltage: 0.0 V
	External Clock: Unknown
	Max Speed: 2000 MHz
	Current Speed: 2041 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0020
	L2 Cache Handle: 0x0021
	L3 Cache Handle: 0x0022
	Serial Number: Not Specified
	Asset Tag: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Part Number: Not Specified

Handle 0x001F, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Other
	Associativity: 16-way Set-associative

Handle 0x0020, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unknown
	Associativity: 16-way Set-associative

Handle 0x0021, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 16-way Set-associative

Handle 0x0022, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 6 kB
	Maximum Size: 6 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 48-way Set-associative

Handle 0x0023, DMI type 4, 35 bytes
Processor Information
	Socket Designation: U2E1
	Type: Central Processor
	Family: Other
	Manufacturer: Intel(R) Corporation
	ID: A7 06 02 00 FF FB EB BF
	Version: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Voltage: 0.0 V
	External Clock: Unknown
	Max Speed: 2000 MHz
	Current Speed: 2022 MHz
	Status: Populated, Enabled
	Upgrade: ZIF Socket
	L1 Cache Handle: 0x0025
	L2 Cache Handle: 0x0026
	L3 Cache Handle: 0x0027
	Serial Number: Not Specified
	Asset Tag: Intel(R) Core(TM) i7-2635QM CPU @ 2.00GHz
	Part Number: Not Specified

Handle 0x0024, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Other
	Associativity: 16-way Set-associative

Handle 0x0025, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 32 kB
	Maximum Size: 32 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unknown
	Associativity: 16-way Set-associative

Handle 0x0026, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 16-way Set-associative

Handle 0x0027, DMI type 7, 19 bytes
Cache Information
	Socket Designation: Unknown
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 6 kB
	Maximum Size: 6 kB
	Supported SRAM Types:
		Asynchronous
	Installed SRAM Type: Asynchronous
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Instruction
	Associativity: 48-way Set-associative

Handle 0x0028, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 8 GB
	Error Information Handle: Not Provided
	Number Of Devices: 2

Handle 0x0029, DMI type 130, 186 bytes
OEM-specific Type
	Header and Data:
		82 BA 29 00 2A 00 00 00 B0 00 92 10 0B 03 03 19
		00 09 03 52 01 08 0C 00 3C 00 69 78 69 30 69 11
		20 89 00 05 3C 3C 00 F0 83 05 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 0F 11 05 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01
		98 04 11 03 6D 22 E4 9C 3E C7 39 39 30 35 34 32
		38 2D 30 31 32 2E 41 30 30 4C 46 20 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00

Handle 0x002A, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0028
	Error Information Handle: No Error
	Total Width: Unknown
	Data Width: Unknown
	Size: 4096 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM0
	Bank Locator: BANK 0
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1333 MHz
	Manufacturer: 0x0198
	Serial Number: 0x6D22E49C
	Asset Tag: Unknown
	Part Number: 0x393930353432382D3031322E4130304C4620

Handle 0x002B, DMI type 130, 186 bytes
OEM-specific Type
	Header and Data:
		82 BA 2B 00 2C 00 00 00 B0 00 92 10 0B 03 03 19
		00 09 03 52 01 08 0C 00 3C 00 69 78 69 30 69 11
		20 89 00 05 3C 3C 00 F0 83 05 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 0F 11 05 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01
		98 04 11 02 65 1F 7A 5B 3E C7 39 39 30 35 34 32
		38 2D 30 31 32 2E 41 30 30 4C 46 20 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00

Handle 0x002C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0028
	Error Information Handle: No Error
	Total Width: Unknown
	Data Width: Unknown
	Size: 4096 MB
	Form Factor: SODIMM
	Set: None
	Locator: DIMM0
	Bank Locator: BANK 1
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1333 MHz
	Manufacturer: 0x0198
	Serial Number: 0x651F7A5B
	Asset Tag: Unknown
	Part Number: 0x393930353432382D3031322E4130304C4620

Handle 0x002D, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 8 GB
	Physical Array Handle: 0x0028
	Partition Width: 0

Handle 0x002E, DMI type 0, 24 bytes
BIOS Information
	Vendor: Apple Inc.
	Version:    MBP81.88Z.0047.B27.1201241646
	Release Date: 01/24/12
	ROM Size: 8192 kB
	Characteristics:
		PCI is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		ACPI is supported
		IEEE 1394 boot is supported
		Smart battery is supported
		Function key-initiated network boot is supported
	BIOS Revision: 0.1

Handle 0x002F, DMI type 1, 27 bytes
System Information
	Manufacturer: Apple Inc.
	Product Name: MacBookPro8,2
	Version: 1.0
	Serial Number: C02FK23WDF8Y
	UUID: A712F2DF-2839-805E-AEB8-1E1682E1322F
	Wake-up Type: Power Switch
	SKU Number: System SKU#
	Family: MacBook Pro

Handle 0x0030, DMI type 2, 16 bytes
Base Board Information
	Manufacturer: Apple Inc.
	Product Name: Mac-94245A3940C91C80
	Version: MacBookPro8,2
	Serial Number: C02115500D8DMNVA2
	Asset Tag: Base Board Asset Tag#
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: Part Component
	Chassis Handle: 0x0031
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0031, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: Apple Inc.
	Type: Notebook
	Lock: Not Present
	Version: Mac-94245A3940C91C80
	Serial Number: C02FK23WDF8Y
	Asset Tag: Not Specified
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Other
	Security Status: Other
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: Unspecified
	Contained Elements: 0

Handle 0x0032, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: FireWire 800
	External Connector Type: IEEE 1394
	Port Type: Firewire (IEEE P1394)

Handle 0x0033, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: Ethernet
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0034, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: USB0
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0035, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: USB1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0036, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: USB2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0037, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: SD Card Reader
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0038, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: Other
	External Reference Designator: Mini DisplayPort
	External Connector Type: None
	Port Type: Other

Handle 0x0039, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: Other
	External Reference Designator: Microphone
	External Connector Type: None
	Port Type: Other

Handle 0x003A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: Other
	External Reference Designator: Speaker
	External Connector Type: None
	Port Type: Other

Handle 0x003B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: Audio Line In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x003C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: Audio Line Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x003D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: MagSafe DC Power
	External Connector Type: Other
	Port Type: Other

Handle 0x003E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA Port A
	Internal Connector Type: On Board IDE
	External Reference Designator: None
	External Connector Type: None
	Port Type: Other

Handle 0x003F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA Port B
	Internal Connector Type: On Board IDE
	External Reference Designator: None
	External Connector Type: None
	Port Type: Other

Handle 0x0040, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: PCI-Express Mini Card
	External Connector Type: Other
	Port Type: Other

Handle 0x0041, DMI type 9, 13 bytes
System Slot Information
	Designation: AirPort
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	ID: 0
	Characteristics:
		3.3 V is provided
		Hot-plug devices are supported
		SMBus signal is supported

Handle 0x0042, DMI type 9, 13 bytes
System Slot Information
	Designation: ExpressCard
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	ID: 1
	Characteristics:
		3.3 V is provided
		Hot-plug devices are supported
		SMBus signal is supported

Handle 0x0043, DMI type 9, 13 bytes
System Slot Information
	Designation: Thunderbolt Slot 1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 2
	Characteristics:
		3.3 V is provided
		PME signal is supported
		Hot-plug devices are supported
		SMBus signal is supported

Handle 0x0044, DMI type 9, 13 bytes
System Slot Information
	Designation: Thunderbolt Slot 2
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 3
	Characteristics:
		3.3 V is provided
		PME signal is supported
		Hot-plug devices are supported
		SMBus signal is supported

Handle 0x0045, DMI type 9, 13 bytes
System Slot Information
	Designation: Thunderbolt Slot 3
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 4
	Characteristics:
		3.3 V is provided
		PME signal is supported
		Hot-plug devices are supported
		SMBus signal is supported

Handle 0x0046, DMI type 9, 13 bytes
System Slot Information
	Designation: Thunderbolt Slot 4
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 5
	Characteristics:
		3.3 V is provided
		PME signal is supported
		Hot-plug devices are supported
		SMBus signal is supported

Handle 0x0047, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description: nVidia Video Adapter

Handle 0x0048, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Enabled
	Description: Azalia Audio Codec

Handle 0x0049, DMI type 10, 6 bytes
On Board Device Information
	Type: Ethernet
	Status: Enabled
	Description: Broadcom Ethernet Controller

Handle 0x004A, DMI type 10, 6 bytes
On Board Device Information
	Type: Other
	Status: Enabled
	Description: SATA

Handle 0x004B, DMI type 12, 5 bytes
System Configuration Options

Handle 0x004C, DMI type 13, 22 bytes
BIOS Language Information
	Language Description Format: Long
	Installable Languages: 1
		<BAD INDEX>
	Currently Installed Language: Not Specified

Handle 0x004D, DMI type 22, 32 bytes
Portable Battery
	Location: Unknown
	Manufacturer: Unknown
	Manufacture Date: Unknown
	Serial Number: Unknown
	Name: Unknown
	Design Capacity: Unknown
	Design Voltage: Unknown
	SBDS Version: Unknown
	Maximum Error: Unknown
	SBDS Chemistry: Unknown
	OEM-specific Information: 0x00000000

Handle 0x004E, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x004F, DMI type 131, 6 bytes
OEM-specific Type
	Header and Data:
		83 06 4F 00 03 07

Handle 0x0050, DMI type 128, 88 bytes
OEM-specific Type
	Header and Data:
		80 58 50 00 04 00 00 00 37 F5 01 C0 37 FF 03 C0
		02 00 00 03 00 00 00 00 00 10 98 FF FF FF C8 FF
		00 00 C9 FF FF 7F CB FF 00 80 CB FF FF 1F E8 FF
		00 80 ED FF FF FF EF FF 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00

Handle 0xFFFD, DMI type 127, 4 bytes
End Of Table


--MGYHOYXEY6WxJCY8--

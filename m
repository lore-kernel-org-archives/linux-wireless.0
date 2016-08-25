Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933904AbcHYPI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 11:08:29 -0400
Date: Thu, 25 Aug 2016 17:06:27 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems with mwifiex_pcie firmware activation
Message-ID: <20160825150626.GA9256@redhat.com> (sfid-20160825_170843_637326_A7897E9F)
References: <20160614135015.GB4962@redhat.com>
 <b881b09bf5384169ba1038af71fd435a@SC-EXCH04.marvell.com>
 <20160616115315.GB21199@redhat.com>
 <20160623120952.GA11157@redhat.com>
 <20160811090113.GA27059@redhat.com>
 <f5b2566be31743809217833e76060d42@SC-EXCH04.marvell.com>
 <20160811122917.GB27059@redhat.com>
 <fc70c75bfcab4e0e932274034b5b4493@SC-EXCH04.marvell.com>
 <20160812081342.GA15538@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
In-Reply-To: <20160812081342.GA15538@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 12, 2016 at 10:13:43AM +0200, Stanislaw Gruszka wrote:
> On Fri, Aug 12, 2016 at 07:17:38AM +0000, Amitkumar Karwar wrote:
> > The problem looks strange. The patch just splits mwifiex_check_fw_status() and increases poll count. It should not have any side-effects.
> > Our code used to check winner status before this patch also.
> 
> Ok, I misread the patch. Anyway checking "winner status" seems
> does not work well on some condition and prevent loading firmware
> into device.

I debug this a bit more on latest wireless-testing-next tree + 3 patches
I just posted and debug_mask=0x700000ff.

On broken system, we do not download FW to device when system is
rebooted, due to PCI-E is not the winner. However if system is
powered OFF and then powered ON, we do FW downloading. Hence
download the new FW into device does not make it work as was
my theory.

In attachments are full dmesgs of good/bad and reboot/power-off-on
cases.

The difference is that on broken system FW (or HW) do not create
new USB Bluetooth device (1286:2046) and do not report
FIRMWARE_READY_PCIE. Additionally on reboot case there are errors
from USB xhci.

GOOD system after reboot:

[   11.899924] mwifiex_pcie: try set_consistent_dma_mask(32)
[   11.937024] mwifiex_pcie: PCI memory map Virt0: ffffc90001000000 PCI memory map Virt2: ffffc90001400000
[   11.948256] mwifiex: rx work enabled, cpus 2
[   11.954821] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[   11.977205] mwifiex_pcie 0000:03:00.0: msi_enable = 1
[   12.001881] mwifiex_pcie 0000:03:00.0: Setting driver ready signature
[   12.008456] mwifiex_pcie 0000:03:00.0: Try 0 if FW is ready <0,0x0>
[   12.051216] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   12.069136] Adding 6254588k swap on /dev/mapper/rhel_iot--r5s3--01-swap.  Priority:-1 extents:1 across:6254588k SSFS
[   12.081133] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   12.111533] mwifiex_pcie 0000:03:00.0: PCI-E is the winner
[   12.111537] mwifiex_pcie 0000:03:00.0: info: Downloading FW image (803884 bytes)
[   13.347194] mwifiex_pcie 0000:03:00.0: info: FW download over, size 803884 bytes
[   13.347200] mwifiex_pcie 0000:03:00.0: Setting driver ready signature
[   13.347205] mwifiex_pcie 0000:03:00.0: Try 0 if FW is ready <0,0x6>
[   13.397597] intel_rapl: Found RAPL domain package
[   13.397600] intel_rapl: Found RAPL domain core
[   13.456221] mwifiex_pcie 0000:03:00.0: Try 1 if FW is ready <0,0x6>
[   13.560263] mwifiex_pcie 0000:03:00.0: Try 2 if FW is ready <0,0x6>
[   13.607377] usb 1-4.2: USB disconnect, device number 3
[   13.664199] mwifiex_pcie 0000:03:00.0: Try 3 if FW is ready <0,0x6>
[   13.768563] mwifiex_pcie 0000:03:00.0: Try 4 if FW is ready <0,0x6>
[   13.795585] usb 1-4.2: new high-speed USB device number 4 using xhci_hcd
[   13.872962] mwifiex_pcie 0000:03:00.0: Try 5 if FW is ready <0,0x6>
[   13.892350] usb 1-4.2: New USB device found, idVendor=1286, idProduct=2046
[   13.900302] usb 1-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   13.900304] usb 1-4.2: Product: Bluetooth and Wireless LAN Composite Device
[   13.900307] usb 1-4.2: Manufacturer: Marvell
[   13.900309] usb 1-4.2: SerialNumber: 0000000000000000
[   13.908594] XFS (dm-2): Mounting V5 Filesystem
[   13.944449] XFS (dm-2): Ending clean mount
[   13.984292] mwifiex_pcie 0000:03:00.0: Try 6 if FW is ready <0,0x6>
[   14.121836] mwifiex_pcie 0000:03:00.0: Try 7 if FW is ready <0,0xfedcba00>
[   14.128771] mwifiex_pcie 0000:03:00.0: WLAN FW is active

BAD system after reboot:

[   14.588111] mwifiex_pcie: try set_consistent_dma_mask(32)
[   14.588155] mwifiex_pcie: PCI memory map Virt0: ffffc90000800000 PCI memory map Virt2: ffffc90000a00000
[   14.588227] mwifiex: rx work enabled, cpus 2
[   14.591260] mwifiex_pcie 0000:02:00.0: msi_enable = 1
[   14.602408] mwifiex_pcie 0000:02:00.0: Setting driver ready signature
[   14.602416] mwifiex_pcie 0000:02:00.0: Try 0 if FW is ready <0,0x6>
[   14.707156] mwifiex_pcie 0000:02:00.0: PCI-E is not the winner <0x6>
[   14.707164] mwifiex_pcie 0000:02:00.0: WLAN is not the winner! Skip FW dnld
[   14.707171] mwifiex_pcie 0000:02:00.0: Setting driver ready signature
[   14.707186] mwifiex_pcie 0000:02:00.0: Try 0 if FW is ready <0,0x6>
[   14.810726] mwifiex_pcie 0000:02:00.0: Try 1 if FW is ready <0,0x6>
<snip>
[   25.550002] mwifiex_pcie 0000:02:00.0: Try 97 if FW is ready <0,0x6>
[   25.662032] mwifiex_pcie 0000:02:00.0: Try 98 if FW is ready <0,0x6>
[   25.667083] usb 1-4.2: device descriptor read/64, error -110
[   25.782069] mwifiex_pcie 0000:02:00.0: Try 99 if FW is ready <0,0x6>
[   25.850076] usb 1-4.2: new high-speed USB device number 4 using xhci_hcd
[   25.894091] mwifiex_pcie 0000:02:00.0: Try 100 if FW is ready <0,0x6>
[   26.006123] mwifiex_pcie 0000:02:00.0: Try 101 if FW is ready <0,0x6>
<snip>
[   31.167060] mwifiex_pcie 0000:02:00.0: Try 147 if FW is ready <0,0x6>
[   31.279149] mwifiex_pcie 0000:02:00.0: Try 148 if FW is ready <0,0x6>
[   31.299139] usb 1-4.2: device descriptor read/64, error -110
[   31.391128] mwifiex_pcie 0000:02:00.0: Try 149 if FW is ready <0,0x6>
[   31.503180] mwifiex_pcie 0000:02:00.0: FW failed to be active in time
[   31.509766] mwifiex_pcie 0000:02:00.0: info: mwifiex_fw_dpc: unregister device
[   31.517118] mwifiex_pcie 0000:02:00.0: mwifiex_unregister_dev(): calling free_irq()
[   34.555397] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   34.721265] Ebtables v2.0 registered
[   35.180409] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   35.258839] tun: Universal TUN/TAP device driver, 1.6
[   35.263968] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   35.317893] virbr0: port 1(virbr0-nic) entered blocking state
[   35.323733] virbr0: port 1(virbr0-nic) entered disabled state
[   35.330484] device virbr0-nic entered promiscuous mode
[   35.731136] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   36.274961] virbr0: port 1(virbr0-nic) entered blocking state
[   36.280795] virbr0: port 1(virbr0-nic) entered listening state
[   36.425084] virbr0: port 1(virbr0-nic) entered disabled state
[   36.467694] device virbr0-nic left promiscuous mode
[   36.472708] virbr0: port 1(virbr0-nic) entered disabled state
[   47.550858] usb 1-4.2: device descriptor read/64, error -110
[   47.734888] usb 1-4.2: new high-speed USB device number 5 using xhci_hcd
[   53.108292] xhci_hcd 0000:00:14.0: Command completion event does not match command
[   53.116708] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   58.741871] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   58.957883] usb 1-4.2: device not accepting address 5, error -62
[   59.039904] usb 1-4.2: new high-speed USB device number 6 using xhci_hcd
[   64.375277] xhci_hcd 0000:00:14.0: Command completion event does not match command
[   64.383018] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   70.008837] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   70.224865] usb 1-4.2: device not accepting address 6, error -62
[   70.231111] usb 1-4-port2: unable to enumerate USB device

On both systems mwifiex seems to be the same device, but the systems
itself are not identical. This could be a BIOS or motherboard issue.
However mwifiex didn't work on good system as well before and start
to work somehow, I'm not sure how this happened.

Thanks
Stanislaw

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-bad-power-off-on.txt"

[    0.000000] Linux version 4.8.0-rc2+ (root@iot-r5s2-01.wlan.rhts.eng.bos.redhat.com) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-9) (GCC) ) #3 SMP Thu Aug 25 05:50:38 EDT 2016
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.8.0-rc2+ root=/dev/mapper/rhel_iot--r5s2--01-root ro crashkernel=auto rd.lvm.lv=rhel_iot-r5s2-01/root rd.lvm.lv=rhel_iot-r5s2-01/swap console=ttyS3,115200n81 LANG=en_US.UTF-8
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001effffff] usable
[    0.000000] BIOS-e820: [mem 0x000000001f000000-0x000000001f0fffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000001f100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000200fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020100000-0x0000000076e4efff] usable
[    0.000000] BIOS-e820: [mem 0x0000000076e4f000-0x0000000076e7efff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000076e7f000-0x0000000076ea4fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000076ea5000-0x000000007742efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007742f000-0x000000007772bfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007772c000-0x000000007772cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007772d000-0x000000007776efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007776f000-0x00000000789e4fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000789e5000-0x0000000078ff9fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000078ffa000-0x0000000078ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed03000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed0c000-0x00000000fed0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff900000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: Dell Inc. Edge Gateway 5000/0N13CD, BIOS 01.02.00 01/28/2016
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x79000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 079000000 mask FFF000000 uncachable
[    0.000000]   2 base 07A000000 mask FFE000000 uncachable
[    0.000000]   3 base 07C000000 mask FFC000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] total RAM covered: 1936M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 0G
[    0.000000] found SMP MP-table at [mem 0x000fd800-0x000fd80f] mapped at [ffff8800000fd800]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] BRK [0x02293000, 0x02293fff] PGTABLE
[    0.000000] BRK [0x02294000, 0x02294fff] PGTABLE
[    0.000000] BRK [0x02295000, 0x02295fff] PGTABLE
[    0.000000] BRK [0x02296000, 0x02296fff] PGTABLE
[    0.000000] BRK [0x02297000, 0x02297fff] PGTABLE
[    0.000000] BRK [0x02298000, 0x02298fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x3095d000-0x344a6fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0580 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x0000000076E97088 00008C (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x0000000076EA3CA8 00010C (v05 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 128/32 (20160422/tbfadt-624)
[    0.000000] ACPI: DSDT 0x0000000076E971A0 00CB03 (v02 DELL   AS09     01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x000000007742EE80 000040
[    0.000000] ACPI: APIC 0x0000000076EA3DB8 000068 (v03 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x0000000076EA3E20 000044 (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x0000000076EA3E68 00009C (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x0000000076EA3F08 00003C (v01 DELL   AS09     01072009 MSFT 00000097)
[    0.000000] ACPI: LPIT 0x0000000076EA3F48 000104 (v01 DELL   AS09     00000003 VLV2 0100000D)
[    0.000000] ACPI: HPET 0x0000000076EA4050 000038 (v01 DELL   AS09     01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x0000000076EA4088 000763 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076EA47F0 000290 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076EA4A80 00017A (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 0x0000000076EA4C00 000042 (v01 DELL   AS09     00000000      00000000)
[    0.000000] ACPI: SLIC 0x0000000076EA4C48 000176 (v03 DELL   AS09     01072009 MSFT 00010013)
[    0.000000] ACPI: CSRT 0x0000000076EA4DC0 00014C (v00 DELL   AS09     00000005 INTL 20120624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000078ffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x789c2000-0x789e3fff]
[    0.000000] kexec_core: crashkernel: memory value expected
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x0000000078ffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009bfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001effffff]
[    0.000000]   node   0: [mem 0x000000001f100000-0x000000001fffffff]
[    0.000000]   node   0: [mem 0x0000000020100000-0x0000000076e4efff]
[    0.000000]   node   0: [mem 0x000000007772c000-0x000000007772cfff]
[    0.000000]   node   0: [mem 0x000000007776f000-0x00000000789e4fff]
[    0.000000]   node   0: [mem 0x0000000078ffa000-0x0000000078ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x0000000078ffffff]
[    0.000000] On node 0 totalpages: 491111
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7680 pages used for memmap
[    0.000000]   DMA32 zone: 487116 pages, LIFO batch:31
[    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
[    0.000000] Reserving Intel graphics memory at 0x000000007b000000-0x000000007effffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-86
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x1f000000-0x1f0fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x200fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e4f000-0x76e7efff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e7f000-0x76ea4fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76ea5000-0x7742efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7742f000-0x7772bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7772d000-0x7776efff]
[    0.000000] PM: Registered nosave memory: [mem 0x789e5000-0x78ff9fff]
[    0.000000] e820: [mem 0x7f000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 36 pages/cpu @ffff880078400000 s107672 r8192 d31592 u1048576
[    0.000000] pcpu-alloc: s107672 r8192 d31592 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 483346
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.8.0-rc2+ root=/dev/mapper/rhel_iot--r5s2--01-root ro crashkernel=auto rd.lvm.lv=rhel_iot-r5s2-01/root rd.lvm.lv=rhel_iot-r5s2-01/swap console=ttyS3,115200n81 LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 1851144K/1964444K available (7131K kernel code, 1541K rwdata, 3196K rodata, 1868K init, 3280K bss, 113300K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-1.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS3] enabled
[    0.000000] tsc: Detected 1333.000 MHz processor
[    0.000044] Calibrating delay loop (skipped), value calculated using timer frequency.. 2666.00 BogoMIPS (lpj=1333000)
[    0.000496] pid_max: default: 32768 minimum: 301
[    0.000715] ACPI: Core revision 20160422
[    0.038865] ACPI: 4 ACPI AML tables successfully acquired and loaded

[    0.039281] Security Framework initialized
[    0.039461] SELinux:  Initializing.
[    0.039627] SELinux:  Starting in permissive mode
[    0.040075] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.041826] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.042767] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.043092] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.044032] CPU: Physical Processor ID: 0
[    0.044211] CPU: Processor Core ID: 0
[    0.044375] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.044629] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.044953] mce: CPU supports 6 MCE banks
[    0.045137] CPU0: Thermal monitoring enabled (TM1)
[    0.045348] process: using mwait in idle threads
[    0.045550] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.045793] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.046617] Freeing SMP alternatives memory: 28K (ffffffff81f56000 - ffffffff81f5d000)
[    0.050675] ftrace: allocating 28065 entries in 110 pages
[    0.074218] smpboot: Max logical packages: 1
[    0.074408] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.075414] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.085685] TSC deadline timer enabled
[    0.085690] smpboot: CPU0: Intel(R) Atom(TM) CPU  E3825  @ 1.33GHz (family: 0x6, model: 0x37, stepping: 0x9)
[    0.086129] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, 8-deep LBR, full-width counters, Intel PMU driver.
[    0.086676] ... version:                3
[    0.086858] ... bit width:              40
[    0.087035] ... generic registers:      2
[    0.087207] ... value mask:             000000ffffffffff
[    0.087432] ... max period:             000000ffffffffff
[    0.087656] ... fixed-purpose events:   3
[    0.087828] ... event mask:             0000000700000003
[    0.089927] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.090782] x86: Booting SMP configuration:
[    0.090967] .... node  #0, CPUs:      #1
[    0.152697] x86: Booted up 1 node, 2 CPUs
[    0.152888] smpboot: Total of 2 processors activated (5339.90 BogoMIPS)
[    0.154327] devtmpfs: initialized
[    0.154664] x86/mm: Memory block size: 128MB
[    0.164757] evm: security.selinux
[    0.164905] evm: security.ima
[    0.165035] evm: security.capability
[    0.165382] PM: Registering ACPI NVS region [mem 0x76ea5000-0x7742efff] (5808128 bytes)
[    0.166123] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.166627] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.166937] pinctrl core: initialized pinctrl subsystem
[    0.167517] NET: Registered protocol family 16
[    0.169988] cpuidle: using governor menu
[    0.170289] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.170609] ACPI: bus type PCI registered
[    0.170782] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.171199] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.171590] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.171914] PCI: Using configuration type 1 for base access
[    0.172174] dmi type 0xB1 record - unknown flag
[    0.177614] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.178540] ACPI: Added _OSI(Module Device)
[    0.178724] ACPI: Added _OSI(Processor Device)
[    0.178915] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.179116] ACPI: Added _OSI(Processor Aggregator Device)
[    0.196687] ACPI: Dynamic OEM Table Load:
[    0.196892] ACPI: SSDT 0xFFFF880077AD8800 0002B4 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.199130] ACPI: Dynamic OEM Table Load:
[    0.199330] ACPI: SSDT 0xFFFF880077A5A000 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.202257] ACPI: Dynamic OEM Table Load:
[    0.202456] ACPI: SSDT 0xFFFF880077A71800 00015F (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.204625] ACPI: Dynamic OEM Table Load:
[    0.204822] ACPI: SSDT 0xFFFF880077ACA0C0 00008D (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.209773] ACPI: Interpreter enabled
[    0.209997] ACPI: (supports S0 S4 S5)
[    0.210159] ACPI: Using IOAPIC for interrupt routing
[    0.210467] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.233195] ACPI: Power Resource [USBC] (on)
[    0.236125] ACPI: Power Resource [PLPE] (on)
[    0.236976] ACPI: Power Resource [PLPE] (on)
[    0.250608] ACPI: Power Resource [CLK0] (on)
[    0.250921] ACPI: Power Resource [CLK1] (on)
[    0.326269] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.326545] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.327356] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.328104] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.328386] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.330076] PCI host bridge to bus 0000:00
[    0.330259] pci_bus 0000:00: root bus resource [io  0x0070-0x0077]
[    0.330523] pci_bus 0000:00: root bus resource [io  0x0000-0x006f window]
[    0.330811] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7 window]
[    0.331108] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.331396] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.331711] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.332026] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff window]
[    0.332349] pci_bus 0000:00: root bus resource [mem 0x80000000-0x90915ffe window]
[    0.332666] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.332913] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.333293] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.333313] pci 0000:00:02.0: reg 0x10: [mem 0x90000000-0x903fffff]
[    0.333329] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x8fffffff pref]
[    0.333345] pci 0000:00:02.0: reg 0x20: [io  0xe080-0xe087]
[    0.333733] pci 0000:00:13.0: [8086:0f23] type 00 class 0x010601
[    0.333758] pci 0000:00:13.0: reg 0x10: [io  0xe070-0xe077]
[    0.333770] pci 0000:00:13.0: reg 0x14: [io  0xe060-0xe063]
[    0.333783] pci 0000:00:13.0: reg 0x18: [io  0xe050-0xe057]
[    0.333795] pci 0000:00:13.0: reg 0x1c: [io  0xe040-0xe043]
[    0.333807] pci 0000:00:13.0: reg 0x20: [io  0xe020-0xe03f]
[    0.333820] pci 0000:00:13.0: reg 0x24: [mem 0x90915000-0x909157ff]
[    0.333885] pci 0000:00:13.0: PME# supported from D3hot
[    0.334208] pci 0000:00:14.0: [8086:0f35] type 00 class 0x0c0330
[    0.334234] pci 0000:00:14.0: reg 0x10: [mem 0x90900000-0x9090ffff 64bit]
[    0.334318] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.334605] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.334965] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.334995] pci 0000:00:1a.0: reg 0x10: [mem 0x90500000-0x905fffff]
[    0.335012] pci 0000:00:1a.0: reg 0x14: [mem 0x90400000-0x904fffff]
[    0.335139] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.335541] pci 0000:00:1b.0: [8086:0f04] type 00 class 0x040300
[    0.335571] pci 0000:00:1b.0: reg 0x10: [mem 0x90910000-0x90913fff 64bit]
[    0.335667] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.335997] pci 0000:00:1c.0: [8086:0f48] type 01 class 0x060400
[    0.336088] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.336318] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.336676] pci 0000:00:1c.2: [8086:0f4c] type 01 class 0x060400
[    0.336765] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.336998] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.337342] pci 0000:00:1c.3: [8086:0f4e] type 01 class 0x060400
[    0.337431] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.337671] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.338023] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.338427] pci 0000:00:1f.3: [8086:0f12] type 00 class 0x0c0500
[    0.338466] pci 0000:00:1f.3: reg 0x10: [mem 0x90914000-0x9091401f]
[    0.338546] pci 0000:00:1f.3: reg 0x20: [io  0xe000-0xe01f]
[    0.339097] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    0.339124] pci 0000:01:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.339159] pci 0000:01:00.0: reg 0x18: [mem 0x90804000-0x90804fff 64bit]
[    0.339182] pci 0000:01:00.0: reg 0x20: [mem 0x90800000-0x90803fff 64bit pref]
[    0.339296] pci 0000:01:00.0: supports D1 D2
[    0.339299] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.339379] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.342679] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.342897] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.342904] pci 0000:00:1c.0:   bridge window [mem 0x90800000-0x908fffff]
[    0.343067] pci 0000:02:00.0: [11ab:2b38] type 00 class 0x020000
[    0.343105] pci 0000:02:00.0: reg 0x10: [mem 0x90700000-0x907fffff 64bit pref]
[    0.343130] pci 0000:02:00.0: reg 0x18: [mem 0x90600000-0x906fffff 64bit pref]
[    0.343290] pci 0000:02:00.0: supports D1 D2
[    0.343294] pci 0000:02:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.343386] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.346709] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.346930] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.347049] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.350758] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 12 14 15)
[    0.351296] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 12 14 15) *0, disabled.
[    0.351901] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 12 14 15)
[    0.352432] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 12 14 15)
[    0.352975] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 5 6 12 14 15)
[    0.353506] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 12 14 15)
[    0.354050] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 12 14 15)
[    0.354579] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 12 14 15) *0, disabled.
[    0.361650] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.362206] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.362451] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.362794] vgaarb: loaded
[    0.362929] vgaarb: bridge control possible 0000:00:02.0
[    0.363412] SCSI subsystem initialized
[    0.363651] ACPI: bus type USB registered
[    0.363875] usbcore: registered new interface driver usbfs
[    0.364154] usbcore: registered new interface driver hub
[    0.364425] usbcore: registered new device driver usb
[    0.364863] PCI: Using ACPI for IRQ routing
[    0.372482] PCI: pci_cache_line_size set to 64 bytes
[    0.372569] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.372573] e820: reserve RAM buffer [mem 0x1f000000-0x1fffffff]
[    0.372576] e820: reserve RAM buffer [mem 0x76e4f000-0x77ffffff]
[    0.372578] e820: reserve RAM buffer [mem 0x7772d000-0x77ffffff]
[    0.372581] e820: reserve RAM buffer [mem 0x789e5000-0x7bffffff]
[    0.372584] e820: reserve RAM buffer [mem 0x79000000-0x7bffffff]
[    0.372866] NetLabel: Initializing
[    0.373017] NetLabel:  domain hash size = 128
[    0.373213] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.373457] NetLabel:  unlabeled traffic allowed by default
[    0.373938] clocksource: Switched to clocksource refined-jiffies
[    0.396187] VFS: Disk quotas dquot_6.6.0
[    0.396403] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.396935] pnp: PnP ACPI init
[    0.397210] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.397567] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.397842] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.398096] system 00:01: [io  0x0500-0x05fe] has been reserved
[    0.398349] system 00:01: [io  0x0600-0x061f] has been reserved
[    0.398606] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.399163] system 00:02: [io  0x0a00-0x0a0f] has been reserved
[    0.399418] system 00:02: [io  0x0a10-0x0a1f] has been reserved
[    0.399671] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    0.399939] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.400685] ACPI: IRQ 10 override to edge, high
[    0.400892] pnp 00:03: [dma 0 disabled]
[    0.400998] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.401677] ACPI: IRQ 11 override to edge, high
[    0.401881] pnp 00:04: [dma 0 disabled]
[    0.401977] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.402643] ACPI: IRQ 10 override to edge, high
[    0.402846] pnp 00:05: [dma 0 disabled]
[    0.402929] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.404331] ACPI: IRQ 7 override to edge, high
[    0.404531] pnp 00:06: [dma 0 disabled]
[    0.404622] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.405486] system 00:07: [mem 0xe0000000-0xefffffff] could not be reserved
[    0.405784] system 00:07: [mem 0xfed01000-0xfed01fff] has been reserved
[    0.406079] system 00:07: [mem 0xfed03000-0xfed03fff] has been reserved
[    0.406361] system 00:07: [mem 0xfed04000-0xfed04fff] has been reserved
[    0.406642] system 00:07: [mem 0xfed0c000-0xfed0ffff] could not be reserved
[    0.406937] system 00:07: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.407226] system 00:07: [mem 0xfed1c000-0xfed1cfff] has been reserved
[    0.407508] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.407803] system 00:07: [mem 0xfef00000-0xfeffffff] has been reserved
[    0.408090] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.411540] pnp: PnP ACPI: found 8 devices
[    0.421868] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.422270] clocksource: Switched to clocksource acpi_pm
[    0.422560] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000 add_align 100000
[    0.422575] pci 0000:00:1c.2: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.422581] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
[    0.422593] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.422598] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 add_align 100000
[    0.422603] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff] to [bus 03] add_size 200000 add_align 100000
[    0.422619] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422624] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422629] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422633] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422638] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x000fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.422643] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x002fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.422647] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422652] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422657] pci 0000:00:1c.2: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.422661] pci 0000:00:1c.2: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.422666] pci 0000:00:1c.3: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.422670] pci 0000:00:1c.3: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.422688] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.423012] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.423378] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.423701] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.424042] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.424349] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.424657] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.424980] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.425343] pci 0000:00:1c.2: BAR 13: assigned [io  0x1000-0x1fff]
[    0.425609] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
[    0.425878] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.426162] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.426491] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.426814] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.427159] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.427503] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.427850] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.428172] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.428533] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.428749] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.429013] pci 0000:00:1c.0:   bridge window [mem 0x90800000-0x908fffff]
[    0.429329] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.429544] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.429806] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.430099] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.430334] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.430605] pci_bus 0000:00: resource 4 [io  0x0070-0x0077]
[    0.430610] pci_bus 0000:00: resource 5 [io  0x0000-0x006f window]
[    0.430614] pci_bus 0000:00: resource 6 [io  0x0078-0x0cf7 window]
[    0.430617] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.430621] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.430625] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.430629] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000fffff window]
[    0.430633] pci_bus 0000:00: resource 11 [mem 0x80000000-0x90915ffe window]
[    0.430637] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.430641] pci_bus 0000:01: resource 1 [mem 0x90800000-0x908fffff]
[    0.430645] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.430649] pci_bus 0000:02: resource 1 [mem 0x90600000-0x907fffff]
[    0.430653] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.430731] NET: Registered protocol family 2
[    0.431446] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.431860] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.432252] TCP: Hash tables configured (established 16384 bind 16384)
[    0.432659] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.432945] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.433392] NET: Registered protocol family 1
[    0.433623] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.434526] PCI: CLS 64 bytes, default 64
[    0.434685] Unpacking initramfs...
[    2.951761] Freeing initrd memory: 60712K (ffff88003095d000 - ffff8800344a7000)
[    2.954704] futex hash table entries: 512 (order: 3, 32768 bytes)
[    2.955034] audit: initializing netlink subsys (disabled)
[    2.955296] audit: type=2000 audit(1472115770.938:1): initialized
[    2.956476] Initialise system trusted keyrings
[    2.956993] workingset: timestamp_bits=36 max_order=19 bucket_order=0
[    2.962777] zbud: loaded
[    2.963655] Key type big_key registered
[    2.963824] SELinux:  Registering netfilter hooks
[    3.133203] NET: Registered protocol family 38
[    3.133403] Key type asymmetric registered
[    3.133580] Asymmetric key parser 'x509' registered
[    3.133921] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 248)
[    3.134376] io scheduler noop registered
[    3.134554] io scheduler deadline registered (default)
[    3.134795] io scheduler cfq registered
[    3.136110] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.136365] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.136708] intel_idle: MWAIT substates: 0x3000020
[    3.136711] intel_idle: v0.4.1 model 0x37
[    3.136889] intel_idle: lapic_timer_reliable_states 0xffffffff
[    3.137162] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    3.137519] ACPI: Sleep Button [SLPB]
[    3.137804] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    3.138146] ACPI: Power Button [PWRF]
[    3.142179] GHES: HEST is not enabled!
[    3.142534] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.164396] 00:03: ttyS0 at I/O 0x3e0 (irq = 10, base_baud = 115200) is a 16550A
[    3.186360] 00:04: ttyS1 at I/O 0x2e0 (irq = 11, base_baud = 115200) is a 16550A
[    3.208289] 00:05: ttyS2 at I/O 0x3e8 (irq = 10, base_baud = 115200) is a 16550A
[    3.230216] 00:06: ttyS3 at I/O 0x2d0 (irq = 7, base_baud = 115200) is a 16550A
[    3.238397] hpet: number irqs doesn't agree with number of timers
[    3.244750] Non-volatile memory driver v1.3
[    3.249102] Linux agpgart interface v0.103
[    3.254362] rdac: device handler registered
[    3.259095] hp_sw: device handler registered
[    3.263429] emc: device handler registered
[    3.268229] alua: device handler registered
[    3.272594] libphy: Fixed MDIO Bus: probed
[    3.276882] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.283490] ehci-pci: EHCI PCI platform driver
[    3.288044] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.294299] ohci-pci: OHCI PCI platform driver
[    3.298821] uhci_hcd: USB Universal Host Controller Interface driver
[    3.305593] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.311049] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    3.319650] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    3.328181] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    3.328390] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.335254] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.342548] usb usb1: Product: xHCI Host Controller
[    3.347483] usb usb1: Manufacturer: Linux 4.8.0-rc2+ xhci-hcd
[    3.353291] usb usb1: SerialNumber: 0000:00:14.0
[    3.358347] hub 1-0:1.0: USB hub found
[    3.362176] hub 1-0:1.0: 6 ports detected
[    3.367552] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.372965] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    3.380877] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    3.387740] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.395036] usb usb2: Product: xHCI Host Controller
[    3.399979] usb usb2: Manufacturer: Linux 4.8.0-rc2+ xhci-hcd
[    3.405789] usb usb2: SerialNumber: 0000:00:14.0
[    3.410811] hub 2-0:1.0: USB hub found
[    3.414634] hub 2-0:1.0: 1 port detected
[    3.419084] usbcore: registered new interface driver usbserial
[    3.425007] usbcore: registered new interface driver usbserial_generic
[    3.431628] usbserial: USB Serial support registered for generic
[    3.437781] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.445708] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.450750] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.456340] mousedev: PS/2 mouse device common for all mice
[    3.463298] rtc_cmos 00:00: RTC can wake from S4
[    3.468528] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    3.474862] rtc_cmos 00:00: alarms up to one month, y3k, 242 bytes nvram
[    3.481673] intel_pstate: Intel P-state driver initializing
[    3.490238] hidraw: raw HID events driver (C) Jiri Kosina
[    3.496488] usbcore: registered new interface driver usbhid
[    3.502159] usbhid: USB HID core driver
[    3.506316] drop_monitor: Initializing network drop monitor service
[    3.513170] Initializing XFRM netlink socket
[    3.517968] NET: Registered protocol family 10
[    3.524310] NET: Registered protocol family 17
[    3.529429] microcode: sig=0x30679, pf=0x1, revision=0x905
[    3.535104] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.544591] registered taskstats version 1
[    3.548749] Loading compiled-in X.509 certificates
[    3.569871] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
[    3.581682] Loaded X.509 cert 'Build time autogenerated kernel key: 19a0efe7f96fd701eff7e953b5dbaab91a7ce442'
[    3.591847] zswap: loaded using pool lzo/zbud
[    3.650735] Key type trusted registered
[    3.666219] Key type encrypted registered
[    3.670312] ima: No TPM chip found, activating TPM-bypass!
[    3.675959] evm: HMAC attrs: 0x1
[    3.681440] rtc_cmos 00:00: setting system clock to 2016-08-25 09:02:51 UTC (1472115771)
[    3.694271] Freeing unused kernel memory: 1868K (ffffffff81d83000 - ffffffff81f56000)
[    3.702204] Write protecting the kernel read-only data: 12288k
[    3.709630] Freeing unused kernel memory: 1044K (ffff8800016fb000 - ffff880001800000)
[    3.724859] Freeing unused kernel memory: 900K (ffff880001b1f000 - ffff880001c00000)
[    3.733442] usb 1-4: new high-speed USB device number 2 using xhci_hcd
[    3.753989] random: systemd: uninitialized urandom read (16 bytes read)
[    3.761910] random: systemd: uninitialized urandom read (16 bytes read)
[    3.779511] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    3.798323] systemd[1]: Detected architecture x86-64.
[    3.803456] systemd[1]: Running in initial RAM disk.
[    3.822995] systemd[1]: Set hostname to <localhost.localdomain>.
[    3.862834] usb 1-4: New USB device found, idVendor=0424, idProduct=2514
[    3.869662] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.877833] hub 1-4:1.0: USB hub found
[    3.881698] hub 1-4:1.0: 4 ports detected
[    3.994289] random: systemd: uninitialized urandom read (16 bytes read)
[    4.001301] random: systemd: uninitialized urandom read (16 bytes read)
[    4.008251] random: systemd: uninitialized urandom read (16 bytes read)
[    4.015296] random: systemd: uninitialized urandom read (16 bytes read)
[    4.022021] tsc: Refined TSC clocksource calibration: 1333.333 MHz
[    4.028575] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x13381e82524, max_idle_ns: 440795248224 ns
[    4.041080] random: systemd: uninitialized urandom read (16 bytes read)
[    4.048406] random: systemd: uninitialized urandom read (16 bytes read)
[    4.055929] random: systemd: uninitialized urandom read (16 bytes read)
[    4.064806] random: systemd: uninitialized urandom read (16 bytes read)
[    4.091907] systemd[1]: Reached target Local File Systems.
[    4.097580] systemd[1]: Starting Local File Systems.
[    4.110830] systemd[1]: Reached target Timers.
[    4.115434] systemd[1]: Starting Timers.
[    4.126806] systemd[1]: Reached target Swap.
[    4.131508] systemd[1]: Starting Swap.
[    4.189341] usb 1-4.2: new high-speed USB device number 3 using xhci_hcd
[    4.299402] usb 1-4.2: New USB device found, idVendor=1286, idProduct=2045
[    4.307168] usb 1-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.315935] usb 1-4.2: Product: Marvell Wireless Device
[    4.315938] usb 1-4.2: Manufacturer: Marvell
[    4.315941] usb 1-4.2: SerialNumber: 0000000000000000
[    4.937066] device-mapper: uevent: version 1.0.3
[    4.941971] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
[    5.041179] clocksource: Switched to clocksource tsc
[    5.531510] sdhci: Secure Digital Host Controller Interface driver
[    5.537763] sdhci: Copyright(c) Pierre Ossman
[    5.654496] FUJITSU Extended Socket Network Device Driver - version 1.1 - Copyright (c) 2015 FUJITSU LIMITED
[    5.758569] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.764255] r8169 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM control
[    5.773499] r8169 0000:01:00.0 eth0: RTL8168f/8111f at 0xffffc900003de000, f4:8e:38:d0:7c:bd, XID 08100880 IRQ 262
[    5.783957] r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.977521] random: fast init done
[    5.983801] [drm] Initialized drm 1.1.0 20060810
[    6.000863] r8169 0000:01:00.0: invalid large VPD tag 7f at offset 0
[    6.014993] r8169 0000:01:00.0 p4p1: renamed from eth0
[    6.021017] libata version 3.00 loaded.
[    6.054139] ahci 0000:00:13.0: version 3.0
[    6.054519] ahci 0000:00:13.0: controller can't do DEVSLP, turning off
[    6.066205] ahci 0000:00:13.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    6.074421] ahci 0000:00:13.0: flags: 64bit ncq pm led clo pio slum part deso 
[    6.084340] scsi host0: ahci
[    6.088334] scsi host1: ahci
[    6.091722] ata1: SATA max UDMA/133 abar m2048@0x90915000 port 0x90915100 irq 263
[    6.099291] ata2: SATA max UDMA/133 abar m2048@0x90915000 port 0x90915180 irq 263
[    6.415160] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.424203] ata1.00: ATA-8: LITEON J8-L1032-11 M.2 2260 32GB, 0J51105, max UDMA/133
[    6.432010] ata1.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    6.439217] ata2: SATA link down (SStatus 0 SControl 300)
[    6.445348] ata1.00: configured for UDMA/133
[    6.450144] scsi 0:0:0:0: Direct-Access     ATA      LITEON J8-L1032- 105  PQ: 0 ANSI: 5
[    6.889507] [drm] Memory usable by graphics device = 2048M
[    6.895070] [drm] Replacing VGA console driver
[    6.900621] Console: switching to colour dummy device 80x25
[    6.906692] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    6.908656] sd 0:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    6.908890] sd 0:0:0:0: [sda] Write Protect is off
[    6.908916] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.908991] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.916154]  sda: sda1 sda2
[    6.917068] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.942521] [drm] Driver supports precise vblank timestamp query.
[    6.943225] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    6.965499] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    6.974198] acpi device:09: registered as cooling_device2
[    6.980140] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    7.808627] i915 0000:00:02.0: No connectors reported connected with modes
[    7.815620] [drm] Cannot find any crtc or sizes - going 1024x768
[    7.825684] fbcon: inteldrmfb (fb0) is primary device
[    7.858581] Console: switching to colour frame buffer device 128x48
[    7.887431] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    9.276040] SGI XFS with ACLs, security attributes, no debug enabled
[    9.297447] XFS (dm-0): Mounting V5 Filesystem
[    9.343122] XFS (dm-0): Starting recovery (logdev: internal)
[    9.391486] XFS (dm-0): Ending recovery (logdev: internal)
[   10.257864] systemd-journald[141]: Received SIGTERM from PID 1 (n/a).
[   10.336909] systemd: 24 output lines suppressed due to ratelimiting
[   10.417510] audit: type=1404 audit(1472115778.233:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[   10.493168] SELinux: 32768 avtab hash slots, 104669 rules.
[   10.545415] SELinux: 32768 avtab hash slots, 104669 rules.
[   10.660317] SELinux:  8 users, 14 roles, 4978 types, 301 bools, 1 sens, 1024 cats
[   10.660325] SELinux:  91 classes, 104669 rules
[   10.672262] SELinux:  Permission validate_trans in class security not defined in policy.
[   10.680467] SELinux:  Permission module_load in class system not defined in policy.
[   10.688462] SELinux:  Class binder not defined in policy.
[   10.693910] SELinux:  Class cap_userns not defined in policy.
[   10.699709] SELinux:  Class cap2_userns not defined in policy.
[   10.705594] SELinux: the above unknown classes and permissions will be allowed
[   10.712894] SELinux:  Completing initialization.
[   10.712896] SELinux:  Setting up existing superblocks.
[   10.734593] audit: type=1403 audit(1472115778.550:3): policy loaded auid=4294967295 ses=4294967295
[   10.756483] systemd[1]: Successfully loaded SELinux policy in 337.821ms.
[   10.806471] systemd[1]: RTC configured in localtime, applying delta of -240 minutes to system time.
[   10.860041] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.865931] systemd[1]: Inserted module 'ip_tables'
[   11.001235] systemd[1]: Relabelled /dev and /run in 121.641ms.
[   11.826529] RPC: Registered named UNIX socket transport module.
[   11.832964] RPC: Registered udp transport module.
[   11.832966] RPC: Registered tcp transport module.
[   11.832967] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   12.120177] systemd-journald[531]: Received request to flush runtime journal from PID 1
[   12.375538] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   12.916297] Bluetooth: Core ver 2.21
[   12.921907] NET: Registered protocol family 31
[   12.926421] Bluetooth: HCI device and connection manager initialized
[   12.934219] Bluetooth: HCI socket layer initialized
[   12.940506] Bluetooth: L2CAP socket layer initialized
[   12.945666] Bluetooth: SCO socket layer initialized
[   13.164374] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   13.194251] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   13.295437] Bluetooth: HCI UART driver ver 2.3
[   13.300032] Bluetooth: HCI UART protocol H4 registered
[   13.305252] Bluetooth: HCI UART protocol BCSP registered
[   13.310629] Bluetooth: HCI UART protocol LL registered
[   13.315830] Bluetooth: HCI UART protocol ATH3K registered
[   13.321290] Bluetooth: HCI UART protocol Three-wire (H5) registered
[   13.338711] Bluetooth: HCI UART protocol Intel registered
[   13.345238] Bluetooth: HCI UART protocol BCM registered
[   13.346766] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   13.356538] Bluetooth: HCI UART protocol QCA registered
[   13.361826] Bluetooth: HCI UART protocol AG6XX registered
[   13.409254] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   13.653343] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[   13.774220] XFS (sda1): Mounting V5 Filesystem
[   13.824007] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   13.842040] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   13.923289] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   14.034149] XFS (sda1): Starting recovery (logdev: internal)
[   14.076208] XFS (sda1): Ending recovery (logdev: internal)
[   14.201308] SSE version of gcm_enc/dec engaged.
[   14.685112] Adding 3129340k swap on /dev/mapper/rhel_iot--r5s2--01-swap.  Priority:-1 extents:1 across:3129340k SSFS
[   14.759985] mwifiex_pcie: try set_consistent_dma_mask(32)
[   14.770938] mwifiex_pcie: PCI memory map Virt0: ffffc90001200000 PCI memory map Virt2: ffffc90001400000
[   14.790041] mwifiex: rx work enabled, cpus 2
[   14.807023] mwifiex_pcie 0000:02:00.0: msi_enable = 1
[   14.823255] mwifiex_pcie 0000:02:00.0: Setting driver ready signature
[   14.829798] mwifiex_pcie 0000:02:00.0: Try 0 if FW is ready <0,0x0>
[   14.938939] mwifiex_pcie 0000:02:00.0: PCI-E is the winner
[   14.944496] mwifiex_pcie 0000:02:00.0: info: Downloading FW image (803884 bytes)
[   16.185661] mwifiex_pcie 0000:02:00.0: info: FW download over, size 803884 bytes
[   16.193133] mwifiex_pcie 0000:02:00.0: Setting driver ready signature
[   16.199653] mwifiex_pcie 0000:02:00.0: Try 0 if FW is ready <0,0x6>
[   16.307816] mwifiex_pcie 0000:02:00.0: Try 1 if FW is ready <0,0x6>
[   16.419372] mwifiex_pcie 0000:02:00.0: Try 2 if FW is ready <0,0x6>
[   16.531370] mwifiex_pcie 0000:02:00.0: Try 3 if FW is ready <0,0x6>
[   16.643433] mwifiex_pcie 0000:02:00.0: Try 4 if FW is ready <0,0x6>
[   16.682161] audit: type=1305 audit(1472130184.496:4): audit_pid=706 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[   16.755614] mwifiex_pcie 0000:02:00.0: Try 5 if FW is ready <0,0x6>
[   16.867461] mwifiex_pcie 0000:02:00.0: Try 6 if FW is ready <0,0x6>
[   16.980028] mwifiex_pcie 0000:02:00.0: Try 7 if FW is ready <0,0x6>
[   17.091501] mwifiex_pcie 0000:02:00.0: Try 8 if FW is ready <0,0x6>
[   17.203557] mwifiex_pcie 0000:02:00.0: Try 9 if FW is ready <0,0x6>
[   17.316391] mwifiex_pcie 0000:02:00.0: Try 10 if FW is ready <0,0x6>
[   17.340141] random: crng init done
[   17.428017] mwifiex_pcie 0000:02:00.0: Try 11 if FW is ready <0,0x6>
[   17.540602] mwifiex_pcie 0000:02:00.0: Try 12 if FW is ready <0,0x6>
[   17.651655] mwifiex_pcie 0000:02:00.0: Try 13 if FW is ready <0,0x6>
[   17.763693] mwifiex_pcie 0000:02:00.0: Try 14 if FW is ready <0,0x6>
[   17.875747] mwifiex_pcie 0000:02:00.0: Try 15 if FW is ready <0,0x6>
[   17.988759] mwifiex_pcie 0000:02:00.0: Try 16 if FW is ready <0,0x6>
[   18.100800] mwifiex_pcie 0000:02:00.0: Try 17 if FW is ready <0,0x6>
[   18.211793] mwifiex_pcie 0000:02:00.0: Try 18 if FW is ready <0,0x6>
[   18.323812] mwifiex_pcie 0000:02:00.0: Try 19 if FW is ready <0,0x6>
[   18.436840] mwifiex_pcie 0000:02:00.0: Try 20 if FW is ready <0,0x6>
[   18.463779] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[   18.505045] r8169 0000:01:00.0 p4p1: link down
[   18.509564] r8169 0000:01:00.0 p4p1: link down
[   18.516961] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[   18.549909] mwifiex_pcie 0000:02:00.0: Try 21 if FW is ready <0,0x6>
[   18.659912] mwifiex_pcie 0000:02:00.0: Try 22 if FW is ready <0,0x6>
[   18.772414] mwifiex_pcie 0000:02:00.0: Try 23 if FW is ready <0,0x6>
[   18.884447] mwifiex_pcie 0000:02:00.0: Try 24 if FW is ready <0,0x6>
[   18.996477] mwifiex_pcie 0000:02:00.0: Try 25 if FW is ready <0,0x6>
[   19.108507] mwifiex_pcie 0000:02:00.0: Try 26 if FW is ready <0,0x6>
[   19.220534] mwifiex_pcie 0000:02:00.0: Try 27 if FW is ready <0,0x6>
[   19.332562] mwifiex_pcie 0000:02:00.0: Try 28 if FW is ready <0,0x6>
[   19.444891] mwifiex_pcie 0000:02:00.0: Try 29 if FW is ready <0,0x6>
[   19.556631] mwifiex_pcie 0000:02:00.0: Try 30 if FW is ready <0,0x6>
[   19.668656] mwifiex_pcie 0000:02:00.0: Try 31 if FW is ready <0,0x6>
[   19.780693] mwifiex_pcie 0000:02:00.0: Try 32 if FW is ready <0,0x6>
[   19.893009] mwifiex_pcie 0000:02:00.0: Try 33 if FW is ready <0,0x6>
[   20.004724] mwifiex_pcie 0000:02:00.0: Try 34 if FW is ready <0,0x6>
[   20.116741] mwifiex_pcie 0000:02:00.0: Try 35 if FW is ready <0,0x6>
[   20.228776] mwifiex_pcie 0000:02:00.0: Try 36 if FW is ready <0,0x6>
[   20.340805] mwifiex_pcie 0000:02:00.0: Try 37 if FW is ready <0,0x6>
[   20.452835] mwifiex_pcie 0000:02:00.0: Try 38 if FW is ready <0,0x6>
[   20.564864] mwifiex_pcie 0000:02:00.0: Try 39 if FW is ready <0,0x6>
[   20.676893] mwifiex_pcie 0000:02:00.0: Try 40 if FW is ready <0,0x6>
[   20.788928] mwifiex_pcie 0000:02:00.0: Try 41 if FW is ready <0,0x6>
[   20.900745] mwifiex_pcie 0000:02:00.0: Try 42 if FW is ready <0,0x6>
[   21.012983] mwifiex_pcie 0000:02:00.0: Try 43 if FW is ready <0,0x6>
[   21.125011] mwifiex_pcie 0000:02:00.0: Try 44 if FW is ready <0,0x6>
[   21.237043] mwifiex_pcie 0000:02:00.0: Try 45 if FW is ready <0,0x6>
[   21.349368] mwifiex_pcie 0000:02:00.0: Try 46 if FW is ready <0,0x6>
[   21.461102] mwifiex_pcie 0000:02:00.0: Try 47 if FW is ready <0,0x6>
[   21.573133] mwifiex_pcie 0000:02:00.0: Try 48 if FW is ready <0,0x6>
[   21.612019] r8169 0000:01:00.0 p4p1: link up
[   21.616425] IPv6: ADDRCONF(NETDEV_CHANGE): p4p1: link becomes ready
[   21.686188] mwifiex_pcie 0000:02:00.0: Try 49 if FW is ready <0,0x6>
[   21.796770] mwifiex_pcie 0000:02:00.0: Try 50 if FW is ready <0,0x6>
[   21.909216] mwifiex_pcie 0000:02:00.0: Try 51 if FW is ready <0,0x6>
[   22.021252] mwifiex_pcie 0000:02:00.0: Try 52 if FW is ready <0,0x6>
[   22.133278] mwifiex_pcie 0000:02:00.0: Try 53 if FW is ready <0,0x6>
[   22.245311] mwifiex_pcie 0000:02:00.0: Try 54 if FW is ready <0,0x6>
[   22.357340] mwifiex_pcie 0000:02:00.0: Try 55 if FW is ready <0,0x6>
[   22.469371] mwifiex_pcie 0000:02:00.0: Try 56 if FW is ready <0,0x6>
[   22.581694] mwifiex_pcie 0000:02:00.0: Try 57 if FW is ready <0,0x6>
[   22.693431] mwifiex_pcie 0000:02:00.0: Try 58 if FW is ready <0,0x6>
[   22.805762] mwifiex_pcie 0000:02:00.0: Try 59 if FW is ready <0,0x6>
[   22.917489] mwifiex_pcie 0000:02:00.0: Try 60 if FW is ready <0,0x6>
[   23.029520] mwifiex_pcie 0000:02:00.0: Try 61 if FW is ready <0,0x6>
[   23.141548] mwifiex_pcie 0000:02:00.0: Try 62 if FW is ready <0,0x6>
[   23.253578] mwifiex_pcie 0000:02:00.0: Try 63 if FW is ready <0,0x6>
[   23.365608] mwifiex_pcie 0000:02:00.0: Try 64 if FW is ready <0,0x6>
[   23.477937] mwifiex_pcie 0000:02:00.0: Try 65 if FW is ready <0,0x6>
[   23.589669] mwifiex_pcie 0000:02:00.0: Try 66 if FW is ready <0,0x6>
[   23.701699] mwifiex_pcie 0000:02:00.0: Try 67 if FW is ready <0,0x6>
[   23.813728] mwifiex_pcie 0000:02:00.0: Try 68 if FW is ready <0,0x6>
[   23.925759] mwifiex_pcie 0000:02:00.0: Try 69 if FW is ready <0,0x6>
[   24.037783] mwifiex_pcie 0000:02:00.0: Try 70 if FW is ready <0,0x6>
[   24.149813] mwifiex_pcie 0000:02:00.0: Try 71 if FW is ready <0,0x6>
[   24.262158] mwifiex_pcie 0000:02:00.0: Try 72 if FW is ready <0,0x6>
[   24.373876] mwifiex_pcie 0000:02:00.0: Try 73 if FW is ready <0,0x6>
[   24.485908] mwifiex_pcie 0000:02:00.0: Try 74 if FW is ready <0,0x6>
[   24.597931] mwifiex_pcie 0000:02:00.0: Try 75 if FW is ready <0,0x6>
[   24.709965] mwifiex_pcie 0000:02:00.0: Try 76 if FW is ready <0,0x6>
[   24.822001] mwifiex_pcie 0000:02:00.0: Try 77 if FW is ready <0,0x6>
[   24.934025] mwifiex_pcie 0000:02:00.0: Try 78 if FW is ready <0,0x6>
[   25.046055] mwifiex_pcie 0000:02:00.0: Try 79 if FW is ready <0,0x6>
[   25.158082] mwifiex_pcie 0000:02:00.0: Try 80 if FW is ready <0,0x6>
[   25.270112] mwifiex_pcie 0000:02:00.0: Try 81 if FW is ready <0,0x6>
[   25.382141] mwifiex_pcie 0000:02:00.0: Try 82 if FW is ready <0,0x6>
[   25.494171] mwifiex_pcie 0000:02:00.0: Try 83 if FW is ready <0,0x6>
[   25.606205] mwifiex_pcie 0000:02:00.0: Try 84 if FW is ready <0,0x6>
[   25.718534] mwifiex_pcie 0000:02:00.0: Try 85 if FW is ready <0,0x6>
[   25.830269] mwifiex_pcie 0000:02:00.0: Try 86 if FW is ready <0,0x6>
[   25.942293] mwifiex_pcie 0000:02:00.0: Try 87 if FW is ready <0,0x6>
[   26.054320] mwifiex_pcie 0000:02:00.0: Try 88 if FW is ready <0,0x6>
[   26.166351] mwifiex_pcie 0000:02:00.0: Try 89 if FW is ready <0,0x6>
[   26.278383] mwifiex_pcie 0000:02:00.0: Try 90 if FW is ready <0,0x6>
[   26.390408] mwifiex_pcie 0000:02:00.0: Try 91 if FW is ready <0,0x6>
[   26.502445] mwifiex_pcie 0000:02:00.0: Try 92 if FW is ready <0,0x6>
[   26.614771] mwifiex_pcie 0000:02:00.0: Try 93 if FW is ready <0,0x6>
[   26.726507] mwifiex_pcie 0000:02:00.0: Try 94 if FW is ready <0,0x6>
[   26.838530] mwifiex_pcie 0000:02:00.0: Try 95 if FW is ready <0,0x6>
[   26.950559] mwifiex_pcie 0000:02:00.0: Try 96 if FW is ready <0,0x6>
[   27.062600] mwifiex_pcie 0000:02:00.0: Try 97 if FW is ready <0,0x6>
[   27.174919] mwifiex_pcie 0000:02:00.0: Try 98 if FW is ready <0,0x6>
[   27.286651] mwifiex_pcie 0000:02:00.0: Try 99 if FW is ready <0,0x6>
[   27.398681] mwifiex_pcie 0000:02:00.0: Try 100 if FW is ready <0,0x6>
[   27.510711] mwifiex_pcie 0000:02:00.0: Try 101 if FW is ready <0,0x6>
[   27.622743] mwifiex_pcie 0000:02:00.0: Try 102 if FW is ready <0,0x6>
[   27.734775] mwifiex_pcie 0000:02:00.0: Try 103 if FW is ready <0,0x6>
[   27.846809] mwifiex_pcie 0000:02:00.0: Try 104 if FW is ready <0,0x6>
[   27.958683] mwifiex_pcie 0000:02:00.0: Try 105 if FW is ready <0,0x6>
[   28.070862] mwifiex_pcie 0000:02:00.0: Try 106 if FW is ready <0,0x6>
[   28.182897] mwifiex_pcie 0000:02:00.0: Try 107 if FW is ready <0,0x6>
[   28.294922] mwifiex_pcie 0000:02:00.0: Try 108 if FW is ready <0,0x6>
[   28.406956] mwifiex_pcie 0000:02:00.0: Try 109 if FW is ready <0,0x6>
[   28.518983] mwifiex_pcie 0000:02:00.0: Try 110 if FW is ready <0,0x6>
[   28.631320] mwifiex_pcie 0000:02:00.0: Try 111 if FW is ready <0,0x6>
[   28.742593] mwifiex_pcie 0000:02:00.0: Try 112 if FW is ready <0,0x6>
[   28.855075] mwifiex_pcie 0000:02:00.0: Try 113 if FW is ready <0,0x6>
[   28.967102] mwifiex_pcie 0000:02:00.0: Try 114 if FW is ready <0,0x6>
[   29.079141] mwifiex_pcie 0000:02:00.0: Try 115 if FW is ready <0,0x6>
[   29.191168] mwifiex_pcie 0000:02:00.0: Try 116 if FW is ready <0,0x6>
[   29.303216] mwifiex_pcie 0000:02:00.0: Try 117 if FW is ready <0,0x6>
[   29.415244] mwifiex_pcie 0000:02:00.0: Try 118 if FW is ready <0,0x6>
[   29.527274] mwifiex_pcie 0000:02:00.0: Try 119 if FW is ready <0,0x6>
[   29.639305] mwifiex_pcie 0000:02:00.0: Try 120 if FW is ready <0,0x6>
[   29.751337] mwifiex_pcie 0000:02:00.0: Try 121 if FW is ready <0,0x6>
[   29.863364] mwifiex_pcie 0000:02:00.0: Try 122 if FW is ready <0,0x6>
[   29.975403] mwifiex_pcie 0000:02:00.0: Try 123 if FW is ready <0,0x6>
[   30.086964] mwifiex_pcie 0000:02:00.0: Try 124 if FW is ready <0,0x6>
[   30.198973] mwifiex_pcie 0000:02:00.0: Try 125 if FW is ready <0,0x6>
[   30.311092] mwifiex_pcie 0000:02:00.0: Try 126 if FW is ready <0,0x6>
[   30.423046] mwifiex_pcie 0000:02:00.0: Try 127 if FW is ready <0,0x6>
[   30.535110] mwifiex_pcie 0000:02:00.0: Try 128 if FW is ready <0,0x6>
[   30.647640] mwifiex_pcie 0000:02:00.0: Try 129 if FW is ready <0,0x6>
[   30.759135] mwifiex_pcie 0000:02:00.0: Try 130 if FW is ready <0,0x6>
[   30.871213] mwifiex_pcie 0000:02:00.0: Try 131 if FW is ready <0,0x6>
[   30.983684] mwifiex_pcie 0000:02:00.0: Try 132 if FW is ready <0,0x6>
[   31.096276] mwifiex_pcie 0000:02:00.0: Try 133 if FW is ready <0,0x6>
[   31.207290] mwifiex_pcie 0000:02:00.0: Try 134 if FW is ready <0,0x6>
[   31.319305] mwifiex_pcie 0000:02:00.0: Try 135 if FW is ready <0,0x6>
[   31.431353] mwifiex_pcie 0000:02:00.0: Try 136 if FW is ready <0,0x6>
[   31.543382] mwifiex_pcie 0000:02:00.0: Try 137 if FW is ready <0,0x6>
[   31.647845] mwifiex_pcie 0000:02:00.0: Try 138 if FW is ready <0,0x6>
[   31.759472] mwifiex_pcie 0000:02:00.0: Try 139 if FW is ready <0,0x6>
[   31.875461] mwifiex_pcie 0000:02:00.0: Try 140 if FW is ready <0,0x6>
[   31.983527] mwifiex_pcie 0000:02:00.0: Try 141 if FW is ready <0,0x6>
[   32.095477] mwifiex_pcie 0000:02:00.0: Try 142 if FW is ready <0,0x6>
[   32.208010] mwifiex_pcie 0000:02:00.0: Try 143 if FW is ready <0,0x6>
[   32.319883] mwifiex_pcie 0000:02:00.0: Try 144 if FW is ready <0,0x6>
[   32.431565] mwifiex_pcie 0000:02:00.0: Try 145 if FW is ready <0,0x6>
[   32.543635] mwifiex_pcie 0000:02:00.0: Try 146 if FW is ready <0,0x6>
[   32.655637] mwifiex_pcie 0000:02:00.0: Try 147 if FW is ready <0,0x6>
[   32.767675] mwifiex_pcie 0000:02:00.0: Try 148 if FW is ready <0,0x6>
[   32.879733] mwifiex_pcie 0000:02:00.0: Try 149 if FW is ready <0,0x6>
[   32.991920] mwifiex_pcie 0000:02:00.0: FW failed to be active in time
[   32.998481] mwifiex_pcie 0000:02:00.0: info: mwifiex_fw_dpc: unregister device
[   33.005829] mwifiex_pcie 0000:02:00.0: mwifiex_unregister_dev(): calling free_irq()
[   35.308685] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   35.433894] Ebtables v2.0 registered
[   35.864489] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   35.950785] tun: Universal TUN/TAP device driver, 1.6
[   35.955914] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   36.008270] virbr0: port 1(virbr0-nic) entered blocking state
[   36.014103] virbr0: port 1(virbr0-nic) entered disabled state
[   36.021678] device virbr0-nic entered promiscuous mode
[   36.420716] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   36.970265] virbr0: port 1(virbr0-nic) entered blocking state
[   36.976105] virbr0: port 1(virbr0-nic) entered listening state
[   37.133423] virbr0: port 1(virbr0-nic) entered disabled state
[   37.148095] device virbr0-nic left promiscuous mode
[   37.153104] virbr0: port 1(virbr0-nic) entered disabled state

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-bad-reboot.txt"

[    0.000000] Linux version 4.8.0-rc2+ (root@iot-r5s2-01.wlan.rhts.eng.bos.redhat.com) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-9) (GCC) ) #3 SMP Thu Aug 25 05:50:38 EDT 2016
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.8.0-rc2+ root=/dev/mapper/rhel_iot--r5s2--01-root ro crashkernel=auto rd.lvm.lv=rhel_iot-r5s2-01/root rd.lvm.lv=rhel_iot-r5s2-01/swap console=ttyS3,115200n81 LANG=en_US.UTF-8
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001effffff] usable
[    0.000000] BIOS-e820: [mem 0x000000001f000000-0x000000001f0fffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000001f100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000200fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020100000-0x0000000076e4efff] usable
[    0.000000] BIOS-e820: [mem 0x0000000076e4f000-0x0000000076e7efff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000076e7f000-0x0000000076ea4fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000076ea5000-0x000000007742efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007742f000-0x000000007772bfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007772c000-0x000000007772cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007772d000-0x000000007776efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007776f000-0x00000000789e4fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000789e5000-0x0000000078ff9fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000078ffa000-0x0000000078ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed03000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed0c000-0x00000000fed0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff900000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: Dell Inc. Edge Gateway 5000/0N13CD, BIOS 01.02.00 01/28/2016
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x79000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 079000000 mask FFF000000 uncachable
[    0.000000]   2 base 07A000000 mask FFE000000 uncachable
[    0.000000]   3 base 07C000000 mask FFC000000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] total RAM covered: 1936M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 0G
[    0.000000] found SMP MP-table at [mem 0x000fd800-0x000fd80f] mapped at [ffff8800000fd800]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] BRK [0x02293000, 0x02293fff] PGTABLE
[    0.000000] BRK [0x02294000, 0x02294fff] PGTABLE
[    0.000000] BRK [0x02295000, 0x02295fff] PGTABLE
[    0.000000] BRK [0x02296000, 0x02296fff] PGTABLE
[    0.000000] BRK [0x02297000, 0x02297fff] PGTABLE
[    0.000000] BRK [0x02298000, 0x02298fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x3095d000-0x344a6fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0580 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x0000000076E97088 00008C (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x0000000076EA3CA8 00010C (v05 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 128/32 (20160422/tbfadt-624)
[    0.000000] ACPI: DSDT 0x0000000076E971A0 00CB03 (v02 DELL   AS09     01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x000000007742EE80 000040
[    0.000000] ACPI: APIC 0x0000000076EA3DB8 000068 (v03 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x0000000076EA3E20 000044 (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x0000000076EA3E68 00009C (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x0000000076EA3F08 00003C (v01 DELL   AS09     01072009 MSFT 00000097)
[    0.000000] ACPI: LPIT 0x0000000076EA3F48 000104 (v01 DELL   AS09     00000003 VLV2 0100000D)
[    0.000000] ACPI: HPET 0x0000000076EA4050 000038 (v01 DELL   AS09     01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x0000000076EA4088 000763 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076EA47F0 000290 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076EA4A80 00017A (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 0x0000000076EA4C00 000042 (v01 DELL   AS09     00000000      00000000)
[    0.000000] ACPI: SLIC 0x0000000076EA4C48 000176 (v03 DELL   AS09     01072009 MSFT 00010013)
[    0.000000] ACPI: CSRT 0x0000000076EA4DC0 00014C (v00 DELL   AS09     00000005 INTL 20120624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000078ffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x789c2000-0x789e3fff]
[    0.000000] kexec_core: crashkernel: memory value expected
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x0000000078ffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009bfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001effffff]
[    0.000000]   node   0: [mem 0x000000001f100000-0x000000001fffffff]
[    0.000000]   node   0: [mem 0x0000000020100000-0x0000000076e4efff]
[    0.000000]   node   0: [mem 0x000000007772c000-0x000000007772cfff]
[    0.000000]   node   0: [mem 0x000000007776f000-0x00000000789e4fff]
[    0.000000]   node   0: [mem 0x0000000078ffa000-0x0000000078ffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x0000000078ffffff]
[    0.000000] On node 0 totalpages: 491111
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7680 pages used for memmap
[    0.000000]   DMA32 zone: 487116 pages, LIFO batch:31
[    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
[    0.000000] Reserving Intel graphics memory at 0x000000007b000000-0x000000007effffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-86
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x1f000000-0x1f0fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x200fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e4f000-0x76e7efff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e7f000-0x76ea4fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76ea5000-0x7742efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7742f000-0x7772bfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7772d000-0x7776efff]
[    0.000000] PM: Registered nosave memory: [mem 0x789e5000-0x78ff9fff]
[    0.000000] e820: [mem 0x7f000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 36 pages/cpu @ffff880078400000 s107672 r8192 d31592 u1048576
[    0.000000] pcpu-alloc: s107672 r8192 d31592 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 483346
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.8.0-rc2+ root=/dev/mapper/rhel_iot--r5s2--01-root ro crashkernel=auto rd.lvm.lv=rhel_iot-r5s2-01/root rd.lvm.lv=rhel_iot-r5s2-01/swap console=ttyS3,115200n81 LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 1851144K/1964444K available (7131K kernel code, 1541K rwdata, 3196K rodata, 1868K init, 3280K bss, 113300K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-1.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS3] enabled
[    0.000000] tsc: Detected 1333.000 MHz processor
[    0.000044] Calibrating delay loop (skipped), value calculated using timer frequency.. 2666.00 BogoMIPS (lpj=1333000)
[    0.000497] pid_max: default: 32768 minimum: 301
[    0.000716] ACPI: Core revision 20160422
[    0.038211] ACPI: 4 ACPI AML tables successfully acquired and loaded

[    0.038626] Security Framework initialized
[    0.038820] SELinux:  Initializing.
[    0.038987] SELinux:  Starting in permissive mode
[    0.039418] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.041598] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.042570] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.042893] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.043833] CPU: Physical Processor ID: 0
[    0.044011] CPU: Processor Core ID: 0
[    0.044174] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.044428] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.044733] mce: CPU supports 6 MCE banks
[    0.044930] CPU0: Thermal monitoring enabled (TM1)
[    0.045142] process: using mwait in idle threads
[    0.045345] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.045575] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.046410] Freeing SMP alternatives memory: 28K (ffffffff81f56000 - ffffffff81f5d000)
[    0.050487] ftrace: allocating 28065 entries in 110 pages
[    0.074036] smpboot: Max logical packages: 1
[    0.074226] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.075240] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.085509] TSC deadline timer enabled
[    0.085515] smpboot: CPU0: Intel(R) Atom(TM) CPU  E3825  @ 1.33GHz (family: 0x6, model: 0x37, stepping: 0x9)
[    0.085953] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, 8-deep LBR, full-width counters, Intel PMU driver.
[    0.086501] ... version:                3
[    0.086683] ... bit width:              40
[    0.086860] ... generic registers:      2
[    0.087032] ... value mask:             000000ffffffffff
[    0.087257] ... max period:             000000ffffffffff
[    0.087481] ... fixed-purpose events:   3
[    0.087653] ... event mask:             0000000700000003
[    0.089753] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.090608] x86: Booting SMP configuration:
[    0.090793] .... node  #0, CPUs:      #1
[    0.152526] x86: Booted up 1 node, 2 CPUs
[    0.152717] smpboot: Total of 2 processors activated (5340.13 BogoMIPS)
[    0.154153] devtmpfs: initialized
[    0.154490] x86/mm: Memory block size: 128MB
[    0.164586] evm: security.selinux
[    0.164733] evm: security.ima
[    0.164863] evm: security.capability
[    0.165214] PM: Registering ACPI NVS region [mem 0x76ea5000-0x7742efff] (5808128 bytes)
[    0.165955] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.166456] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.166766] pinctrl core: initialized pinctrl subsystem
[    0.167344] NET: Registered protocol family 16
[    0.169818] cpuidle: using governor menu
[    0.170120] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.170440] ACPI: bus type PCI registered
[    0.170614] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.171030] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.171421] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.171744] PCI: Using configuration type 1 for base access
[    0.172004] dmi type 0xB1 record - unknown flag
[    0.177446] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.178362] ACPI: Added _OSI(Module Device)
[    0.178546] ACPI: Added _OSI(Processor Device)
[    0.178737] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.178938] ACPI: Added _OSI(Processor Aggregator Device)
[    0.196472] ACPI: Dynamic OEM Table Load:
[    0.196677] ACPI: SSDT 0xFFFF880077AD8800 0002B4 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.198911] ACPI: Dynamic OEM Table Load:
[    0.199111] ACPI: SSDT 0xFFFF880077A5A000 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.202039] ACPI: Dynamic OEM Table Load:
[    0.202238] ACPI: SSDT 0xFFFF880077A71800 00015F (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.204406] ACPI: Dynamic OEM Table Load:
[    0.204604] ACPI: SSDT 0xFFFF880077ACA0C0 00008D (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.209557] ACPI: Interpreter enabled
[    0.209782] ACPI: (supports S0 S4 S5)
[    0.209943] ACPI: Using IOAPIC for interrupt routing
[    0.210251] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.232993] ACPI: Power Resource [USBC] (on)
[    0.235924] ACPI: Power Resource [PLPE] (on)
[    0.236777] ACPI: Power Resource [PLPE] (on)
[    0.250432] ACPI: Power Resource [CLK0] (on)
[    0.250744] ACPI: Power Resource [CLK1] (on)
[    0.326082] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.326358] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.327168] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.327914] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.328196] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.329884] PCI host bridge to bus 0000:00
[    0.330068] pci_bus 0000:00: root bus resource [io  0x0070-0x0077]
[    0.330331] pci_bus 0000:00: root bus resource [io  0x0000-0x006f window]
[    0.330618] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7 window]
[    0.330916] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.331204] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.331520] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.331835] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff window]
[    0.332158] pci_bus 0000:00: root bus resource [mem 0x80000000-0x90915ffe window]
[    0.332474] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.332721] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.333099] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.333119] pci 0000:00:02.0: reg 0x10: [mem 0x90000000-0x903fffff]
[    0.333136] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x8fffffff pref]
[    0.333151] pci 0000:00:02.0: reg 0x20: [io  0xe080-0xe087]
[    0.333539] pci 0000:00:13.0: [8086:0f23] type 00 class 0x010601
[    0.333563] pci 0000:00:13.0: reg 0x10: [io  0xe070-0xe077]
[    0.333576] pci 0000:00:13.0: reg 0x14: [io  0xe060-0xe063]
[    0.333588] pci 0000:00:13.0: reg 0x18: [io  0xe050-0xe057]
[    0.333601] pci 0000:00:13.0: reg 0x1c: [io  0xe040-0xe043]
[    0.333613] pci 0000:00:13.0: reg 0x20: [io  0xe020-0xe03f]
[    0.333626] pci 0000:00:13.0: reg 0x24: [mem 0x90915000-0x909157ff]
[    0.333690] pci 0000:00:13.0: PME# supported from D3hot
[    0.334014] pci 0000:00:14.0: [8086:0f35] type 00 class 0x0c0330
[    0.334040] pci 0000:00:14.0: reg 0x10: [mem 0x90900000-0x9090ffff 64bit]
[    0.334123] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.334408] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.334768] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.334798] pci 0000:00:1a.0: reg 0x10: [mem 0x90500000-0x905fffff]
[    0.334815] pci 0000:00:1a.0: reg 0x14: [mem 0x90400000-0x904fffff]
[    0.334942] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.335345] pci 0000:00:1b.0: [8086:0f04] type 00 class 0x040300
[    0.335376] pci 0000:00:1b.0: reg 0x10: [mem 0x90910000-0x90913fff 64bit]
[    0.335472] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.335804] pci 0000:00:1c.0: [8086:0f48] type 01 class 0x060400
[    0.335894] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.336127] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.336484] pci 0000:00:1c.2: [8086:0f4c] type 01 class 0x060400
[    0.336574] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.336808] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.337152] pci 0000:00:1c.3: [8086:0f4e] type 01 class 0x060400
[    0.337240] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.337480] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.337832] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.338236] pci 0000:00:1f.3: [8086:0f12] type 00 class 0x0c0500
[    0.338276] pci 0000:00:1f.3: reg 0x10: [mem 0x90914000-0x9091401f]
[    0.338355] pci 0000:00:1f.3: reg 0x20: [io  0xe000-0xe01f]
[    0.338909] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    0.338937] pci 0000:01:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.338971] pci 0000:01:00.0: reg 0x18: [mem 0x90804000-0x90804fff 64bit]
[    0.338994] pci 0000:01:00.0: reg 0x20: [mem 0x90800000-0x90803fff 64bit pref]
[    0.339108] pci 0000:01:00.0: supports D1 D2
[    0.339112] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.339192] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.342491] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.342710] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.342716] pci 0000:00:1c.0:   bridge window [mem 0x90800000-0x908fffff]
[    0.342880] pci 0000:02:00.0: [11ab:2b38] type 00 class 0x020000
[    0.342917] pci 0000:02:00.0: reg 0x10: [mem 0x90700000-0x907fffff 64bit pref]
[    0.342943] pci 0000:02:00.0: reg 0x18: [mem 0x90600000-0x906fffff 64bit pref]
[    0.343102] pci 0000:02:00.0: supports D1 D2
[    0.343106] pci 0000:02:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.343196] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.346521] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.346741] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.346860] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.350571] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 12 14 15)
[    0.351108] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 12 14 15) *0, disabled.
[    0.351712] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 12 14 15)
[    0.352244] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 12 14 15)
[    0.352786] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 5 6 12 14 15)
[    0.353317] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 12 14 15)
[    0.353860] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 12 14 15)
[    0.354391] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 12 14 15) *0, disabled.
[    0.361464] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.362027] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.362272] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.362614] vgaarb: loaded
[    0.362750] vgaarb: bridge control possible 0000:00:02.0
[    0.363234] SCSI subsystem initialized
[    0.363472] ACPI: bus type USB registered
[    0.363697] usbcore: registered new interface driver usbfs
[    0.363976] usbcore: registered new interface driver hub
[    0.364248] usbcore: registered new device driver usb
[    0.364684] PCI: Using ACPI for IRQ routing
[    0.372303] PCI: pci_cache_line_size set to 64 bytes
[    0.372380] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.372384] e820: reserve RAM buffer [mem 0x1f000000-0x1fffffff]
[    0.372387] e820: reserve RAM buffer [mem 0x76e4f000-0x77ffffff]
[    0.372390] e820: reserve RAM buffer [mem 0x7772d000-0x77ffffff]
[    0.372392] e820: reserve RAM buffer [mem 0x789e5000-0x7bffffff]
[    0.372395] e820: reserve RAM buffer [mem 0x79000000-0x7bffffff]
[    0.372679] NetLabel: Initializing
[    0.372829] NetLabel:  domain hash size = 128
[    0.373026] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.373269] NetLabel:  unlabeled traffic allowed by default
[    0.373755] clocksource: Switched to clocksource refined-jiffies
[    0.396003] VFS: Disk quotas dquot_6.6.0
[    0.396219] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.396752] pnp: PnP ACPI init
[    0.397025] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.397385] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.397661] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.397915] system 00:01: [io  0x0500-0x05fe] has been reserved
[    0.398168] system 00:01: [io  0x0600-0x061f] has been reserved
[    0.398425] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.398984] system 00:02: [io  0x0a00-0x0a0f] has been reserved
[    0.399239] system 00:02: [io  0x0a10-0x0a1f] has been reserved
[    0.399492] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    0.399761] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.400506] ACPI: IRQ 10 override to edge, high
[    0.400712] pnp 00:03: [dma 0 disabled]
[    0.400818] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.401495] ACPI: IRQ 11 override to edge, high
[    0.401698] pnp 00:04: [dma 0 disabled]
[    0.401793] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.402460] ACPI: IRQ 10 override to edge, high
[    0.402663] pnp 00:05: [dma 0 disabled]
[    0.402746] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.404146] ACPI: IRQ 7 override to edge, high
[    0.404346] pnp 00:06: [dma 0 disabled]
[    0.404438] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.405302] system 00:07: [mem 0xe0000000-0xefffffff] could not be reserved
[    0.405601] system 00:07: [mem 0xfed01000-0xfed01fff] has been reserved
[    0.405896] system 00:07: [mem 0xfed03000-0xfed03fff] has been reserved
[    0.406178] system 00:07: [mem 0xfed04000-0xfed04fff] has been reserved
[    0.406460] system 00:07: [mem 0xfed0c000-0xfed0ffff] could not be reserved
[    0.406754] system 00:07: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.407043] system 00:07: [mem 0xfed1c000-0xfed1cfff] has been reserved
[    0.407325] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.407620] system 00:07: [mem 0xfef00000-0xfeffffff] has been reserved
[    0.407907] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.411352] pnp: PnP ACPI: found 8 devices
[    0.421667] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.422068] clocksource: Switched to clocksource acpi_pm
[    0.422352] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000 add_align 100000
[    0.422371] pci 0000:00:1c.2: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.422377] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
[    0.422392] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.422397] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 add_align 100000
[    0.422403] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff] to [bus 03] add_size 200000 add_align 100000
[    0.422418] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422423] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422428] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422432] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422437] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x000fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.422442] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x002fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.422446] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422451] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.422456] pci 0000:00:1c.2: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.422460] pci 0000:00:1c.2: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.422465] pci 0000:00:1c.3: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.422469] pci 0000:00:1c.3: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.422487] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.422811] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.423177] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.423500] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.423840] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.424147] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.424455] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.424778] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.425140] pci 0000:00:1c.2: BAR 13: assigned [io  0x1000-0x1fff]
[    0.425406] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
[    0.425676] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.425960] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.426289] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.426612] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.426957] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.427301] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.427647] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.427970] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.428330] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.428546] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.428809] pci 0000:00:1c.0:   bridge window [mem 0x90800000-0x908fffff]
[    0.429125] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.429340] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.429602] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.429895] pci 0000:00:1c.3: PCI bridge to [bus 03]
[    0.430130] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.430401] pci_bus 0000:00: resource 4 [io  0x0070-0x0077]
[    0.430405] pci_bus 0000:00: resource 5 [io  0x0000-0x006f window]
[    0.430409] pci_bus 0000:00: resource 6 [io  0x0078-0x0cf7 window]
[    0.430413] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.430417] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.430421] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.430425] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000fffff window]
[    0.430429] pci_bus 0000:00: resource 11 [mem 0x80000000-0x90915ffe window]
[    0.430433] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.430437] pci_bus 0000:01: resource 1 [mem 0x90800000-0x908fffff]
[    0.430441] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.430445] pci_bus 0000:02: resource 1 [mem 0x90600000-0x907fffff]
[    0.430449] pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
[    0.430526] NET: Registered protocol family 2
[    0.431241] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.431656] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.432049] TCP: Hash tables configured (established 16384 bind 16384)
[    0.432453] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.432740] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.433191] NET: Registered protocol family 1
[    0.433422] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.434322] PCI: CLS 64 bytes, default 64
[    0.434482] Unpacking initramfs...
[    2.959255] Freeing initrd memory: 60712K (ffff88003095d000 - ffff8800344a7000)
[    2.962289] futex hash table entries: 512 (order: 3, 32768 bytes)
[    2.962584] audit: initializing netlink subsys (disabled)
[    2.962878] audit: type=2000 audit(1472116163.946:1): initialized
[    2.964106] Initialise system trusted keyrings
[    2.964577] workingset: timestamp_bits=36 max_order=19 bucket_order=0
[    2.970344] zbud: loaded
[    2.971215] Key type big_key registered
[    2.971383] SELinux:  Registering netfilter hooks
[    3.140236] NET: Registered protocol family 38
[    3.140435] Key type asymmetric registered
[    3.140613] Asymmetric key parser 'x509' registered
[    3.140983] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 248)
[    3.141379] io scheduler noop registered
[    3.141551] io scheduler deadline registered (default)
[    3.141821] io scheduler cfq registered
[    3.143053] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.143307] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    3.143650] intel_idle: MWAIT substates: 0x3000020
[    3.143653] intel_idle: v0.4.1 model 0x37
[    3.143905] intel_idle: lapic_timer_reliable_states 0xffffffff
[    3.144140] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    3.144497] ACPI: Sleep Button [SLPB]
[    3.144815] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    3.145130] ACPI: Power Button [PWRF]
[    3.149082] GHES: HEST is not enabled!
[    3.149442] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.171292] 00:03: ttyS0 at I/O 0x3e0 (irq = 10, base_baud = 115200) is a 16550A
[    3.193300] 00:04: ttyS1 at I/O 0x2e0 (irq = 11, base_baud = 115200) is a 16550A
[    3.215254] 00:05: ttyS2 at I/O 0x3e8 (irq = 10, base_baud = 115200) is a 16550A
[    3.237178] 00:06: ttyS3 at I/O 0x2d0 (irq = 7, base_baud = 115200) is a 16550A
[    3.245384] hpet: number irqs doesn't agree with number of timers
[    3.251744] Non-volatile memory driver v1.3
[    3.256072] Linux agpgart interface v0.103
[    3.261306] rdac: device handler registered
[    3.266152] hp_sw: device handler registered
[    3.270485] emc: device handler registered
[    3.275506] alua: device handler registered
[    3.280181] libphy: Fixed MDIO Bus: probed
[    3.284468] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.291080] ehci-pci: EHCI PCI platform driver
[    3.295618] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.301876] ohci-pci: OHCI PCI platform driver
[    3.306401] uhci_hcd: USB Universal Host Controller Interface driver
[    3.313169] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.318605] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    3.327199] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    3.335729] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    3.335956] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.342829] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.350130] usb usb1: Product: xHCI Host Controller
[    3.355068] usb usb1: Manufacturer: Linux 4.8.0-rc2+ xhci-hcd
[    3.360879] usb usb1: SerialNumber: 0000:00:14.0
[    3.365939] hub 1-0:1.0: USB hub found
[    3.369765] hub 1-0:1.0: 6 ports detected
[    3.375143] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.380564] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    3.388422] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    3.395287] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.402584] usb usb2: Product: xHCI Host Controller
[    3.407519] usb usb2: Manufacturer: Linux 4.8.0-rc2+ xhci-hcd
[    3.413331] usb usb2: SerialNumber: 0000:00:14.0
[    3.418344] hub 2-0:1.0: USB hub found
[    3.422173] hub 2-0:1.0: 1 port detected
[    3.426603] usbcore: registered new interface driver usbserial
[    3.432533] usbcore: registered new interface driver usbserial_generic
[    3.439154] usbserial: USB Serial support registered for generic
[    3.445304] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    3.453055] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.458091] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.463519] mousedev: PS/2 mouse device common for all mice
[    3.470881] rtc_cmos 00:00: RTC can wake from S4
[    3.475912] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    3.482257] rtc_cmos 00:00: alarms up to one month, y3k, 242 bytes nvram
[    3.489066] intel_pstate: Intel P-state driver initializing
[    3.497613] hidraw: raw HID events driver (C) Jiri Kosina
[    3.503825] usbcore: registered new interface driver usbhid
[    3.509496] usbhid: USB HID core driver
[    3.513639] drop_monitor: Initializing network drop monitor service
[    3.520494] Initializing XFRM netlink socket
[    3.525316] NET: Registered protocol family 10
[    3.530831] NET: Registered protocol family 17
[    3.535958] microcode: sig=0x30679, pf=0x1, revision=0x905
[    3.541598] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.551224] registered taskstats version 1
[    3.555385] Loading compiled-in X.509 certificates
[    3.578608] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
[    3.590819] Loaded X.509 cert 'Build time autogenerated kernel key: 19a0efe7f96fd701eff7e953b5dbaab91a7ce442'
[    3.601308] zswap: loaded using pool lzo/zbud
[    3.668744] Key type trusted registered
[    3.692148] Key type encrypted registered
[    3.696278] ima: No TPM chip found, activating TPM-bypass!
[    3.702048] evm: HMAC attrs: 0x1
[    3.705386] usb 1-4: new high-speed USB device number 2 using xhci_hcd
[    3.713543] rtc_cmos 00:00: setting system clock to 2016-08-25 09:09:25 UTC (1472116165)
[    3.726580] Freeing unused kernel memory: 1868K (ffffffff81d83000 - ffffffff81f56000)
[    3.734528] Write protecting the kernel read-only data: 12288k
[    3.742275] Freeing unused kernel memory: 1044K (ffff8800016fb000 - ffff880001800000)
[    3.757830] Freeing unused kernel memory: 900K (ffff880001b1f000 - ffff880001c00000)
[    3.780961] random: systemd: uninitialized urandom read (16 bytes read)
[    3.788994] random: systemd: uninitialized urandom read (16 bytes read)
[    3.809256] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    3.828094] systemd[1]: Detected architecture x86-64.
[    3.833259] systemd[1]: Running in initial RAM disk.
[    3.852828] systemd[1]: Set hostname to <localhost.localdomain>.
[    3.884321] usb 1-4: New USB device found, idVendor=0424, idProduct=2514
[    3.891115] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.898922] hub 1-4:1.0: USB hub found
[    3.902788] hub 1-4:1.0: 4 ports detected
[    4.016075] tsc: Refined TSC clocksource calibration: 1333.333 MHz
[    4.022768] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x13381e82524, max_idle_ns: 440795248224 ns
[    4.039911] random: systemd: uninitialized urandom read (16 bytes read)
[    4.046714] random: systemd: uninitialized urandom read (16 bytes read)
[    4.053568] random: systemd: uninitialized urandom read (16 bytes read)
[    4.060507] random: systemd: uninitialized urandom read (16 bytes read)
[    4.069507] random: systemd: uninitialized urandom read (16 bytes read)
[    4.076698] random: systemd: uninitialized urandom read (16 bytes read)
[    4.084166] random: systemd: uninitialized urandom read (16 bytes read)
[    4.093321] random: systemd: uninitialized urandom read (16 bytes read)
[    4.120602] systemd[1]: Reached target Timers.
[    4.125196] systemd[1]: Starting Timers.
[    4.135371] systemd[1]: Reached target Swap.
[    4.139766] systemd[1]: Starting Swap.
[    4.151790] systemd[1]: Created slice Root Slice.
[    4.156632] systemd[1]: Starting Root Slice.
[    4.220129] usb 1-4.2: new high-speed USB device number 3 using xhci_hcd
[    5.040979] clocksource: Switched to clocksource tsc
[    5.046695] device-mapper: uevent: version 1.0.3
[    5.051581] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
[    5.681095] sdhci: Secure Digital Host Controller Interface driver
[    5.687362] sdhci: Copyright(c) Pierre Ossman
[    5.729533] FUJITSU Extended Socket Network Device Driver - version 1.1 - Copyright (c) 2015 FUJITSU LIMITED
[    5.877290] libata version 3.00 loaded.
[    5.904328] ahci 0000:00:13.0: version 3.0
[    5.905097] ahci 0000:00:13.0: controller can't do DEVSLP, turning off
[    5.922549] ahci 0000:00:13.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    5.930741] ahci 0000:00:13.0: flags: 64bit ncq pm led clo pio slum part deso 
[    5.996393] [drm] Initialized drm 1.1.0 20060810
[    6.087159] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    6.101990] scsi host0: ahci
[    6.113589] scsi host1: ahci
[    6.118246] ata1: SATA max UDMA/133 abar m2048@0x90915000 port 0x90915100 irq 262
[    6.125827] ata2: SATA max UDMA/133 abar m2048@0x90915000 port 0x90915180 irq 262
[    6.140705] r8169 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM control
[    6.181068] r8169 0000:01:00.0 eth0: RTL8168f/8111f at 0xffffc900003f2000, f4:8e:38:d0:7c:bd, XID 08100880 IRQ 263
[    6.191544] r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    6.239594] r8169 0000:01:00.0: invalid large VPD tag 7f at offset 0
[    6.254456] r8169 0000:01:00.0 p4p1: renamed from eth0
[    6.451861] ata2: SATA link down (SStatus 0 SControl 300)
[    6.457352] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.465828] ata1.00: ATA-8: LITEON J8-L1032-11 M.2 2260 32GB, 0J51105, max UDMA/133
[    6.473574] ata1.00: 62533296 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    6.489847] ata1.00: configured for UDMA/133
[    6.518810] scsi 0:0:0:0: Direct-Access     ATA      LITEON J8-L1032- 105  PQ: 0 ANSI: 5
[    6.849824] [drm] Memory usable by graphics device = 2048M
[    6.855371] [drm] Replacing VGA console driver
[    6.861216] Console: switching to colour dummy device 80x25
[    6.868119] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    6.869041] sd 0:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    6.869276] sd 0:0:0:0: [sda] Write Protect is off
[    6.869281] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.869355] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.877598]  sda: sda1 sda2
[    6.878484] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.897106] random: fast init done
[    6.907394] [drm] Driver supports precise vblank timestamp query.
[    6.908063] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    6.937032] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    6.938820] acpi device:09: registered as cooling_device2
[    6.939030] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    7.776388] i915 0000:00:02.0: No connectors reported connected with modes
[    7.783385] [drm] Cannot find any crtc or sizes - going 1024x768
[    7.792227] fbcon: inteldrmfb (fb0) is primary device
[    7.826925] Console: switching to colour frame buffer device 128x48
[    7.855893] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    9.241724] SGI XFS with ACLs, security attributes, no debug enabled
[    9.258093] XFS (dm-0): Mounting V5 Filesystem
[    9.509478] XFS (dm-0): Ending clean mount
[    9.789553] usb 1-4.2: device descriptor read/64, error -110
[   10.347405] systemd-journald[145]: Received SIGTERM from PID 1 (systemd).
[   10.440487] systemd: 24 output lines suppressed due to ratelimiting
[   10.532646] audit: type=1404 audit(1472116172.317:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[   10.606447] SELinux: 32768 avtab hash slots, 104669 rules.
[   10.658762] SELinux: 32768 avtab hash slots, 104669 rules.
[   10.771942] SELinux:  8 users, 14 roles, 4978 types, 301 bools, 1 sens, 1024 cats
[   10.771950] SELinux:  91 classes, 104669 rules
[   10.783845] SELinux:  Permission validate_trans in class security not defined in policy.
[   10.792042] SELinux:  Permission module_load in class system not defined in policy.
[   10.800039] SELinux:  Class binder not defined in policy.
[   10.805490] SELinux:  Class cap_userns not defined in policy.
[   10.811299] SELinux:  Class cap2_userns not defined in policy.
[   10.817189] SELinux: the above unknown classes and permissions will be allowed
[   10.824486] SELinux:  Completing initialization.
[   10.824488] SELinux:  Setting up existing superblocks.
[   10.844357] audit: type=1403 audit(1472116172.628:3): policy loaded auid=4294967295 ses=4294967295
[   10.865818] systemd[1]: Successfully loaded SELinux policy in 333.495ms.
[   10.905116] systemd[1]: RTC configured in localtime, applying delta of -240 minutes to system time.
[   10.956801] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.962670] systemd[1]: Inserted module 'ip_tables'
[   11.096840] systemd[1]: Relabelled /dev and /run in 121.225ms.
[   11.701827] systemd-journald[543]: Received request to flush runtime journal from PID 1
[   12.010343] RPC: Registered named UNIX socket transport module.
[   12.016352] RPC: Registered udp transport module.
[   12.016354] RPC: Registered tcp transport module.
[   12.016355] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   12.507580] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   12.935544] Bluetooth: Core ver 2.21
[   12.945242] NET: Registered protocol family 31
[   12.949775] Bluetooth: HCI device and connection manager initialized
[   12.973535] Bluetooth: HCI socket layer initialized
[   13.026420] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   13.044298] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   13.064633] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   13.079700] Bluetooth: L2CAP socket layer initialized
[   13.090198] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   13.104057] Bluetooth: SCO socket layer initialized
[   13.277204] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   13.448527] SSE version of gcm_enc/dec engaged.
[   13.627152] XFS (sda1): Mounting V5 Filesystem
[   13.702289] Bluetooth: HCI UART driver ver 2.3
[   13.706844] Bluetooth: HCI UART protocol H4 registered
[   13.712053] Bluetooth: HCI UART protocol BCSP registered
[   13.717424] Bluetooth: HCI UART protocol LL registered
[   13.722645] Bluetooth: HCI UART protocol ATH3K registered
[   13.728112] Bluetooth: HCI UART protocol Three-wire (H5) registered
[   13.815009] Bluetooth: HCI UART protocol Intel registered
[   13.820997] Bluetooth: HCI UART protocol BCM registered
[   13.826320] Bluetooth: HCI UART protocol QCA registered
[   13.831663] Bluetooth: HCI UART protocol AG6XX registered
[   13.977263] XFS (sda1): Ending clean mount
[   14.061535] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[   14.136163] Adding 3129340k swap on /dev/mapper/rhel_iot--r5s2--01-swap.  Priority:-1 extents:1 across:3129340k SSFS
[   14.159637] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   14.171257] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   14.588111] mwifiex_pcie: try set_consistent_dma_mask(32)
[   14.588155] mwifiex_pcie: PCI memory map Virt0: ffffc90000800000 PCI memory map Virt2: ffffc90000a00000
[   14.588227] mwifiex: rx work enabled, cpus 2
[   14.591260] mwifiex_pcie 0000:02:00.0: msi_enable = 1
[   14.602408] mwifiex_pcie 0000:02:00.0: Setting driver ready signature
[   14.602416] mwifiex_pcie 0000:02:00.0: Try 0 if FW is ready <0,0x6>
[   14.707156] mwifiex_pcie 0000:02:00.0: PCI-E is not the winner <0x6>
[   14.707164] mwifiex_pcie 0000:02:00.0: WLAN is not the winner! Skip FW dnld
[   14.707171] mwifiex_pcie 0000:02:00.0: Setting driver ready signature
[   14.707186] mwifiex_pcie 0000:02:00.0: Try 0 if FW is ready <0,0x6>
[   14.810726] mwifiex_pcie 0000:02:00.0: Try 1 if FW is ready <0,0x6>
[   14.915176] mwifiex_pcie 0000:02:00.0: Try 2 if FW is ready <0,0x6>
[   15.019234] mwifiex_pcie 0000:02:00.0: Try 3 if FW is ready <0,0x6>
[   15.122780] mwifiex_pcie 0000:02:00.0: Try 4 if FW is ready <0,0x6>
[   15.234803] mwifiex_pcie 0000:02:00.0: Try 5 if FW is ready <0,0x6>
[   15.346948] mwifiex_pcie 0000:02:00.0: Try 6 if FW is ready <0,0x6>
[   15.458896] mwifiex_pcie 0000:02:00.0: Try 7 if FW is ready <0,0x6>
[   15.571523] mwifiex_pcie 0000:02:00.0: Try 8 if FW is ready <0,0x6>
[   15.682989] mwifiex_pcie 0000:02:00.0: Try 9 if FW is ready <0,0x6>
[   15.794982] mwifiex_pcie 0000:02:00.0: Try 10 if FW is ready <0,0x6>
[   15.820212] audit: type=1305 audit(1472130577.602:4): audit_pid=700 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[   15.907021] mwifiex_pcie 0000:02:00.0: Try 11 if FW is ready <0,0x6>
[   16.019055] mwifiex_pcie 0000:02:00.0: Try 12 if FW is ready <0,0x6>
[   16.131064] mwifiex_pcie 0000:02:00.0: Try 13 if FW is ready <0,0x6>
[   16.244269] mwifiex_pcie 0000:02:00.0: Try 14 if FW is ready <0,0x6>
[   16.355099] mwifiex_pcie 0000:02:00.0: Try 15 if FW is ready <0,0x6>
[   16.467138] mwifiex_pcie 0000:02:00.0: Try 16 if FW is ready <0,0x6>
[   16.540899] random: crng init done
[   16.579178] mwifiex_pcie 0000:02:00.0: Try 17 if FW is ready <0,0x6>
[   16.691606] mwifiex_pcie 0000:02:00.0: Try 18 if FW is ready <0,0x6>
[   16.803238] mwifiex_pcie 0000:02:00.0: Try 19 if FW is ready <0,0x6>
[   16.915285] mwifiex_pcie 0000:02:00.0: Try 20 if FW is ready <0,0x6>
[   17.027292] mwifiex_pcie 0000:02:00.0: Try 21 if FW is ready <0,0x6>
[   17.142259] mwifiex_pcie 0000:02:00.0: Try 22 if FW is ready <0,0x6>
[   17.251354] mwifiex_pcie 0000:02:00.0: Try 23 if FW is ready <0,0x6>
[   17.363518] mwifiex_pcie 0000:02:00.0: Try 24 if FW is ready <0,0x6>
[   17.425249] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[   17.473066] r8169 0000:01:00.0 p4p1: link down
[   17.478916] mwifiex_pcie 0000:02:00.0: Try 25 if FW is ready <0,0x6>
[   17.486477] r8169 0000:01:00.0 p4p1: link down
[   17.493977] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[   17.587427] mwifiex_pcie 0000:02:00.0: Try 26 if FW is ready <0,0x6>
[   17.699460] mwifiex_pcie 0000:02:00.0: Try 27 if FW is ready <0,0x6>
[   17.811945] mwifiex_pcie 0000:02:00.0: Try 28 if FW is ready <0,0x6>
[   17.923584] mwifiex_pcie 0000:02:00.0: Try 29 if FW is ready <0,0x6>
[   18.035984] mwifiex_pcie 0000:02:00.0: Try 30 if FW is ready <0,0x6>
[   18.149582] mwifiex_pcie 0000:02:00.0: Try 31 if FW is ready <0,0x6>
[   18.265646] mwifiex_pcie 0000:02:00.0: Try 32 if FW is ready <0,0x6>
[   18.380092] mwifiex_pcie 0000:02:00.0: Try 33 if FW is ready <0,0x6>
[   18.492130] mwifiex_pcie 0000:02:00.0: Try 34 if FW is ready <0,0x6>
[   18.604157] mwifiex_pcie 0000:02:00.0: Try 35 if FW is ready <0,0x6>
[   18.716189] mwifiex_pcie 0000:02:00.0: Try 36 if FW is ready <0,0x6>
[   18.828015] mwifiex_pcie 0000:02:00.0: Try 37 if FW is ready <0,0x6>
[   18.940247] mwifiex_pcie 0000:02:00.0: Try 38 if FW is ready <0,0x6>
[   19.052272] mwifiex_pcie 0000:02:00.0: Try 39 if FW is ready <0,0x6>
[   19.164308] mwifiex_pcie 0000:02:00.0: Try 40 if FW is ready <0,0x6>
[   19.276330] mwifiex_pcie 0000:02:00.0: Try 41 if FW is ready <0,0x6>
[   19.388367] mwifiex_pcie 0000:02:00.0: Try 42 if FW is ready <0,0x6>
[   19.500568] mwifiex_pcie 0000:02:00.0: Try 43 if FW is ready <0,0x6>
[   19.612425] mwifiex_pcie 0000:02:00.0: Try 44 if FW is ready <0,0x6>
[   19.724456] mwifiex_pcie 0000:02:00.0: Try 45 if FW is ready <0,0x6>
[   19.836494] mwifiex_pcie 0000:02:00.0: Try 46 if FW is ready <0,0x6>
[   19.948520] mwifiex_pcie 0000:02:00.0: Try 47 if FW is ready <0,0x6>
[   20.060547] mwifiex_pcie 0000:02:00.0: Try 48 if FW is ready <0,0x6>
[   20.172576] mwifiex_pcie 0000:02:00.0: Try 49 if FW is ready <0,0x6>
[   20.284613] mwifiex_pcie 0000:02:00.0: Try 50 if FW is ready <0,0x6>
[   20.396633] mwifiex_pcie 0000:02:00.0: Try 51 if FW is ready <0,0x6>
[   20.508672] mwifiex_pcie 0000:02:00.0: Try 52 if FW is ready <0,0x6>
[   20.620694] mwifiex_pcie 0000:02:00.0: Try 53 if FW is ready <0,0x6>
[   20.640196] r8169 0000:01:00.0 p4p1: link up
[   20.644632] IPv6: ADDRCONF(NETDEV_CHANGE): p4p1: link becomes ready
[   20.732460] mwifiex_pcie 0000:02:00.0: Try 54 if FW is ready <0,0x6>
[   20.844560] mwifiex_pcie 0000:02:00.0: Try 55 if FW is ready <0,0x6>
[   20.956785] mwifiex_pcie 0000:02:00.0: Try 56 if FW is ready <0,0x6>
[   21.068814] mwifiex_pcie 0000:02:00.0: Try 57 if FW is ready <0,0x6>
[   21.180845] mwifiex_pcie 0000:02:00.0: Try 58 if FW is ready <0,0x6>
[   21.292877] mwifiex_pcie 0000:02:00.0: Try 59 if FW is ready <0,0x6>
[   21.404904] mwifiex_pcie 0000:02:00.0: Try 60 if FW is ready <0,0x6>
[   21.516935] mwifiex_pcie 0000:02:00.0: Try 61 if FW is ready <0,0x6>
[   21.628966] mwifiex_pcie 0000:02:00.0: Try 62 if FW is ready <0,0x6>
[   21.741004] mwifiex_pcie 0000:02:00.0: Try 63 if FW is ready <0,0x6>
[   21.853024] mwifiex_pcie 0000:02:00.0: Try 64 if FW is ready <0,0x6>
[   21.965052] mwifiex_pcie 0000:02:00.0: Try 65 if FW is ready <0,0x6>
[   22.077082] mwifiex_pcie 0000:02:00.0: Try 66 if FW is ready <0,0x6>
[   22.189110] mwifiex_pcie 0000:02:00.0: Try 67 if FW is ready <0,0x6>
[   22.301144] mwifiex_pcie 0000:02:00.0: Try 68 if FW is ready <0,0x6>
[   22.413172] mwifiex_pcie 0000:02:00.0: Try 69 if FW is ready <0,0x6>
[   22.525202] mwifiex_pcie 0000:02:00.0: Try 70 if FW is ready <0,0x6>
[   22.637233] mwifiex_pcie 0000:02:00.0: Try 71 if FW is ready <0,0x6>
[   22.749261] mwifiex_pcie 0000:02:00.0: Try 72 if FW is ready <0,0x6>
[   22.861307] mwifiex_pcie 0000:02:00.0: Try 73 if FW is ready <0,0x6>
[   22.973333] mwifiex_pcie 0000:02:00.0: Try 74 if FW is ready <0,0x6>
[   23.085362] mwifiex_pcie 0000:02:00.0: Try 75 if FW is ready <0,0x6>
[   23.197417] mwifiex_pcie 0000:02:00.0: Try 76 if FW is ready <0,0x6>
[   23.309435] mwifiex_pcie 0000:02:00.0: Try 77 if FW is ready <0,0x6>
[   23.421467] mwifiex_pcie 0000:02:00.0: Try 78 if FW is ready <0,0x6>
[   23.533497] mwifiex_pcie 0000:02:00.0: Try 79 if FW is ready <0,0x6>
[   23.645520] mwifiex_pcie 0000:02:00.0: Try 80 if FW is ready <0,0x6>
[   23.757620] mwifiex_pcie 0000:02:00.0: Try 81 if FW is ready <0,0x6>
[   23.869595] mwifiex_pcie 0000:02:00.0: Try 82 if FW is ready <0,0x6>
[   23.981671] mwifiex_pcie 0000:02:00.0: Try 83 if FW is ready <0,0x6>
[   24.093647] mwifiex_pcie 0000:02:00.0: Try 84 if FW is ready <0,0x6>
[   24.205675] mwifiex_pcie 0000:02:00.0: Try 85 if FW is ready <0,0x6>
[   24.317686] mwifiex_pcie 0000:02:00.0: Try 86 if FW is ready <0,0x6>
[   24.429704] mwifiex_pcie 0000:02:00.0: Try 87 if FW is ready <0,0x6>
[   24.541735] mwifiex_pcie 0000:02:00.0: Try 88 if FW is ready <0,0x6>
[   24.653774] mwifiex_pcie 0000:02:00.0: Try 89 if FW is ready <0,0x6>
[   24.765801] mwifiex_pcie 0000:02:00.0: Try 90 if FW is ready <0,0x6>
[   24.877785] mwifiex_pcie 0000:02:00.0: Try 91 if FW is ready <0,0x6>
[   24.989855] mwifiex_pcie 0000:02:00.0: Try 92 if FW is ready <0,0x6>
[   25.101881] mwifiex_pcie 0000:02:00.0: Try 93 if FW is ready <0,0x6>
[   25.213914] mwifiex_pcie 0000:02:00.0: Try 94 if FW is ready <0,0x6>
[   25.325945] mwifiex_pcie 0000:02:00.0: Try 95 if FW is ready <0,0x6>
[   25.437973] mwifiex_pcie 0000:02:00.0: Try 96 if FW is ready <0,0x6>
[   25.550002] mwifiex_pcie 0000:02:00.0: Try 97 if FW is ready <0,0x6>
[   25.662032] mwifiex_pcie 0000:02:00.0: Try 98 if FW is ready <0,0x6>
[   25.667083] usb 1-4.2: device descriptor read/64, error -110
[   25.782069] mwifiex_pcie 0000:02:00.0: Try 99 if FW is ready <0,0x6>
[   25.850076] usb 1-4.2: new high-speed USB device number 4 using xhci_hcd
[   25.894091] mwifiex_pcie 0000:02:00.0: Try 100 if FW is ready <0,0x6>
[   26.006123] mwifiex_pcie 0000:02:00.0: Try 101 if FW is ready <0,0x6>
[   26.118151] mwifiex_pcie 0000:02:00.0: Try 102 if FW is ready <0,0x6>
[   26.230185] mwifiex_pcie 0000:02:00.0: Try 103 if FW is ready <0,0x6>
[   26.342211] mwifiex_pcie 0000:02:00.0: Try 104 if FW is ready <0,0x6>
[   26.454241] mwifiex_pcie 0000:02:00.0: Try 105 if FW is ready <0,0x6>
[   26.566271] mwifiex_pcie 0000:02:00.0: Try 106 if FW is ready <0,0x6>
[   26.678306] mwifiex_pcie 0000:02:00.0: Try 107 if FW is ready <0,0x6>
[   26.790339] mwifiex_pcie 0000:02:00.0: Try 108 if FW is ready <0,0x6>
[   26.902363] mwifiex_pcie 0000:02:00.0: Try 109 if FW is ready <0,0x6>
[   27.014392] mwifiex_pcie 0000:02:00.0: Try 110 if FW is ready <0,0x6>
[   27.126687] mwifiex_pcie 0000:02:00.0: Try 111 if FW is ready <0,0x6>
[   27.238453] mwifiex_pcie 0000:02:00.0: Try 112 if FW is ready <0,0x6>
[   27.350483] mwifiex_pcie 0000:02:00.0: Try 113 if FW is ready <0,0x6>
[   27.462512] mwifiex_pcie 0000:02:00.0: Try 114 if FW is ready <0,0x6>
[   27.574545] mwifiex_pcie 0000:02:00.0: Try 115 if FW is ready <0,0x6>
[   27.686569] mwifiex_pcie 0000:02:00.0: Try 116 if FW is ready <0,0x6>
[   27.798599] mwifiex_pcie 0000:02:00.0: Try 117 if FW is ready <0,0x6>
[   27.910820] mwifiex_pcie 0000:02:00.0: Try 118 if FW is ready <0,0x6>
[   28.023950] mwifiex_pcie 0000:02:00.0: Try 119 if FW is ready <0,0x6>
[   28.134694] mwifiex_pcie 0000:02:00.0: Try 120 if FW is ready <0,0x6>
[   28.246723] mwifiex_pcie 0000:02:00.0: Try 121 if FW is ready <0,0x6>
[   28.358747] mwifiex_pcie 0000:02:00.0: Try 122 if FW is ready <0,0x6>
[   28.470779] mwifiex_pcie 0000:02:00.0: Try 123 if FW is ready <0,0x6>
[   28.584336] mwifiex_pcie 0000:02:00.0: Try 124 if FW is ready <0,0x6>
[   28.694378] mwifiex_pcie 0000:02:00.0: Try 125 if FW is ready <0,0x6>
[   28.806605] mwifiex_pcie 0000:02:00.0: Try 126 if FW is ready <0,0x6>
[   28.918650] mwifiex_pcie 0000:02:00.0: Try 127 if FW is ready <0,0x6>
[   29.037477] mwifiex_pcie 0000:02:00.0: Try 128 if FW is ready <0,0x6>
[   29.150767] mwifiex_pcie 0000:02:00.0: Try 129 if FW is ready <0,0x6>
[   29.262555] mwifiex_pcie 0000:02:00.0: Try 130 if FW is ready <0,0x6>
[   29.374562] mwifiex_pcie 0000:02:00.0: Try 131 if FW is ready <0,0x6>
[   29.486832] mwifiex_pcie 0000:02:00.0: Try 132 if FW is ready <0,0x6>
[   29.598822] mwifiex_pcie 0000:02:00.0: Try 133 if FW is ready <0,0x6>
[   29.710855] mwifiex_pcie 0000:02:00.0: Try 134 if FW is ready <0,0x6>
[   29.822731] mwifiex_pcie 0000:02:00.0: Try 135 if FW is ready <0,0x6>
[   29.934761] mwifiex_pcie 0000:02:00.0: Try 136 if FW is ready <0,0x6>
[   30.047185] mwifiex_pcie 0000:02:00.0: Try 137 if FW is ready <0,0x6>
[   30.158815] mwifiex_pcie 0000:02:00.0: Try 138 if FW is ready <0,0x6>
[   30.271016] mwifiex_pcie 0000:02:00.0: Try 139 if FW is ready <0,0x6>
[   30.382854] mwifiex_pcie 0000:02:00.0: Try 140 if FW is ready <0,0x6>
[   30.494934] mwifiex_pcie 0000:02:00.0: Try 141 if FW is ready <0,0x6>
[   30.606949] mwifiex_pcie 0000:02:00.0: Try 142 if FW is ready <0,0x6>
[   30.718950] mwifiex_pcie 0000:02:00.0: Try 143 if FW is ready <0,0x6>
[   30.830977] mwifiex_pcie 0000:02:00.0: Try 144 if FW is ready <0,0x6>
[   30.943198] mwifiex_pcie 0000:02:00.0: Try 145 if FW is ready <0,0x6>
[   31.055039] mwifiex_pcie 0000:02:00.0: Try 146 if FW is ready <0,0x6>
[   31.167060] mwifiex_pcie 0000:02:00.0: Try 147 if FW is ready <0,0x6>
[   31.279149] mwifiex_pcie 0000:02:00.0: Try 148 if FW is ready <0,0x6>
[   31.299139] usb 1-4.2: device descriptor read/64, error -110
[   31.391128] mwifiex_pcie 0000:02:00.0: Try 149 if FW is ready <0,0x6>
[   31.503180] mwifiex_pcie 0000:02:00.0: FW failed to be active in time
[   31.509766] mwifiex_pcie 0000:02:00.0: info: mwifiex_fw_dpc: unregister device
[   31.517118] mwifiex_pcie 0000:02:00.0: mwifiex_unregister_dev(): calling free_irq()
[   34.555397] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   34.721265] Ebtables v2.0 registered
[   35.180409] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   35.258839] tun: Universal TUN/TAP device driver, 1.6
[   35.263968] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   35.317893] virbr0: port 1(virbr0-nic) entered blocking state
[   35.323733] virbr0: port 1(virbr0-nic) entered disabled state
[   35.330484] device virbr0-nic entered promiscuous mode
[   35.731136] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   36.274961] virbr0: port 1(virbr0-nic) entered blocking state
[   36.280795] virbr0: port 1(virbr0-nic) entered listening state
[   36.425084] virbr0: port 1(virbr0-nic) entered disabled state
[   36.467694] device virbr0-nic left promiscuous mode
[   36.472708] virbr0: port 1(virbr0-nic) entered disabled state
[   47.550858] usb 1-4.2: device descriptor read/64, error -110
[   47.734888] usb 1-4.2: new high-speed USB device number 5 using xhci_hcd
[   53.108292] xhci_hcd 0000:00:14.0: Command completion event does not match command
[   53.116708] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   58.741871] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   58.957883] usb 1-4.2: device not accepting address 5, error -62
[   59.039904] usb 1-4.2: new high-speed USB device number 6 using xhci_hcd
[   64.375277] xhci_hcd 0000:00:14.0: Command completion event does not match command
[   64.383018] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   70.008837] xhci_hcd 0000:00:14.0: Timeout while waiting for setup device command
[   70.224865] usb 1-4.2: device not accepting address 6, error -62
[   70.231111] usb 1-4-port2: unable to enumerate USB device

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-good-power-off-on.txt"

[    0.000000] Linux version 4.8.0-rc2+ (root@iot-r5s3-01.wlan.rhts.eng.bos.redhat.com) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-10) (GCC) ) #1 SMP Mon Aug 22 06:33:34 EDT 2016
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.8.0-rc2+ root=/dev/mapper/rhel_iot--r5s3--01-root ro crashkernel=auto rd.lvm.lv=rhel_iot-r5s3-01/root rd.lvm.lv=rhel_iot-r5s3-01/swap console=ttyS3,115200n81 LANG=en_US.UTF-8
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001effffff] usable
[    0.000000] BIOS-e820: [mem 0x000000001f000000-0x000000001f0fffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000001f100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000200fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020100000-0x0000000076e40fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000076e41000-0x0000000076e70fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000076e71000-0x0000000076e96fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000076e97000-0x0000000077420fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000077421000-0x000000007771efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007771f000-0x000000007771ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000077720000-0x0000000077761fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000077762000-0x00000000789e4fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000789e5000-0x0000000078ff9fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000078ffa000-0x0000000078ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed03000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed0c000-0x00000000fed0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff900000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000027fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: Dell Inc. Edge Gateway 5000/      , BIOS 00.03.08 11/09/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x280000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 079000000 mask FFF000000 uncachable
[    0.000000]   2 base 07A000000 mask FFE000000 uncachable
[    0.000000]   3 base 07C000000 mask FFC000000 uncachable
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask F80000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] total RAM covered: 8080M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 0G
[    0.000000] e820: update [mem 0x79000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x79000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd840-0x000fd84f] mapped at [ffff8800000fd840]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] BRK [0x02291000, 0x02291fff] PGTABLE
[    0.000000] BRK [0x02292000, 0x02292fff] PGTABLE
[    0.000000] BRK [0x02293000, 0x02293fff] PGTABLE
[    0.000000] BRK [0x02294000, 0x02294fff] PGTABLE
[    0.000000] BRK [0x02295000, 0x02295fff] PGTABLE
[    0.000000] BRK [0x02296000, 0x02296fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x3094f000-0x3449ffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0580 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x0000000076E89088 000094 (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x0000000076E95CB8 00010C (v05 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 128/32 (20160422/tbfadt-624)
[    0.000000] ACPI: DSDT 0x0000000076E891B0 00CB03 (v02 DELL   AS09     01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x0000000077420E80 000040
[    0.000000] ACPI: APIC 0x0000000076E95DC8 000068 (v03 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x0000000076E95E30 000044 (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x0000000076E95E78 00009C (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x0000000076E95F18 00003C (v01 DELL   AS09     01072009 MSFT 00000097)
[    0.000000] ACPI: LPIT 0x0000000076E95F58 000104 (v01 DELL   AS09     00000003 VLV2 0100000D)
[    0.000000] ACPI: HPET 0x0000000076E96060 000038 (v01 DELL   AS09     01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x0000000076E96098 000763 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076E96800 000290 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076E96A90 00017A (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 0x0000000076E96C10 000042 (v01 DELL   AS09     00000000      00000000)
[    0.000000] ACPI: SLIC 0x0000000076E96C58 000176 (v03 DELL   AS09     01072009 MSFT 00010013)
[    0.000000] ACPI: TCPA 0x0000000076E96DD0 000032 (v02 DELL   AS09     00000001 MSFT 01000013)
[    0.000000] ACPI: CSRT 0x0000000076E96E08 00014C (v00 DELL   AS09     00000005 INTL 20120624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000027fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x27ffcb000-0x27fff5fff]
[    0.000000] kexec_core: crashkernel: memory value expected
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000027fffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009bfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001effffff]
[    0.000000]   node   0: [mem 0x000000001f100000-0x000000001fffffff]
[    0.000000]   node   0: [mem 0x0000000020100000-0x0000000076e40fff]
[    0.000000]   node   0: [mem 0x000000007771f000-0x000000007771ffff]
[    0.000000]   node   0: [mem 0x0000000077762000-0x00000000789e4fff]
[    0.000000]   node   0: [mem 0x0000000078ffa000-0x0000000078ffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000027fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000027fffffff]
[    0.000000] On node 0 totalpages: 2063974
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7612 pages used for memmap
[    0.000000]   DMA32 zone: 487115 pages, LIFO batch:31
[    0.000000]   Normal zone: 24576 pages used for memmap
[    0.000000]   Normal zone: 1572864 pages, LIFO batch:31
[    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
[    0.000000] Reserving Intel graphics memory at 0x000000007b000000-0x000000007effffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-86
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x1f000000-0x1f0fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x200fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e41000-0x76e70fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e71000-0x76e96fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e97000-0x77420fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77421000-0x7771efff]
[    0.000000] PM: Registered nosave memory: [mem 0x77720000-0x77761fff]
[    0.000000] PM: Registered nosave memory: [mem 0x789e5000-0x78ff9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79000000-0x7affffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b000000-0x7effffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7f000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed01fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed02000-0xfed02fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed03000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed07fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed0c000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1d000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xff8fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff900000-0xffffffff]
[    0.000000] e820: [mem 0x7f000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 36 pages/cpu @ffff88027fc00000 s107608 r8192 d31656 u1048576
[    0.000000] pcpu-alloc: s107608 r8192 d31656 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2031701
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.8.0-rc2+ root=/dev/mapper/rhel_iot--r5s3--01-root ro crashkernel=auto rd.lvm.lv=rhel_iot-r5s3-01/root rd.lvm.lv=rhel_iot-r5s3-01/swap console=ttyS3,115200n81 LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 3916164K/8255896K available (7121K kernel code, 1532K rwdata, 3184K rodata, 1868K init, 3280K bss, 277736K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS3] enabled
[    0.000000] tsc: Detected 1749.300 MHz processor
[    0.000034] Calibrating delay loop (skipped), value calculated using timer frequency.. 3498.60 BogoMIPS (lpj=1749300)
[    0.000469] pid_max: default: 32768 minimum: 301
[    0.000676] ACPI: Core revision 20160422
[    0.030012] ACPI: 4 ACPI AML tables successfully acquired and loaded

[    0.030399] Security Framework initialized
[    0.030572] SELinux:  Initializing.
[    0.030728] SELinux:  Starting in permissive mode
[    0.031880] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.036438] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.038637] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.038964] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.039816] CPU: Physical Processor ID: 0
[    0.039986] CPU: Processor Core ID: 0
[    0.040143] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.040387] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.040679] mce: CPU supports 6 MCE banks
[    0.040864] CPU0: Thermal monitoring enabled (TM1)
[    0.041067] process: using mwait in idle threads
[    0.041261] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.041482] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.042685] Freeing SMP alternatives memory: 28K (ffffffff81f54000 - ffffffff81f5b000)
[    0.046039] ftrace: allocating 27933 entries in 110 pages
[    0.064020] smpboot: Max logical packages: 1
[    0.064202] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.065145] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.075404] TSC deadline timer enabled
[    0.075409] smpboot: CPU0: Intel(R) Atom(TM) CPU  E3827  @ 1.74GHz (family: 0x6, model: 0x37, stepping: 0x9)
[    0.075830] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, 8-deep LBR, full-width counters, Intel PMU driver.
[    0.076352] ... version:                3
[    0.076525] ... bit width:              40
[    0.076694] ... generic registers:      2
[    0.076860] ... value mask:             000000ffffffffff
[    0.077076] ... max period:             000000ffffffffff
[    0.077292] ... fixed-purpose events:   3
[    0.077458] ... event mask:             0000000700000003
[    0.079067] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.079717] x86: Booting SMP configuration:
[    0.079894] .... node  #0, CPUs:      #1
[    0.142033] x86: Booted up 1 node, 2 CPUs
[    0.142216] smpboot: Total of 2 processors activated (7005.33 BogoMIPS)
[    0.192638] node 0 initialised, 1015499 pages in 49ms
[    0.194117] devtmpfs: initialized
[    0.194388] x86/mm: Memory block size: 128MB
[    0.203561] evm: security.selinux
[    0.203704] evm: security.ima
[    0.203829] evm: security.capability
[    0.204162] PM: Registering ACPI NVS region [mem 0x76e97000-0x77420fff] (5808128 bytes)
[    0.204806] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.205285] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.205568] pinctrl core: initialized pinctrl subsystem
[    0.206065] NET: Registered protocol family 16
[    0.209286] cpuidle: using governor menu
[    0.209555] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.209862] ACPI: bus type PCI registered
[    0.210029] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.210423] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.210799] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.211106] PCI: Using configuration type 1 for base access
[    0.211354] dmi type 0xB1 record - unknown flag
[    0.218719] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.219523] ACPI: Added _OSI(Module Device)
[    0.219699] ACPI: Added _OSI(Processor Device)
[    0.219882] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.220075] ACPI: Added _OSI(Processor Aggregator Device)
[    0.233730] ACPI: Dynamic OEM Table Load:
[    0.233925] ACPI: SSDT 0xFFFF88027FBFC800 000338 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.235708] ACPI: Dynamic OEM Table Load:
[    0.235897] ACPI: SSDT 0xFFFF88017EF11800 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.238195] ACPI: Dynamic OEM Table Load:
[    0.238383] ACPI: SSDT 0xFFFF88027F7F5000 00015F (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.240117] ACPI: Dynamic OEM Table Load:
[    0.240304] ACPI: SSDT 0xFFFF88027FE69540 00008D (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.244160] ACPI: Interpreter enabled
[    0.244357] ACPI: (supports S0 S4 S5)
[    0.244511] ACPI: Using IOAPIC for interrupt routing
[    0.244797] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.262306] ACPI: Power Resource [USBC] (on)
[    0.264601] ACPI: Power Resource [PLPE] (on)
[    0.265301] ACPI: Power Resource [PLPE] (on)
[    0.275825] ACPI: Power Resource [CLK0] (on)
[    0.276115] ACPI: Power Resource [CLK1] (on)
[    0.349269] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.349545] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.350228] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.350861] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.351131] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.352488] PCI host bridge to bus 0000:00
[    0.352673] pci_bus 0000:00: root bus resource [io  0x0070-0x0077]
[    0.352927] pci_bus 0000:00: root bus resource [io  0x0000-0x006f window]
[    0.353203] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7 window]
[    0.353479] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.353761] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.354065] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.354368] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff window]
[    0.354671] pci_bus 0000:00: root bus resource [mem 0x80000000-0x90a15ffe window]
[    0.354980] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.355216] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.355505] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.355521] pci 0000:00:02.0: reg 0x10: [mem 0x90000000-0x903fffff]
[    0.355534] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x8fffffff pref]
[    0.355546] pci 0000:00:02.0: reg 0x20: [io  0xe080-0xe087]
[    0.355833] pci 0000:00:13.0: [8086:0f23] type 00 class 0x010601
[    0.355853] pci 0000:00:13.0: reg 0x10: [io  0xe070-0xe077]
[    0.355864] pci 0000:00:13.0: reg 0x14: [io  0xe060-0xe063]
[    0.355874] pci 0000:00:13.0: reg 0x18: [io  0xe050-0xe057]
[    0.355884] pci 0000:00:13.0: reg 0x1c: [io  0xe040-0xe043]
[    0.355895] pci 0000:00:13.0: reg 0x20: [io  0xe020-0xe03f]
[    0.355905] pci 0000:00:13.0: reg 0x24: [mem 0x90a15000-0x90a157ff]
[    0.355959] pci 0000:00:13.0: PME# supported from D3hot
[    0.356213] pci 0000:00:14.0: [8086:0f35] type 00 class 0x0c0330
[    0.356235] pci 0000:00:14.0: reg 0x10: [mem 0x90a00000-0x90a0ffff 64bit]
[    0.356304] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.356514] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.356843] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.356868] pci 0000:00:1a.0: reg 0x10: [mem 0x90500000-0x905fffff]
[    0.356883] pci 0000:00:1a.0: reg 0x14: [mem 0x90400000-0x904fffff]
[    0.357001] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.357300] pci 0000:00:1b.0: [8086:0f04] type 00 class 0x040300
[    0.357324] pci 0000:00:1b.0: reg 0x10: [mem 0x90a10000-0x90a13fff 64bit]
[    0.357406] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.357649] pci 0000:00:1c.0: [8086:0f48] type 01 class 0x060400
[    0.357722] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.357901] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.358226] pci 0000:00:1c.1: [8086:0f4a] type 01 class 0x060400
[    0.358298] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.358475] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.358785] pci 0000:00:1c.2: [8086:0f4c] type 01 class 0x060400
[    0.358857] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.359033] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.359351] pci 0000:00:1c.3: [8086:0f4e] type 01 class 0x060400
[    0.359423] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.359596] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.359912] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.360230] pci 0000:00:1f.3: [8086:0f12] type 00 class 0x0c0500
[    0.360265] pci 0000:00:1f.3: reg 0x10: [mem 0x90a14000-0x90a1401f]
[    0.360347] pci 0000:00:1f.3: reg 0x20: [io  0xe000-0xe01f]
[    0.360783] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    0.360806] pci 0000:01:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.360836] pci 0000:01:00.0: reg 0x18: [mem 0x90904000-0x90904fff 64bit]
[    0.360856] pci 0000:01:00.0: reg 0x20: [mem 0x90900000-0x90903fff 64bit pref]
[    0.360956] pci 0000:01:00.0: supports D1 D2
[    0.360959] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.361020] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.364326] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.364534] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.364539] pci 0000:00:1c.0:   bridge window [mem 0x90900000-0x909fffff]
[    0.364650] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.364674] pci 0000:02:00.0: reg 0x10: [io  0xc000-0xc0ff]
[    0.364704] pci 0000:02:00.0: reg 0x18: [mem 0x90804000-0x90804fff 64bit]
[    0.364723] pci 0000:02:00.0: reg 0x20: [mem 0x90800000-0x90803fff 64bit pref]
[    0.364823] pci 0000:02:00.0: supports D1 D2
[    0.364826] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.364887] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.367334] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.367542] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.367547] pci 0000:00:1c.1:   bridge window [mem 0x90800000-0x908fffff]
[    0.367682] pci 0000:03:00.0: [11ab:2b38] type 00 class 0x020000
[    0.367717] pci 0000:03:00.0: reg 0x10: [mem 0x90700000-0x907fffff 64bit pref]
[    0.367741] pci 0000:03:00.0: reg 0x18: [mem 0x90600000-0x906fffff 64bit pref]
[    0.367894] pci 0000:03:00.0: supports D1 D2
[    0.367897] pci 0000:03:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.367971] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.370361] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.370571] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.370664] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.373561] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 12 14 15)
[    0.374038] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 *4 5 6 12 14 15)
[    0.374521] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 12 14 15)
[    0.374992] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 12 14 15)
[    0.375473] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 5 6 12 14 15)
[    0.375944] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 12 14 15)
[    0.376425] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 12 14 15)
[    0.376897] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 12 14 15) *0, disabled.
[    0.382683] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.383146] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.383381] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.383726] vgaarb: loaded
[    0.383842] vgaarb: bridge control possible 0000:00:02.0
[    0.384187] SCSI subsystem initialized
[    0.384400] ACPI: bus type USB registered
[    0.384608] usbcore: registered new interface driver usbfs
[    0.384868] usbcore: registered new interface driver hub
[    0.385121] usbcore: registered new device driver usb
[    0.385580] PCI: Using ACPI for IRQ routing
[    0.392026] PCI: pci_cache_line_size set to 64 bytes
[    0.392099] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.392102] e820: reserve RAM buffer [mem 0x1f000000-0x1fffffff]
[    0.392104] e820: reserve RAM buffer [mem 0x76e41000-0x77ffffff]
[    0.392106] e820: reserve RAM buffer [mem 0x77720000-0x77ffffff]
[    0.392108] e820: reserve RAM buffer [mem 0x789e5000-0x7bffffff]
[    0.392110] e820: reserve RAM buffer [mem 0x79000000-0x7bffffff]
[    0.392331] NetLabel: Initializing
[    0.392475] NetLabel:  domain hash size = 128
[    0.392654] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.392893] NetLabel:  unlabeled traffic allowed by default
[    0.393314] clocksource: Switched to clocksource refined-jiffies
[    0.411176] VFS: Disk quotas dquot_6.6.0
[    0.411377] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.411833] pnp: PnP ACPI init
[    0.412072] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.412370] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.412615] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.412858] system 00:01: [io  0x0500-0x05fe] has been reserved
[    0.413105] system 00:01: [io  0x0600-0x061f] has been reserved
[    0.413363] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.413781] system 00:02: [io  0x0a00-0x0a0f] has been reserved
[    0.414025] system 00:02: [io  0x0a10-0x0a1f] has been reserved
[    0.414268] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    0.414524] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.415099] ACPI: IRQ 10 override to edge, high
[    0.415294] pnp 00:03: [dma 0 disabled]
[    0.415362] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.415899] ACPI: IRQ 11 override to edge, high
[    0.416092] pnp 00:04: [dma 0 disabled]
[    0.416161] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.416691] ACPI: IRQ 10 override to edge, high
[    0.416884] pnp 00:05: [dma 0 disabled]
[    0.416948] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.418021] ACPI: IRQ 7 override to edge, high
[    0.418212] pnp 00:06: [dma 0 disabled]
[    0.418281] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.418945] system 00:07: [mem 0xe0000000-0xefffffff] could not be reserved
[    0.419231] system 00:07: [mem 0xfed01000-0xfed01fff] has been reserved
[    0.419501] system 00:07: [mem 0xfed03000-0xfed03fff] has been reserved
[    0.419782] system 00:07: [mem 0xfed04000-0xfed04fff] has been reserved
[    0.420053] system 00:07: [mem 0xfed0c000-0xfed0ffff] could not be reserved
[    0.420336] system 00:07: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.420606] system 00:07: [mem 0xfed1c000-0xfed1cfff] has been reserved
[    0.420883] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.421166] system 00:07: [mem 0xfef00000-0xfeffffff] has been reserved
[    0.421440] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.424219] pnp 00:08: Plug and Play ACPI device, IDs PNP0c31 (active)
[    0.424239] pnp: PnP ACPI: found 9 devices
[    0.433232] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.433613] clocksource: Switched to clocksource acpi_pm
[    0.433852] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000 add_align 100000
[    0.433864] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
[    0.433874] pci 0000:00:1c.2: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.433878] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 add_align 100000
[    0.433888] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[    0.433892] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000 add_align 100000
[    0.433896] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff] to [bus 04] add_size 200000 add_align 100000
[    0.433909] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433913] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433917] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433921] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433924] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433928] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433931] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x000fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.433935] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x002fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.433939] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433942] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433946] pci 0000:00:1c.2: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.433949] pci 0000:00:1c.2: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.433953] pci 0000:00:1c.3: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.433956] pci 0000:00:1c.3: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.433970] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.434326] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.434679] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.434989] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.435319] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.435649] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.435977] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.436250] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.436543] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.436872] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.437200] pci 0000:00:1c.2: BAR 13: assigned [io  0x1000-0x1fff]
[    0.437455] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
[    0.437733] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.438006] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.438298] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.438608] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.438958] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.439268] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.439598] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.439927] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.440258] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.440568] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.440911] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.441118] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.441370] pci 0000:00:1c.0:   bridge window [mem 0x90900000-0x909fffff]
[    0.441671] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.441877] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.442128] pci 0000:00:1c.1:   bridge window [mem 0x90800000-0x908fffff]
[    0.442409] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.442614] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.442884] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.443166] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.443372] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.443648] pci_bus 0000:00: resource 4 [io  0x0070-0x0077]
[    0.443651] pci_bus 0000:00: resource 5 [io  0x0000-0x006f window]
[    0.443654] pci_bus 0000:00: resource 6 [io  0x0078-0x0cf7 window]
[    0.443657] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.443660] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.443663] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.443666] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000fffff window]
[    0.443669] pci_bus 0000:00: resource 11 [mem 0x80000000-0x90a15ffe window]
[    0.443672] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.443675] pci_bus 0000:01: resource 1 [mem 0x90900000-0x909fffff]
[    0.443678] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.443680] pci_bus 0000:02: resource 1 [mem 0x90800000-0x908fffff]
[    0.443684] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.443686] pci_bus 0000:03: resource 1 [mem 0x90600000-0x907fffff]
[    0.443689] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.443750] NET: Registered protocol family 2
[    0.444363] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.445021] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.445691] TCP: Hash tables configured (established 65536 bind 65536)
[    0.446043] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.446375] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.446844] NET: Registered protocol family 1
[    0.447056] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.447828] PCI: CLS 64 bytes, default 64
[    0.447957] Unpacking initramfs...
[    2.365351] Freeing initrd memory: 60740K (ffff88003094f000 - ffff8800344a0000)
[    2.365711] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.365975] software IO TLB [mem 0x72e41000-0x76e41000] (64MB) mapped at [ffff880072e41000-ffff880076e40fff]
[    2.368207] futex hash table entries: 512 (order: 3, 32768 bytes)
[    2.368525] audit: initializing netlink subsys (disabled)
[    2.368778] audit: type=2000 audit(1472121595.355:1): initialized
[    2.369752] Initialise system trusted keyrings
[    2.370114] workingset: timestamp_bits=36 max_order=21 bucket_order=0
[    2.374535] zbud: loaded
[    2.375192] Key type big_key registered
[    2.375354] SELinux:  Registering netfilter hooks
[    2.503240] NET: Registered protocol family 38
[    2.503430] Key type asymmetric registered
[    2.503639] Asymmetric key parser 'x509' registered
[    2.503946] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    2.504325] io scheduler noop registered
[    2.504544] io scheduler deadline registered (default)
[    2.504774] io scheduler cfq registered
[    2.505949] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.506190] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.506550] intel_idle: MWAIT substates: 0x3000020
[    2.506552] intel_idle: v0.4.1 model 0x37
[    2.506684] intel_idle: lapic_timer_reliable_states 0xffffffff
[    2.506866] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    2.507207] ACPI: Sleep Button [SLPB]
[    2.507492] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.507794] ACPI: Power Button [PWRF]
[    2.511516] GHES: HEST is not enabled!
[    2.511828] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.533509] 00:03: ttyS0 at I/O 0x3e0 (irq = 10, base_baud = 115200) is a 16550A
[    2.555219] 00:04: ttyS1 at I/O 0x2e0 (irq = 11, base_baud = 115200) is a 16550A
[    2.576945] 00:05: ttyS2 at I/O 0x3e8 (irq = 10, base_baud = 115200) is a 16550A
[    2.598685] 00:06: ttyS3 at I/O 0x2d0 (irq = 7, base_baud = 115200) is a 16550A
[    2.606701] hpet: number irqs doesn't agree with number of timers
[    2.613003] Non-volatile memory driver v1.3
[    2.617297] Linux agpgart interface v0.103
[    2.635984] tpm_tis 00:08: 1.2 TPM (device-id 0xFE, rev-id 2)
[    2.727088] rdac: device handler registered
[    2.732395] hp_sw: device handler registered
[    2.736726] emc: device handler registered
[    2.742933] alua: device handler registered
[    2.747287] libphy: Fixed MDIO Bus: probed
[    2.751781] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.758369] ehci-pci: EHCI PCI platform driver
[    2.762889] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.769128] ohci-pci: OHCI PCI platform driver
[    2.773634] uhci_hcd: USB Universal Host Controller Interface driver
[    2.780320] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.785717] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    2.794279] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    2.802788] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.802961] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.809810] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.817087] usb usb1: Product: xHCI Host Controller
[    2.822008] usb usb1: Manufacturer: Linux 4.8.0-rc2+ xhci-hcd
[    2.827804] usb usb1: SerialNumber: 0000:00:14.0
[    2.832763] hub 1-0:1.0: USB hub found
[    2.836599] hub 1-0:1.0: 6 ports detected
[    2.841671] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.847049] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    2.854863] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.861713] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.868992] usb usb2: Product: xHCI Host Controller
[    2.873914] usb usb2: Manufacturer: Linux 4.8.0-rc2+ xhci-hcd
[    2.879707] usb usb2: SerialNumber: 0000:00:14.0
[    2.884659] hub 2-0:1.0: USB hub found
[    2.888467] hub 2-0:1.0: 1 port detected
[    2.892807] usbcore: registered new interface driver usbserial
[    2.898717] usbcore: registered new interface driver usbserial_generic
[    2.905310] usbserial: USB Serial support registered for generic
[    2.911429] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.919400] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.924444] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.930054] mousedev: PS/2 mouse device common for all mice
[    2.936919] rtc_cmos 00:00: RTC can wake from S4
[    2.942109] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.948389] rtc_cmos 00:00: alarms up to one month, y3k, 242 bytes nvram
[    2.955178] intel_pstate: Intel P-state driver initializing
[    2.963779] hidraw: raw HID events driver (C) Jiri Kosina
[    2.970077] usbcore: registered new interface driver usbhid
[    2.975750] usbhid: USB HID core driver
[    2.979988] drop_monitor: Initializing network drop monitor service
[    2.986969] Initializing XFRM netlink socket
[    2.991737] NET: Registered protocol family 10
[    2.998092] NET: Registered protocol family 17
[    3.003593] microcode: sig=0x30679, pf=0x1, revision=0x905
[    3.009202] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.018496] registered taskstats version 1
[    3.022644] Loading compiled-in X.509 certificates
[    3.034947] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
[    3.044782] Loaded X.509 cert 'Build time autogenerated kernel key: 9518684b013c6df000e78d3f046bb6acff340d12'
[    3.055010] zswap: loaded using pool lzo/zbud
[    3.113940] Key type trusted registered
[    3.130440] Key type encrypted registered
[    3.215165] usb 1-4: new high-speed USB device number 2 using xhci_hcd
[    3.274483] evm: HMAC attrs: 0x1
[    3.279868] rtc_cmos 00:00: setting system clock to 2016-08-25 10:39:56 UTC (1472121596)
[    3.294814] Freeing unused kernel memory: 1868K (ffffffff81d81000 - ffffffff81f54000)
[    3.302735] Write protecting the kernel read-only data: 12288k
[    3.310381] Freeing unused kernel memory: 1056K (ffff8800016f8000 - ffff880001800000)
[    3.324408] Freeing unused kernel memory: 912K (ffff880001b1c000 - ffff880001c00000)
[    3.348162] random: systemd: uninitialized urandom read (16 bytes read)
[    3.356291] random: systemd: uninitialized urandom read (16 bytes read)
[    3.371985] tsc: Refined TSC clocksource calibration: 1749.999 MHz
[    3.378506] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1939a77ee81, max_idle_ns: 440795244944 ns
[    3.393518] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    3.412173] usb 1-4: New USB device found, idVendor=0424, idProduct=2514
[    3.418944] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.426413] systemd[1]: Detected architecture x86-64.
[    3.431547] systemd[1]: Running in initial RAM disk.
[    3.437058] hub 1-4:1.0: USB hub found
[    3.441459] hub 1-4:1.0: 4 ports detected
[    3.457954] systemd[1]: Set hostname to <localhost.localdomain>.
[    3.624474] random: systemd: uninitialized urandom read (16 bytes read)
[    3.631416] random: systemd: uninitialized urandom read (16 bytes read)
[    3.638302] random: systemd: uninitialized urandom read (16 bytes read)
[    3.645315] random: systemd: uninitialized urandom read (16 bytes read)
[    3.654189] random: systemd: uninitialized urandom read (16 bytes read)
[    3.661692] random: systemd: uninitialized urandom read (16 bytes read)
[    3.668987] random: systemd: uninitialized urandom read (16 bytes read)
[    3.677432] random: systemd: uninitialized urandom read (16 bytes read)
[    3.703478] systemd[1]: Reached target Local File Systems.
[    3.709082] systemd[1]: Starting Local File Systems.
[    3.722229] systemd[1]: Created slice Root Slice.
[    3.727035] systemd[1]: Starting Root Slice.
[    3.739505] systemd[1]: Created slice System Slice.
[    3.744471] usb 1-4.2: new high-speed USB device number 3 using xhci_hcd
[    3.751291] systemd[1]: Starting System Slice.
[    3.847418] usb 1-4.2: New USB device found, idVendor=1286, idProduct=2045
[    3.855709] usb 1-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.864429] usb 1-4.2: Product: Marvell Wireless Device
[    3.870379] usb 1-4.2: Manufacturer: Marvell
[    3.874691] usb 1-4.2: SerialNumber: 0000000000000000
[    4.396867] device-mapper: uevent: version 1.0.3
[    4.401713] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
[    4.412689] clocksource: Switched to clocksource tsc
[    4.930691] sdhci: Secure Digital Host Controller Interface driver
[    4.936930] sdhci: Copyright(c) Pierre Ossman
[    4.978715] FUJITSU Extended Socket Network Device Driver - version 1.1 - Copyright (c) 2015 FUJITSU LIMITED
[    5.183405] [drm] Initialized drm 1.1.0 20060810
[    5.258374] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.294933] r8169 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM control
[    5.323374] r8169 0000:01:00.0 eth0: RTL8168f/8111f at 0xffffc90000e6c000, 74:e6:e2:e5:05:f8, XID 08100880 IRQ 262
[    5.333797] r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.343803] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.349496] libata version 3.00 loaded.
[    5.358040] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[    5.378070] r8169 0000:02:00.0 eth1: RTL8168f/8111f at 0xffffc90000e68000, 74:e6:e2:e5:05:f9, XID 08100800 IRQ 263
[    5.388490] r8169 0000:02:00.0 eth1: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.400896] ahci 0000:00:13.0: version 3.0
[    5.401115] ahci 0000:00:13.0: controller can't do DEVSLP, turning off
[    5.418841] ahci 0000:00:13.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    5.426992] ahci 0000:00:13.0: flags: 64bit ncq pm led clo pio slum part deso 
[    5.452204] r8169 0000:01:00.0: invalid large VPD tag 7f at offset 0
[    5.460607] r8169 0000:02:00.0: invalid large VPD tag 7f at offset 0
[    5.480535] scsi host0: ahci
[    5.488189] r8169 0000:02:00.0 p4p2: renamed from eth1
[    5.498681] scsi host1: ahci
[    5.502271] ata1: SATA max UDMA/133 abar m2048@0x90a15000 port 0x90a15100 irq 264
[    5.509818] ata2: SATA max UDMA/133 abar m2048@0x90a15000 port 0x90a15180 irq 264
[    5.812886] r8169 0000:01:00.0 p4p1: renamed from eth0
[    5.826011] [drm] Memory usable by graphics device = 2048M
[    5.831568] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.837815] [drm] Replacing VGA console driver
[    5.842411] ata1.00: ATA-8: LITEON J8-L1064-11 M.2 2260 64GB, 0J61104, max UDMA/133
[    5.842414] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    5.843248] Console: switching to colour dummy device 80x25
[    5.851063] random: fast init done
[    5.851144] ata1.00: configured for UDMA/133
[    5.851389] scsi 0:0:0:0: Direct-Access     ATA      LITEON J8-L1064- 104  PQ: 0 ANSI: 5
[    5.880327] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    5.886995] [drm] Driver supports precise vblank timestamp query.
[    5.893625] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    5.918661] ata2: SATA link down (SStatus 0 SControl 300)
[    5.948267] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    5.956554] sd 0:0:0:0: [sda] Write Protect is off
[    5.961415] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.962332] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.972876]  sda: sda1 sda2
[    5.976510] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.367145] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    6.376649] acpi device:09: registered as cooling_device2
[    6.382729] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    6.805607] i915 0000:00:02.0: No connectors reported connected with modes
[    6.812587] [drm] Cannot find any crtc or sizes - going 1024x768
[    6.820834] fbcon: inteldrmfb (fb0) is primary device
[    6.855473] Console: switching to colour frame buffer device 128x48
[    6.883316] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    8.015971] SGI XFS with ACLs, security attributes, no debug enabled
[    8.032398] XFS (dm-0): Mounting V5 Filesystem
[    8.087753] XFS (dm-0): Starting recovery (logdev: internal)
[    8.115221] XFS (dm-0): Ending recovery (logdev: internal)
[    8.745442] systemd-journald[138]: Received SIGTERM from PID 1 (systemd).
[    8.809224] systemd: 24 output lines suppressed due to ratelimiting
[    8.856952] audit: type=1404 audit(1472121602.073:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    8.904816] SELinux: 32768 avtab hash slots, 104828 rules.
[    8.945639] SELinux: 32768 avtab hash slots, 104828 rules.
[    9.038839] SELinux:  8 users, 14 roles, 4982 types, 301 bools, 1 sens, 1024 cats
[    9.038846] SELinux:  91 classes, 104828 rules
[    9.047973] SELinux:  Permission validate_trans in class security not defined in policy.
[    9.056151] SELinux:  Permission module_load in class system not defined in policy.
[    9.064074] SELinux:  Class binder not defined in policy.
[    9.069501] SELinux:  Class cap_userns not defined in policy.
[    9.075275] SELinux:  Class cap2_userns not defined in policy.
[    9.081139] SELinux: the above unknown classes and permissions will be allowed
[    9.088410] SELinux:  Completing initialization.
[    9.088411] SELinux:  Setting up existing superblocks.
[    9.105920] audit: type=1403 audit(1472121602.322:3): policy loaded auid=4294967295 ses=4294967295
[    9.124019] systemd[1]: Successfully loaded SELinux policy in 266.995ms.
[    9.152682] systemd[1]: RTC configured in localtime, applying delta of -240 minutes to system time.
[    9.191248] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.197089] systemd[1]: Inserted module 'ip_tables'
[    9.307122] systemd[1]: Relabelled /dev and /run in 101.136ms.
[    9.909258] systemd-journald[536]: Received request to flush runtime journal from PID 1
[   10.021886] RPC: Registered named UNIX socket transport module.
[   10.027868] RPC: Registered udp transport module.
[   10.032614] RPC: Registered tcp transport module.
[   10.032616] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   10.400169] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   10.683771] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.705364] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.722923] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   10.851636] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   11.016702] XFS (sda1): Mounting V5 Filesystem
[   11.147379] XFS (sda1): Ending clean mount
[   11.248656] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   11.348492] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[   11.387336] SSE version of gcm_enc/dec engaged.
[   11.442629] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   11.453193] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   11.708441] mwifiex_pcie: try set_consistent_dma_mask(32)
[   11.737777] mwifiex_pcie: PCI memory map Virt0: ffffc90001800000 PCI memory map Virt2: ffffc90001a00000
[   11.747339] mwifiex: rx work enabled, cpus 2
[   11.751969] mwifiex_pcie 0000:03:00.0: msi_enable = 1
[   11.893874] mwifiex_pcie 0000:03:00.0: Setting driver ready signature
[   11.893884] mwifiex_pcie 0000:03:00.0: Try 0 if FW is ready <0,0x0>
[   11.916631] Adding 6254588k swap on /dev/mapper/rhel_iot--r5s3--01-swap.  Priority:-1 extents:1 across:6254588k SSFS
[   11.999279] mwifiex_pcie 0000:03:00.0: PCI-E is the winner
[   11.999283] mwifiex_pcie 0000:03:00.0: info: Downloading FW image (803884 bytes)
[   12.016293] intel_rapl: Found RAPL domain package
[   12.016295] intel_rapl: Found RAPL domain core
[   13.234942] mwifiex_pcie 0000:03:00.0: info: FW download over, size 803884 bytes
[   13.234948] mwifiex_pcie 0000:03:00.0: Setting driver ready signature
[   13.234964] mwifiex_pcie 0000:03:00.0: Try 0 if FW is ready <0,0x6>
[   13.344223] mwifiex_pcie 0000:03:00.0: Try 1 if FW is ready <0,0x6>
[   13.355192] usb 1-4.2: USB disconnect, device number 3
[   13.448257] mwifiex_pcie 0000:03:00.0: Try 2 if FW is ready <0,0x6>
[   13.523231] XFS (dm-2): Mounting V5 Filesystem
[   13.545710] XFS (dm-2): Ending clean mount
[   13.553618] mwifiex_pcie 0000:03:00.0: Try 3 if FW is ready <0,0x6>
[   13.661920] usb 1-4.2: new high-speed USB device number 4 using xhci_hcd
[   13.668945] mwifiex_pcie 0000:03:00.0: Try 4 if FW is ready <0,0x6>
[   13.762327] usb 1-4.2: New USB device found, idVendor=1286, idProduct=2046
[   13.769320] usb 1-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   13.776734] usb 1-4.2: Product: Bluetooth and Wireless LAN Composite Device
[   13.783771] usb 1-4.2: Manufacturer: Marvell
[   13.784361] mwifiex_pcie 0000:03:00.0: Try 5 if FW is ready <0,0x6>
[   13.794408] usb 1-4.2: SerialNumber: 0000000000000000
[   14.005456] mwifiex_pcie 0000:03:00.0: Try 6 if FW is ready <0,0xfedcba00>
[   14.012409] mwifiex_pcie 0000:03:00.0: WLAN FW is active
[   14.018621] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xfa, cmd_pending=1
[   14.033887] Bluetooth: Core ver 2.21
[   14.037537] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xfa, act 0x1000, len 52, seqno 0x1
[   14.046380] NET: Registered protocol family 31
[   14.050871] Bluetooth: HCI device and connection manager initialized
[   14.057397] Bluetooth: HCI socket layer initialized
[   14.062383] Bluetooth: L2CAP socket layer initialized
[   14.067556] Bluetooth: SCO socket layer initialized
[   14.082162] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.088133] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.093854] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.100175] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80fa, result 0, len 52, seqno 0x1
[   14.108407] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.114290] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xfa, cmd_pending=0
[   14.122128] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xa9, cmd_pending=1
[   14.129435] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xa9, act 0x0, len 8, seqno 0x2
[   14.187975] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.193950] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.199674] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.205987] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80a9, result 0, len 8, seqno 0x2
[   14.214134] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.220017] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xa9, cmd_pending=0
[   14.222265] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x3, cmd_pending=1
[   14.234394] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x3, act 0x0, len 71, seqno 0x3
[   14.242760] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.248738] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.248757] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.248761] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8003, result 0, len 87, seqno 0x3
[   14.248764] mwifiex_pcie 0000:03:00.0: key_api v2.0
[   14.248767] mwifiex_pcie 0000:03:00.0: Firmware api version 15
[   14.248769] mwifiex_pcie 0000:03:00.0: info: GET_HW_SPEC: fw_release_number- 0x350f4407
[   14.248772] mwifiex_pcie 0000:03:00.0: info: GET_HW_SPEC: permanent addr: 98:f1:70:6f:55:af
[   14.248775] mwifiex_pcie 0000:03:00.0: info: GET_HW_SPEC: hw_if_version=0x2 version=0x4021
[   14.248778] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.248785] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x3, cmd_pending=0
[   14.257180] mwifiex_pcie 0000:03:00.0: cmd: set tx_buf=4096
[   14.257184] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xd9, cmd_pending=1
[   14.257223] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xd9, act 0x1, len 16, seqno 0x4
[   14.265216] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.265219] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.265231] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.265237] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80d9, result 0, len 16, seqno 0x4
[   14.265240] mwifiex_pcie 0000:03:00.0: cmd: curr_tx_buf_size=3584
[   14.265244] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.265253] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xd9, cmd_pending=0
[   14.265646] mwifiex_pcie 0000:03:00.0: cmd: PS Command: Enter PS
[   14.265651] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xe4, cmd_pending=1
[   14.265677] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xe4, act 0xff, len 30, seqno 0x5
[   14.266343] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.266346] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.266356] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.266361] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80e4, result 0, len 30, seqno 0x5
[   14.266365] mwifiex_pcie 0000:03:00.0: info: mwifiex_ret_enh_power_mode: PS_MODE cmd reply result=0x0 action=0XFF
[   14.266367] mwifiex_pcie 0000:03:00.0: cmd: Enabled STA power save
[   14.266370] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.266378] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xe4, cmd_pending=0
[   14.266414] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xd6, cmd_pending=1
[   14.266427] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xd6, act 0x0, len 60, seqno 0x6
[   14.266501] usbcore: registered new interface driver btusb
[   14.267284] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.267286] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.267309] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.267315] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80d6, result 0, len 60, seqno 0x6
[   14.267319] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.267328] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xd6, cmd_pending=0
[   14.267396] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
[   14.267417] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x1e, act 0x0, len 14, seqno 0x7
[   14.275737] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.275740] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.275747] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.275751] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x801e, result 0, len 14, seqno 0x7
[   14.275755] mwifiex_pcie 0000:03:00.0: Current TxPower Level=0, Max Power=18, Min Power=8
[   14.275757] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.275765] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
[   14.275776] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x83, cmd_pending=1
[   14.276033] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x83, act 0x1, len 24, seqno 0x8
[   14.280994] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.280996] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.281004] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.281008] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8083, result 0, len 24, seqno 0x8
[   14.281011] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.281018] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x83, cmd_pending=0
[   14.281030] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xdf, cmd_pending=1
[   14.281042] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xdf, act 0x1, len 14, seqno 0x9
[   14.286944] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.286947] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.286954] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.286957] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80df, result 0, len 14, seqno 0x9
[   14.286960] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.286967] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xdf, cmd_pending=0
[   14.286977] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
[   14.286988] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x28, act 0x13, len 12, seqno 0xa
[   14.295076] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.295078] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.295085] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.295089] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8028, result 0, len 12, seqno 0xa
[   14.295092] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.295098] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
[   14.295118] mwifiex_pcie 0000:03:00.0: cmd: PS Command: Enter Auto Deep Sleep
[   14.295121] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xe4, cmd_pending=1
[   14.295132] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xe4, act 0xff, len 18, seqno 0xb
[   14.303569] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.303571] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.303578] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.303582] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80e4, result 0, len 18, seqno 0xb
[   14.303585] mwifiex_pcie 0000:03:00.0: info: mwifiex_ret_enh_power_mode: PS_MODE cmd reply result=0x0 action=0XFF
[   14.303588] mwifiex_pcie 0000:03:00.0: cmd: Enabled auto deep sleep
[   14.303590] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.303597] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xe4, cmd_pending=0
[   14.303606] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x9
[   14.303609] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x1, OID=0x9,	OIDSize=0x2, Value=0x1
[   14.303612] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.303623] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x1, len 16, seqno 0xc
[   14.311978] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.311980] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.311987] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.311990] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 16, seqno 0xc
[   14.311994] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x9,	query_type = 0x1, buf size = 0x2
[   14.311996] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.312003] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.312015] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xcd, cmd_pending=1
[   14.312027] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xcd, act 0x1, len 16, seqno 0xd
[   14.318043] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.318045] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.318052] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.318056] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80cd, result 0, len 16, seqno 0xd
[   14.318058] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.318065] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xcd, cmd_pending=0
[   14.318076] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xd6, cmd_pending=1
[   14.318087] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xd6, act 0x0, len 60, seqno 0xe
[   14.325209] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.325212] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.325218] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.325222] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80d6, result 0, len 60, seqno 0xe
[   14.325225] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.325232] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xd6, cmd_pending=0
[   14.325289] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
[   14.325300] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x1e, act 0x0, len 14, seqno 0xf
[   14.330950] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.330952] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.330959] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.330963] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x801e, result 0, len 14, seqno 0xf
[   14.330966] mwifiex_pcie 0000:03:00.0: Current TxPower Level=0, Max Power=18, Min Power=8
[   14.330968] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.330975] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
[   14.330985] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x83, cmd_pending=1
[   14.330996] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x83, act 0x1, len 24, seqno 0x10
[   14.338291] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.338293] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.338300] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.338304] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8083, result 0, len 24, seqno 0x10
[   14.338306] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.338313] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x83, cmd_pending=0
[   14.338323] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xdf, cmd_pending=1
[   14.338334] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xdf, act 0x1, len 14, seqno 0x11
[   14.346326] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.346328] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.346335] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.346339] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80df, result 0, len 14, seqno 0x11
[   14.346341] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.346348] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xdf, cmd_pending=0
[   14.346357] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
[   14.346368] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x28, act 0x13, len 12, seqno 0x12
[   14.352352] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.352354] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.352361] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.352365] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8028, result 0, len 12, seqno 0x12
[   14.352367] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.352374] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
[   14.352383] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x9
[   14.352386] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x1, OID=0x9,	OIDSize=0x2, Value=0x1
[   14.352389] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.352400] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x1, len 16, seqno 0x13
[   14.358117] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.358119] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.358126] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.358129] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 16, seqno 0x13
[   14.358132] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x9,	query_type = 0x1, buf size = 0x2
[   14.358135] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.358141] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.358151] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xcd, cmd_pending=1
[   14.358162] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xcd, act 0x1, len 16, seqno 0x14
[   14.364608] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.364610] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.364617] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.364621] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80cd, result 0, len 16, seqno 0x14
[   14.364623] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.364630] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xcd, cmd_pending=0
[   14.364641] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xd6, cmd_pending=1
[   14.364652] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xd6, act 0x0, len 60, seqno 0x15
[   14.372901] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.372903] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.372910] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.372913] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80d6, result 0, len 60, seqno 0x15
[   14.372916] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.372922] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xd6, cmd_pending=0
[   14.372932] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
[   14.372943] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x1e, act 0x0, len 14, seqno 0x16
[   14.379095] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.379097] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.379103] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.379107] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x801e, result 0, len 14, seqno 0x16
[   14.379110] mwifiex_pcie 0000:03:00.0: Current TxPower Level=0, Max Power=18, Min Power=8
[   14.379112] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.379118] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
[   14.379128] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x83, cmd_pending=1
[   14.379138] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x83, act 0x1, len 24, seqno 0x17
[   14.385033] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.385035] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.385041] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.385045] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8083, result 0, len 24, seqno 0x17
[   14.385047] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.385054] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x83, cmd_pending=0
[   14.385063] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xdf, cmd_pending=1
[   14.385074] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xdf, act 0x1, len 14, seqno 0x18
[   14.392444] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.392446] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.392452] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.392456] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80df, result 0, len 14, seqno 0x18
[   14.392458] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.392464] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xdf, cmd_pending=0
[   14.392503] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
[   14.392514] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x28, act 0x13, len 12, seqno 0x19
[   14.398713] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.398715] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.398721] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.398725] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8028, result 0, len 12, seqno 0x19
[   14.398727] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.398734] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
[   14.398757] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x9
[   14.398760] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x1, OID=0x9,	OIDSize=0x2, Value=0x1
[   14.398763] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.398774] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x1, len 16, seqno 0x1a
[   14.406227] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.406229] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.406235] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.406239] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 16, seqno 0x1a
[   14.406242] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x9,	query_type = 0x1, buf size = 0x2
[   14.406244] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.406250] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.406275] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xcd, cmd_pending=1
[   14.406287] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xcd, act 0x1, len 16, seqno 0x1b
[   14.414663] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.414665] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.414671] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.414675] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80cd, result 0, len 16, seqno 0x1b
[   14.414677] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.414683] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xcd, cmd_pending=0
[   14.414803] mwifiex_pcie 0000:03:00.0: info: cfg80211 regulatory domain callback for 00
[   14.414998] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x20, cmd_pending=1
[   14.415016] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x20, act 0x8, len 16, seqno 0x1c
[   14.421044] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.421046] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.421053] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.421057] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8020, result 0, len 16, seqno 0x1c
[   14.421061] mwifiex_pcie 0000:03:00.0: RF_ANT_RESP: Tx action = 0x8, Tx Mode = 0x0003	Rx action = 0x4, Rx Mode = 0x0003
[   14.421064] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.421071] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x20, cmd_pending=0
[   14.421185] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x8
[   14.421188] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x0, OID=0x8,	OIDSize=0x80, Value=0x0
[   14.421191] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.421203] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x0, len 142, seqno 0x1d
[   14.427256] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.427258] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.427267] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.427272] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 142, seqno 0x1d
[   14.427275] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x8,	query_type = 0x0, buf size = 0x80
[   14.427278] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: FragThsd =2346
[   14.427281] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.427289] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.427329] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x5
[   14.427332] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x0, OID=0x5,	OIDSize=0x80, Value=0x0
[   14.427335] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.427348] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x0, len 142, seqno 0x1e
[   14.427709] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.427711] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.427719] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.427723] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 142, seqno 0x1e
[   14.427727] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x5,	query_type = 0x0, buf size = 0x80
[   14.427730] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: RTSThsd =2347
[   14.427732] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.427740] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.427752] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x6
[   14.427755] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x0, OID=0x6,	OIDSize=0x80, Value=0x0
[   14.427758] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.427769] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x0, len 142, seqno 0x1f
[   14.428136] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.428138] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.428147] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.428152] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 142, seqno 0x1f
[   14.428156] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x6,	query_type = 0x0, buf size = 0x80
[   14.428158] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: TxRetryCount=9
[   14.428161] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.428170] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.428184] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x7
[   14.428187] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x0, OID=0x7,	OIDSize=0x80, Value=0x0
[   14.428190] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.428202] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x0, len 142, seqno 0x20
[   14.434815] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.434817] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.434825] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.434830] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 142, seqno 0x20
[   14.434833] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x7,	query_type = 0x0, buf size = 0x80
[   14.434836] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.434844] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.434911] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xf7, cmd_pending=1
[   14.434923] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xf7, act 0x0, len 9, seqno 0x21
[   14.443198] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.443201] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.443207] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.443211] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80f7, result 0, len 9, seqno 0x21
[   14.443225] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.443232] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xf7, cmd_pending=0
[   14.443263] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xd6, cmd_pending=1
[   14.443275] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xd6, act 0x0, len 60, seqno 0x22
[   14.453640] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.453642] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.453649] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.453653] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80d6, result 0, len 60, seqno 0x22
[   14.453656] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.453662] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xd6, cmd_pending=0
[   14.453696] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
[   14.453708] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x1e, act 0x0, len 14, seqno 0x23
[   14.459968] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.459970] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.459977] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.459981] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x801e, result 0, len 14, seqno 0x23
[   14.459984] mwifiex_pcie 0000:03:00.0: Current TxPower Level=0, Max Power=18, Min Power=8
[   14.459986] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.459992] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
[   14.460018] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x83, cmd_pending=1
[   14.460030] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x83, act 0x1, len 24, seqno 0x24
[   14.465936] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.465938] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.465945] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.465949] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8083, result 0, len 24, seqno 0x24
[   14.465951] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.465958] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x83, cmd_pending=0
[   14.465982] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xdf, cmd_pending=1
[   14.465993] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xdf, act 0x1, len 14, seqno 0x25
[   14.473207] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.473209] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.473216] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.473220] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80df, result 0, len 14, seqno 0x25
[   14.473222] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.473239] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xdf, cmd_pending=0
[   14.473263] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
[   14.473274] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x28, act 0x13, len 12, seqno 0x26
[   14.480709] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.480711] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.480722] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.480727] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8028, result 0, len 12, seqno 0x26
[   14.480731] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.480739] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
[   14.480931] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x9
[   14.480935] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x1, OID=0x9,	OIDSize=0x2, Value=0x1
[   14.480938] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.480960] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x1, len 16, seqno 0x27
[   14.481311] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.481313] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.481322] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.481327] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 16, seqno 0x27
[   14.481330] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x9,	query_type = 0x1, buf size = 0x2
[   14.481333] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.481342] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.489166] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xcd, cmd_pending=1
[   14.489180] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xcd, act 0x1, len 16, seqno 0x28
[   14.494749] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.494752] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.494760] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.494764] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80cd, result 0, len 16, seqno 0x28
[   14.494767] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.494774] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xcd, cmd_pending=0
[   14.495193] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
[   14.495225] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x1e, act 0x0, len 14, seqno 0x29
[   14.495604] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.495607] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.495618] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.495623] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x801e, result 0, len 14, seqno 0x29
[   14.495626] mwifiex_pcie 0000:03:00.0: Current TxPower Level=0, Max Power=18, Min Power=8
[   14.495629] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.495637] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
[   14.513381] mwifiex_pcie 0000:03:00.0: info: mlan0: Marvell 802.11 Adapter
[   14.513471] mwifiex_pcie 0000:03:00.0: info: MWIFIEX VERSION: mwifiex 1.0 (15.68.7.p53) 
[   14.513474] mwifiex_pcie 0000:03:00.0: driver_version = mwifiex 1.0 (15.68.7.p53) 
[   14.513556] mwifiex_pcie 0000:03:00.0: info: cfg80211 regulatory domain callback for US
[   14.513566] mwifiex_pcie 0000:03:00.0: info: 11D: no_of_triplet=0x1
[   14.513571] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x5b, cmd_pending=1
[   14.513605] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x5b, act 0x1, len 20, seqno 0x2a
[   14.514041] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.514046] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.514071] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.514078] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x805b, result 0, len 20, seqno 0x2a
[   14.514083] mwifiex_pcie 0000:03:00.0: info: 11D Domain Info Resp: no_of_triplet=1
[   14.514090] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x5b, cmd_pending=0
[   14.516919] mwifiex_pcie 0000:03:00.0 wlp3s0: renamed from mlan0
[   14.614742] mwifiex_pcie 0000:03:00.0: info: Rx EVENT
[   14.614770] mwifiex_pcie 0000:03:00.0: info: EventReady: Initial <Rd: 0x80, Wr: 0x1>
[   14.614778] mwifiex_pcie 0000:03:00.0: info: Read Index: 0
[   14.614792] mwifiex_pcie 0000:03:00.0: info: Event length: 10
[   14.614812] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.614822] mwifiex_pcie 0000:03:00.0: EVENT: cause: 0xb
[   14.614830] mwifiex_pcie 0000:03:00.0: info: EVENT: SLEEP
[   14.614842] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xe4, act 0x5, len 12, seqno 0x2b
[   14.614869] mwifiex_pcie 0000:03:00.0: info: Updated <Rd: 0x81, Wr: 0x1>
[   14.614877] mwifiex_pcie 0000:03:00.0: info: Check Events Again
[   14.614887] mwifiex_pcie 0000:03:00.0: info: EventReady: Initial <Rd: 0x81, Wr: 0x1>
[   14.615186] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.615194] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.615212] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80e4, result 0, len 12, seqno 0x2b
[   14.620418] mwifiex_pcie 0000:03:00.0: max count reached while accessing sleep cookie
[   14.620444] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   17.201708] audit: type=1305 audit(1472136010.415:4): audit_pid=754 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[   18.000074] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   18.005465] Bluetooth: BNEP filters: protocol multicast
[   18.041721] Bluetooth: BNEP socket layer initialized
[   18.114011] random: crng init done
[   18.704463] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[   18.742122] r8169 0000:01:00.0 p4p1: link down
[   18.742125] r8169 0000:01:00.0 p4p1: link down
[   18.751445] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[   18.767131] IPv6: ADDRCONF(NETDEV_UP): p4p2: link is not ready
[   18.802289] r8169 0000:02:00.0 p4p2: link down
[   18.806891] IPv6: ADDRCONF(NETDEV_UP): p4p2: link is not ready
[   21.968051] r8169 0000:01:00.0 p4p1: link up
[   21.972465] IPv6: ADDRCONF(NETDEV_CHANGE): p4p1: link becomes ready
[   31.551136] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   31.646816] Ebtables v2.0 registered
[   31.947009] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   32.007223] tun: Universal TUN/TAP device driver, 1.6
[   32.012329] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   32.040582] virbr0: port 1(virbr0-nic) entered blocking state
[   32.046415] virbr0: port 1(virbr0-nic) entered disabled state
[   32.053595] device virbr0-nic entered promiscuous mode
[   32.348642] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   32.800604] virbr0: port 1(virbr0-nic) entered blocking state
[   32.806421] virbr0: port 1(virbr0-nic) entered listening state
[   32.919057] virbr0: port 1(virbr0-nic) entered disabled state
[   32.946657] device virbr0-nic left promiscuous mode
[   32.951649] virbr0: port 1(virbr0-nic) entered disabled state

--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-good-reboot.txt"

[    0.000000] Linux version 4.8.0-rc2+ (root@iot-r5s3-01.wlan.rhts.eng.bos.redhat.com) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-10) (GCC) ) #1 SMP Mon Aug 22 06:33:34 EDT 2016
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.8.0-rc2+ root=/dev/mapper/rhel_iot--r5s3--01-root ro crashkernel=auto rd.lvm.lv=rhel_iot-r5s3-01/root rd.lvm.lv=rhel_iot-r5s3-01/swap console=ttyS3,115200n81 LANG=en_US.UTF-8
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001effffff] usable
[    0.000000] BIOS-e820: [mem 0x000000001f000000-0x000000001f0fffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000001f100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000200fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020100000-0x0000000076e40fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000076e41000-0x0000000076e70fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000076e71000-0x0000000076e96fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x0000000076e97000-0x0000000077420fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000077421000-0x000000007771efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007771f000-0x000000007771ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000077720000-0x0000000077761fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000077762000-0x00000000789e4fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000789e5000-0x0000000078ff9fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000078ffa000-0x0000000078ffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed01fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed03000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed0c000-0x00000000fed0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1cfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fef00000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff900000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000027fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: Dell Inc. Edge Gateway 5000/      , BIOS 00.03.08 11/09/2015
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x280000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 079000000 mask FFF000000 uncachable
[    0.000000]   2 base 07A000000 mask FFE000000 uncachable
[    0.000000]   3 base 07C000000 mask FFC000000 uncachable
[    0.000000]   4 base 100000000 mask F00000000 write-back
[    0.000000]   5 base 200000000 mask F80000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] total RAM covered: 8080M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 0G
[    0.000000] e820: update [mem 0x79000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x79000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd840-0x000fd84f] mapped at [ffff8800000fd840]
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] BRK [0x02291000, 0x02291fff] PGTABLE
[    0.000000] BRK [0x02292000, 0x02292fff] PGTABLE
[    0.000000] BRK [0x02293000, 0x02293fff] PGTABLE
[    0.000000] BRK [0x02294000, 0x02294fff] PGTABLE
[    0.000000] BRK [0x02295000, 0x02295fff] PGTABLE
[    0.000000] BRK [0x02296000, 0x02296fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x3094f000-0x3449ffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0580 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x0000000076E89088 000094 (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x0000000076E95CB8 00010C (v05 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 128/32 (20160422/tbfadt-624)
[    0.000000] ACPI: DSDT 0x0000000076E891B0 00CB03 (v02 DELL   AS09     01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x0000000077420E80 000040
[    0.000000] ACPI: APIC 0x0000000076E95DC8 000068 (v03 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x0000000076E95E30 000044 (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x0000000076E95E78 00009C (v01 DELL   AS09     01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x0000000076E95F18 00003C (v01 DELL   AS09     01072009 MSFT 00000097)
[    0.000000] ACPI: LPIT 0x0000000076E95F58 000104 (v01 DELL   AS09     00000003 VLV2 0100000D)
[    0.000000] ACPI: HPET 0x0000000076E96060 000038 (v01 DELL   AS09     01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x0000000076E96098 000763 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076E96800 000290 (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x0000000076E96A90 00017A (v01 DELL   AS09     00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 0x0000000076E96C10 000042 (v01 DELL   AS09     00000000      00000000)
[    0.000000] ACPI: SLIC 0x0000000076E96C58 000176 (v03 DELL   AS09     01072009 MSFT 00010013)
[    0.000000] ACPI: TCPA 0x0000000076E96DD0 000032 (v02 DELL   AS09     00000001 MSFT 01000013)
[    0.000000] ACPI: CSRT 0x0000000076E96E08 00014C (v00 DELL   AS09     00000005 INTL 20120624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000027fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x27ffcb000-0x27fff5fff]
[    0.000000] kexec_core: crashkernel: memory value expected
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000027fffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009bfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001effffff]
[    0.000000]   node   0: [mem 0x000000001f100000-0x000000001fffffff]
[    0.000000]   node   0: [mem 0x0000000020100000-0x0000000076e40fff]
[    0.000000]   node   0: [mem 0x000000007771f000-0x000000007771ffff]
[    0.000000]   node   0: [mem 0x0000000077762000-0x00000000789e4fff]
[    0.000000]   node   0: [mem 0x0000000078ffa000-0x0000000078ffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000027fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000027fffffff]
[    0.000000] On node 0 totalpages: 2063974
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7612 pages used for memmap
[    0.000000]   DMA32 zone: 487115 pages, LIFO batch:31
[    0.000000]   Normal zone: 24576 pages used for memmap
[    0.000000]   Normal zone: 1572864 pages, LIFO batch:31
[    0.000000] x86/hpet: Will disable the HPET for this platform because it's not reliable
[    0.000000] Reserving Intel graphics memory at 0x000000007b000000-0x000000007effffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-86
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x1f000000-0x1f0fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x200fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e41000-0x76e70fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e71000-0x76e96fff]
[    0.000000] PM: Registered nosave memory: [mem 0x76e97000-0x77420fff]
[    0.000000] PM: Registered nosave memory: [mem 0x77421000-0x7771efff]
[    0.000000] PM: Registered nosave memory: [mem 0x77720000-0x77761fff]
[    0.000000] PM: Registered nosave memory: [mem 0x789e5000-0x78ff9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x79000000-0x7affffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7b000000-0x7effffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7f000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed01fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed02000-0xfed02fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed03000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed07fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed0c000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1d000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeefffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xff8fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff900000-0xffffffff]
[    0.000000] e820: [mem 0x7f000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 36 pages/cpu @ffff88027fc00000 s107608 r8192 d31656 u1048576
[    0.000000] pcpu-alloc: s107608 r8192 d31656 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2031701
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.8.0-rc2+ root=/dev/mapper/rhel_iot--r5s3--01-root ro crashkernel=auto rd.lvm.lv=rhel_iot-r5s3-01/root rd.lvm.lv=rhel_iot-r5s3-01/swap console=ttyS3,115200n81 LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 3916164K/8255896K available (7121K kernel code, 1532K rwdata, 3184K rodata, 1868K init, 3280K bss, 277736K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=2
[    0.000000] NR_IRQS:524544 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS3] enabled
[    0.000000] tsc: Detected 1749.300 MHz processor
[    0.000034] Calibrating delay loop (skipped), value calculated using timer frequency.. 3498.60 BogoMIPS (lpj=1749300)
[    0.000469] pid_max: default: 32768 minimum: 301
[    0.000676] ACPI: Core revision 20160422
[    0.030029] ACPI: 4 ACPI AML tables successfully acquired and loaded

[    0.030416] Security Framework initialized
[    0.030588] SELinux:  Initializing.
[    0.030746] SELinux:  Starting in permissive mode
[    0.031897] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.036456] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.039191] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.039494] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.040343] CPU: Physical Processor ID: 0
[    0.040514] CPU: Processor Core ID: 0
[    0.040670] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.040939] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.041232] mce: CPU supports 6 MCE banks
[    0.041406] CPU0: Thermal monitoring enabled (TM1)
[    0.041608] process: using mwait in idle threads
[    0.041813] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0
[    0.042035] Last level dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0
[    0.042716] Freeing SMP alternatives memory: 28K (ffffffff81f54000 - ffffffff81f5b000)
[    0.046072] ftrace: allocating 27933 entries in 110 pages
[    0.064050] smpboot: Max logical packages: 1
[    0.064232] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.065182] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.075441] TSC deadline timer enabled
[    0.075445] smpboot: CPU0: Intel(R) Atom(TM) CPU  E3827  @ 1.74GHz (family: 0x6, model: 0x37, stepping: 0x9)
[    0.075866] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont events, 8-deep LBR, full-width counters, Intel PMU driver.
[    0.076387] ... version:                3
[    0.076561] ... bit width:              40
[    0.076730] ... generic registers:      2
[    0.076896] ... value mask:             000000ffffffffff
[    0.077112] ... max period:             000000ffffffffff
[    0.077328] ... fixed-purpose events:   3
[    0.077494] ... event mask:             0000000700000003
[    0.079107] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.079759] x86: Booting SMP configuration:
[    0.079935] .... node  #0, CPUs:      #1
[    0.142073] x86: Booted up 1 node, 2 CPUs
[    0.142256] smpboot: Total of 2 processors activated (7005.35 BogoMIPS)
[    0.192649] node 0 initialised, 1015499 pages in 49ms
[    0.194077] devtmpfs: initialized
[    0.194355] x86/mm: Memory block size: 128MB
[    0.203526] evm: security.selinux
[    0.203667] evm: security.ima
[    0.203793] evm: security.capability
[    0.204110] PM: Registering ACPI NVS region [mem 0x76e97000-0x77420fff] (5808128 bytes)
[    0.204769] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.205238] atomic64_test: passed for x86-64 platform with CX8 and with SSE
[    0.205533] pinctrl core: initialized pinctrl subsystem
[    0.206035] NET: Registered protocol family 16
[    0.209563] cpuidle: using governor menu
[    0.209832] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.210139] ACPI: bus type PCI registered
[    0.210306] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.210688] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.211064] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.211369] PCI: Using configuration type 1 for base access
[    0.211621] dmi type 0xB1 record - unknown flag
[    0.217985] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.218781] ACPI: Added _OSI(Module Device)
[    0.218958] ACPI: Added _OSI(Processor Device)
[    0.219141] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.219334] ACPI: Added _OSI(Processor Aggregator Device)
[    0.232967] ACPI: Dynamic OEM Table Load:
[    0.233160] ACPI: SSDT 0xFFFF88027FBFC800 000338 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.234944] ACPI: Dynamic OEM Table Load:
[    0.235133] ACPI: SSDT 0xFFFF88017EF11800 000433 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.237434] ACPI: Dynamic OEM Table Load:
[    0.237622] ACPI: SSDT 0xFFFF88027F7F5000 00015F (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.239352] ACPI: Dynamic OEM Table Load:
[    0.239539] ACPI: SSDT 0xFFFF88027FE69540 00008D (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.243400] ACPI: Interpreter enabled
[    0.243596] ACPI: (supports S0 S4 S5)
[    0.243751] ACPI: Using IOAPIC for interrupt routing
[    0.244036] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.261572] ACPI: Power Resource [USBC] (on)
[    0.263870] ACPI: Power Resource [PLPE] (on)
[    0.264568] ACPI: Power Resource [PLPE] (on)
[    0.275085] ACPI: Power Resource [CLK0] (on)
[    0.275376] ACPI: Power Resource [CLK1] (on)
[    0.348508] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.348785] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.349467] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.350099] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.350369] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    0.351726] PCI host bridge to bus 0000:00
[    0.351912] pci_bus 0000:00: root bus resource [io  0x0070-0x0077]
[    0.352165] pci_bus 0000:00: root bus resource [io  0x0000-0x006f window]
[    0.352441] pci_bus 0000:00: root bus resource [io  0x0078-0x0cf7 window]
[    0.352717] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.353000] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.353303] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff window]
[    0.353606] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000fffff window]
[    0.353910] pci_bus 0000:00: root bus resource [mem 0x80000000-0x90a15ffe window]
[    0.354218] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.354454] pci 0000:00:00.0: [8086:0f00] type 00 class 0x060000
[    0.354742] pci 0000:00:02.0: [8086:0f31] type 00 class 0x030000
[    0.354758] pci 0000:00:02.0: reg 0x10: [mem 0x90000000-0x903fffff]
[    0.354771] pci 0000:00:02.0: reg 0x18: [mem 0x80000000-0x8fffffff pref]
[    0.354783] pci 0000:00:02.0: reg 0x20: [io  0xe080-0xe087]
[    0.355069] pci 0000:00:13.0: [8086:0f23] type 00 class 0x010601
[    0.355089] pci 0000:00:13.0: reg 0x10: [io  0xe070-0xe077]
[    0.355100] pci 0000:00:13.0: reg 0x14: [io  0xe060-0xe063]
[    0.355110] pci 0000:00:13.0: reg 0x18: [io  0xe050-0xe057]
[    0.355121] pci 0000:00:13.0: reg 0x1c: [io  0xe040-0xe043]
[    0.355131] pci 0000:00:13.0: reg 0x20: [io  0xe020-0xe03f]
[    0.355142] pci 0000:00:13.0: reg 0x24: [mem 0x90a15000-0x90a157ff]
[    0.355195] pci 0000:00:13.0: PME# supported from D3hot
[    0.355452] pci 0000:00:14.0: [8086:0f35] type 00 class 0x0c0330
[    0.355474] pci 0000:00:14.0: reg 0x10: [mem 0x90a00000-0x90a0ffff 64bit]
[    0.355543] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.355751] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.356079] pci 0000:00:1a.0: [8086:0f18] type 00 class 0x108000
[    0.356105] pci 0000:00:1a.0: reg 0x10: [mem 0x90500000-0x905fffff]
[    0.356119] pci 0000:00:1a.0: reg 0x14: [mem 0x90400000-0x904fffff]
[    0.356238] pci 0000:00:1a.0: PME# supported from D0 D3hot
[    0.356536] pci 0000:00:1b.0: [8086:0f04] type 00 class 0x040300
[    0.356561] pci 0000:00:1b.0: reg 0x10: [mem 0x90a10000-0x90a13fff 64bit]
[    0.356643] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.356886] pci 0000:00:1c.0: [8086:0f48] type 01 class 0x060400
[    0.356958] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.357138] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.357463] pci 0000:00:1c.1: [8086:0f4a] type 01 class 0x060400
[    0.357536] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.357712] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.358022] pci 0000:00:1c.2: [8086:0f4c] type 01 class 0x060400
[    0.358094] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.358269] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.358588] pci 0000:00:1c.3: [8086:0f4e] type 01 class 0x060400
[    0.358660] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.358833] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.359149] pci 0000:00:1f.0: [8086:0f1c] type 00 class 0x060100
[    0.359466] pci 0000:00:1f.3: [8086:0f12] type 00 class 0x0c0500
[    0.359502] pci 0000:00:1f.3: reg 0x10: [mem 0x90a14000-0x90a1401f]
[    0.359584] pci 0000:00:1f.3: reg 0x20: [io  0xe000-0xe01f]
[    0.360021] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    0.360044] pci 0000:01:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.360074] pci 0000:01:00.0: reg 0x18: [mem 0x90904000-0x90904fff 64bit]
[    0.360094] pci 0000:01:00.0: reg 0x20: [mem 0x90900000-0x90903fff 64bit pref]
[    0.360194] pci 0000:01:00.0: supports D1 D2
[    0.360197] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.360258] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.363562] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.363770] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.363775] pci 0000:00:1c.0:   bridge window [mem 0x90900000-0x909fffff]
[    0.363887] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.363910] pci 0000:02:00.0: reg 0x10: [io  0xc000-0xc0ff]
[    0.363940] pci 0000:02:00.0: reg 0x18: [mem 0x90804000-0x90804fff 64bit]
[    0.363959] pci 0000:02:00.0: reg 0x20: [mem 0x90800000-0x90803fff 64bit pref]
[    0.364059] pci 0000:02:00.0: supports D1 D2
[    0.364062] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.364123] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.366570] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.366778] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.366783] pci 0000:00:1c.1:   bridge window [mem 0x90800000-0x908fffff]
[    0.366917] pci 0000:03:00.0: [11ab:2b38] type 00 class 0x020000
[    0.366952] pci 0000:03:00.0: reg 0x10: [mem 0x90700000-0x907fffff 64bit pref]
[    0.366976] pci 0000:03:00.0: reg 0x18: [mem 0x90600000-0x906fffff 64bit pref]
[    0.367118] pci 0000:03:00.0: supports D1 D2
[    0.367121] pci 0000:03:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.367195] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.369598] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.369808] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.369901] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.372800] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 12 14 15)
[    0.373277] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 *4 5 6 12 14 15)
[    0.373759] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 12 14 15)
[    0.374231] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 12 14 15)
[    0.374712] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 5 6 12 14 15)
[    0.375184] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 12 14 15)
[    0.375664] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 12 14 15)
[    0.376134] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 12 14 15) *0, disabled.
[    0.381916] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.382381] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.382616] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.382961] vgaarb: loaded
[    0.383077] vgaarb: bridge control possible 0000:00:02.0
[    0.383422] SCSI subsystem initialized
[    0.383635] ACPI: bus type USB registered
[    0.383842] usbcore: registered new interface driver usbfs
[    0.384102] usbcore: registered new interface driver hub
[    0.384355] usbcore: registered new device driver usb
[    0.384815] PCI: Using ACPI for IRQ routing
[    0.391260] PCI: pci_cache_line_size set to 64 bytes
[    0.391332] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.391336] e820: reserve RAM buffer [mem 0x1f000000-0x1fffffff]
[    0.391338] e820: reserve RAM buffer [mem 0x76e41000-0x77ffffff]
[    0.391340] e820: reserve RAM buffer [mem 0x77720000-0x77ffffff]
[    0.391342] e820: reserve RAM buffer [mem 0x789e5000-0x7bffffff]
[    0.391344] e820: reserve RAM buffer [mem 0x79000000-0x7bffffff]
[    0.391564] NetLabel: Initializing
[    0.391708] NetLabel:  domain hash size = 128
[    0.391887] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.392125] NetLabel:  unlabeled traffic allowed by default
[    0.392547] clocksource: Switched to clocksource refined-jiffies
[    0.410362] VFS: Disk quotas dquot_6.6.0
[    0.410580] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.411033] pnp: PnP ACPI init
[    0.411272] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.411571] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.411816] system 00:01: [io  0x0400-0x047f] has been reserved
[    0.412059] system 00:01: [io  0x0500-0x05fe] has been reserved
[    0.412305] system 00:01: [io  0x0600-0x061f] has been reserved
[    0.412563] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.412978] system 00:02: [io  0x0a00-0x0a0f] has been reserved
[    0.413223] system 00:02: [io  0x0a10-0x0a1f] has been reserved
[    0.413465] system 00:02: [io  0x0a20-0x0a2f] has been reserved
[    0.413722] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.414295] ACPI: IRQ 10 override to edge, high
[    0.414491] pnp 00:03: [dma 0 disabled]
[    0.414560] pnp 00:03: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.415098] ACPI: IRQ 11 override to edge, high
[    0.415291] pnp 00:04: [dma 0 disabled]
[    0.415359] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.415888] ACPI: IRQ 10 override to edge, high
[    0.416081] pnp 00:05: [dma 0 disabled]
[    0.416144] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.417218] ACPI: IRQ 7 override to edge, high
[    0.417408] pnp 00:06: [dma 0 disabled]
[    0.417476] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.418141] system 00:07: [mem 0xe0000000-0xefffffff] could not be reserved
[    0.418427] system 00:07: [mem 0xfed01000-0xfed01fff] has been reserved
[    0.418697] system 00:07: [mem 0xfed03000-0xfed03fff] has been reserved
[    0.418978] system 00:07: [mem 0xfed04000-0xfed04fff] has been reserved
[    0.419249] system 00:07: [mem 0xfed0c000-0xfed0ffff] could not be reserved
[    0.419532] system 00:07: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.419802] system 00:07: [mem 0xfed1c000-0xfed1cfff] has been reserved
[    0.420078] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.420362] system 00:07: [mem 0xfef00000-0xfeffffff] has been reserved
[    0.420637] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.423412] pnp 00:08: Plug and Play ACPI device, IDs PNP0c31 (active)
[    0.423432] pnp: PnP ACPI: found 9 devices
[    0.432427] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.432808] clocksource: Switched to clocksource acpi_pm
[    0.433046] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 01] add_size 200000 add_align 100000
[    0.433058] pci 0000:00:1c.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
[    0.433068] pci 0000:00:1c.2: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.433073] pci 0000:00:1c.2: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000 add_align 100000
[    0.433082] pci 0000:00:1c.3: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[    0.433086] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000 add_align 100000
[    0.433090] pci 0000:00:1c.3: bridge window [mem 0x00100000-0x000fffff] to [bus 04] add_size 200000 add_align 100000
[    0.433103] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433107] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433111] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433114] pci 0000:00:1c.1: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433118] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433122] pci 0000:00:1c.2: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433125] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x000fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.433129] pci 0000:00:1c.3: res[14]=[mem 0x00100000-0x002fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.433133] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433136] pci 0000:00:1c.3: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.433140] pci 0000:00:1c.2: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.433143] pci 0000:00:1c.2: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.433146] pci 0000:00:1c.3: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.433150] pci 0000:00:1c.3: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.433164] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.433505] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.433858] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.434168] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.434498] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.434809] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.435157] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.435429] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.435722] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.436052] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.436380] pci 0000:00:1c.2: BAR 13: assigned [io  0x1000-0x1fff]
[    0.436634] pci 0000:00:1c.3: BAR 13: assigned [io  0x2000-0x2fff]
[    0.436912] pci 0000:00:1c.3: BAR 14: no space for [mem size 0x00200000]
[    0.437185] pci 0000:00:1c.3: BAR 14: failed to assign [mem size 0x00200000]
[    0.437478] pci 0000:00:1c.3: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.437788] pci 0000:00:1c.3: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.438137] pci 0000:00:1c.2: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.438448] pci 0000:00:1c.2: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.438777] pci 0000:00:1c.1: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.439107] pci 0000:00:1c.1: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.439437] pci 0000:00:1c.0: BAR 15: no space for [mem size 0x00200000 64bit pref]
[    0.439747] pci 0000:00:1c.0: BAR 15: failed to assign [mem size 0x00200000 64bit pref]
[    0.440092] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.440299] pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
[    0.440551] pci 0000:00:1c.0:   bridge window [mem 0x90900000-0x909fffff]
[    0.440851] pci 0000:00:1c.1: PCI bridge to [bus 02]
[    0.441057] pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
[    0.441309] pci 0000:00:1c.1:   bridge window [mem 0x90800000-0x908fffff]
[    0.441590] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.441795] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.442063] pci 0000:00:1c.2:   bridge window [mem 0x90600000-0x907fffff]
[    0.442345] pci 0000:00:1c.3: PCI bridge to [bus 04]
[    0.442550] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
[    0.442808] pci_bus 0000:00: resource 4 [io  0x0070-0x0077]
[    0.442811] pci_bus 0000:00: resource 5 [io  0x0000-0x006f window]
[    0.442833] pci_bus 0000:00: resource 6 [io  0x0078-0x0cf7 window]
[    0.442836] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.442839] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff window]
[    0.442842] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff window]
[    0.442845] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000fffff window]
[    0.442848] pci_bus 0000:00: resource 11 [mem 0x80000000-0x90a15ffe window]
[    0.442851] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.442854] pci_bus 0000:01: resource 1 [mem 0x90900000-0x909fffff]
[    0.442857] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.442860] pci_bus 0000:02: resource 1 [mem 0x90800000-0x908fffff]
[    0.442863] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.442866] pci_bus 0000:03: resource 1 [mem 0x90600000-0x907fffff]
[    0.442869] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.442929] NET: Registered protocol family 2
[    0.443540] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.444199] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.444872] TCP: Hash tables configured (established 65536 bind 65536)
[    0.445222] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.445555] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.446022] NET: Registered protocol family 1
[    0.446233] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.447008] PCI: CLS 64 bytes, default 64
[    0.447138] Unpacking initramfs...
[    2.363144] Freeing initrd memory: 60740K (ffff88003094f000 - ffff8800344a0000)
[    2.363447] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.363748] software IO TLB [mem 0x72e41000-0x76e41000] (64MB) mapped at [ffff880072e41000-ffff880076e40fff]
[    2.365960] futex hash table entries: 512 (order: 3, 32768 bytes)
[    2.366238] audit: initializing netlink subsys (disabled)
[    2.366492] audit: type=2000 audit(1472121976.352:1): initialized
[    2.367472] Initialise system trusted keyrings
[    2.367880] workingset: timestamp_bits=36 max_order=21 bucket_order=0
[    2.372262] zbud: loaded
[    2.372954] Key type big_key registered
[    2.373116] SELinux:  Registering netfilter hooks
[    2.501248] NET: Registered protocol family 38
[    2.501439] Key type asymmetric registered
[    2.501609] Asymmetric key parser 'x509' registered
[    2.501955] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    2.502326] io scheduler noop registered
[    2.502490] io scheduler deadline registered (default)
[    2.502783] io scheduler cfq registered
[    2.503948] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.504187] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.504509] intel_idle: MWAIT substates: 0x3000020
[    2.504512] intel_idle: v0.4.1 model 0x37
[    2.504678] intel_idle: lapic_timer_reliable_states 0xffffffff
[    2.504864] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    2.505206] ACPI: Sleep Button [SLPB]
[    2.505455] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.505795] ACPI: Power Button [PWRF]
[    2.509346] GHES: HEST is not enabled!
[    2.509728] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.531353] 00:03: ttyS0 at I/O 0x3e0 (irq = 10, base_baud = 115200) is a 16550A
[    2.553111] 00:04: ttyS1 at I/O 0x2e0 (irq = 11, base_baud = 115200) is a 16550A
[    2.574866] 00:05: ttyS2 at I/O 0x3e8 (irq = 10, base_baud = 115200) is a 16550A
[    2.596564] 00:06: ttyS3 at I/O 0x2d0 (irq = 7, base_baud = 115200) is a 16550A
[    2.604545] hpet: number irqs doesn't agree with number of timers
[    2.610861] Non-volatile memory driver v1.3
[    2.615144] Linux agpgart interface v0.103
[    2.633168] tpm_tis 00:08: 1.2 TPM (device-id 0xFE, rev-id 2)
[    2.724254] rdac: device handler registered
[    2.729504] hp_sw: device handler registered
[    2.733838] emc: device handler registered
[    2.739255] alua: device handler registered
[    2.743592] libphy: Fixed MDIO Bus: probed
[    2.747871] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.754454] ehci-pci: EHCI PCI platform driver
[    2.758966] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.765197] ohci-pci: OHCI PCI platform driver
[    2.769697] uhci_hcd: USB Universal Host Controller Interface driver
[    2.776377] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.781789] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    2.790345] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    2.798846] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.799019] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.805863] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.813137] usb usb1: Product: xHCI Host Controller
[    2.818056] usb usb1: Manufacturer: Linux 4.8.0-rc2+ xhci-hcd
[    2.823844] usb usb1: SerialNumber: 0000:00:14.0
[    2.828806] hub 1-0:1.0: USB hub found
[    2.832613] hub 1-0:1.0: 6 ports detected
[    2.837672] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.843045] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    2.850859] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    2.857706] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.864981] usb usb2: Product: xHCI Host Controller
[    2.869898] usb usb2: Manufacturer: Linux 4.8.0-rc2+ xhci-hcd
[    2.875687] usb usb2: SerialNumber: 0000:00:14.0
[    2.880602] hub 2-0:1.0: USB hub found
[    2.884413] hub 2-0:1.0: 1 port detected
[    2.888721] usbcore: registered new interface driver usbserial
[    2.894624] usbcore: registered new interface driver usbserial_generic
[    2.901219] usbserial: USB Serial support registered for generic
[    2.907330] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.914864] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.919881] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.925224] mousedev: PS/2 mouse device common for all mice
[    2.932047] rtc_cmos 00:00: RTC can wake from S4
[    2.937116] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.943389] rtc_cmos 00:00: alarms up to one month, y3k, 242 bytes nvram
[    2.950167] intel_pstate: Intel P-state driver initializing
[    2.958736] hidraw: raw HID events driver (C) Jiri Kosina
[    2.965020] usbcore: registered new interface driver usbhid
[    2.970676] usbhid: USB HID core driver
[    2.974923] drop_monitor: Initializing network drop monitor service
[    2.981775] Initializing XFRM netlink socket
[    2.986513] NET: Registered protocol family 10
[    2.992648] NET: Registered protocol family 17
[    2.997696] microcode: sig=0x30679, pf=0x1, revision=0x905
[    3.003297] microcode: Microcode Update Driver: v2.01 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.012580] registered taskstats version 1
[    3.016731] Loading compiled-in X.509 certificates
[    3.034463] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
[    3.044264] Loaded X.509 cert 'Build time autogenerated kernel key: 9518684b013c6df000e78d3f046bb6acff340d12'
[    3.054345] zswap: loaded using pool lzo/zbud
[    3.115599] Key type trusted registered
[    3.127641] Key type encrypted registered
[    3.214365] usb 1-4: new high-speed USB device number 2 using xhci_hcd
[    3.272546] evm: HMAC attrs: 0x1
[    3.277927] rtc_cmos 00:00: setting system clock to 2016-08-25 10:46:17 UTC (1472121977)
[    3.292764] Freeing unused kernel memory: 1868K (ffffffff81d81000 - ffffffff81f54000)
[    3.300695] Write protecting the kernel read-only data: 12288k
[    3.308363] Freeing unused kernel memory: 1056K (ffff8800016f8000 - ffff880001800000)
[    3.322493] Freeing unused kernel memory: 912K (ffff880001b1c000 - ffff880001c00000)
[    3.346269] random: systemd: uninitialized urandom read (16 bytes read)
[    3.354583] random: systemd: uninitialized urandom read (16 bytes read)
[    3.372034] tsc: Refined TSC clocksource calibration: 1749.999 MHz
[    3.378607] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1939a77ee81, max_idle_ns: 440795244944 ns
[    3.392253] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    3.410819] usb 1-4: New USB device found, idVendor=0424, idProduct=2514
[    3.417588] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.424907] systemd[1]: Detected architecture x86-64.
[    3.430323] systemd[1]: Running in initial RAM disk.
[    3.435873] hub 1-4:1.0: USB hub found
[    3.440219] hub 1-4:1.0: 4 ports detected
[    3.456342] systemd[1]: Set hostname to <localhost.localdomain>.
[    3.627530] random: systemd: uninitialized urandom read (16 bytes read)
[    3.634521] random: systemd: uninitialized urandom read (16 bytes read)
[    3.641506] random: systemd: uninitialized urandom read (16 bytes read)
[    3.648493] random: systemd: uninitialized urandom read (16 bytes read)
[    3.657447] random: systemd: uninitialized urandom read (16 bytes read)
[    3.664559] random: systemd: uninitialized urandom read (16 bytes read)
[    3.671909] random: systemd: uninitialized urandom read (16 bytes read)
[    3.680267] random: systemd: uninitialized urandom read (16 bytes read)
[    3.704391] systemd[1]: Reached target Timers.
[    3.708949] systemd[1]: Starting Timers.
[    3.720443] systemd[1]: Created slice Root Slice.
[    3.725225] usb 1-4.2: new high-speed USB device number 3 using xhci_hcd
[    3.732038] systemd[1]: Starting Root Slice.
[    3.743416] systemd[1]: Created slice System Slice.
[    3.748407] systemd[1]: Starting System Slice.
[    3.823289] usb 1-4.2: New USB device found, idVendor=1286, idProduct=2045
[    3.830349] usb 1-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.837726] usb 1-4.2: Product: Marvell Wireless Device
[    3.843009] usb 1-4.2: Manufacturer: Marvell
[    3.847332] usb 1-4.2: SerialNumber: 0000000000000000
[    4.414080] clocksource: Switched to clocksource tsc
[    4.561215] device-mapper: uevent: version 1.0.3
[    4.566238] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel@redhat.com
[    5.014215] sdhci: Secure Digital Host Controller Interface driver
[    5.020469] sdhci: Copyright(c) Pierre Ossman
[    5.155673] FUJITSU Extended Socket Network Device Driver - version 1.1 - Copyright (c) 2015 FUJITSU LIMITED
[    5.267794] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.283564] r8169 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM control
[    5.317213] r8169 0000:01:00.0 eth0: RTL8168f/8111f at 0xffffc90000e6e000, 74:e6:e2:e5:05:f8, XID 08100880 IRQ 262
[    5.327637] r8169 0000:01:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.409267] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.415900] [drm] Initialized drm 1.1.0 20060810
[    5.434625] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[    5.451034] r8169 0000:02:00.0 eth1: RTL8168f/8111f at 0xffffc90000e6c000, 74:e6:e2:e5:05:f9, XID 08100800 IRQ 263
[    5.461473] r8169 0000:02:00.0 eth1: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.479780] libata version 3.00 loaded.
[    5.510809] ahci 0000:00:13.0: version 3.0
[    5.511386] ahci 0000:00:13.0: controller can't do DEVSLP, turning off
[    5.527921] r8169 0000:01:00.0: invalid large VPD tag 7f at offset 0
[    5.535011] r8169 0000:02:00.0: invalid large VPD tag 7f at offset 0
[    5.544994] ahci 0000:00:13.0: AHCI 0001.0300 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    5.553170] ahci 0000:00:13.0: flags: 64bit ncq pm led clo pio slum part deso 
[    5.573689] r8169 0000:02:00.0 p4p2: renamed from eth1
[    5.589179] scsi host0: ahci
[    5.592571] scsi host1: ahci
[    5.596280] ata1: SATA max UDMA/133 abar m2048@0x90a15000 port 0x90a15100 irq 264
[    5.603835] ata2: SATA max UDMA/133 abar m2048@0x90a15000 port 0x90a15180 irq 264
[    5.924547] ata2: SATA link down (SStatus 0 SControl 300)
[    5.930120] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.939134] ata1.00: ATA-8: LITEON J8-L1064-11 M.2 2260 64GB, 0J61104, max UDMA/133
[    5.946919] ata1.00: 125045424 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    5.954814] ata1.00: configured for UDMA/133
[    5.959603] scsi 0:0:0:0: Direct-Access     ATA      LITEON J8-L1064- 104  PQ: 0 ANSI: 5
[    6.102170] r8169 0000:01:00.0 p4p1: renamed from eth0
[    6.115448] [drm] Memory usable by graphics device = 2048M
[    6.120997] [drm] Replacing VGA console driver
[    6.126764] Console: switching to colour dummy device 80x25
[    6.132724] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    6.132725] [drm] Driver supports precise vblank timestamp query.
[    6.133233] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    6.162713] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
[    6.169234] random: fast init done
[    6.174038] sd 0:0:0:0: [sda] Write Protect is off
[    6.178876] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.179813] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.192208]  sda: sda1 sda2
[    6.195822] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.589871] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    6.599234] acpi device:09: registered as cooling_device2
[    6.604931] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    7.025869] i915 0000:00:02.0: No connectors reported connected with modes
[    7.032846] [drm] Cannot find any crtc or sizes - going 1024x768
[    7.041501] fbcon: inteldrmfb (fb0) is primary device
[    7.074196] Console: switching to colour frame buffer device 128x48
[    7.101994] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    8.237073] SGI XFS with ACLs, security attributes, no debug enabled
[    8.253071] XFS (dm-0): Mounting V5 Filesystem
[    8.310850] XFS (dm-0): Ending clean mount
[    8.969348] systemd-journald[145]: Received SIGTERM from PID 1 (systemd).
[    9.036045] systemd: 24 output lines suppressed due to ratelimiting
[    9.103811] audit: type=1404 audit(1472121983.322:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    9.155097] SELinux: 32768 avtab hash slots, 104828 rules.
[    9.195923] SELinux: 32768 avtab hash slots, 104828 rules.
[    9.289910] SELinux:  8 users, 14 roles, 4982 types, 301 bools, 1 sens, 1024 cats
[    9.289916] SELinux:  91 classes, 104828 rules
[    9.299041] SELinux:  Permission validate_trans in class security not defined in policy.
[    9.307213] SELinux:  Permission module_load in class system not defined in policy.
[    9.315133] SELinux:  Class binder not defined in policy.
[    9.320562] SELinux:  Class cap_userns not defined in policy.
[    9.326339] SELinux:  Class cap2_userns not defined in policy.
[    9.332215] SELinux: the above unknown classes and permissions will be allowed
[    9.339491] SELinux:  Completing initialization.
[    9.339492] SELinux:  Setting up existing superblocks.
[    9.357169] audit: type=1403 audit(1472121983.575:3): policy loaded auid=4294967295 ses=4294967295
[    9.375912] systemd[1]: Successfully loaded SELinux policy in 271.801ms.
[    9.414875] systemd[1]: RTC configured in localtime, applying delta of -240 minutes to system time.
[    9.464359] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.470208] systemd[1]: Inserted module 'ip_tables'
[    9.579723] systemd[1]: Relabelled /dev and /run in 100.687ms.
[   10.181139] RPC: Registered named UNIX socket transport module.
[   10.188176] RPC: Registered udp transport module.
[   10.194293] RPC: Registered tcp transport module.
[   10.200418] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   10.211458] systemd-journald[532]: Received request to flush runtime journal from PID 1
[   10.621371] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   10.971353] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   11.077135] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   11.131630] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   11.139036] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   11.530786] SSE version of gcm_enc/dec engaged.
[   11.530834] XFS (sda1): Mounting V5 Filesystem
[   11.569877] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   11.810001] XFS (sda1): Ending clean mount
[   11.899924] mwifiex_pcie: try set_consistent_dma_mask(32)
[   11.937024] mwifiex_pcie: PCI memory map Virt0: ffffc90001000000 PCI memory map Virt2: ffffc90001400000
[   11.948256] mwifiex: rx work enabled, cpus 2
[   11.954821] snd_hda_intel 0000:00:1b.0: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
[   11.977205] mwifiex_pcie 0000:03:00.0: msi_enable = 1
[   12.001881] mwifiex_pcie 0000:03:00.0: Setting driver ready signature
[   12.008456] mwifiex_pcie 0000:03:00.0: Try 0 if FW is ready <0,0x0>
[   12.051216] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input7
[   12.069136] Adding 6254588k swap on /dev/mapper/rhel_iot--r5s3--01-swap.  Priority:-1 extents:1 across:6254588k SSFS
[   12.081133] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   12.111533] mwifiex_pcie 0000:03:00.0: PCI-E is the winner
[   12.111537] mwifiex_pcie 0000:03:00.0: info: Downloading FW image (803884 bytes)
[   13.347194] mwifiex_pcie 0000:03:00.0: info: FW download over, size 803884 bytes
[   13.347200] mwifiex_pcie 0000:03:00.0: Setting driver ready signature
[   13.347205] mwifiex_pcie 0000:03:00.0: Try 0 if FW is ready <0,0x6>
[   13.397597] intel_rapl: Found RAPL domain package
[   13.397600] intel_rapl: Found RAPL domain core
[   13.456221] mwifiex_pcie 0000:03:00.0: Try 1 if FW is ready <0,0x6>
[   13.560263] mwifiex_pcie 0000:03:00.0: Try 2 if FW is ready <0,0x6>
[   13.607377] usb 1-4.2: USB disconnect, device number 3
[   13.664199] mwifiex_pcie 0000:03:00.0: Try 3 if FW is ready <0,0x6>
[   13.768563] mwifiex_pcie 0000:03:00.0: Try 4 if FW is ready <0,0x6>
[   13.795585] usb 1-4.2: new high-speed USB device number 4 using xhci_hcd
[   13.872962] mwifiex_pcie 0000:03:00.0: Try 5 if FW is ready <0,0x6>
[   13.892350] usb 1-4.2: New USB device found, idVendor=1286, idProduct=2046
[   13.900302] usb 1-4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   13.900304] usb 1-4.2: Product: Bluetooth and Wireless LAN Composite Device
[   13.900307] usb 1-4.2: Manufacturer: Marvell
[   13.900309] usb 1-4.2: SerialNumber: 0000000000000000
[   13.908594] XFS (dm-2): Mounting V5 Filesystem
[   13.944449] XFS (dm-2): Ending clean mount
[   13.984292] mwifiex_pcie 0000:03:00.0: Try 6 if FW is ready <0,0x6>
[   14.121836] mwifiex_pcie 0000:03:00.0: Try 7 if FW is ready <0,0xfedcba00>
[   14.128771] mwifiex_pcie 0000:03:00.0: WLAN FW is active
[   14.134179] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xfa, cmd_pending=1
[   14.145709] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xfa, act 0x1000, len 52, seqno 0x1
[   14.269844] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.275821] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.281539] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.287855] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80fa, result 0, len 52, seqno 0x1
[   14.296084] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.301965] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xfa, cmd_pending=0
[   14.309157] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xa9, cmd_pending=1
[   14.316440] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xa9, act 0x0, len 8, seqno 0x2
[   14.327004] Bluetooth: Core ver 2.21
[   14.330665] NET: Registered protocol family 31
[   14.335152] Bluetooth: HCI device and connection manager initialized
[   14.344367] Bluetooth: HCI socket layer initialized
[   14.349353] Bluetooth: L2CAP socket layer initialized
[   14.354705] Bluetooth: SCO socket layer initialized
[   14.382554] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.388532] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.394270] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.400587] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80a9, result 0, len 8, seqno 0x2
[   14.408746] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.414642] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xa9, cmd_pending=0
[   14.421847] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x3, cmd_pending=1
[   14.429061] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x3, act 0x0, len 71, seqno 0x3
[   14.437335] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.443311] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.449029] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.455348] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8003, result 0, len 87, seqno 0x3
[   14.463589] mwifiex_pcie 0000:03:00.0: key_api v2.0
[   14.468509] mwifiex_pcie 0000:03:00.0: Firmware api version 15
[   14.474390] mwifiex_pcie 0000:03:00.0: info: GET_HW_SPEC: fw_release_number- 0x350f4407
[   14.482455] mwifiex_pcie 0000:03:00.0: info: GET_HW_SPEC: permanent addr: 98:f1:70:6f:55:af
[   14.490874] mwifiex_pcie 0000:03:00.0: info: GET_HW_SPEC: hw_if_version=0x2 version=0x4021
[   14.499205] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.505089] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x3, cmd_pending=0
[   14.512204] mwifiex_pcie 0000:03:00.0: cmd: set tx_buf=4096
[   14.517823] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xd9, cmd_pending=1
[   14.525481] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xd9, act 0x1, len 16, seqno 0x4
[   14.536309] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.542294] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.548023] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.554344] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80d9, result 0, len 16, seqno 0x4
[   14.562581] mwifiex_pcie 0000:03:00.0: cmd: curr_tx_buf_size=3584
[   14.568726] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.574615] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xd9, cmd_pending=0
[   14.581835] mwifiex_pcie 0000:03:00.0: cmd: PS Command: Enter PS
[   14.587895] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xe4, cmd_pending=1
[   14.595192] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xe4, act 0xff, len 30, seqno 0x5
[   14.603746] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.609736] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.615469] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.621795] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80e4, result 0, len 30, seqno 0x5
[   14.630036] mwifiex_pcie 0000:03:00.0: info: mwifiex_ret_enh_power_mode: PS_MODE cmd reply result=0x0 action=0XFF
[   14.640367] mwifiex_pcie 0000:03:00.0: cmd: Enabled STA power save
[   14.646590] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.652487] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xe4, cmd_pending=0
[   14.659706] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xd6, cmd_pending=1
[   14.667041] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xd6, act 0x0, len 60, seqno 0x6
[   14.675460] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.677340] usbcore: registered new interface driver btusb
[   14.686980] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.692711] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.699065] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80d6, result 0, len 60, seqno 0x6
[   14.707333] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.713229] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xd6, cmd_pending=0
[   14.720432] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
[   14.720442] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x1e, act 0x0, len 14, seqno 0x7
[   14.720819] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.720821] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.720829] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.720833] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x801e, result 0, len 14, seqno 0x7
[   14.720836] mwifiex_pcie 0000:03:00.0: Current TxPower Level=0, Max Power=18, Min Power=8
[   14.720838] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.720845] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
[   14.720856] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x83, cmd_pending=1
[   14.720865] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x83, act 0x1, len 24, seqno 0x8
[   14.728187] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.728190] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.728197] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.728201] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8083, result 0, len 24, seqno 0x8
[   14.728203] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.728210] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x83, cmd_pending=0
[   14.728220] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xdf, cmd_pending=1
[   14.728230] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xdf, act 0x1, len 14, seqno 0x9
[   14.736233] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.736236] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.736242] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.736246] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80df, result 0, len 14, seqno 0x9
[   14.736249] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.736255] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xdf, cmd_pending=0
[   14.736265] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
[   14.736276] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x28, act 0x13, len 12, seqno 0xa
[   14.742266] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.742269] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.742275] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.742279] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8028, result 0, len 12, seqno 0xa
[   14.742282] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.742288] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
[   14.742297] mwifiex_pcie 0000:03:00.0: cmd: PS Command: Enter Auto Deep Sleep
[   14.742300] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xe4, cmd_pending=1
[   14.742311] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xe4, act 0xff, len 18, seqno 0xb
[   14.748042] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.748044] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.748051] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.748055] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80e4, result 0, len 18, seqno 0xb
[   14.748058] mwifiex_pcie 0000:03:00.0: info: mwifiex_ret_enh_power_mode: PS_MODE cmd reply result=0x0 action=0XFF
[   14.748060] mwifiex_pcie 0000:03:00.0: cmd: Enabled auto deep sleep
[   14.748063] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.748069] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xe4, cmd_pending=0
[   14.748078] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x9
[   14.748081] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x1, OID=0x9,	OIDSize=0x2, Value=0x1
[   14.748084] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.748095] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x1, len 16, seqno 0xc
[   14.754434] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.754436] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.754443] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.754447] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 16, seqno 0xc
[   14.754450] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x9,	query_type = 0x1, buf size = 0x2
[   14.754452] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.754459] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.754469] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xcd, cmd_pending=1
[   14.754480] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xcd, act 0x1, len 16, seqno 0xd
[   14.762742] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.762744] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.762752] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.762755] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80cd, result 0, len 16, seqno 0xd
[   14.762758] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.762765] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xcd, cmd_pending=0
[   14.762775] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xd6, cmd_pending=1
[   14.762786] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xd6, act 0x0, len 60, seqno 0xe
[   14.771050] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.771052] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.771059] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.771063] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80d6, result 0, len 60, seqno 0xe
[   14.771066] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.771072] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xd6, cmd_pending=0
[   14.771085] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
[   14.771096] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x1e, act 0x0, len 14, seqno 0xf
[   14.777011] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.777014] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.777021] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.777024] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x801e, result 0, len 14, seqno 0xf
[   14.777027] mwifiex_pcie 0000:03:00.0: Current TxPower Level=0, Max Power=18, Min Power=8
[   14.777030] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.777036] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
[   14.777046] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x83, cmd_pending=1
[   14.777057] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x83, act 0x1, len 24, seqno 0x10
[   14.784274] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.784277] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.784284] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.784287] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8083, result 0, len 24, seqno 0x10
[   14.784290] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.784296] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x83, cmd_pending=0
[   14.784307] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xdf, cmd_pending=1
[   14.784318] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xdf, act 0x1, len 14, seqno 0x11
[   14.791624] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.791627] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.791634] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.791637] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80df, result 0, len 14, seqno 0x11
[   14.791640] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.791647] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xdf, cmd_pending=0
[   14.791656] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
[   14.791667] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x28, act 0x13, len 12, seqno 0x12
[   14.799664] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.799666] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.799673] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.799677] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8028, result 0, len 12, seqno 0x12
[   14.799680] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.799686] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
[   14.799695] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x9
[   14.799698] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x1, OID=0x9,	OIDSize=0x2, Value=0x1
[   14.799701] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.799711] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x1, len 16, seqno 0x13
[   14.805702] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.805704] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.805711] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.805715] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 16, seqno 0x13
[   14.805717] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x9,	query_type = 0x1, buf size = 0x2
[   14.805720] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.805726] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.805736] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xcd, cmd_pending=1
[   14.805746] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xcd, act 0x1, len 16, seqno 0x14
[   14.811474] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.811476] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.811483] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.811487] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80cd, result 0, len 16, seqno 0x14
[   14.811489] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.811496] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xcd, cmd_pending=0
[   14.811506] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xd6, cmd_pending=1
[   14.811517] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xd6, act 0x0, len 60, seqno 0x15
[   14.817858] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.817860] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.817867] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.817871] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80d6, result 0, len 60, seqno 0x15
[   14.817874] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.817880] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xd6, cmd_pending=0
[   14.817889] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
[   14.817900] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x1e, act 0x0, len 14, seqno 0x16
[   14.826161] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.826163] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.826169] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.826173] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x801e, result 0, len 14, seqno 0x16
[   14.826176] mwifiex_pcie 0000:03:00.0: Current TxPower Level=0, Max Power=18, Min Power=8
[   14.826178] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.826184] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
[   14.826193] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x83, cmd_pending=1
[   14.826204] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x83, act 0x1, len 24, seqno 0x17
[   14.832106] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.832108] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.832115] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.832118] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8083, result 0, len 24, seqno 0x17
[   14.832121] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.832127] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x83, cmd_pending=0
[   14.832137] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xdf, cmd_pending=1
[   14.832148] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xdf, act 0x1, len 14, seqno 0x18
[   14.839395] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.839397] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.839404] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.839408] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80df, result 0, len 14, seqno 0x18
[   14.839410] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.839417] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xdf, cmd_pending=0
[   14.839438] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
[   14.839450] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x28, act 0x13, len 12, seqno 0x19
[   14.847159] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.847168] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.847203] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.847218] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8028, result 0, len 12, seqno 0x19
[   14.847227] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.847246] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
[   14.855025] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x9
[   14.855028] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x1, OID=0x9,	OIDSize=0x2, Value=0x1
[   14.855031] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.855048] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x1, len 16, seqno 0x1a
[   14.861962] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.861971] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.862004] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.862019] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 16, seqno 0x1a
[   14.862030] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x9,	query_type = 0x1, buf size = 0x2
[   14.862039] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.862058] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.867046] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xcd, cmd_pending=1
[   14.867063] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xcd, act 0x1, len 16, seqno 0x1b
[   14.873822] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.873831] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.873865] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.873879] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80cd, result 0, len 16, seqno 0x1b
[   14.873889] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.873908] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xcd, cmd_pending=0
[   14.882034] mwifiex_pcie 0000:03:00.0: info: cfg80211 regulatory domain callback for 00
[   14.882080] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x20, cmd_pending=1
[   14.882153] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x20, act 0x8, len 16, seqno 0x1c
[   14.888039] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.888047] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.888078] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.888095] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8020, result 0, len 16, seqno 0x1c
[   14.888107] mwifiex_pcie 0000:03:00.0: RF_ANT_RESP: Tx action = 0x8, Tx Mode = 0x0003	Rx action = 0x4, Rx Mode = 0x0003
[   14.888116] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.888139] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x20, cmd_pending=0
[   14.895308] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x8
[   14.895311] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x0, OID=0x8,	OIDSize=0x80, Value=0x0
[   14.895315] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.895338] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x0, len 142, seqno 0x1d
[   14.902715] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.902720] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.902747] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.902756] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 142, seqno 0x1d
[   14.902763] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x8,	query_type = 0x0, buf size = 0x80
[   14.902767] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: FragThsd =2346
[   14.902773] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.902786] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.908360] mwifiex_pcie 0000:03:00.0: info: cfg80211 regulatory domain callback for US
[   14.908368] mwifiex_pcie 0000:03:00.0: info: 11D: no_of_triplet=0x1
[   14.908373] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x5b, cmd_pending=1
[   14.908413] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x5b, act 0x1, len 20, seqno 0x1e
[   14.910747] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x5
[   14.910750] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x0, OID=0x5,	OIDSize=0x80, Value=0x0
[   14.910753] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=2
[   14.910787] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.910790] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.910801] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.910807] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x805b, result 0, len 20, seqno 0x1e
[   14.910811] mwifiex_pcie 0000:03:00.0: info: 11D Domain Info Resp: no_of_triplet=1
[   14.910817] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x5b, cmd_pending=1
[   14.910823] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x0, len 142, seqno 0x1f
[   14.916829] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.916832] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.916842] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.916847] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 142, seqno 0x1f
[   14.916851] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x5,	query_type = 0x0, buf size = 0x80
[   14.916854] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: RTSThsd =2347
[   14.916857] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.916866] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.922505] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x6
[   14.922508] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x0, OID=0x6,	OIDSize=0x80, Value=0x0
[   14.922511] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.922538] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x0, len 142, seqno 0x20
[   14.928884] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.928886] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.928896] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.928901] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 142, seqno 0x20
[   14.928904] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x6,	query_type = 0x0, buf size = 0x80
[   14.928907] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: TxRetryCount=9
[   14.928909] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.928918] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.937125] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x7
[   14.937129] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x0, OID=0x7,	OIDSize=0x80, Value=0x0
[   14.937131] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   14.937157] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x0, len 142, seqno 0x21
[   14.943061] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.943064] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.943073] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.943078] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 142, seqno 0x21
[   14.943081] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x7,	query_type = 0x0, buf size = 0x80
[   14.943084] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.943092] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   14.950291] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xf7, cmd_pending=1
[   14.950317] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xf7, act 0x0, len 9, seqno 0x22
[   14.957560] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.957563] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.957572] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.957577] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80f7, result 0, len 9, seqno 0x22
[   14.957581] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.957589] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xf7, cmd_pending=0
[   14.964819] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xd6, cmd_pending=1
[   14.964855] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xd6, act 0x0, len 60, seqno 0x23
[   14.973030] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.973032] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.973043] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.973047] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80d6, result 0, len 60, seqno 0x23
[   14.973052] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.973060] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xd6, cmd_pending=0
[   14.978917] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
[   14.978957] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x1e, act 0x0, len 14, seqno 0x24
[   14.984708] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.984711] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.984734] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.984739] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x801e, result 0, len 14, seqno 0x24
[   14.984743] mwifiex_pcie 0000:03:00.0: Current TxPower Level=0, Max Power=18, Min Power=8
[   14.984745] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.984754] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
[   14.991008] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x83, cmd_pending=1
[   14.991405] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x83, act 0x1, len 24, seqno 0x25
[   14.999320] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   14.999323] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   14.999333] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   14.999338] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8083, result 0, len 24, seqno 0x25
[   14.999341] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   14.999350] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x83, cmd_pending=0
[   15.009658] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xdf, cmd_pending=1
[   15.009691] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xdf, act 0x1, len 14, seqno 0x26
[   15.016052] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   15.016054] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   15.016063] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   15.016067] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80df, result 0, len 14, seqno 0x26
[   15.016070] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   15.016078] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xdf, cmd_pending=0
[   15.021925] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x28, cmd_pending=1
[   15.021986] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x28, act 0x13, len 12, seqno 0x27
[   15.029201] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   15.029204] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   15.029216] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   15.029221] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8028, result 0, len 12, seqno 0x27
[   15.029224] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   15.029234] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x28, cmd_pending=0
[   15.035487] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: cmd_oid = 0x9
[   15.035490] mwifiex_pcie 0000:03:00.0: cmd: SNMP_CMD: Action=0x1, OID=0x9,	OIDSize=0x2, Value=0x1
[   15.035493] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x16, cmd_pending=1
[   15.035890] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x16, act 0x1, len 16, seqno 0x28
[   15.044581] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   15.044590] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   15.044622] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   15.044636] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x8016, result 0, len 16, seqno 0x28
[   15.044647] mwifiex_pcie 0000:03:00.0: info: SNMP_RESP: oid value = 0x9,	query_type = 0x1, buf size = 0x2
[   15.044706] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   15.044730] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x16, cmd_pending=0
[   15.051760] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0xcd, cmd_pending=1
[   15.052151] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xcd, act 0x1, len 16, seqno 0x29
[   15.060159] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   15.060167] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   15.060204] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   15.060219] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80cd, result 0, len 16, seqno 0x29
[   15.060229] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   15.060252] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0xcd, cmd_pending=0
[   15.066146] mwifiex_pcie 0000:03:00.0: cmd: QUEUE_CMD: cmd=0x1e, cmd_pending=1
[   15.066221] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0x1e, act 0x0, len 14, seqno 0x2a
[   15.071993] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   15.072003] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   15.072038] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   15.072054] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x801e, result 0, len 14, seqno 0x2a
[   15.072064] mwifiex_pcie 0000:03:00.0: Current TxPower Level=0, Max Power=18, Min Power=8
[   15.072073] mwifiex_pcie 0000:03:00.0: cmd completed: status=0
[   15.072097] mwifiex_pcie 0000:03:00.0: cmd: FREE_CMD: cmd=0x1e, cmd_pending=0
[   15.096233] mwifiex_pcie 0000:03:00.0: info: mlan0: Marvell 802.11 Adapter
[   15.096306] mwifiex_pcie 0000:03:00.0: info: MWIFIEX VERSION: mwifiex 1.0 (15.68.7.p53) 
[   15.096308] mwifiex_pcie 0000:03:00.0: driver_version = mwifiex 1.0 (15.68.7.p53) 
[   15.098295] mwifiex_pcie 0000:03:00.0 wlp3s0: renamed from mlan0
[   15.171308] mwifiex_pcie 0000:03:00.0: info: Rx EVENT
[   15.171323] mwifiex_pcie 0000:03:00.0: info: EventReady: Initial <Rd: 0x80, Wr: 0x1>
[   15.171331] mwifiex_pcie 0000:03:00.0: info: Read Index: 0
[   15.171346] mwifiex_pcie 0000:03:00.0: info: Event length: 10
[   15.171367] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   15.171378] mwifiex_pcie 0000:03:00.0: EVENT: cause: 0xb
[   15.171386] mwifiex_pcie 0000:03:00.0: info: EVENT: SLEEP
[   15.171398] mwifiex_pcie 0000:03:00.0: cmd: DNLD_CMD: 0xe4, act 0x5, len 12, seqno 0x2b
[   15.171430] mwifiex_pcie 0000:03:00.0: info: Updated <Rd: 0x81, Wr: 0x1>
[   15.171437] mwifiex_pcie 0000:03:00.0: info: Check Events Again
[   15.171447] mwifiex_pcie 0000:03:00.0: info: EventReady: Initial <Rd: 0x81, Wr: 0x1>
[   15.179262] mwifiex_pcie 0000:03:00.0: info: CMD sent Interrupt
[   15.179267] mwifiex_pcie 0000:03:00.0: info: Rx CMD Response
[   15.179282] mwifiex_pcie 0000:03:00.0: cmd: CMD_RESP: 0x80e4, result 0, len 12, seqno 0x2b
[   15.184007] mwifiex_pcie 0000:03:00.0: max count reached while accessing sleep cookie
[   15.184030] mwifiex_pcie 0000:03:00.0: info: cmd_sent=0 data_sent=0
[   17.482391] audit: type=1305 audit(1472136391.697:4): audit_pid=748 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[   17.962379] random: crng init done
[   18.388549] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   18.393948] Bluetooth: BNEP filters: protocol multicast
[   18.399540] Bluetooth: BNEP socket layer initialized
[   18.982915] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[   19.022331] r8169 0000:01:00.0 p4p1: link down
[   19.026834] r8169 0000:01:00.0 p4p1: link down
[   19.031392] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[   19.047159] IPv6: ADDRCONF(NETDEV_UP): p4p2: link is not ready
[   19.082513] r8169 0000:02:00.0 p4p2: link down
[   19.087064] IPv6: ADDRCONF(NETDEV_UP): p4p2: link is not ready
[   22.147435] r8169 0000:01:00.0 p4p1: link up
[   22.151902] IPv6: ADDRCONF(NETDEV_CHANGE): p4p1: link becomes ready
[   34.670403] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   34.748845] Ebtables v2.0 registered
[   35.131722] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   35.187935] tun: Universal TUN/TAP device driver, 1.6
[   35.193051] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   35.225885] virbr0: port 1(virbr0-nic) entered blocking state
[   35.231709] virbr0: port 1(virbr0-nic) entered disabled state
[   35.250512] device virbr0-nic entered promiscuous mode
[   35.549474] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   35.988369] virbr0: port 1(virbr0-nic) entered blocking state
[   35.994175] virbr0: port 1(virbr0-nic) entered listening state
[   36.127004] virbr0: port 1(virbr0-nic) entered disabled state
[   36.147501] device virbr0-nic left promiscuous mode
[   36.152499] virbr0: port 1(virbr0-nic) entered disabled state

--liOOAslEiF7prFVr--

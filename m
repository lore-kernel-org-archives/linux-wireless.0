Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host250-57-static.36-88-b.business.telecomitalia.it ([88.36.57.250]:57625
	"EHLO MONSTER.residential.fw" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750833AbXDKHPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 03:15:01 -0400
Received: from MONSTER.residential.fw (localhost [127.0.0.1])
	by MONSTER.residential.fw (8.13.8/8.13.8) with ESMTP id l3B7Etgi007241
	for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2007 09:14:55 +0200
Received: (from root@localhost)
	by MONSTER.residential.fw (8.13.8/8.13.8/Submit) id l3B7Eto9007240
	for linux-wireless@vger.kernel.org; Wed, 11 Apr 2007 09:14:55 +0200
Subject: problems with both 3945 drivers
From: Gallo Renato <renatogallo@katamail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 11 Apr 2007 09:14:54 +0200
Message-Id: <1176275694.7163.0.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

lspci
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and
945GT Express Memory Controller Hub (rev 03)
00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and
945GT Express PCI Express Root Port (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 3 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 4 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GHM (ICH7-M DH) LPC Interface
Bridge (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
Serial ATA Storage Controller IDE (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
(rev 02)
01:00.0 VGA compatible controller: nVidia Corporation G70 [GeForce Go
7600] (rev a1)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8055 PCI-E
Gigabit Ethernet Controller (rev 12)
07:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
Network Connection (rev 02)
09:04.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
Video Broadcast Decoder (rev d1)
09:06.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
09:06.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant
IEEE 1394 Host Controller
09:06.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia
Card Reader (SD/MMC/MS/MS PRO/xD)
09:06.3 Class 0805: Texas Instruments PCIxx12 SDA Standard Compliant SD
Host Controller



hw platform is an acer aspire 9814WKMi 
so is linux slackware 11.0 
kernels tried are both 2.6.20.4 and 2.6.20.6
gcc is version 3.4.6
driver/daemon/firmware versions are 
ipw3945-1.2.0.tgz  ipw3945-ucode-1.14.2.tgz ipw3945d-1.7.22.tgz



about ipw3945 driver... sometimes the device just loses the wifi
extentions without apparent reasons/action taken by anyone....
when it happens dmesg gives:


ipw3945: Microcode SW error detected.  Restarting.
ipw3945: request scan called when driver not ready.
ipw3945: Error sending ADD_STA: time out after 500ms.
general protection fault: e290 [#1]
SMP
Modules linked in: snd_rtctimer cisco_ipsec(P) snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss
video1394 raw1394 dv1394
eth1394 irtty_sir sir_dev irlan ircomm_tty ircomm mmc_block hci_uart
ipw3945 ieee80211 ieee80211_crypt sco rfcomm hidp bnep l2cap
lirc_mceusb2 lirc_dev nvidia(P) gspca
pcmcia snd_hda_intel snd_hda_codec videodev ohci1394 snd_pcm sdhci
v4l2_common ieee1394 v4l1_compat mmc_core yenta_socket snd_timer sky2
hci_usb 8250_pnp
rsrc_nonstatic snd irda bluetooth pcmcia_core 8250 serial_core
snd_page_alloc crc_ccitt
CPU:    0
EIP:    0060:[<f90a375e>]    Tainted: P      VLI
EFLAGS: 00010286   (2.6.20.4 #7)
EIP is at ipw_disassociate+0x6e/0xb0 [ipw3945]
eax: 00000018   ebx: f5b74ac4   ecx: 00000018   edx: 00000246
esi: f5b74ac4   edi: f580c840   ebp: 00000246   esp: f6219f2c
ds: 007b   es: 007b   ss: 0068
Process ipw3945/0 (pid: 1375, ti=f6218000 task=c2161a70
task.ti=f6218000)
Stack: f5b74c10 f90a37d8 f5b760ec f5b760e8 c0137c7c 00000000 c200c380
c2161b7c
       00000073 f580c860 f580c84c f90a37a0 f580c840 f580c854 f580c84c
f6219f98
       c0137ea7 ffffffff ffffffff 00000001 00000000 c01215c0 00010000
00000000
Call Trace:
[<f90a37d8>] ipw_bg_disassociate+0x38/0x50 [ipw3945]
[<c0137c7c>] run_workqueue+0x7c/0x150
[<f90a37a0>] ipw_bg_disassociate+0x0/0x50 [ipw3945]
[<c0137ea7>] worker_thread+0x157/0x180
[<c01215c0>] default_wake_function+0x0/0x10
[<c01215c0>] default_wake_function+0x0/0x10
[<c0137d50>] worker_thread+0x0/0x180
[<c013b774>] kthread+0xa4/0xe0
[<c013b6d0>] kthread+0x0/0xe0
[<c0103d87>] kernel_thread_helper+0x7/0x10
=======================
Code: 8b 88 a0 06 00 00 85 c9 75 29 83 b8 f8 05 00 00 02 74 43 8d 83 cc
03 00 00 e8 2f ca 08 c7 89 d8 31 c9 ba f0 45 0c f9 e8 91 81 ff <ff> 5b
b8 01 00 00 00 c3 8b 80
a4 06 00 00 e8 5f 75 0d c7 8b 03
EIP: [<f90a375e>] ipw_disassociate+0x6e/0xb0 [ipw3945] SS:ESP
0068:f6219f2c
azx_pcm_prepare: bufsize=0x10000, fragsize=0x1000, format=0x11


it is annoying since the only way to regain the eth1 wifi extention is
to reboot the whole system.
since it claims a microcode error I thought in my total ignorance it
could be a firmware issue.... is it ? how could it be possible to fix
this in your wise opinion ?



----------------------------------------------------
about iwlwifi (same platform about system and hardware) I have got
versions iwlwifi-0.0.11.tgz  iwlwifi-ucode-2.14.1.tgz mac80211-6.0.0.tgz
of the module/firmware but is gives this error during kern 2.20.6
compilation 
 CC      drivers/net/wireless/mac80211/iwlwifi/base.o
drivers/net/wireless/mac80211/iwlwifi/base.c: In function
`ipw_rate_scale_rate_init':
drivers/net/wireless/mac80211/iwlwifi/base.c:11695: error: structure has
no member named `num_curr_rates'
drivers/net/wireless/mac80211/iwlwifi/base.c:11697: error: structure has
no member named `curr_rates'
drivers/net/wireless/mac80211/iwlwifi/base.c: In function
`ipw_get_lowest_rate':
drivers/net/wireless/mac80211/iwlwifi/base.c:11862: error: structure has
no member named `num_curr_rates'
drivers/net/wireless/mac80211/iwlwifi/base.c:11863: error: structure has
no member named `curr_rates'
drivers/net/wireless/mac80211/iwlwifi/base.c:11869: error: structure has
no member named `curr_rates'
make[5]: *** [drivers/net/wireless/mac80211/iwlwifi/base.o] Error 1
make[4]: *** [drivers/net/wireless/mac80211/iwlwifi] Error 2
make[3]: *** [drivers/net/wireless/mac80211] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2


--------------------------------------------------



additional hw infos:

lshw
monster
    description: Computer
    product: Aspire 9810
    vendor: Acer
    version: Aspire 9810
    serial: LXAF60J146639018292300
    width: 32 bits
    capabilities: smbios-2.31 dmi-2.31
    configuration: administrator_password=disabled boot=oem-specific
frontpanel_password=unknown keyboard_password=unknown
power-on_password=disabled uuid=4007D050-3120-11DB-A70E-00A0D1A02FDB
  *-core
       description: Motherboard
       product: Cheela
       vendor: Acer
       physical id: 2
       version: Not Applicable
       serial: Not Applicable
     *-firmware
          description: BIOS
          vendor: Acer
          physical id: 0
          version: I1.12 (09/13/06)
          size: 102KB
          capabilities: isa pci pcmcia pnp apm upgrade shadowing escd
cdboot acpi usb agp biosbootspecification
     *-cpu
          description: CPU
          product: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz
          vendor: Intel Corp.
          physical id: 4
          bus info: cpu@0
          version: 6.15.6
          serial: 0000-06F6-0000-0000-0000-0000
          slot: U1
          size: 1833MHz
          capacity: 1833MHz
          width: 64 bits
          clock: 166MHz
          capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce
cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse
sse2 ss ht tm pbe x86-64 constant_tsc pni monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr lahf_lm cpufreq
          configuration: id=0
        *-cache:0
             description: L1 cache
             physical id: 5
             slot: L1 Cache
             size: 16KB
             capacity: 16KB
             capabilities: asynchronous internal write-back
        *-cache:1
             description: L2 cache
             physical id: 6
             slot: L2 Cache
             size: 2MB
             capabilities: burst external write-back
        *-logicalcpu:0
             description: Logical CPU
             physical id: 0.1
             width: 64 bits
             capabilities: logical
        *-logicalcpu:1
             description: Logical CPU
             physical id: 0.2
             width: 64 bits
             capabilities: logical
     *-memory
          description: System Memory
          physical id: 12
          slot: System board or motherboard
          size: 2GB
        *-bank:0
             description: SODIMM Synchronous
             physical id: 0
             slot: M1
             size: 1GB
             width: 32 bits
        *-bank:1
             description: SODIMM Synchronous
             physical id: 1
             slot: M2
             size: 1GB
             width: 32 bits
     *-pci
          description: Host bridge
          product: Mobile 945GM/PM/GMS/940GML and 945GT Express Memory
Controller Hub
          vendor: Intel Corporation
          physical id: 100
          bus info: pci@0000:00:00.0
          version: 03
          width: 32 bits
          clock: 33MHz
          configuration: driver=agpgart-intel
        *-pci:0
             description: PCI bridge
             product: Mobile 945GM/PM/GMS/940GML and 945GT Express PCI
Express Root Port
             vendor: Intel Corporation
             physical id: 1
             bus info: pci@0000:00:01.0
             version: 03
             width: 32 bits
             clock: 33MHz
             capabilities: pci pm msi pciexpress normal_decode
bus_master cap_list
             configuration: driver=pcieport-driver
           *-display
                description: VGA compatible controller
                product: G70 [GeForce Go 7600]
                vendor: nVidia Corporation
                physical id: 0
                bus info: pci@0000:01:00.0
                version: a1
                width: 64 bits
                clock: 33MHz
                capabilities: pm msi pciexpress vga bus_master cap_list
                configuration: driver=nvidia latency=0 module=nvidia
        *-multimedia
             description: Audio device
             product: 82801G (ICH7 Family) High Definition Audio
Controller
             vendor: Intel Corporation
             physical id: 1b
             bus info: pci@0000:00:1b.0
             version: 02
             width: 64 bits
             clock: 33MHz
             capabilities: pm msi pciexpress bus_master cap_list
             configuration: driver=HDA Intel latency=0
module=snd_hda_intel
        *-pci:1
             description: PCI bridge
             product: 82801G (ICH7 Family) PCI Express Port 1
             vendor: Intel Corporation
             physical id: 1c
             bus info: pci@0000:00:1c.0
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm normal_decode
bus_master cap_list
             configuration: driver=pcieport-driver
           *-network
                description: Ethernet interface
                product: 88E8055 PCI-E Gigabit Ethernet Controller
                vendor: Marvell Technology Group Ltd.
                physical id: 0
                bus info: pci@0000:02:00.0
                logical name: eth0
                version: 12
                serial: 00:a0:d1:a0:2f:db
                size: 100MB/s
                capacity: 1GB/s
                width: 64 bits
                clock: 33MHz
                capabilities: pm vpd msi pciexpress bus_master cap_list
ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd 1000bt 1000bt-fd
autonegotiation
                configuration: autonegotiation=on broadcast=yes
driver=sky2 driverversion=1.10 duplex=full firmware=N/A ip=192.168.0.35
latency=0 link=yes module=sky2 multicast=yes port=twisted pair
speed=100MB/s
        *-pci:2
             description: PCI bridge
             product: 82801G (ICH7 Family) PCI Express Port 2
             vendor: Intel Corporation
             physical id: 1c.1
             bus info: pci@0000:00:1c.1
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm normal_decode
bus_master cap_list
             configuration: driver=pcieport-driver
        *-pci:3
             description: PCI bridge
             product: 82801G (ICH7 Family) PCI Express Port 3
             vendor: Intel Corporation
             physical id: 1c.2
             bus info: pci@0000:00:1c.2
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm normal_decode
bus_master cap_list
             configuration: driver=pcieport-driver
        *-pci:4
             description: PCI bridge
             product: 82801G (ICH7 Family) PCI Express Port 4
             vendor: Intel Corporation
             physical id: 1c.3
             bus info: pci@0000:00:1c.3
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm normal_decode
bus_master cap_list
             configuration: driver=pcieport-driver
           *-network DISABLED
                description: Wireless interface
                product: PRO/Wireless 3945ABG Network Connection
                vendor: Intel Corporation
                physical id: 0
                bus info: pci@0000:07:00.0
                logical name: eth1
                version: 02
                serial: 00:18:de:47:8f:02
                width: 32 bits
                clock: 33MHz
                capabilities: pm msi pciexpress bus_master cap_list
ethernet physical wireless
                configuration: broadcast=yes driver=ipw3945
driverversion=1.2.0d firmware=14.2 1:0 () latency=0 link=no
module=ipw3945 multicast=yes wireless=unassociated
        *-usb:0
             description: USB Controller
             product: 82801G (ICH7 Family) USB UHCI #1
             vendor: Intel Corporation
             physical id: 1d
             bus info: pci@0000:00:1d.0
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master
             configuration: driver=uhci_hcd latency=0
        *-usb:1
             description: USB Controller
             product: 82801G (ICH7 Family) USB UHCI #2
             vendor: Intel Corporation
             physical id: 1d.1
             bus info: pci@0000:00:1d.1
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master
             configuration: driver=uhci_hcd latency=0
        *-usb:2
             description: USB Controller
             product: 82801G (ICH7 Family) USB UHCI #3
             vendor: Intel Corporation
             physical id: 1d.2
             bus info: pci@0000:00:1d.2
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master
             configuration: driver=uhci_hcd latency=0
        *-usb:3
             description: USB Controller
             product: 82801G (ICH7 Family) USB UHCI #4
             vendor: Intel Corporation
             physical id: 1d.3
             bus info: pci@0000:00:1d.3
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master
             configuration: driver=uhci_hcd latency=0
        *-usb:4
             description: USB Controller
             product: 82801G (ICH7 Family) USB2 EHCI Controller
             vendor: Intel Corporation
             physical id: 1d.7
             bus info: pci@0000:00:1d.7
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: pm debug ehci bus_master cap_list
             configuration: driver=ehci_hcd latency=0
        *-pci:5
             description: PCI bridge
             product: 82801 Mobile PCI Bridge
             vendor: Intel Corporation
             physical id: 1e
             bus info: pci@0000:00:1e.0
             version: e2
             width: 32 bits
             clock: 33MHz
             capabilities: pci subtractive_decode bus_master cap_list
           *-multimedia UNCLAIMED
                description: Multimedia controller
                product: SAA7133/SAA7135 Video Broadcast Decoder
                vendor: Philips Semiconductors
                physical id: 4
                bus info: pci@0000:09:04.0
                version: d1
                width: 32 bits
                clock: 33MHz
                capabilities: pm cap_list
                configuration: latency=0
           *-pcmcia
                description: CardBus bridge
                product: PCIxx12 Cardbus Controller
                vendor: Texas Instruments
                physical id: 6
                bus info: pci@0000:09:06.0
                version: 00
                width: 32 bits
                clock: 33MHz
                capabilities: pcmcia bus_master cap_list
                configuration: driver=yenta_cardbus latency=176
maxlatency=5 mingnt=192 module=yenta_socket
           *-firewire
                description: FireWire (IEEE 1394)
                product: PCIxx12 OHCI Compliant IEEE 1394 Host
Controller
                vendor: Texas Instruments
                physical id: 6.1
                bus info: pci@0000:09:06.1
                version: 00
                width: 32 bits
                clock: 33MHz
                capabilities: pm ohci bus_master cap_list
                configuration: driver=ohci1394 latency=64 maxlatency=4
mingnt=2 module=ohci1394
           *-storage UNCLAIMED
                description: Mass storage controller
                product: 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS
PRO/xD)
                vendor: Texas Instruments
                physical id: 6.2
                bus info: pci@0000:09:06.2
                version: 00
                width: 32 bits
                clock: 33MHz
                capabilities: storage pm cap_list
                configuration: latency=0 maxlatency=4 mingnt=7
           *-system
                description: Generic system peripheral
                product: PCIxx12 SDA Standard Compliant SD Host
Controller
                vendor: Texas Instruments
                physical id: 6.3
                bus info: pci@0000:09:06.3
                version: 00
                width: 32 bits
                clock: 33MHz
                capabilities: pm bus_master cap_list
                configuration: driver=sdhci latency=64 maxlatency=4
mingnt=7 module=sdhci
        *-isa
             description: ISA bridge
             product: 82801GHM (ICH7-M DH) LPC Interface Bridge
             vendor: Intel Corporation
             physical id: 1f
             bus info: pci@0000:00:1f.0
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: isa bus_master cap_list
             configuration: latency=0
        *-ide UNCLAIMED
             description: IDE interface
             product: 82801GBM/GHM (ICH7 Family) Serial ATA Storage
Controller IDE
             vendor: Intel Corporation
             physical id: 1f.2
             bus info: pci@0000:00:1f.2
             version: 02
             width: 32 bits
             clock: 66MHz
             capabilities: ide pm bus_master cap_list
             configuration: latency=0
        *-serial
             description: SMBus
             product: 82801G (ICH7 Family) SMBus Controller
             vendor: Intel Corporation
             physical id: 1f.3
             bus info: pci@0000:00:1f.3
             version: 02
             width: 32 bits
             clock: 33MHz
             configuration: driver=i801_smbus latency=0
  *-ide:0
       description: IDE Channel 0
       physical id: 0
       bus info: ide@0
       logical name: ide0
     *-disk
          description: ATA Disk
          product: ST9120821AS
          vendor: Seagate
          physical id: 0
          bus info: ide@0.0
          logical name: /dev/hda
          version: 3.06
          serial: 5PL2ECA4
          size: 111GB
          capacity: 111GB
          capabilities: ata dma lba iordy smart security pm apm
partitioned partitioned:dos
          configuration: apm=off smart=on
        *-volume:0
             description: Linux filesystem partition
             physical id: 1
             bus info: ide@0.0,1
             logical name: /dev/hda1
             capacity: 108GB
             capabilities: primary bootable
        *-volume:1
             description: Linux swap / Solaris partition
             physical id: 2
             bus info: ide@0.0,2
             logical name: /dev/hda2
             capacity: 3820MB
             capabilities: primary nofs
  *-ide:1
       description: IDE Channel 0
       physical id: 1
       bus info: ide@1
       logical name: ide1
     *-cdrom
          description: DVD-RAM writer
          product: MATSHITADVD-RAM UJ-85JS
          physical id: 1
          bus info: ide@1.1
          logical name: /dev/hdd
          version: F100
          capabilities: packet atapi cdrom removable nonmagnetic dma lba
iordy audio cd-r cd-rw dvd dvd-r dvd-ram
          configuration: mode=udma2 status=open
  *-network:0 DISABLED
       description: Ethernet interface
       physical id: 3
       logical name: irlan0
       capabilities: ethernet physical
       configuration: broadcast=yes multicast=yes
  *-network:1 DISABLED
       description: IEEE1394 interface
       physical id: 4
       logical name: eth2
       serial: 00:a0:d1:a0:d1:a0
       capabilities: ieee1394 physical
       configuration: broadcast=yes driver=eth1394 multicast=yes
  *-network:2 DISABLED
       description: Ethernet interface
       physical id: 5
       logical name: cipsec0
       serial: 00:0b:fc:f8:01:8f
       capabilities: ethernet physical


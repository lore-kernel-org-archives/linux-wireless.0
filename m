Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailserver.naic.edu ([192.65.176.45]:56124 "EHLO
	mailserver.naic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab0LFVZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 16:25:07 -0500
Date: Mon, 6 Dec 2010 17:25:02 -0400
From: Giacomo Comes <comes@naic.edu>
To: Dave Kilroy <kilroyd@googlemail.com>
Cc: Giacomo Comes <comes@naic.edu>, linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs module and WPA not working
Message-ID: <20101206212502.GA31434@monopoli.naic.edu>
References: <AANLkTinLaa+dOiq67DAt+KYfnxUEkNgWEiE2x1NtT9RE@mail.gmail.com> <AANLkTim-hexpFnV_DfKGM53vWo1-5W6fbK4e+jLnb5fB@mail.gmail.com> <20101203202321.GA21937@monopoli.naic.edu> <AANLkTi=qvZ-Uj1T=9Xc8LyyxKvgNw4CKV8Zx2fDfo4uH@mail.gmail.com> <20101204033646.GA22662@monopoli.naic.edu> <AANLkTik=nbdNUU7gzO9V17fHWZibc2LjuXDgpeRDztoM@mail.gmail.com> <20101204134732.GA24216@monopoli.naic.edu> <AANLkTinU+Xv+gNSTJnEz_tYPhcXRf=kEfkyyeuN0QPFt@mail.gmail.com> <20101206042812.GB28134@monopoli.naic.edu> <AANLkTimC4NkPhpmOUWHvWpCZGvXjM1GkZCUja=Qhr=9N@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
In-Reply-To: <AANLkTimC4NkPhpmOUWHvWpCZGvXjM1GkZCUja=Qhr=9N@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 06, 2010 at 06:43:04PM +0000, Dave Kilroy wrote:
> > I have been testing your patches and I can confirm that now the orinoco
> > driver is working properly for me. Using directly wpa_supplicant and using
> > networkmanager.
> > Thank you very much for your work.
> 
> No problem.
> 
> > The only issue still not fixed is the suspend/resume timeout.
> > Can you help also with that?
> 
> Absolutely. With the latest patches, please just do a suspend resume,
> and post the dmesg output. Also let me know what the value of
> CONFIG_HERMES_CACHE_FW_ON_INIT is.

CONFIG_HERMES_CACHE_FW_ON_INIT=y

Attached is the outpur of dmesg after suspend/resume

As you can see, the driver is unable to load the firmware,
therefore WPA is not available after resume:

iwlist eth1 scan:
eth1      Scan completed :
          Cell 01 - Address: 00:13:10:AA:89:4B
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=70/70  Signal level=-37 dBm
                    Encryption key:on
                    ESSID:"Comes"
                    Mode:Master
                    Extra:tsf=0000000000000000
                    Extra: Last beacon: 168ms ago
                    IE: Unknown: 0005436F6D6573

iw dev eth1 scan:
BSS 00:13:10:aa:89:4b (on eth1)
        freq: 2437
        beacon interval: 100
        capability: ESS Privacy PBCC (0x0051)
        signal: -41.00 dBm
        last seen: 0 ms ago
        SSID: Comes

Giacomo

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesgdiff

783a784,912
> [  891.388960] pcmcia_socket pcmcia_socket0: pccard: card ejected from slot 0
> [  891.389460] pcmcia_socket pcmcia_socket1: pccard: card ejected from slot 1
> [  891.389569] pcmcia_socket pcmcia_socket2: pccard: card ejected from slot 2
> [  895.286074] PM: Marking nosave pages: 0000000000002000 - 0000000000010000
> [  895.286081] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
> [  895.286086] PM: Basic memory bitmaps created
> [  895.642068] Syncing filesystems ... done.
> [  895.650034] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [  895.663138] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [  895.674258] PM: Preallocating image memory... done (allocated 72866 pages)
> [  898.531573] PM: Allocated 291464 kbytes in 2.85 seconds (102.26 MB/s)
> [  898.531579] Suspending console(s) (use no_console_suspend to debug)
> [  898.536671] parport_pc 00:0e: disabled
> [  898.540943] serial 00:0d: disabled
> [  898.543249] ACPI handle has no context!
> [  898.543350] [drm] nouveau 0000:01:00.0: Disabling fbcon acceleration...
> [  898.543354] [drm] nouveau 0000:01:00.0: Unpinning framebuffer(s)...
> [  898.543359] [drm] nouveau 0000:01:00.0: Evicting buffers...
> [  898.547445] Intel ICH Modem 0000:00:1f.6: PCI INT B disabled
> [  898.547667] Intel ICH 0000:00:1f.5: PCI INT B disabled
> [  898.628878] [drm] nouveau 0000:01:00.0: Idling channels...
> [  898.629588] [drm] nouveau 0000:01:00.0: Suspending GPU objects...
> [  898.735443] [drm] nouveau 0000:01:00.0: And we're gone!
> [  898.736048] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  898.990935] ata_piix 0000:00:1f.1: PCI INT A disabled
> [  898.990956] PM: freeze of devices complete after 459.026 msecs
> [  898.991448] PM: late freeze of devices complete after 0.483 msecs
> [  898.996744] ACPI: Preparing to enter system sleep state S4
> [  898.997725] PM: Saving platform NVS memory
> [  898.997849] Disabling non-boot CPUs ...
> [  898.997931] PM: Creating hibernation image:
> [  898.998488] PM: Need to copy 58748 pages
> [  898.998488] PM: Normal pages needed: 58748 + 1024, available pages: 72169
> [  898.998488] PM: Restoring platform NVS memory
> [  899.001534] ACPI: Waking up from system sleep state S4
> [  899.014724] ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800003, writing 0x2800007)
> [  899.014759] Intel ICH 0000:00:1f.5: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
> [  899.014863] 3c59x 0000:02:00.0: restoring config space at offset 0x1 (was 0x2100117, writing 0x82100117)
> [  899.014885] yenta_cardbus 0000:02:01.0: restoring config space at offset 0xf (was 0x74001ff, writing 0x5c001ff)
> [  899.014908] yenta_cardbus 0000:02:01.0: restoring config space at offset 0x3 (was 0x822008, writing 0x82a810)
> [  899.014948] yenta_cardbus 0000:02:01.1: restoring config space at offset 0xf (was 0x74001ff, writing 0x5c001ff)
> [  899.014971] yenta_cardbus 0000:02:01.1: restoring config space at offset 0x3 (was 0x822008, writing 0x82a810)
> [  899.014979] yenta_cardbus 0000:02:01.1: restoring config space at offset 0x1 (was 0x2100007, writing 0x82100007)
> [  899.015062] ohci1394 0000:02:01.2: restoring config space at offset 0x1 (was 0x2100116, writing 0x82100116)
> [  899.015085] yenta_cardbus 0000:02:03.0: restoring config space at offset 0xf (was 0x340010b, writing 0x5c0010b)
> [  899.015107] yenta_cardbus 0000:02:03.0: restoring config space at offset 0x3 (was 0x22008, writing 0x2a810)
> [  899.015116] yenta_cardbus 0000:02:03.0: restoring config space at offset 0x1 (was 0x2100007, writing 0x82100007)
> [  899.015493] PM: early restore of devices complete after 0.970 msecs
> [  899.040854] pm_op(): pci_pm_restore+0x0/0xa0 returns -16
> [  899.040860] PM: Device 0000:00:00.0 failed to restore async: error -16
> [  899.040966] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> [  899.041002] usb usb1: root hub lost power or was reset
> [  899.041095] uhci_hcd 0000:00:1d.2: setting latency timer to 64
> [  899.041127] usb usb2: root hub lost power or was reset
> [  899.041193] pci 0000:00:1e.0: setting latency timer to 64
> [  899.041299] ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
> [  899.041306] ata_piix 0000:00:1f.1: setting latency timer to 64
> [  899.041612] Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 5 (level, low) -> IRQ 5
> [  899.041620] Intel ICH 0000:00:1f.5: setting latency timer to 64
> [  899.041691] Intel ICH Modem 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 5 (level, low) -> IRQ 5
> [  899.041699] Intel ICH Modem 0000:00:1f.6: setting latency timer to 64
> [  899.041769] [drm] nouveau 0000:01:00.0: We're back, enabling device...
> [  899.041777] [drm] nouveau 0000:01:00.0: POSTing device...
> [  899.041902] [drm] nouveau 0000:01:00.0: Loading NV17 power sequencing microcode
> [  899.041911] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xC264
> [  899.041954] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xC531
> [  899.041981] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xC34E
> [  899.042051] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xCA34
> [  899.042067] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xC4CC
> [  899.042080] agpgart-intel 0000:00:00.0: AGP 2.0 bridge
> [  899.042105] agpgart-intel 0000:00:00.0: putting AGP V2 device into 4x mode
> [  899.042131] nouveau 0000:01:00.0: putting AGP V2 device into 4x mode
> [  899.042167] [drm] nouveau 0000:01:00.0: Reinitialising engines...
> [  899.042199] [drm] nouveau 0000:01:00.0: Restoring GPU objects...
> [  899.045684] sd 0:0:0:0: [sda] Starting disk
> [  899.086577] [drm] nouveau 0000:01:00.0: Restoring mode...
> [  899.086589] [drm] nouveau 0000:01:00.0: Calling LVDS script 1:
> [  899.086595] [drm] nouveau 0000:01:00.0: Calling LVDS script 6:
> [  899.086600] [drm] nouveau 0000:01:00.0: 0xD6D8: Parsing digital output script table
> [  899.097133] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[11]  MMIO=[f8fff000-f8fff7ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
> [  899.204451] ata1.00: configured for UDMA/100
> [  899.210251] ata1.01: configured for MWDMA2
> [  899.248064] serial 00:0d: activated
> [  899.355134] parport_pc 00:0e: activated
> [  899.608086] [drm] nouveau 0000:01:00.0: Calling LVDS script 2:
> [  899.608095] [drm] nouveau 0000:01:00.0: 0xD780: Parsing digital output script table
> [  899.642115] [drm] nouveau 0000:01:00.0: Calling LVDS script 5:
> [  899.642120] [drm] nouveau 0000:01:00.0: 0xD662: Parsing digital output script table
> [  899.849247] [drm] nouveau 0000:01:00.0: Restoring CRTC_OWNER to 0.
> [  899.882143] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on lvds encoder (output 0)
> [  899.882149] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on vga encoder (output 1)
> [  899.882154] [drm] nouveau 0000:01:00.0: Setting dpms mode 3 on TV encoder (output 2)
> [  899.904777] [drm] nouveau 0000:01:00.0: Output LVDS-1 is running on CRTC 1 using output A
> [  899.904782] [drm] nouveau 0000:01:00.0: Calling LVDS script 6:
> [  899.904787] [drm] nouveau 0000:01:00.0: 0xD6D8: Parsing digital output script table
> [  900.426093] [drm] nouveau 0000:01:00.0: Calling LVDS script 2:
> [  900.426098] [drm] nouveau 0000:01:00.0: 0xD780: Parsing digital output script table
> [  900.460127] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on lvds encoder (output 0)
> [  900.460131] [drm] nouveau 0000:01:00.0: Calling LVDS script 5:
> [  900.460134] [drm] nouveau 0000:01:00.0: 0xD662: Parsing digital output script table
> [  900.664099] [drm] nouveau 0000:01:00.0: Output LVDS-1 is running on CRTC 1 using output A
> [  901.542098] pcmcia_socket pcmcia_socket2: pccard: PCMCIA card inserted into slot 2
> [  901.542438] pcmcia 2.0: pcmcia: registering new device pcmcia2.0
> [  901.624760] orinoco_cs 2.0: Hardware identity 0005:0004:0005:0000
> [  901.624881] orinoco_cs 2.0: Station identity  001f:0001:0008:000a
> [  901.624886] orinoco_cs 2.0: Firmware determined as Lucent/Agere 8.10
> [  901.624891] orinoco_cs 2.0: firmware: requesting agere_sta_fw.bin
> [  961.625193] orinoco_cs 2.0: firmware: requesting agere_sta_fw.bin
> [ 1021.625131] orinoco_cs 2.0: Cannot find firmware agere_sta_fw.bin
> [ 1021.625194] orinoco_cs 2.0: Hardware identity 0005:0004:0005:0000
> [ 1021.625302] orinoco_cs 2.0: Station identity  001f:0001:0008:000a
> [ 1021.625307] orinoco_cs 2.0: Firmware determined as Lucent/Agere 8.10
> [ 1021.625310] orinoco_cs 2.0: Ad-hoc demo mode supported
> [ 1021.625313] orinoco_cs 2.0: IEEE standard IBSS ad-hoc mode supported
> [ 1021.625316] orinoco_cs 2.0: WEP supported, 104-bit key
> [ 1021.627555] PM: restore of devices complete after 122586.854 msecs
> [ 1021.633004] snapshot_deprecated_ioctl: 6 callbacks suppressed
> [ 1021.633064] snapshot_ioctl: ioctl '4004330c' is deprecated and will be removed soon, update your suspend-to-disk utilities
> [ 1021.633072] Restarting tasks ... done.
> [ 1021.644392] PM: Basic memory bitmaps freed
> [ 1021.644406] video LNXVIDEO:00: Restoring backlight state
> [ 1053.626744] Disabling lock debugging due to kernel taint
> [ 1053.652635] ndiswrapper version 1.55 loaded (smp=yes, preempt=yes)
> [ 1053.716507] usbcore: registered new interface driver ndiswrapper
> [ 1053.801470] eth0:  setting full-duplex.
> [ 1053.829438] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [ 1054.154949] eth1: New link status: Disconnected (0002)
> [ 1059.608421] SFW2-INext-ACC-TCP IN=eth0 OUT= MAC=00:08:74:03:ab:0d:00:24:e8:a6:6e:a2:08:00 SRC=192.168.15.100 DST=192.168.15.101 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=4015 DF PROTO=TCP SPT=59089 DPT=22 WINDOW=5840 RES=0x00 SYN URGP=0 OPT (020405B40402080A06E6DD9C0000000001030306) 
> [ 1064.165048] eth0: no IPv6 routers present

--gKMricLos+KVdGMg--

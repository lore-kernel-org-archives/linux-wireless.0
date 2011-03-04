Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60342 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397Ab1CDM7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 07:59:36 -0500
Received: by ewy6 with SMTP id 6so685494ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 04:59:34 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 4 Mar 2011 07:59:34 -0500
Message-ID: <AANLkTinm_O2e5G=zn9umQdRrysyyeX-yndcmD6-9J5Yf@mail.gmail.com>
Subject: brcm80211: ieee80211_register_hw failed, status -22
From: Sheldon Neuberger <neuberger@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using compat-wireless-2011-03-03 and when the brcm80211 module
loads at boot up, I'm getting an an error. See dmesg below.

uname -a:
Linux sheldon-lenovo 2.6.37.2-sheldon-u160lcd-powertop-1 #1 SMP Thu
Mar 3 21:22:39 EST 2011 x86_64 Intel(R) Core(TM) i5 CPU       U 470  @
1.33GHz GenuineIntel GNU/Linux

lspci -vvn | grep 14e4:
04:00.0 0280: 14e4:4727 (rev 01)
Subsystem: 14e4:0510

dmesg:

s:agpgart
[    7.502410] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    7.535645] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    7.552697] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[    7.569634] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[    7.586262] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    7.602587] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    7.628262] sd 0:0:0:0: rpm_resume flags 0x4
[    7.628267] sd 0:0:0:0: rpm_resume returns 1
[    7.636622] PM: Adding info for No Bus:eth0
[    7.636970] atl1c 0000:03:00.0: version 1.0.1.0-NAPI
[    7.637932] PM: Adding info for No Bus:BAT0
[    7.657374] sd 0:0:0:0: rpm_resume flags 0x4
[    7.657378] sd 0:0:0:0: rpm_resume returns 1
[    7.658356] sd 0:0:0:0: rpm_resume flags 0x4
[    7.658363] sd 0:0:0:0: rpm_resume returns 1
[    7.662671] ACPI: Battery Slot [BAT0] (battery present)
[    7.688581] Compat-wireless backport release:
compat-wireless-2011-01-31-25-g9d8e201
[    7.694075] rtc_cmos 00:06: RTC can wake from S4
[    7.695249] usb 2-1.5: New USB device found, idVendor=0bda, idProduct=0138
[    7.695253] usb 2-1.5: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[    7.695257] usb 2-1.5: Product: USB2.0-CRW
[    7.695259] usb 2-1.5: Manufacturer: Generic
[    7.695261] usb 2-1.5: SerialNumber: 20090516388200000
[    7.695382] PM: Adding info for usb:2-1.5
[    7.695454] usb 2-1.5: rpm_resume flags 0x4
[    7.695457] usb 2-1.5: rpm_resume returns 1
[    7.706735] Linux video capture interface: v2.00
[    7.817342] Backport based on linux-next.git next-20110303
[    7.818893] PM: Adding info for usb:2-1.5:1.0
[    7.822530] usb 2-1.5: rpm_resume flags 0x4
[    7.822533] usb 2-1.5: rpm_resume returns 1
[    7.822640] scsi8 : usb-storage 2-1.5:1.0
[    7.822662] PM: Adding info for scsi:host8
[    7.822716] PM: Adding info for No Bus:host8
[    7.822808] PM: Adding info for No Bus:ep_01
[    7.822828] PM: Adding info for No Bus:ep_82
[    7.822865] PM: Adding info for No Bus:usbdev2.3
[    7.822915] PM: Adding info for No Bus:ep_00
[    7.822922] hub 2-1:1.0: rpm_suspend flags 0x0
[    7.822925] hub 2-1:1.0: rpm_suspend returns 0
[    7.858372] PM: Adding info for No Bus:rtc0
[    7.858419] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    7.874227] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    7.898401] brcm80211: module is from the staging directory, the
quality is unknown, you have been warned.
[    7.900720] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    7.931521] usb 1-1.6: rpm_resume flags 0x4
[    7.931526] usb 1-1.6: rpm_resume returns 1
[    7.931543] [drm] Initialized drm 1.1.0 20060810
[    7.931547] uvcvideo: Found UVC 1.00 device Lenovo EasyCamera (5986:0190)
[    7.971829] HDA Intel 0000:00:1b.0: irq 41 for MSI/MSI-X
[    7.971909] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.973572] PM: Adding info for No Bus:video0
[    7.973734] PM: Adding info for No Bus:input4
[    7.973782] input: Lenovo EasyCamera as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input4
[    7.978551] brcm80211 0000:04:00.0: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
[    7.978560] brcm80211 0000:04:00.0: setting latency timer to 64
[    8.008670] PM: Adding info for No Bus:0000:04:00.0
[    8.009181] PM: Adding info for No Bus:event4
[    8.009259] uvcvideo 1-1.6:1.0: rpm_suspend flags 0x0
[    8.009270] uvcvideo 1-1.6:1.0: rpm_suspend returns 0
[    8.009401] usbcore: registered new interface driver uvcvideo
[    8.026970] USB Video Class driver (v1.0.0)
[    8.028264] PM: Removing info for No Bus:0000:04:00.0
[    8.028345] PM: Adding info for No Bus:0000:04:00.0
[    8.046282] PM: Removing info for No Bus:0000:04:00.0
[    8.046480] Found chip type AI (0x13814313)
[    8.048297] uvcvideo 1-1.6:1.0: rpm_resume flags 0x4
[    8.048303] usb 1-1.6: rpm_resume flags 0x0
[    8.048306] usb 1-1.6: rpm_resume returns 1
[    8.048311] uvcvideo 1-1.6:1.0: rpm_resume returns 0
[    8.048451] uvcvideo 1-1.6:1.0: rpm_suspend flags 0x0
[    8.048458] uvcvideo 1-1.6:1.0: rpm_suspend returns 0
[    8.067035] Changing max_res_mask to 0xffff
[    8.083136] Changing min_res_mask to 0x200d
[    8.104910] Applying 4313 WARs
[    8.120917] hda_codec: ALC269VB: BIOS auto-probing.
[    8.121379] wlc_bmac_attach:: deviceid 0x4727 nbands 1 board 0x510
macaddr: ac:81:12:3a:59:4f
[    8.121528] ------------[ cut here ]------------
[    8.121539] WARNING: at
/home/sheldon/compat-wireless-2011-03-03/net/wireless/core.c:475
wiphy_register+0x2de/0x340 [cfg80211]()
[    8.121542] Hardware name: 08945LU
[    8.121543] Modules linked in: snd_hda_codec_realtek i915(+)
brcm80211(C+) drm_kms_helper uvcvideo drm snd_hda_intel(+)
snd_hda_codec mac80211 snd_hwdep snd_pcm videodev rtc_cmos compat
i2c_algo_bit v4l1_compat intel_agp v4l2_compat_ioctl32 atl1c acer_wmi
rtc_core cfg80211 evdev intel_gtt snd_timer battery i2c_i801 psmouse
rtc_lib sg video ac serio_raw snd agpgart shpchp processor thermal
btusb i2c_core output wmi button thermal_sys hwmon soundcore
snd_page_alloc bluetooth rfkill
[    8.121571] Pid: 1504, comm: modprobe Tainted: G         C
2.6.37.2-sheldon-u160lcd-powertop-1 #1
[    8.121574] Call Trace:
[    8.121586]  [<ffffffff8104c2df>] warn_slowpath_common+0x7f/0xc0
[    8.121590]  [<ffffffff8104c33a>] warn_slowpath_null+0x1a/0x20
[    8.121595]  [<ffffffffa026223e>] wiphy_register+0x2de/0x340 [cfg80211]
[    8.121601]  [<ffffffff811135f7>] ? __kmalloc+0x127/0x1f0
[    8.121610]  [<ffffffffa02af22f>] ?
ieee80211_register_hw+0x9f/0x590 [mac80211]
[    8.121615]  [<ffffffffa02af323>] ieee80211_register_hw+0x193/0x590
[mac80211]
[    8.121639]  [<ffffffffa03468c5>] wl_pci_probe+0x656/0x7a0 [brcm80211]
[    8.121645]  [<ffffffff815f910e>] ? __pm_runtime_set_status+0x12e/0x200
[    8.121650]  [<ffffffff81567a3f>] local_pci_probe+0x5f/0xd0
[    8.121654]  [<ffffffff81568118>] pci_device_probe+0x88/0xb0
[    8.121659]  [<ffffffff815ef53a>] ? driver_sysfs_add+0x7a/0xb0
[    8.121662]  [<ffffffff815ef826>] driver_probe_device+0x96/0x1c0
[    8.121666]  [<ffffffff815ef9fb>] __driver_attach+0xab/0xb0
[    8.121669]  [<ffffffff815ef950>] ? __driver_attach+0x0/0xb0
[    8.121672]  [<ffffffff815ee73e>] bus_for_each_dev+0x5e/0x90
[    8.121676]  [<ffffffff815ef4be>] driver_attach+0x1e/0x20
[    8.121679]  [<ffffffff815eefe5>] bus_add_driver+0xd5/0x2d0
[    8.121691]  [<ffffffffa0159000>] ? wl_module_init+0x0/0x84 [brcm80211]
[    8.121694]  [<ffffffff815efc86>] driver_register+0x76/0x140
[    8.121698]  [<ffffffff81072cfd>] ? notifier_call_chain+0x4d/0x70
[    8.121710]  [<ffffffffa0159000>] ? wl_module_init+0x0/0x84 [brcm80211]
[    8.121714]  [<ffffffff815683b6>] __pci_register_driver+0x56/0xd0
[    8.121725]  [<ffffffffa0159082>] wl_module_init+0x82/0x84 [brcm80211]
[    8.121729]  [<ffffffff81000304>] do_one_initcall+0x44/0x170
[    8.121733]  [<ffffffff81088073>] sys_init_module+0xc3/0x210
[    8.121736]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
[    8.121739] ---[ end trace a8bbcf613a799428 ]---
[    8.121742] wl_attach: ieee80211_register_hw failed, status -22
[    8.121744] wl_set_hint: Sending country code US to MAC80211
[    8.121750] wl0: Broadcom BCM43xx 802.11 MAC80211 Driver 5.75.11
(1.82.8.0) (Compiled in . at 23:11:48 on Mar  3 2011)
[    8.333625] Unable to query Synaptics hardware.
[    9.585913] scsi host8: rpm_resume flags 0x4
[    9.585918] scsi host8: rpm_resume returns 1
[    9.585922] scsi host8: rpm_resume flags 0x4
[    9.585924] scsi host8: rpm_resume returns 1
[    9.585950] scsi target8:0:0: rpm_resume flags 0x4
[    9.585952] scsi target8:0:0: rpm_resume returns -11
[    9.588517] scsi 8:0:0:0: Direct-Access     Generic- Multi-Card
  1.00 PQ: 0 ANSI: 0 CCS
[    9.608744] PM: Adding info for scsi:target8:0:0
[    9.608797] scsi target8:0:0: rpm_resume flags 0x4
[    9.608807] scsi target8:0:0: rpm_resume returns 1
[    9.608815] scsi 8:0:0:0: rpm_resume flags 0x0
[    9.608823] scsi 8:0:0:0: rpm_resume returns -11
[    9.608831] scsi 8:0:0:0: rpm_resume flags 0x4
[    9.608837] scsi 8:0:0:0: rpm_resume returns 1
[    9.608921] PM: Adding info for scsi:8:0:0:0
[    9.609042] PM: Adding info for No Bus:8:0:0:0
[    9.609122] PM: Adding info for No Bus:8:0:0:0
[    9.609281] PM: Adding info for No Bus:sg1
[    9.609348] sd 8:0:0:0: Attached scsi generic sg1 type 0
[    9.626102] PM: Adding info for No Bus:8:0:0:0
[    9.626359] PM: Adding info for No Bus:8:16
[    9.626407] scsi target8:0:1: rpm_resume flags 0x4
[    9.626411] scsi target8:0:1: rpm_resume returns -11
[    9.626425] PM: Adding info for No Bus:sdb
[    9.626488] scsi target8:0:2: rpm_resume flags 0x4
[    9.626492] scsi target8:0:2: rpm_resume returns -11
[    9.629268] sd 8:0:0:0: [sdb] Attached SCSI removable disk
[    9.631082] scsi target8:0:3: rpm_resume flags 0x4
[    9.631087] scsi target8:0:3: rpm_resume returns -11
[    9.631182] scsi target8:0:4: rpm_resume flags 0x4
[    9.631185] scsi target8:0:4: rpm_resume returns -11
[    9.631265] scsi target8:0:5: rpm_resume flags 0x4
[    9.631269] scsi target8:0:5: rpm_resume returns -11
[    9.631346] scsi target8:0:6: rpm_resume flags 0x4
[    9.631350] scsi target8:0:6: rpm_resume returns -11
[    9.631426] scsi target8:0:7: rpm_resume flags 0x4
[    9.631429] scsi target8:0:7: rpm_resume returns -11
[    9.634076] sd 8:0:0:0: rpm_resume flags 0x4
[    9.634084] sd 8:0:0:0: rpm_resume returns 1
[    9.651826] PM: Adding info for No Bus:card0
[    9.651895] PM: Adding info for No Bus:pcmC0D7p
[    9.651944] PM: Adding info for No Bus:pcmC0D3p
[    9.651984] PM: Adding info for No Bus:pcmC0D0p
[    9.652024] PM: Adding info for No Bus:pcmC0D0c
[    9.652069] PM: Adding info for No Bus:input5
[    9.652089] input: HDA Intel Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    9.670934] PM: Adding info for No Bus:event5
[    9.671018] PM: Adding info for No Bus:input6
[    9.671052] input: HDA Intel Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    9.690541] PM: Adding info for No Bus:event6
[    9.690630] PM: Adding info for No Bus:hwC0D3
[    9.690714] PM: Adding info for No Bus:hwC0D0
[    9.690809] PM: Adding info for No Bus:controlC0
[    9.690878] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.706831] i915 0000:00:02.0: setting latency timer to 64
[    9.708698] PM: Adding info for No Bus:controlD64
[    9.708886] PM: Adding info for No Bus:card0
[    9.809793] PM: Adding info for i2c:i2c-0
[    9.809900] PM: Adding info for i2c:i2c-1
[    9.809980] PM: Adding info for i2c:i2c-2
[    9.810019] PM: Adding info for i2c:i2c-3
[    9.810054] PM: Adding info for i2c:i2c-4
[    9.810086] PM: Adding info for i2c:i2c-5
[    9.810119] PM: Adding info for i2c:i2c-6
[    9.810150] PM: Adding info for i2c:i2c-7
[    9.810183] PM: Adding info for i2c:i2c-8
[    9.810214] PM: Adding info for i2c:i2c-9
[    9.810247] PM: Adding info for i2c:i2c-10
[    9.810280] PM: Adding info for i2c:i2c-11
[    9.810313] PM: Adding info for i2c:i2c-12
[    9.810345] PM: Adding info for i2c:i2c-13
[    9.810488] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[    9.873921] PM: Adding info for No Bus:card0-LVDS-1
[    9.874043] PM: Adding info for No Bus:card0-VGA-1
[    9.874131] PM: Adding info for i2c:i2c-14
[    9.876495] PM: Removing info for i2c:i2c-14
[    9.876617] PM: Adding info for No Bus:card0-HDMI-A-1
[    9.876752] PM: Adding info for No Bus:card0-DP-1
[    9.877851] PM: Adding info for i2c:i2c-14
[    9.877905] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    9.885692] usb 1-1.2: rpm_suspend flags 0x1
[    9.885702] usb 1-1.2: rpm_suspend returns 0
[    9.885714] usb 1-1.2: rpm_suspend flags 0x2
[    9.896690] usb 1-1.2: rpm_suspend returns 0
[    9.933865] checking generic (d0000000 3ff0000) vs hw (d0000000 10000000)
[    9.933875] fb: conflicting fb hw usage inteldrmfb vs VESA VGA -
removing generic driver
[    9.935814] Console: switching to colour dummy device 80x25
[    9.935863] PM: Removing info for No Bus:fb0
[    9.935995] PM: Removing info for No Bus:vtcon1
[    9.936469] PM: Adding info for No Bus:fb0
[    9.936546] PM: Adding info for No Bus:vtcon1
[    9.991542] [drm:intel_panel_get_max_backlight] *ERROR* fixme: max
PWM is zero.
[    9.991569] Console: switching to colour frame buffer device 170x48
[   10.000213] fb0: inteldrmfb frame buffer device
[   10.000279] drm: registered panic notifier
[   10.040598] PM: Adding info for No Bus:acpi_video0
[   10.044564] PM: Adding info for No Bus:cooling_device4
[   10.044584] acpi device:07: registered as cooling_device4
[   10.044663] PM: Adding info for No Bus:acpi_video0
[   10.045004] PM: Adding info for No Bus:input7
[   10.045032] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input7
[   10.045130] PM: Adding info for No Bus:event7
[   10.045143] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   10.045425] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   10.101670] sd 0:0:0:0: rpm_resume flags 0x4
[   10.101680] sd 0:0:0:0: rpm_resume returns 1
[   10.103228] sd 0:0:0:0: rpm_resume flags 0x4
[   10.103231] sd 0:0:0:0: rpm_resume returns 1
[   10.181761] PM: Adding info for No Bus:input8
[   10.181805] input: PS/2 Synaptics TouchPad as
/devices/platform/i8042/serio1/input/input8
[   10.181960] PM: Adding info for No Bus:mouse0
[   10.182022] PM: Adding info for No Bus:event8
[   10.876482] usb 1-1.6: rpm_suspend flags 0x1
[   10.876492] usb 1-1.6: rpm_suspend returns 0
[   10.876508] usb 1-1.6: rpm_suspend flags 0x2
[   10.887425] usb 1-1.6: rpm_suspend returns 0
[   13.880726] usb 1-1: rpm_suspend flags 0x1
[   13.880736] usb 1-1: rpm_suspend returns 0
[   13.880751] usb 1-1: rpm_suspend flags 0x2
[   13.891581] usb 1-1: rpm_suspend returns 0
[   14.276290] Adding 4886304k swap on /dev/sda2.  Priority:-1
extents:1 across:4886304k SS
[   14.324217] fuse init (API version 7.15)
[   14.324533] PM: Adding info for No Bus:fuse
[   14.493930] sd 0:0:0:0: rpm_resume flags 0x4
[   14.493935] sd 0:0:0:0: rpm_resume returns 1
[   14.494112] EXT4-fs (sda1): re-mounted. Opts: discard
[   14.506894] EXT4-fs (sda1): re-mounted. Opts: discard
[   14.640154] PM: Adding info for platform:parport_pc.956
[   14.640198] PM: Removing info for platform:parport_pc.956
[   14.640252] PM: Adding info for platform:parport_pc.888
[   14.640317] PM: Removing info for platform:parport_pc.888
[   14.640370] PM: Adding info for platform:parport_pc.632
[   14.640416] PM: Removing info for platform:parport_pc.632
[   14.651184] lp: driver loaded but no devices found
[   14.651548] ppdev: user-space parallel port driver
[   16.868825] usb usb1: rpm_suspend flags 0x1
[   16.868832] usb usb1: rpm_suspend returns 0
[   16.868851] usb usb1: rpm_suspend flags 0x2
[   16.868886] usb usb1: rpm_suspend returns 0
[   17.986047] atl1c 0000:03:00.0: irq 43 for MSI/MSI-X
[   36.538530] NET: Registered protocol family 10
[   36.538739] lo: Disabled Privacy Extensions
[   36.538858] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   37.346988] uvcvideo 1-1.6:1.0: rpm_resume flags 0x4
[   37.346995] usb 1-1.6: rpm_resume flags 0x0
[   37.346999] usb 1-1: rpm_resume flags 0x0
[   37.347002] usb usb1: rpm_resume flags 0x0
[   37.347006] ehci_hcd 0000:00:1a.0: rpm_resume flags 0x0
[   37.347009] ehci_hcd 0000:00:1a.0: rpm_resume returns 1
[   37.360282] sd 8:0:0:0: rpm_resume flags 0x4
[   37.360289] sd 0:0:0:0: rpm_resume flags 0x4
[   37.360295] sd 0:0:0:0: rpm_resume returns 1
[   37.360299] sd 8:0:0:0: rpm_resume returns 1
[   37.360427] sd 0:0:0:0: rpm_resume flags 0x4
[   37.360431] sd 0:0:0:0: rpm_resume returns 1
[   37.366480] usb usb1: rpm_resume returns 0
[   37.366685] hub 1-0:1.0: rpm_resume flags 0x4
[   37.366690] usb usb1: rpm_resume flags 0x0
[   37.366694] usb usb1: rpm_resume returns 1
[   37.366698] hub 1-0:1.0: rpm_resume returns 0
[   37.366703] hub 1-0:1.0: rpm_suspend flags 0x0
[   37.366708] hub 1-0:1.0: rpm_suspend returns 0
[   37.404448] usb 1-1: rpm_resume returns 0
[   37.404454] hub 1-1:1.0: rpm_resume flags 0x4
[   37.404458] usb 1-1: rpm_resume flags 0x0
[   37.404462] usb 1-1: rpm_resume returns 1
[   37.404466] hub 1-1:1.0: rpm_resume returns 0
[   37.404470] hub 1-1:1.0: rpm_suspend flags 0x0
[   37.404473] hub 1-1:1.0: rpm_suspend returns 0
[   37.442508] usb 1-1.6: rpm_resume returns 0
[   37.442515] uvcvideo 1-1.6:1.0: rpm_resume returns 0
[   37.443451] uvcvideo 1-1.6:1.0: rpm_suspend flags 0x0
[   37.443457] uvcvideo 1-1.6:1.0: rpm_suspend returns 0
[   38.330993] PM: Adding info for No Bus:mixer
[   38.339935] PM: Adding info for No Bus:dsp
[   38.340010] PM: Adding info for No Bus:audio
[   38.352123] PM: Adding info for No Bus:seq
[   38.360429] PM: Adding info for No Bus:sequencer
[   38.360490] PM: Adding info for No Bus:sequencer2
[   38.392837] PM: Adding info for No Bus:vcs2
[   38.392924] PM: Adding info for No Bus:vcsa2
[   38.393086] PM: Adding info for No Bus:vcs6
[   38.393152] PM: Adding info for No Bus:vcsa6
[   38.394528] PM: Adding info for No Bus:vcs4
[   38.395185] PM: Adding info for No Bus:vcsa4
[   38.395386] PM: Adding info for No Bus:vcs5
[   38.395630] PM: Adding info for No Bus:vcsa5
[   38.396091] PM: Adding info for No Bus:vcs3
[   38.396376] PM: Adding info for No Bus:vcsa3
[   39.847330] usb 1-1.6: rpm_suspend flags 0x1
[   39.847338] usb 1-1.6: rpm_suspend returns 0
[   39.847352] usb 1-1.6: rpm_suspend flags 0x2
[   39.858353] usb 1-1.6: rpm_suspend returns 0
[   42.843519] usb 1-1: rpm_suspend flags 0x1
[   42.843524] usb 1-1: rpm_suspend returns 0
[   42.843541] usb 1-1: rpm_suspend flags 0x2
[   42.854500] usb 1-1: rpm_suspend returns 0
[   45.839666] usb usb1: rpm_suspend flags 0x1
[   45.839672] usb usb1: rpm_suspend returns 0
[   45.839690] usb usb1: rpm_suspend flags 0x2
[   45.839725] usb usb1: rpm_suspend returns 0
[   54.133714] sd 8:0:0:0: rpm_resume flags 0x4
[   54.133720] sd 8:0:0:0: rpm_resume returns 1
[   54.140876] sd 8:0:0:0: rpm_resume flags 0x4
[   54.140880] sd 8:0:0:0: rpm_resume returns 1
[   54.155041] sd 8:0:0:0: rpm_resume flags 0x4
[   54.155051] sd 8:0:0:0: rpm_resume returns 1
[   71.113647] sd 8:0:0:0: rpm_resume flags 0x4
[   71.113653] sd 8:0:0:0: rpm_resume returns 1
[   88.090778] sd 8:0:0:0: rpm_resume flags 0x4
[   88.090784] sd 8:0:0:0: rpm_resume returns 1
[  105.068875] sd 8:0:0:0: rpm_resume flags 0x4
[  105.068881] sd 8:0:0:0: rpm_resume returns 1
[  122.047093] sd 8:0:0:0: rpm_resume flags 0x4
[  122.047106] sd 8:0:0:0: rpm_resume returns 1
[  139.026140] sd 8:0:0:0: rpm_resume flags 0x4
[  139.026147] sd 8:0:0:0: rpm_resume returns 1
[  156.004497] sd 8:0:0:0: rpm_resume flags 0x4
[  156.004503] sd 8:0:0:0: rpm_resume returns 1
[  172.982906] sd 8:0:0:0: rpm_resume flags 0x4
[  172.982912] sd 8:0:0:0: rpm_resume returns 1
[  189.961148] sd 8:0:0:0: rpm_resume flags 0x4
[  189.961154] sd 8:0:0:0: rpm_resume returns 1
[  206.939066] sd 8:0:0:0: rpm_resume flags 0x4
[  206.939072] sd 8:0:0:0: rpm_resume returns 1
[  223.906692] sd 8:0:0:0: rpm_resume flags 0x4
[  223.906698] sd 8:0:0:0: rpm_resume returns 1
[  240.895763] sd 8:0:0:0: rpm_resume flags 0x4
[  240.895769] sd 8:0:0:0: rpm_resume returns 1
[  257.873881] sd 8:0:0:0: rpm_resume flags 0x4
[  257.873887] sd 8:0:0:0: rpm_resume returns 1
[  274.852037] sd 8:0:0:0: rpm_resume flags 0x4
[  274.852043] sd 8:0:0:0: rpm_resume returns 1
[  291.830138] sd 8:0:0:0: rpm_resume flags 0x4
[  291.830144] sd 8:0:0:0: rpm_resume returns 1
[  308.808363] sd 8:0:0:0: rpm_resume flags 0x4
[  308.808369] sd 8:0:0:0: rpm_resume returns 1
[  325.775905] sd 8:0:0:0: rpm_resume flags 0x4
[  325.775910] sd 8:0:0:0: rpm_resume returns 1
[  342.764997] sd 8:0:0:0: rpm_resume flags 0x4
[  342.765002] sd 8:0:0:0: rpm_resume returns 1
[  359.743252] sd 8:0:0:0: rpm_resume flags 0x4
[  359.743258] sd 8:0:0:0: rpm_resume returns 1
[  376.721473] sd 8:0:0:0: rpm_resume flags 0x4
[  376.721478] sd 8:0:0:0: rpm_resume returns 1
[  393.699733] sd 8:0:0:0: rpm_resume flags 0x4
[  393.699739] sd 8:0:0:0: rpm_resume returns 1
[  410.677761] sd 8:0:0:0: rpm_resume flags 0x4
[  410.677767] sd 8:0:0:0: rpm_resume returns 1
[  427.645592] sd 8:0:0:0: rpm_resume flags 0x4
[  427.645598] sd 8:0:0:0: rpm_resume returns 1
[  444.634851] sd 8:0:0:0: rpm_resume flags 0x4
[  444.634857] sd 8:0:0:0: rpm_resume returns 1
[  461.613026] sd 8:0:0:0: rpm_resume flags 0x4
[  461.613032] sd 8:0:0:0: rpm_resume returns 1
[  478.591057] sd 8:0:0:0: rpm_resume flags 0x4
[  478.591063] sd 8:0:0:0: rpm_resume returns 1
[  495.569289] sd 8:0:0:0: rpm_resume flags 0x4
[  495.569295] sd 8:0:0:0: rpm_resume returns 1
[  512.547300] sd 8:0:0:0: rpm_resume flags 0x4
[  512.547306] sd 8:0:0:0: rpm_resume returns 1
[  529.525474] sd 8:0:0:0: rpm_resume flags 0x4
[  529.525487] sd 8:0:0:0: rpm_resume returns 1
[  546.504608] sd 8:0:0:0: rpm_resume flags 0x4
[  546.504614] sd 8:0:0:0: rpm_resume returns 1
[  563.482561] sd 8:0:0:0: rpm_resume flags 0x4
[  563.482567] sd 8:0:0:0: rpm_resume returns 1
[  580.460784] sd 8:0:0:0: rpm_resume flags 0x4
[  580.460790] sd 8:0:0:0: rpm_resume returns 1
[  597.439008] sd 8:0:0:0: rpm_resume flags 0x4
[  597.439014] sd 8:0:0:0: rpm_resume returns 1
[  614.416871] sd 8:0:0:0: rpm_resume flags 0x4
[  614.416877] sd 8:0:0:0: rpm_resume returns 1
[  631.384723] sd 8:0:0:0: rpm_resume flags 0x4
[  631.384728] sd 8:0:0:0: rpm_resume returns 1
[  648.373963] sd 8:0:0:0: rpm_resume flags 0x4
[  648.373969] sd 8:0:0:0: rpm_resume returns 1
[  665.352152] sd 8:0:0:0: rpm_resume flags 0x4
[  665.352158] sd 8:0:0:0: rpm_resume returns 1
[  682.330149] sd 8:0:0:0: rpm_resume flags 0x4
[  682.330154] sd 8:0:0:0: rpm_resume returns 1
[  699.308373] sd 8:0:0:0: rpm_resume flags 0x4
[  699.308379] sd 8:0:0:0: rpm_resume returns 1
[  716.286432] sd 8:0:0:0: rpm_resume flags 0x4
[  716.286438] sd 8:0:0:0: rpm_resume returns 1
[  733.264639] sd 8:0:0:0: rpm_resume flags 0x4
[  733.264644] sd 8:0:0:0: rpm_resume returns 1
[  750.243910] sd 8:0:0:0: rpm_resume flags 0x4
[  750.243916] sd 8:0:0:0: rpm_resume returns 1
[  767.222015] sd 8:0:0:0: rpm_resume flags 0x4
[  767.222021] sd 8:0:0:0: rpm_resume returns 1
[  784.200360] sd 8:0:0:0: rpm_resume flags 0x4
[  784.200366] sd 8:0:0:0: rpm_resume returns 1
[  801.178534] sd 8:0:0:0: rpm_resume flags 0x4
[  801.178540] sd 8:0:0:0: rpm_resume returns 1
[  818.156482] sd 8:0:0:0: rpm_resume flags 0x4
[  818.156487] sd 8:0:0:0: rpm_resume returns 1
[  835.134217] sd 8:0:0:0: rpm_resume flags 0x4
[  835.134222] sd 8:0:0:0: rpm_resume returns 1
[  852.113334] sd 8:0:0:0: rpm_resume flags 0x4
[  852.113340] sd 8:0:0:0: rpm_resume returns 1
[  869.091383] sd 8:0:0:0: rpm_resume flags 0x4
[  869.091388] sd 8:0:0:0: rpm_resume returns 1
[  886.069438] sd 8:0:0:0: rpm_resume flags 0x4
[  886.069444] sd 8:0:0:0: rpm_resume returns 1
[  903.047432] sd 8:0:0:0: rpm_resume flags 0x4
[  903.047439] sd 8:0:0:0: rpm_resume returns 1
[  920.026447] sd 8:0:0:0: rpm_resume flags 0x4
[  920.026453] sd 8:0:0:0: rpm_resume returns 1
[  937.003830] sd 8:0:0:0: rpm_resume flags 0x4
[  937.003843] sd 8:0:0:0: rpm_resume returns 1
[  953.983071] sd 8:0:0:0: rpm_resume flags 0x4
[  953.983076] sd 8:0:0:0: rpm_resume returns 1
[  970.961017] sd 8:0:0:0: rpm_resume flags 0x4
[  970.961023] sd 8:0:0:0: rpm_resume returns 1
[  987.939006] sd 8:0:0:0: rpm_resume flags 0x4
[  987.939012] sd 8:0:0:0: rpm_resume returns 1
[ 1004.917008] sd 8:0:0:0: rpm_resume flags 0x4
[ 1004.917014] sd 8:0:0:0: rpm_resume returns 1
[ 1021.896125] sd 8:0:0:0: rpm_resume flags 0x4
[ 1021.896130] sd 8:0:0:0: rpm_resume returns 1
[ 1038.873427] sd 8:0:0:0: rpm_resume flags 0x4
[ 1038.873439] sd 8:0:0:0: rpm_resume returns 1
[ 1055.852432] sd 8:0:0:0: rpm_resume flags 0x4
[ 1055.852438] sd 8:0:0:0: rpm_resume returns 1
[ 1072.830616] sd 8:0:0:0: rpm_resume flags 0x4
[ 1072.830621] sd 8:0:0:0: rpm_resume returns 1
[ 1089.808787] sd 8:0:0:0: rpm_resume flags 0x4
[ 1089.808792] sd 8:0:0:0: rpm_resume returns 1
[ 1106.786818] sd 8:0:0:0: rpm_resume flags 0x4
[ 1106.786823] sd 8:0:0:0: rpm_resume returns 1
[ 1123.764909] sd 8:0:0:0: rpm_resume flags 0x4
[ 1123.764915] sd 8:0:0:0: rpm_resume returns 1
[ 1140.732898] sd 8:0:0:0: rpm_resume flags 0x4
[ 1140.732904] sd 8:0:0:0: rpm_resume returns 1
[ 1157.722173] sd 8:0:0:0: rpm_resume flags 0x4
[ 1157.722178] sd 8:0:0:0: rpm_resume returns 1
[ 1174.700496] sd 8:0:0:0: rpm_resume flags 0x4
[ 1174.700502] sd 8:0:0:0: rpm_resume returns 1
[ 1191.678373] sd 8:0:0:0: rpm_resume flags 0x4
[ 1191.678379] sd 8:0:0:0: rpm_resume returns 1
[ 1208.656500] sd 8:0:0:0: rpm_resume flags 0x4
[ 1208.656506] sd 8:0:0:0: rpm_resume returns 1
[ 1225.634527] sd 8:0:0:0: rpm_resume flags 0x4
[ 1225.634532] sd 8:0:0:0: rpm_resume returns 1
[ 1242.602069] sd 8:0:0:0: rpm_resume flags 0x4
[ 1242.602076] sd 8:0:0:0: rpm_resume returns 1
[ 1259.591251] sd 8:0:0:0: rpm_resume flags 0x4
[ 1259.591257] sd 8:0:0:0: rpm_resume returns 1
[ 1276.569682] sd 8:0:0:0: rpm_resume flags 0x4
[ 1276.569688] sd 8:0:0:0: rpm_resume returns 1
[ 1293.547856] sd 8:0:0:0: rpm_resume flags 0x4
[ 1293.547862] sd 8:0:0:0: rpm_resume returns 1
[ 1310.526259] sd 8:0:0:0: rpm_resume flags 0x4
[ 1310.526264] sd 8:0:0:0: rpm_resume returns 1
[ 1327.504255] sd 8:0:0:0: rpm_resume flags 0x4
[ 1327.504261] sd 8:0:0:0: rpm_resume returns 1
[ 1344.472135] sd 8:0:0:0: rpm_resume flags 0x4
[ 1344.472140] sd 8:0:0:0: rpm_resume returns 1
[ 1361.461341] sd 8:0:0:0: rpm_resume flags 0x4
[ 1361.461347] sd 8:0:0:0: rpm_resume returns 1
[ 1374.774686] hub 2-1:1.0: rpm_resume flags 0x4
[ 1374.774692] usb 2-1: rpm_resume flags 0x0
[ 1374.774695] usb 2-1: rpm_resume returns 1
[ 1374.774699] hub 2-1:1.0: rpm_resume returns 0
[ 1374.952451] usb 2-1.3: new high speed USB device using ehci_hcd and address 4
[ 1375.037345] usb 2-1.3: rpm_resume flags 0x0
[ 1375.037349] usb 2-1.3: rpm_resume returns -11
[ 1375.083154] usb 2-1.3: New USB device found, idVendor=1307, idProduct=0165
[ 1375.083159] usb 2-1.3: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[ 1375.083163] usb 2-1.3: Product: USB Mass Storage Device
[ 1375.083166] usb 2-1.3: Manufacturer: USBest Technology
[ 1375.083169] usb 2-1.3: SerialNumber: 1001095703c1c5
[ 1375.083292] PM: Adding info for usb:2-1.3
[ 1375.083340] usb 2-1.3: rpm_resume flags 0x4
[ 1375.083344] usb 2-1.3: rpm_resume returns 1
[ 1375.083545] PM: Adding info for usb:2-1.3:1.0
[ 1375.083603] usb 2-1.3: rpm_resume flags 0x4
[ 1375.083608] usb 2-1.3: rpm_resume returns 1
[ 1375.083691] scsi9 : usb-storage 2-1.3:1.0
[ 1375.083730] PM: Adding info for scsi:host9
[ 1375.083805] PM: Adding info for No Bus:host9
[ 1375.083915] PM: Adding info for No Bus:ep_01
[ 1375.083966] PM: Adding info for No Bus:ep_82
[ 1375.084022] PM: Adding info for No Bus:ep_83
[ 1375.084073] PM: Adding info for No Bus:usbdev2.4
[ 1375.084187] PM: Adding info for No Bus:ep_00
[ 1375.084194] hub 2-1:1.0: rpm_suspend flags 0x0
[ 1375.084200] hub 2-1:1.0: rpm_suspend returns 0
[ 1376.082056] scsi host9: rpm_resume flags 0x4
[ 1376.082062] scsi host9: rpm_resume returns 1
[ 1376.082066] scsi host9: rpm_resume flags 0x4
[ 1376.082069] scsi host9: rpm_resume returns 1
[ 1376.082092] scsi target9:0:0: rpm_resume flags 0x4
[ 1376.082095] scsi target9:0:0: rpm_resume returns -11
[ 1376.082831] scsi 9:0:0:0: Direct-Access     EDGE     DiskGO
  0.00 PQ: 0 ANSI: 2
[ 1376.082871] PM: Adding info for scsi:target9:0:0
[ 1376.082899] scsi target9:0:0: rpm_resume flags 0x4
[ 1376.082903] scsi target9:0:0: rpm_resume returns 1
[ 1376.082907] scsi 9:0:0:0: rpm_resume flags 0x0
[ 1376.082911] scsi 9:0:0:0: rpm_resume returns -11
[ 1376.082915] scsi 9:0:0:0: rpm_resume flags 0x4
[ 1376.082918] scsi 9:0:0:0: rpm_resume returns 1
[ 1376.082965] PM: Adding info for scsi:9:0:0:0
[ 1376.083056] PM: Adding info for No Bus:9:0:0:0
[ 1376.083109] PM: Adding info for No Bus:9:0:0:0
[ 1376.083214] PM: Adding info for No Bus:sg2
[ 1376.083292] sd 9:0:0:0: Attached scsi generic sg2 type 0
[ 1376.083360] PM: Adding info for No Bus:9:0:0:0
[ 1376.083491] scsi target9:0:1: rpm_resume flags 0x4
[ 1376.083496] scsi target9:0:1: rpm_resume returns -11
[ 1376.084106] sd 9:0:0:0: [sdc] 1974272 512-byte logical blocks:
(1.01 GB/964 MiB)
[ 1376.084258] scsi target9:0:2: rpm_resume flags 0x4
[ 1376.084269] scsi target9:0:2: rpm_resume returns -11
[ 1376.084796] sd 9:0:0:0: [sdc] Write Protect is off
[ 1376.084810] sd 9:0:0:0: [sdc] Mode Sense: 00 00 00 00
[ 1376.084819] sd 9:0:0:0: [sdc] Assuming drive cache: write through
[ 1376.084949] PM: Adding info for No Bus:8:32
[ 1376.085111] PM: Adding info for No Bus:sdc
[ 1376.085155] sd 9:0:0:0: rpm_resume flags 0x4
[ 1376.085165] sd 9:0:0:0: rpm_resume returns 1
[ 1376.085307] scsi target9:0:3: rpm_resume flags 0x4
[ 1376.085316] scsi target9:0:3: rpm_resume returns -11
[ 1376.085710] scsi target9:0:4: rpm_resume flags 0x4
[ 1376.085721] scsi target9:0:4: rpm_resume returns -11
[ 1376.086867] scsi target9:0:5: rpm_resume flags 0x4
[ 1376.086878] scsi target9:0:5: rpm_resume returns -11
[ 1376.087101] scsi target9:0:6: rpm_resume flags 0x4
[ 1376.087110] scsi target9:0:6: rpm_resume returns -11
[ 1376.087501] scsi target9:0:7: rpm_resume flags 0x4
[ 1376.087511] scsi target9:0:7: rpm_resume returns -11
[ 1376.088027] sd 9:0:0:0: [sdc] Assuming drive cache: write through
[ 1376.208120]  sdc:
[ 1376.209769] sd 9:0:0:0: [sdc] Assuming drive cache: write through
[ 1376.209775] sd 9:0:0:0: [sdc] Attached SCSI removable disk
[ 1376.214278] sd 9:0:0:0: rpm_resume flags 0x4
[ 1376.214288] sd 9:0:0:0: rpm_resume returns 1
[ 1376.480136] sd 9:0:0:0: rpm_resume flags 0x4
[ 1376.480146] sd 9:0:0:0: rpm_resume returns 1
[ 1376.541638] sd 9:0:0:0: rpm_resume flags 0x4
[ 1376.541651] sd 9:0:0:0: rpm_resume returns 1
[ 1378.424051] sd 8:0:0:0: rpm_resume flags 0x4
[ 1378.424057] sd 8:0:0:0: rpm_resume returns 1
[ 1386.390044] sd 9:0:0:0: rpm_resume flags 0x4
[ 1386.390054] sd 9:0:0:0: rpm_resume returns 1
[ 1386.646615] sd 9:0:0:0: rpm_resume flags 0x4
[ 1386.646625] sd 9:0:0:0: rpm_resume returns 1
[ 1393.419914] sd 9:0:0:0: rpm_resume flags 0x4
[ 1393.419919] sd 9:0:0:0: rpm_resume returns 1
[ 1393.425800] sd 9:0:0:0: rpm_resume flags 0x4
[ 1393.425810] sd 9:0:0:0: rpm_resume returns 1
[ 1395.401383] sd 9:0:0:0: rpm_resume flags 0x4
[ 1395.401393] sd 9:0:0:0: rpm_resume returns 1
[ 1395.417517] sd 8:0:0:0: rpm_resume flags 0x4
[ 1395.417526] sd 8:0:0:0: rpm_resume returns 1
[ 1395.453914] sd 9:0:0:0: rpm_resume flags 0x4
[ 1395.453923] sd 9:0:0:0: rpm_resume returns 1
[ 1410.397791] sd 9:0:0:0: rpm_resume flags 0x4
[ 1410.397797] sd 9:0:0:0: rpm_resume returns 1
[ 1412.396280] sd 8:0:0:0: rpm_resume flags 0x4
[ 1412.396285] sd 8:0:0:0: rpm_resume returns 1

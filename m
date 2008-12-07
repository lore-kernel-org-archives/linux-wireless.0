Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48317 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbYLGV2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 16:28:32 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1L9RAv-0002yF-06
	for linux-wireless@vger.kernel.org; Sun, 07 Dec 2008 21:28:27 +0000
Received: from 206-248-161-192.dsl.teksavvy.com ([206.248.161.192])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 21:28:24 +0000
Received: from monnier by 206-248-161-192.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 21:28:24 +0000
To: linux-wireless@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: rt73 doesn't show up at boot (and neither at resume from hibernation)
Date: Sun, 07 Dec 2008 16:28:11 -0500
Message-ID: <jwvoczn65zk.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org> (sfid-20081207_222839_640399_FD0A36DD)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My rt73 USB dongle used to work fine (that was a while back, when it
was not part of the stock kernel).   Nowadays, it works OK except that
it refuses to show up at boot, and it also refuses to show up after
a resume from hibernation.  I.e. after turning ON my machine I have to
wait for Linux to come (back) up and then unplug the dongle and plug it
back in.

Once I plug it back in, everything works just dandy again.  I'm using
2.6.26-1-686-bigmem (stock Debian kernel) on a Debian testing system.
Any idea what might be going on or what kind of info might be useful to
try and figure out where the problem comes from?

Here's the relevant part of my `dmesg' after a resume from hibernation.
It does include some relevant error message, tho it doesn't "speak" to me.


        Stefan


[45886.021582] PM: Creating hibernation image: 
[45886.024850] PM: Need to copy 105239 pages
[45886.024850] Intel machine check architecture supported.
[45886.024850] Intel machine check reporting enabled on CPU#0.
[45886.916905] Enabling non-boot CPUs ...
[45886.916905] CPU0 attaching NULL sched-domain.
[45886.916905] SMP alternatives: switching to SMP code
[45886.916905] Booting processor 1/1 ip 6000
[45886.916905] Initializing CPU#1
[45886.916905] Calibrating delay using timer specific routine.. 4825.06 BogoMIPS (lpj=9650125)
[45886.916905] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[45886.916905] CPU: L2 Cache: 1024K (64 bytes/line)
[45886.916905] CPU 1(2) -> Core 1
[45886.916905] Intel machine check architecture supported.
[45886.916905] Intel machine check reporting enabled on CPU#1.
[45886.997092] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4800+ stepping 02
[45886.997119] CPU0 attaching sched-domain:
[45886.997122]  domain 0: span 0-1
[45886.997123]   groups: 0 1
[45886.997127] CPU1 attaching sched-domain:
[45886.997128]  domain 0: span 0-1
[45886.997130]   groups: 1 0
[45886.916905] CPU1 is up
[45886.916905] ACPI: Unable to turn cooling device [f7440ec8] 'off'
[45887.108853] Switched to high resolution mode on CPU 1
[45887.108879] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 23 (level, low) -> IRQ 23
[45887.108884] PCI: Setting latency timer of device 0000:00:02.0 to 64
[45887.166842] usb usb1: root hub lost power or was reset
[45887.166849] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 22 (level, low) -> IRQ 22
[45887.166853] PCI: Setting latency timer of device 0000:00:02.1 to 64
[45887.166866] usb usb2: root hub lost power or was reset
[45887.166871] ehci_hcd 0000:00:02.1: debug port 1
[45887.166874] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[45887.166885] PM: Writing back config space on device 0000:00:04.0 at offset 5 (was 1001, writing e001)
[45887.166889] PM: Writing back config space on device 0000:00:04.0 at offset 1 (was b00000, writing b00003)
[45887.166896] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 22 (level, low) -> IRQ 22
[45887.166900] PCI: Setting latency timer of device 0000:00:04.0 to 64
[45887.174855] PM: Writing back config space on device 0000:00:07.0 at offset 1 (was b00003, writing b00007)
[45887.174863] ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 21 (level, low) -> IRQ 21
[45887.174866] PCI: Setting latency timer of device 0000:00:07.0 to 64
[45887.174889] PM: Writing back config space on device 0000:00:08.0 at offset 1 (was b00003, writing b00007)
[45887.174896] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 20 (level, low) -> IRQ 20
[45887.174900] PCI: Setting latency timer of device 0000:00:08.0 to 64
[45887.174918] PCI: Setting latency timer of device 0000:00:09.0 to 64
[45887.174927] PM: Writing back config space on device 0000:00:0a.0 at offset 1 (was b00007, writing b80003)
[45887.174949] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[45887.174969] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[45887.174988] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[45887.175007] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[45887.188855] PM: Writing back config space on device 0000:05:0b.0 at offset f (was 4020100, writing 40201ff)
[45887.188865] PM: Writing back config space on device 0000:05:0b.0 at offset 5 (was 0, writing d4004000)
[45887.188869] PM: Writing back config space on device 0000:05:0b.0 at offset 4 (was 0, writing d4008000)
[45887.188872] PM: Writing back config space on device 0000:05:0b.0 at offset 3 (was 0, writing 2008)
[45887.188877] PM: Writing back config space on device 0000:05:0b.0 at offset 1 (was 2100000, writing 2100006)
[45887.238446] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[d4008000-d40087ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[45887.322038] PM: Writing back config space on device 0000:05:0c.0 at offset f (was 1f170100, writing 1f170105)
[45887.322047] PM: Writing back config space on device 0000:05:0c.0 at offset 5 (was 1, writing a001)
[45887.322051] PM: Writing back config space on device 0000:05:0c.0 at offset 4 (was 0, writing d4000000)
[45887.322054] PM: Writing back config space on device 0000:05:0c.0 at offset 3 (was 0, writing 2008)
[45887.322059] PM: Writing back config space on device 0000:05:0c.0 at offset 1 (was 2b00000, writing 2b00007)
[45887.322086] skge eth-up: enabling interface
[45887.326202] serial 00:08: activated
[45887.327390] parport_pc 00:09: activated
[45887.328287] mpu401 00:0a: activated
[45887.328846] ns558 00:0b: activated
[45887.496737] ata1: SATA link down (SStatus 0 SControl 300)
[45887.496801] ata4: SATA link down (SStatus 0 SControl 300)
[45887.651615] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[45887.651733] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[45887.659768] ata2.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[45887.659814] ata3.00: ACPI cmd ef/03:46:00:00:00:a0 filtered out
[45887.692079] ata2.00: configured for UDMA/133
[45887.692124] sd 1:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[45887.692139] sd 1:0:0:0: [sda] Write Protect is off
[45887.692141] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[45887.692164] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[45887.755582] ata3.00: configured for UDMA/133
[45887.755582] sd 2:0:0:0: [sdb] 390721968 512-byte hardware sectors (200050 MB)
[45887.755582] sd 2:0:0:0: [sdb] Write Protect is off
[45887.755582] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[45887.755582] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[45887.775013] sd 1:0:0:0: [sda] Starting disk
[45887.905306] usb 2-5: reset high speed USB device using ehci_hcd and address 4
[45888.046953] sd 2:0:0:0: [sdb] Starting disk
[45888.060004] hub 1-3:1.0: hub_port_status failed (err = -62)
[45888.060004] hub 1-3:1.0: hub_port_status failed (err = -62)
[45888.060004] hub 1-3:1.0: hub_port_status failed (err = -62)
[45888.060004] hub 1-3:1.0: hub_port_status failed (err = -62)
[45888.073277] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[45888.074072] hda: UDMA/33 mode selected
[45888.077223] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[45888.077250] hdc: set_drive_speed_status: status=0x6f { DriveReady DeviceFault DataRequest CorrectedError Index Error }
[45888.077255] hdc: set_drive_speed_status: error=0x6f { DriveStatusError UncorrectableError TrackZeroNotFound AddrMarkNotFound }, LBAsect=8830587504648, sector=18446744073709551615
[45888.077266] ide: failed opcode was: unknown
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.190462] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.232490] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.235486] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.235488] hub 1-3:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
[45889.238476] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.239583] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.239583] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.239583] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.239583] hub 1-3:1.0: cannot reset port 3 (err = -62)
[45889.239583] hub 1-3:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
[45918.801084] Restarting tasks ... done.
[45918.948502] usb 1-2: USB disconnect, address 9
[45918.948606] usb0: unregister 'cdc_ether' usb-0000:00:02.0-2, CDC Ethernet Device
[45919.267966] usb 1-2: new full speed USB device using ohci_hcd and address 10
[45919.506947] usb 1-2: configuration #1 chosen from 2 choices
[45919.519439] usb0: register 'cdc_ether' at usb-0000:00:02.0-2, CDC Ethernet Device, b2:b0:68:7a:d4:da
[45919.527441] usb 1-2: New USB device found, idVendor=1457, idProduct=5122
[45919.527441] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[45919.527441] usb 1-2: Product: RNDIS/Ethernet Gadget
[45919.527441] usb 1-2: Manufacturer: Linux 2.6.24/s3c2410_udc
[45919.527441] usb 1-3: USB disconnect, address 2
[45919.527441] usb 1-3.1: USB disconnect, address 3
[45919.592455] usb 1-3.3: USB disconnect, address 4
[45919.718886] usb 1-3.4: USB disconnect, address 5
[45920.143846] usb 1-3: new full speed USB device using ohci_hcd and address 11
[45920.355091] usb 1-3: configuration #1 chosen from 1 choice
[45920.355091] hub 1-3:1.0: USB hub found
[45920.373085] hub 1-3:1.0: 4 ports detected
[45920.490113] usb 1-3: New USB device found, idVendor=04b3, idProduct=3016
[45920.490155] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[45920.490187] usb 1-3: Product: USB 1.1 2 port downstream low-power hub
[45920.490214] usb 1-3: Manufacturer: Lite-On Tech
[45920.620098] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 0x09 failed for offset 0x0000 with error -71.
[45920.623941] phy3 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x3000 with error -71.
[45920.623941] phy3 -> rt73usb_init_eeprom: Error - Invalid RT chipset detected.
[45920.623941] phy3 -> rt2x00lib_probe_dev: Error - Failed to allocate device.
[45920.876081] usb 1-3.1: new low speed USB device using ohci_hcd and address 12
[45921.000080] usb 1-3.1: configuration #1 chosen from 1 choice
[45921.012454] input: Logitech USB-PS/2 Optical Mouse as /class/input/input13
[45921.066888] input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.0-3.1
[45921.067034] usb 1-3.1: New USB device found, idVendor=046d, idProduct=c03e
[45921.067065] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[45921.067098] usb 1-3.1: Product: USB-PS/2 Optical Mouse
[45921.067119] usb 1-3.1: Manufacturer: Logitech
[45921.307049] usb 1-3.3: new low speed USB device using ohci_hcd and address 13
[45921.431802] usb 1-3.3: configuration #1 chosen from 1 choice
[45921.445707] input: Lite-On Tech IBM USB Travel Keyboard with UltraNav as /class/input/input14
[45921.488839] input,hidraw1: USB HID v1.00 Keyboard [Lite-On Tech IBM USB Travel Keyboard with UltraNav] on usb-0000:00:02.0-3.3
[45921.503910] input: Lite-On Tech IBM USB Travel Keyboard with UltraNav as /class/input/input15
[45921.558099] input,hidraw2: USB HID v1.00 Device [Lite-On Tech IBM USB Travel Keyboard with UltraNav] on usb-0000:00:02.0-3.3
[45921.558258] usb 1-3.3: New USB device found, idVendor=04b3, idProduct=3019
[45921.558289] usb 1-3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[45921.558322] usb 1-3.3: Product: IBM USB Travel Keyboard with UltraNav
[45921.558349] usb 1-3.3: Manufacturer: Lite-On Tech
[45921.785900] usb 1-3.4: new low speed USB device using ohci_hcd and address 14
[45921.908928] usb 1-3.4: configuration #1 chosen from 1 choice
[45921.936932] input: Synaptics Inc. Composite TouchPad / TrackPoint as /class/input/input16
[45921.966880] input,hidraw3: USB HID v1.00 Mouse [Synaptics Inc. Composite TouchPad / TrackPoint] on usb-0000:00:02.0-3.4
[45921.984561] input: Synaptics Inc. Composite TouchPad / TrackPoint as /class/input/input17
[45922.026791] input,hidraw4: USB HID v1.00 Mouse [Synaptics Inc. Composite TouchPad / TrackPoint] on usb-0000:00:02.0-3.4
[45922.026735] usb 1-3.4: New USB device found, idVendor=06cb, idProduct=0009
[45922.026735] usb 1-3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[45922.028185] usb 1-3.4: Product: Composite TouchPad / TrackPoint
[45922.029632] usb 1-3.4: Manufacturer: Synaptics Inc.
[45922.032589] usbcore: registered new interface driver rt73usb
[45922.050737] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[45922.050737] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 23
[45922.050737] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[45922.579618] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:15:f2:68:e9:f0
[45922.579618] forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
[45922.598590] eth-down: no link during initialization.
[45922.602594] udev: renamed network interface eth0 to eth-down
[45922.602594] ADDRCONF(NETDEV_UP): eth-down: link is not ready
[45930.653955] usb0: no IPv6 routers present
[46144.975252] usb 2-1: USB disconnect, address 5
[46150.872491] usb 2-1: new high speed USB device using ehci_hcd and address 10
[46151.175136] usb 2-1: configuration #1 chosen from 1 choice
[46151.442767] phy4: Selected rate control algorithm 'pid'
[46151.442767] Registered led device: rt73usb-phy4:radio
[46151.442767] Registered led device: rt73usb-phy4:assoc
[46151.442767] Registered led device: rt73usb-phy4:quality
[46151.443789] usb 2-1: New USB device found, idVendor=050d, idProduct=705a
[46151.443798] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[46151.443800] usb 2-1: Product: Belkin 54g USB Network Adapter
[46151.443803] usb 2-1: Manufacturer: Belkin
[46151.514828] firmware: requesting rt73.bin
[46151.603225] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[46152.871201] wlan0: Initial auth_alg=0
[46152.871201] wlan0: authenticate with AP 00:18:3f:cb:5a:59
[46152.965309] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[46163.799142] wlan0: Initial auth_alg=0
[46163.799142] wlan0: authenticate with AP 00:18:3f:cb:5a:59
[46163.799336] wlan0: RX authentication from 00:18:3f:cb:5a:59 (alg=0 transaction=2 status=0)
[46163.799341] wlan0: authenticated
[46163.799344] wlan0: associate with AP 00:18:3f:cb:5a:59
[46163.803142] wlan0: RX AssocResp from 00:18:3f:cb:5a:59 (capab=0x431 status=0 aid=3)
[46163.803142] wlan0: associated
[46163.803142] wlan0: switched to short barker preamble (BSSID=00:18:3f:cb:5a:59)
[46163.809120] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[46175.316391] wlan0: no IPv6 routers present


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38110 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246Ab0CGD0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Mar 2010 22:26:22 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Wouter Verhelst <wouter@debian.org>, 572664@bugs.debian.org
In-Reply-To: <20100305155155.3578.80301.reportbug@celtic.nixsys.be>
References: <20100305155155.3578.80301.reportbug@celtic.nixsys.be>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mbnFn+Wso6lL9DckBDil"
Date: Sun, 07 Mar 2010 03:26:13 +0000
Message-ID: <1267932373.2819.393.camel@localhost>
Mime-Version: 1.0
Subject: Re: iwlagn driver is no longer able to manage Intel 5100 AGN
 wireless controller
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mbnFn+Wso6lL9DckBDil
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-03-05 at 16:51 +0100, Wouter Verhelst wrote:
> Package: linux-2.6
> Version: 2.6.32-8
> Severity: important
>=20
> Hi,
>=20
> Since about a month or so, I can not bring my wireless network interface
> up anymore. At first I thought it was a hardware issue, but that's not
> the case; under "that other" OS, everything seems to work fine.
>=20
> When I try to bring it up, the following ensues:
>=20
> wouter@celtic:~$ sudo ip link set wlan0 up
> RTNETLINK answers: Unknown error 132
>=20
> Ben Hutchings told me on IRC that error 132 meant ERFKILL, i.e., that
> the RF kill button would be engaged. But that is not the case; and
> toggling it does not seem to change anything.

Is this a known bug?  Otherwise, can anyone help Wouter to debug it?

> -- Package-specific info:
> ** Version:
> Linux version 2.6.32-2-amd64 (Debian 2.6.32-8) (ben@decadent.org.uk) (gcc=
 version 4.3.4 (Debian 4.3.4-6) ) #1 SMP Fri Feb 12 00:01:47 UTC 2010
>=20
> ** Command line:
> BOOT_IMAGE=3D/boot/vmlinuz-2.6.32-2-amd64 root=3DUUID=3Dacdf54ed-d8be-453=
3-a9c6-5a66d77fb0e3 ro vdso32=3D2
>=20
> ** Tainted: W (512)
>  * Taint on warning.

This warning is due to a broken DMAR table and seems unrelated.

More system information follows.

Ben.

> ** Kernel log:
> [    8.248978] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [    8.251400] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [    8.252409]  sdb: sdb1
> [    8.255402] sd 6:0:0:0: [sdb] Assuming drive cache: write through
> [    8.256461] sd 6:0:0:0: [sdb] Attached SCSI disk
> [    8.464124] Linux video capture interface: v2.00
> [    8.545487] ACPI: AC Adapter [AC] (on-line)
> [    8.852235] ACPI: SSDT 000000007bac6c18 002B7 (v01  PmRef  Cpu0Ist 000=
03000 INTL 20060912)
> [    8.853838] ACPI: SSDT 000000007bac4618 0057B (v01  PmRef  Cpu0Cst 000=
03001 INTL 20060912)
> [    8.858536] Monitor-Mwait will be used to enter C-1 state
> [    8.858564] Monitor-Mwait will be used to enter C-2 state
> [    8.858570] Marking TSC unstable due to TSC halts in idle
> [    8.859636] processor LNXCPU:00: registered as cooling_device6
> [    8.861214] ACPI: SSDT 000000007bac5e18 001D7 (v01  PmRef    ApIst 000=
03000 INTL 20060912)
> [    8.862545] Switching to clocksource hpet
> [    8.863694] ACPI: SSDT 000000007bac6f18 0008D (v01  PmRef    ApCst 000=
03000 INTL 20060912)
> [    8.866500] processor LNXCPU:01: registered as cooling_device7
> [    8.904445] ACPI: Battery Slot [BAT0] (battery present)
> [    9.080309] cfg80211: Using static regulatory domain info
> [    9.081312] cfg80211: Regulatory domain: US
> [    9.082259] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, m=
ax_eirp)
> [    9.083262] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 m=
Bm)
> [    9.084285] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 m=
Bm)
> [    9.085372] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 m=
Bm)
> [    9.086352] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 m=
Bm)
> [    9.087261] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 m=
Bm)
> [    9.088166] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 m=
Bm)
> [    9.089043] cfg80211: Calling CRDA for country: US
> [    9.159804] Bluetooth: Core ver 2.15
> [    9.160782] NET: Registered protocol family 31
> [    9.161599] Bluetooth: HCI device and connection manager initialized
> [    9.162410] Bluetooth: HCI socket layer initialized
> [    9.356233] Bluetooth: Generic Bluetooth USB driver ver 0.6
> [    9.357374] usbcore: registered new interface driver btusb
> [    9.464483] lis3lv02d: laptop model unknown, using default axes config=
uration
> [    9.466170] lis3lv02d: 1-byte sensor found
> [    9.477747] input: ST LIS3LV02DL Accelerometer as /devices/platform/li=
s3lv02d/input/input9
> [    9.479205] Registered led device: hp::hddprotect
> [    9.480122] lis3lv02d driver loaded.
> [    9.591647] input: PC Speaker as /devices/platform/pcspkr/input/input1=
0
> [    9.614761] uvcvideo: Found UVC 1.00 device CKF7063 (04f2:b083)
> [    9.631983] input: CKF7063 as /devices/pci0000:00/0000:00:1a.7/usb1/1-=
5/1-5:1.0/input/input11
> [    9.632961] usbcore: registered new interface driver uvcvideo
> [    9.633851] USB Video Class driver (v0.1.0)
> [    9.774652] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, =
1.3.27ks
> [    9.775616] iwlagn: Copyright(c) 2003-2009 Intel Corporation
> [    9.776624] iwlagn 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> I=
RQ 17
> [    9.777503] iwlagn 0000:02:00.0: setting latency timer to 64
> [    9.777562] iwlagn 0000:02:00.0: Detected Intel Wireless WiFi Link 510=
0AGN REV=3D0x54
> [    9.815302] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802=
.11a channels
> [    9.816242]   alloc irq_desc for 32 on node -1
> [    9.816244]   alloc kstat_irqs on node -1
> [    9.816265] iwlagn 0000:02:00.0: irq 32 for MSI/MSI-X
> [    9.943396] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: =
0xd04711/0xa00000
> [    9.985362] input: SynPS/2 Synaptics TouchPad as /devices/platform/i80=
42/serio4/input/input12
> [   10.010689] phy0: Selected rate control algorithm 'iwl-agn-rs'
> [   10.672084] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
> [   10.673018] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -=
> IRQ 17
> [   10.673962] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [   11.168127] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1=
b.0/input/input13
> [   12.438161] Adding 1951888k swap on /dev/sda5.  Priority:-1 extents:1 =
across:1951888k=20
> [   12.874317] loop: module loaded
> [   15.643484] fuse init (API version 7.13)
> [   48.664225] sky2 eth0: enabling interface
> [   48.666870] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   48.680067] sky2 eth0: disabling interface
> [   49.708388] RPC: Registered udp transport module.
> [   49.710602] RPC: Registered tcp transport module.
> [   49.712875] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [   49.920186] Slow work thread pool: Starting up
> [   49.922553] Slow work thread pool: Ready
> [   49.924908] FS-Cache: Loaded
> [   50.029731] FS-Cache: Netfs 'nfs' registered for caching
> [   50.115338] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> [   62.042747] Bluetooth: L2CAP ver 2.14
> [   62.044869] Bluetooth: L2CAP socket layer initialized
> [   62.137809] Bluetooth: RFCOMM TTY layer initialized
> [   62.139905] Bluetooth: RFCOMM socket layer initialized
> [   62.141955] Bluetooth: RFCOMM ver 1.11
> [   62.202480] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   62.204482] Bluetooth: BNEP filters: protocol multicast
> [   62.302460] Bridge firewalling registered
> [   62.465648] Bluetooth: SCO (Voice Link) ver 0.6
> [   62.466703] Bluetooth: SCO socket layer initialized
> [   66.077873] lp: driver loaded but no devices found
> [   66.108962] ppdev: user-space parallel port driver
> [   77.978500] input: ACPI Virtual Keyboard Device as /devices/virtual/in=
put/input14
> [ 3862.425305] [drm] DAC-6: set mode  24
> [ 3900.820867] sky2 eth0: enabling interface
> [ 3900.821646] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [ 3903.271227] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow cont=
rol both
> [ 3903.271994] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [ 3913.980155] eth0: no IPv6 routers present
> [ 3979.691106] tun: Universal TUN/TAP device driver, 1.6
> [ 3979.691116] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [ 3979.692807] tun0: Disabled Privacy Extensions
> [ 4681.017531] sky2 eth0: Link is down.
> [ 4698.540258] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow cont=
rol both
> [ 4715.933118] sky2 eth0: Link is down.
> [ 4718.224969] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow cont=
rol both
>=20
> ** Model information
> sys_vendor: Hewlett-Packard
> product_name: HP Compaq 2230s (FU312EA)
> product_version: F.08
> chassis_vendor: Hewlett-Packard
> chassis_version:=20
> bios_vendor: Hewlett-Packard
> bios_version: 68PHU Ver. F.08
> board_vendor: Hewlett-Packard
> board_name: 3037
> board_version: KBC Version 11.17
>=20
> ** Loaded modules:
> Module                  Size  Used by
> tun                    10828  2=20
> uinput                  6376  1=20
> ppdev                   5030  0=20
> lp                      7478  0=20
> parport                27938  2 ppdev,lp
> sco                     7193  2=20
> bridge                 39582  0=20
> stp                     1440  1 bridge
> bnep                    9395  2=20
> rfcomm                 29501  5=20
> l2cap                  24656  16 bnep,rfcomm
> binfmt_misc             6431  1=20
> nfsd                  253670  3=20
> exportfs                3170  1 nfsd
> nfs                   239956  0=20
> lockd                  57523  2 nfsd,nfs
> fscache                29802  1 nfs
> nfs_acl                 2031  2 nfsd,nfs
> auth_rpcgss            33476  2 nfsd,nfs
> sunrpc                161073  6 nfsd,nfs,lockd,nfs_acl,auth_rpcgss
> autofs4                20773  0=20
> acpi_cpufreq            5555  0=20
> cpufreq_userspace       1992  0=20
> cpufreq_powersave        902  0=20
> cpufreq_stats           2659  0=20
> cpufreq_conservative     5162  0=20
> fuse                   50078  3=20
> dm_crypt               10507  0=20
> md_mod                 73616  0=20
> loop                   11767  0=20
> snd_hda_codec_intelhdmi    10695  1=20
> snd_hda_codec_analog    64530  1=20
> snd_hda_intel          19411  0=20
> snd_hda_codec          54212  3 snd_hda_codec_intelhdmi,snd_hda_codec_ana=
log,snd_hda_intel
> snd_hwdep               5364  1 snd_hda_codec
> snd_pcm_oss            32591  0=20
> snd_mixer_oss          12606  1 snd_pcm_oss
> snd_pcm                60615  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
> snd_seq_midi            4400  0=20
> snd_rawmidi            15483  1 snd_seq_midi
> snd_seq_midi_event      4628  1 snd_seq_midi
> snd_seq                42801  3 snd_seq_midi,snd_seq_midi_event
> snd_timer              15502  2 snd_pcm,snd_seq
> snd_seq_device          4477  3 snd_seq_midi,snd_rawmidi,snd_seq
> arc4                    1274  2=20
> snd                    46350  13 snd_hda_codec_intelhdmi,snd_hda_codec_an=
alog,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pc=
m,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
> ecb                     1841  2=20
> iwlagn                 71772  0=20
> joydev                  8411  0=20
> soundcore               4598  1 snd
> uvcvideo               51663  0=20
> pcspkr                  1699  0=20
> iwlcore                77830  1 iwlagn
> hp_accel               11056  0=20
> lis3lv02d               5109  1 hp_accel
> snd_page_alloc          6217  2 snd_hda_intel,snd_pcm
> input_polldev           1967  1 lis3lv02d
> btusb                   9785  2=20
> mac80211              136124  2 iwlagn,iwlcore
> psmouse                49505  0=20
> led_class               2401  2 iwlcore,hp_accel
> bluetooth              41795  9 sco,bnep,rfcomm,l2cap,btusb
> evdev                   7336  28=20
> cfg80211              101269  3 iwlagn,iwlcore,mac80211
> battery                 4998  0=20
> processor              29495  3 acpi_cpufreq
> rfkill                 12996  3 bluetooth,cfg80211
> serio_raw               3752  0=20
> ac                      2192  0=20
> container               2389  0=20
> videodev               29977  1 uvcvideo
> v4l1_compat            11442  2 uvcvideo,videodev
> v4l2_compat_ioctl32     8538  1 videodev
> wmi                     4307  0=20
> ext4                  285035  1=20
> mbcache                 4970  1 ext4
> jbd2                   66855  1 ext4
> crc16                   1319  2 l2cap,ext4
> dm_mod                 53690  9 dm_crypt
> sg                     18728  0=20
> sr_mod                 12602  0=20
> cdrom                  29399  1 sr_mod
> sd_mod                 29673  6=20
> crc_t10dif              1276  1 sd_mod
> usbhid                 33116  0=20
> hid                    62825  1 usbhid
> usb_storage            38521  1=20
> uhci_hcd               18489  0=20
> ahci                   31686  3=20
> libata                132167  1 ahci
> sky2                   39390  0=20
> scsi_mod              121893  5 sg,sr_mod,sd_mod,usb_storage,libata
> ehci_hcd               30674  0=20
> usbcore               121751  7 uvcvideo,btusb,usbhid,usb_storage,uhci_hc=
d,ehci_hcd
> nls_base                6377  1 usbcore
> thermal                11674  0=20
> fan                     3346  0=20
> nbd                     7985  0=20
> i915                  247194  2=20
> drm_kms_helper         18883  1 i915
> i2c_algo_bit            4225  1 i915
> button                  4634  1 i915
> video                  17445  1 i915
> thermal_sys            11878  4 processor,thermal,fan,video
> output                  1692  1 video
> drm                   137174  3 i915,drm_kms_helper
> i2c_core               15584  4 videodev,i915,i2c_algo_bit,drm
> intel_agp              25593  1=20
>=20
> ** PCI devices:
> 00:00.0 Host bridge [0600]: Intel Corporation Mobile 4 Series Chipset Mem=
ory Controller Hub [8086:2a40] (rev 07)
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort+ >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: <access denied>
> 	Kernel driver in use: agpgart-intel
>=20
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 4 Seri=
es Chipset Integrated Graphics Controller [8086:2a42] (rev 07) (prog-if 00 =
[VGA controller])
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 29
> 	Region 0: Memory at 90000000 (64-bit, non-prefetchable) [size=3D4M]
> 	Region 2: Memory at 80000000 (64-bit, prefetchable) [size=3D256M]
> 	Region 4: I/O ports at 70f0 [size=3D8]
> 	Expansion ROM at <unassigned> [disabled]
> 	Capabilities: <access denied>
> 	Kernel driver in use: i915
>=20
> 00:02.1 Display controller [0380]: Intel Corporation Mobile 4 Series Chip=
set Integrated Graphics Controller [8086:2a43] (rev 07)
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Region 0: Memory at 90400000 (64-bit, non-prefetchable) [size=3D1M]
> 	Capabilities: <access denied>
>=20
> 00:1a.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB=
 UHCI Controller #4 [8086:2937] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 16
> 	Region 4: I/O ports at 70c0 [size=3D32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1a.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB=
 UHCI Controller #5 [8086:2938] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 17
> 	Region 4: I/O ports at 70a0 [size=3D32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1a.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB=
 UHCI Controller #6 [8086:2939] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 18
> 	Region 4: I/O ports at 7080 [size=3D32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1a.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB=
2 EHCI Controller #2 [8086:293c] (rev 03) (prog-if 20 [EHCI])
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin D routed to IRQ 19
> 	Region 0: Memory at 98904c00 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ehci_hcd
>=20
> 00:1b.0 Audio device [0403]: Intel Corporation 82801I (ICH9 Family) HD Au=
dio Controller [8086:293e] (rev 03)
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: Memory at 98900000 (64-bit, non-prefetchable) [size=3D16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: HDA Intel
>=20
> 00:1c.0 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Exp=
ress Port 1 [8086:2940] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
> 	I/O behind bridge: 00008000-00008fff
> 	Memory behind bridge: 98800000-988fffff
> 	Prefetchable memory behind bridge: 0000000098a00000-0000000098bfffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.1 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Exp=
ress Port 2 [8086:2942] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
> 	I/O behind bridge: 00009000-00009fff
> 	Memory behind bridge: 98700000-987fffff
> 	Prefetchable memory behind bridge: 0000000098c00000-0000000098dfffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.2 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Exp=
ress Port 3 [8086:2944] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D03, subordinate=3D43, sec-latency=3D0
> 	I/O behind bridge: 00005000-00006fff
> 	Memory behind bridge: 94700000-986fffff
> 	Prefetchable memory behind bridge: 0000000098e00000-0000000098ffffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.4 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Exp=
ress Port 5 [8086:2948] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D44, subordinate=3D84, sec-latency=3D0
> 	I/O behind bridge: 00003000-00004fff
> 	Memory behind bridge: 90700000-946fffff
> 	Prefetchable memory behind bridge: 0000000099000000-00000000991fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1c.5 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Exp=
ress Port 6 [8086:294a] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Bus: primary=3D00, secondary=3D85, subordinate=3D85, sec-latency=3D0
> 	I/O behind bridge: 00002000-00002fff
> 	Memory behind bridge: 90600000-906fffff
> 	Prefetchable memory behind bridge: 0000000099200000-00000000993fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport
>=20
> 00:1d.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB=
 UHCI Controller #1 [8086:2934] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 20
> 	Region 4: I/O ports at 7060 [size=3D32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1d.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB=
 UHCI Controller #2 [8086:2935] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 22
> 	Region 4: I/O ports at 7040 [size=3D32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1d.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB=
 UHCI Controller #3 [8086:2936] (rev 03) (prog-if 00 [UHCI])
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 18
> 	Region 4: I/O ports at 7020 [size=3D32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: uhci_hcd
>=20
> 00:1d.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB=
2 EHCI Controller #1 [8086:293a] (rev 03) (prog-if 20 [EHCI])
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin D routed to IRQ 20
> 	Region 0: Memory at 98904800 (32-bit, non-prefetchable) [size=3D1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ehci_hcd
>=20
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [808=
6:2448] (rev 93) (prog-if 01 [Subtractive decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Bus: primary=3D00, secondary=3D86, subordinate=3D86, sec-latency=3D32
> 	Memory behind bridge: 90500000-905fffff
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
>=20
> 00:1f.0 ISA bridge [0601]: Intel Corporation ICH9M LPC Interface Controll=
er [8086:2919] (rev 03)
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: <access denied>
>=20
> 00:1f.2 SATA controller [0106]: Intel Corporation ICH9M/M-E SATA AHCI Con=
troller [8086:2929] (rev 03) (prog-if 01 [AHCI 1.0])
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 31
> 	Region 0: I/O ports at 70e8 [size=3D8]
> 	Region 1: I/O ports at 70fc [size=3D4]
> 	Region 2: I/O ports at 70e0 [size=3D8]
> 	Region 3: I/O ports at 70f8 [size=3D4]
> 	Region 4: I/O ports at 7000 [size=3D32]
> 	Region 5: Memory at 98904000 (32-bit, non-prefetchable) [size=3D2K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ahci
>=20
> 02:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 5100 AG=
N [Shiloh] Network Connection [8086:4237]
> 	Subsystem: Intel Corporation PRO/Wireless 5100AGN Network Connection [80=
86:1211]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 32
> 	Region 0: Memory at 98700000 (64-bit, non-prefetchable) [size=3D8K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: iwlagn
>=20
> 85:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. Device =
[11ab:436c] (rev 10)
> 	Subsystem: Hewlett-Packard Company Device [103c:3037]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 30
> 	Region 0: Memory at 90600000 (64-bit, non-prefetchable) [size=3D16K]
> 	Region 2: I/O ports at 2000 [size=3D256]
> 	Expansion ROM at 99200000 [disabled] [size=3D128K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: sky2
>=20
>=20
> ** USB devices:
> Bus 003 Device 002: ID 03f0:171d Hewlett-Packard Wireless (Bluetooth + WL=
AN) Interface [Integrated Module]
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 006 Device 003: ID 04d9:0420 Holtek Semiconductor, Inc.=20
> Bus 006 Device 002: ID 046d:c316 Logitech, Inc. HID-Compliant Keyboard
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 001 Device 003: ID 04f2:b083 Chicony Electronics Co., Ltd=20
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 004: ID 04e8:5f05 Samsung Electronics Co., Ltd=20
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>=20
>=20
> -- System Information:
> Debian Release: squeeze/sid
>   APT prefers unstable
>   APT policy: (500, 'unstable'), (500, 'testing'), (500, 'stable'), (1, '=
experimental')
> Architecture: amd64 (x86_64)
>=20
> Kernel: Linux 2.6.32-2-amd64 (SMP w/2 CPU cores)
> Locale: LANG=3Dnl_BE.UTF-8, LC_CTYPE=3Dnl_BE.UTF-8 (charmap=3DUTF-8)
> Shell: /bin/sh linked to /bin/bash
>=20
> Versions of packages linux-image-2.6.32-2-amd64 depends on:
> ii  debconf [debconf-2.0]        1.5.28      Debian configuration managem=
ent sy
> ii  initramfs-tools [linux-initr 0.93.4      tools for generating an init=
ramfs
> ii  module-init-tools            3.12~pre1-1 tools for managing Linux ker=
nel mo
>=20
> Versions of packages linux-image-2.6.32-2-amd64 recommends:
> ii  firmware-linux-free           2.6.32-9   Binary firmware for various =
driver
>=20
> Versions of packages linux-image-2.6.32-2-amd64 suggests:
> pn  grub | lilo                   <none>     (no description available)
> pn  linux-doc-2.6.32              <none>     (no description available)
>=20
> Versions of packages linux-image-2.6.32-2-amd64 is related to:
> pn  firmware-bnx2                 <none>     (no description available)
> pn  firmware-bnx2x                <none>     (no description available)
> pn  firmware-ipw2x00              <none>     (no description available)
> pn  firmware-ivtv                 <none>     (no description available)
> ii  firmware-iwlwifi              0.23       Binary firmware for Intel Wi=
reless
> ii  firmware-linux                0.23       Binary firmware for various =
driver
> ii  firmware-linux-nonfree        0.23       Binary firmware for various =
driver
> pn  firmware-qlogic               <none>     (no description available)
> pn  firmware-ralink               <none>     (no description available)
>=20
> -- debconf information:
>   linux-image-2.6.32-2-amd64/postinst/depmod-error-initrd-2.6.32-2-amd64:=
 false
>   linux-image-2.6.32-2-amd64/prerm/removing-running-kernel-2.6.32-2-amd64=
: true
>   linux-image-2.6.32-2-amd64/postinst/bootloader-error-2.6.32-2-amd64:
>   shared/kernel-image/really-run-bootloader: true
>   linux-image-2.6.32-2-amd64/postinst/missing-firmware-2.6.32-2-amd64:
>   linux-image-2.6.32-2-amd64/prerm/would-invalidate-boot-loader-2.6.32-2-=
amd64: true
>   linux-image-2.6.32-2-amd64/postinst/bootloader-test-error-2.6.32-2-amd6=
4:
>=20
>=20
>=20

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-mbnFn+Wso6lL9DckBDil
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS5Mc0+e/yOyVhhEJAQJHeg//Z2tKgo6stJDUADpXFGq9mM167EsCGrFB
wYaSgw9wG7dg+8fex//5HB2jzpW1SqhcDCo8FTmDofiwIBUOyLC59qw26Vn4dURn
EtAadONFrYj3GWwnVF+8tH9glBRXo9zMU2ZAw5LNsnbArXd/pR5nw/78wg0IrE1Y
L22lS9VNeaM6wMk7WeEXpykoMeW6Al/vStOzb5zCSDjnYC8xNsRzwoKd9roP5Dy9
ab5HTjaOJdPPtMfEbyknPrHj8/hh/fGPAKO7WibsAvAopKVQr+UmM81WUp3xiakZ
O2tD+HP5bKtsFzsqDu3iE3B+DrMGWxghsPTUt5KyIZycNBhoR/owIFbXE5FT14LR
qCXgHsvRbagOOpZ5t8I87xO9uWO7L6EMbA/DFzgrPUjqSJjFyMCTodf+HoKMGlq4
TajwKlFs74GNoTwBN8eCIMrQ3/YbflLhNyEWiEtRDI8Nfb0g2o4mAvLuV0EaUA8y
zOzpCNLSVbkgHZcgoj0H4WzSqEalA6/ixvdwHe/lqqWnU/pV7hBZjpNqR3u6Y1tk
a5cyX8nhVDPNqo/zgckn7Jxt7fsKHzBrSUkuKUH+YSQA4ABZIaa7+chlXbCNZCUL
Pd35gelmalM0/FyiPW6FkrSgYZaAnKoXK8FYqoeWLI+7Ni27i2R46AtHD9nOlOUw
gk6pJpAWEh0=
=Ef0y
-----END PGP SIGNATURE-----

--=-mbnFn+Wso6lL9DckBDil--

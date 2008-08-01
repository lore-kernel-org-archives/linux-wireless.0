Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34148 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYHAXao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 19:30:44 -0400
Message-ID: <48939C97.5030608@imap.cc> (sfid-20080802_013050_843746_C55A39B4)
Date: Sat, 02 Aug 2008 01:30:31 +0200
From: Tilman Schmidt <tilman@imap.cc>
MIME-Version: 1.0
To: Eugeniy Meshcheryakov <eugen@debian.org>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
References: <4891D1B9.70703@imap.cc> <1217517915.10489.143.camel@johannes.berg> <4891E97C.1060302@imap.cc> <20080731165054.GA14485@tuxdriver.com> <4892391D.2010305@imap.cc> <20080731224357.GA9741@localhost.localdomain>
In-Reply-To: <20080731224357.GA9741@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7426AC847552304538D43EA5"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7426AC847552304538D43EA5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On Fri, 1 Aug 2008 00:43:57 +0200, Eugeniy Meshcheryakov wrote:
> If you see some new device like /dev/cdrom? or /dev/sr? after inserting=

> the stick (and without closed source driver),

I do. The stick initially announces itself as:

Aug  2 01:00:21 compaq kernel: usb 2-4: New USB device found, idVendor=3D=
057c, idProduct=3D62ff
Aug  2 01:00:21 compaq kernel: usb 2-4: New USB device strings: Mfr=3D3, =
Product=3D2, SerialNumber=3D1
Aug  2 01:00:21 compaq kernel: usb 2-4: Product: WLAN USB Device
Aug  2 01:00:21 compaq kernel: usb 2-4: Manufacturer: AVM GmbH
Aug  2 01:00:21 compaq kernel: usb 2-4: SerialNumber: 001C4AF1E469
Aug  2 01:00:21 compaq kernel: usb-storage: device found at 7
Aug  2 01:00:21 compaq kernel: usb-storage: waiting for device to settle =
before scanning
Aug  2 01:00:22 compaq kernel: scsi 3:0:0:0: CD-ROM            FRITZ!   W=
LAN selfinstall 1.00 PQ: 0 ANSI: 0 CCS
Aug  2 01:00:22 compaq kernel: sr1: scsi3-mmc drive: 52x/52x cd/rw xa/for=
m2 cdda tray
Aug  2 01:00:22 compaq kernel: sr 3:0:0:0: Attached scsi CD-ROM sr1
Aug  2 01:00:22 compaq kernel: sr 3:0:0:0: Attached scsi generic sg2 type=
 5
Aug  2 01:00:22 compaq kernel: usb-storage: device scan complete

and gets automounted by hal:

Aug  2 01:00:23 compaq gnome-keyring-daemon[3186]: adding removable locat=
ion: volume_label_FRITZ_WLAN_USB_Stick_selfinstall at /media/FRITZ!WLAN U=
SB Stick selfinstall
Aug  2 01:00:23 compaq hald: mounted /dev/sr1 on behalf of uid 1000

> try to run 'eject' on it.
> Hopefully this device will disappear and stick will switch to WLAN mode=
=2E

I don't even have to eject it. After about 90 secs it disconnects all by
itself:

Aug  2 01:01:52 compaq kernel: usb 2-4: USB disconnect, address 7
Aug  2 01:01:52 compaq hald[1667]: forcibly attempting to lazy unmount /d=
ev/sr1 as enclosing drive was disconnected
Aug  2 01:01:52 compaq kernel: scsi 3:0:0:0: rejecting I/O to dead device=

Aug  2 01:01:52 compaq gnome-keyring-daemon[3186]: removing removable loc=
ation: volume_label_FRITZ_WLAN_USB_Stick_selfinstall
Aug  2 01:01:52 compaq hald: unmounted /dev/sr1 from '/media/FRITZ!WLAN U=
SB Stick selfinstall' on behalf of uid 0

and then reconnects as:

Aug  2 01:01:54 compaq kernel: usb 2-4: New USB device found, idVendor=3D=
057c, idProduct=3D6201
Aug  2 01:01:54 compaq kernel: usb 2-4: New USB device strings: Mfr=3D3, =
Product=3D2, SerialNumber=3D1
Aug  2 01:01:54 compaq kernel: usb 2-4: Product: WLAN USB Device
Aug  2 01:01:54 compaq kernel: usb 2-4: Manufacturer: AVM GmbH
Aug  2 01:01:54 compaq kernel: usb 2-4: SerialNumber: 001C4AF1E469

> Then try to load acx module. If it works, then it is possible to do thi=
s
> automatically with udev. This works with my UMTS modem.

The acx module also loads all by itself, but complains about missing
firmware and throws two backtraces:

Aug  2 01:01:54 compaq kernel: acx: this driver is still EXPERIMENTAL
Aug  2 01:01:54 compaq kernel: acx: reading README file and/or Craig's HO=
WTO is recommended, visit http://acx100.sf.net in case of further questio=
ns/discussion
Aug  2 01:01:54 compaq kernel: acx: compiled to use 32bit I/O access. I/O=
 timing issues might occur, such as non-working firmware upload. Report t=
hem
Aug  2 01:01:54 compaq kernel: acx: running on a little-endian CPU
Aug  2 01:01:54 compaq kernel: acx: PCI/VLYNQ module v0.3.37 initialized,=
 waiting for cards to probe...
Aug  2 01:01:54 compaq kernel: USB module v0.3.37 initialized, probing fo=
r devices...
Aug  2 01:01:54 compaq kernel: wait for device ready
Aug  2 01:01:54 compaq kernel: requesting firmware image 'tiacx111usbc1B'=

Aug  2 01:01:54 compaq kernel: acx: firmware image 'tiacx111usbc1B' was n=
ot provided. Check your hotplug scripts
Aug  2 01:01:54 compaq kernel: acx: issue_cmd(cmd:ACX1xx_CMD_WAKE) FAILED=

Aug  2 01:01:54 compaq kernel: Pid: 3739, comm: modprobe Tainted: G      =
  N 2.6.25.11-0.1-default #1
Aug  2 01:01:54 compaq kernel:  [<c01071d9>] dump_trace+0x63/0x227
Aug  2 01:01:54 compaq kernel:  [<c0107c8a>] show_trace+0x15/0x29
Aug  2 01:01:54 compaq kernel:  [<c02e66d8>] _etext+0x5b/0x65
Aug  2 01:01:54 compaq kernel:  [<e0bd1bed>] acxusb_s_issue_cmd_timeo_deb=
ug+0x2e7/0x31c [acx]
Aug  2 01:01:54 compaq kernel:  [<e0bd2042>] acxusb_e_probe+0x420/0x602 [=
acx]
Aug  2 01:01:54 compaq kernel:  [<e088ccec>] usb_probe_interface+0xc6/0x1=
08 [usbcore]
Aug  2 01:01:54 compaq kernel:  [<c024c315>] driver_probe_device+0xa0/0x1=
36
Aug  2 01:01:54 compaq kernel:  [<c024c406>] __driver_attach+0x5b/0x91
Aug  2 01:01:54 compaq kernel:  [<c024bcf1>] bus_for_each_dev+0x36/0x5e
Aug  2 01:01:54 compaq kernel:  [<c024c1ba>] driver_attach+0x14/0x16
Aug  2 01:01:54 compaq kernel:  [<c024b6f6>] bus_add_driver+0x9d/0x1ba
Aug  2 01:01:54 compaq kernel:  [<c024c57c>] driver_register+0x47/0xa7
Aug  2 01:01:54 compaq kernel:  [<e088cee1>] usb_register_driver+0x66/0xc=
0 [usbcore]
Aug  2 01:01:54 compaq kernel:  [<e07af0bd>] acxusb_e_init_module+0x2b/0x=
2d [acx]
Aug  2 01:01:54 compaq kernel:  [<e07af01a>] acx_e_init_module+0x1a/0x2a =
[acx]
Aug  2 01:01:54 compaq kernel:  [<c01434d1>] sys_init_module+0x198b/0x1ab=
8
Aug  2 01:01:54 compaq kernel:  [<c01059e4>] sysenter_past_esp+0x6d/0xa9
Aug  2 01:01:54 compaq kernel:  [<ffffe430>] 0xffffe430
Aug  2 01:01:54 compaq kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Aug  2 01:01:54 compaq kernel: initializing max packet templates
Aug  2 01:01:54 compaq kernel: acx: issue_cmd(cmd:cmd) FAILED
Aug  2 01:01:54 compaq kernel: Pid: 3739, comm: modprobe Tainted: G      =
  N 2.6.25.11-0.1-default #1
Aug  2 01:01:54 compaq kernel:  [<c01071d9>] dump_trace+0x63/0x227
Aug  2 01:01:54 compaq kernel:  [<c0107c8a>] show_trace+0x15/0x29
Aug  2 01:01:54 compaq kernel:  [<c02e66d8>] _etext+0x5b/0x65
Aug  2 01:01:54 compaq kernel:  [<e0bd1bed>] acxusb_s_issue_cmd_timeo_deb=
ug+0x2e7/0x31c [acx]
Aug  2 01:01:54 compaq kernel:  [<e0bc6d70>] acx_s_init_max_template_gene=
ric+0x75/0x80 [acx]
Aug  2 01:01:54 compaq kernel:  [<e0bc6dc0>] acx_s_init_packet_templates+=
0x45/0x183 [acx]
Aug  2 01:01:54 compaq kernel:  [<e0bccf50>] acx_s_init_mac+0x8c/0x6c0 [a=
cx]
Aug  2 01:01:54 compaq kernel:  [<e0bd204d>] acxusb_e_probe+0x42b/0x602 [=
acx]
Aug  2 01:01:54 compaq kernel:  [<e088ccec>] usb_probe_interface+0xc6/0x1=
08 [usbcore]
Aug  2 01:01:54 compaq kernel:  [<c024c315>] driver_probe_device+0xa0/0x1=
36
Aug  2 01:01:54 compaq kernel:  [<c024c406>] __driver_attach+0x5b/0x91
Aug  2 01:01:54 compaq kernel:  [<c024bcf1>] bus_for_each_dev+0x36/0x5e
Aug  2 01:01:54 compaq kernel:  [<c024c1ba>] driver_attach+0x14/0x16
Aug  2 01:01:54 compaq kernel:  [<c024b6f6>] bus_add_driver+0x9d/0x1ba
Aug  2 01:01:54 compaq kernel:  [<c024c57c>] driver_register+0x47/0xa7
Aug  2 01:01:54 compaq kernel:  [<e088cee1>] usb_register_driver+0x66/0xc=
0 [usbcore]
Aug  2 01:01:54 compaq kernel:  [<e07af0bd>] acxusb_e_init_module+0x2b/0x=
2d [acx]
Aug  2 01:01:54 compaq kernel:  [<e07af01a>] acx_e_init_module+0x1a/0x2a =
[acx]
Aug  2 01:01:54 compaq kernel:  [<c01434d1>] sys_init_module+0x198b/0x1ab=
8
Aug  2 01:01:54 compaq kernel:  [<c01059e4>] sysenter_past_esp+0x6d/0xa9
Aug  2 01:01:54 compaq kernel:  [<ffffe430>] 0xffffe430
Aug  2 01:01:54 compaq kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Aug  2 01:01:54 compaq kernel: wlan%d: acx_s_init_packet_templates() FAIL=
ED
Aug  2 01:01:54 compaq kernel: acx: init_mac() FAILED
Aug  2 01:01:54 compaq kernel: acx_usb: probe of 2-4:1.0 failed with erro=
r 1
Aug  2 01:01:54 compaq kernel: usbcore: registered new interface driver a=
cx_usb
Aug  2 01:01:54 compaq firmware.sh[3744]: Cannot find  firmware file 'tia=
cx111usbc1B'

Ok, next step I guess is trying to find that firmware image 'tiacx111usbc=
1B' on
the temporarily appearing pseudo CD-ROM drive or on the real CD-ROM that =
came
with the device. Trouble is I don't really know what I am looking for. Th=
e
real CD-ROM contains several instances of a file named Fwusb1b.bin, could=
 that
be it? And if so, where should I copy it so that the acx driver will find=
 it?

Thanks,
Tilman



--------------enig7426AC847552304538D43EA5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIk5ygQ3+did9BuFsRAh4EAJ91xRnyKHzAOdfb5ebMkbY+J7MaQwCeOSO0
PDnFdXCyXeTkOrqxrEEZoLM=
=1xte
-----END PGP SIGNATURE-----

--------------enig7426AC847552304538D43EA5--

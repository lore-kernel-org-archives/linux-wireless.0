Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44001 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbYHBV6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 17:58:18 -0400
Message-ID: <4894D86A.6030108@imap.cc> (sfid-20080802_235824_118024_13C62FF2)
Date: Sat, 02 Aug 2008 23:58:02 +0200
From: Tilman Schmidt <tilman@imap.cc>
MIME-Version: 1.0
To: me@felipebalbi.com
CC: Eugeniy Meshcheryakov <eugen@debian.org>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
References: <4891D1B9.70703@imap.cc> <1217517915.10489.143.camel@johannes.berg> <4891E97C.1060302@imap.cc> <20080731165054.GA14485@tuxdriver.com> <4892391D.2010305@imap.cc> <20080731224357.GA9741@localhost.localdomain> <48939C97.5030608@imap.cc> <20080802082851.GB8213@frodo>
In-Reply-To: <20080802082851.GB8213@frodo>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7E2D9A8B06029E440F6C3EBE"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7E2D9A8B06029E440F6C3EBE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 2 Aug 2008 11:28:52 +0300, Felipe Balbi wrote:
> On Sat, Aug 02, 2008 at 01:30:31AM +0200, Tilman Schmidt wrote:
>> The acx module also loads all by itself, but complains about missing
>> firmware and throws two backtraces:
[...]
>> real CD-ROM contains several instances of a file named Fwusb1b.bin, co=
uld that
>> be it? And if so, where should I copy it so that the acx driver will f=
ind it?
>=20
> Try with that one, copy to /lib/firmware,

The first attempt with that firmware failed with the messages:

Aug  2 19:01:35 compaq kernel: read firmware upload result
Aug  2 19:01:40 compaq kernel: acx: issue_cmd(cmd:ACX1xx_CMD_WAKE) FAILED=

Aug  2 19:01:40 compaq kernel: initializing max packet templates
Aug  2 19:01:46 compaq kernel: acx: issue_cmd(cmd:cmd) FAILED
Aug  2 19:01:46 compaq kernel: wlan%d: acx_s_init_packet_templates() FAIL=
ED
Aug  2 19:01:46 compaq kernel: acx: init_mac() FAILED
Aug  2 19:01:46 compaq kernel: acx_usb: probe of 2-2:1.0 failed with erro=
r 1

I guess that fits in with the messages the ACX module would emit when loa=
ded:

Aug  2 19:01:35 compaq kernel: acx: this driver is still EXPERIMENTAL
Aug  2 19:01:35 compaq kernel: acx: reading README file and/or Craig's HO=
WTO is recommended, visit http://acx100.sf.net in case of further questio=
ns/discussion
Aug  2 19:01:35 compaq kernel: acx: compiled to use 32bit I/O access. I/O=
 timing issues might occur, such as non-working firmware upload. Report t=
hem

On the second attempt, the firmware upload succeeded, but more errors
followed:

Aug  2 19:06:16 compaq kernel: read firmware upload result
Aug  2 19:06:16 compaq kernel: TNETW1450 firmware upload successful!
Aug  2 19:06:16 compaq kernel: initializing max packet templates
Aug  2 19:06:16 compaq kernel: acx: issue_cmd(): USB read error -75
Aug  2 19:06:16 compaq kernel: acx: issue_cmd(cmd:ACX1xx_CMD_INTERROGATE)=
 FAILED
Aug  2 19:06:16 compaq kernel: wlan%d: interrogate(type:ACX1xx_IE_MEMORY_=
CONFIG_OPTIONS) FAILED
Aug  2 19:06:16 compaq kernel: dump queue head (from card):
Aug  2 19:06:16 compaq kernel: len: 20
Aug  2 19:06:16 compaq kernel: tx_memory_block_address: 80000B80
Aug  2 19:06:16 compaq kernel: rx_memory_block_address: DF313D34
Aug  2 19:06:16 compaq kernel: tx1_queue address: 10
Aug  2 19:06:16 compaq kernel: rx1_queue address: E080FBBD
Aug  2 19:06:16 compaq kernel: get_mask 0x00004182, set_mask 0x00000000
Aug  2 19:06:16 compaq kernel: don't know how to get sensitivity for radi=
o type 0x1B
Aug  2 19:06:16 compaq kernel: got sensitivity value 0
Aug  2 19:06:16 compaq kernel: got antenna value 0x4A
Aug  2 19:06:16 compaq kernel: got regulatory domain 0x30
Aug  2 19:06:16 compaq kernel: get_mask 0x00000000, set_mask 0x00000000 -=
 after update
Aug  2 19:06:16 compaq kernel: new ratevector: 82 84 0B 0C 12 16 18 24 2C=
 30 48 60 6C
Aug  2 19:06:16 compaq kernel: setting RXconfig to 2010:0FDD
Aug  2 19:06:16 compaq kernel: acx: =3D=3D=3D chipset TNETW1450, radio ty=
pe 0x1B (An unknown radio used by TNETW1450 USB adapters), form factor 0x=
00 (unspecified), EEPROM version 0x05: uploaded firmware 'Rev 2.4.0.72' =3D=
=3D=3D
Aug  2 19:06:16 compaq kernel: registering network device
Aug  2 19:06:16 compaq kernel: creating /proc entry driver/acx_wlan0
Aug  2 19:06:16 compaq kernel: creating /proc entry driver/acx_wlan0_diag=

Aug  2 19:06:16 compaq kernel: creating /proc entry driver/acx_wlan0_eepr=
om
Aug  2 19:06:16 compaq kernel: creating /proc entry driver/acx_wlan0_phy
Aug  2 19:06:16 compaq kernel: acx: USB module v0.3.37 loaded successfull=
y
Aug  2 19:06:16 compaq kernel: usb 2-2: New USB device found, idVendor=3D=
057c, idProduct=3D6201
Aug  2 19:06:16 compaq kernel: usb 2-2: New USB device strings: Mfr=3D3, =
Product=3D2, SerialNumber=3D1
Aug  2 19:06:16 compaq kernel: usb 2-2: Product: WLAN USB Device
Aug  2 19:06:16 compaq kernel: usb 2-2: Manufacturer: AVM GmbH
Aug  2 19:06:16 compaq kernel: usb 2-2: SerialNumber: 001C4AF1E469
Aug  2 19:06:16 compaq ifup:     wlan0    =20
Aug  2 19:06:16 compaq ifup:               No configuration found for wla=
n0

The device was reported in iwconfig as:

wlan0     IEEE 802.11b+/g+  ESSID:"STAF1E469"  Nickname:"acx v0.3.37"
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated=
  =20
          Bit Rate:54 Mb/s   Tx-Power=3D15 dBm  =20
          Retry min limit:7   RTS thr:off  =20
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

but didn't work. In particular "iwlist wlan0 scan" failed with the messag=
e:

wlan0     Interface doesn't support scanning : Resource temporarily unava=
ilable

(No accompanying kernel message.)

> if it doesn't work try with the one from [1].
>=20
> [1] http://www.cmartin.tk/acx/fw.tar.bz2

That archive contains several firmware images but none that seems to fit
the device. Specifically, the module asks for tiacx111usbc1B, but the
archive only has tiacx100usb, no tiacx111usb*, and the radio module IDs
(last two characters) for ACX111 include 16, 17 and 19, but not 1B.
Also, http://acx100.sourceforge.net/wiki/Firmware has this not very
encouraging note:
*  The new TNETW1450 (USB 2.0 capable chipset) isn't fully supported by o=
ur driver yet (useful support probably available soon).=20
   [This is as of Feb. 2006 - still not supported?]

Btw, about two times out of three, after plugging it in, the device even
fails to activate in Mass Storage mode, endlessly reporting:

Aug  2 20:14:05 compaq kernel: usb 2-2: reset high speed USB device using=
 ehci_hcd and address 12
Aug  2 20:14:20 compaq kernel: usb 2-2: device descriptor read/64, error =
-110

(ie. ETIMEDOUT) and never switching to WLAN mode. Unplugging and plugging=

back in a couple of times succeeds eventually.

Anything else I should test?

Thanks,
Tilman


--------------enig7E2D9A8B06029E440F6C3EBE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFIlNh0Q3+did9BuFsRAoeBAJ9NJv7SM33BnT4nOrNDiBWWzmr5zwCfa4M1
aAtUa1ada9fxOSRzXmTdW0I=
=NjXN
-----END PGP SIGNATURE-----

--------------enig7E2D9A8B06029E440F6C3EBE--

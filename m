Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:43810 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab1GARch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 13:32:37 -0400
Date: Fri, 1 Jul 2011 13:32:37 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless
 3.0-rc4-1
Message-ID: <20110701173237.GC7125@alittletooquiet.net> (sfid-20110701_193241_236526_FC145869)
References: <20110701133553.GA7125@alittletooquiet.net>
 <BANLkTikByepHZoEE2b65CrgUmpBmcxiTgw@mail.gmail.com>
 <BANLkTimUs65_Sw=pwF-J8gPjyrNcs2qnOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
In-Reply-To: <BANLkTimUs65_Sw=pwF-J8gPjyrNcs2qnOw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi shafi,

[Sorry for the duplicate, lost the Cc's the first time around.]

On Fri, Jul 01, 2011 at 07:39:40PM +0530, Mohammed Shafi wrote:
> On Fri, Jul 1, 2011 at 7:31 PM, Mohammed Shafi <shafi.wireless@gmail.com>=
 wrote:
> > On Fri, Jul 1, 2011 at 7:05 PM, Forest Bond <forest@alittletooquiet.net=
> wrote:
> >> Now the module loads fine and appears to load the firmware correctly, =
but the
> >> interface never comes up. =A0Here's what happens when I insert the dev=
ice:
> >>
> >> [ =A0206.270348] usb 5-7: new high speed USB device using ehci_hcd and=
 address 5
> >> [ =A0206.422393] usb 5-7: configuration #1 chosen from 1 choice
> >> [ =A0206.657723] Compat-wireless backport release: compat-wireless-v3.=
0-rc4-1
> >> [ =A0206.657732] Backport based on linux-2.6-allstable.git v3.0-rc4
> >> [ =A0206.864667] Calling CRDA to update world regulatory domain
> >> [ =A0207.714633] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size=
: 51288
> >> [ =A0207.861037] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33=
 credits
> >>
> >> At this point the interface is not visible in the output of ifconfig. =
=A0Something
> >> has gone wrong with USB, because lsusb hangs until I unplug the device=
, at which
> >> point I see the following in dmesg:
> >>
> >> [ =A0225.464212] usb 5-7: USB disconnect, address 5
> >> [ =A0225.592282] ath: Reading Magic # failed
> >> [ =A0225.592310] ath: no band has been marked as supported in EEPROM
> >> [ =A0225.592315] ath: Unable to initialize hardware; initialization st=
atus: -22
> >> [ =A0225.592321] ath: Unable to initialize hardware; initialization st=
atus: -22
> >> [ =A0225.592336] Failed to initialize the device
> >> [ =A0225.592400] ath9k_htc: probe of 5-7:1.0 failed with error -22
> >> [ =A0225.712249] usbcore: registered new interface driver ath9k_htc
> >
> > something wrong in reading EEPROM, please post the kernel log for
> > sudo modprobe ath9k_htc debug debug=3D0x404
>=20
> please do
> sudo modprobe ath9k_htc debug=3D0xffffffff
> this will give lots of information

[   98.421395] Compat-wireless backport release: compat-wireless-v3.0-rc4-1
[   98.421405] Backport based on linux-2.6-allstable.git v3.0-rc4
[   98.638709] Calling CRDA to update world regulatory domain
[   99.219353] usbcore: registered new interface driver ath9k_htc
[  103.829197] usb 5-7: new high speed USB device using ehci_hcd and addres=
s 5
[  103.985215] usb 5-7: configuration #1 chosen from 1 choice
[  104.288053] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size: 51288
[  104.448323] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 credits
[  104.453395] ath: UNDEFINED -> AWAKE
[  104.454654] ath: serialize_regmode is 0
[  104.686218] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  104.686240] ath: REGISTER WRITE FAILED, multi len: 9
[  104.901237] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  104.901259] ath: REGISTER READ FAILED: (0x9c00, -110)
[  104.901276] ath: Reading from EEPROM, not flash
[  105.136983] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  105.137000] ath: Multiple REGISTER READ FAILED (count: 8)
[  105.408496] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  105.408513] ath: Multiple REGISTER READ FAILED (count: 8)
[  105.676507] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  105.676524] ath: Multiple REGISTER READ FAILED (count: 8)
[  105.911084] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  105.911106] ath: Multiple REGISTER READ FAILED (count: 8)
[  106.148500] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  106.148517] ath: Multiple REGISTER READ FAILED (count: 8)
[  106.380920] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  106.380933] ath: Multiple REGISTER READ FAILED (count: 8)
[  106.646720] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  106.646737] ath: Multiple REGISTER READ FAILED (count: 8)
[  106.877455] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  106.877473] ath: Multiple REGISTER READ FAILED (count: 8)
[  107.106916] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  107.106932] ath: Multiple REGISTER READ FAILED (count: 8)
[  107.327013] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  107.327029] ath: Multiple REGISTER READ FAILED (count: 8)
[  107.549431] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  107.549453] ath: Multiple REGISTER READ FAILED (count: 8)
[  107.784184] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  107.784205] ath: Multiple REGISTER READ FAILED (count: 8)
[  108.028850] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  108.028867] ath: Multiple REGISTER READ FAILED (count: 8)
[  108.268894] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  108.268911] ath: Multiple REGISTER READ FAILED (count: 8)
[  108.507164] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  108.507180] ath: Multiple REGISTER READ FAILED (count: 8)
[  108.746603] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  108.746619] ath: Multiple REGISTER READ FAILED (count: 8)
[  108.978447] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  108.978464] ath: Multiple REGISTER READ FAILED (count: 8)
[  109.219056] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  109.219069] ath: Multiple REGISTER READ FAILED (count: 8)
[  109.496668] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  109.496685] ath: Multiple REGISTER READ FAILED (count: 8)
[  109.735763] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  109.735780] ath: Multiple REGISTER READ FAILED (count: 8)
[  109.973853] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  109.973869] ath: Multiple REGISTER READ FAILED (count: 8)

> > make sure to enable CONFIG_ATH_DEBUG and ATH9K_HTC_DEBUGFS
> > http://wireless.kernel.org/en/users/Drivers/ath9k/debug
> >
> > was this previously working?

Not that I am aware of.  This is this first time I've tried it.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--3siQDZowHQqNOShm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4OBLUACgkQRO4fQQdv5AzfBgCgxhoJBT0VcEhAWTnLUwVTeNrO
TMsAoK3302A5QvNTAZZZACMrkhIka6u5
=/HLT
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:50568 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1GANpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 09:45:32 -0400
Date: Fri, 1 Jul 2011 09:35:54 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: ath9k_htc fails to initialize TL-WN721N with compat-wireless
 3.0-rc4-1
Message-ID: <20110701133553.GA7125@alittletooquiet.net> (sfid-20110701_154535_252992_7C08F9A0)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I am running compat-wireless 3.0-rc4-1 on an Ubuntu 8.04 (Hardy) system with
Ubuntu kernel version 2.6.24-21-generic.  Yes, I know this kernel version is
ancient, but that's what c-w is for, right? ;)

First, I should mention that had to apply this patch for c-w to build:

  http://permalink.gmane.org/gmane.linux.kernel.wireless.general/72402

I also ran into problems because the c-w Makefile installs the udev
compat_firmware rules file into /lib/udev/rules.d, which is not a supported
location on Hardy.  Moving the rules file to /etc/udev/rules.d solved that.

Now the module loads fine and appears to load the firmware correctly, but t=
he
interface never comes up.  Here's what happens when I insert the device:

[  206.270348] usb 5-7: new high speed USB device using ehci_hcd and addres=
s 5
[  206.422393] usb 5-7: configuration #1 chosen from 1 choice
[  206.657723] Compat-wireless backport release: compat-wireless-v3.0-rc4-1
[  206.657732] Backport based on linux-2.6-allstable.git v3.0-rc4
[  206.864667] Calling CRDA to update world regulatory domain
[  207.714633] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size: 51288
[  207.861037] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 credits

At this point the interface is not visible in the output of ifconfig.  Some=
thing
has gone wrong with USB, because lsusb hangs until I unplug the device, at =
which
point I see the following in dmesg:

[  225.464212] usb 5-7: USB disconnect, address 5
[  225.592282] ath: Reading Magic # failed
[  225.592310] ath: no band has been marked as supported in EEPROM
[  225.592315] ath: Unable to initialize hardware; initialization status: -=
22
[  225.592321] ath: Unable to initialize hardware; initialization status: -=
22
[  225.592336] Failed to initialize the device
[  225.592400] ath9k_htc: probe of 5-7:1.0 failed with error -22
[  225.712249] usbcore: registered new interface driver ath9k_htc

There are several variations on this depending on how long I leave the devi=
ce
plugged in.  Eventually lsusb runs fine in some cases, and I have seen the
interface come up once, but I did not test functionality and I haven't been=
 able
to easily repeat that scenario.

What can I do to debug?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4NzTkACgkQRO4fQQdv5Ay4aACbBkvIjx+4PB5TlADJlcGMGcGe
TYwAnjiVA65h6MubxeVc7i7bN8QlzoRM
=Vo6s
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--

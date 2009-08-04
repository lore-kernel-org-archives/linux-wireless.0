Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx73.mail.ru ([94.100.176.87]:36034 "EHLO mx73.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbZHDMak (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 08:30:40 -0400
Received: from mx40.mail.ru (mx40.mail.ru [94.100.176.54])
	by mx73.mail.ru (mPOP.Fallback_MX) with ESMTP id 51ED248A8D3
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2009 16:30:38 +0400 (MSD)
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: mjg59@srcf.ucam.org
Subject: Multiple rfkill knobs for the same hardware interface
Date: Tue, 4 Aug 2009 16:29:56 +0400
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1400429.dJ2kqDD6Lh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200908041630.00533.arvidjaar@mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1400429.dJ2kqDD6Lh
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This is mostly the same situation as ACPI vs. platform backlight=20
control. Here on Dell XPS M1330:

{pts/1}% rfkill list
0: dell-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: dell-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
2: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no
4: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no

Arguably, either one in the pair is redundant. Moreover, hard disabling=20
wireless (using slider on notebook side):

{pts/1}% rfkill list
0: dell-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: dell-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
2: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: yes

So dell-laptop actually lies claiming that both radios are enabled. Even=20
if this is a bug that can be fixed, having two knobs for exactly the=20
same piece of hardware is confusing at the very least.

--nextPart1400429.dJ2kqDD6Lh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp4KcQACgkQR6LMutpd94x4AQCePD4z1F/IDdHmdCDa4sxin4ul
Ut8AoJB5CJS4HTki/LWr6PCUn/BLNI7s
=XC51
-----END PGP SIGNATURE-----

--nextPart1400429.dJ2kqDD6Lh--

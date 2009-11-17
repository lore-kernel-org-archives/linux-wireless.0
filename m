Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52744 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZKQQVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:21:38 -0500
Received: by bwz27 with SMTP id 27so91710bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 08:21:42 -0800 (PST)
Message-ID: <4B02CD95.2010805@gmail.com>
Date: Tue, 17 Nov 2009 17:21:41 +0100
From: Piotr Findeisen <piotr.findeisen@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: unsupported TL-WN422G (0cf3:1006)
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig73451DD42CC59CF80E58AECC"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig73451DD42CC59CF80E58AECC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi!

I've bought TP-LINK WN422G USB wireless card with Zydas chipset (as
stated by the seller) in the hope it will be supported by zd1211rw
driver (listed here [1]), but it seems it's not.
I've tried to find help on linuxforums.org <http://linuxforums.org> [2]
=E2=80=94 the only open option is to use ndiswrapper, which (a) is report=
ed not
to work earlier in the thread and (b) is the last option for me to
consider. Search in linux-wireless's archives yielded only a result [3]
with a patch included in my kernel (Ubuntu-2.6.31-14.48).

My card's vendor:product id is 0cf3:1006 (different that the one listed
[1] for WN422G).
If i execute the following after plugging the card:
echo "0cf3 1006 FFFFFFFF FFFFFFFF 0 0 1" | sudo tee -a
/sys/bus/usb/drivers/zd1211rw/new_id

dmesg reports (notice the 5s interval between first and second entry):
--------------
[21745.628183] usb 2-1: reset high speed USB device using ehci_hcd and
address 9
[21750.776294] usb 2-1: read over firmware interface failed: -110
[21750.888072] usb 2-1: reset high speed USB device using ehci_hcd and
address 9
[21751.085403] zd1211rw: probe of 2-1:1.0 failed with error -110
--------------

lsusb reports the card as
Bus 002 Device 009: ID 0cf3:1006 Atheros Communications, Inc

What I can do to better diagnose the problem and possibly get the card
working?


best regards,
Piotr Findeisen


[1] http://linuxwireless.org/en/users/Devices/USB
[2]
http://www.linuxforums.org/forum/wireless-internet/154830-tl-wn422g-probl=
em-2.html
[3] 5 messages on 2009-02-04,
http://marc.info/?l=3Dlinux-wireless&w=3D2&r=3D1&s=3Dwn422g&q=3Db
<http://marc.info/?l=3Dlinux-wireless&w=3D2&r=3D1&s=3Dwn422g&q=3Db>



--------------enig73451DD42CC59CF80E58AECC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksCzZUACgkQhIjjAqQbQwMh4ACffE58tS4AXgCEXF1RWRoNuKMm
XG8An1cfPzfmODoYUv9UiswqkMcRuEVq
=ZMzS
-----END PGP SIGNATURE-----

--------------enig73451DD42CC59CF80E58AECC--

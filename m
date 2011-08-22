Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41448 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab1HVJJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 05:09:33 -0400
Message-ID: <4E521CC0.8060305@pengutronix.de> (sfid-20110822_110936_363165_BD849C72)
Date: Mon, 22 Aug 2011 11:09:20 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org, Netdev@vger.kernel.org
Subject: Re: BUG: rt2x00usb: Vendor Request 0x07 failed
References: <4E4F7364.2060609@pengutronix.de> <20110822082507.GB2422@redhat.com>
In-Reply-To: <20110822082507.GB2422@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1C3F50DD1A8C77590699C261"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1C3F50DD1A8C77590699C261
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/22/2011 10:25 AM, Stanislaw Gruszka wrote:
> On Sat, Aug 20, 2011 at 10:42:12AM +0200, Marc Kleine-Budde wrote:
>> I'm a running a sheeva plug (ARM/kirkwood) with a rt2800 USB stick in =
AP mode.
>> Bus 001 Device 002: ID 1737:0071 Linksys WUSB600N v1 Dual-Band Wireles=
s-N Network Adapter [Ralink RT2870]
>=20
> First of all, the best way to get rt2x00 support is write to
> (moderated for non-subscribers) list users@rt2x00.serialmonkey.com=20

Okay - will subscribe there.
>=20
>> kernel is v3.0.3 +
>> http://www.spinics.net/lists/linux-wireless/msg74377.html
>> (see http://git.pengutronix.de/?p=3Dmkl/linux-2.6.git;a=3Dshortlog;h=3D=
refs/heads/wireless/rt2x00/v3.0.3)
>=20
> We have now wireless-testing applied version of that fix (3 -patches):
> http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testing.g=
it;a=3Dcommit;h=3D674db1344443204b6ce3293f2df8fd1b7665deea
> http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testing.g=
it;a=3Dcommit;h=3Ddf71c9cfceea801e7e26e2c74241758ef9c042e5
> http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testing.g=
it;a=3Dcommit;h=3D4b1bfb7d2d125af6653d6c2305356b2677f79dc6
>=20
>> With the patch the oops is gone, but after a few hours it fails with:
>>
>> [30971.764840] phy0 -> rt2x00usb_vendor_request: Error - Vendor Reques=
t 0x07 failed for offset 0x0438 with error -71.
>=20
> Looks there is something wrong at USB bus. Perhaps this could be debugg=
ed
> using CONFIG_USB_DEBUG and friends. Eventually look at vendor driver to=

> check if it does not do some quirks regarding usb bus could help.

Seems the best is to try to reproduce with a different usb host controlle=
r.

thanks,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig1C3F50DD1A8C77590699C261
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5SHMIACgkQjTAFq1RaXHO/MACfSPPnmA9QuxWZNIpKNqomrN+N
XAQAmwZO+F95MfOXUy27do4T4mdBt4Mz
=bnsp
-----END PGP SIGNATURE-----

--------------enig1C3F50DD1A8C77590699C261--

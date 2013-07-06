Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41745 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048Ab3GFPjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jul 2013 11:39:19 -0400
Message-ID: <1373125142.22888.113.camel@deadeye.wl.decadent.org.uk> (sfid-20130706_173924_854951_3A8045E4)
Subject: Re: [PATCH] brcm: add brcmfmac sdio firmware for bcm43241
From: Ben Hutchings <ben@decadent.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stephen Warren <swarren@wwwdotorg.org>
Date: Sat, 06 Jul 2013 16:39:02 +0100
In-Reply-To: <51D54FD2.6090107@broadcom.com>
References: <1369833235-3642-1-git-send-email-arend@broadcom.com>
	 <1372904558.22888.50.camel@deadeye.wl.decadent.org.uk>
	 <51D54FD2.6090107@broadcom.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-V3839x7JZpUsGWOQfr9B"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V3839x7JZpUsGWOQfr9B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-07-04 at 12:34 +0200, Arend van Spriel wrote:
> On 07/04/2013 04:22 AM, Ben Hutchings wrote:
> > On Wed, 2013-05-29 at 15:13 +0200, Arend van Spriel wrote:
[...]
> >> --- a/WHENCE
> >> +++ b/WHENCE
> >> @@ -1652,6 +1652,7 @@ Driver: brcmfmac - Broadcom 802.11n fullmac wire=
less LAN driver.
> >>
> >>   File: brcm/bcm4329-fullmac-4.bin
> >>   File: brcm/brcmfmac43236b.bin
> >> +File: brcm/brcmfmac43241.bin
> >>   File: brcm/brcmfmac4329.bin
> >>   File: brcm/brcmfmac4330.bin
> >>   File: brcm/brcmfmac4334.bin
> > [...]
> >
> > Unless you're doing something very clever with macros, I don't believe
> > you've posted any driver code that uses this file... or several of the
> > others.  The current driver in net-next (I don't know what you've sent
> > to Nvidia) appears to request only these files:
>=20
> Hi, Ben
>=20
> Nvidia was just using the upstream brcmfmac driver. The "clever" thing=
=20
> we are doing for the SDIO part of our brcmfmac driver is that the=20
> firmware filename requested by the driver is always brcmfmac-sdio.bin.=
=20
> We explain on wireless.kernel.org that people should link/copy the=20
> firmware file for their device to brcmfmac-sdio.bin

Not a great idea, but I think you recognise that now.

> and get=20
> brcmfmac-sdio.txt from their board supplier as it is very board specific=
=20
> initialization data.

What if someone wants to put more than one of these devices in the same
system?

[...]
> > So I think, before this patch is applied, you owe me and David patches
> > to:
> >
> > 1. Add brcm/brcmfmac43143.bin, brcm/brcmfmac43242a.bin and
> > brcm/brcmfmac-sdio.txt.
>=20
> The 43143 and 43242 bin files will be submitted, but these firmwares=20
> have not yet been released. I have to wait for a green light on that.
>=20
> > 2. Rename brcm/bcm4329-fullmac-4.bin to brcm/brcmfmac-sdio.bin.
>=20
> That file is there for brcmfmac in older kernels (< v3.3) as the=20
> replacement brcmfmac4329.bin does not work with brcmfmac in those older=
=20
> kernels.

OK.

> > 3. Add symlinks from all the old names to the new names.  (As
> > linux-firmware should support old in-tree drivers indefinitely.)
>=20
> I will look into this to see what names were used by brcmfmac since it=
=20
> was mainlined.

As I said, all the names that have been used should be supported.  So
either provide multiple versions of the firmware or add symlinks, as
appropriate.

> > and you owe linux-wireless some driver patches.
> >
> > linux-firmware.git is not the appropriate place to send firmware used
> > only by out-of-tree code, and any firmware blob that has never been
> > referenced by in-tree code is subject to removal.
>=20
> I am aware and none of the firmwares we released are for out-of-tree=20
> code. We actually got feedback that using the same firmware filename for=
=20
> multiple devices was not very user-friendly. Therefore we will get rid=
=20
> of this quirky approach in the next kernel and the firmware files in=20
> linux-firmware will be listed in brcmfmac using the MODULE_FIRMWARE() mac=
ro.

Thanks for clearing this up.

Please re-send the new firmware, and include the firmware version in
WHENCE.

Ben.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-V3839x7JZpUsGWOQfr9B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUdg6Fue/yOyVhhEJAQoEdw//RWbUFa39PTDUJeZF8Rx7wMy9slVnQJT/
adrkqECiJrpol/dJfJn8PJtgDQpajg00HPafb0Qqcm4agmaXwxRgD54jA7Lf69KY
fGlsyNHpDf/mY6pMbpXCCTsnMV64Tyur8gj9cAnQPfITGgn6k3qfUmGtaRpDYcVj
4nl6P3rd7fkC/7lRawaF1cTUl9vvWWrSHomrjEFDwEIobpJbF10PuGlO0YroS4kf
9WR6+0w1OH8TZUQm2F3/WbXohK1iMwP6U9xhhb9lGmPWaKN6naLG6tNMv6KUWCGx
Me032G0kyuWaF8b9qsNbpLZXO0MqYwNhQWYyloxR+6Mc0sBbk9y5Hk1Wg1CjYtaO
UyornEV/+QDiX03FfTWFIteyhkilA6S1LN46e8QB/mCAcz2AUq/4P/DZf7jJY+fn
p1rXfZSrl+lmyTYxD1lZWPscQ5gWl9IC1LIgFvRnSNP9l7+k7jw9KzE0AtfAOx7z
0AnISm4lkeqvLAq5hWlLjs43az5l+vtsRWiUKLMA3tkJbyES5lW2MyclnlZAFnmW
bWW5NPjRDoeUjtXpLrd0EfjzKsTP3r5NdarxNwY77lz6i/b5xHhcFGXWGi2C3aab
pxQVyp+qiZyykRgb5vnPZJmVRPjHl8uYSE3adZnC36G27mvXDtzQIg+sOzJll/OL
D/zsjvzz4I8=
=94GC
-----END PGP SIGNATURE-----

--=-V3839x7JZpUsGWOQfr9B--

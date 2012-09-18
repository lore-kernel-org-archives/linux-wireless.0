Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133Ab2IRNPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 09:15:16 -0400
Message-ID: <1347974432.7112.61.camel@sauron.fi.intel.com> (sfid-20120918_151526_783450_E27DFD3B)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Johannes Berg <johannes@sipsolutions.net>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 Sep 2012 16:20:32 +0300
In-Reply-To: <1347968754.4283.6.camel@jlt4.sipsolutions.net>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 (sfid-20120917_163617_677167_0B529F43) <1347952199.6503.3.camel@jlt4.sipsolutions.net>
	 <1347957651.7112.38.camel@sauron.fi.intel.com>
	 <1347957847.6503.6.camel@jlt4.sipsolutions.net>
	 (sfid-20120918_104337_198974_0F170017) <1347968754.4283.6.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-uy3q8cLR5lKC9xi8gzHQ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uy3q8cLR5lKC9xi8gzHQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-09-18 at 13:45 +0200, Johannes Berg wrote:
> On Tue, 2012-09-18 at 10:44 +0200, Johannes Berg wrote:
>=20
> > Thanks. I just got that far as well, but I hadn't set up a DHCP
> > server ... I'll debug further, I just confirmed that association still
> > works.
>=20
> Ok I can't reproduce the problem. You're going to have to be more
> specific about what connman sets up, I think.
>=20
> Here's what I did:
>=20
>  * brctl addbr br0
>  * ip addr add ... br0
>  * ip link set br0 up
>  * start dnsmasq on br0
>  * start wpa_supplicant on wlan0, with -Dnl80211 -bbr0 -iwlan0 -c../cfg
>  * brctl addif br0 wlan0
>=20
> Maybe this isn't exactly what connman does, but it works for me with
> kernel 3.5.4, a 6230 Intel device and 1.0 wpa_supplicant.
>=20
> Can you capture exactly what connman does?

I can with some amount of efforts - I'd need to read the code. If you
would be kind / enthusiastic enough to try this with Tizen images, that
would be a lot easier for me.

But let me CC Samuel who did tethering support for connman. Samuel, if
you wish to provide some input, here is the link to this discussion:

http://thread.gmane.org/gmane.linux.kernel.wireless.general/97389

> Also, are you sure that reverting just the carrier state patch isn't
> sufficient? It seems to me that the carrier state patch might confuse
> the bridge code, but I really see no reason Eric's change should have
> any impact at all.

Yes, 100% sure. I spent a lot of time bisecting this, and found out that
in my setup tethering starts working only if I revert both.

--=20
Best Regards,
Artem Bityutskiy

--=-uy3q8cLR5lKC9xi8gzHQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQWHUgAAoJECmIfjd9wqK05bUP/07pNy28rBinqDiaV1d3YTYB
UYvlxXzF+8axwMFdOhng6z1sYfrhPh5gOi5rBlu1QgGgqsy/oVymWoA2JaOW3tKr
+8k11FMJ8daQrU667yyEnfdva08bDBvw8M5NDw2tv5GY0DQInw2DOeoTF8iB0L5p
rYWSTFp21om5lcABg28bFs3gPDlxe3RogTGdeU9Q064W3xp8CJiiPV4M49MC7vRX
POvb9t+uJTc5qQre0uVpmfHIzRMPJmBkABhOGpXbUS3yoUW7h2KCOfz9oaltArw9
x7PTPry5/Rqd4uyccm11HFFhrvtMByhX3C8rADFnBPCCNt2lRTkkzIjf4iav7cnV
8R/D45NzlAAWUGL2Ma1sMChFqqni+juCku5ckuUl5/3LNxiCx8oO9Hq9Whu8kMue
s4cTZ+OoX+KUlaO+r31gkQq4w7LlHjy/3+yGEuchXykU5rulFLSf3x6bu422p6Kx
/C7ogU49BG+Zl0AmkNrGGt93P5yBRT5PrJphSZ/LW71ZO705F1CVDTsRSwuJCLK7
Zt1mg01NOjIEmdA6XD6WLuzpSbHh2mmHqtZEiC91L3jCjFc19Xj1ALm4CXXCHfZ5
Pc6fDnBxDGuSNAo2jVlf5tITtyMWf7XKL5zvJKKITBOR4HpwaOL2CRMNypC+IESy
+hf1vRr+QsitA/U9Omyh
=xIBB
-----END PGP SIGNATURE-----

--=-uy3q8cLR5lKC9xi8gzHQ--


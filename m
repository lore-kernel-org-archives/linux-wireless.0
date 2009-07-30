Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZG3Kb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 06:31:26 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <4A70C17B.6090309@candelatech.com>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <4A70C17B.6090309@candelatech.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IV/xOT6t24qiwOKAPjba"
Date: Thu, 30 Jul 2009 12:30:53 +0200
Message-Id: <1248949853.29062.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IV/xOT6t24qiwOKAPjba
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-29 at 14:39 -0700, Ben Greear wrote:
> On 07/29/2009 02:32 PM, Reinette Chatre wrote:
> > From: Reinette Chatre<reinette.chatre@intel.com>
> >
> > The connection monitor currently relies on probe requests paired
> > with probe responses to ensure that a connection is alive. This is
> > fragile in some environments where probe responses can get lost.
> > When we receive beacons we can also consider the connection to be
> > alive, so cancel connection poll instance when we receive a beacon.
>=20
> I'm chasing a similar problem while working on virtual STA device
> support in ath5k.  I was also going to try sending up to 3 polls before
> giving up on the connection.  Does that seems like a valid thing to do?

That seems somewhat better, yeah.

I suspect the real cause of the issue is something else though, like the
probe request not going out properly or the card being in a kind of
'temporary lock-up' state where it's not really doing anything for the
time being -- I've never had a problem on any other (than iwlwifi)
hardware.

Of course, the virtual STA device support stuff potentially has similar
issues, especially if it does channel switching like the ath9k virtual
wiphy stuff.

johannes

--=-IV/xOT6t24qiwOKAPjba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcXZZAAoJEODzc/N7+QmaCj8P/igWF5bvi4HpUrRQ4fkoAnMi
Tc5wDGFy2Yy3hKLdeNVwyv8Hk0dH/+ZyYMndDIQvHROT/GNcNl+lk4lSW6/S57Tp
7dNtIL30Ia1KU6BfE7vqJggan5tpi6r9I5Y+jMKU8KHsRXyBGGQV3ZBfEdAxnFqj
8BnmiYKFSSxfoJJ53Hy2Ghh0o8jLBOPTZklgDTYklygaZR8iCgoMa0SN7/BMJ7N7
C6SOrRTsW5aaDyH0Gquxn3UXInyCMkUolEhvaiBJGkh+dK7ZCQJb2quXDDJXyAwH
qKbKgvEIWCxPnSsYOsTWJe23tCS4ib+NCD6bjYjlOw0d+he/ANKToFVqNI6Ij5Vw
PB778HRxk7vT15UHcZRG1yn2fYQ2JLOOuKlxvTR4T7+f92AdacNPgImSsytoaZrA
WFi3ZsoWEyfqfZmj/8fEEyUvebPcDAIRBsZ7froqqSIs0lf4mAPbFPCC6Mm3T4+Q
irl6vf0hm4ni9Q4g8c0EQ0wmQJuOEROEPatm6ruVo+A0clVYgkJUkjOOCwb5d5AX
qQ5dniDjD6rVh0qqEjYxd5UttHEbQ1WKJBefdCOfOwy3I+f66I/1X+SzotxxnwMx
s4CLT+tHvm5pMb/bWD8G85GOUAfQ4mJSharwxw8z3SR03FD/mMZ2i0deysZcViZS
tdRyZ84i3M3G7jrXTmAq
=winc
-----END PGP SIGNATURE-----

--=-IV/xOT6t24qiwOKAPjba--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZEGTCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 15:02:55 -0400
Subject: Re: [RFC] Simulate medium behavior
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Wagner <wagi@monom.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090507184007.GA6684@newton.monom.org>
References: <20090422092159.GA24586@toronto053.server4you.de>
	 <1240393088.21756.3.camel@johannes.local>
	 <20090422113556.GB24586@toronto053.server4you.de>
	 <20090507184007.GA6684@newton.monom.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hrd8t2darnK3pvHkCi8E"
Date: Thu, 07 May 2009 21:02:52 +0200
Message-Id: <1241722972.7590.34.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hrd8t2darnK3pvHkCi8E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

> > > http://thread.gmane.org/gmane.linux.kernel.wireless.general/25001
> >=20
> > No, I haven't. Yep, my solution is really too simple.  I like the
> > virtual air grouping. I'll implement it.
>=20
> After a bit studying how to use configfs (and getting a bit lost)
> I found netconsole.c which uses configfs. So this version is a copy&past
> thing. Of course, this needs more work.=20
>=20
> Is this what do did have in mind?

Very cool. We had a patch at some point to add configfs support to hwsim
but it seems it got lost :(

But I don't think your configfs support is optimal since you need to
create those dirs for phy0 and put the name in etc. even when phy0
already exists. I'm sorry to have wasted your time with the configfs
suggestion, but I think with how hwsim _currently_ behaves, without
configfs support for creating new radios etc., putting this into debugfs
would be nicer, since debugfs already has a dir for this from
cfg80211/mac80211...

> +config MAC80211_HWSIM_VGROUP
> +	bool "enable virtual air grouping"
> +	depends on MAC80211_HWSIM
> +	default y
> +	help
> +	  This option enables virtual air grouping.
> +
> +	  If unsure, say N.

I also wouldn't make it configurable, just make it default to group =3D=3D =
1
so that it behaves as it was.

johannes

--=-hrd8t2darnK3pvHkCi8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKAzBSAAoJEODzc/N7+QmaYZ8QAJaAShVT2boqyQFfcFfGQuNb
CyDeO/adBORizFsoOXzXTiRPR5LvxVZ4/Iz7tpKZa1579N+akp9INpgusCqvjIvt
rT4XbKGSDi+5woh7RIY7/G/+/AP5g9rknYJb8Ors9zxih6sOlx54tkMiIktdXBE3
HJNrZVRFKzFyFZLv4QDEbwa+bqVxmySUAoHjgocCEAxX7yPG6ugppMCYL2rYYtJX
qhqI58MZ5YPeihbjoZPC3rFfRBdRSCB7bJpcWFi8EuI4I0jJRGRGw1vXmbqS5lmC
ox1O0czEHL/snbaYLIkWEHr98gJcjQQSsiaqZEC6Ho3nm/FEY0Azxfptg8m9SPQ2
3BBwAXw93OtgN63JXiglNKZpidnARIQa4z8NPFdJGj9P6LbHGDTM0jEo5WD7gE5Z
Q5VsbH/zNGDM1tuiTEL0EPtJ1eX08IKddQtGfwGOaci2X/SM5tvg52GOGmhMZzc6
ib5a/YygMz810bchqrO+oFo1q7hr+qmq9iLJiIxMTuvKvIJxSCgzIB0HpKtDftes
aWdsLcKJN0FEIl7V0s+5wRlPM7pRSUW/AH1xsNjVXSMFn7gtuVbhCFfOJjubS3qC
l9uua1cmQU8rwLzXiGq72LdqKh6MZNimgUiVF46Ba+p/kAVf2jxhroVsC9DJ0ydZ
HzAUqa4HhmMUKfJmCH+W
=sfPj
-----END PGP SIGNATURE-----

--=-hrd8t2darnK3pvHkCi8E--


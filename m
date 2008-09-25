Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYIYLVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 07:21:42 -0400
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <1ba2fa240809250404i7e2404e7o3531ea1a889afb35@mail.gmail.com> (sfid-20080925_130410_491774_FCE34FAF)
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 <1222245882.18015.62.camel@johannes.berg>
	 <1222328058.2510.470.camel@debian.sh.intel.com>
	 <1222334592.10563.59.camel@johannes.berg>
	 <1ba2fa240809250404i7e2404e7o3531ea1a889afb35@mail.gmail.com>
	 (sfid-20080925_130410_491774_FCE34FAF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZxgOxl+Oxu+jNVNPdsZb"
Date: Thu, 25 Sep 2008 13:21:03 +0200
Message-Id: <1222341663.10563.67.camel@johannes.berg> (sfid-20080925_132146_871200_B8EAC719)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZxgOxl+Oxu+jNVNPdsZb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-25 at 14:04 +0300, Tomas Winkler wrote:

> > Therefore, I don't understand why you need to clutter the driver with
> > this code.
>=20
> You are too development oriented not everybody is looking into kernel
> logs. It's easier to ask user
> to cat sysfs/debubgfs. This is not tracing this is just check static
> information.

Shouldn't be much harder to ask users to provide kernel logs, we've been
doing that with b43 forever.

> Malicious gossip has it you're trying to obfuscate the code
> > to a point where everybody else refuses to work on it.
>=20
> We have probably most documented HW registers from all drivers so I
> doubt that has any ground :)

Well, in the code, I'm sure b43 has more documentation, I wrote it ;)

> We are definitely hooked to TX power, maybe you didn't notice

Didn't see it on iwl3945, but I only looked for the function that the
sysfs code calls and didn't find any other callsite, might well be a
different way.

> power_level
> >   also belongs here, sometimes one can't avoid the impression that
> >   you're adding things like that to avoid having to help define and
> >   implement the generic functionality;
>=20
> The patches are no the way, actually  I've sent one yesterday and more
> are on the way.

yay :)

> except log level
> which I want always visible and has proven to be most useful.

Yeah, indeed, though it seems to be notably lacking printing out the
physical addresses and the ringbuffer entries. But that's just the thing
I was looking for yesterday when debugging the corruption issue.

> > generic option to disable hardware crypto in _mac80211_ rather than eac=
h
> > driver because this is actually genuinely useful if you want to monitor
> > frames at the same time.

> This is good point also disabling and enabling hw scan I would like to
> remove from module params.

That would be doable via mac80211 too, though that is a much more debug
option than disabling hardware crypto, I see disabling hw crypto as much
more useful than disabling hw scan.

> This is on TODO list.

:)

Thanks,
johannes

--=-ZxgOxl+Oxu+jNVNPdsZb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI23QaAAoJEKVg1VMiehFY56UQAMEBoJgpyLUywJ3g21eJ2CQq
cCYkFv6aRsTFX4JAxu4Ja6P6FBaIVM0tujbTNy20ZZnHkCFyIbSkoOUv/foPf0bC
6juSB7+w7ZQrSFfbCg6jeSqCKByLeYV4pr9SVKE5yTli+Pw4CVNatbrjXCigepU9
IOoAjVd5DyaJUBQFs92zVcrPKxgou/NGi0iOWHGZilTFmrpEGRudjFdM9Y08is2U
f1AnKGZP1YJQnntriNCx9iZ9Mr2Qu7dEj8iUY/aw6Mtk5BEmGsD10LmRIuE40WlL
GaOP2a/ERXL5XbHoXu70TiOCrrB4aqhb9OyqzUz3MQT0gewCQtOmr/vwCEd/bdBb
8PUUtWunuOwubAuiepAHXXMDVaoslVgljdmg3sNy0zL+J1xeLHATmGpaoiHyLPTE
ZGMMYq6pjghqM9zIMen7rMlzyG9mcqs8BbA44nFj7kiZRFw/gLkKXE915FPuFNzu
KIHJjOIs8jqLY+P58RzsORibdw9wtMfYIZYxAx0Ve36Ea2NAWSeH/Su6FZfpeMoY
HHe49mHg6a0yqTumsM3uOm8mJDOpC35ztegdzCvZLfF4BHUSim3sSvlsfKzrdm7j
zeTjW4jMwqYTvOxyjFFW6yklt0PcrLVnVpsSuyaNCELBCwLw3x0qZiPNdpzvw1M8
k2B8RlnC0L6GSzY3wAqS
=UQvk
-----END PGP SIGNATURE-----

--=-ZxgOxl+Oxu+jNVNPdsZb--


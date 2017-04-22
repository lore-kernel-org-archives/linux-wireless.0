Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:36552 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1427263AbdDVWBq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Apr 2017 18:01:46 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Daniel Golle <daniel@makrotopia.org>
Cc: battlemesh@ml.ninux.org, gnunet-developers@gnu.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [Battlemesh] wifibroadcast
Date: Sun, 23 Apr 2017 00:01:41 +0200
Message-ID: <1806801.tVQKAhPZbv@prime> (sfid-20170423_000150_578218_07394F22)
In-Reply-To: <20170422153703.GE1681@makrotopia.org>
References: <CANjd3nfeiGgaHMcgOyKOKhRRKEwnn43VgC4GRcw-fuCkCdg2zQ@mail.gmail.com> <2945991.ay5rM9MeUZ@prime> <20170422153703.GE1681@makrotopia.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8783359.V50GRE38a8"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8783359.V50GRE38a8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Daniel,

On Saturday, April 22, 2017 5:37:03 PM CEST Daniel Golle wrote:
> Hi Simon,
>=20
> On Fri, Apr 21, 2017 at 09:55:03PM +0200, Simon Wunderlich wrote:
> > Hi Daniel,
> >=20
> > >     mac80211: Parse legacy and HT rate in injected frames
> >=20
> > Yup, Sven was so kind and helped with this. :D
> >=20
> > I'm experimenting with some opportunistic routing ideas ...
>=20
> I just realized that the radiotap headers are still not part of the
> UAPI exported by the kernel. How is one supposed to go about this
> issue? Have lots of diverging local copies of ieee80211_radiotap.h?

Propose a patch and send it to linux wireless to move it? :)

> And change all the kernel-specific types (u16 and such) into their
> corresponding userland types (u_int16)...?

Hmm, uapi is full with __u16, __u32, ... see linux/types.h

>=20
> I'd be glad if you can share your idea about proper and/or intentional
> use of the kernel's radiotap capabilities...

Well, there is a radiotap parser in the kernel which is quite useful for=20
reading (net/wireless/radiotap.c). And there is a radiotap library which al=
so=20
does parsing [1] (seems it's based on the kernel implementation), reference=
d=20
from=20radiotap.org [2]. What is missing (or at least I didn't find it and=20
implemented something on my own) is a library/function to build radiotap=20
headers (i.e. for writing). There are quite a few things to consider (paddi=
ng,=20
alignment, etc). To make it useful, you would also need to build ieee80211=
=20
headers at the same time ...

I have some rough working C code for all of that (integrated into something=
=20
bigger), not sure if it would be useful to make a library out of it.

I don't have an idea about "proper" usage though. Since Johannes seems to=20
maintain most of that radiotap stuff, I'm CC'ing him and linux-wireless. Ma=
ybe=20
there is already more than what we know. :)

Cheers,
      Simon

[1] https://github.com/radiotap/radiotap-library/blob/master/radiotap.c
[2] http://www.radiotap.org/
--nextPart8783359.V50GRE38a8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAlj70sUACgkQoSvjmEKS
nqFb0w//UqmR7ix/vU0oMbegHhBkLQ5AVviXcx93382SKwshFltFh+7KhXE4+gAk
umX0qWmWIJDuHjKM1HI86Oq1+lEtoLuZQX7ZP4CHZ2A2KvystM2A7wQngNTNln73
F2iTb05/zPaShVKAALPZpDwDCrrSoDCqBpincFLXIvKbLreA5d6zIxEqxrP8XZ9v
SVF3jUFATI8iXUYzn/853BXXfB6DOC85wC09fssXDrx98kroXDx0JKo7qFmjf1rU
KLoD3IHuTvSsE8h8iKB0N9ZSq1sdrYrYVbozdG4Sux5rhvz9HlrqVzKpbR69vzsH
hOZqGS6zR/K7vXk15M54w1jl0Wn7h3BH/krD0+DFfB+TAusBIqE5JmK30JJECzAM
OsEGzsYmGJPsw5CLAkaG9jRueJQ72iQfT+yUeG2R1rVE72HBA50AYSQWAMAOPP0T
ITZ/4ObMGyWzoESXHCNcpjSUxtwW8UFlereghAdvFJgydlfAtFjNHNfbjE4cUTTO
Vb99+Usmy6NP+vQrJf4UKNfYkm5ub7rbvAD+JmCigykK7deyd8bFL/qRNcpmckY4
ff4eGkjc+9tgc65E3BIZK8yG29IhsR2xplaE3wR0FtBL/Gr68Xtdz6K4fBcDTuLd
JkDZemPoIgUIpTW1zHGMKIdIlXwmoTUnLnZ+oUxxAgoUJ8G6NfM=
=jcF5
-----END PGP SIGNATURE-----

--nextPart8783359.V50GRE38a8--

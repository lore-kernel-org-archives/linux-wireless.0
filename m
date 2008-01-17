Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYAQPgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 10:36:36 -0500
Subject: Re: [PATCH] mac80211: fix RCU locking in
	__ieee80211_rx_handle_packet
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <c85cb4470801170732y4e0c1921n6e66836f7ebf495d@mail.gmail.com> (sfid-20080117_153252_992658_4E2FDA82)
References: <1200516460.8007.2.camel@johannes.berg>
	 <c85cb4470801170732y4e0c1921n6e66836f7ebf495d@mail.gmail.com>
	 (sfid-20080117_153252_992658_4E2FDA82)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WPNEzIfrSdlgnMKrJG9o"
Date: Thu, 17 Jan 2008 16:36:17 +0100
Message-Id: <1200584178.8007.48.camel@johannes.berg> (sfid-20080117_153641_519390_D2EC0144)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WPNEzIfrSdlgnMKrJG9o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-01-17 at 17:32 +0200, Ron Rindjunsky wrote:
> >
> > sparse actually detected this.... oh well
> >
>=20
> Arrrr... i did the re-structuring of Rx flow and forgot to sparse.
> I'll issue a patch to clean up the warnings.

No worries, the rest is just harmless missing "static" keywords. I
wonder though, should we get rid of that special case completely? Jiri
intended this as an 'optimisation' but since we rarely even hit the case
(I had to play with monitor interfaces *and* AP mode to hit it!!) it
probably hurts performance more by the extra branches and all that. And
it makes it harder to verify correctness...

johannes

--=-WPNEzIfrSdlgnMKrJG9o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4918KVg1VMiehFYAQIkTg//TV6kkktK9MTQoxPxF7A4qumT7MzFuZH7
hewZY7o1AaWfwDAEzkiyTyzpQQEAbZfIhgKSGIdJAufTKtp8cd2L1MiIIJLJF0j1
DrByR/eljFS4F9JPMDuJ8+zDOtd0JAH2Bn8VOKfas9lCz9OPQ/uSTrEiDGNTZjLy
bQvffVPQtL1xFTk6htrlY8C0jYhEN+AM8y/1pT6Lm1WumjzbJyZzeLXcQ6wE4Kxy
HKs0lb5DbvLMhgzSR3SPguBo4KZuIsiiZEuCQiJMcusf7KaB/da63Tf7EVBiLWbb
76Twrg5o81mDoOydXoBoaFkcHcUGpMELD10uwU9hJcMF6eD050DS5Kov/MNewZct
zhes0wgcvWkoesom6iP0fJ/qGFi2TOnXmfI2x/NqmXzZxICEmSNtxWMJcpxbvS95
FOLRGEfP0sqnOjv63W8uFzA18cFHfQg6IhghsiygP2zbK1xnuFXEv79AV9DSnFQy
wPKr7TcfNsXL7y5RmhJnA+5N/jA4OZEot7zBPQBQBtz/tL/Sz/bD/bYl2vutIp7i
HnG/bOgV5kV2OwalHb+YPCKyYrbAoQs+687c3GDo2M0mITkQcn0Mxkws8j8cSHVb
/vb1PeWwJS6dStMC6MK5Xxo9y6iNHKnNhvUkBY7t0J1ZdDdAZx7jLhiJAXuaZSOu
/g1RjdYx5/o=
=p5j8
-----END PGP SIGNATURE-----

--=-WPNEzIfrSdlgnMKrJG9o--


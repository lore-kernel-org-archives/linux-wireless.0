Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbYBYXsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 18:48:20 -0500
Subject: Re: mac80211: sta info locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1ba2fa240802251541r218d5f22j5b3490d20ab508e3@mail.gmail.com> (sfid-20080225_234203_093090_045ED971)
References: <1203677069.26341.52.camel@johannes.berg>
	 <20080222143745.GB3067@tuxdriver.com>
	 <1203693409.7082.30.camel@johannes.berg>
	 <20080222155704.GD3067@tuxdriver.com>
	 <1203972413.13162.163.camel@johannes.berg>
	 <1ba2fa240802251450x4ee13b94yb93e64fd9ebfcec8@mail.gmail.com>
	 <1203980105.13162.182.camel@johannes.berg>
	 <1ba2fa240802251512k15b40d65oee774acebdb953e0@mail.gmail.com>
	 <1203981812.13162.187.camel@johannes.berg>
	 <1ba2fa240802251541r218d5f22j5b3490d20ab508e3@mail.gmail.com>
	 (sfid-20080225_234203_093090_045ED971)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g1GoXjrqCdk0ar43WCiU"
Date: Tue, 26 Feb 2008 00:48:04 +0100
Message-Id: <1203983284.13162.196.camel@johannes.berg> (sfid-20080225_234824_589856_EDAD0ADB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-g1GoXjrqCdk0ar43WCiU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  Thanks. Yes, I do realize that this is a bit intrusive. On the other
> >  hand, I can't see the code holding the spinlock for longer code/period=
s
> >  of time (nor should it). Or do you think the driver is allowed to call
> >  into the AMPDU TX setup path while being called from the AMPDU RX setu=
p
> >  path? That would be a bit weird.
> >
>=20
> TX and RX BA sessions are triggered from different threads of
> execution namely rate scaling and RX path. The protected sections are
> quite long IMHO including call outs to underlying driver. It is very
> likely that both sides decides for BA session at the same times.

Yes, but I still can't see how the driver would be calling both RX and
TX aggregation functions /within each other/. That's the only thing that
really matters since all the frame TX/RX is synchronized and thus the
spinlock can't really be contended. Anyway, I need to look deeper into
the code or just try or something.

> >  > Do you have any setup to check your these changes?
> >
> >  Unfortunately not quite yet. I have an 11n AP now though, but broke of
> >  one of the antennas, I'll need to see how well it works.
>=20
> That's bad 11n is too sensitive on antennas setup.

Yeah, I know. I don't know why my router has three antennas though
knowing that the Broadcom HW only has two chains.

> >  > Currently there is known possible deadlock when unloading driver whi=
le
> >  > heavy HT traffic. This is happening while trearing down BA session. =
I
> >  > need to solve this as well.
> >
> >  Interesting, where does it deadlock?
>=20
> IIRC there is nice loop including queue lock need to dig the
> description tomorrow to satisfy your curiosity.

Not too important so don't bother.

johannes

--=-g1GoXjrqCdk0ar43WCiU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8NTs6Vg1VMiehFYAQIt6w//Rh3WRq6xFGOWOR6wReQPlUB9EJF/s+MS
XBIhghNMlsTQd55nqSE8teDhTAGpvbuZBexoHrZD0PYievsxH6sHhBqjdIAFiixS
hbq+zUGSCSUOlVoVYPgBw7djEbi3GEKxidzjC4kxPA+4j2Ask5nCdALgwqiY/S1d
SrfYY7E9Dc3CUQpJPtzXKo3zM8oQs3LEJig4gre3ufpeuaLLAp8WG07QyrAhh/gO
/Oq0wCfkiQGkuE/VLk1R67MFpnvkt0DmHBqVi+EoriRnZIahvW7qjUu88Ke4LcTE
1UrV6MRx+LpN+GGnFVne7YcajA8n9YLuKurTwNsB5n7u4l0CJfJDRQqhJ6n4VfPx
5jPEl4puRhtCKTxYqI9Bse8DsQQ9jmaH3wIXOnVMmMl/d36kuETxBGoZYvS3aErA
fWwMHSx+XG0Eik+97Y7X3/1bl7L3lI1M6ZSBE4jC7FkapT9IKBF4SbwqdSYZwhsv
Tp68qGYYrYDyZlnUB9sYf6GT8HI7Ta/m823J/BhqcGJgsvicqI4L7fh4CMoyxvru
aP+IPzAMOWXVs6KJip1IBuY2miXdnS8d8avBKE+qAir9XSmkyAb6m9IvV9VC8+ZF
9TsfzYlGXe2AHKNDMqrUikuT0Fu39p2mffAd3jvVRhZbBtKO6xobAy5hr9IgNij7
tIlwLA5sKHU=
=CILL
-----END PGP SIGNATURE-----

--=-g1GoXjrqCdk0ar43WCiU--


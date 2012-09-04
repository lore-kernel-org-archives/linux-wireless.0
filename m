Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:21279 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab2IDTpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 15:45:47 -0400
Date: Tue, 4 Sep 2012 21:45:32 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg/nl/mac80211: use per-band basic rates bitmap in IBSS
Message-ID: <20120904194532.GJ22841@ritirata.org> (sfid-20120904_214551_314737_330FCA48)
References: <1346784741-7003-1-git-send-email-ordex@autistici.org>
 <1346787524.3737.43.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8jNwmpfkpox/fiJK"
In-Reply-To: <1346787524.3737.43.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--8jNwmpfkpox/fiJK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 04, 2012 at 09:38:44PM +0200, Johannes Berg wrote:
> On Tue, 2012-09-04 at 20:52 +0200, Antonio Quartulli wrote:
> > Each band maps the bitmap of rates to different real bitrates, therefor=
e using
> > the same bitmask for every band (as it is now) is not correct.
> > Each band must have its own bitmask where the bits of the rates specifi=
ed by the
> > user on IBSS join have to be set
> >=20
> > Signed-off-by: Antonio Quartulli <ordex@autistici.org>
> > ---
> >  include/net/cfg80211.h     |  4 ++--
> >  net/mac80211/ibss.c        |  6 ++++--
> >  net/mac80211/ieee80211_i.h |  2 +-
> >  net/wireless/nl80211.c     | 12 +++++++-----
>=20
> I'm not sure I see the need to change nl80211, and the change seems
> wrong anyway.
>=20
> As far as I understand it, the basic rates that are passed into the
> kernel are intended to be used when the kernel creates a new IBSS. This
> always happens on the channel that is also passed in, so it's always
> bound to a given channel (band).

I think basic rates are also used in case of merging, right? In this case we
could switch to another channel (and band).

>=20
> Now mac80211 internally seems to mess this up a bit, but that doesn't
> affect nl80211/cfg80211?

I modified nl/cfg as well because it is in that point that the bitrates pro=
vided
by the user are converted to the band bitmask and so only here I create a b=
itmask
for every band and pass them all to the mac80211.

In this way we have a bitmask for each band and we can use the one we need
whenever we switch band.

is it a wrong approach?

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--8jNwmpfkpox/fiJK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBGWlwACgkQpGgxIkP9cwcT8gCbBqYbKqLp3GEm5PL94gUk0OfK
rywAnRVWcnwheRyp5ETLiffhPz9Qkt7e
=EseM
-----END PGP SIGNATURE-----

--8jNwmpfkpox/fiJK--

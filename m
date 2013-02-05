Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:47874 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab3BEKDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 05:03:38 -0500
Date: Tue, 5 Feb 2013 11:03:29 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 2/3] mac80211: add radar detection command/event
Message-ID: <20130205100329.GC7865@pandem0nium> (sfid-20130205_110348_718786_45029696)
References: <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359643448.8415.62.camel@jlt4.sipsolutions.net>
 <20130131163126.GB1387@pandem0nium>
 <1359650902.8415.93.camel@jlt4.sipsolutions.net>
 <20130131174758.GC2018@pandem0nium>
 <1359712620.8528.5.camel@jlt4.sipsolutions.net>
 <20130202221544.GA22363@pandem0nium>
 <1359999125.17993.15.camel@jlt4.sipsolutions.net>
 <20130205084405.GA7865@pandem0nium>
 <1360056900.8376.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
In-Reply-To: <1360056900.8376.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 05, 2013 at 10:35:00AM +0100, Johannes Berg wrote:
> >=20
> > Well, yeah the reporting is currently done per interface. Reporting rad=
ars
> > for the hw is certainly possible as well - channel contexts are current=
ly
> > not implemented in ath9k (where I test). The latest patchset works the =
same
> > way, although we can change that if you prefer. For the current impleme=
ntation
> > (single channel, single vif) it makes no difference, maybe for future i=
mplementations.
> > I don't know if there are any weird corner cases though, and we probabl=
y need to
> > adjust the mac80211 interface too when to report radars on certain chan=
nels only
> > (e.g. extension channel radar).
>=20
> It really just seems strange to me to report radar on all/any other
> interfaces to userspace. If we leave it up to the drivers, we'll get all
> kinds of strange behaviour ;-)
>=20
> So it seems better to let mac80211 manage that?

I was afraid you'd say that ... :)

I'll include that change in the next iteration (it is a rather small fix). =
If you
find anything else in the v8 patchset, please let me know so I can include =
that.

Cheers,
	Simon

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEQ2PEACgkQrzg/fFk7axbhCgCg63gKkwLbU3xy8V5szFJsv88s
zCMAoKsWyvdz726C2WGabViZKuHGFQRK
=LjQm
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--

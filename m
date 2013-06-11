Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:65301 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3FKL7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 07:59:21 -0400
Date: Tue, 11 Jun 2013 13:57:22 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCHv4 1/4] mac80211: make mgmt_tx accept a NULL channel
Message-ID: <20130611115722.GD1466@ritirata.org> (sfid-20130611_135923_952339_15D8E136)
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
 <1370951718.8356.22.camel@jlt4.sipsolutions.net>
 <1370951887.8356.23.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
In-Reply-To: <1370951887.8356.23.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 01:58:07PM +0200, Johannes Berg wrote:
> On Tue, 2013-06-11 at 13:55 +0200, Johannes Berg wrote:
> > On Wed, 2013-06-05 at 17:09 +0200, Antonio Quartulli wrote:
> >=20
> > > +	if (need_offchan && !chan)
> > > +		return -EINVAL;
> >=20
> > > @@ -2847,10 +2853,14 @@ static int ieee80211_mgmt_tx(struct wiphy *wi=
phy, struct wireless_dev *wdev,
> > >  		rcu_read_lock();
> > >  		chanctx_conf =3D rcu_dereference(sdata->vif.chanctx_conf);
> > > =20
> > > -		if (chanctx_conf)
> > > -			need_offchan =3D chan !=3D chanctx_conf->def.chan;
> > > -		else
> > > +		if (chanctx_conf) {
> > > +			need_offchan =3D chan && (chan !=3D chanctx_conf->def.chan);
> > > +		} else if (!chan) {
> > > +			ret =3D -EINVAL;
> > > +			goto out_unlock;
> > > +		} else {
> > >  			need_offchan =3D true;
> > > +		}
> > >  		rcu_read_unlock();
> >=20
> > It seems this would be clearer?
> > http://p.sipsolutions.net/b8a03c85f0e8b89f.txt
>=20
> Actually, no, I like your version better.

uhm, having one else less looks better..why did you change your mind?
Maybe you version is not entirely equivalent?


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRtxCiAAoJEADl0hg6qKeOHCoP/0RSurva4pXRIqK9V3GEEvl7
KbS9guXF+Ls1ER4GqDNMr1qNJ0f7k4HvH5mB1iD6xWHCBwvlyXlGdGOnblQqaV4H
Web2ZwtqYPaXVtGHtZgxI7yX5DgqWspKeyqOeA1u9NExbohCrV0Ehb2AQD/rborj
oakvKTTY2YaNSeMR+58pdC8b9VTOogcalBTblKwPBD7twTkXA9gpjYYe1bU2ATAZ
SuEqDwYCZERkkX/pebjTPgmoo2xehg2VwzGaiNxeuQDsFnQO6cHGw2n8Sjqq1LrI
CXPQvFWYAC7N5xjdxabiCbEMoTEcDHd47w672AMwXKWrVGPNtCNO/H5aIM+ORDuF
UYlhhgiF5uEIhuIvDx7utHc9LxkpLvBr5Lxru7huzV1X9uGA4JEzv7bg9Du8JMfI
PJMdsLrsd0S4VkI9JSPFpovBYKss6OtXm16rITDsLe7HKOx1Zv4NwT2baeBda08a
GskxVwYz+A3gWZp49LC6htcZZ0zLKG/dS8WzNE9jZtfLC31II5hLm63s9Y8rt2N5
BM5FiP4s2121NsorlzG00/xKolL/WZiAGcJsc0liwqnwgb7+LUbrzm8JU7Y+hzfb
lacN4RVFt45no+tLcEvshCNmmFGhaS+6wpTEfHwfKknHPPV3o4rTYRo2XtMrqbXl
5jc4OhQ3eybsmjRlJ+oK
=ot94
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--

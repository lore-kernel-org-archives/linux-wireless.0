Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:37222 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3FKL6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 07:58:37 -0400
Date: Tue, 11 Jun 2013 13:56:37 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCHv4 1/4] mac80211: make mgmt_tx accept a NULL channel
Message-ID: <20130611115637.GC1466@ritirata.org> (sfid-20130611_135840_177343_DEBFBE88)
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
 <1370951718.8356.22.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
In-Reply-To: <1370951718.8356.22.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 01:55:18PM +0200, Johannes Berg wrote:
> On Wed, 2013-06-05 at 17:09 +0200, Antonio Quartulli wrote:
>=20
> > +	if (need_offchan && !chan)
> > +		return -EINVAL;
>=20
> > @@ -2847,10 +2853,14 @@ static int ieee80211_mgmt_tx(struct wiphy *wiph=
y, struct wireless_dev *wdev,
> >  		rcu_read_lock();
> >  		chanctx_conf =3D rcu_dereference(sdata->vif.chanctx_conf);
> > =20
> > -		if (chanctx_conf)
> > -			need_offchan =3D chan !=3D chanctx_conf->def.chan;
> > -		else
> > +		if (chanctx_conf) {
> > +			need_offchan =3D chan && (chan !=3D chanctx_conf->def.chan);
> > +		} else if (!chan) {
> > +			ret =3D -EINVAL;
> > +			goto out_unlock;
> > +		} else {
> >  			need_offchan =3D true;
> > +		}
> >  		rcu_read_unlock();
>=20
> It seems this would be clearer?
> http://p.sipsolutions.net/b8a03c85f0e8b89f.txt

agreed :)

I'll include this change.

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRtxB1AAoJEADl0hg6qKeOclIP/jyhgZrLSfy6NLtsOex+ljT6
7FheupZ7o/6FS1fBFsxlo2y1/oiRyGdCfwpzD3BWtR3coYa7e2MntvYrmDeueVLI
Zd00g8lTozbcJw/TtQoeDXK1uOqK3PsFVuKfOZcpDA40EkMtrYanMgoAVcvTK6Ki
9gr3jDL01MVGg9ajsWM+D27ZWREKDmxQvfvfntdrB7yk8YONDWDZXpJMJ9ZAL2c9
bzb6rJoDfYUwMZek2oXCQmWi2JvlYsUHqEiJo2c70Fuq9GwDJQ4dpECuDUeO9fHC
840OogWwsyi1ALkuRMJZXI4mPzs4KFu/cf9LCOAbbF1gBsciycU1hEeuktFTBGZ/
kclPwDGwNfgf9SR4oq/gEPQ3YqLLhtoohAOc/72VWNfzenYBE8oS/rSMtexYPkp7
eLT7s02AG1vffQBgG+9y7/7b/JubHGMjz2tGYqCWpX2jAAkCaFQm+62/CWhtLPGz
Irbeu4nMgxbVflbyMxEjbuHIpcE4XyGsNMR/Lfdqmd3y80hpvKmQ2+qIbWMcj4ub
Hufcjd8Ja3o37FWxVZfvifFFgzq26fCDD7PvSlC82Ds0cJA+WG07n4POlCgPIJse
zL5311XvcnniSjjVuaTos3qMFafL2ptOBA/Buvzhj6ZXoBoVDIXQfnJ9lMMCwxsJ
uOuFnXW2AJnpXnA57Y28
=76KS
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--

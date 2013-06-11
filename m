Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:31770 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3FKMJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 08:09:35 -0400
Date: Tue, 11 Jun 2013 14:07:34 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCHv4 1/4] mac80211: make mgmt_tx accept a NULL channel
Message-ID: <20130611120734.GE1466@ritirata.org> (sfid-20130611_140946_366423_A822A73B)
References: <1370444989-2095-1-git-send-email-ordex@autistici.org>
 <1370951718.8356.22.camel@jlt4.sipsolutions.net>
 <1370951887.8356.23.camel@jlt4.sipsolutions.net>
 <20130611115722.GD1466@ritirata.org>
 <1370952437.8356.26.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
In-Reply-To: <1370952437.8356.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 02:07:17PM +0200, Johannes Berg wrote:
> On Tue, 2013-06-11 at 13:57 +0200, Antonio Quartulli wrote:
> > On Tue, Jun 11, 2013 at 01:58:07PM +0200, Johannes Berg wrote:
> > > On Tue, 2013-06-11 at 13:55 +0200, Johannes Berg wrote:
> > > > On Wed, 2013-06-05 at 17:09 +0200, Antonio Quartulli wrote:
> > > >=20
> > > > > +	if (need_offchan && !chan)
> > > > > +		return -EINVAL;
> > > >=20
> > > > > @@ -2847,10 +2853,14 @@ static int ieee80211_mgmt_tx(struct wiphy=
 *wiphy, struct wireless_dev *wdev,
> > > > >  		rcu_read_lock();
> > > > >  		chanctx_conf =3D rcu_dereference(sdata->vif.chanctx_conf);
> > > > > =20
> > > > > -		if (chanctx_conf)
> > > > > -			need_offchan =3D chan !=3D chanctx_conf->def.chan;
> > > > > -		else
> > > > > +		if (chanctx_conf) {
> > > > > +			need_offchan =3D chan && (chan !=3D chanctx_conf->def.chan);
> > > > > +		} else if (!chan) {
> > > > > +			ret =3D -EINVAL;
> > > > > +			goto out_unlock;
> > > > > +		} else {
> > > > >  			need_offchan =3D true;
> > > > > +		}
> > > > >  		rcu_read_unlock();
> > > >=20
> > > > It seems this would be clearer?
> > > > http://p.sipsolutions.net/b8a03c85f0e8b89f.txt
> > >=20
> > > Actually, no, I like your version better.
> >=20
> > uhm, having one else less looks better..why did you change your mind?
> > Maybe you version is not entirely equivalent?
>=20
> It's not, but that wouldn't matter, it's different I think only if you
> have input from cfg80211 as "!chan && offchan".
>=20
> It just seems to me that your version is clearer, first you check if you
> need offchan, and if you do but don't have a channel you abort. Then you
> check if you might need offchan for another reason, etc.


yeah. Ok I'll keep my version.

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRtxMGAAoJEADl0hg6qKeOJfkP/1HfNB/+iHkSotsOffMqADz6
trASboMR41xwBzH7/umvE2HpHuFpM7Ws/R3zEfhtd21Mbqq4fjpgAigy7Vv0IxKQ
s6h+rQd+FUCsd48CjNgR1VhHQa7dTbKEV2DBoG4zxKnPY8NRocG+IbVFOacShuPx
7nUJOKkVS78Cq0a6OEzeiRihS1vkAuUOvmiERrl1DWyTXPu7gXQo4x58DnfC9jX7
QplzsYdiTWkoH4fgXynQifv/y8rGCKePx7dim1aJWkYMVIouDpjk0TLZXg7Ak7TJ
+KqaVVkuJnRN0Gr4jEe1OiqWHmx0rPalVBkI7KDV3pEyN4xqFBT7uVh117m9/gd8
9b5zco5RWnfocfSOoHQLMIUnLqtlc/ynMQIz0h0nEd+sBUiMZHWqoM215FCRCF4d
x36mEzUaDwUvk+oauwFd1kvG/1LklofwSLIMLb1ZWXBPzcV70AQvwBoErf9rrTxj
SiymrCJyOd9rOLLdqEJ/5tkwN9Vl8A2XhFiQaatm1/RTTj7F0Y+R57AkG9nz/Xv7
ur/dffV6x3y3gUq/k+ZdLKHyXMwgfYGgIIF0DwlN/K/v+Vew5HdhJcT22E+4yoLS
qgSkSw85R+Hj1CRMd8FEgmyWhJX78o7osYatkuRt2X9Ht79nRLpkXfwjzYgBt+vI
2Q9IyT4f7teiJmB0VNQs
=8hri
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:42274 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3FCS2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 14:28:17 -0400
Date: Mon, 3 Jun 2013 20:26:24 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCH 2/2] mac80211: in mgmt_tx use the current channel if none
 has been specified
Message-ID: <20130603182624.GG1226@ritirata.org> (sfid-20130603_202821_001370_37EDA5E0)
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
 <1370241587-2609-2-git-send-email-ordex@autistici.org>
 <1370271690.8227.18.camel@jlt4.sipsolutions.net>
 <20130603180320.GF1226@ritirata.org>
 <1370283363.8227.27.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
In-Reply-To: <1370283363.8227.27.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2013 at 08:16:03PM +0200, Johannes Berg wrote:
> On Mon, 2013-06-03 at 20:03 +0200, Antonio Quartulli wrote:
> > On Mon, Jun 03, 2013 at 05:01:30PM +0200, Johannes Berg wrote:
> > > On Mon, 2013-06-03 at 08:39 +0200, Antonio Quartulli wrote:
> > >=20
> > > > @@ -2845,6 +2852,10 @@ static int ieee80211_mgmt_tx(struct wiphy *w=
iphy, struct wireless_dev *wdev,
> > > >  		rcu_read_lock();
> > > >  		chanctx_conf =3D rcu_dereference(sdata->vif.chanctx_conf);
> > > > =20
> > > > +		/* if no channel was specified, use the current one */
> > > > +		if (chanctx_conf && !chan)
> > > > +			chan =3D chanctx_conf->def.chan;
> > > > +
> > > >  		if (chanctx_conf)
> > > >  			need_offchan =3D chan !=3D chanctx_conf->def.chan;
> > > >  		else
> > > > @@ -2852,6 +2863,12 @@ static int ieee80211_mgmt_tx(struct wiphy *w=
iphy, struct wireless_dev *wdev,
> > > >  		rcu_read_unlock();
> > > >  	}
> > > > =20
> > > > +	/* at this point a channel should have been chosen */
> > > > +	if (!chan) {
> > > > +		ret =3D -EINVAL;
> > > > +		goto out_unlock;
> > > > +	}
> > > > +
> > >=20
> > > These two changes make no sense at all. If you look at the function
> > > you'll see that "chan" isn't used at all after the check,=20
> >=20
> > uhm? it is passed to ieee80211_start_roc_work() right after (this part =
has not
> > been changed).
>=20
> > 2904         ret =3D ieee80211_start_roc_work(local, sdata, chan,
>=20
> No, you can't get there without need_offchan.

ah, you are right. Now I see why these two changes do not make sense at all=
 :-)

Thanks!

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRrN/QAAoJEADl0hg6qKeOBzYQALoMfRuReePflIugthunlq7i
6itzo5H0Sig0WImzAbdu3UNae6k6P7FB4BBUD1sefDyOYTAfQZbxk01d3kZOsJSS
Pm9v+2NBn7yymiaRdy+EIshRHA/2D87sV8acLSjPGV1IHHAsPK1l/p5RGo3rCjFQ
ecs8qmQtc78OsGKxjwXM+TQWa5F/cdN4M42o/ABvu/ww+SHXiKmNAqgi6fhWm13c
gWPpvCW5aqU16cEOBGehlPh7HHmFwOE3rK6MZvCbVh6FoQlkzcCQMauETNsYKeeO
J3qYEEqGesmQLDBC/F2h9RbiSNXan8p8BqqaPMDJB+ToX+ljbUBT36de3c7394qT
+ecsrmWlrpaBKUpVTu8WsKwCAMw5xh516aJHJoatDeTeuPCDO0ue5YBAeKHY0o6s
DTkkMlMWzTidZqKsIwrsz7rWnSwUy8WGi2xQqWU4/FeJAfSfiCMd/3EHIDTfmCah
W1weBeDR7Dr/+uMEy0omAk50chBjlbnBvWh7NfMIjcmfC1zvoPx7kIb/25wMCBcM
hI7dThCdOikvkNt9SY/oa+l4CDlOc4KNmh9tOhTfe43/C3r+RBCOic4OQ/9QPYbC
uEYlPJkeUdrFuYZn+wwK/50XZI9ROBrcrHuF2rV8lUeb3zprlgt4tJp8lwsJB7uD
f3GPY+tIdHo2C1p4kgKm
=vF2A
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:20352 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273Ab3FCSFP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 14:05:15 -0400
Date: Mon, 3 Jun 2013 20:03:20 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCH 2/2] mac80211: in mgmt_tx use the current channel if none
 has been specified
Message-ID: <20130603180320.GF1226@ritirata.org> (sfid-20130603_200527_827139_9305B739)
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
 <1370241587-2609-2-git-send-email-ordex@autistici.org>
 <1370271690.8227.18.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2FkSFaIQeDFoAt0B"
In-Reply-To: <1370271690.8227.18.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--2FkSFaIQeDFoAt0B
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2013 at 05:01:30PM +0200, Johannes Berg wrote:
> On Mon, 2013-06-03 at 08:39 +0200, Antonio Quartulli wrote:
>=20
> > @@ -2845,6 +2852,10 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy=
, struct wireless_dev *wdev,
> >  		rcu_read_lock();
> >  		chanctx_conf =3D rcu_dereference(sdata->vif.chanctx_conf);
> > =20
> > +		/* if no channel was specified, use the current one */
> > +		if (chanctx_conf && !chan)
> > +			chan =3D chanctx_conf->def.chan;
> > +
> >  		if (chanctx_conf)
> >  			need_offchan =3D chan !=3D chanctx_conf->def.chan;
> >  		else
> > @@ -2852,6 +2863,12 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy=
, struct wireless_dev *wdev,
> >  		rcu_read_unlock();
> >  	}
> > =20
> > +	/* at this point a channel should have been chosen */
> > +	if (!chan) {
> > +		ret =3D -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
>=20
> These two changes make no sense at all. If you look at the function
> you'll see that "chan" isn't used at all after the check,=20

uhm? it is passed to ieee80211_start_roc_work() right after (this part has =
not
been changed).

2904         ret =3D ieee80211_start_roc_work(local, sdata, chan,


> and modifying
> the "check if ..." part to use the channel also doesn't make sense.
>=20

to which part do you exactly refer? I'm just ensuring that the chan variable
gets assigned before something accesses it.

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--2FkSFaIQeDFoAt0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRrNpoAAoJEADl0hg6qKeOKCQP/jmZtwoJQxMRJEVYjDDvI8lP
ApacpIvM33GqrwKgTC5CtnvjPOrC5Z7KLUyIObnURHOX4ABVwyPVLz/PX009kpbY
e2usFztg7YH2j5hnUmVk+05qrBYE3/dyNUJpxvWmA2DA5TBWsInT6EDSC0/nYTyP
ICmKmlYw5GojsM+0vHBFj0rQqFaiRiiBYkS0TsinezbTmaevRh8MWNPmtPrZs+BA
8SGUpTJV3r3E9VWO/w3pvhEmi2x7m2rwNj+YIIrrErcgi6Rv9o1fXkWDO1agMorU
lN/HSvwLoVPWfk8CmBosVQHjgIHTpNAfysy9TqpGcEFAgh7lV0CfrQYpaQ2GYMX6
j7JJnB5ZGm1OzMhVus5wGxsSQwg239wmy3/aX5zt1Z5nETu446NVbdDSKzd9DKZy
+Z7CnY1pfAjeYh9t81ZYPxNy4dtv1+eQLtCTLRAK/Pa+yF85FBJ69IC6YqC286ra
wLBtYkV0Oz84NJU8hxJ7j1A48VN71oB7SRzYR/Cqqqljew9GyjhpEBQVETtn7OWF
lXbEaTMW2IYV5guQ3OV+TsCyZxpPixxIprARgw3kWM4Et9PCuymYB2mAcpY8ISGQ
dCbl5B0mQUC3dcyxOtBZ60pga3CGS+du4hXrIMu/beHSE+ZcVHCKGxRoeOk82ISu
gRwbXsfMZqaPuXRn1vwM
=Mwgw
-----END PGP SIGNATURE-----

--2FkSFaIQeDFoAt0B--

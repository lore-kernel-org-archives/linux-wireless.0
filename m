Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbZCWTgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 15:36:53 -0400
Subject: Re: Kernel panic with zd1211rw and today's compat-wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Bob Copeland <me@bobcopeland.com>,
	"Alexander E. Patrakov" <patrakov@gmail.com>,
	linux-wireless@vger.kernel.org, mb@bu3sch.de
In-Reply-To: <87iqm0s2dy.fsf@litku.valot.fi> (sfid-20090323_160900_704015_CEA0ADD2)
References: <20090322174515.22f11d92@home.aephome.ru>
	 <1237726612.19647.2.camel@johannes.local>
	 <b6c5339f0903220749j5373d132gdf24edc4d6ac610c@mail.gmail.com>
	 <87iqm0s2dy.fsf@litku.valot.fi> (sfid-20090323_160900_704015_CEA0ADD2)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xKwyaleZVg1KqeJigkqO"
Date: Mon, 23 Mar 2009 20:36:28 +0100
Message-Id: <1237836988.6147.18.camel@johannes.local> (sfid-20090323_203657_272502_2D7B9D8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xKwyaleZVg1KqeJigkqO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Hmm, I've seen the rate_control one before, and there's a guy
> > with ath5k who can reproduce it easily.  Looks like minstrel
> > somehow gets confused about the rate table and eventually tries
> > to use -1 as a valid rate index.  Neither I nor Felix could come
> > up with a logical explanation, though (I am completely lost in
> > the RC code, so that's not saying much for me).
> >
> > He is using ad-hoc too - but I use adhoc on a daily basis and
> > haven't seen it myself.
>=20
> Today I saw something similar with stlc45xx and wireless-testing:
>=20
> [11723.959442] kernel BUG at net/mac80211/rate.c:239!
>=20
> And the BUG_ON() is this:
>=20
> 	/*
> 	 * try to enforce the maximum rate the user wanted
> 	 */
> 	if (sdata->max_ratectrl_rateidx > -1)
> 		for (i =3D 0; i < IEEE80211_TX_MAX_RATES; i++) {
> 			if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS)
> 				continue;
> 			info->control.rates[i].idx =3D
> 				min_t(s8, info->control.rates[i].idx,
> 				      sdata->max_ratectrl_rateidx);
> 	}
>=20
> 	BUG_ON(info->control.rates[0].idx < 0);
> }

I think I'm in favour of "downgrading" that to a WARN_ON, like this:
	if (WARN_ON(...))
		info->control.rates[0].idx =3D rate_lowest()

johannes

--=-xKwyaleZVg1KqeJigkqO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJx+S4AAoJEKVg1VMiehFY5ZoP/jA1YZV1nmuWw1BHv0dUVq14
qWCIeHrtnicBG0rbXMQTr/B9QkpRES1tpj90d+UWN3HU5jvEdFmypwv4yFq+wXLF
4Kv8DZX98G4BWjOcOkODmsUTi9J5pBrMSvtthRImXmq5UpAF9o4YgddZ+yr4eaEa
4YKl7gGiBtxBUMkWs2MvLXNAZy3E0EISlnFdQ0tsAoKNVbwtuhw4IG6G0TFrysvJ
KUJRhof+JTvTdFI+RhuHlmdPV8uMYXdvh4wzd0RdTy9iKvOlOciKcXG0axX/Emx9
/3EiZ6J/0jKp7wwN4G07ExF0K4wJwFDoFdyy6dNEfVsOqpFzlNTc2irUmbxabodE
7y4j87Oz4QgOXTCNzRQaSZzvtbp6LPxvqchbzvN8nNJDS7g819JTGGi4iSWAvcFe
ucNrPGS95YSrFha3BaXhQHj1bZtbiyODoxuFKLfZJsfiOitDYZsmNTUt2z3Ma3kf
WPcMjESmN4GU4LCFCGnrBZM/aPsYlyLTmeeafQtu1KaxC6XRuTUW+7AbJcc7Gce4
jVFKc3p823td0xS3l8IudABH7ZiRz1z5FdZayUwpK2t6p7wq6GDaxJvIAQ/Hc0bx
rl9KE19qBmqBH0FToEVPkYT/vLDZBXZ0bFipz8yXUEnEqmTB+MxyFMeIT/hpaEd6
opf9c6vsohbGBxnA9ZNs
=oeiB
-----END PGP SIGNATURE-----

--=-xKwyaleZVg1KqeJigkqO--


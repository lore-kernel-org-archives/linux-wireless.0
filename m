Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbYIIIUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 04:20:34 -0400
Subject: Re: HT action frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com> (sfid-20080909_101424_122343_0B1BD36D)
References: <1220883730.31304.60.camel@johannes.berg>
	 <48C5868B.8060103@w1.fi> <1220942004.31304.101.camel@johannes.berg>
	 <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com>
	 (sfid-20080909_101424_122343_0B1BD36D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3WLKoNX9iWwo/jm0KsPI"
Date: Tue, 09 Sep 2008 10:20:27 +0200
Message-Id: <1220948427.31304.107.camel@johannes.berg> (sfid-20080909_102039_326994_F0D81859)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3WLKoNX9iWwo/jm0KsPI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-09 at 11:14 +0300, Tomas Winkler wrote:

> >> The current design assumes that hostapd takes care of all management
> >> frames, so eyes, these would need to go to hostapd for processing and
> >> then setup back to mac80211 through some new command..
> >
> > Well we can always pick out those action frames in the kernel if we wan=
t
> > to, that's not the problem, is it?
>=20
> We've indeed has kept inside just BA session action frames.

Hmm? I don't think I understand what you're trying to say.

> > Should the design be changed? It seems that this is more related to the
> > rate scale algorithm and the "can we support aggregation for this STA"
> > question, both of which we currently have information about in the
> > kernel and not hostapd.
>=20
> The decision might come both from RS and hostapd. RS just have more
> info whether there will be gain from aggregation. When throughput is
> not high enough it's just an overhead. Though some APs open session
> immediately uppon association without and RS decision.
> Our design is that BA can be triggered not only for RS.

Well yeah, but I'm not sure we really want to add API to cfg80211 for
this. It's not exactly hard to, but right now I don't see how hostapd
would influence the decision.

Also, I'm not talking about the AP triggering the aggregation session,
this is entirely done with the rate scaling right now, but about an
associated STA wanting to start an aggregation session. Aren't
aggregation sessions always triggered by whoever wants to send? So if a
STA notices it has lots of upload going on it could want to trigger a BA
session, which is something we don't currently support afaict.

johannes

--=-3WLKoNX9iWwo/jm0KsPI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxjHHAAoJEKVg1VMiehFYM1QQAKZXENw58RQE8xzVtb6y4eAF
kjCm+uI87iaoenLgUIAAOfA0qtn+QvZ6beJD9c9bzStPdLjjy3mVYaRIardKd71Y
2RRSaSc81tWoj2YuWaiphUlaQef9cp9esXZoq9IU4rx3kK7w+iGM7iMnjta0ryN1
z8ulyCvWP/cNiciwhpYNC1VVc71gITfcatBzC493/HPHyGBl155q70S9h15D4RVW
X/dkc9UXLYzY2tluEHbMpCNgEfG+XUEjdvtm9Ga3OpNk9YJxnMO9RfTNgvRW+VMY
jmdxhbE5TCrEDzkrKyYOHkpII7Z7eYaSBKxHAsAed7UW/wKV9BPleQyYF1ZZzw5Y
pjrXnqdKzqVEKTZoITcO3LBl/KeqYroD3e1qlfl13ZUNifVzDuxlRGzQBHf6FJcH
niR6dhG+iFbo82nG7vS0B27houovhrmBGsAp97TSBNI7dK+AwrSUlnBLwRhlerM+
O7fjmDYfY/Az19GhDviGbFtPSx5dd9eqUUV61ApO7rtzNc6Gg8wkkhfRoNtfejyW
Qa+XxAdQugAFFhznD6vkzuZMZdL2xkdfxGXJM7+NMNmXHg6zCI+JAP8ub8Pxq1Qq
ekoOF06fkWsILC3cvd84CsozO6Trt/KI07KKcg6u/qBboMkLsqNMQNLIjyENGJl7
sebsSYChxClWTCbGVNMb
=zq5b
-----END PGP SIGNATURE-----

--=-3WLKoNX9iWwo/jm0KsPI--


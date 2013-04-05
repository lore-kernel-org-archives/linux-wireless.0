Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:55046 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160994Ab3DEMQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 08:16:36 -0400
Date: Fri, 5 Apr 2013 14:16:30 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] mac80211: fix recalc_radar hwconf sync problem
Message-ID: <20130405121629.GB29188@pandem0nium> (sfid-20130405_141639_850605_6B16ABB5)
References: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1364993200.8351.35.camel@jlt4.sipsolutions.net>
 <515D8259.1030208@neratec.com>
 <20130404182219.GA24704@pandem0nium>
 <1365160971.8515.23.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
In-Reply-To: <1365160971.8515.23.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 05, 2013 at 01:22:51PM +0200, Johannes Berg wrote:
> On Thu, 2013-04-04 at 20:22 +0200, Simon Wunderlich wrote:
>=20
> > As far as I see, the problem happens when changing from a DFS to a non-=
DFS
> > channel. local->hw.conf.radar_enabled is true from the last (DFS) chann=
el,
> > but the channel gets released when stopping the AP, and the channel con=
text
> > is freed.=20
>=20
> At this point, why doesn't it disable hw.conf.radar_enabled? I really
> think it should?

As far as I see release_channel() -> unassign_vif_chanctx() -> ieee80211_re=
calc_radar_chanctx()
is called while the interface with radar enabled is still present, and ther=
efore it is assumed
that the radar enable is still required.

We could reset local->hw.conf.radar_enabled ieee80211_free_chanctx() though=
, but IMHO the cleaner
way would be to properly initialize it when the the channel is used next ti=
me through
vif_use_channel().

Cheers,
	Simon

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlFewJ0ACgkQrzg/fFk7axb07wCg7w/oILM04vPdd1Zh/9JPOhx0
vjwAoPSX7ZozxrDLMvyqxlCPT/K9LWYX
=RtzT
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:51147 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab3DHLvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 07:51:19 -0400
Date: Mon, 8 Apr 2013 13:51:11 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] mac80211: fix recalc_radar hwconf sync problem
Message-ID: <20130408115111.GA15594@pandem0nium> (sfid-20130408_135123_691247_90D74DE6)
References: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1364993200.8351.35.camel@jlt4.sipsolutions.net>
 <515D8259.1030208@neratec.com>
 <20130404182219.GA24704@pandem0nium>
 <1365160971.8515.23.camel@jlt4.sipsolutions.net>
 <20130405121629.GB29188@pandem0nium>
 <1365165364.8515.24.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
In-Reply-To: <1365165364.8515.24.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 05, 2013 at 02:36:04PM +0200, Johannes Berg wrote:
> On Fri, 2013-04-05 at 14:16 +0200, Simon Wunderlich wrote:
> > On Fri, Apr 05, 2013 at 01:22:51PM +0200, Johannes Berg wrote:
> > > On Thu, 2013-04-04 at 20:22 +0200, Simon Wunderlich wrote:
> > >=20
> > > > As far as I see, the problem happens when changing from a DFS to a =
non-DFS
> > > > channel. local->hw.conf.radar_enabled is true from the last (DFS) c=
hannel,
> > > > but the channel gets released when stopping the AP, and the channel=
 context
> > > > is freed.=20
> > >=20
> > > At this point, why doesn't it disable hw.conf.radar_enabled? I really
> > > think it should?
> >=20
> > As far as I see release_channel() -> unassign_vif_chanctx() -> ieee8021=
1_recalc_radar_chanctx()
> > is called while the interface with radar enabled is still present, and =
therefore it is assumed
> > that the radar enable is still required.
> >=20
> > We could reset local->hw.conf.radar_enabled ieee80211_free_chanctx() th=
ough, but IMHO the cleaner
> > way would be to properly initialize it when the the channel is used nex=
t time through
> > vif_use_channel().
>=20
> I disagree, it would leave the hardware in a weird state -- idle but
> having to detect radars??
>=20
> johannes

Well, you have a point ...

I'll look into it, it should be doable that the radar flag is always set
correctly. Please drop this patch for now.

Cheers,
	Simon

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlFiry8ACgkQrzg/fFk7axbZDACfWXcB4fJuD96oPKZkiaofPFfR
xU0An0IiHtmlSnyPEV6/1RbZIaFx8vAK
=West
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--

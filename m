Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:36308 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3A3Q4q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 11:56:46 -0500
Date: Wed, 30 Jan 2013 17:56:36 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Luciano Coelho <coelho@ti.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	victorg@ti.com, linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	igalc@ti.com, nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 2/6] cfg80211: check radar interface combinations
Message-ID: <20130130165636.GA27636@pandem0nium> (sfid-20130130_175650_795976_B776DBA7)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357650251-17425-3-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1359563688.14894.54.camel@cumari.coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
In-Reply-To: <1359563688.14894.54.camel@cumari.coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Luca,

On Wed, Jan 30, 2013 at 06:34:48PM +0200, Luciano Coelho wrote:
> [...]
>
> > @@ -1195,14 +1196,36 @@ int cfg80211_can_use_iftype_chan(struct cfg8021=
1_registered_device *rdev,
> >  	enum cfg80211_chan_mode chmode;
> >  	int num_different_channels =3D 0;
> >  	int total =3D 1;
> > +	bool radar_required;
> >  	int i, j;
> > =20
> >  	ASSERT_RTNL();
> >  	lockdep_assert_held(&rdev->devlist_mtx);
> > =20
> > +	if (WARN_ON(hweight32(radar_detect) > 1))
> > +		return -EINVAL;
> > +
> > +	switch (iftype) {
> > +	case NL80211_IFTYPE_ADHOC:
> > +	case NL80211_IFTYPE_AP:
> > +	case NL80211_IFTYPE_AP_VLAN:
> > +	case NL80211_IFTYPE_MESH_POINT:
> > +	case NL80211_IFTYPE_P2P_GO:
> > +		radar_required =3D !!(chan->flags & IEEE80211_CHAN_RADAR);
> > +		break;
>=20
> This code is causing an oops with the wl18xx driver in AP mode.  The
> problem is that cfg80211_can_change_interface() calls
> cfg80211_can_use_iftype_chan() with chan =3D=3D NULL.  This code doesn't
> check if chan is NULL, so this dereference causes the oops.

Sorry about that - I believe you've found the same bug I've posted a patch
for a few days ago. Johannes already has this in mac80211-next, but it is
not yet in wireless-testing:

http://article.gmane.org/gmane.linux.kernel.wireless.general/102836/match=
=3Dsimon
http://git.kernel.org/?p=3Dlinux/kernel/git/jberg/mac80211-next.git;a=3Dcom=
mit;h=3D683d41ae6755e6ae297ec09603c229795ab9566e

>=20
> I don't have the time right now to fix this, but I'll look into it
> tomorrow (unless someone comes with a fix before that :P).

Please have a look at the patch posted above (both links for the same patch=
).

Cheers,
	Simon

> [...]=20

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEJUMQACgkQrzg/fFk7axa0EQCfZoxxH+b8Pfu4JcVZC+uWg0Et
VeEAn0YJOZlFhdFtpeVMHBIfjGxGSw4H
=CM6/
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--

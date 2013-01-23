Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:39877 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3AWMmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 07:42:50 -0500
Date: Wed, 23 Jan 2013 13:42:36 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 4/6] mac80211: add radar detection command/event
Message-ID: <20130123124236.GA23989@pandem0nium> (sfid-20130123_134254_665457_3E45478A)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357650251-17425-5-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1358377171.15012.45.camel@jlt4.sipsolutions.net>
 <20130117135228.GD19552@pandem0nium>
 <1358546411.7922.41.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
In-Reply-To: <1358546411.7922.41.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 18, 2013 at 11:00:11PM +0100, Johannes Berg wrote:
> On Thu, 2013-01-17 at 14:52 +0100, Simon Wunderlich wrote:
>=20
> > > > +	res =3D drv_start_radar_detection(local, sdata, chandef);
> > >=20
> > > If the vif is assigned the channel, why also pass it to the
> > > start_radar_detection command? That seems pointless, they can't be
> > > different?
> > >=20
> > In the initial phase, __nl80211_set_channel() should not be able to set
> > the channel (no CAC yet), and will fail for IBSS (to be implemented lat=
er)
> > generally, at least as it's implemented now.
> >=20
> > But what we can do is set the channel from mac80211 and call the driver
> > function without the channel argument, as it'll be pointless in this ca=
se.
> > Is this what you mean?
>=20
> Hmm. Why are you talking about __nl80211_set_channel() now? We're now
> talking about mac80211, which can and does set the channel (chanctx,
> which may fall back to drv_config()) before calling
> drv_start_radar_detection(), so I think the latter needs no chandef
> argument?
>=20

Sorry, I was confused at the point, you are right nl80211_set_channel() has
nothing to do with that. ieee80211_vif_use_channel() already sets the chann=
el
implicitly (e.g. through ieee80211_hw_config()).

> > > Actually that raises another question: If we have "external" radar
> > > detection, say by a different NIC, then shouldn't we still ask the
> > > driver to start radar detection when using the channel? Or is that
> > > implicit, does the driver have to check?
> >=20
> > That is a good question, I didn't consider that. In the "simple process"
> > we first start radar detection and start the ap on the same channel.
> > For external CAC that won't work, of course. What about mac80211 checki=
ng
> > the channel in start_ap(), and if the channel requires DFS, pass some f=
lag
> > to the driver that radar detection should be enabled?
>=20
> Yes, that makes sense. But then it would also make sense to remove the
> start_radar_detection() callback entirely, and encode all that
> information in the channel context/drv_config call?
>=20
> If mac80211 gets to be responsible for it, this should totally be
> documented in the cfg80211 API though so if a full-mac driver wants to
> implement it they know what to do. I do think this is the reasonable way
> of doing it though.
>=20
> Note that I'm not advocating removing the start_radar_detection() or its
> chandef from the *cfg80211* API. That is clearly needed. But in mac80211
> it seems "set this chandef with radar detection" is a better API?
>=20

OK, so we keep the cfg80211 start_radar_detection() and replace the mac80211
part with respective information that radar is required. That could work,
I'll look into this.

Thanks,
	Simon

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD/2rwACgkQrzg/fFk7axavCgCguiuv2k0bKz9FfHSWFqMuPBrO
QtUAoOVpsiGWVHPOadgA3ERK6oK++f+7
=fJ1q
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--

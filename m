Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:24817 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2J2Jea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 05:34:30 -0400
Date: Mon, 29 Oct 2012 10:33:54 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv3 2/2] mac80211: implement set_mcast_rate() callback
Message-ID: <20121029093354.GC5944@ritirata.org> (sfid-20121029_103433_935319_09D914C1)
References: <1351267055-21927-1-git-send-email-ordex@autistici.org>
 <1351267055-21927-2-git-send-email-ordex@autistici.org>
 <1351502110.10925.10.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
In-Reply-To: <1351502110.10925.10.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 29, 2012 at 10:15:10AM +0100, Johannes Berg wrote:
> On Fri, 2012-10-26 at 17:57 +0200, Antonio Quartulli wrote:
> > The callback can be used with vif configured as
> > ADHOC or MESH_POINT only.
>=20
> You said the same in the cfg80211 patch, so
>=20
> > +int ieee80211_mcast_rate(struct ieee80211_sub_if_data *sdata,
> > +			 int rate[IEEE80211_NUM_BANDS])
> > +{
> > +	if (sdata->vif.type !=3D NL80211_IFTYPE_ADHOC &&
> > +	    sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> > +		return -EOPNOTSUPP;
>=20
> should that check be in cfg80211?

Ok, will change that.

>=20
> OTOH, it seems it might be valid in AP mode as well?

as we discussed on IRC, the AP has no real mcast_rate parameter since it se=
ems
to be chosen from the basic rates every time. How ever this would be an
interesting feature. Maybe we can add this later after this API change.

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCOTYIACgkQpGgxIkP9cwft3ACgiyPBUmy700pUpYemDVdHjPSC
DyYAoJv4URbDWoiuDA/bUKk7r8Bdq7Zu
=PYLn
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:41467 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3AQN2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 08:28:11 -0500
Date: Thu, 17 Jan 2013 14:27:56 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 1/6] nl80211: check if channel can be used in
 join_ibss
Message-ID: <20130117132755.GA19552@pandem0nium> (sfid-20130117_142815_407389_6CFA8C07)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357650251-17425-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1358375759.15012.30.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
In-Reply-To: <1358375759.15012.30.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 16, 2013 at 11:35:59PM +0100, Johannes Berg wrote:
> On Tue, 2013-01-08 at 14:04 +0100, Simon Wunderlich wrote:
> > IBSS should also consider interface combinations.
> >=20
> > Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> > ---
> >  net/wireless/nl80211.c |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >=20
> > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> > index 9bd8340..62e98f5 100644
> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -5463,6 +5463,7 @@ static int nl80211_join_ibss(struct sk_buff *skb,=
 struct genl_info *info)
> >  {
> >  	struct cfg80211_registered_device *rdev =3D info->user_ptr[0];
> >  	struct net_device *dev =3D info->user_ptr[1];
> > +	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
> >  	struct cfg80211_ibss_params ibss;
> >  	struct wiphy *wiphy;
> >  	struct cfg80211_cached_keys *connkeys =3D NULL;
> > @@ -5524,6 +5525,15 @@ static int nl80211_join_ibss(struct sk_buff *skb=
, struct genl_info *info)
> >  	ibss.channel_fixed =3D !!info->attrs[NL80211_ATTR_FREQ_FIXED];
> >  	ibss.privacy =3D !!info->attrs[NL80211_ATTR_PRIVACY];
> > =20
> > +	mutex_lock(&rdev->devlist_mtx);
> > +	err =3D cfg80211_can_use_chan(rdev, wdev, ibss.chandef.chan,
> > +				    ibss.channel_fixed ? CHAN_MODE_SHARED :
> > +							 CHAN_MODE_EXCLUSIVE);
> > +	mutex_unlock(&rdev->devlist_mtx);
> > +
> > +	if (err)
> > +		return -EINVAL;
> > +
>=20
> This is already in __cfg80211_join_ibss()

Whoops, missed that, sorry. Then we can skip this patch.

Cheers,
	Simon

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD3/FsACgkQrzg/fFk7axbdkACggoYcMpIua2Us73WH6HMPWCje
Z6MAoLHbRu1u0JjsSY2DW/PBuynLUDPm
=hcfe
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--

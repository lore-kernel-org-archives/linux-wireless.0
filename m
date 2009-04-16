Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbZDPQEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 12:04:33 -0400
Subject: Re: [PATCH] mac80211: Allow scan to be requested in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090416160056.GA7912@jm.kir.nu>
References: <20090416154453.GA7311@jm.kir.nu>
	 <1239897117.14169.8.camel@johannes.local> <20090416160056.GA7912@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tGvcwyZxDX2HxW3g8jAW"
Date: Thu, 16 Apr 2009 18:03:59 +0200
Message-Id: <1239897839.14169.17.camel@johannes.local> (sfid-20090416_180436_501955_3CA8D608)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tGvcwyZxDX2HxW3g8jAW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 19:00 +0300, Jouni Malinen wrote:
> On Thu, Apr 16, 2009 at 05:51:57PM +0200, Johannes Berg wrote:
> > On Thu, 2009-04-16 at 18:44 +0300, Jouni Malinen wrote:
> > > --- uml.orig/net/mac80211/cfg.c	2009-04-16 18:20:19.000000000 +0300
> > > +++ uml/net/mac80211/cfg.c	2009-04-16 18:33:44.000000000 +0300
> > > @@ -1167,7 +1167,8 @@ static int ieee80211_scan(struct wiphy *
> > > =20
> > >  	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION &&
> > >  	    sdata->vif.type !=3D NL80211_IFTYPE_ADHOC &&
> > > -	    sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
> > > +	    sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT &&
> > > +	    (sdata->vif.type !=3D NL80211_IFTYPE_AP || sdata->u.ap.beacon))
> > >  		return -EOPNOTSUPP;
> >=20
> > Should this return a different error code for AP then? Maybe -EBUSY for
> > AP && beacon? Then again, EBUSY is already returned for "already
> > scanning". hmm.
>=20
> I thought about that for a moment, but did not come up with a good error
> code.. ;-)  EBUSY is not a good option here since that could be used by
> applications to decide that they should try again (which would not help
> here at all). If someone has a better one in mind, I would have no
> problems changing this, but I don't see much problems with EOPNOTSUPP
> either.

Ok. Good enough for me :)

johannes

--=-tGvcwyZxDX2HxW3g8jAW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ51bsAAoJEKVg1VMiehFYJYYQAKL9etZlmzkzLT4teQeHgN39
+D4TNmP1DHVn5AKxJvyQc9fa2tVLz1tH1HFq/TIsxVnS28wDoHIdQcFl/wDACGDe
2kIy8WdWnve4cZxs8tG4VphU9aYq9frSOECsZ74KVvYYokQa+rbsnz9OkDkoeINw
FRYg6iCsBRLqQNx2PAyL7fGmwmDM2F8Vmzzs1DOBBzudSCFjYAHt5rZ4PsBOTf/f
P1BdSl1EY7A+BGaSh9uV6hIlnicLyBpunOOlEIaCAevLjoOulRmbpenOoHQeyzXL
KQks4zQRxWj7LhWnVXU714ZmLbv9IZSMjk6shofoC0VrBdccEdAm7CFYKJ+H+LV+
ubACgBSg3bsH85O9JlKdMbGKHuzPK3sw81VA7VHkSQSqJBG2VY/2m0f6fX0cleuU
rH03tZujFEWO7BURL2ekn2AuvoBqeHc1bBk/eWSfWq61/bq95XmjtUV+dwBJKacw
GGm+Dh1EYz4QKDkfcfZSfGuHUk/CB9jMr0UU7J3AZSCTYo9v1wgDBQnkYr1s3GBd
NOjHYKeu9rKxhCnZGotGLI+w9vbhvAiemldVQq5H9vhaiAc65U9NcDsmipfki3Og
Lg0ZCL4ppcuk5Xo5KuBBmSdMbm/B5MD4dGJQ3w8LgjHx2hwNxTMV1D9oLlJ8g20Z
EheayNX7oqRjIGPZK8NX
=Dmzj
-----END PGP SIGNATURE-----

--=-tGvcwyZxDX2HxW3g8jAW--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbYIKAKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 20:10:11 -0400
Subject: Re: [PATCH 16/18] mac80211 hwsim: verify vif pointers
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20080911000630.GC20358@tesla>
References: <20080910220145.707263000@sipsolutions.net>
	 <20080910220426.564761000@sipsolutions.net>  <20080911000630.GC20358@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6QUhHDGJx0vL2BcCbxdn"
Date: Thu, 11 Sep 2008 02:09:33 +0200
Message-Id: <1221091773.3804.60.camel@johannes.berg> (sfid-20080911_021018_173547_51FE380B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6QUhHDGJx0vL2BcCbxdn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-10 at 17:06 -0700, Luis R. Rodriguez wrote:
> On Wed, Sep 10, 2008 at 03:02:01PM -0700, Johannes Berg wrote:
> > --- everything.orig/drivers/net/wireless/mac80211_hwsim.c       2008-09=
-10 23:58:05.000000000 +0200
> > +++ everything/drivers/net/wireless/mac80211_hwsim.c    2008-09-10 23:5=
8:11.000000000 +0200
> > @@ -28,6 +28,29 @@ static int radios =3D 2;
> >  module_param(radios, int, 0444);
> >  MODULE_PARM_DESC(radios, "Number of simulated radios");
> >=20
> > +struct hwsim_vif_priv {
> > +       u32 magic;
> > +};
> > +
> > +#define HWSIM_VIF_MAGIC        0x69537748
> > +
> > +static inline void hwsim_check_magic(struct ieee80211_vif *vif)
> > +{
> > +       struct hwsim_vif_priv *vp =3D (void *)vif->drv_priv;
> > +       BUG_ON(vp->magic !=3D HWSIM_VIF_MAGIC);
>=20
> If its a debugging tool then better WARN_ON instead no?

I don't know, yeah, maybe. I can change it.

johannes

--=-6QUhHDGJx0vL2BcCbxdn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyGG5AAoJEKVg1VMiehFYeiUP/2ZLCUIhMLNXtRvq/6aWmeop
OVJv1sH6AAkXc6sD5dK2wqag+cCbrRxE0kCEuHia7JrAIiQm4y9V4n/EPgIoykH9
cy4Likpu2oz0yN9oA8X33V24wb3Nfajl5RZ7mbuw3pKVK2+qWvvaPDZDtyfKAxUE
+9B0WxXxjdNBuUVkD0HhmBj5MA32/El6vzZUPRNMJRShoExsRouryhARmaQx0dQc
s6in3cGTw1QYLvk33Do33pJ7Ru3b3xf8tIxfzDCI9j1qQO3hnXeyBXo20hxUKtcG
9m6xW1TsDMACT0XUvZDYPz7pHtcjzLFIxTfJbH1SbdrsVaDyhBaLNy/xs2zGyvNO
HjS0XJiIxFozEw5AzscTDy8OeOB+Bsj2PFQaJmRsvWU99er45v9QfyuFzwqeLuXD
jBOSckvrw1K5tVPwR3o3ZCnwiiiAjJsS/UGUbUJHvVhCQyvYhS3LGehE65ZRrhLw
L87AweWkI+xWEERvmOfAb6v8QB21BikI53zBPqjHUVqB85cGWPBKdmwVtQ3Owb4U
yhl2fvXL3TYkYwdmINx38WGbVLHGwT/tDz72tYOCzmp7QeFYE7zogkxJOmKHbPdZ
/D2fa2Z1ekSS0gk+4RvKO4N7XSavkU6M5xg/UH+AzuFET4ahvIWfZ3UL36r5+XLS
3Ve2wdYbT9TCXyHxaMaT
=GDv3
-----END PGP SIGNATURE-----

--=-6QUhHDGJx0vL2BcCbxdn--


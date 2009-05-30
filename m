Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40614 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbZE3VEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 17:04:47 -0400
Subject: Re: commit #1868cf308a3b3a336fcfe52c5aea4ac12d5e42ac breaks
 wireless on my system
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A219E78.5070009@lwfinger.net>
References: <1243716437.26585.4.camel@maxim-laptop>
	 <4A219E78.5070009@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-a04uT2OCYuCduWZ6P+1H"
Date: Sat, 30 May 2009 23:04:31 +0200
Message-Id: <1243717471.19302.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-a04uT2OCYuCduWZ6P+1H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-30 at 16:00 -0500, Larry Finger wrote:

> From the above patch, this hunk looks a little strange:
>=20
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index c143947..a01154e 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -37,12 +37,13 @@ static int ieee80211_ioctl_siwgenie(struct
> net_device *dev,
>=20
>         if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
>                 int ret =3D ieee80211_sta_set_extra_ie(sdata, extra, data=
->length);
> -               if (ret)
> +               if (ret && ret !=3D -EALREADY)
>                         return ret;
>                 sdata->u.mgd.flags &=3D ~IEEE80211_STA_AUTO_BSSID_SEL;
>                 sdata->u.mgd.flags &=3D ~IEEE80211_STA_EXT_SME;
>                 sdata->u.mgd.flags &=3D ~IEEE80211_STA_CONTROL_PORT;
> -               ieee80211_sta_req_auth(sdata);
> +               if (ret !=3D -EALREADY)
> +                       ieee80211_sta_req_auth(sdata);
>                 return 0;
>         }
>=20
> Why is there a check before the call to ieee80211_sta_req_auth()? If
> ret !=3D -EALREADY, would we not have already exited?

No, it's && deliberately, I don't want to show -EALREADY to userspace,
but I _do_ want to skip the req_auth() step, that's the whole purpose of
the patch. Problem is I forgot to change the cfg80211 handlers
accordingly and that created a problem Luis fixed.

johannes

--=-a04uT2OCYuCduWZ6P+1H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKIZ9XAAoJEODzc/N7+QmaGr0P/2U6etdteKgnFcIEDeAONcSe
SzpX547lQiIZG0eZ8VZLZnqkNX0M5WnEh0bJ5JLGEWOw8WEhqHQMlXMIxW9FXQUw
JKXbmOh7iAqhxVZZkUll0RuNQUuGL8P3+nlNzrx7NhlaBJ/WotImDCYneLbqvXFK
tfU7bICmm1sOvXRcjh9i9FblpM0HdbrG5Cwl0wMUnzNkJSedjBNQ701ov3tY3iY4
g7/PuIJsZF1FKIzziFLP8tto0fE9V4NF3oGXt0kYY4v1tV3LUGdNxiRSvIrENeji
2ZOwpFShjc9KewLxA0lUdArLXI0yHakGfajaxOUyyf8/GGLAKHbzBmb2aSo8lu4a
SQANdKyqxzofJE84jfiw+iTJcjFz+QZvOj19iHJSPwOn0qSIFeHiF4cRfhFl2ZC/
S6cZ0Ii4aKysIlqcfpyxch3S7Fww9hKX2hVzrjfIxCDZltPymcKL+h45eoYi3UFe
9TxrFH2FJNMx5dB0x60G/zixtTLwFEMq1KTmT0cku/8tjXFxzggU0eMO5PKY9BBe
WYARwKdQuTTebY8QIwBjM58bsB6gFnX9K6DTPDM9FD86DSyitKx/B5PnXGG48CAg
ng3mMgNeMSaLjBekhJkoMtAhjT/QzdHl2d2YRQY07mhcB5F0ZlI2AdAtIB04kmBW
mnXbSjubP2hAbkEHtAMQ
=AC4t
-----END PGP SIGNATURE-----

--=-a04uT2OCYuCduWZ6P+1H--


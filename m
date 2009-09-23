Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZIWHCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 03:02:05 -0400
Subject: Re: BUGLET? cfg80211: .dumpit methods called twice
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200909220933.24443.hs4233@mail.mn-solutions.de>
References: <200909220933.24443.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iY9R2yTd8zUnXHx3Bjmo"
Date: Wed, 23 Sep 2009 09:02:06 +0200
Message-Id: <1253689326.4458.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iY9R2yTd8zUnXHx3Bjmo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-22 at 09:33 +0200, Holger Schurig wrote:
> I just noticed that all functions mentioned on .dumpit in=20
> net/wireless/nl80211.c are actually called twice.
>=20
> For example, I've added
>=20
> --- linux-wl.orig/net/wireless/nl80211.c        2009-09-18=20
> 14:44:28.000000000 +0200
> +++ linux-wl/net/wireless/nl80211.c     2009-09-18=20
> 14:45:41.000000000 +0200
> @@ -2919,6 +2919,8 @@ static int nl80211_trigger_scan(struct s
>         enum ieee80211_band band;
>         size_t ie_len;
>=20
> +       printk("##HS %s:%d\n", __func__, __LINE__);
> +
>         if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
>                 return -EINVAL;
>=20
> and when I now issue one "iw eth1 scan dump" I get two logs of=20
> this printk in my dmesg.
>=20
> AFAIK it doesn't cause any harm, but it's not that efficient and=20
> it might cause harm in the future if any of the .dumpit methods=20
> has the "right" side-effects.

Umm, that's expected since dumpit() effectively runs until it returns no
more data.

johannes

--=-iY9R2yTd8zUnXHx3Bjmo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKucfrAAoJEODzc/N7+QmajOEP/3kU+mWuL9VHfsG3yf8FJvvB
0mKA57bdtwpLU06mpXVc7Y6FG5naLjkBBzmrYwLrzmOM4BM/BDlH2I2yy4cCVqKM
8tYYKAT/rd2ehv6+Qmm1xhKkxKRbHSKJa1W3KzTyyCOe3mNBypigszqWQ++S9VqD
pJJcGlyui4DvFDn7Hra2nSN2bJWj1vltFi7QsGfx4HfLBweSCwIHtpLSzL7e208O
RoVY5GN9UX6AWtCkw0Inr7mCPUESa+z7wgq4jbAy9elbkEXK2eOSWmygKj2QmesF
dhI9PoDWRRteAApYF/nCUyWDkEvWAmzZ8DRI88xmpA8CLJ9ODO0eNBuGajGrIqmw
8gperSL/mYsvlYpiytacVxBQuVYKlI6BxcDDgOYAvdY+pBIU/Nn6MlFqBCfSKZx+
ETazl43QGZIOC5jrLWL+/RQm6Mnr6YaOeq4dM95igzGRar532vVbv4m78dsDW/au
XC48MM+c2AKnhsoyToWINYd9kcBImgNSaU7jtDgio0HHMFK9NmtSenpaddZIH7nZ
j3ryaZzS5154m2jaZBHO+f4HbMh2pZx239TdxVa6ESmAXy4/CcSsj31RdBNao7DX
iKDHiruov+DjbvyxdCK5C6imH/Ub4fb6aFHVaSVf8rUTTL18nj0JtFZlmio/wZdM
gQpKVzHzWDdLyWZxlsHo
=X0QY
-----END PGP SIGNATURE-----

--=-iY9R2yTd8zUnXHx3Bjmo--


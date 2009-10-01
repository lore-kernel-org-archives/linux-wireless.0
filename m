Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbZJAIvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 04:51:01 -0400
Subject: Re: [PATCH 1/3] wireless: implement basic ethtool support for
 cfg80211 devices
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kalle.valo@nokia.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1254359942-3483-1-git-send-email-linville@tuxdriver.com>
References: <20091001011340.GA3123@tuxdriver.com>
	 <1254359942-3483-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vBBkHIzINJzjx+NTiayw"
Date: Thu, 01 Oct 2009 10:51:01 +0200
Message-Id: <1254387061.3959.20.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vBBkHIzINJzjx+NTiayw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-09-30 at 21:19 -0400, John W. Linville wrote:

> +		if (!dev->ethtool_ops)
> +			dev->ethtool_ops =3D &cfg80211_ethtool_ops;
>  		break;

I might go so far and do it unconditionally so we get consistent
functionality across things. OTOH, full-mac drivers might be able to
support more.

> +const struct ethtool_ops cfg80211_ethtool_ops =3D {
> +	.get_drvinfo =3D cfg80211_get_drvinfo,
> +	.get_link =3D ethtool_op_get_link,
> +};
> +
> +void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo=
 *info)

if you change the order, you can make the latter static

johannes

--=-vBBkHIzINJzjx+NTiayw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKxG1yAAoJEODzc/N7+Qma++QQAKBADLlBUGKpLXFy9saCXG/O
QqbExhEC2Hm+wPAfoMnL7RD0o7ENO5u7qQ6iB5JxAuIaCy0rTBJ0wCwhGEXqpEHj
WcyI8PJxkxM0W6r58DFz/NoPxfQnMTE7G64I8NdUYz2F1lI0xL48D9a1htKJeTaF
U+3ZhI3ujukaMWFkgoOvkqj2jOPsT91PygY8z50EKeVAINcakVUMSaDhYj6LrRbG
H6c5Gm3a443P2bcDuTxouhKpalHK9DUHF44Slbnv5b1W+EYqfj0i0cYPY7SILD4W
3BZhtGMrAcBXYlFRXGzZyeDcbOqAREQcaJxaBdDQukwem7OR324TfxExxbDKaY9V
f9k0Xy6HwlBIZbw+E6Fw0aNmbb/OcCYhyJkXX/O3wrD6uXFD7Hato1VZwJn0p2Rx
3F9xRkC8gYYDijrV2O7FA/mkl4x1UyJq7CbiSE5d/2O8ISDs8HS2wvCA4qzGABJl
Ks1sYOWAYZEhjNBoWo9zT4qGDJ2hySvneiyEKVv5bgh+hJ3CSIH+tDsE8Bb8rfqe
E014+w8FBdOQtnUev+KmLGvRNImqcg9GoMhCjukWI66oD+NaKM74CSypOzPGcznY
BDvG5LeBCGOsNU1hK3veFqQMOhGxJH3mPeX6yfRTGfa1gcQ50fVfh0jjAcXAbOxo
Aa02zMRBpTArqw+FUMmP
=YTch
-----END PGP SIGNATURE-----

--=-vBBkHIzINJzjx+NTiayw--


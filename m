Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbZDAOf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 10:35:26 -0400
Subject: Re: [PATCH] mac80211: Report rejected association to user space SME
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090401142354.GA8695@jm.kir.nu>
References: <20090401142354.GA8695@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OyQ22nYeYqZCAAA7F6Sb"
Date: Wed, 01 Apr 2009 16:34:48 +0200
Message-Id: <1238596488.4492.0.camel@johannes.local> (sfid-20090401_163529_698509_EAA768E5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OyQ22nYeYqZCAAA7F6Sb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-01 at 17:23 +0300, Jouni Malinen wrote:
> When using nl80211 association, we need to send association response
> with a failure code to user space SME instead of just internally
> trying to send out the same (re)association request again couple of
> times. This fixes problems in association process getting stuck on a
> failure when user space is not notified in any way that something
> actually failed.

Indeed.

> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mlme.c |    5 +++++
>  1 file changed, 5 insertions(+)
>=20
> --- uml.orig/net/mac80211/mlme.c	2009-04-01 17:20:11.000000000 +0300
> +++ uml/net/mac80211/mlme.c	2009-04-01 17:21:15.000000000 +0300
> @@ -1363,6 +1363,11 @@ static void ieee80211_rx_mgmt_assoc_resp
>  		 * association next time. This works around some broken APs
>  		 * which do not correctly reject reassociation requests. */
>  		ifmgd->flags &=3D ~IEEE80211_STA_PREV_BSSID_SET;
> +		cfg80211_send_rx_assoc(sdata->dev, (u8 *) mgmt, len);
> +		if (ifmgd->flags & IEEE80211_STA_EXT_SME) {
> +			/* Wait for SME to decide what to do next */
> +			ifmgd->state =3D IEEE80211_STA_MLME_DISABLED;
> +		}
>  		return;
>  	}
> =20
>=20

--=-OyQ22nYeYqZCAAA7F6Sb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ03uFAAoJEKVg1VMiehFYH60QAJ4zrE4w+PP058VlSEumRUHx
5+/eMRMAjqC7wvLeGyknoUUA6KIAVIplfCPhj25CYrJiCG2QXNDopXvdyhGfoXTf
0ouXcFig4w/JUG7JC+CHCfGw6WNjLvFGf5qHcW55NZ1dbQv7BT8+jGkd3WwqK9w0
jKv3sppg9is7aP7ED4tg2ofjUOb3g7+ZLdALqMlqqIVNvnfyGLapJSqwNogs5Gv3
QOr7C8HsF3sZhOZpOqBpjJ95cH9ef+bqrHN4fvDRpbaTuZK/I+bu6GRris+Dd9rS
B9aeyceu0F/tdpDwCdBkOHTyhvXK/WwsNramAE3kUaQJfKcKtzB5nXeKtaDJomxo
37YOtcLrjwr0XCQoXfy+BpfBCNcOHfF/SOBDLyraHwivtKxmPttmY4p6QEIZK9uO
jP4ntwivZfSD9xjrnPJUuXx0pX+SGKjRx7ph7fbarUh5lSfKgBT2hfbXfN8DC1xu
WoeKIT3afp6lem3pqd5g+C6+ooxY7107A7N4vquaslX+1c2mwhtuNar5GaCFEZ4V
hCBDTNGgu9ntXkyYqGxW5paGXsBzjVPkdtn08rFR+iGQ1xt1Gj+Vedz3z5902ey0
3o+f6BD13SQwi2vY6OzMqgqnrdwElHFRfgcvrLszm57ncPBJ4iPd3xxe0mayygXC
JhiaP4A1NuCJCSjdAXdT
=TnsS
-----END PGP SIGNATURE-----

--=-OyQ22nYeYqZCAAA7F6Sb--


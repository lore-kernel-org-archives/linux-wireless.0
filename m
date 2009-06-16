Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbZFPXrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 19:47:25 -0400
Subject: Re: [PATCH] mac80211: Successfully set master mode and get/set
 ESSID in master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: James Le Cuirot <chewi@aura-online.co.uk>
Cc: "John W.Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090617004435.3801930f@symphony>
References: <20090617004435.3801930f@symphony>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eQDVRJ/IOEkDe4vpUuH/"
Date: Wed, 17 Jun 2009 01:46:57 +0200
Message-Id: <1245196017.21287.75.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eQDVRJ/IOEkDe4vpUuH/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-17 at 00:44 +0100, James Le Cuirot wrote:
> This allows wext-based drivers to successfully put the adapter into maste=
r
> mode and get/set the ESSID while in master mode. I'm not sure why this
> code was not already present but the "Invalid argument" error I was
> getting has now gone and getting/setting the ESSID afterwards now
> works. Hopefully this helps and I haven't misunderstood something. This
> patch is against the wireless-testing branch. Admittedly, I haven't
> actually tested it against this branch but I've made identical changes
> to 2.6.30 and that's working fine. For the record, I'm using a p54usb
> adapter.

NACK.
http://wireless.kernel.org/RTFM-AP

johannes

> Signed-off-by: James Le Cuirot <chewi@aura-online.co.uk>
>=20
> ---
>=20
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 1da81f4..e8d5cee 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -131,7 +131,8 @@ static int ieee80211_ioctl_siwessid(struct net_device=
 *dev,
>         size_t len =3D data->length;
>         int ret;
> =20
> -       if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC)
> +       if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC ||
> +           sdata->vif.type =3D=3D NL80211_IFTYPE_AP)
>                 return cfg80211_ibss_wext_siwessid(dev, info, data, ssid)=
;
> =20
>         /* iwconfig uses nul termination in SSID.. */
> @@ -167,7 +168,8 @@ static int ieee80211_ioctl_giwessid(struct net_device=
 *dev,
> =20
>         sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> -       if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC)
> +       if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC ||
> +           sdata->vif.type =3D=3D NL80211_IFTYPE_AP)
>                 return cfg80211_ibss_wext_giwessid(dev, info, data, ssid)=
;
> =20
>         if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
> diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
> index d030c53..5c1f215 100644
> --- a/net/wireless/wext-compat.c
> +++ b/net/wireless/wext-compat.c
> @@ -82,6 +82,9 @@ int cfg80211_wext_siwmode(struct net_device *dev, struc=
t iw_request_info *info,
>                 return -EOPNOTSUPP;
> =20
>         switch (*mode) {
> +       case IW_MODE_MASTER:
> +               type =3D NL80211_IFTYPE_AP;
> +               break;
>         case IW_MODE_INFRA:
>                 type =3D NL80211_IFTYPE_STATION;
>                 break;
>=20

--=-eQDVRJ/IOEkDe4vpUuH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKOC7uAAoJEODzc/N7+QmavkUQALi/H0AyrpOoZAtQ1yoEbiWa
Q1cxtMEMmhg9g4X+i/NG1NeCedhuyf5P+kMWYu1Sgk1BaDGB2aRqpwYyu1KHUSEu
WpvcsvXGEuDZWFdF5vXITjspkaQbUIBUgP++WWnl3ADf6O6wg6kKZbfHZqM9Uzh1
6Kltgko23FgY25b6Zo7fagLI7bVGeJabU5/p9jXDcdJ7M3AEWboT8CECceCtj0CN
tMGsOgvH+QDyoZ6Eq9YY6KgH/RhZDvRwDp2XG3qDEP/YfHPsfKgy5em9ZDXkyYXx
wApYEt8HQwG96W01BRBMCCWHFcT618kF8GVfQMfPjRh15vb+5ERkPdAbWVIatQhx
xg8p81F1GCP1llyfzVbdYttJUG+ZhuRzr4CH6J2i4zEhXnMX7g0kYu3HmTlH4oAf
kcz0Uj1UsD6Z9LAfOXO8Nrwkxh2vb2NNqZV9x5uTXSxIjcMr0lKjaK+aEditmYWl
jeDmC2OBa/9Xqimy2JIQhqO4j9o9lBlot4GU5gHIeHY0JpHQYw2XXuJfHp0je9Z2
TC+ebr4JCW3XlD0OI2sTCc0sWMnxLFuSZ8i47x1uoLHJK9VSMqLC84ykOSckHkzy
alUPazCMtVdYfhdYFl5NLM4n72ic5Vu7ISz3Guolve60S6JtLSRBs3Yv4IGCThPB
VE4dwiTljIFRv4G9i4/7
=gZ+z
-----END PGP SIGNATURE-----

--=-eQDVRJ/IOEkDe4vpUuH/--


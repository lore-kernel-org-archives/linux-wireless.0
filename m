Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0A3IhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 03:37:11 -0500
Subject: Re: [PATCH 1/1] cfg80211: wext: set bssid to NULL in SIOCIWESSID
From: Johannes Berg <johannes@sipsolutions.net>
To: shanyu.zhao@intel.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1264808376-8003-1-git-send-email-shanyu.zhao@intel.com>
References: <1264808376-8003-1-git-send-email-shanyu.zhao@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-58ScTYtVaghvTR173BZv"
Date: Sat, 30 Jan 2010 09:37:06 +0100
Message-ID: <1264840626.3546.181.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-58ScTYtVaghvTR173BZv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-01-29 at 15:39 -0800, shanyu.zhao@intel.com wrote:
> From: Shanyu Zhao <shanyu.zhao@intel.com>
>=20
> Need to set bssid to NULL in cfg80211's SIOCIWESSID function, otherwise
> after "iwconfig wlanx ap <mac>", the "iwconfig wlanx essid" won't work.
>=20
> Cc: stable@kernel.org
>=20
> Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
> ---
>  net/wireless/wext-sme.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
> index eede356..5a67dd5 100644
> --- a/net/wireless/wext-sme.c
> +++ b/net/wireless/wext-sme.c
> @@ -194,6 +194,7 @@ int cfg80211_mgd_wext_siwessid(struct net_device *dev=
,
>  	wdev->wext.connect.ssid =3D wdev->wext.ssid;
>  	memcpy(wdev->wext.ssid, ssid, len);
>  	wdev->wext.connect.ssid_len =3D len;
> +	wdev->wext.connect.bssid =3D NULL;

This is incorrect. If you want to connect to an AP with the SSID "foo"
and the BSSID "00:...:ff" you need to make two calls, e.g.

iwconfig wlan0 essid "foo"
iwconfig wlan0 ap "00:...:ff"

Your patch disables that functionality.

johannes

--=-58ScTYtVaghvTR173BZv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLY++vAAoJEODzc/N7+Qmamb4QAKID4tDzJots0BwodTQoiOzy
FRetFVbvah+Y2dhtgWY1Xm+twkt+Ht88kWFobD+DL+xyfO6K5Af7iBRod8AUBKzT
fCwtpjAntHYZS3w07UUz51qpaUvMTR5yO7b59pQ85QroyxMO4nhvr4fic9ZNxhig
XR1ux/uDbLJYOf0TH2slhmNw41LdkJ7MAl3sulBtERp9OJUWlcfp1molcJYmDk1s
MiOPf9m1D8uwQIQFD+stMwSA6RSxTBi8k2hSs7FJh2fC1frbbjo3CuoWhDfHI42U
CjWwxq/oiKMBFbFvB2GJjkxfihMJLMPXBj5Fa/5VmnSRaJ0Oxj2l/loPqyvwTE3y
Euw9xWYZxXmGULfd8q5C/OZsaiyq1oCwptRN+wMJbANbcGUVqsH9vKWvpYHAVIpp
sqQs6+6fsemMhJYaJ8hS3XsO6KYF6qHb2swqINSfa87V/kHVxpeAPL1vxv+oIYwp
PtW106x8k7r4Q8696JR25gLLo4c7SIxhII9FBNudM5EAY5Q7D0KdTbINULMrBloB
jfNYJVCWAlt8gLaZPJllWiS41L2tKc0g6EF1poNc1NISkXkY0NLlsDHWr3UodVK5
OnrMa+NDqGdi2UHlNa5WUQ9wH3smBB8qDzpQAXIzbn876MO9NiLycbOu+ACFOiuC
xHxgYVwDLdgum9IwyxEu
=wu3K
-----END PGP SIGNATURE-----

--=-58ScTYtVaghvTR173BZv--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZGTKgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 06:36:10 -0400
Subject: Re: [PATCH 2/5] cfg80211: fix typo of IWEVASSOCRESPIE
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1248061667-8614-3-git-send-email-yi.zhu@intel.com>
References: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-3-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EPviVZzDXsfmTNwp8ihi"
Date: Mon, 20 Jul 2009 12:36:07 +0200
Message-Id: <1248086167.14765.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EPviVZzDXsfmTNwp8ihi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-20 at 11:47 +0800, Zhu Yi wrote:
> It should be IWEVASSOCREQIE instead.

Indeed, thanks.

> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  net/wireless/sme.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index e7a8851..82de2d9 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -341,7 +341,7 @@ void __cfg80211_connect_result(struct net_device *dev=
, const u8 *bssid,
>  		if (req_ie && status =3D=3D WLAN_STATUS_SUCCESS) {
>  			memset(&wrqu, 0, sizeof(wrqu));
>  			wrqu.data.length =3D req_ie_len;
> -			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, req_ie);
> +			wireless_send_event(dev, IWEVASSOCREQIE, &wrqu, req_ie);
>  		}
> =20
>  		if (resp_ie && status =3D=3D WLAN_STATUS_SUCCESS) {
> @@ -474,7 +474,7 @@ void __cfg80211_roamed(struct wireless_dev *wdev, con=
st u8 *bssid,
>  	if (req_ie) {
>  		memset(&wrqu, 0, sizeof(wrqu));
>  		wrqu.data.length =3D req_ie_len;
> -		wireless_send_event(wdev->netdev, IWEVASSOCRESPIE,
> +		wireless_send_event(wdev->netdev, IWEVASSOCREQIE,
>  				    &wrqu, req_ie);
>  	}
> =20

--=-EPviVZzDXsfmTNwp8ihi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKZEiTAAoJEODzc/N7+QmajkMP/jVC9JCCyJ9+hqHW+6dv0MI3
KF66b1V1oWgkXuSYO4oB+DkDetErLkUJFnlIqP75FlX8X9/Le+XC/QbHDWdxn6Q4
Y62WLu9YUt7m6cMJI0mhSH7NCW3vU1xPGulfPzxMuJeCuDiUmaVkAOMLltFIXawX
/KqqsfAsxfh1xbSCQBPt8Vsj4S9ByE2fOK6bR+gCqPjHIvsfdWY+BVTvrCr96ulM
3oq6Oh5q4GfiZpNhhr5IyjneLYCkQg/Q3mjAcRxCYI8+FQ0P6xlhNDMQ/FVE0mM1
/f/mh14z2+j2nWVSK25HUh1d5bvOISjR6a9AFkpEqN34FGDyuH3jtG/lUPocpCAA
duVsdqJ7il8hwKejvBBqMCh/WaL/p79ZUgPUI/ImD75dyxLdqq6XexNNueXbuJhq
rnbVaR/rQzyG/1o73uqnGXK/iMQ/XIqme19alhjKgTW26QWIHuc3sS/b6H7IZ3bg
p/lDWhsA8DZExqZ0FbnFqPinqoKk/FETzVYPyTewn1JOkllGHrBXw/2+Cf/XxUT9
uVxQo+JFFP5UaPEUAYaAoXiRLZNEL8veRavi4Pw+QoFVxK/BtNwshgFHX9dfNxMB
5CD8BHrAvEWACCem+nbwxuK2m/+udoU3TLIHYOyILO2tCwtcIib7B4bBQCmBXEU4
LSra392IPyI+lewKrYuE
=uzV2
-----END PGP SIGNATURE-----

--=-EPviVZzDXsfmTNwp8ihi--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45199 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbZGPJkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:40:33 -0400
Subject: Re: [PATCH 09/10] cfg80211: remove WARN_ON in
 __cfg80211_sme_scan_done
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1247736854-6760-10-git-send-email-yi.zhu@intel.com>
References: <1247736854-6760-1-git-send-email-yi.zhu@intel.com>
	 <1247736854-6760-2-git-send-email-yi.zhu@intel.com>
	 <1247736854-6760-3-git-send-email-yi.zhu@intel.com>
	 <1247736854-6760-4-git-send-email-yi.zhu@intel.com>
	 <1247736854-6760-5-git-send-email-yi.zhu@intel.com>
	 <1247736854-6760-6-git-send-email-yi.zhu@intel.com>
	 <1247736854-6760-7-git-send-email-yi.zhu@intel.com>
	 <1247736854-6760-8-git-send-email-yi.zhu@intel.com>
	 <1247736854-6760-9-git-send-email-yi.zhu@intel.com>
	 <1247736854-6760-10-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1CyGD9G+TUh6yYmd8Q30"
Date: Thu, 16 Jul 2009 11:39:52 +0200
Message-Id: <1247737192.24433.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1CyGD9G+TUh6yYmd8Q30
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 17:34 +0800, Zhu Yi wrote:
> cfg80211_sme_scan_done() can be called (by fullmac cards) with
> wdev->conn =3D=3D NULL when CFG80211_SME_CONNECTING. We quit silently
> instead of WARN_ON in this case.

Indeed, sorry.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  net/wireless/sme.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 10ed366..e7a8851 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -227,7 +227,7 @@ static void __cfg80211_sme_scan_done(struct net_devic=
e *dev)
>  	if (wdev->sme_state !=3D CFG80211_SME_CONNECTING)
>  		return;
> =20
> -	if (WARN_ON(!wdev->conn))
> +	if (!wdev->conn)
>  		return;
> =20
>  	if (wdev->conn->state !=3D CFG80211_CONN_SCANNING &&

--=-1CyGD9G+TUh6yYmd8Q30
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXvVlAAoJEODzc/N7+QmaunIP/30T6abLjf2lixeSa0yRwFya
3nidGFqPJWGyPBPNIhYvNwLMm//FiDGSGfffCZU9Wj3r1Kx702OtuyP4szy/Hw+b
9x7wC9x2hD6YiLl4qCv3gfSMdacNda/LVT0d4T8UdEAKDtVHzkTat4oDD5KomBWo
XA7o717r/kFnvwDkdfU5JXzTF2XfpX5y/x1h6en9pSeZvPHRl3k43UEc4zIEkw9J
qmweyH3pYXQeUPWiD14x/E9XSi4fzIbg2WLuarr4Pk3DAtWUrnu/T+X2XtloPppI
YViXIfXGl1qGdurtM3YqI4RjB9yIxNiYHakoj6xPjiYX45O7uuTcwJMBe8cHPXer
o8QPndoyO7xh+CRzlBa//CrfaTLFocPZq7bo/G5GGXlf/Y6dC00EYvnG6SFMq1Yy
EchDYk/3he+qaBrNDlxIzOUjcnw6+uYpyx23411jDdF4tVtadDtMGNlF9XwsgWTN
cPrcdWYBVLBa9KIf//7kDmMCaQRoEetF8h0BlSYWp3OYmu+HYFmokI8QB2fycKTA
7yJCS8HE2c5OP313H/W6Pugox6FF4QsU7pWg/xtU0Mk6T0jasDeerotG49JO9oKG
HNsDty89ryyi8fz4NcCb26TjhjWfvmxOl97TBwJANfBhSGtIefzD42Zu602Xvkcn
ZZpPJ4eI0fIarTlliOBj
=jpZT
-----END PGP SIGNATURE-----

--=-1CyGD9G+TUh6yYmd8Q30--


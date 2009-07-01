Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbZGAK6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 06:58:38 -0400
Subject: Re: [PATCH] cfg80211: set conn.state properly in the connect() case
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090630153522.GA28206@sortiz.org>
References: <20090630115245.675553951@sipsolutions.net>
	 <20090630115301.625487032@sipsolutions.net>
	 <20090630153522.GA28206@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NqgrNIC32nqcE/ItcV+x"
Date: Wed, 01 Jul 2009 12:58:22 +0200
Message-Id: <1246445902.4131.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NqgrNIC32nqcE/ItcV+x
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-30 at 17:35 +0200, Samuel Ortiz wrote:
> We need to set the conn.state to ASSOCIATING for the ->connect() path. By
> default, it is set to 0, i.e. SCANNING, which causes sme_scan_done() to
> eventually call conn_do_work(), which then would call assoc() and auth()
> blindly. That's why we also bug on those hooks not being defined there.

Maybe it would be better to have a default IDLE state for this state
machine as well, instead?

johannes

> Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> ---
>  net/wireless/sme.c |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> Index: iwm-2.6/net/wireless/sme.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- iwm-2.6.orig/net/wireless/sme.c	2009-06-30 16:39:58.000000000 +0200
> +++ iwm-2.6/net/wireless/sme.c	2009-06-30 17:17:14.000000000 +0200
> @@ -103,6 +103,7 @@ static int cfg80211_conn_do_work(struct=20
>  		u.auth_req.ie =3D NULL;
>  		u.auth_req.ie_len =3D 0;
>  		wdev->conn.state =3D CFG80211_CONN_AUTHENTICATING;
> +		BUG_ON(!drv->ops->auth);
>  		return drv->ops->auth(wdev->wiphy, wdev->netdev, &u.auth_req);
>  	case CFG80211_CONN_ASSOCIATE_NEXT:
>  		u.assoc_req.chan =3D wdev->conn.params.channel;
> @@ -115,6 +116,7 @@ static int cfg80211_conn_do_work(struct=20
>  		memcpy(&u.assoc_req.crypto, &wdev->conn.params.crypto,
>  			sizeof(u.assoc_req.crypto));
>  		wdev->conn.state =3D CFG80211_CONN_ASSOCIATING;
> +		BUG_ON(!drv->ops->assoc);
>  		return drv->ops->assoc(wdev->wiphy, wdev->netdev,
>  					&u.assoc_req);
>  	default:
> @@ -455,6 +457,7 @@ int cfg80211_connect(struct cfg80211_reg
>  		return err;
>  	} else {
>  		wdev->sme_state =3D CFG80211_SME_CONNECTING;
> +		wdev->conn.state =3D CFG80211_CONN_ASSOCIATING;
>  		err =3D rdev->ops->connect(&rdev->wiphy, dev, connect);
>  		if (err) {
>  			wdev->sme_state =3D CFG80211_SME_IDLE;

--=-NqgrNIC32nqcE/ItcV+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKS0FLAAoJEODzc/N7+QmaIbcP/i7BRwbo2wQC3eAuaqboq37J
ligLVgOOYzijjvw0RonjjhbvsE75H8Mo3EXGw4+bsBnEAkGZHPojkuPT8wdrG3Lb
zqjyDG5G9NaSLI0Ud3GpD196KblLWsRhRizig7571WGBwMiavl8vbQ7YigQw4EuI
FpNkOgAQXLOHy0XwJFHNxHVMSGfr/g9T8zsmBZxzE6xeTnFvdbVr2QPtXsUdyxpf
TrZX8SADDSWFSSvkLNqVwxe8V+YAATbFWa/iWXRlowkFlamUvhHpnAhtCViAfg6H
3cIt8DNylXFci4uIn2C9EtO9BnBP/VB2t85Cd25q9QV7f1tIt8iDJUXxLf80NN5m
sg8eHLcyPbAgpuUIgoHDP9yyxpanNCvi3LHCV5JAqwzmC2kxCLtkS1sN8U+wT88D
d5gpnOAYr8gWL+/9KInDkbzeRKhJKGWMB43546JlI0XfniCizO0YXciYY0TzOaiT
hoxzNvNusvQWljT70mDl6V2fD+ZDtmiUIX+bn9Vs3d6bzGXXk2cjFrQseHtXXuDA
rqRUF0xLbnU6aLAqtMe7HTB7tEzWFRTQ77OghBcj9CNdD5jP7fRd+/JMC6h9ahRV
re7aV/nW7BYs2V1vpXcz8Hm9P58bqMr8BG1orEr3hG5PwwfJf9XUlF+dmnr4VvVV
QLb35iCqUyOSfXYkMgf4
=k27j
-----END PGP SIGNATURE-----

--=-NqgrNIC32nqcE/ItcV+x--


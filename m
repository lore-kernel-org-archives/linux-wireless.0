Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41653 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZHSHxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 03:53:11 -0400
Subject: Re: [PATCH] cfg80211: fix leaks of wdev->conn->ie
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1250639011-18258-1-git-send-email-kilroyd@googlemail.com>
References: <1250639011-18258-1-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-25y5UTdkv1S6ITrWy8iD"
Date: Wed, 19 Aug 2009 09:52:41 +0200
Message-Id: <1250668361.25419.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-25y5UTdkv1S6ITrWy8iD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-19 at 00:43 +0100, David Kilroy wrote:
> This only occurs in the following error situations:
>  - driver calls connect_result with failure
>  - error scheduling authentication on connect
>  - error initiating scan (to get BSSID and channel) on
>    connect
>  - userspace calls disconnect while in the SCANNING or
>    SCAN_AGAIN states
>=20
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> ---
>=20
> I came across this while looking at my orinoco scanning issue. It's
> possible I'm wrong...

Yes, looks like I forgot these, thanks!

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/wireless/sme.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 6fb6a70..9ddc00e 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -395,6 +395,8 @@ void __cfg80211_connect_result(struct net_device *dev=
, const u8 *bssid,
> =20
>  	if (status !=3D WLAN_STATUS_SUCCESS) {
>  		wdev->sme_state =3D CFG80211_SME_IDLE;
> +		if (wdev->conn)
> +			kfree(wdev->conn->ie);
>  		kfree(wdev->conn);
>  		wdev->conn =3D NULL;
>  		kfree(wdev->connect_keys);
> @@ -779,6 +781,7 @@ int __cfg80211_connect(struct cfg80211_registered_dev=
ice *rdev,
>  			}
>  		}
>  		if (err) {
> +			kfree(wdev->conn->ie);
>  			kfree(wdev->conn);
>  			wdev->conn =3D NULL;
>  			wdev->sme_state =3D CFG80211_SME_IDLE;
> @@ -848,6 +851,7 @@ int __cfg80211_disconnect(struct cfg80211_registered_=
device *rdev,
>  		    (wdev->conn->state =3D=3D CFG80211_CONN_SCANNING ||
>  		     wdev->conn->state =3D=3D CFG80211_CONN_SCAN_AGAIN)) {
>  			wdev->sme_state =3D CFG80211_SME_IDLE;
> +			kfree(wdev->conn->ie);
>  			kfree(wdev->conn);
>  			wdev->conn =3D NULL;
>  			wdev->ssid_len =3D 0;


--=-25y5UTdkv1S6ITrWy8iD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKi69FAAoJEODzc/N7+QmasdMQAJRaDrAZ5QM9fLvB27O0tH8Y
W3wB8GJMItEZVOlfNhHEZQmKUaYVCvKFlfjvNTvInvjyvFMEtCd1VYLUmqEcMPTF
/tJpCFZW2HrpoTjNUIeaVd3wtCTbRKlflVGzh4run8mCSu5EIoWKDx4wOl0Rwq5B
xd5lfjgzyGpUdfiaVs1Zln+OmES7XaPUugXdtgBNV5C2yxGtn1+cvDsJAvoAuBaR
ZhsnuycFkNdW4HnXZVkXCIHupLrWfV/U9J4C55zJyJzwdo5g7RHmK0SXIrMp+Bdy
EoSB0PpwUnhIM01xG1JzCWBKcuTs3gEl4XqeAqowHEvM7UKv/IolZ0P6mJVhuubH
lblLpdeLpffL49fZUBdQrm3AJVcuwSCoT/Hpvep8WqJW8Pluz5nU6BIP3nBCrjzA
xWyYlLH0A+CRCce5Q8d9LAFdzf3HMJJKgi4HidkHHK0LfwcF4Go/i7kD1U4cxd2D
AXKpyfNONcfmmfY0IptyjFBJ8xz7ty/sd2LGr8BS/3rqtSoPWpluI+9EthniKK85
TFv7EQTTTiPyRQc/DRpjKgkx7H+Tp7hWUwCmGS8sX7kxuRPrdbD/7XffjiFJtn/E
BwtDC2BBkBT6x8qvRLmJYAaziEnzdqQfEwlfBIm1hCcJi2rgQ0uQnoswgS+JvyK2
RYXwDsQekU5kh7312t+r
=zXG4
-----END PGP SIGNATURE-----

--=-25y5UTdkv1S6ITrWy8iD--


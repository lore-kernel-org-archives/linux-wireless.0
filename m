Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYJ1SgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:36:06 -0400
Subject: Re: [PATCH] mac80211: print reason code for deauth/dissoc frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225180711-5204-1-git-send-email-yi.zhu@intel.com> (sfid-20081028_090432_399434_02E86D17)
References: <1225180711-5204-1-git-send-email-yi.zhu@intel.com>
	 (sfid-20081028_090432_399434_02E86D17)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N6RZLf7T/v8lAixSnudH"
Date: Tue, 28 Oct 2008 11:06:27 +0100
Message-Id: <1225188387.3598.0.camel@johannes.berg> (sfid-20081028_193611_520464_0E7EEB58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-N6RZLf7T/v8lAixSnudH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 15:58 +0800, Zhu Yi wrote:
> The patch prints reason code for deauth/dissoc frames to give users
> more ideas what's happened for the disconnection.

Indeed, that seems useful.

> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/mlme.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index d5006b2..0752e09 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1134,7 +1134,8 @@ static void ieee80211_rx_mgmt_deauth(struct ieee802=
11_sub_if_data *sdata,
>  	reason_code =3D le16_to_cpu(mgmt->u.deauth.reason_code);
> =20
>  	if (ifsta->flags & IEEE80211_STA_AUTHENTICATED)
> -		printk(KERN_DEBUG "%s: deauthenticated\n", sdata->dev->name);
> +		printk(KERN_DEBUG "%s: deauthenticated (Reason: %u)\n",
> +				sdata->dev->name, reason_code);
> =20
>  	if (ifsta->state =3D=3D IEEE80211_STA_MLME_AUTHENTICATE ||
>  	    ifsta->state =3D=3D IEEE80211_STA_MLME_ASSOCIATE ||
> @@ -1166,7 +1167,8 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee8=
0211_sub_if_data *sdata,
>  	reason_code =3D le16_to_cpu(mgmt->u.disassoc.reason_code);
> =20
>  	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
> -		printk(KERN_DEBUG "%s: disassociated\n", sdata->dev->name);
> +		printk(KERN_DEBUG "%s: disassociated (Reason: %u)\n",
> +				sdata->dev->name, reason_code);
> =20
>  	if (ifsta->state =3D=3D IEEE80211_STA_MLME_ASSOCIATED) {
>  		ifsta->state =3D IEEE80211_STA_MLME_ASSOCIATE;

--=-N6RZLf7T/v8lAixSnudH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBuQfAAoJEKVg1VMiehFYKDcQAIL5/9uf4R3hScodSaWMdn0T
7zVBxxUx+zqwuc3Ng5HzTdt2N/QYvzxkANmoJu1Fz0IrwR2MFD2D8mYe2kVPlo0D
iOurZlqoCp1lhDa+o33xPlj9YZQnnehL9XWvL+f3CK3TpW4+n4jWudizVIzJUL2J
NhBG09GkXMbTrPn4tuWyY8VFDh3t29K8Bk2lVUIRlgmLkDtn1+Qy7PKICBJLtvBl
aIirqjUXhNihfG5lRKjygfE/lVK45TviJRj6WRehOtp3fohQaqrinEBBWia97CIP
8lI0ko5a0da/qyksfMHIkPg+Kos+FKSheP0Dz/JwasN9BTCiukimv2tkD/FGYP8u
Tjgp1uCMdl+Qb1M9MI17i95ZR8hh+ceNOHMAUNWwJSH6elIti1zYYleQoU3rqhrU
uA3oX9iJEyG2jMDB/MwLQltDBGifiEyqOsga7sV6etaFbDUNV1hrpEzvb13u/uXK
iBEMznU30aOOuPiytwJBTJTUksB33wRAiWMkhPqDHM4zBcWGjnuxSrhRy0ShIgfv
cWbnzugGU2a/7RoF2/SPVk0ryAxl6ytrQQXKfmXrXTRWDGRCX7IHAtiu9BXiZKyz
hh5sR5qf9Hmpj2F3PvmFKNMuSXSVVSpg9g44eDerw5f2QYh82WUQH17tm82HTac0
Ba+nm7EzmlRQIgJK4R5t
=Xbta
-----END PGP SIGNATURE-----

--=-N6RZLf7T/v8lAixSnudH--


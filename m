Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56571 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbaAQXao (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 18:30:44 -0500
Received: from [192.168.1.221] ([93.218.75.192]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0LdHeL-1VdSQj3GQj-00iT6V for
 <linux-wireless@vger.kernel.org>; Sat, 18 Jan 2014 00:30:42 +0100
Message-ID: <52D9BD1C.5070405@rempel-privat.de> (sfid-20140118_003046_964429_A8CE394E)
Date: Sat, 18 Jan 2014 00:30:36 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
CC: kvalo@adurom.com, antonio@meshcoding.com
Subject: Re: [PATCH v3 1/5] ath: add common function ath_is_mybeacon
References: <1389802038-6688-2-git-send-email-linux@rempel-privat.de> <1390001249-19784-1-git-send-email-linux@rempel-privat.de>
In-Reply-To: <1390001249-19784-1-git-send-email-linux@rempel-privat.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8lvL2cauHHF0HHdFBdrJ5WnaxGGH8wBSq"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8lvL2cauHHF0HHdFBdrJ5WnaxGGH8wBSq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 18.01.2014 00:27, schrieb Oleksij Rempel:
> this function is used by most ath driver, so it can be moved here.
>=20
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>  drivers/net/wireless/ath/ath.h | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/=
ath.h
> index e0ba7cd..ab6a0c8 100644
> --- a/drivers/net/wireless/ath/ath.h
> +++ b/drivers/net/wireless/ath/ath.h
> @@ -17,6 +17,7 @@
>  #ifndef ATH_H
>  #define ATH_H
> =20
> +#include <linux/etherdevice.h>
>  #include <linux/skbuff.h>
>  #include <linux/if_ether.h>
>  #include <linux/spinlock.h>
> @@ -162,10 +163,17 @@ struct ath_common {
>  	bool bt_ant_diversity;
>  };
> =20
> +static inline bool ath_is_mybeacon(struct ath_common *common,
> +				   struct ieee80211_hdr *hdr)
> +{
> +	return ieee80211_is_beacon(hdr->frame_control) &&
> +		!is_zero_ether_addr(common->curbssid) &&
> +		ether_addr_equal_64bits(hdr->addr3, common->curbssid);
> +}
> +
>  struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
>  				u32 len,

If there is no more comments, i'll resend tomorrow this patch set to
Linville.


--=20
Regards,
Oleksij


--8lvL2cauHHF0HHdFBdrJ5WnaxGGH8wBSq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLZvRwACgkQHwImuRkmbWlQOgD/ZGNb3tO7Ob0QOp1xD+T7LcOU
B2SvIv021CGf7/YeR+QA/3hVo8taIdVBuOZZh9SoNUnMxCPt4XCD3uaJ+pNxg7aG
=EhoJ
-----END PGP SIGNATURE-----

--8lvL2cauHHF0HHdFBdrJ5WnaxGGH8wBSq--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41123 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbYHCJWc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 05:22:32 -0400
Subject: Re: [PATCH] move ETH_P_PAE from ieee80211_i.h to if_ether.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Jasper Bryant-Greene <jasper@amiton.co.nz>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1217719855.14226.5.camel@luna.unix.geek.nz> (sfid-20080803_013052_034741_F88529F6)
References: <1217719855.14226.5.camel@luna.unix.geek.nz>
	 (sfid-20080803_013052_034741_F88529F6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NXdfJ2LAL4bLmXsxqVCK"
Date: Sun, 03 Aug 2008 11:22:23 +0200
Message-Id: <1217755343.4721.11.camel@johannes.berg> (sfid-20080803_112236_699949_52210BE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NXdfJ2LAL4bLmXsxqVCK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-08-03 at 11:30 +1200, Jasper Bryant-Greene wrote:
> ETH_P_PAE belongs in if_ether.h with the other ETH_P_* definitions. This
> patch moves it there.


This needs to cross netdev, but other than that

> Signed-off-by: Jasper Bryant-Greene <jasper@amiton.co.nz>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
> diff --git a/include/linux/if_ether.h b/include/linux/if_ether.h
> index e157c13..5028e0b 100644
> --- a/include/linux/if_ether.h
> +++ b/include/linux/if_ether.h
> @@ -74,6 +74,7 @@
>  #define ETH_P_ATMFATE	0x8884		/* Frame-based ATM Transport
>  					 * over Ethernet
>  					 */
> +#define ETH_P_PAE	0x888E		/* Port Access Entity (IEEE 802.1X) */
>  #define ETH_P_AOE	0x88A2		/* ATA over Ethernet		*/
>  #define ETH_P_TIPC	0x88CA		/* TIPC 			*/
> =20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index a4f9a83..be4d99e 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -32,10 +32,6 @@
>  /* ieee80211.o internal definitions, etc. These are not included into
>   * low-level drivers. */
> =20
> -#ifndef ETH_P_PAE
> -#define ETH_P_PAE 0x888E /* Port Access Entity (IEEE 802.1X) */
> -#endif /* ETH_P_PAE */
> -
>  #define WLAN_FC_DATA_PRESENT(fc) (((fc) & 0x4c) =3D=3D 0x08)
> =20
>  #define IEEE80211_FC(type, subtype) cpu_to_le16(type | subtype)
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-NXdfJ2LAL4bLmXsxqVCK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlXjLAAoJEKVg1VMiehFYDpUP/jst2owwOZDIZd2XoBRXw45R
qzBceWCQksyWNTo/d6/gRwtbnSUdJ6tfI/o+g9/+uT5EnB2pihSk59U+n75vCxuz
FBU8/ZyK3QP2bW4udnj8lP7+OKNOWDKSzWfxxWEQK73AEU6+6AnBfA2e2V0W+TL5
HukACXDKL1G3BvS+YQHkp2dQhNhzddsEYjBMfwab2QOg32WiXgwjEN/ubb5T61Kh
wjH9mK2+dSZWyVWvRh9Q8rbW3bgGMafKCeJ2wGbbFhxMUGggJT06UKHh4Fhrv0Dz
gIAvlAcoDN1e7l515xrSWPB+YlwZGpdi58Fg9Juanl6UtzohYDCwiemh11rVWEP0
GkF+KbCmGacbV1KiksTdHfzoFcS20RiM7T4XAnV4Noz3cuE47zoRQqQoHgeAGkHA
pBuavjB/QXdCOSGUPuFY3diIKT0L9oZDZS+eigbi0TzGi57lBul0MB0EGWojgQUS
G/mPqfk3MhgR55mBUjFOzEZ+R6jXbRxeElbC4/BA+e/j5ikXqBQy1Du35wXaRH+K
Y4308CVTTEAjIX2U8ju3kjU1UyUbhDmVuAt7LFko2ut0SRolza/VqDHYtt5SqDuJ
wUhPyh0OK0NQPEFJ2UAZrXXfPx4iQ73vNoz75ESMRwN6AcSBxiQI69pG3tQAIkKH
jm37eCMi5MCw4TDf23XF
=wlyG
-----END PGP SIGNATURE-----

--=-NXdfJ2LAL4bLmXsxqVCK--


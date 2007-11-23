Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbXKWUeJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 15:34:09 -0500
Subject: Re: [PATCH 2.6.24] zd1211rw: fix unaligned memory accesses
	comparing MAC addresses
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	davem@davemloft.net, shaddy_baddah@hotmail.com, kune@deine-taler.de
In-Reply-To: <20071123001428.03A199D4A1F@zog.reactivated.net> (sfid-20071123_001438_811073_6683A41B)
References: <20071123001428.03A199D4A1F@zog.reactivated.net>
	 (sfid-20071123_001438_811073_6683A41B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AQQCfAB7KxGqNqwXfi0u"
Date: Fri, 23 Nov 2007 21:34:01 +0100
Message-Id: <1195850041.4149.167.camel@johannes.berg> (sfid-20071123_203414_590150_A4D41F84)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AQQCfAB7KxGqNqwXfi0u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-11-23 at 00:14 +0000, Daniel Drake wrote:
> Shaddy Baddah reported some unaligned accesses with the zd1211rw driver.
> David Miller found an issue with comparison of ethernet addresses, and I
> found a few others on top of that. This patch should remove most/all of t=
he
> unaligned accesses.

Why are these unaligned to start with?

> Signed-off-by: Daniel Drake <dsd@gentoo.org>
>=20
> ---
>=20
> A different patch will follow for 2.6.25 soon, probably using
> compare_ether_addr_unaligned() if David accepts that patch.
>=20
> Index: linux-2.6.24-rc3-git1/drivers/net/wireless/zd1211rw/zd_mac.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.24-rc3-git1.orig/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ linux-2.6.24-rc3-git1/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -974,14 +974,14 @@ static int is_data_packet_for_us(struct=20
>  	switch (ieee->iw_mode) {
>  	case IW_MODE_ADHOC:
>  		if ((fc & (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS)) !=3D 0 ||
> -		    compare_ether_addr(hdr->addr3, ieee->bssid) !=3D 0)
> +		    memcmp(hdr->addr3, ieee->bssid, ETH_ALEN) !=3D 0)
>  			return 0;
>  		break;
>  	case IW_MODE_AUTO:
>  	case IW_MODE_INFRA:
>  		if ((fc & (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS)) !=3D
>  		    IEEE80211_FCTL_FROMDS ||
> -		    compare_ether_addr(hdr->addr2, ieee->bssid) !=3D 0)
> +		    memcmp(hdr->addr2, ieee->bssid, ETH_ALEN) !=3D 0)
>  			return 0;
>  		break;
>  	default:
> @@ -989,9 +989,9 @@ static int is_data_packet_for_us(struct=20
>  		return 0;
>  	}
> =20
> -	return compare_ether_addr(hdr->addr1, netdev->dev_addr) =3D=3D 0 ||
> +	return memcmp(hdr->addr1, netdev->dev_addr, ETH_ALEN) =3D=3D 0 ||
>  	       (is_multicast_ether_addr(hdr->addr1) &&
> -		compare_ether_addr(hdr->addr3, netdev->dev_addr) !=3D 0) ||
> +		memcmp(hdr->addr3, netdev->dev_addr, ETH_ALEN) !=3D 0) ||
>  	       (netdev->flags & IFF_PROMISC);
>  }
> =20
> @@ -1047,7 +1047,7 @@ static void update_qual_rssi(struct zd_m
>  	hdr =3D (struct ieee80211_hdr_3addr *)buffer;
>  	if (length < offsetof(struct ieee80211_hdr_3addr, addr3))
>  		return;
> -	if (compare_ether_addr(hdr->addr2, zd_mac_to_ieee80211(mac)->bssid) !=
=3D 0)
> +	if (memcmp(hdr->addr2, zd_mac_to_ieee80211(mac)->bssid, ETH_ALEN) !=3D =
0)
>  		return;
> =20
>  	spin_lock_irqsave(&mac->lock, flags);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-AQQCfAB7KxGqNqwXfi0u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0c5N6Vg1VMiehFYAQJ/gQ//WlYhDOoRNHQqje5H7U79fsW3fdmYQOXr
UebDnpTmAfLHK5yasjEXRj59/Eju/kQKXfvpta3gahIO3F6UF3os9TfJtPBViVIc
QVhWNueTGcY/7rWKokjWMAaZb3X/Crhg916odYWfANdceYkgfPeM6lrtNb8/dYtF
G25QQl6YSYP3secs48yFgUV4HmXATMLxGITD1DMmdLQq2pn/ljO7EBgpg+EiGCUR
e6v2v37C29V2ngBFI83bZGZw0BwRJo3Z1XeW7rlLqdCy5phR+9V0P78NG/1cKYj4
1TknOILizbNETMPZArAy/cSaPrlhqbZ3+56YX8FUP0yxvNK8/J1TEQiKUMAQZFMX
wWosX8NYsskyYRBaedbNHZIqakaUHFWMi9BToFL1GuaciOwRlLEWCQmpE52VAPNQ
q9znddhYWRKuKL9f42nyESDlmyA3GwpzbiPza24UPVw5lf4jMHX+4Jtttku3wUwI
Sad/Z4PrnBzYq9tf4vDu1xxjCYm5NMImX5B8hNtDH0BZ23hu3jYrGUsqs7AYA73z
UXPSB89L2KRbWSohARM0dNWOi9WeLpcXHgeJC3aLoe5o8RVTqH4Im00dISCkrKyR
kX1RlblNG/QOOxMwoV73KQyXAje/KbmxlidFPoG5ecYHFmzQCtjvBUF4EEyuaxf1
b33djMt/E54=
=uT5i
-----END PGP SIGNATURE-----

--=-AQQCfAB7KxGqNqwXfi0u--


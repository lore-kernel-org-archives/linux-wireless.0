Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbXKTNtb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 08:49:31 -0500
Subject: Re: [RFC] mac80211: always have a valid master device mac address
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1195517851.19479.24.camel@johannes.berg> (sfid-20071120_123645_893727_38226573)
References: <1195517851.19479.24.camel@johannes.berg>
	 (sfid-20071120_123645_893727_38226573)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YWsTaXSBH+st3TBwqZw6"
Date: Tue, 20 Nov 2007 14:22:16 +0100
Message-Id: <1195564936.10920.21.camel@johannes.berg> (sfid-20071120_134935_357424_7F8CF46E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YWsTaXSBH+st3TBwqZw6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-11-20 at 01:17 +0100, Johannes Berg wrote:
> Once a while a driver will give us a bogus MAC address. This can be
> remedied by the user by setting the MAC address on the wlanX interface,
> but unfortunately one cannot change the address of the wmasterX
> interface which results in wlanX going up but wmasterX refusing to. This
> is pretty bad. This patch forces wmasterX to have a valid MAC address.
> The actual address doesn't matter at all.
>=20
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Or should we hardcode one and always use that instead of the device
> address?

Hmm. Considering this. udev has trouble with devices with the same MAC
address, maybe we *should* hardcode a different one? That'd also stop
people from using the master device's MAC address as the "eeprom MAC"
that should be gotten from sysfs instead. It's bound to happen ;)

> --- everything.orig/net/mac80211/ieee80211.c	2007-11-20 00:25:03.00870860=
2 +0100
> +++ everything/net/mac80211/ieee80211.c	2007-11-20 00:27:09.278700356 +01=
00
> @@ -1286,6 +1286,8 @@ int ieee80211_register_hw(struct ieee802
>  		goto fail_dev;
> =20
>  	memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
> +	if (!is_valid_ether_addr(local->mdev->dev_addr))
> +		random_ether_addr(local->mdev->dev_addr);
>  	SET_NETDEV_DEV(local->mdev, wiphy_dev(local->hw.wiphy));
> =20
>  	result =3D register_netdevice(local->mdev);
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-YWsTaXSBH+st3TBwqZw6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0Lfh6Vg1VMiehFYAQKgMRAAvMCoblvhlK3SavV6fy1QRcUZIsqO6HmE
i7n9KM47jUdfVC8ZyygAE2unkwbnHkYvpiAC3Y1WIuWmohAhIdWRnjMiohdjOhNw
CdcZUerU4WwpNdLeAAMQLfe6bXnbtu/rZJmAItJICkwYEz1ZKYmwplvhv7S14Wgw
m3ta+hOEGJ5BmsyzzxXl0rECFbWtoGLcPnALwhxe5QVElZaYffm8vCLRhjwKE0xc
bixbDrEjs+c56B8WN74KueaQ3hgUyI+1HerwmWyzJt8YCjwXPvGPIZj6xr0CH5Kj
qvfaylKrZHVefsJE0XUppmMNcaY/2t9SFIK4km+/CverFHxYb3WGRwwMHHpUDe8g
wOpw4TsCXJ+9P7C6nUz8wUjab2XI1iZLWFrjMs+x01d2D/k13PwmQnv3ph0WFiiF
xUF3Gn5tF8q7bO3N+IChq9P9WLTXzMOhYcYBlhY+oYsQ+s760/2qSUs9Dhhu4/so
o/nB/3fex2VX+tJ/bvznR86tOj+jDTwsAawZSBEcWNJnL2sH4LmlEAnVF8YcN0od
umZ2abJJBIVDSRgYr9n66AqJezbCvbxnbFeJmAwIBhZDizsDqu8MxvmMB90mMS46
K7rSk/wlnTqUVeUxTfApPIUZnKbuIpE8Hp4f1PaYXmD+fM4zlQAOHtsfofchFMc7
pIQAoNGOhS4=
=/5C5
-----END PGP SIGNATURE-----

--=-YWsTaXSBH+st3TBwqZw6--


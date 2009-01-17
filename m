Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410AbZAQJZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 04:25:59 -0500
Subject: Re: [PATCH] mac80211: decrement ref count to netdev after
	launching mesh discovery
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1232161489-29528-1-git-send-email-brian@cozybit.com> (sfid-20090117_035936_492701_222DF2F9)
References: <mesh netdev decrement>
	 <1232161489-29528-1-git-send-email-brian@cozybit.com>
	 (sfid-20090117_035936_492701_222DF2F9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-do7vCdYmY8wcHJ+qoWkU"
Date: Sat, 17 Jan 2009 10:25:56 +0100
Message-Id: <1232184356.3668.0.camel@johannes> (sfid-20090117_102618_125068_02EA2175)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-do7vCdYmY8wcHJ+qoWkU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 19:04 -0800, Brian Cavagnolo wrote:
> After launching mesh discovery in tx path, reference count was not being
> decremented.  This was preventing module unload.
>=20
> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>


> ---
>  net/mac80211/tx.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index a7392af..d0ae7f0 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1358,8 +1358,10 @@ int ieee80211_master_start_xmit(struct sk_buff *sk=
b, struct net_device *dev)
>  		if (is_multicast_ether_addr(hdr->addr3))
>  			memcpy(hdr->addr1, hdr->addr3, ETH_ALEN);
>  		else
> -			if (mesh_nexthop_lookup(skb, osdata))
> -				return  0;
> +			if (mesh_nexthop_lookup(skb, osdata)) {
> +				dev_put(odev);
> +				return 0;
> +			}
>  		if (memcmp(odev->dev_addr, hdr->addr4, ETH_ALEN) !=3D 0)
>  			IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.mesh,
>  							    fwded_frames);

--=-do7vCdYmY8wcHJ+qoWkU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcaQhAAoJEKVg1VMiehFYurMQAJhZQ6sYnGVSbSIsJbb0fVoF
JczpyDprx5X3OAiiONWLFFTswrRCeRKtXxodQqfnpjYNXYDuKe4GfSqTti7iqZmp
oWIsK+lZdRiKbXHlKmAlA3fRm71bDhrhpM/HD4UMYc8dEwlGCfMJfweUL/HBV/vP
PfkLVmZfoNqUaezn6GQczPVOhXUAMU4YlSrk6CehBB34DUUR0XWmCACod3P5zb+p
Dhn7bfM7VOZoCGxvVgvV89ohOEl//mkft56OaPnoQRTmOF8Po1GT582lMe2JO/H2
RQZr2BU5a0igOL0Vwr9D8sfE2PIBzNMhXv6fpOIm1JhsyNpvS0M16x5PRul5mDsc
8J9fkYBGE1SrsRIel08KnXNsxFnVs9dHvojJQfPdIbQ9QILfb/VR0dsWTQIm4N5y
4hTNMs3e12iCii3mwJ/oBoNHRZ5chhOF8Nqs2SbXF2UeCcvxVQgGahtKv5xwmajz
zquN5vUeSe+7G3ResWvhPb1s5yKdS0pnaetAtSwk7CEnHZgdqJClrj8vVyjo+iQC
ZrQiQE1M+XoQcTUzHNr5TQTfstT5Wgy46tStu377oPysr+J/tSO+n0WwUrR45V/K
HG0DjiTRtmctIkVg+VxxqkrM6EWPXv/s9cc4dnpQuw0p52P3H53jrsKuWgX6BFq4
kJ6KtklzBEg/phcJa5gQ
=vgQF
-----END PGP SIGNATURE-----

--=-do7vCdYmY8wcHJ+qoWkU--


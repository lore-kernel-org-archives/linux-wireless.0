Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760291AbYFBMjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 08:39:32 -0400
Subject: Re: [PATCH] mac80211: fix panic when using hardware WEP
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de
In-Reply-To: <20080602115437.12734.42209.stgit@dv.roinet.com>
References: <20080602115437.12734.42209.stgit@dv.roinet.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RCuPpsl24HG5sCr3HTTf"
Date: Mon, 02 Jun 2008 14:19:43 +0200
Message-Id: <1212409183.4148.14.camel@johannes.berg> (sfid-20080602_144009_444678_FF45226B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RCuPpsl24HG5sCr3HTTf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-02 at 07:54 -0400, Pavel Roskin wrote:
> 57ccbb1cbe3f8e10a500ff8b9fb26dc1a542fe99 misplaced code for setting
> hardware WEP keys.  Move it back.  This fixes kernel panic in b43 if WEP
> is used and hardware encryption is enabled.

Oh wow, yes, sorry about that, and thanks for tracking it down!

> Signed-off-by: Pavel Roskin <proski@gnu.org>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/mac80211/wep.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
> index c9fd129..e7b6344 100644
> --- a/net/mac80211/wep.c
> +++ b/net/mac80211/wep.c
> @@ -335,10 +335,10 @@ static int wep_encrypt_skb(struct ieee80211_tx_data=
 *tx, struct sk_buff *skb)
>  	info->control.icv_len =3D WEP_ICV_LEN;
> =20
>  	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
> -		info->control.hw_key =3D &tx->key->conf;
>  		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
>  			return -1;
>  	} else {
> +		info->control.hw_key =3D &tx->key->conf;
>  		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
>  			if (!ieee80211_wep_add_iv(tx->local, skb, tx->key))
>  				return -1;
>=20

--=-RCuPpsl24HG5sCr3HTTf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEPlX6Vg1VMiehFYAQIPnhAAvif+QOnA1Mypdv5EsJ13E8RhOIL4bFXJ
c78ZlTPSi+GJpPIVwaqhijgYdH+znV0Amb9BvHjPH2GIc4+kvtZxURY/z4m2nwtz
UgTcZ93KLXvrga5L48czEBTsvfhTXNPLtPtx7kNg+1L6JT3+/1op45TzzNKfMT0d
Ryc8Ama5g4s8WuHzFqLDu1bghSmn9dtnApNHQ9bdNS68cXZsnu7ZmWL/f6bPpHXy
R3w0S3WFLz3+Xb5X0HLYE/gbgfBesk7UZXZJrpROBkNeNd5HDgJCXmFlr5fLXodH
mI+spt/6CfFXuqRhqANWdEfUBxe9ELvL3fuV8YvzJ3RzuUZx2c3dyfRYQ91OoPy1
deyKnSIrTmRP9Mb0BgD+PxJ9YovGbB9PyhYLvqdshkeRsOAtIYP4FRHTKC0ko5Lg
qs7Z4x5E1NiQyLewP5hHN9cfKsxw16H0kIPd3wF1sSMtXRtVqYgDIUEZRlMc9Uig
kcM+kGDMJBRrtQrIiad+C1yh9OcqBrFlDggogGL1RE4auaPbSaliSMWt0cyMwgCC
KLm9U37s7gCNhu7R29HIk7ZoVJPhJ6h95tCPdp4KGVcxiB7CU+ocdauCIZwPaI8m
uJdotABlmue9PpMF9WII2K8JsEFBPcA9SrONaTBcCJm1yQ+2SzUwGONTrgTnBxuF
Ho+71gRV1xM=
=FBlw
-----END PGP SIGNATURE-----

--=-RCuPpsl24HG5sCr3HTTf--


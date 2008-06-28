Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYF1H6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 03:58:35 -0400
Subject: Re: [PATCH 1/1] mac80211: fix warning: unused variable
	invoke_tx_handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1214612103-8389-1-git-send-email-tomas.winkler@intel.com>
References: <1214612103-8389-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jq5ydCVgfi+VTAqqNkru"
Date: Sat, 28 Jun 2008 09:58:20 +0200
Message-Id: <1214639900.5507.8.camel@johannes.berg> (sfid-20080628_095837_514442_086857D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jq5ydCVgfi+VTAqqNkru
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-06-28 at 03:15 +0300, Tomas Winkler wrote:
> This patch fixes warning: unused variable in invoke_tx_handlers
> when compiling without MAC80211_DEBUG option

Guess I haven't compiled like that in a long time.

> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/tx.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 345d6ff..a8c1809 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1110,7 +1110,6 @@ static int __ieee80211_tx(struct ieee80211_local *l=
ocal, struct sk_buff *skb,
>   */
>  static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
>  {
> -	struct ieee80211_local *local =3D tx->local;
>  	struct sk_buff *skb =3D tx->skb;
>  	ieee80211_tx_handler *handler;
>  	ieee80211_tx_result res =3D TX_DROP;
> @@ -1123,7 +1122,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_d=
ata *tx)
>  	}
> =20
>  	if (unlikely(res =3D=3D TX_DROP)) {
> -		I802_DEBUG_INC(local->tx_handlers_drop);
> +		I802_DEBUG_INC(tx->local->tx_handlers_drop);
>  		dev_kfree_skb(skb);
>  		for (i =3D 0; i < tx->num_extra_frag; i++)
>  			if (tx->extra_frag[i])
> @@ -1131,7 +1130,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_d=
ata *tx)
>  		kfree(tx->extra_frag);
>  		return -1;
>  	} else if (unlikely(res =3D=3D TX_QUEUED)) {
> -		I802_DEBUG_INC(local->tx_handlers_queued);
> +		I802_DEBUG_INC(tx->local->tx_handlers_queued);
>  		return -1;
>  	}
> =20

--=-jq5ydCVgfi+VTAqqNkru
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIZe8WAAoJEKVg1VMiehFYkDoP/jg0RiPWSwstv4HTMDT/Oorl
lovcvKwZjYpQ3kbXCziJnpDwlXyDrQ5qaxsjmDyhaGnBbLqqsglk53Ind8MQrAx2
4gvq3SXrXGiowJ8o+NG2ZXBeN1LSWEKCvy/uXbnPYanDm5OLjvshpzFViLJ2exNf
dT6WWqtj2lHLZ9j/4ex5Ez/LG9C0l+MpAp/u4jkE+eYc7l26USm9923Gtm3ndvz6
aB5MwnuNS9h6WsBRh9SCIe8c8f9cG+m8UU2T7Jdk7VAgGDCTLQ4T/1zps60Y8vGc
MmDFYEwjp9KUSVnNj3xtYcRQUzhhYh4veyzNn2L9hkaxYTCGYDsjFTzBqM79ZEEG
aIpYzqp622gf+6rxAJIGkVTS0YW9qbOXXVTfoKsALvmgBXxzWsPMaEtIRFudWtdR
VaHEvacz6BF13Dy5a0/eN28ubRA0sS5ypQ0tQGNuP50ZJvrmJ/6K6p1OhM/vNIck
ozpiUJITKwjlqBk/ZyDuBgno46hEWwM46+272xULor8E3FvLSQX0wIQOb/v2DoK9
QiDpcKZF9WMgl1LPGzmAHlSMYgLa+c70fh43qLxCHpOcTm33+l3j6Q8CeAWeKXXC
txc43FFb9Rokmx/cuL0eoNV2y6507bc8WiBB7Qh42kdcgvDS83h2cj4Yg0io3SGU
yAl9Y+oiZRdJUr2Lp0xZ
=KXzE
-----END PGP SIGNATURE-----

--=-jq5ydCVgfi+VTAqqNkru--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab0AVSp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 13:45:29 -0500
Subject: Re: [PATCH] mac80211: avoid NULL ptr deref when using WEP
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1264181989-28483-1-git-send-email-linville@tuxdriver.com>
References: <1264181989-28483-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V8qfxz27lvf1tCc39TE/"
Date: Fri, 22 Jan 2010 19:45:24 +0100
Message-ID: <1264185924.2593.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V8qfxz27lvf1tCc39TE/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-01-22 at 12:39 -0500, John W. Linville wrote:
> "mac80211: move control.hw_key assignment" changed an if-else into two
> separate if statments, but the if-else is needed to prevent
> dereferencing a null info->control.hw_key.  This fixes avoids a lock-up
> during association on my machine when using WEP.

Indeed, good catch, wonder how I arrived at that code.

johannes

> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/mac80211/wep.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
> index 0a4c641..5d745f2 100644
> --- a/net/mac80211/wep.c
> +++ b/net/mac80211/wep.c
> @@ -310,9 +310,8 @@ static int wep_encrypt_skb(struct ieee80211_tx_data *=
tx, struct sk_buff *skb)
>  					  tx->key->conf.keylen,
>  					  tx->key->conf.keyidx))
>  			return -1;
> -	}
> -
> -	if (info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
> +	} else if (info->control.hw_key->flags &
> +			IEEE80211_KEY_FLAG_GENERATE_IV) {
>  		if (!ieee80211_wep_add_iv(tx->local, skb,
>  					  tx->key->conf.keylen,
>  					  tx->key->conf.keyidx))


--=-V8qfxz27lvf1tCc39TE/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWfJBAAoJEODzc/N7+QmaBvgP/jQJ43N4FpnilW8sEEEQmF6Z
KkJzllevBDa+nrDzwY+0tfsoZrJWXf5yFAuhi9Z0eOWUlgv3TGvgT3iFIys7tZ6e
vZrXw0yBQwd+rXt5MK7XKMNyBqJZLCLjeUfLeHIPoPv3iQKV5n4ciIgrQr84qeIM
zlv/aI98p0uyz4Pfs71nDOB3G1d/cNDk5GzErrnvwhZTkO/d5BouvvHRxwM6qXPn
5c1+JMCy5e1AI85X17TFqf+T0x/KmKBUv1KufoAcdj9rgPkTpehZyXsiyWaWPoKi
ppGY92e1dWSq0ATzwrfGOukUHuTGiCARZcoR+5yuDdjHlNeWmS9Gs3C3Cx4+TfWA
KZ4FTnSou7+K+Aixnm+/9vy6Un1fZhkHgJ3XlJ638MWXAbxFz3hf93Lx+4a5WaKV
/zNlvER/F8+NwWBOW2nFbsISo1i0BcfwiFdnR/6WMRFbL4acXs2zWl+DUu2eh0o0
ISkkKeMRUi/ALzRgiCTEHGUzYNec5R9MChPz6SqgJxYerQu20DeZP8YpQHSCtZSu
oPE+oQizGrmhGyx3e/kDEnRhfpIJhGgF4HfRsWhmDMds1eTVIXYdAq2l/nQAQkbf
FYiRoJst8yYqc1g7SmKS1eRJUEk7XW6fquiulLuujqC3mvwtur5N00mWcxg2U9ye
fjYkZlAQi4N/Rb63nW7X
=DVri
-----END PGP SIGNATURE-----

--=-V8qfxz27lvf1tCc39TE/--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43012 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0BOJYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 04:24:19 -0500
Subject: Re: [PATCH 2/2] mac80211: Fix WPA-NONE for RX unicast frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1266190346-2247-2-git-send-email-benoit.papillault@free.fr>
References: <1266190346-2247-1-git-send-email-benoit.papillault@free.fr>
	 <1266190346-2247-2-git-send-email-benoit.papillault@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AD1Sl/3Xzb1cUSqHaPac"
Date: Mon, 15 Feb 2010 10:24:16 +0100
Message-ID: <1266225856.5290.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AD1Sl/3Xzb1cUSqHaPac
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-15 at 00:32 +0100, Benoit Papillault wrote:
> This patch might have side effect which needs to be studied
>=20
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> ---
>  net/mac80211/rx.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 22ae6ee..f73fe9b 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -923,6 +923,13 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data
> *rx)
>  		rx->key =3D rcu_dereference(rx->sdata->keys[keyidx]);
> =20
>  		/*
> +		 * Using WPA-NONE in IBSS, all frames, be it unicast or
> +		 * multicast (including broadcast) are encrypted with the
> +		 * same group key. In this case, we should not reset the key
> +		 * to NULL
> +		 */
> +#if 0
> +		/*
>  		 * RSNA-protected unicast frames should always be sent with
>  		 * pairwise or station-to-station keys, but for WEP we allow
>  		 * using a key index as well.

#if 0 is never a good idea, and that code is certainly needed.

Don't send bad patches like this with [PATCH] tag please.

johannes

--=-AD1Sl/3Xzb1cUSqHaPac
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLeRK8AAoJEODzc/N7+QmaqjoQAIkXVHbGBzbRPPqyIYB+Ihqh
AeKwzNFDCWxG8Aw5YEn2oRvNqxtOpk5/Bfr+eIQ/ottG7Dob9O7JoAKGJizw0utL
E8zlHqq2J3DM0ROsQ+WSeWMGo01vBYND11d92fRww4xH3fC38WwQ3byprPsZITCP
WyEpnlVEkpOBmK7tVlKIcUUuQNfjNNBBbKO39BDPmz9//KVF6LBrclPUBJHdVPB6
ZsGqSb/esAbPZhIoxg1suXv1eAyWrE2PVVTFwZTwR02pI9H6jn4gSEBXNNzRQ4+y
a1EgarZ27w9IM8xx7UN1DWPFxJlm0qF2zQ8a5F4k7NIiZFWnXJnNQHgA91zGqvgO
ur667eOdphsQ1Id6YCR9vzNKbNWxpN4z+BdCfn89Pccj2kdDcV8wYswET4D9lg4s
+0Oc/Sn/2yDRh5JGGzwpfyElGFUWQNhuNjvFAkXPWN95yoLrRPRQDdLax0nr6cYc
ZbPBVGxt9n3+2buwE3UBsp61phRsK6jviS4Is0ci7pkg7d4l+csmPfbL9fMNe5Oq
as8jl+kcBxsEj9QK9W2iN69nvn2CESVls9MlG1MVT5htqyOmWu8HWb6NeRC2btyl
MWXzUSR5jVT+5ctHt8hYpCmBgWJ71azg6hH6r399BCbMwsEhH54Ywqt1hOCJFHhm
6DRLs/+fdNDIkQqh17cO
=pP+V
-----END PGP SIGNATURE-----

--=-AD1Sl/3Xzb1cUSqHaPac--


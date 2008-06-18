Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42124 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYFRKSo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 06:18:44 -0400
Subject: Re: [RFC PATCH 4/7] 802.11w: Use BIP (AES-128-CMAC)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617155920.329586297@localhost>
References: <20080617154008.883383150@localhost>
	 <20080617155920.329586297@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oOVChcikOi2NPoT07q0z"
Date: Wed, 18 Jun 2008 12:17:48 +0200
Message-Id: <1213784268.1312.9.camel@johannes.berg> (sfid-20080618_121848_237156_E295C392)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oOVChcikOi2NPoT07q0z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

One more thing:

> +/* Get the BIP key index from MMIE; return -1 if this is not a BIP frame=
 */
> +static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
> +{
> +	struct ieee80211_mgmt *hdr =3D (struct ieee80211_mgmt *) skb->data;
> +	struct ieee80211_mmie *mmie;
> +
> +	if (skb->len < 24 + sizeof(*mmie) ||
> +	    !is_multicast_ether_addr(hdr->da))
> +		return -1;
> +
> +	if (!ieee80211_is_disassoc(hdr->frame_control) &&
> +	    !ieee80211_is_deauth(hdr->frame_control) &&
> +	    !ieee80211_is_action(hdr->frame_control))
> +		return -1; /* not a robust management frame */

If you reorder the code a bit, you can use the helper below here as
well.

> +static int ieee80211_is_robust_mgmt_frame(__le16 fc)
> +{
> +	return ieee80211_is_disassoc(fc) ||
> +		ieee80211_is_deauth(fc) ||
> +		ieee80211_is_action(fc);
> +}

johannes

--=-oOVChcikOi2NPoT07q0z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWOC+AAoJEKVg1VMiehFYCx4P/2ygf61bdPemqSJpyO55ZhxP
WPW5eil7Iu48EUgXOp3yrLMQ7fPEV/6HglCwT0oGnSfIvUEiwZPliI0ggQAmGC+Q
9BJsBGq7QJTWrZbR2w8cNnWPZ3dyVlbHpXYIBqXzW5qF2m7CbOhnZeybVgBjystQ
KSBLdptKd74BlPtLheFmCcqGhXtnVGhDk4w5kvtHaYz9Hyszc8hb/3i0wPguZHiG
6RRrjg4anPgk4NfGx+1il3vj2gpsfifI1bythpK6yKH8DjYXjAlB8v+t2e88C/K/
34sXwnZKN74s4tzwxQJmFFbcuCqun+qLk69ELFgiAoU8JUULOJmcuo0X+6HkHxhV
ql0tM0bvgK5KpJg2ixDJ0EaTPUlQKCfID7mDp3VYYNLG5fqPxXL7l99fp7uqtniZ
z46BK1aATjzjjuVzVGefXMjZSS98UlR1kExlKAshkv8TaKJCtBpM9JLBiT/OkXBZ
iLxdEx9aZVx6M1Y+r7yjcLz+nESFsquDIxCZogyzv4uLxTDzsy9Az7Ijy6XOQz4w
BmfW1qN/AoHTD7BwZgd628puFYHMkCaxF2yfl8gcGqqKEwAGGdDKyyiCYXCeUVTy
c0ONuvjGbN1YZYWDyVGPhHSeS6eUd6TYyqZ7T+MIxZKWHOUPjXTJjcrC9UnT/vBA
wFmJ5ziXpGU1vaQo6E3r
=cdy+
-----END PGP SIGNATURE-----

--=-oOVChcikOi2NPoT07q0z--


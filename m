Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYBKMXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 07:23:03 -0500
Subject: Re: [PATCH 05/13] o11s: added mesh.h, mesh function and data
	structures definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a78274.12025a0a.0fb8.67db@mx.google.com> (sfid-20080204_212415_776178_13DE2F2C)
References: <47a78274.12025a0a.0fb8.67db@mx.google.com>
	 (sfid-20080204_212415_776178_13DE2F2C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-J8IDL8bDHjHL3qTS4EZn"
Date: Mon, 11 Feb 2008 10:21:22 +0100
Message-Id: <1202721682.11481.37.camel@johannes.berg> (sfid-20080211_122308_403660_F2F8A22A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J8IDL8bDHjHL3qTS4EZn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +/* plink is short for peer link */
> +struct mesh_plink {

Looking at this structure in more detail, a few more comments.

If you group "retries" and "ignore_timer" the structure will be four
bytes smaller (each of them uses one byte and is padded to four in the
current struct layout).

> +	struct ieee80211_channel channel;
> +	u32 channel_precedence;

These don't seem to be used? I was about to suggest that channel should
be a pointer instead of a copy of the data, especially since the
original data can be updated by the regulatory control code.

> +#define plink_inc(s) 	atomic_inc(&s->u.sta.mshstats.estab_plinks)
> +#define plink_dec(s) 	atomic_dec(&s->u.sta.mshstats.estab_plinks)
> +#define plink_capacity(s)   (s->u.sta.mshcfg.dot11MeshMaxPeerLinks - \
> +				atomic_read(&s->u.sta.mshstats.estab_plinks))
> +#define available_plinks(s) (min(plink_capacity(s), MESH_MAX_PLINKS - \
> +			atomic_read(&s->u.sta.plinks)) > 0)
> +
> +#define activate_path(mpath) (mpath->flags |=3D \
> +				(MESH_PATH_ACTIVE | MESH_PATH_RESOLVED))

Those should probably all be static inlines.

johannes

--=-J8IDL8bDHjHL3qTS4EZn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7ATkaVg1VMiehFYAQLIUg//d2LS/oSvzmtOWXcpu7eSsfdYw7l3eog6
E8EImTwrkDvM0KQVeDlTE4RB5DGTy9W1vYsJHvZZ7Kw2olN8xek2gWD8sg1VaTN8
8kd6xzMm+mxVu2Bg4VdRvg5YVY1GuDt0wY4budxD9Ibi6bxXXOyORhW1+dNfqyDR
hs6a7MGRci87xVF/P4wkHCVhPKAyX2PLkSP1+PKeLeP6gKZEWVNJ1VF0Hsebdk5v
LWBILeloxdZ2G8D7RlySCePF2dn7Ua1YFiSF3sweF5ZTlAPZG3CVXJHHArdP4MbE
qAtdKQyVoqd4SqoXXwBfJNVsz0zQmMnT1GoRbk8QP+D7MCKXSkQubgHx4VgjH2ya
mrt3yFQD6y4aH1IosNWBbPAkGFMDIsTg5eEv7Y82jKloHUvSHDJT1QHOwu625MoC
ftNObNXUcDIUUHVaaCVfEYfPWzY2dJ+726+WkqHTzts+h3K3/lN+dMe+en8t1S3e
W+wTTmBWEgbhghXo8EoBAwbr2tuYx1k4io+vbghMxTvyTVf4NhnKHmscF6Kn5+Vd
/qBfdCuBpU1NvCQZv5GH5q7AX4tKxRHqRwOfxXTu9ftlckjokpmbwlxuutgFuGG4
XotTvr8Py+z9TtO3PbQUe2/Yxngniy0GcNjt0syQ4M6DU7Uf89ujCdB9WsEasj38
t7YLAhVHOPc=
=DJ04
-----END PGP SIGNATURE-----

--=-J8IDL8bDHjHL3qTS4EZn--


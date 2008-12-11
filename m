Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbYLKRDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 12:03:36 -0500
Subject: Re: [PATCH 1/2] mac80211: misc cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Vladimir Koutny <vlado@ksp.sk>
In-Reply-To: <eb3ff54b0812110400y2305c5abp9955a325b3372215@mail.gmail.com> (sfid-20081211_130026_587546_9D11E66D)
References: <eb3ff54b0812110400y2305c5abp9955a325b3372215@mail.gmail.com>
	 (sfid-20081211_130026_587546_9D11E66D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Jrnie/sTZN0MoY3z+9G1"
Date: Thu, 11 Dec 2008 15:28:23 +0100
Message-Id: <1229005703.8081.12.camel@johannes.berg> (sfid-20081211_180339_897731_F9B98626)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Jrnie/sTZN0MoY3z+9G1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 14:00 +0200, Rami Rosen wrote:

> -			rx->sta =3D ieee80211_ibss_add_sta(sdata, rx->skb,
> -						bssid, hdr->addr2,
> -						BIT(rx->status->rate_idx));
> +			rx->sta =3D ieee80211_ibss_add_sta(sdata, bssid, hdr->addr2,
> +				BIT(rx->status->rate_idx));

Unrelated to this patch (it's good), shouldn't we take into account the
mandatory rate set here? If, for instance, we're receiving an 11MBit
frame then we can be sure the sender supports 1 and 11, and if we're
receiving a 48 MBit frame then we know already it supports [1, 2, 5.5,
11 if 2.4 GHz], 6, 12, 24 and 48.

johannes

--=-Jrnie/sTZN0MoY3z+9G1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQSODAAoJEKVg1VMiehFYfyMQAMOFRFXi4JVoOemNqq84y3Ql
bq5z+QaVvN4TcAnfvxxzes04eKNEBG7StFlr9Vfsd3ZP7P8nz0GS0EwRe9EUQqA3
g4iF65QGHkk8eT5CGB7kPKra7Bc/rqmfvuzbK5NwycYAzvv3JZXedCrYRAOhcFLp
6R0eQQMJgK8DZp5mdQB4y+XPnP5rgbx8Gl5yzvLLSrtJjigVcsKzeqMaO8Q2junU
o3EKVZV9ZvSfqFz4/tpi8B2tvcvp6Tvoa/csl6rqNK2h1OEKx8H5cWHEZsCuPZ5a
IlutkvFkFWKty80w3gNmgOmO1aByLKZ17Gud4rYEV2OYVPFrtHvcA03XlSJP3c7g
u3zQ3KdOjP74O/VVvw57nTCGSbez1FKwOsVME95zTRKhdgamEzhacZyR9QKKUE7z
yvf6r/kVjqo9AaHer98Iuli17xHc6ACBxUTZ2/qO4hbTW47fw/CdiASMiKojzAhS
AMrRYX3rtvtrQ0d7Q6N+A1ppFucJmTfzyF8dfXfKBTO6uhY8ztLfXen+NYtH6+3Q
qPh7jD3aZBfQTs8XfiZCuV9E9iXmOOppJl3rOFZFKlxBNM7xvOs3ZY47a0pZKsmS
NmN3c5oa4RdbX0BsHAmR8YtAYK8RzML1ELDS5QKVpSaEsCdGcWZzEBlZAQQfE01I
KVt4fkYdTkLz9+f07Ctw
=0Pux
-----END PGP SIGNATURE-----

--=-Jrnie/sTZN0MoY3z+9G1--


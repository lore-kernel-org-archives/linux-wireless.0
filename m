Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54029 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYIKNXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 09:23:13 -0400
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <18632.55008.411078.289830@gargle.gargle.HOWL>
References: <20080910220145.707263000@sipsolutions.net>
	 <18632.55008.411078.289830@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+nATz7pNlnJ9STuJKOwG"
Date: Thu, 11 Sep 2008 15:22:31 +0200
Message-Id: <1221139351.6986.26.camel@johannes.berg> (sfid-20080911_152321_192695_3F0A6C6A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+nATz7pNlnJ9STuJKOwG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 13:59 +0530, Sujith wrote:

>  > I'd been talking with Sujith about this one:
>  >=20
>  >  * mac80211: share STA information with driver
>  >=20
>  > and decided to just do it; as it stands it's not very useful
>  > but I expect it to be used soon, if not we can remove the
>  > EXPORT_SYMBOL again.
>  >=20
>=20
> This would be very useful for ath9k. Making use of the
> private area for each STA can enable removal of the node list
> that is maintained currently.

I had actually tried
(http://johannes.sipsolutions.net/patches/kernel/ath9k-sta-node.patch)
but you're using refcounting for the nodes while mac80211 RCU-protects
them, so I didn't get very far. It needs a bit more effort to make sure
you don't have node pointers stick around in some tx descriptor after
mac80211 decides to remove a node (which may very well happen while
frames are queued)

johannes

--=-+nATz7pNlnJ9STuJKOwG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyRuTAAoJEKVg1VMiehFY3j4QAJfzbIQQbZacRrjcaNUkn4dt
8ItWQ366x0V/huaEcJ42Nss3BC9B1M3dh94aeyMBwEjmmaCON6k8EB1NYnpmy2hT
8DCSNLJDLjFVHedlJ0T9Z9GKZ9wOySSQGPtj7/2kCDuZWNwHafIt1FmOVjYcD5PC
b7Djrj5hPriboCNIf/AQ7cl97ev9L93qQo0r9QqIHGUOnBwVSyb+MoxnVwbRTc6m
7TmOvGQ+/BONUiAMGiRP2rno8DoYZxiIRISKPKGfU5xNjx5V57G+wFsgd6AM8LQe
HBcu1y2K5WNgmTwsPgEvgOfGgEGCLvEIqcIPtNncIf6Bk2WbXNfqeYwmq3HecZaE
1Gkbdy8XYDh2cY24q8dT9LdWs6sPTw3Z8HDwCxh4qNAs+LhxAyaVBznpaUgyz2fj
AbBxMYL9S/I3xv85g/FBUJPgrGk9FdUDCpfDMUWdsMBpLmE+3AlUPO+jYbu25beG
RnscmvS15M06nAr4hLtlqKjuzf91epK4XUPkhbMfcwKIKXp+3R0EZ5p+1fGa0ojR
frnJVRUKwUszNCOCWcVXQ87vsbuFRw9NCfbhMqRW3AxrJ7ABx8ZFph7fq0seqqQN
o3A+T2+qNP/zXGfW7kZxtLG0i58dQO5OAvF7KHVEiJ3JVRkGjk/0bdIg5Y3AqMAc
1rSZ8+eh1+NdviQ4MSlM
=um7K
-----END PGP SIGNATURE-----

--=-+nATz7pNlnJ9STuJKOwG--


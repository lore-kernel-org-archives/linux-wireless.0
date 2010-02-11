Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0BKI4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 03:56:11 -0500
Subject: Re: [BUG?] ieee80211_ops.remove_interface() being called twice
From: Johannes Berg <johannes@sipsolutions.net>
To: dsaxena@plexity.net
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <20100209202421.GA31240@plexity.net>
References: <20100209202421.GA31240@plexity.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KV8WubuVUIM16O3wuDhr"
Date: Thu, 11 Feb 2010 09:56:07 +0100
Message-ID: <1265878567.5679.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KV8WubuVUIM16O3wuDhr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-02-09 at 12:24 -0800, Deepak Saxena wrote:
> I'm working on getting the libertas_tf driver on 2.6.31 working on an
> XO-1 laptopt with a USB connected device and running into the
> following
> situation during a suspend:
>=20
> Upon initiating a suspend, lbtf_op_remove_interface() gets called via
> the wiphy_suspend() path:

> Later on, the USB device is removed from the tree and=20
> lbtf_op_remove_interface() gets called again and this causes
> an OOOPS:


> Following is the code for lbtf_op_remove_interface().  Basically we
> set=20
> priv->vif to NULL the first time around and then we crash on trying=20
> to access priv->vif->type the second time around. Easy "fix" is a NULL
>=20
> check in lbtf_op_remove_interface() to simply return to caller=20
> if !priv->vif, but I don't think the remove_interface() function
> should be called twice.=20

Indeed. mac80211's removal logic should cope with interfaces that are
suspended.

johannes

--=-KV8WubuVUIM16O3wuDhr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLc8YkAAoJEODzc/N7+QmaWjcP/A4wNDJwG5Y65GUul68NQ7/K
208qZGBtEt5UIJqoDR9E3fMzwjhlBLOJLPNMK2f+suiS4iCX+42XDA/T1Q1UtvDy
gF5M/vq7LFsmDZatfYOGJe5EOV0gekYpwe075LWVaaayb4ht8tLerErHOvKoPJmU
RuYQmmtBjBItHJsG0QLbxs6TbREiS4Bmm7pueWQAoQpQfXpaHaEvYTmWkBIG6YZI
mAg81zHn0ssun+yFeXS7aWeBqGaNJe6gEQeZPKK/rhLIYvzCvsbEPseyg0GuWOaF
Bb9IZMzQiSpaCv0+nEZ7SC8OTgs7STlNduQNrU4j/iPvfnfeHJxj9NHNJsH3N0tv
fgtlXQlhzT2VXSK1YuyIe6SRWZUeA32MLthsHHILG1ROLDb1/cmyoDmoxo7tPPBW
j2rlrIeisO0lxDXwTxAK7IKuGbtq9lebnMfs4H9yTIvzGSlBycjsQxlLbgDVMWmc
hPl0EpArcB8+avsYl7zSrDkSPNRy+fAIuWKy41z3XWRWP8EBhv1GIZpRvoX4hean
I8O89uDvAokKM5sPgMTjEdygAbE6mmRay3ogWepTa/fuYXCJ1PlJyB5c9d0CrxBg
aVtnOsy81bEW0/CHJVmpzxYdXqWxbO0IzYEVlIxP15lmeFU+rkwOiz5QQNxkiesz
LHVM3L2PRFULrMxp4Gv8
=SbQv
-----END PGP SIGNATURE-----

--=-KV8WubuVUIM16O3wuDhr--


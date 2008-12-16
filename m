Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756AbYLPPBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 10:01:39 -0500
Subject: Re: [ath5k-devel] [PATCH] ath5k: set mac address in add_interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f0812160658y5ed2ceb4qdbb4b2ddf1fe07a5@mail.gmail.com> (sfid-20081216_155826_911157_CE1A0E9E)
References: <20081118044037.GA18983@hash.localnet>
	 <69e28c910812150747j60cf17d9nc2e24aabb991d2a9@mail.gmail.com>
	 <1229357080.12163.47.camel@localhost.localdomain>
	 <69e28c910812150812h4a316327u67aad1b225262816@mail.gmail.com>
	 <b6c5339f0812150916k521fa7a4l4fc3aa560d08c1db@mail.gmail.com>
	 <b6c5339f0812160658y5ed2ceb4qdbb4b2ddf1fe07a5@mail.gmail.com>
	 (sfid-20081216_155826_911157_CE1A0E9E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E9u5+sF9lXHfyztjA+OM"
Date: Tue, 16 Dec 2008 16:01:09 +0100
Message-Id: <1229439670.4471.41.camel@johannes.berg> (sfid-20081216_160143_242157_2D2CC840)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-E9u5+sF9lXHfyztjA+OM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-16 at 09:58 -0500, Bob Copeland wrote:

> The code, for mac address setting at least, looks to be working as
> designed: the mac address is only set up at add_interface time to avoid
> automatically acking packets before an interface is brought up (see the
> kerneldoc comments in mac80211 on add/remove_interface).
>=20
> The ath5k rx filter for unicast frames requires mac addresses to match in
> order to accept or ack frames.  However, in monitor mode, mac80211 will
> never call add_interface().  Instead, it should configure the filter to
> put the card in promiscuous mode which then should enable all packets
> to be passed back to the host.

FWIW, this is as designed, if you need to have ACKs then you need to
bring up a monitor as well as a regular interface. Stefanik, please do
that and report whether it works.

johannes

--=-E9u5+sF9lXHfyztjA+OM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJR8KyAAoJEKVg1VMiehFYMF0P/3MYgcOVjSa+ckbT9E8uNkWf
9i8E4Eo6nHNoeZ8aVLSti4ab2stz3vaYU8CfHwBmwPM1O75rACLSsScW8oXGMmHZ
W2MsUcSiJlCI2uEmY7vTkwjPY15i5gBSOpw2JC7tpTPSe198RDeC/7/YLwmv8UVf
6Dsd8WdxO3OaL63ap/O1Im3Fw8bFrCZbnZaI1abNnaZeeKwuh7m/X5TCUtQ6fX+m
AVyD82aKRLmR2HSjXtr7MNntEP0se9MGuxABj4NvUWggG6sdXr4CrLYtVsl6kCIK
ptuVo+GTaFBOUJaCPR1GTt9nEi3gBg3xCe0iOk9ybbHbZwndAc2Cxy4qDUGCisIn
B2uQnRhxNZWOrRpsc73tY7TnNHp8amX691oNITgF5ax8bY1bWoauv237E7mnDFGt
dm9bMzogYeEFP+2auvD1s4cw1wTjqMkEDVxVhCUeB7iIFpQBtuBf1qZ7w5SMIbdw
Rb/EqvHBsoIFenoZx3cYP8QPof4+WOlf5dBbGn8HkAtMmWOSxRlgGSzHbQEQ/akg
uHBCdRefYQSzaoUjaiqVLsrmG1gVlIWTKphh1wF1u8alLCzZ1DjQeSk4Cmo6DdIz
n648YdZ2XRmm4wxBnHwiIom4qOdHi5gxj8IOBznOKvrpuuvQqIxUuuO+v03EBjqE
lu3v3az3ZFKTwsvw5jJR
=YaJE
-----END PGP SIGNATURE-----

--=-E9u5+sF9lXHfyztjA+OM--


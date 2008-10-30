Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbYJ3Olq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 10:41:46 -0400
Subject: Re: [PATCH for 2.6.28] mac80211: fix basic rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810300739m69ec943didc1d76b82da7f1e5@mail.gmail.com> (sfid-20081030_153906_383488_ABE5D808)
References: <1225300446.5439.27.camel@johannes.berg>
	 <1ba2fa240810300623o51dbd0a6p7a7bc89795dc5d35@mail.gmail.com>
	 <1225376692.3690.46.camel@johannes.berg>
	 <1ba2fa240810300739m69ec943didc1d76b82da7f1e5@mail.gmail.com>
	 (sfid-20081030_153906_383488_ABE5D808)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/b9cdf8o1DEj57klEGXy"
Date: Thu, 30 Oct 2008 15:41:40 +0100
Message-Id: <1225377700.3690.53.camel@johannes.berg> (sfid-20081030_154201_011897_A533CACD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/b9cdf8o1DEj57klEGXy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 16:39 +0200, Tomas Winkler wrote:
> On Thu, Oct 30, 2008 at 4:24 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2008-10-30 at 15:23 +0200, Tomas Winkler wrote:
> >> On Wed, Oct 29, 2008 at 7:14 PM, Johannes Berg
> >> <johannes@sipsolutions.net> wrote:
> >> > This fixes the basic rate bitmap calculation in mac80211.
> >> >
> >> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> >> > Cc: stable@kernel.org [2.6.25, 2.6.26, 2.6.27]
> >> > ---
> >> > Is this appropriate for stable? It's a trivial and obvious fix, and =
can
> >> > throw off the duration calculation, but it's likely nobody will ever
> >> > really notice...
> >>
> >> You would should fail association if one of the basic rates is not
> >> supported  by the station
> >
> > No, this has nothing to do with association, it's just setting the
> > internal variable about which rates are basic in the BSS.
>=20
> I understand that but What your patch is doing it is preventing
> of setting basic rates for ratest that are not sported by the driver,
> but according
> the spec it is not permissible that driver will not support one of the
> basic rates.

I don't understand. My patch is simply fixing the basic rate bitmap
calculation. If we don't support all basic rates then the AP shall have
denied the association, or we probably didn't even ask it.

The current code there is just wrong, it will always set _all_ rates in
the basic rate bitmap rather than just those that really are basic
rates.

johannes

--=-/b9cdf8o1DEj57klEGXy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCcegAAoJEKVg1VMiehFYlhkP/j7JaXBbd/sGEAPlrPBcgfrv
pALowKiIONC9MWcja3TBY0tlruYWC1gk/QSTCj2+syysGWhPFNZ+VkZwj/WjgaJe
YbUeGLqUzu3IZ4G+fjp9muXkRg3VD/OROC/BnpzW04SAFSSVf84k0rSkOEzNUrH0
EduQQpJdb9P6W87Aqzox8rDBBtjUwdAHTUy1eLyQtmbsE9aUciHOQcOhzq4rwDDK
8VyLoJBCFHFoOXMOGC+vpU8Lq6TltUnbnmEJDHa96qvqKy/v6yZihW1Owb8u9afx
VyFNshjUVyX9a0xhdPrHuqqKh4c/ROpmfjOsrMsDsdtez64a54wfzAxRt3nZn+cU
N46+alBmeIMSrkDM0FomVgcuZHpVwP66QeVtDA1Kk4+5DW2Dzej3zV41Lm68A/6y
rWzPXA/IFBjtwxS66rsherZVwpLCnWt3KXxTOAes7TX/C5r+fUO2GL+GQj781xBA
PTTiGubHxkwvcAh/yR0AFu6NhTwHUFsBIvENzZxzgkRc93L1Ar6037VKphJjMYp/
1CTReuPvN0tKAfRdgYoeBVYwhXdsam1EueaYn6mXcTktLXFzHXDL57WEv0Cnydc2
0QYQryVIjb8bUNNdFa9fVwGhYmatm+mSfJzH7bdkmrGz+ppN0csEt5rbFFj4Vee7
VRZN8M5amHx37Vw5G6PK
=z4NA
-----END PGP SIGNATURE-----

--=-/b9cdf8o1DEj57klEGXy--


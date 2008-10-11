Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbYJKAz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 20:55:56 -0400
Subject: Re: [PATCH] mac80211: move bss_conf into vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810101749k5d053451kdaef3194a954b442@mail.gmail.com> (sfid-20081011_024943_373346_968487FF)
References: <1223682711.29811.7.camel@johannes.berg>
	 <1ba2fa240810101732y610b4cc8g1b914b2c8eb726e5@mail.gmail.com>
	 <1223685820.29811.23.camel@johannes.berg>
	 <1ba2fa240810101749k5d053451kdaef3194a954b442@mail.gmail.com>
	 (sfid-20081011_024943_373346_968487FF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rT50PcekfI/5bvcOBFgw"
Date: Sat, 11 Oct 2008 02:55:53 +0200
Message-Id: <1223686553.29811.30.camel@johannes.berg> (sfid-20081011_025559_406223_8B819614)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rT50PcekfI/5bvcOBFgw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-11 at 02:49 +0200, Tomas Winkler wrote:
> On Sat, Oct 11, 2008 at 2:43 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sat, 2008-10-11 at 02:32 +0200, Tomas Winkler wrote:
> >> On Sat, Oct 11, 2008 at 1:51 AM, Johannes Berg
> >> <johannes@sipsolutions.net> wrote:
> >> > Move bss_conf into the vif struct so that drivers can
> >> > access it during ->tx without having to store it in
> >> > the private data or similar. No driver updates because
> >> > this is only for when they want to start using it.
> >>
> >> What protection should driver take to be sure it won't be changed unde=
rneath ?
> >> With prive copy you know this is changed only in bss_info changed is c=
alled.
> >
> > Yeah, that's true, I guess you can only access those fields there that
> > you can access atomically. That's actually most of the fields though.
> >
> > Also, we don't actually take care about locking this structure at all
> > even in mac80211, something we might need to think about.
>=20
> When working on SM PS I have the  same dilemma I have with
> ieee80211_conf do you think I need to take a private copy of it?

Well, what do you use it for? If you absolutely rely on it having the
same value, then you probably need to do that, but if you just use it
then I don't see why you'd have to, unless it's some value that can't be
read atomically.

johannes

--=-rT50PcekfI/5bvcOBFgw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7/mVAAoJEKVg1VMiehFYl00P/AjKkadUeK6mSqXN+O67KaxV
wLp2lBzcAvhhSQTi1AuSnuaOVguVDsx8cKIZdPtDAjTbgzrKLeKHCDhFzLsK6DZd
ELnNDBLrlKvIfdhYVL3M+4C+J/+QUAkwf/dLikVuUc9lZQvbpW/WPL+dUKRFaOLy
JWtFQ+qRQs1/eUjLdSuDUDvueL/VR9jnjvPbYfMnDapUsl95axVt1GHmD9o3vWPL
nwlhOPH9C+fWOmBxdCeRKwr4aHWcSNQB8xujmVVA/aqflcutSdVxtHh8peQ22PLB
CDDv8Rmnh7PkeY1iVy3hGGTYSb8148OfJGgD04P95QnrS8zVi7rvsiwY/bW3y1Gn
C0u/z9Edp/0d0h5qaCnY5oVJyJioHo60RSQlc/Z59C+16L728NBD0N+p+AXBo7fg
QaZEXPOlH8NYze5yidAIjRX4WadcN94F0E24p5Z/lJz2BVgb/YPLdKBTwD+FR5vO
MFtuEkmCEuHmy7e8BOG9iEXlDyZ4cpeQZTp+TPJSGbiTSw/KEtr43yZOYqAQ3nia
0ZI333AHlM/q75WLZxOw/z6Jgq6SJCGhFnDNcBAJ8K4XwyJs6Q/YgtLHPXppmwBn
CWSsfPflFQoErz2oowi/LsMFnonX9EW+btd9yPWzwn/6opmuRkjlsjeGSE4zXT3P
lCzIKwFxkpmfPnMI+UGa
=d79S
-----END PGP SIGNATURE-----

--=-rT50PcekfI/5bvcOBFgw--


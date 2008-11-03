Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbYKCIFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 03:05:22 -0500
Subject: Re: wireless-testing commit
	eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	tim.gardner@canonical.com, mick@madwifi.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890811030001x7a3b166am440873fcf2c143d4@mail.gmail.com> (sfid-20081103_090117_991216_F03C9222)
References: <4908B754.1050400@tpi.com>
	 <40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com>
	 <40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com>
	 <20081102184146.GA6065@hash.localnet>
	 <43e72e890811021249x6047b38do5d7ead10fe4098e7@mail.gmail.com>
	 <1225696692.3619.18.camel@johannes.berg>
	 <43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com>
	 <1225697686.3619.25.camel@johannes.berg>
	 <43e72e890811022351m2c03e0b4g2a67a70cd6a7bd3c@mail.gmail.com>
	 <1225698867.3619.31.camel@johannes.berg>
	 <43e72e890811030001x7a3b166am440873fcf2c143d4@mail.gmail.com>
	 (sfid-20081103_090117_991216_F03C9222)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z1rd5bTeEDsiSsZWpt8C"
Date: Mon, 03 Nov 2008 09:04:42 +0100
Message-Id: <1225699482.3619.34.camel@johannes.berg> (sfid-20081103_090527_287036_E4651888)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z1rd5bTeEDsiSsZWpt8C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-03 at 00:01 -0800, Luis R. Rodriguez wrote:

> > But you're saying it's "normal" to get this failure,
>=20
> No, I'm just sayings its possible, right now mac80211 assumes its not
> and if it does its because we somehow lied to mac80211 of our
> capabilities.

Well, yes, sort of.

> > so wouldn't it
> > always do that sooner or later and always say your hw is broken?
>=20
> Nope

Why not?

> > Also,
> > that's a bad thing to do in userspace, imho.
>=20
> What should we do with these rare failures then?

print an error message? ignore them? try again?

> > hw borked is one obvious case, but it shouldn't happen enough
> > for this to be a problem yet.
>=20
> This I agree with. It is rare, its just possible, right now mac80211
> assumes it never will.

It's _always_ assumed that by ignoring the return value, now it's just
noisy about it because clearly it doesn't like when the driver fails to
do what it wants since then the hw and sw states get out of sync. I
really don't see what to do other than retry maybe, but that might well
be done in the driver instead.

johannes

--=-z1rd5bTeEDsiSsZWpt8C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDrCXAAoJEKVg1VMiehFYiWIP/24Uic7JTkLvN9g7aXEZfsCG
fbZM2YObJytlwRLtqk20vccHDXc0k+SPYjuju0ff8goPHoNV57GUlRehpp3CRZCy
lOqpdJzOvH281LitdwAFS8R1QKnYm/sqqyP3yy2Rq4CuPkP9i/+GIOXwcckROYYQ
u+Me2pKPCmz3AvONeUGyeJs6SaTuFgzRX+jK47aU4cDRwUjmIMb6tIY8oS0HLG9B
PoE4hRPshkzG2AeXwgUFWyBwsVoMmhVQDf1Rji2C7E0J7TiFxu9Ncm6UGynfBzD7
XXox80H9w6Bj63FvzjTbhCt8rO7M2Fiv07amz61c9AqzcyNTfyy4PdCpWrumL14M
4Nb0TSomUWG5DBCrRts9RbgB/plGyRqp3qQkw8U04JrDZzOaQemM3vRLhhcM19/2
cfSOsbghP45kQplCSqODZ0BC8Y8ehvnZ9jnblio914xP/ftas/4XJhfvuLt9Pwxv
ke5s0o4HsVwY6sJSWSZ1nfVHcVZzEm4lnwGBWCtxLK9A29pJ7JvGury7P3+cVAYo
3iZ6zCZra5hc7jlH7xQLNcHXEYe5EKGLg0Pbmy4rreeBS6//IbFnXvTUbc8V7d38
x7CuFwySMlNf+Rm2+ZFfFBOoeg5XtjoXJp3uAwTEPZPPeR0D5KTFihXSHYwbQa5I
qsJt5JiVBUH2bT9OqjEh
=4Fwe
-----END PGP SIGNATURE-----

--=-z1rd5bTeEDsiSsZWpt8C--


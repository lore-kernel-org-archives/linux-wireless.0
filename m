Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbYKCHzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:55:06 -0500
Subject: Re: wireless-testing commit
	eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	tim.gardner@canonical.com, mick@madwifi.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890811022351m2c03e0b4g2a67a70cd6a7bd3c@mail.gmail.com> (sfid-20081103_085123_312223_8FACF40C)
References: <4908B754.1050400@tpi.com>
	 <43e72e890811011419k460b11e0he08d66022cbd606e@mail.gmail.com>
	 <40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com>
	 <40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com>
	 <20081102184146.GA6065@hash.localnet>
	 <43e72e890811021249x6047b38do5d7ead10fe4098e7@mail.gmail.com>
	 <1225696692.3619.18.camel@johannes.berg>
	 <43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com>
	 <1225697686.3619.25.camel@johannes.berg>
	 <43e72e890811022351m2c03e0b4g2a67a70cd6a7bd3c@mail.gmail.com>
	 (sfid-20081103_085123_312223_8FACF40C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HbH/VoN14QMajLw2SU0j"
Date: Mon, 03 Nov 2008 08:54:27 +0100
Message-Id: <1225698867.3619.31.camel@johannes.berg> (sfid-20081103_085512_665179_665B7F07)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HbH/VoN14QMajLw2SU0j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-02 at 23:51 -0800, Luis R. Rodriguez wrote:
> On Sun, Nov 2, 2008 at 11:34 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2008-11-02 at 23:29 -0800, Luis R. Rodriguez wrote:
> >
> >> >> Not sure I agree with the WARN_ON() if the driver's mac80211 config=
()
> >> >> callback fails. In our case when we tune to a different channel we
> >> >> have to clear any DMA operations first and then we reset the chip.
> >> >> Reseting the chip can fail for whatever strange hw issue cases. The
> >> >> patch fixes the complaint but is the complaint sane?
> >> >
> >> > What's mac80211 to do when it fails?
> >>
> >> How about a shiny new nl80211 event?
> >
> > And wtf would userspace do?
>=20
> If multiple configuration attempts fail perhaps stop trying, and
> inform the user?

But you're saying it's "normal" to get this failure, so wouldn't it
always do that sooner or later and always say your hw is broken? Also,
that's a bad thing to do in userspace, imho. Why can it fail here
anyway? hw borked is one obvious case, but it shouldn't happen enough
for this to be a problem yet.

johannes

--=-HbH/VoN14QMajLw2SU0j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDq4vAAoJEKVg1VMiehFY3WsP/3LbsEaJgYCjmXiRq4Fgop34
uYNPavumcD1pvEnsAZcsFHLcjCfjLH//b30hopLmmQyX8j96qRkM7quMmNN4mLKU
gdbJPjdspelPAXjPiZuejyTw9AMUS3zaKEan/5cXeA5tsFarmAJGkNUCQglwJfEW
Be2H1u0EFXvNLTdShm4yjM9fHhiAB5+NuS4sF7JXYWO+VPG58HxiYWJwuQg+v8eS
m3wDOUIReOWWhQp2U+NeucR4Y2Uw5GobGZTxv5b0ScC5nplwDjsHeRA3Ih/tb+uI
DapT9hOQscz4eee5VKBQyWOsn/77vz+AFvglyunJI46/LsQM2TJjtvJOrtzFZf83
++B1OIUjlxPR6U42nsT7+TKpJiYI5gs7T29d6gkbaUUS0B8+RHpOByc34QRqLpfg
LyRA/pt5KC+oLbowJ2XVvM3pbgwjhUqf3C5hwARzHMLKg0Pb8bcE7fCj9YcseWpn
Kes+d3SZA12d+yD2CBNQObdqQyXUTh+eCiX/ts0QV4gjhvJCMwTfmzCMXM672hgd
WkSG7gLaJAKDuOhYmGpXetPhFbCN7erSJq29uHaAtHUf/zFzNs41VgfefS2bOt8X
T64jMoQz+SADGGxSx5hxic4cXF3CgzTciULvrJCPbB0xBSICxD1fWwuHzJQSk96P
NU8jKaTFHNSdRXJn9upf
=WNIb
-----END PGP SIGNATURE-----

--=-HbH/VoN14QMajLw2SU0j--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZC3PUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 11:20:10 -0400
Subject: Re: rfkill-input madness
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090330132344.GA11934@khazad-dum.debian.net>
References: <1238159196.4452.1.camel@johannes.local>
	 <20090327143007.GA24288@khazad-dum.debian.net>
	 <1238188237.4452.17.camel@johannes.local>
	 <20090328005214.GA7439@khazad-dum.debian.net>
	 <1238262651.4217.21.camel@johannes.local>
	 <20090330132344.GA11934@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EGuwsRAYWdbvu9t9VAb7"
Date: Mon, 30 Mar 2009 16:11:32 +0200
Message-Id: <1238422292.5970.9.camel@johannes.local> (sfid-20090330_172021_428008_A04BAD38)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EGuwsRAYWdbvu9t9VAb7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 10:23 -0300, Henrique de Moraes Holschuh wrote:
> On Sat, 28 Mar 2009, Johannes Berg wrote:
> > Ok so you want to add "global" states mostly -- that's fine, but not al=
l
> > that useful since userspace cannot really claim globally. I also don't
> > see a point -- if userspace wanted to do global stuff it might just as
> > well do nothing.
>=20
> The point of doing global stuff is to do rfkill-input in userspace, the w=
ay
> userspace might want to do it.
>=20
> Without the global state being exposed, userspace really can't do anythin=
g
> properly, and rfkill-input is needed for any semblance of good rfkill inp=
ut
> event handling.

Right -- but I've been wondering about those global states completely. I
still need to look at input.c in more detail though. It seems that it
can trivially get out of sync, if for example a global event turns _all_
radios off, but then a wlan event turns wlan back on, and then what's
the state of the "all" switch?

> I can't say I strongly want it, since I am happy enough with rfkill-input=
,
> though.  But the API to userspace _is_ incomplete if the global states an=
d
> global functionality are not exposed.

I've kinda removed the entire userspace API part from rfkill, mostly out
of laziness (so I guess I'll add it back) but also because I don't quite
see the point. Has anyone come up with a usecase for it?

johannes

--=-EGuwsRAYWdbvu9t9VAb7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0NMQAAoJEKVg1VMiehFYnNIP/j0cBEo5Ao6mRpceiXSDrZvk
09IU3YzhnGOf3EeF4MzCySU+Ph3tPN0jJHcZCpUUYtxgxr+/bkDOo4bHvBvaHHMl
u7FwGunKGQTycfUyUkFFjTRjZ39R0H26on28bMW17cZpr4jNwwNvbV1YKz0yFFss
4N/qA096febjc4+yh2pqlcK8oJ5Ftr/bRb2dmmrJY0o98YKwjOGBH4/uuzZE6zhZ
IYbDWWERBvquIkIirr4iYha5tgntxUcSpG3WloZ1ey7QOOqqMpf5UPAdyPd4EPPt
Od+z1K/SxDSbFjaqFEPXyfB4DYgR1zGv/NgO3dTxX8Kilz/toBMQ8rNM1kTNbab5
K2Gd388XCcGP6NVMUo15/KYHZMpQlx7wjm8jF1OoFg5mgxUB+tHhDTdvOeAb9yPU
LcwYu4zxq2Hk/Ock4ZUidAtx6+5Eg0z3lirXGOE9FfBQKGSBVb4tWtvpzSeE4uOx
MIyGRmTF/YRIqF7HZNPZ64o3/aYWbo+SPeo95M0VF7d2ON7BpAu1lg7/wr2c4Pf+
q9AZ+jHvhzgJ8ArS7cMth1MA43RweBGCqSBYLfW+IdM1M1W+EB+a8mw1BtQWgR2h
/CH4NHGI7a5FYg0K7Zglbk7JgaSN5Yscjm2LnZSrZyktcVX/6eiNi2gS0qce9ZiT
uwACac9Li8o7N3RTDSPt
=qVOO
-----END PGP SIGNATURE-----

--=-EGuwsRAYWdbvu9t9VAb7--


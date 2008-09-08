Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYIHJLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 05:11:32 -0400
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809080206u42908ef6yc6641435d747155a@mail.gmail.com> (sfid-20080908_110640_740319_9DE6828D)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 <1220863139.31304.33.camel@johannes.berg>
	 <1ba2fa240809080146o93200eetcf8e142f6ef4a2b1@mail.gmail.com>
	 <1220864314.31304.38.camel@johannes.berg>
	 <1ba2fa240809080206u42908ef6yc6641435d747155a@mail.gmail.com>
	 (sfid-20080908_110640_740319_9DE6828D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kCQ56HFuM6nMHo60vKBh"
Date: Mon, 08 Sep 2008 11:11:26 +0200
Message-Id: <1220865086.31304.45.camel@johannes.berg> (sfid-20080908_111135_128840_3E4715C4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kCQ56HFuM6nMHo60vKBh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 12:06 +0300, Tomas Winkler wrote:

> > That's what we're doing of course, but should we really drop all the
> > frames that might still be in the queue? If we're just roaming we could
> > send them out via the next AP, but it's hard to know, and since it's
> > working let's not touch it for now.
>=20
> In current situation we are dropping the frames anyway.
> How do you know you are roaming and not moving to another network?

Yeah exactly, it's not easy to know.

> > How exactly are you triggering that "unauthorized port" message? I can'=
t
> > seem to reproduce to see if stopping the queue helps, but I'm fairly
> > sure, try the patch below that fixes this.
>=20
> Powering off AP, I think I've seen only Cisco AP that are able to send
> deauth packet on power off. So this was without.

Odd. So you did get the "No ProbeResp from current AP - assume out of
range" message?

In that case I would have expected you to get the same message, but of
course it's both timing and frame sensitive. I'm a bit surprised you saw
the message at all. Maybe I can reproduce by doing a ping flood to the
AP.

johannes

--=-kCQ56HFuM6nMHo60vKBh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxOw7AAoJEKVg1VMiehFYyvUP/R20BW+sSfV1cLJWggyfsfLA
mD5140KAlCgCDdT27mW+rm9li3//62xgdkWwsLXX682aPQxhkJwv6OL2lGFmscvc
gWw+kUrOqO4NMI+4GowsNconrSOIE9k5J91h5Ob3AowmPI/lbRfwzGUSf1mWSGWP
e7+JxJ2lqulJK+YH9H5GiRwYFpuysXIPPMTWfVGl5/e0mYxGoHecfbJWqnmwdNSV
E1O8IEaUikueJSZLOKBce7q+3dO3bYfi+bzdPfcVOw2nCf17/0tDTqD/2TDPcFkB
/Nbi8fAk0MabhRXSLsDYKATspeqBdgYtnbfFYOQae2z3hsqCTbRPeglocynhHZCv
5CKfK7SOXqFb/yqt5kkz4sk+dhYgVAz8cuXo0gYcI72M5fsMwbvLnr1TruIxW/SF
jCkjjNspifNWatyLJMWjc2423RUC0LVlC2w72K3XMGfkZyBktfXfsR9abw1zUF7o
XTcA5deQMtW+vRuU9+i6CEemnV+kA4qjHGjXSXioT6MzFFlu8alyfIdMxf7mD/Jw
nblGnzuEuh4QT86yhJfqLt94kTMaQqnntaci4nTOrA//POrn2zvEbKNb697DzNaJ
/E0BLLR/3GT/VtDk/Xsc2s7EzSe1MGLcPmds4xOq5NMb79F1LQVKxB+TnTceb0rQ
DwLToKEgeh1Vg29GGqfw
=Z6/x
-----END PGP SIGNATURE-----

--=-kCQ56HFuM6nMHo60vKBh--


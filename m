Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbYGXO7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 10:59:35 -0400
Subject: Re: Another fragmentation multiqueue kludge
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: David Miller <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Guy Cohen <guy.cohen@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240807240755o25889a9fy50d20e298beb14b0@mail.gmail.com> (sfid-20080724_165549_391304_6D8882D8)
References: <1ba2fa240807231441u7b870a15rb525771e364f65f3@mail.gmail.com>
	 <1ba2fa240807240601o2c083347rf5f1b6507e0abe7c@mail.gmail.com>
	 <1216908973.13587.65.camel@johannes.berg>
	 <1ba2fa240807240737lf649fc8m3c4236329e02288@mail.gmail.com>
	 <1216910776.13587.74.camel@johannes.berg>
	 <1ba2fa240807240755o25889a9fy50d20e298beb14b0@mail.gmail.com>
	 (sfid-20080724_165549_391304_6D8882D8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D5GkOqutKv8qaP0nbER7"
Date: Thu, 24 Jul 2008 16:59:23 +0200
Message-Id: <1216911563.13587.86.camel@johannes.berg> (sfid-20080724_165938_418671_8EFBD043)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D5GkOqutKv8qaP0nbER7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-24 at 17:55 +0300, Tomas Winkler wrote:

> > What happens if you just invert the
> >                if (__netif_subqueue_stopped(local->mdev, i))
> >                        continue;
>=20
> > check in ieee80211_tx_pending to read
> >                if (!__netif_subqueue_stopped(local->mdev, i))
> >                        continue;
> >
> > as I suggested yesterday?
>=20
> This is wrong since you it will actually starts queues that driver
> didn't ask to start in the next line.

Ok.

> As I see it any failure in the driver's tx path will cause moving to
> pending queue, except packets on AMPDU
> queues that will be dropped.

> That's correct for stopping because of queue overhead, not for errors.

Tough luck, just drop packets on errors. If that matters to you, fix the
driver to not run into these errors.

> So till someone fix adm driver consider this patch It worked quite
> well. I will also send patch that fixes the behavior in the iwlwifi
> driver.

If you fix iwlwifi we don't need this patch, and then I can instead
remove the code from mac80211, but we can just as well merge this first
since we'll get rid of it again.

johannes

--=-D5GkOqutKv8qaP0nbER7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIiJjHAAoJEKVg1VMiehFYm/0P/A/6glm/IO7sgyJ/aKMOTMtH
0H1e2LhWP1T/yFqxy6HUTK3DMi9s4Au7wjkCof0gkVO1llfv1jdCjOZVP7zsYaah
ewI9Q15Mkij6TwbAiuDhMzWp2lldCIaFiNxiFTSO29Nm7TThL/mASysa5kgWDaSk
Iu+fbty2C4F42lrdVCPfonjUy9C+92WVopcWgcTm41+l/m/zKKouNb1I0gs9/yri
5gfgr/wvxh2OT4iwFMj/V0ZSzfF45k3wk29dK37AwlR2RB6Ew+mhi1IpMYU31b4w
bP75JhAvJA4mj4xej6PdhJOrJzC5t5LudSFOD68kvgxTQ+coY5UWNbeeSxaYSwMK
CKR070ZWisRoZAheLwyIPHalOFzknLrWMrHyzGKmzIfqVZZfFTybLRSPMvvNklJR
mPR4QD3IlLfZ38Sjioh1uihoZEdUbYft+ogl71F9aDg1sj+xw2zOpWaIeHZfufAp
JihbrJmXblq55SNDWF9xP2kgLHfCX/sxng1bUdY034OroBdodeCWEqVPS/a4oNsC
bJbR3FRAcqeyx2mBJyhIrTnMLGo/DfbzjfTgC7a4NoiCEHrMs7d5HGno8hDyb29s
QzLbUCXVx1jY6qv9MMsq339/r3O6hPVlI/t++c/JI5+kCOjNJ8iK0NZunADL7KaU
Hjvd0zy6PBdwm+8oBq8N
=6mGH
-----END PGP SIGNATURE-----

--=-D5GkOqutKv8qaP0nbER7--


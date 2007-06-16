Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbXFPSum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 14:50:42 -0400
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	David Lamparter <lists@diac24.net>
In-Reply-To: <200706161129.13782.flamingice@sourmilk.net>
References: <20070611085950.GA5540@mail.intel.com>
	 <200706140935.50779.flamingice@sourmilk.net>
	 <1181996855.9058.39.camel@johannes.berg>
	 <200706161129.13782.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kcK8d9IZHQU029aXf1l6"
Date: Sat, 16 Jun 2007 20:51:09 +0200
Message-Id: <1182019869.9058.57.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kcK8d9IZHQU029aXf1l6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-16 at 11:29 -0700, Michael Wu wrote:

> I think that decision was made without much consideration to the=20
> implementation details.=20

I don't think the implementation details are much of a problem. It's
just a bit of message bouncing which is trivial. Except of course when
you consider wext, but hey, no need to consider that for this discussion
since you're proposing ditching wext completely. Not that I don't want
to ditch it, but people still use it and probably will. Heck, people
still use 'ifconfig'...

> I thought it was a good idea then, but passing=20
> messages from userspace to the kernel and then to userspace again is real=
ly a=20
> waste of time.

It's not happening a lot so it's not a waste of *much* time ;)

> NetworkManager already uses wpa_supplicant to avoid all the=20
> nasty details of dealing with wireless configuration, so why not keep usi=
ng=20
> it for everything instead of hiding wpa_supplicant behind nl80211?

I hope that nm would start using nl80211 instead of talking to
wpa_supplicant and just start wpa_supplicant if necessary. Or maybe some
startup scripts start the userspace MLME (wpa_supplicant) for the
interfaces during boot/hotplug.

> This is=20
> more simple and direct and allows the kernel to expose exactly what the=20
> hardware/kernel can do. Userspace won't have to change much and nl80211 w=
on't=20
> have to support every possible thing a userspace MLME would want.

It's not that the kernel will have to support everything that a
userspace MLME would want, but rather that the kernel needs to support
everything the MLME would want, to support fullmac drivers.

Another counter: when you have a tool like 'iw' that David wrote, then
it'll need to look for the userspace MLME every time you invoke it and
start communicating with it instead of the kernel. That's likely a waste
of much more time than just bouncing the messages.

johannes

--=-kcK8d9IZHQU029aXf1l6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGdDEc/ETPhpq3jKURAlWwAJoCKJtUQ2lltpPDy/jQuHM/GQIWWACfeEGY
UZLiI7DNXsU9cZqOPXzOax4=
=87SB
-----END PGP SIGNATURE-----

--=-kcK8d9IZHQU029aXf1l6--


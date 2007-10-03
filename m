Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33590 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbXJCQca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2007 12:32:30 -0400
Subject: Re: Kernelspace --> Userspace MLME move and related items
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20071003025019.GF933@jm.kir.nu> (sfid-20071003_035130_280489_9121CC7D)
References: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com>
	 <1191066581.22960.55.camel@johannes.berg>
	 <20070929161740.GB6130@tuxdriver.com>
	 <1191141815.22960.134.camel@johannes.berg> <20071003025019.GF933@jm.kir.nu>
	 (sfid-20071003_035130_280489_9121CC7D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KIZ6sP5hWQTOL0hPUkMK"
Date: Wed, 03 Oct 2007 18:32:22 +0200
Message-Id: <1191429142.4178.13.camel@johannes.berg> (sfid-20071003_173235_905918_DAD25CFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KIZ6sP5hWQTOL0hPUkMK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-02 at 19:50 -0700, Jouni Malinen wrote:

> > > >  * 802.11r (fast roaming)
>=20
> The current implementation is more or less complete for all the required
> functionality. I just updated it for the latest draft (D8.0) that was
> released last week. This includes code for adding new IEs to
> authentication and association frames and also sending/receiving of
> action frames.

Good to know. The latter are passed with SIOCSIWGENIE I assume.

> > > >  * 802.11w (encrypted management)

> wpa_supplicant has implementation for negotiating the keys and
> configuring them to the driver. It does not implement
> encryption/decryption of the management frames, though, and I do not
> have plans on doing that in user space either.

Right, that makes sense.

> 802.11w actually uses the
> same PTK than data frames for unicast management frames, so the kernel
> side (or firmware/hardware) CCMP should be used for this.

Yeah we'll probably need a new hw flag for this since I expect there to
be some hardware that will not like hw-crypto for management frames.
OTOH, it could probably better be a key flag or something, not sure
about the details right now. But it should be trivial to solve.

> As far as
> broadcast/multicast management frames are concerned, they will need a
> new encryption (or well, actually it is not encryption, just integrity
> protection) algorithm in the kernel. The key (IGTK) comes from user
> space in the same way as GTK for data frames.

Right, so we need a new cipher added to nl80211's checking code and make
mac80211 handle that new cipher. It needs to be implemented too, but
right now I definitely won't have time for that and the 802.11w draft I
have may well be outdated too.

In any case, it doesn't look like a hard problem to solve once we have
the algorithm spec.

johannes

--=-KIZ6sP5hWQTOL0hPUkMK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwPEFaVg1VMiehFYAQIr7hAAsUTqdxKuyQMBsLKN5X/8B0y/8k4IUhi9
HyuZlWxdsxv5n56MFYp3MtocV56AHtQw5DinCzE22EhMMMm5J9Uh9C1bPQP8f/gw
itNBFfZwvvV1ZOjktl083uYUy8JNol+ByW7AZSC532bSm7hTtyYX0+okex6hEXPD
WunzdKGxqqyBErAMouz1AqlQ066RQBdYsmBaagPq/2WlIbinvk0zzTrqecYtl7hV
xtnm8bY73c9ELu7nvhfoPvtZCYA/gqw0lRcBg5CjpP7rWlrOl384ud/z87oaQyyT
0ge5RVX/cal0o8u+pq0V25L/ytJXfsxn4RQSw6gu0YGwVY3qx2+jL3z3NxbDiz58
LOWbyEw8+q4wxOy90ia/ZhdD8of6vYi9DAPYMRDqA64bP0in/gYlZAkhL/9KRxOe
Uu69K8jRUJuucafblN+5z34oexA7vBmbcjgOTReLBSJf3K4SJ8s1LY/IlitCfZtv
Yd267MzxDYBL0Yk84n29gE+wcrUnStX10OvvqYluPm0UK/9EAD51ulvnCNCqhSy9
kZ1Nhxjk+oEvROeO4++3X5jCbnfwFu10BRLZYpyAYVsN52vGXnKl6/EngWLpyLcZ
osRvxLaFq4+L3s84fCESVU6t8aXlyUcINyggAVCvUuNO/cQ/w9mA0/EILHDmSq3R
DlC+5XJF8Kg=
=jWPS
-----END PGP SIGNATURE-----

--=-KIZ6sP5hWQTOL0hPUkMK--


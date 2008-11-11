Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbYKKM4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 07:56:18 -0500
Subject: Re: [RFC] mac80211 dynamic powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Kalle Valo <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
In-Reply-To: <8e92b4100811102032j7698254ct7020879e4cd5af1d@mail.gmail.com> (sfid-20081111_053249_569004_980D64BD)
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	 <8e92b4100811102032j7698254ct7020879e4cd5af1d@mail.gmail.com>
	 (sfid-20081111_053249_569004_980D64BD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qm8TtiGG5Y+aKKZ+1050"
Date: Tue, 11 Nov 2008 11:38:15 +0100
Message-Id: <1226399895.3890.8.camel@johannes.berg> (sfid-20081111_135625_606115_2B5488F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qm8TtiGG5Y+aKKZ+1050
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-11 at 10:02 +0530, Vivek Natarajan wrote:

> 1) I see from your patch that power save is enabled whenever there
>    is no Tx for the specified 'timeout' period. Should we also take into
>    account the type of power connection( i.e battery or direct ac supply)
>    before enabling PS?

That's userspace policy, we only provide the mechanism to set the
required state.

> 2) Do you intend to leave the NULL frame formation, waking up the chip
>      for TIM and modifying sleep/awake time according to  DTIM to
>     the driver since I did not see this in your TODO list?( I understand =
from
>     the iwlwifi code that it just sends a request to the firmware for sen=
ding
>     NULL frame and the firmware takes care of the rest. But it may not be
>     so in the case of other vendor drivers.)

Can you elaborate on this? I don't think we're concerned with that in
dynPS.

> 3) Is the PS-POLL concept(or M frames in N milliseconds concept of Johann=
es)
>      dropped after the DNS response timings related discussion that you h=
ad
>      since it might save some more power in low-traffic conditions?

It might save more power, but it seems that the compromise is too
strongly in favour of power for the dynPS mode, so you can just do
static PS all the time instead.

johannes

--=-qm8TtiGG5Y+aKKZ+1050
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJGWCTAAoJEKVg1VMiehFYRsUP/0j1wi+KpRHerhHJWkbZN3c2
j3qQXhdgKpZhXPfDtjTQaF1pivaTE5iJhbLG3bRc1tWO7eRvzwTfRdpjZ25Gaz46
Ugk1RCEFyIrdeKzuXuDrVy5Lts1hoIVsGeaHJHPw5233AwFFKoPxzieayMDFckRy
e/jvGJwV/eZB8ZklUNJhyIHHZ09LxT6y9/RDotIyTqjJHsj1Dv4Lr+1+hwOL3swB
18hjLYOqU0TbOYPKXTLjpHbyC0gHMwD+VRdg34HQKd1F/BkrzGK1BO0p2P8is7ij
ezCWpXtGU63/QhPvMEOu5Pp+AMv2nZ2YXTiWxkNEyTM0/sy4EC201PPPemJJqesi
jnTKRv/OxiDnOMXAQmUe+XLgx5ygJQ2Sga/kreZhHDXXzHuOtj+jS/5jmaEUDI31
ugngSt+FnRGwk/+SEWGcuLcuhOzMv9m+cBlYTrZfdTcjBZSqW3Bg7X+LEXaxSPAy
uoIZj1EFvxfdLY0sVn5Oh+ijnYhFM5uMRDmZGTNVsb+/vPzG52vT8O7KdCkrwuB7
5ns9nVAVsA8GH9ko32hykwCSmSd6pOGtn6//HJVO7lnhdAc48Xjyiu9b8l+eDNhk
cLssCOzXwGnGvB2aAMBre9NjDraKfKbNzQkAAw5gzSSugnDOueTowAE1o4zGct6z
wHOOfLnOfZQ62W4tGocx
=hHjh
-----END PGP SIGNATURE-----

--=-qm8TtiGG5Y+aKKZ+1050--


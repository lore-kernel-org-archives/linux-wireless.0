Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36280 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbYFJNKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 09:10:16 -0400
Subject: Re: mac80211_hwsim - simulator of 802.11 radios for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080610124724.GB6961@jm.kir.nu>
References: <20080610105058.GA6961@jm.kir.nu>
	 <1213096575.3668.6.camel@johannes.berg>  <20080610124724.GB6961@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nTmtvn7hDtw2qB+YlThn"
Date: Tue, 10 Jun 2008 15:09:38 +0200
Message-Id: <1213103378.3668.10.camel@johannes.berg> (sfid-20080610_151025_565793_E08CD049)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nTmtvn7hDtw2qB+YlThn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'm currently running Linux 2.6.25 on my laptop and as such, this is
> indeed not based on the latest changes. I'll fix couple of issues in the
> current code with 2.6.25-based version and then look into making a
> submission against wireless-testing (or if there are large, pending
> patches that are not yet there, against something including those
> changes).

I don't think there are large pending changes, but there were large
changes in the way channels are registered, tx control works etc.

> > One thing caught my eye: you use GFP_KERNEL in the tx routine, that's
> > not good, it is running under a spinlock.
>=20
> Thanks, I'll fix that. I was trying to follow the documentation in
> net/mac80211.h to verify that it is correct, but clearly I missed the
> comment on tx() about the handler having to be atomic.

You should probably use the _irqsafe versions of rx and txstatus too.

> > One thing that I'd like to add is a having a "global" monitor interface
> > that is registered by the hwsim module and not mac80211 and shows all
> > frames, regardless of channel etc.
>=20
> Yes, I've been thinking of something similar, too. I'll add a netdev
> that gets all frames with radiotap header.

Maybe it could support injection on that too, so you can test against a
userspace agent.

The design I had come up with a long time ago allowed userspace to
control each radio by having each _radio_ have a raw netdev like this
and not doing forwarding in the kernel but relying on some userspace
tool, but I guess that much more complicated.

johannes

--=-nTmtvn7hDtw2qB+YlThn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITn0OAAoJEKVg1VMiehFYpGUP/iWTYjbbjTeSsRUyyAt0IXKe
cxbbWrmzYAe60MEtW+Gi/w4t6D+4EnZv0i23WbF6dr/S6VoJypjvRrYBzDx7GlI1
oOy9u9HaMCb29R4V9I0hencNQSOrqzbrZ7R81ZQWUCLvT0FCYxZwU0VgY+X41yMC
2lUL9bCZzK8VCsHMSoGRLyHp9sCyx3z98uE+b+gy5sGpVTiujr0nX19PhOt5ERPV
53QkAowx2VWpTRF6B+fiJXgTFB+6bCfMdgRg2YteMCHY5CUv0saokKg8h1AOtln+
9AoX8YoGOZ4L+byXiYVDY0tdd01ZtXwhvg00PiDYbNUVEzOm1yIMXjA9TBjVKU27
NiSKGknUVcVB6mc5ypT+idMNN7G5n9Tdhbzra2eAiuaMybVidfAF4iIoLYTE0cax
DLlJBpBRmmcZrhQBejf0Z8Y2rJmKF2Efe7BvbWtSyhJa/Je/yICYunXzoNYewSpm
Tdhgv4QKAx200uFi5W6sTXt9IG11twc4yXvHdZeyYx+TlSRscQFje9KgndYFl2L3
ijf7SRWix65Pw1/hxjcUicCfHAL/3lDeCJkhBeaba+PkXP9qdPslOL1HNrU3+aNZ
qz2vlH2vsRXh4y2qNkrc5uQb/sgrzCm9ivaeO/EMD/Puo2V7b9sR5ZJrVyqhGshb
BiMo1AnBkV953D+CvkCw
=FeG5
-----END PGP SIGNATURE-----

--=-nTmtvn7hDtw2qB+YlThn--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYDOLCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 07:02:14 -0400
Subject: Re: Does mac80211 support ap mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: cao jing <caojing.china@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1208202280.12139.23.camel@localhost.localdomain> (sfid-20080414_204742_445593_54A5FE8E)
References: <9f33c5230804141218j5778195ajc1a7bae011eb9528@mail.gmail.com>
	 <1208202280.12139.23.camel@localhost.localdomain>
	 (sfid-20080414_204742_445593_54A5FE8E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E9kB9H7sKyb3N6b1s7xH"
Date: Tue, 15 Apr 2008 13:02:06 +0200
Message-Id: <1208257326.3502.26.camel@johannes.berg> (sfid-20080415_120226_451018_06D5D558)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-E9kB9H7sKyb3N6b1s7xH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I read the mac80211 code. I found only the STA, IBSS and Mesh_Point
> > interface type are processed by the code. So does it support the ap
> > mode.
>=20
> Yes, it does.  I'd suggest using hostapd as your AP daemon and the
> nl80211 hostap driver.  While it's still under pretty heavy development,
> it all should be fairly usable.  Johannes Berg would probably have a
> more up-to-date description of the status of the hostapd nl80211 driver
> and mac80211 AP-mode support.

Yes, AP mode is supported, however, you need patches (see
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/series for a
note on it)

The reason for the patches is that while it work, there are a number of
problems:
 * depending on configuration, it may not be IEEE 802.11 compliant
   (this is related to basic rate set and similar things)
 * there may be inefficiencies with the frame handling
 * probably more I'm not thinking of right now

johannes

--=-E9kB9H7sKyb3N6b1s7xH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASASLLaVg1VMiehFYAQKQ1w/9GEe2tBwdRAGV47FTqpGHCI7gaaqto78m
JkXFd7W4LmxU9NAXdsv3u1i5wXoBLzNrYorBk7SKeQAvXaJV837rPZofkO99oqOH
Nn7UpNAAa+fl3pDsQtQhJ7WrJ1GJm1oYlP/OQMR1WLDrlNhiT+weGNsSJZAd/OXP
MHl0RMZEZGkFsN9ZrUUIGxicbZG0a1/GMpR4/cdoEpSEfcDGF7ZZV5hLlUHDEA1C
GMflmZxJOot1n7OELWZLzuPEqheJP8xo9zT9CHSflhOgF9yucZdQbglEkttTGYfa
DCa8JkbSdWHhytGNp10lmHAuBB583Wn3uDDTVLpSpE9G5XASs1/sCYNy9pbW8zeS
bRs/q1jg8pK5ZP0BzSafldWekzQECz9SKqw3n5kTJqbLfFmbuzzz2DdXs1Q1eynV
5uiABCjhRGXx7jAtJ6NwRwiWyDc1r1QNiLHEM1IP5fpuvGwQThsK5iq7U1yfISEz
jJ0C8poPwUHX4F/p5xigN2E/M9nHMuken55hTDLpMiAGi0itwjpS03taovmxfrUu
o2ZE0JFCdQXOezjNS2fNCi2DX0y3ExKdE0JpjXeJVI56wIc5KAbV419k6ISVgINR
6qhTISw7MCdHbh0nHfGIvlPeuXXqGpbsRdgcGHs5MHPJyDJWJx7LG3d+Zx/Tp2VM
uVMskRhz+Z0=
=yALE
-----END PGP SIGNATURE-----

--=-E9kB9H7sKyb3N6b1s7xH--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59185 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZGaQL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 12:11:57 -0400
Subject: Re: [PATCH] cfg80211: fix regression on beacon world roaming
 feature
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
In-Reply-To: <43e72e890907310903k65be4480j3279253281f2935e@mail.gmail.com>
References: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
	 <1249026324.29587.15.camel@johannes.local>
	 <43e72e890907310849l3487b8a2p52302f6662a26f95@mail.gmail.com>
	 <1249055782.20312.19.camel@johannes.local>
	 <43e72e890907310903k65be4480j3279253281f2935e@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-D4n7r/6r7yUavCtbIycZ"
Date: Fri, 31 Jul 2009 18:11:53 +0200
Message-Id: <1249056713.25587.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D4n7r/6r7yUavCtbIycZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 09:03 -0700, Luis R. Rodriguez wrote:

> > I did mean those devices. Adding a reg notifier hook for iwlwifi seems =
a
> > little odd, given that cfg80211 is supposed to always honour the flags
> > (which it copies to orig_flags for that purpose).
> >
> > But I don't see why ath couldn't do this:
> >
> >  * do _not_ set the passive/no-ibss flags in flags (orig_flags)
>=20
> That's up to cfg80211 through the custom regdomain, so yes, and in
> fact we can WARN if these are set.

Ah, that seems a little heavy-handed :)

> >  * in the reg notifier, always set the passive/no-ibss flag into 'flags=
'
> >   unless a beacon was noticed on that channel.
>=20
> That's fine too, we still need a fix for 2.6.31. Do you have any
> thoughts on that?

Not really, tbh. Seems like all you'd have to do is remove the
IEEE80211_CHAN_PASSIVE_SCAN/IEEE80211_CHAN_NO_IBSS flags from your
channel registration, and set them in ath_reg_apply_beaconing_flags and
ath_reg_apply_active_scan_flags, changing the polarity?

I mean, right now you tell cfg80211 you don't support it, and then try
to support it anyhow. Instead, you could tell cfg80211 you _do_ support
it, and then not support them depending on the notifier? It seems like
that should work and not break cfg80211's assumption that you can never
ever support _more_ than registration flags (orig_flags).

johannes

--=-D4n7r/6r7yUavCtbIycZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcxfFAAoJEODzc/N7+Qma7OUQAJJnG3zORuu7jb/9kLeI02Ty
4nln34k49IuUI7ihS6xnTiUit6t+9edGB/4Lh1Rz6bjGVwBI+i2ytIiNtKiRECDv
7gKPsbbCYMYk/5I8Rv7T41iGv9PGmQ9WKZlIc7Xrsm1th8cqBhfiSobxerunwsBq
/nfS/Ru++1hX+LWjoUCT5EcdDeq9IcoApxIv4Myg8uM/kpeHXrDSJaJipL1iGX0T
sbAzzcnTKvVewrJQiA+91Dtnl50FbvGzLXej8VBLiQ64bUqvlcS5A9RxLL61EuYO
me39FijPHbpmbEPDyiv/EUkIGCO1MKjJ1oruUmMUE28h4EwhbSUpl18o4OcQlVa3
9bhpZF5wLkKoNmSJ4qi6UFAQkr2DGdQk8NUBd110Ch+uxk54D69Xs4VC1Cu/b5uh
iBslgEtpHiIIbWJt5AtYwszOSWItAEdue9O5CxpidHEe2ERThDBQ7O8Y3lwM64fS
LLgQFdjwjqyRDGWYLKAX07XdbVyYUZrfFaN87YVFLwUlxTJr6I1QgMtG1xAIj4mZ
9M+reNiVZ79Lwq6t7ywQqo3lFl652KYGx2Jk6KDiiTJJc+2vFUAh7hY0PJPHbZ6t
gGP5G7KYexSJXKClpbo68/dvW36dKmwKIULvYboHoarI/C4Nd4dmNn0PGR53IStN
7LgOOk293CYD80C2D9Iy
=DfKH
-----END PGP SIGNATURE-----

--=-D4n7r/6r7yUavCtbIycZ--


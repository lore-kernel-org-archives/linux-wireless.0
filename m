Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbZEMWVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 18:21:37 -0400
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending
 on the stop callback
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	 <1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
	 <1242208388.14227.46.camel@johannes.local>
	 <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vnQQOGCU1Ms+BF7UOO1B"
Date: Thu, 14 May 2009 00:21:08 +0200
Message-Id: <1242253268.10076.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vnQQOGCU1Ms+BF7UOO1B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 10:20 -0700, Luis R. Rodriguez wrote:

> > The way you have it, a driver needs to
> >  * keep track of the wow config
> >  * check whether a stop is due to suspend
> >  * apply wow config during stop
> >
> > If you passed the wow config in some struct to _stop() [and NULL if not
> > for wow] then the driver would only need to
> >
> >  * check if for wow and apply config during stop
>=20
> Reason for not passing it is its accessible through the wiphy. All we
> really need from mac80211 is if it changed (some devices may need
> this, and will be more useful for the user pattern handling) and if we
> are stopping due to suspend.
>=20
> What advantage do we have if we stuff a wow struct instead of having
> the driver read the wiphy wow info?

None on that, but I think it would be a lot simpler for the driver to
check "was I passed wow info" instead of checking "is this for suspend,
if yes, check if there is wow info". In the former case
cfg80211/mac80211 would simply not pass any wow info if wow wasn't
enabled.

johannes

--=-vnQQOGCU1Ms+BF7UOO1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKC0fQAAoJEODzc/N7+QmaqqAP/2gJ33MAl+21D1Fp5Sm/Nld4
PY64SloMtsjI1MUmWonFHbAiXdUm8TT0kFQCIIJuKpPT0q2o/1Hs+cMeNPinWIgQ
QWPSYhQTCINVVX0urCPJJUst7Ed+xexV5uu+2VkoYWA2Zmnulg4SnJIlt8S64zbD
iAHp32bAONsT1PQfoFme6dvQ7wrCLDaXtysKPzC6Y8ZSYOgbiQwl4xf6aNLdcvuU
+I00LzwdPMhzIw75TgwU5MgmKCNbfQfN9RAdEqUZ8WycmI/WnfeXXWAKi7D9JiUj
m+1nUCeJnlx21e5v1CypIP5tu024hCrGpCsqjzUMecQfVUJjlIayiVbYgi3uouim
sgzhS/lf5+wLA5IR8ltUbtMjCTHQmRgsySiBqQt2GIvneq7NZp865Vqw0MnR0Zbd
GBWOJDqCRW8p9JP2xpM1T5rALlEL88xE2v8FvrKJjnMxpzjt5srP1ziz0i6ftPLJ
MXwsnpP9CgDQir2BbMOFNwNgkd4nCs2+RuKat6RNyUVQQVj2ZWYtsxiyqDPZpoln
bFx3MN/TvSZMyON5vl6Ok+lRrQIxw2ZLHh+QXIziot6YuQ7N/4+Xy14V57ezIHie
tScWPwl+OuHNIR9xm4alTBX17Y8f4jX+Cuc8n+8XLZb4/0Eum77FhwTlgZMS2XIO
gB8/ZSrnbXs8O9e6vAYC
=+H3i
-----END PGP SIGNATURE-----

--=-vnQQOGCU1Ms+BF7UOO1B--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYIKRN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 13:13:58 -0400
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20080911171059.GB6049@tesla>
References: <20080910220145.707263000@sipsolutions.net>
	 <18632.55008.411078.289830@gargle.gargle.HOWL>
	 <1221139351.6986.26.camel@johannes.berg> <20080911165011.GA6049@tesla>
	 <1221151995.6986.33.camel@johannes.berg>  <20080911171059.GB6049@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pBVv4AFCmiqBsTIQwvh9"
Date: Thu, 11 Sep 2008 19:13:19 +0200
Message-Id: <1221153199.6986.39.camel@johannes.berg> (sfid-20080911_191403_265965_52262D6E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pBVv4AFCmiqBsTIQwvh9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 10:10 -0700, Luis R. Rodriguez wrote:

> > The driver already gets notified via sta_notify() that the sta is about
> > to be deleted, it must make sure that no matter what sort of references
> > it kept, the sta will not be accessed after that sta_notify call.
>=20
> Ah good point. Then what is the issue?

Well, mostly that ath9k right now assumes it controls the lifetime, and
it won't do that afterwards, so since I didn't want to read all of the
code I failed to change it that way because I didn't know where node
pointers are kept. It's not a huge issue really, but the lifetime
management change is somewhat involved, I think.

johannes

--=-pBVv4AFCmiqBsTIQwvh9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyVGlAAoJEKVg1VMiehFYbtsP/3okWpBqs4ZR0P+UXlKB9hTI
Bqk25QFt9ip8+7M3yYKAGO8ulXrj3INsWFztthNRExgbR/jMSbKQCcfHkraikQo/
7CLBgWco7WLf9mGBD82sKoYaoIEfwFjHCGiUiDixuvmY+2NkLj7rXwNWxTSb6gYM
Z4HKfl7IBYHVddgRjJ6lOQ4xg7aYjAtAiNAIcf9P55V6hL9QSU/3N8D2m+7TeXTq
hU9z9IsIk0jDpJvbLTkdCuA9k/jr78hxag4t6d1sERQG7dYkoxSiLJZtNlb5COJl
ER1DoLw1uWLr8Z8qLBSJfTdUV5lNOKdq5VXluk3BnnguvkQq1ea0lJeK6zFAFLXp
dkfvepYqNbWlnDDMMShoXa81Hg4nFfZac1mPLL1iVoBjnn+dXJoTBEu0z/23otfI
JT6A8i4MpQAJYhKVgtkTsGcCTtw1SO1tK2DHOMwvjs56u3Dyc+HyMClUGhhrasBO
RARizT2f5b6tRBBkxFpVwe7LXfS/jjU8mx29m35wPTQkbSkWPAWjyoJ7OeKmb2cv
aZsJa/f+f0nlJ0KhJurxlSLsR3oDi18fKIRwJr11CM3DGM5taa51dPacLmizj/ZO
eglIlHlvIZjh9ijMNiu26kg2ijcHbLhlJNtwNi8XwvDuSnEqJrqK0zqwiE2RJNha
VpDWMSYmiSW76iGx+ntF
=4pcr
-----END PGP SIGNATURE-----

--=-pBVv4AFCmiqBsTIQwvh9--


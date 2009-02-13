Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZBMHtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 02:49:02 -0500
Subject: Re: [PATCH 6/6] cfg80211: move regulatory hints to workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902122335l6580dbc1m44702996cc8200e4@mail.gmail.com> (sfid-20090213_084150_789218_6A367D4F)
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-7-git-send-email-lrodriguez@atheros.com>
	 <1234508187.1327.19.camel@johannes.local>
	 <43e72e890902122309q61036a23k2efeb14fe3a6e814@mail.gmail.com>
	 <43e72e890902122314m2966471dm3a9485a91e8e927@mail.gmail.com>
	 <43e72e890902122314r6b9e881cg5538523780e808ef@mail.gmail.com>
	 <1234509436.1327.25.camel@johannes.local>
	 <43e72e890902122335l6580dbc1m44702996cc8200e4@mail.gmail.com>
	 (sfid-20090213_084150_789218_6A367D4F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U+mmvuMps/dLlFEMJdTc"
Date: Fri, 13 Feb 2009 08:48:54 +0100
Message-Id: <1234511334.1327.34.camel@johannes.local> (sfid-20090213_084908_475668_A423C39E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U+mmvuMps/dLlFEMJdTc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 23:35 -0800, Luis R. Rodriguez wrote:

> > Well, regardless of regulatory, we now have two paths:
> >
> > nl80211: cfg80211_mutex  -->  drv->mutex  -->  rtnl
> > wext:    rtnl  -->  cfg80211_mutex  -->  drv->mutex
> >
> > which is clearly not a good plan.
> >
> > Therefore, I'll probably have to implement solution (1) from what I sen=
t
> > you, and invert the locking in nl80211. That would fix your the
> > immediate problem with regulatory as well, because that was:
> >
> > rtnl  --->  (regulatory_hint) --->  cfg80211_mutex  -->  drv->mutex
>=20
> Yup I see. So as it stands in this patch user reg hint now is:
>=20
> reg_mutex --> cfg80211_mutex

I don't really care about reg_mutex much, and it probably doesn't matter
as long as its use is limited. Question is whether we need it, but
that's a different question.

> Driver hint also does the same so it seems your fix on nl80211 would
> probably just tap this series on the nl80211_req_set_reg().

Yeah, I think I'll work on top of your series anyway so I don't clash
with the cleanups.

> I also think using a workqueue would be good here anyway, the only
> negative thing I've seen is loading takes a bit longer.

Indeed, it's a good thing because a path like this:

driver_open
 -> regulatory_hint
  -> cfg80211 stuff
   -> driver_reg_notifier

is always deadlock prone since you call into the driver from itself.

johannes

--=-U+mmvuMps/dLlFEMJdTc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlSXjAAoJEKVg1VMiehFYKeYP/RCKS9DeKYpEngerzWz/Nywm
PKr3bvSpx4nynpi851cfT8I5H1bjsRLVsJPQAi8svGLa0//MUKyknxYT4/47sdST
SFHwlniHdamvlQu4giRoJJqUJK3XrWVZWSpaGiUiKFWkFb9uLzbfDz919eIlLtqK
cAN7Lxjto/2KjiuxibEsA3Vu7tqErHn51Pfx9qOG3S1DHy0LpTDKCxco8cqAG1EO
mzAMejKKqSuIBz17cGc4Pc+027QrFjNA1OVhfizemANAULcS9K9WqnLGaXRRi+5r
4FEnRiz0NUCrqPKjBZ5PxQIZflwWwo7FsgO1hz8oD+CZsUse2Fh/pKve3p1jS713
aprvvktBG4vXB7aveJwq0ZcfE5KVT4GJ9Hp1MVT/mwfAQMJ3ER2G4V9gk4cddDAJ
nluIEtCcffUzPRdLOw0sim5SMWb6181EAu3S/9QbJUZCXKVhc+/OkllS6ZSC4kpw
klojtbDmN2aHdZAFknAgaCefnxUFA41IMzo6s+pg+jzc4q91m0gx46h/bEEqy1gD
c6bIFcjdkr+vuedkEpYBzZgJnz4EGYsFT03GDIEeZVCjkPz0kaUc0akhpJyXTlc4
V/buu9EIi7+E3hukasgnWHqsyybhRAUCkikteNkN4I0LfcvAuJocjJWC3gO2zZiF
hH0tT57PeVkxc4uhmgi9
=23JO
-----END PGP SIGNATURE-----

--=-U+mmvuMps/dLlFEMJdTc--


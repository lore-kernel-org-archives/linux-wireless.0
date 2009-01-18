Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbZARIra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 03:47:30 -0500
Subject: Re: [PATCH 08/13] cfg80211: save original values on regulatory
	hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090116210655.GK29609@tesla>
References: <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
	 <1232097921.3854.28.camel@johannes> <20090116163100.GE29609@tesla>
	 <1232138062.3745.6.camel@johannes>  <20090116210655.GK29609@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6EDV0luBY9ezZj8a6omD"
Date: Sun, 18 Jan 2009 09:47:29 +0100
Message-Id: <1232268449.3877.8.camel@johannes> (sfid-20090118_094733_246754_3978EB10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6EDV0luBY9ezZj8a6omD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 13:06 -0800, Luis R. Rodriguez wrote:

> Well in ath9k we want this, and orig_* stuff is used only for custom
> regulatory domains. How would we install information on orig_* from
> a regulatory_hint() on drivers if we have drivres which may or may not
> want to save that information on orig_* parameters?

Not sure.

> > We just need to have the driver set
> > orig_flags rather than cfg80211, no?
>=20
> Oh you mean in the reg_notifier() on REGDOM_SET_BY_DRIVER? Sure, that wor=
ks
> as well, if so desired.

Well, I wasn't intending for anything to _ever_ touch orig_flags at
all... I think you're hampered by not being able to simply request a
regdomain from crda outside the normal "apply regdomain" flow, maybe we
should think about that instead? Then ath9k could just request a
regdomain from crda before it even registers its wiphy?

johannes

--=-6EDV0luBY9ezZj8a6omD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIbBAABAgAGBQJJcuyeAAoJEKVg1VMiehFYThsP91cyYsvUXSr6tGZ6trb3hzSM
+VF8oGEJNcA6GHLI7N3o6ZATu91kn3ikA3Tk+TLfprrKAn890A8epj3qBHiLq0ax
oQbWBkgzxgAa0VzJJD0k1ijpLVy6JUuIDZdI5+dQ3wWyDI+tr4q0bAjFeW0Qosjx
1aL5u8PwPAUqULDPeRuTXHK4mJSyngnBQVT2y/g+MJweSoYzSodaNSle/HzUQSuL
wuYerYyb5LAf0qmetTFCLm81hFNs7DVxiBzdnAJJHti48Et16GdGdJk/Z8biz41s
Ju1D8++YwBlYi8DJXKCTLUryq9vFbnZ7g899AClIPeDkjQcILhjvttIFJU9Chcgb
u1evIoaOC47TbaG2iZfZhAhTO3GLSbuh0wx9r6/b2/DEK0bbM75ddLnAjXfuQ521
6+/f+NTmdYhvv6/cKBfCjekqQr4riQZKf69Ez7r/uP+KVqQfXXeM7Qrzqtqatz9B
k3vLoWzcDea+43sMb4kYDfCk0Iro3CVDIGGMmmd0EZ3c6Kgfe4/wSktSgAp7imnY
sTQMyrFxsiaYb7parsX6b97Qmk90VzsQkUi28IqIzuv/yh3x86atM3hDglTkAuSo
f5OHA9XEdo78V+e77/ROjtQl+5oIyIVSkc7bqFrTAxCa+5XSf1R5whF4kGcmaqnh
Unnb/WR6K58L7uVpGXg=
=XPlQ
-----END PGP SIGNATURE-----

--=-6EDV0luBY9ezZj8a6omD--


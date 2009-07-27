Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZG0QAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 12:00:20 -0400
Subject: Re: [PATCH 1/3] mac80211: cooperate more with network namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248708886.2688.4.camel@mj>
References: <20090713223333.042733013@sipsolutions.net>
	 <20090713223413.255405284@sipsolutions.net>  <1248653082.3106.7.camel@mj>
	 <1248683249.19945.29.camel@johannes.local>  <1248708886.2688.4.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GBf+qNn7JgaIrBatOeAH"
Date: Mon, 27 Jul 2009 17:59:47 +0200
Message-Id: <1248710387.8500.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GBf+qNn7JgaIrBatOeAH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 11:34 -0400, Pavel Roskin wrote:

> If you mean "verify info->control.vif is not NULL", it makes no
> difference for me.  No BUG is triggered.  info->control.vif is never
> NULL in ieee80211_tx_pending(), but sdata->dev is NULL the second time
> ieee80211_tx_pending() is called.  Just skipping that case doesn't help,
> I still get a panic in that function after about 10 calls.

Weird.
So where does it panic if you skip with sdata->dev =3D=3D NULL?

I don't see how sdata->dev can possibly be NULL. Hmm. Ok, I think we may
not be recycling things correctly. Is it possible that this is a frame
that was rejected by the device, or maybe a frame that was attempted to
transmit, but then got into software retransmit?

johannes

--=-GBf+qNn7JgaIrBatOeAH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbc7wAAoJEODzc/N7+Qmar50QALMEcNREp2jagwjArBIdcwLS
vwR+R1wR00wRX8DEEdmN8jYTwpFcuaMw3hOW0446SlSMFv0oDP4dIkHF/RuH9g8p
6NBcdzo1ymQcs1z/kCgaTSEs+ajVILScCxe0gf0dY3D7XwPB9iR5YC0fn7LZXyby
YOPPW2kbiCOzl0ZPnUeKmvNMJiG7IFgYPw5G1gtzVnMze1pGe/jzuhhlk+iENCr7
M9xbpTeEFd/dZ8kmxOuzIb59Gv8VgDUuUFDoZHvH78gN6PfIJ7kCj1eLv25rQZci
Gpq3APpiyT4V4EXEY694G4APgm8rboqF0I3qdFQxqQIHx+eZJA43smV/Ddn4Jk30
dWMLmqwwy0HKybzWeUxsE9oY2eosEE9LbzDay5cbkhuPgwU8cpAj8IYmK3gxT4Ai
bsM1hdhXWQQe25B6QJ8JsVUhBijY/lOEKJP6FIN93WELEidoQXL2Ei2Q7gBmmsFx
JUPZJ/07c6oN3YsUpTNwoYZBFskuzlJUiK3px9/Y0cVON2PPpsHBKmh+/6i9QGzC
ntlf1RdPtJsel5Kb+6goQSWKnHznPk7Qapxv2rZOq3jYEWGH2imxIQTQOxpDSzUx
JWWeqh48X/1ikTOgVVaYr1pt8499EuCxY0HRH+moLRMUDMFtaxLf3oVGqe14SFSJ
GkO86hnmCb/WTiXL/3sy
=73jg
-----END PGP SIGNATURE-----

--=-GBf+qNn7JgaIrBatOeAH--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZCTKlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 06:41:42 -0400
Subject: Re: [RFC PATCH v2 1/4] mac80211: decrease execution of the
 associated timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <87vdq4lbtq.fsf@litku.valot.fi> (sfid-20090320_113755_292367_61DD61D9)
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171431.11126.51242.stgit@tikku>
	 <1237051084.5235.97.camel@johannes.local> <49BBFB78.6070708@nokia.com>
	 <87zlfglfa2.fsf@litku.valot.fi> <1237542166.5100.137.camel@johannes.local>
	 <87vdq4lbtq.fsf@litku.valot.fi> (sfid-20090320_113755_292367_61DD61D9)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oWTwSA2IB98CrbD7RPB2"
Date: Fri, 20 Mar 2009 11:41:38 +0100
Message-Id: <1237545698.5100.145.camel@johannes.local> (sfid-20090320_114145_748428_E654F12C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oWTwSA2IB98CrbD7RPB2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-20 at 12:37 +0200, Kalle Valo wrote:

> The original (or current) implementation sends probe requests even
> when beacons are received or there is unicast traffic going on. My
> patches change this so that the probe request is only sent when there
> is data idle period (ie. no unicast traffic).

Ok.

> Like we discussed earlier, I think the most optimal solution would be
> to send nullfunc frames during data idle periods just to check that the
> connection is working bothways.
>=20
> What should AP do if it receives a nullfunc frame from a station which
> is not associated? Send a deauth frame back to the station? It would
> be nice to check the association state also during the data idle
> period. Sometimes I have noticed that AP might deauthenticate the
> station without station noticing it. It would be just perfect if
> nullfunc frame would do the assocition also during data idle periods.

Yes, I think nullfunc, being data, counts as class 3, and as such the AP
will deauth the station.

> Sorry, I did that only for the period when there is data transmission.
> To get rid of unncessary wakeups altogether I need to do something
> more advanced, like using two timers or something. I haven't thought
> that yet.

Ok, guess I got lost in all the timers.

johannes

--=-oWTwSA2IB98CrbD7RPB2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJw3LgAAoJEKVg1VMiehFYfQEP/jbZqK1ocmoOhzctZQxobnhx
JVyxhwspGjWQquvy6aUs7jgpZcOXz/SqGi7dDEthfyj/ewyvdhlHC4MM/9VvRDw9
WKq7YArN8dnuzFQ4MdJrZUSUqnQq6AgKNivqRKkFHsYhWoIYW0r4QHto3S3Lf1i4
UAIUW7h3NqTQ8CTD12JaWxn1pBbw8GRe43Z5tmc8aPtmZgRn5cM5fjPzO08yPcOc
hzPurJmzgWkYz7dH+UjLZsNjFCMBCdpCuuXlzGnS5jjFs1v+FYFMv6qConAL7NXP
8RJS1LtxMP2dK1ME01sU0mhplaz7lT/T+l2YBpe25BfD/MTHd6BEYsdmn+xIysZX
Nq1dBhP4ZnYcwWHt+cPv33tGkh09DQKrtuRGTrpavNPhTRXFQuse+RmShnTVzeat
bc7ip/L7ZhICksjfinBkCCHKKSUIZPj6QS1fnr4otuhnhqEsfnczMjSTrZXyIWEq
tDvKjo8+yibAqDuEhZLLgafGX70P20bnbPDOF3/YVZw5A+nEBL7oH09AHvuklQD3
+r2/u1bTLXeP9I3cw2fciza9o7bRLI8qQeRE7L//x9XYFd42+wOGgWKYSwqX7fwy
BlyyLygkfxcnuhAJg6Z5u/BXiT7dNzScb11SQ0mfYUUFlwlaPpOxbir0mLnLdeGB
gG2i7bnOPXN9vhQat48L
=5f6m
-----END PGP SIGNATURE-----

--=-oWTwSA2IB98CrbD7RPB2--


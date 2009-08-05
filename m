Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934650AbZHEREc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 13:04:32 -0400
Subject: Re: Status of 802.11s in wireless-testing?
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: xxiao <austinxxh-ath9k@yahoo.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20090805165021.GA20338@tuxdriver.com>
References: <2f1373ed0908042145pc83adc5qd968e3bf8d0ce3c7@mail.gmail.com>
	 <175701.5780.qm@web55308.mail.re4.yahoo.com>
	 <20090805165021.GA20338@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GjyUw/menBAMCT8wdzmn"
Date: Wed, 05 Aug 2009 19:04:26 +0200
Message-Id: <1249491866.6902.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GjyUw/menBAMCT8wdzmn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-05 at 12:50 -0400, John W. Linville wrote:
> On Wed, Aug 05, 2009 at 09:08:54AM -0700, xxiao wrote:
> > I didn't see patches from open80211s project for a while, which
> > means it will break as the rest mac80211/drivers are evolving quickly.
>=20
> You may be right, but it _should_not_ mean that -- at least not
> necessarily.  Yes, there will be accidental breakage from time to time.
> But developers ought to keep mesh in mind when making changes and
> they should be "on the hook" to fix whatever breaks.

Right now, except from the stuff Luis had broken and fixed, the real
problem is that there are a bunch of bugs that appear to have been in
the code forever, just never noticed -- for instance the code can end up
calling synchronize_rcu() in an atomic section.

This is the reason for disabling it -- it can splatter all over the
scheduler if that happens, and it's not clear to me that it cannot
happen. It seems not to happen in _most_ scenarios, but I've certainly
caused it to happen by not beaconing, for instance.

johannes

--=-GjyUw/menBAMCT8wdzmn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKebuXAAoJEODzc/N7+QmaRdYP/imtvj1dkodmUfpvCQLFTes/
u8Udfv0yi7Sd/AQFevCS839IhI5KiDVc6uCH+89+O1Owpx/9oBDRiJvrG7OUzCQ3
fmeTAuXmt7Gy+PBlUxT2RgwPZ1+zGcC8Vs6S3PtM5XrYRFdFRF3hO+mT5xdppYN6
RqIdWvSj/mvr5LgtRTtv5aiFmiWjA9u27+fZSCbMDtC1OkBDiWODIvgxYONA98ue
2UPM7vTmSrcbBX5+gfqhSpzA5rqwzucTbW34XMGy+9SjNjOu80AZJuTvCee0tmx9
0pl7c3lRZ3oJIZO9lgVkqOAjYYv4koMAXm307w3utIHiRdfXtXhwwW0I+R9e0Bwm
UvVfOGSeIUg2v6ndq7b/NB0bKgHOnVjWgUCO+/dt5NpVzqOXrMAwwDxSwJWAtqab
RX/8n+91Mn3uSn/+WMA5nvisS9vb7ruoWZvkX+ZjfPujhVob1gxLkJaQS4qulVJm
rAoNSBjmQC03sHFQsp/Mi8my++z+80DA6Se6e7jh4jbPSMmzd+gs//pigBIhd5dq
ry1bKNSAl1cTkGLcwy9Q0XZCgN3K9qbB5JytyTICJd1n0+TJyNSyD94jNS2foGbY
iWLpNif2op2s6/31M3z940f4qMpD1CWco+HaOwYw6TK3bQJQZy2+afVZlXDfwPCQ
aPD+tHlEAVPPW3PYeFn3
=c0JZ
-----END PGP SIGNATURE-----

--=-GjyUw/menBAMCT8wdzmn--


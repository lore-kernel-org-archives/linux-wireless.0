Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab0AXLiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 06:38:19 -0500
Subject: Re: hwtkip hangs on b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
In-Reply-To: <4B5BE16E.7080901@lwfinger.net>
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu>
	 <201001232000.07229.mb@bu3sch.de> <4B5B4E9F.8040708@lwfinger.net>
	 <201001232038.55204.mb@bu3sch.de>  <4B5BE16E.7080901@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BXLkoXYnchRiBy1H+UdW"
Date: Sun, 24 Jan 2010 12:32:50 +0100
Message-ID: <1264332771.23766.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BXLkoXYnchRiBy1H+UdW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-01-23 at 23:58 -0600, Larry Finger wrote:
> On 01/23/2010 01:38 PM, Michael Buesch wrote:
> > On Saturday 23 January 2010 20:31:43 Larry Finger wrote:
> >> On 01/23/2010 01:00 PM, Michael Buesch wrote:
> >>> On Saturday 23 January 2010 19:53:48 Johannes Berg wrote:
> >>>> Actually you can't, because you can't acquire the mutex here since w=
e're
> >>>> in an atomic section. So relying on it being already locked is proba=
bly
> >>>> safer. However, you can't actually sleep anyway...
> >>>
> >>> I'm OK with removing the lock from the callback, if it is guaranteed =
that
> >>> the callback is only called on behalf of a RX call.
> >>>
> >>> We can just remove the lock and add a comment explaining why it is no=
t locked...

Mind you, it won't work on SDIO hardware since the callback cannot
sleep, contrary to what Kalle documented :(

Why is it not giving everybody warnings in might_sleep()?

johannes

--=-BXLkoXYnchRiBy1H+UdW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXC/aAAoJEODzc/N7+QmaPBAQAIZx199Yr43s5MmzWqDOL9x+
GhGSUX6ebXq00yhrmuxWy8tXBmM+mmZXm2jLBBG4jVXVGB5g8YspGMk0AR2NLRvJ
sOB4SXcyQw7d0+lEqDCGxjxa7HWBiz41BqvNK45cuQBrRyXAGCeUE4OQI+LrYAP9
lIMc4XA4c86o6VR8TJ3mC0hpf2tyC69voScmhOjQGbcWm5M3EW2Ks3qLdllidSzE
YtUizHpctcgXtsckJOQaOvV43jesJtTmbesByKDTGK0eHfxZ7HYFeWpmMrXcCRMx
1j5L+D/gsETdyHiBz4o/+iBrVBcn+mb8+GaN4uZlzrhAwNMNUK/VVGWDjW4zXoiL
huviT65LqpoWpB9jp3n0uGc+zboh9MdaXqCdpWEyDgKnwmx7MH0p4hcJ17MPzKvA
h4V7mLqOukSJtUBRgh6ExIeA0QX7amrQbJK6y8srtO9pGinpaQPxFx4DS7Ytw5CM
zaJZJsFnh90g0mTZ1OpdhB/acIFL5SEOoMmD/rNb8HAfZlp3lGNaMbR1frrQs/ZD
qJyu5nC7KEq3Ke7vu8AuX9LSTR7D8RFqL0xQ5tizm9wkDD84tIbFe4qR1caxQykz
cbgEAm1iwOM+rVzBqvAiL2Bd4M8Z6Y9J0iHazEq0vpmyhKCFfpPXUK8OqbTD2oCJ
GKwK/gmTlysJATJlRu28
=5OMS
-----END PGP SIGNATURE-----

--=-BXLkoXYnchRiBy1H+UdW--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbYIOUeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 16:34:07 -0400
Subject: Re: [RFC][PATCH] TX status reporting with help of an ack queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221510009.4511.99.camel@localhost> (sfid-20080915_222042_138159_E2373F89)
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <200809151911.32834.IvDoorn@gmail.com> <1221501417.4511.49.camel@localhost>
	 (sfid-20080915_195731_733752_74D2117C)  <1221501786.3700.68.camel@johannes.berg>
	 <1221505251.4511.77.camel@localhost>
	 (sfid-20080915_210128_632488_FB448E33)  <1221506496.3700.81.camel@johannes.berg>
	 <1221507551.4511.89.camel@localhost>
	 (sfid-20080915_213946_840165_74EE062B)  <1221507988.3700.84.camel@johannes.berg>
	 <1221510009.4511.99.camel@localhost> (sfid-20080915_222042_138159_E2373F89)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qPdia5b6G59b1aNfvoGs"
Date: Mon, 15 Sep 2008 22:33:05 +0200
Message-Id: <1221510785.3700.87.camel@johannes.berg> (sfid-20080915_223413_194650_147FA7AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qPdia5b6G59b1aNfvoGs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 22:20 +0200, Mattias Nissler wrote:

> Well, I'm a big fan of modularizing everything in a clean way. This
> whole mac80211 thingy is complex enough... But I don't really care as
> long as everybody here is happy with it. Let's wait what Mikko says,
> it's his code so far.

Sure. If you manage to split it out entirely, maybe by some struct that
drivers embed in their private vif struct, that'd be great too.


> > But ACK is getting confusing, we're just reporting status based on
> > reception (or non-reception!) of ACKs :) How about retries in the hw?
>=20
> Retries in the hw? I don't understand? You mean that as a name?

Well, with all this we won't know how many times the hardware attempted
to send a frame before it got an ACK, if it got one at all. We'd like to
know this too, I guess, for the rate control algorithm.

johannes

--=-qPdia5b6G59b1aNfvoGs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzsZ9AAoJEKVg1VMiehFY3N4QAMHy8vaCBHgShYoGLX3AtmXk
+0TfuTPHq3xmbfjDnLZfP48zSTDMLivHxC6Axeet3wXWmpR13540U98BOkmv+e2L
O/UOr02+/gftFxsxpBvkGcT0rbFcvWiroBsz/LfMbiKNx13Bgw4voXbPUojCswnr
pC9/1TQdkIegVfqPEIL+xsrMZ3ufTTXCIG+JUg6Us/M7gSc9AY8S2ekCLzBVnGh6
UTDC0YNUVBoIFj90nmeliBRiB3zzIc5dFWbBQGbAtWPAbT7MjxSI3ZnY/RTqNVRX
AgkJHx+Mjlmf8WUCqlWaSQMWNtJJ05V1gS2SbHV37uud2osUjN7csAhKscJZGtgh
VhtAI7EqghQ44GKoXdrWg7wOzkhYNWVLAtZhh7ZqsziWrzeuVh9+fLEKz99sQDBC
qwA7AP+ZL+NJe5NWnEcsv/ugIf/7UCwDe9W31C7jp6Rf9YB8Rog8eg0Z2wsuzdF1
NS2f6fRQm0zS52JBZ/ZAdNgu5IaZsiQiT9pI/q4b7gxJtQov2KwW4Tft6pP2pMJf
g3DlfnXXl+Q+7Uyu3OtuwLJ1ss1A3LVqVbeIIAz31HB02Uu9FYvBbigcp+zVWERX
eULYst9tvbHRstg/ndu7SFaHRVIAxtCu+13CF/QAMKKvq1dsyQ1weVUhrnICWFm5
aNQA1QgcFgIDPzAfU43Q
=hMZW
-----END PGP SIGNATURE-----

--=-qPdia5b6G59b1aNfvoGs--


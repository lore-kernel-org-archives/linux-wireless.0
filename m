Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbXLLR2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 12:28:38 -0500
Subject: Re: tx_status reporting of RTS/CTS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <1197412922.7030.11.camel@localhost> (sfid-20071211_224234_989906_7701C071)
References: <1197412922.7030.11.camel@localhost>
	 (sfid-20071211_224234_989906_7701C071)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Jv0EEsTeBuW7sm6fjwE1"
Date: Wed, 12 Dec 2007 18:15:02 +0100
Message-Id: <1197479702.6558.125.camel@johannes.berg> (sfid-20071212_172847_752248_F3A173D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Jv0EEsTeBuW7sm6fjwE1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> rt2x00 devices can't generate rts/cts frames themselves, but rely on the
> driver to generate them. Also, the hardware reports tx status back for
> those frames. Now the question is whether these frames should be
> reported back to mac80211 using ieee80211_tx_status[_irqsafe]. AFAIK,
> this has some subtle effects, e.g. they won't show up on monitor
> interfaces if we don't report them.

They never show up on monitor interfaces for all other hardware because
there the hardware handles them. How is it that rt2x00 cannot handle
rts? It has to at least know that an RTS was sent and to send the frame
only after the CTS, and that needs to be a MAC function and cannot be
implemented in host software.

So, I'd think they shouldn't be reported at all.

johannes

--=-Jv0EEsTeBuW7sm6fjwE1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2AXFaVg1VMiehFYAQK90RAAq1jGQWvXHA0OA/c8f15ouQUY0mdtMlCV
651hrpWK8oaFAarkoxcqhzKOQWr0a/VqUaBULFHjuMCfOeBTTRN4k5blNJWNLDvo
zSQ1ZaR5ph6J8v7rsZ3UtRKNZWc0ykter0alT1hcIWddn0KO96hw5gZhVqKtzY16
DaW5e30wwwmlNbIxoXJ8nPrwC3uOzRTYwcW/C4dBzBCdle/LBPh6c2ibeBD6KH4W
vMv1e0cbcQrljbX9OiHMmMv4nvBcm4wSrXNRX2BcKVPLXJl0psTAIHz6UjLX3qyl
9O+jIEx0L1RNXCnvSiOaMMQAOe+ya+chprXCWWt3UqTJopK0LPx99XKVh+WnZFbV
bJUUDBBeCQe3wist02sXgJi5VcQTIq8lI1F39EcyTqmtISkmVpD+JNuZxjZjoFwM
CsWk2nEBkECa14Rxsbm1xoVU34PZd2Cz4RGqrqIy50IP9bP+wOGg17ykjl92Bvtl
yZNf2w+N8N+OahNSyxDG2pd9JUvygXrNPDmqwJ44XS3bTY89k7TynOOqJkV0Dy5e
ku3JTeHJJUiZUIFmPujaLvNluYWdhOrwZHP6EKpER05fvrwa+eCQ+R75WeMQwCd3
MMx4CMo2JFNZskBbX0VokdpkAwLWvlLbF3M3TRGZXrXzI8ZlV3bnjt4Mq25v2Yad
LaZmhlvEwoM=
=SD1b
-----END PGP SIGNATURE-----

--=-Jv0EEsTeBuW7sm6fjwE1--


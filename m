Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbXLXVpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 16:45:45 -0500
Subject: Re: Strange mac80211 oops
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200712242237.28913.mb@bu3sch.de>
References: <200712242237.28913.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c7lo/7vbeS/u2DcIRCSb"
Date: Mon, 24 Dec 2007 22:45:35 +0100
Message-Id: <1198532736.4103.44.camel@johannes.berg> (sfid-20071224_214550_097878_F699D24B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c7lo/7vbeS/u2DcIRCSb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> [   98.415423] ------------[ cut here ]------------
> [   98.415627] Badness at e221c924 [verbose debug info unavailable]

> [   98.416905] NIP [e221c924] __ieee80211_rx+0x48c/0xd44 [mac80211]

ieee80211_rx_monitor() is inlined into __ieee80211_rx() and that +0x48c
is quite a high number, so I'm guessing it's this:

        /*
         * Drivers are required to align the payload data to a four-byte
         * boundary, so the last two bits of the address where it starts
         * may not be set. The header is required to be directly before
         * the payload data, padding like atheros hardware adds which is
         * inbetween the 802.11 header and the payload is not supported,
         * the driver is required to move the 802.11 header further back
         * in that case.
         */
        hdrlen =3D ieee80211_get_hdrlen(rx.fc);
        WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);

johannes

--=-c7lo/7vbeS/u2DcIRCSb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3AofqVg1VMiehFYAQKsQQ/9HGuFLB+YXTPMtfV/3D0g4VOT0PAUUYKJ
K46n/mEx1wj9/uh//IlKg+5VB+bxFv39tFGjYDo0EgnxTuecDFrQG9bPSSP374m6
5NVAzutf5b05gIkJmHyDPwBWYALwD6SSTqEzRcJ2l9wVau11wjddBBkSDsHfOTtw
J09KJrte7Paep9ZD1pYuR4wMx4cs5YpZuK8RJFjv2jl/rV70atSA+iHPytbXQRE7
GrBHlarGlVrnCXczm2gtIKU8AzjdyOKDsRq2o6gzkwcm3+AZdbXjTeWs/QH2ra7S
XIUrrH26Sr/3+IQgUE6LHpeUFz6XOEHJlcZbnRxfO7NaqAShOC3FhuUMWK+brD/u
RJCXfwCg+bJKf2rHk2FXfTtoio7m3rixSGpyfiHA6xptGwqPnTv9vCvDokIh8DpS
1yps0uPRxmI1k1ZzFQuhe57TtEb8gpY/rXSq9qCkHhiv63BWZJ3BKZIfbk09bNfY
JuOaIMuyX9xVmWJAeOj1T9sklWkvUjupH9FPP+Fffb2PlH6cE1cjCgTw6E0Be8g8
Blah0EqhDG3xH+kUVunp+DL+jSGfw46HlIi6MdMskKDU7YL19mhfr2abzgUsPs5+
5boPq6SWI9kTuyJg+jRMTDOJrBdj864tFMvIZ2OJiX3f4oeUHPSe6wzSfIvzaMaz
e5XgL/YW7mE=
=K+sJ
-----END PGP SIGNATURE-----

--=-c7lo/7vbeS/u2DcIRCSb--


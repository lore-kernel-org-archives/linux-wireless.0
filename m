Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYK2MVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 07:21:38 -0500
Subject: Re: [PATCH 1/3] mac80211: add power state transition callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>
In-Reply-To: <200811291315.01685.chunkeey@web.de>
References: <200811282345.48379.chunkeey@web.de>
	 <1227951709.3542.1.camel@johannes.berg>
	 <200811291315.01685.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-p5YwORdEqFNTnDxq3V7J"
Date: Sat, 29 Nov 2008 13:21:33 +0100
Message-Id: <1227961293.3542.7.camel@johannes.berg> (sfid-20081129_132149_652362_7060F406)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p5YwORdEqFNTnDxq3V7J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-29 at 13:15 +0100, Christian Lamparter wrote:

> > Unless we want to defer RX packet processing to a workqueue rather than
> > a tasklet?

> Hmm, but if we put the RX packet processing into a workqueue, we have to
> put the tx status report processing in one too (see comment about rx/tx r=
ace
> in main.c line 400)?

Yeah, probably. I don't know all the details all the time, so I write
such comments ;)

> Or do you mean I should only put ap_sta_ps_end  (& ap_sta_ps_start)=20
> resending stuff into a workqueue? (Yeah, this makes a lot more sense,
> and might actually work!, well let's prepare another patch)

No idea!

The only thing I was thinking is that it's not a good plan to have a
callback that has different locking requirements depending on a
parameter.

johannes

--=-p5YwORdEqFNTnDxq3V7J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIbBAABAgAGBQJJMTPJAAoJEKVg1VMiehFYlnkP93E0dbwBP2nN2U+4Y/tZOxAc
rcPzxS8E34PEyxuyZnYns/0AH/xFlpz+6h8XhGCBl/kxO2i7qqsZePCW1iB6PmRk
K3SHS34odaNoIfAq+Ot1KgJkgU7eYSJnRBCzYaW8CANt/K8acI41ldcfQWEwOLNt
zUXNiWz8im5uPPmFrvOJte3ctWVMkSYbHTHwI8RFbbHpgzQFuL9cdByXhyTbXmh3
7d/4uFuTEgTizl+GR2OhfiA9KWG2n6b7uoR5pVBksoqxa3fXdeCYVcbHctTiGvVN
ZW4hWsnoc8keUqcOFHl20Za9zYMkwK+Mny3vkwcDVhjgOLL7b3HR1CndQLienXeJ
rL3immZRzwNy3+J+sQxNmJSw+Wet8EGEa3MuApRK6chksVKJe4uS9n24/4dIlCDv
pAATfeBAgptqddfeSUSDPgMPyF98gMlYYM9F32wfdaCj89/ns2df+Wx4U13iRz0s
3MoiwXuViKwVHUr57KlGaOO/hmKdIFsl7I/i1KgGgjPX0qofmcJezAF82AJC2i73
5X6bzrYR+xjhU1bNk7XxhqT1MLYR8FCiYGuASmyVA7RSO4uUjT85mY7dus1VWqH7
rZ8cBvKfnFkKB3DzUmSBWBnL7F9IalLyZEcmSgtRvpZpeR6fsc39OmTj/I5//DpV
YxWtpQApsh+EJsTtFUE=
=8H2l
-----END PGP SIGNATURE-----

--=-p5YwORdEqFNTnDxq3V7J--


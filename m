Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54143 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYA2L2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 06:28:18 -0500
Subject: Re: Kernel Panic in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <47996701.8000804@lwfinger.net>
References: <47983B31.4020304@lwfinger.net>
	 <1201185235.3454.93.camel@johannes.berg>  <47996701.8000804@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-J860XtcZEEIwPKsRCo6f"
Date: Fri, 25 Jan 2008 21:59:17 +0100
Message-Id: <1201294757.9397.2.camel@johannes.berg> (sfid-20080129_112827_402830_26F1D0B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J860XtcZEEIwPKsRCo6f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> Code: f6 44 02 08 10 74 12 45 85 ed 78 05 44 39 e9 7f 08 89 8f 24
> >> RIP  [<ffffffff88202940>] :mac80211:rate_control_pid_tx_status+0x426/0=
x45a
> >=20
> > Damn, I've seen that too but blamed it on my own patching. Stefano, any
> > idea? IIRC some sta struct was NULL in pid_tx_status.
>=20
> The problem is not a NULL in one of the structs, but a runaway loop.

Ah, you're right, I remember now that the access was to some random
rather high address which matches what you observed.

johannes

--=-J860XtcZEEIwPKsRCo6f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5pNpKVg1VMiehFYAQLCFg/8C7X9XRrAj/dTvzrJ2kMoDU6Fthbg39JI
mGo2eJ0aPU0qP0qeuOlXEh3wxG+8rmFxhTo2fMhzjUz45YTGmNR49Q1y1F/LNjyo
TBH4ygp6p8G0odt2SgxiHf87+IZRZ+JSW1Qiwiz8spahpNQGm4Or5mIn4sF/r3oV
Np5Rc6ng3qHTj2PwYRRGP9e3J8txe8VwmqPnd8wz5HdRNfj18mWE74YoP7QUICIv
pL75H1mEQtt402NJSm5yO0ny4ljs6515eT8w8C7irjnX/FSHphpV4wLUWywuvg4l
YwT4Vb2uJLu6yjxeuRy4rQvComBJnX+GOuvq/N+dJUlb0W1K2GgZXKBp3o23qDIe
iJw8vC0Nj+YrdtuPlqYN3IF+WbX9VjOpEPzPbWiWDDHkJeiFA1rG5Zq7GbxjMPWj
sKWuA1tuUBtps4wBFiAxv2yyVt9qRLIr969ya9iWwCfx8kbZ1Pec7gaycXgKYkFc
c6s4ZGTyxYqc3bTcysSanKlL4hdZuFimRkUydF3y62M/PUJ5VEdcRQaJ4r/RYquE
+YFQbY+kDOzCtYRNoN4hsS7B8xQqh+4vIw2gpwyT3VNNmCY6YHZZPqt10SkPpTgo
YwOsw+dmTxdEH4vdggUU23g5hUn3Mg9nXquOAkMN2f6M2D+0z8aiW4vqWxL75zs9
xhWIHBtC+WU=
=7duA
-----END PGP SIGNATURE-----

--=-J860XtcZEEIwPKsRCo6f--


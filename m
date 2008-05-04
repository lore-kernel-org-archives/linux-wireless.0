Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45000 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYEDWso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 18:48:44 -0400
Subject: Re: mac80211 truesize bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080504.154540.214129591.davem@davemloft.net>
References: <1209904088.4065.11.camel@johannes.berg>
	 <20080504124542.GA1455@gondor.apana.org.au>
	 <1209909990.3753.0.camel@johannes.berg>
	 <20080504.154540.214129591.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wiiaCynr+lpV8e7XFNY+"
Date: Mon, 05 May 2008 00:48:31 +0200
Message-Id: <1209941311.3981.13.camel@johannes.berg> (sfid-20080505_004806_943831_4AD01810)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wiiaCynr+lpV8e7XFNY+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-05-04 at 15:45 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Sun, 04 May 2008 16:06:30 +0200
>=20
> > [  256.241496] KERNEL: assertion (!atomic_read(&sk->sk_wmem_alloc))
> > failed at net/packet/af_packet.c (225)
> >=20
> > any ideas about that?
>=20
> This is exactly what happens if you change skb->truesize
> when a socket is still attached to the skb.

Ok, that makes sense. Then it also makes sense I never got that warning
again, I had left one of my test patches in too long.

johannes

--=-wiiaCynr+lpV8e7XFNY+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB49PaVg1VMiehFYAQKJ3RAAoXTvAuBKbxvTD3REHfplf6JKTt1Mf2Mt
kQNKKA5S3pDEEp3Gl9gD20ALtjT3ascyk/cfbUK+9urThpDwZQ9dfsvK8ykuXIXA
1kgLxMA+awSav9rhm2xpkzCqqoRxfkMD0dpaS2GeJi/dp/P7eAoxWvi2LkS3ovNb
3PGa7HKHEcIsgyBCQBwh/ODOzLISW+m7mOBJeJSZK1aJ2Ys37sjD//T8UkKy4KAy
kct0kklYBbeM2yajRS6B6ImBM61myITPAblvJMJd8qOueqRUuPlIzkx4ezEmBm/5
qOlPdKd8uTBYpTCxghcxXz7xlaX1ePxuPiPJpWPPslX/2f/AXCwg55wi5l3mZFaj
e/98gCyJLhkO2dTpSNqD+tOGO5/HXHV7CCrMVBbLvLgHvS6HLjbKRhSkieWYSbNB
YasnM2EYl69YNU+FSOOxXIKRHFz8oZh6iLvTEwi3SaaKNfvY0Kn8FYzMGs4Ph0P4
hBpgHo6pHxXQdR8xNWTIToeNZcT/KCq0D0J/O8zdeNmcGPXPk8USGeOgXvCEN7mn
rLRA+4rww04NgayFeAdl6WKYbE5ClKgE8qXtj7fGL7G/LhKISMEXTlVfmePT5TQK
xsXQ+xUHLZ0fQw+s2pHDh2AnOSgl3wfzeMNOjhUWcg4psRm1/iMo3rF2dyi17ykr
TEi3xqBLlYA=
=9cNC
-----END PGP SIGNATURE-----

--=-wiiaCynr+lpV8e7XFNY+--


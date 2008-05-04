Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbYEDRr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 13:47:57 -0400
Subject: Re: mac80211 truesize bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1209917006.3753.2.camel@johannes.berg> (sfid-20080504_180307_553231_1D0CF66C)
References: <1209866916.6210.39.camel@johannes.berg>
	 <20080504021213.GA30660@gondor.apana.org.au>
	 <1209867740.6210.46.camel@johannes.berg>
	 <20080504031652.GA30993@gondor.apana.org.au>
	 <1209890847.6210.51.camel@johannes.berg>
	 <1209892489.6210.56.camel@johannes.berg>
	 <20080504094444.GA541@gondor.apana.org.au>
	 <1209894754.6210.58.camel@johannes.berg>
	 <1209900355.6210.64.camel@johannes.berg>
	 <1209904088.4065.11.camel@johannes.berg>
	 <20080504124542.GA1455@gondor.apana.org.au>
	 <1209909990.3753.0.camel@johannes.berg>
	 (sfid-20080504_160619_267031_C8D61782)  <1209917006.3753.2.camel@johannes.berg>
	 (sfid-20080504_180307_553231_1D0CF66C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gpAn2hDt8EKy96+lvFWr"
Date: Sun, 04 May 2008 19:47:40 +0200
Message-Id: <1209923260.3655.2.camel@johannes.berg> (sfid-20080504_194721_979379_07EB6D7A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gpAn2hDt8EKy96+lvFWr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > [  256.241496] KERNEL: assertion (!atomic_read(&sk->sk_wmem_alloc))
> > failed at net/packet/af_packet.c (225)
>=20
> Except for that,=20

Oddly, I haven't been able to reproduce this, so I'll clean up the
patches now.


If I have a device that needs 100 bytes headroom (not unheard of),
there will of course still be packets that don't have enough headroom.
Should we skb_orphan them?

johannes

--=-gpAn2hDt8EKy96+lvFWr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB32u6Vg1VMiehFYAQIudw/+Na3Nw9rYuA7K4quD16gDGC+Z+yMKsqe2
R6mRF9NPpKBnO+RyOEr6IPdA84CcMX8GJAc7lmlPTFq9C8M1qPrTO2cISfnNQbdI
32T1CYsgbyDubO+N4/KApi1ehFkO7pr3NwRG6rHZvCZ7xFhR88gJI2BcCK0zslwk
ONlNlh1gs49e7J9eJXUU+8dj6so88+dj6gWHiHjlTRWXwZxQ3RhJUJlJtj3NX8Hq
71Adx+U5xX1goHLWcsHv8Zxch2jLlS7QI3gbBs+rD0Tw6vlYGrxH007VSzXxMgIE
gpzVB1vMMidHz75erE7vzjmwlNggVyzlVQItD5TuEqXsPych8c39MyVUde/VoPL1
3Z4fg31Eug1drNenr2l5RV9+87MvS3WJs9b2axiv2N19IH8auB9ZkJ+WafRoJgTM
OrgIWcZurc74H+YRaaGkCPd6eoiqjD3fgyGv9kaLB5slovyCty2no5n4mvCAYozl
4GfcQ83pikpIMRx6zjXhxYlDsRtyHiLsEPmkJohsgTHMwaTwsQbS9wZ418vC0UKd
O9Nj7OUlp1px2nw+ch94oRSagiTSzarH3TU/sxpeAOJFERSuGqlExoA7GDjvmfOo
fcYSaTwCRzqc7olvH1Emq3eXx3JAf1EbNhiidI4rdFrC6t16AyuU9ny7PGw+XOWp
Tsp+CguoP9Q=
=6eYc
-----END PGP SIGNATURE-----

--=-gpAn2hDt8EKy96+lvFWr--


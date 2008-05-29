Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYE2Hua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 03:50:30 -0400
Subject: Re: question about ...: wrong count at exit"
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200805290937.22146.hs4233@mail.mn-solutions.de> (sfid-20080529_093731_142217_77BB66EC)
References: <200805290937.22146.hs4233@mail.mn-solutions.de>
	 (sfid-20080529_093731_142217_77BB66EC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gIjhF+lbk0KINtxEC/x0"
Date: Thu, 29 May 2008 09:49:21 +0200
Message-Id: <1212047361.16917.6.camel@johannes.berg> (sfid-20080529_095048_399395_8C82FB24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gIjhF+lbk0KINtxEC/x0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-29 at 09:37 +0200, Holger Schurig wrote:
> After pulling the newest sparse, I got some new sparse warnings
> which puzzle me. Here's one of them:
>=20
> drivers/net/wireless/libertas/main.c:477:9: warning: context imbalance in=
 'lbs_eth_stop': wrong count at exit
> drivers/net/wireless/libertas/main.c:477:9:    context 'lock': wanted 0, =
got 1
>=20
> However, the function looks quite innocent, and I cannot see
> any imbalance there. Did I oversee something or is that a
> problem of sparse?

>         spin_lock_irq(&priv->driver_lock);
>         priv->infra_open =3D 0;
>         netif_stop_queue(dev);
>         spin_unlock_irq(&priv->driver_lock);

I think it's a sparse problem caused by my patch, I sent further patches
to fix it but they were never applied (and had a slight remaining
problem too). If you look at the pre-processed function it should become
obvious.

johannes

--=-gIjhF+lbk0KINtxEC/x0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD5gAKVg1VMiehFYAQJmEg//aQt4p3ErVaM91WwYOP5pRK1EVnFJQgPi
p+LNPH0fIZ6+3GHgbnh4sbeKjaHkTiD8eM00Yvd4yvrJoHIwwa6QkMl5QbAzK/xv
k/fWysYF1iyr1Cv9tmYGkG2OMaRzwsTbpQl1ZlA7grFXvrqmWsXMBVfdETdwzp0c
B3+XU/psKdCGPUDIKydZrc8VXibFbGgbEeYcyeKzUFkhbnVlPUdAfWv9SSNHH2fn
u/Y2qdKS0K4zS/RbOB11ZfrdF3VVeKyEAu+mjHKdi5+Robm3zS7TWUFJHwWDJ5BV
k+aLyOnoEL/CG8eRSQNXwuHP0nSSfOjCCYJOAjiBmNgX8uhZU2jcgaNq9mCdshgy
/O1DvZFAg0z/0NG3BOmMfacsMslgYLu3Mp3jbiT8c99Mrsd6QnQ/6grR4cegnyEP
HZmDTUMu5yKYjdmjQs/b9K4JMYq9Oxk0UxwKFGLWKvV9GmWdDhlyonG/7OdLvaFr
DK+exxrs1VXbpO9Cf0pDBhaeq9IIDb/Ab8okd2FZ/jlmmMV6CyJ79OIpDtbfTMZ9
Agbrgsh32otbNNISkD5Oy+GE1J0f2svqmkZKUx9WDMJA8zGEXpfS+nVw7+frWec9
GPx3fksjoMgXcg7SEObJIfBRzWgm4nvb5EFT53iOFwi5z6Xnokvg1qewBwxm9tMR
jblt7CWzPSc=
=g9DB
-----END PGP SIGNATURE-----

--=-gIjhF+lbk0KINtxEC/x0--


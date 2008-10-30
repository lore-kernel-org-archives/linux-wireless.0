Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47579 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYJ3XHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 19:07:52 -0400
Subject: Re: crash with rt61pci when resuming with card ejected
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810302247.28609.IvDoorn@gmail.com> (sfid-20081030_224734_416436_2229EB9B)
References: <1225361553.3690.3.camel@johannes.berg>
	 <200810302247.28609.IvDoorn@gmail.com>
	 (sfid-20081030_224734_416436_2229EB9B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KrpKjZdsu55eKvxDGMW+"
Date: Fri, 31 Oct 2008 00:07:35 +0100
Message-Id: <1225408055.3535.1.camel@johannes.berg> (sfid-20081031_000756_625019_4DDEB46D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KrpKjZdsu55eKvxDGMW+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 22:47 +0100, Ivo van Doorn wrote:
> Hi,
>=20
> > Maybe it was stupid, but with USB it always works, I suspended, ejected
> > the card (because I had to go and didn't want to resume) while suspende=
d
> > and resumed when I arrived at uni, to find the laptop crashing.
> >=20
> > http://johannes.sipsolutions.net/files/rt61pci-resume-crash.jpg

> Heh well these 2 functions are the most important ones in the trace anywa=
y. ;)
> The only reason I see that rt61pci_mcu_request might fail like this is if=
 writel()
> crashes when a device is unplugged while a driver still has a reference t=
o the
> register base pointer which came from ioremap().
> But I don't know if that would be a valid assumption. :S

It looks like a NULL dereference to me. Look at

http://johannes.sipsolutions.net/files/rt61pci-resume-crash2.jpg

(ignore the first backtrace, it's something I always get, but it allows
me to see this oops because it turns on the console early :) )

johannes

--=-KrpKjZdsu55eKvxDGMW+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCj4zAAoJEKVg1VMiehFYCrgP/20/lqsaRDMpdLhhaRV1Gp3w
jueYISz4+PRc0bdb5sVFmLzMiRxRcKSoiURG1HtU80XmyVIfJe90zflzxOjLYGWS
noJbWyIaTlqeZ+5CjvbQnbtrc74m6AcSsIeX7AH0eVvZN8+x3U2anmwK+wGnqp9k
v6TPskG8JU0HILr3TICCltqcg9jKw/mutgrhY9IOXNX1/1vfpAgZTxnKWGzAej5y
r63F5Wvv8ofqee6mZgdmAEmItpV5HDm09CSmOxntKLrVmsqAbxILVZNhfPhFMnm4
hJMYl6/djm4Ptvxp9j3TvhljznmeXQOZcaCiZ+xoKCawj2eEcp6qU8MlGGL0b1bd
34deaG+OcG/RxSdmWqydKYQus05wf2t6kTTEKpMNxjXaLVnzm7s/Gt70xpOoqZ7a
d5uH+gTMl3LrFb777zeK0cTsFKNRw6Qf0uEuGQPpddHYh2YF6Z91YmesjhGipuSg
vQDF/TayMY3uh8q5P0lt7gk0C08uy0bNjwKFgHktj5oUBKDT2F+FV2szZMBIixoS
+pklm4S/7EQyT5rklWlc7go045j158dWwGAJSVi8WUyJH36dx6vU7p5UAExXjBcv
hrnPQfTRUhdxq5oaixoY1Rb/wWghR+CV3oKNq3pGOmHfj3MN/WkoCCq7WAG6ESwJ
HSC1FLS8JZeVkcYq0EOm
=lXRO
-----END PGP SIGNATURE-----

--=-KrpKjZdsu55eKvxDGMW+--


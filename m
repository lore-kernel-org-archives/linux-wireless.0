Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbXL2OkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 09:40:22 -0500
Subject: Re: Warning emited by 2.6.24-rc6-git5
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org
In-Reply-To: <200712291529.10357.IvDoorn@gmail.com> (sfid-20071229_142858_091423_1B2A787E)
References: <200712290942.37396.chris2553@googlemail.com>
	 <200712291247.54258.IvDoorn@gmail.com>
	 <1198929568.4172.37.camel@johannes.berg>
	 <200712291529.10357.IvDoorn@gmail.com>
	 (sfid-20071229_142858_091423_1B2A787E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BTN+FjqpKs/a8LK53xJq"
Date: Sat, 29 Dec 2007 15:40:08 +0100
Message-Id: <1198939208.4172.46.camel@johannes.berg> (sfid-20071229_144028_674986_35607375)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BTN+FjqpKs/a8LK53xJq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Well Ralink doesn't seem to add this padding since this bug appeared,
> remember all bytes from the DMA was copied to the skb buffer so if there
> was any padding included it would have been copied as well. ;)

Not necessarily, Broadcom hardware adds the padding in front of the
802.11 header so if you'd start copying with the 802.11 header you'd run
into the same thing. A quick look at the rt2x00pci.c file doesn't
suggest that there's anything variable about the RX header though so I
guess that indeed this may be a problem.

> Anyway, I have worked on a fix for the padding and I'll commit it to
> rt2x00.git first to see if anybody reports any problems with it before
> sending it to wireless-dev.

Great. I just posted a similar fix in the other thread for zd1211, does
that look similar to yours as well? Should we have a static inline with
this code "ieee80211_needs_padding()" or something?

johannes

--=-BTN+FjqpKs/a8LK53xJq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3ZcRqVg1VMiehFYAQJkug//Xusj8IpdJ9OlVTs0NJOtuL/EM4o4539H
5zQwSmglRIu2AcO/d5wj1/kK+tfMvlVC+FAeqv2ii6qGG2IczGyHmATl1abnPEkT
oe0DGlNE6/acoAU7bMTNDqSgZQYG17bi+zszipuvB5NgUcUUAlTG8KEBOdm9UkWF
fSM5x77J2g+0tILI92H3dJEOId580g57fID0Z4nNUE1OuE7omHIR2BEAw2D4Kcdz
bDFbckbwKC3mFpEjD4yxLZ21NifCq7TVhXF/Fqxz+ztLWTg58HclaHMdvaiXcDYY
2YCpKMadwu884nkpD5LCFyOxEEvQnHH5oZQ0iPV03NA2oB7f9YR0fksOzJwooAiC
Pdtg8TqvnzIoGUzshrXulCE3EfXRuf5dYybPzs3ckNhlTnW+x5XLcuUqFvBRLj6R
VQqYlEFA+efLztjbTXWqi20qjVsPwyySE0r0+ia9F3lboFCiWJQdaYN2ur0I+q4Y
F47xxWqFwOan4Tv2jfbvC491FYmVSnXMF869hrOuD3l6F5v6JRhHSH9r/iasVdcC
sKQQPryHeasO0pxmgIa8NwrUVvScMLbd4X10T5VIukIndCZdJfeCqcWlCffvbLl8
7KIf3VZcoC7iwguqOfNEkER+kyTSEzTACWEgzOIaQM4SGzB9qYJ8E9hRcTwpaCVL
9i1eO+JlRBE=
=4T69
-----END PGP SIGNATURE-----

--=-BTN+FjqpKs/a8LK53xJq--


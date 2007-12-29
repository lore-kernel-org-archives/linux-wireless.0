Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbXL2Kg5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2007 05:36:57 -0500
Subject: Re: Warning emited by 2.6.24-rc6-git5
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: chris2553@googlemail.com, linux-wireless@vger.kernel.org
In-Reply-To: <200712291121.31120.IvDoorn@gmail.com> (sfid-20071229_102122_537113_95530FCD)
References: <200712290942.37396.chris2553@googlemail.com>
	 <1198922056.4172.25.camel@johannes.berg>
	 <200712291121.31120.IvDoorn@gmail.com>
	 (sfid-20071229_102122_537113_95530FCD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-REqksYWHcxfBT/uWNFij"
Date: Sat, 29 Dec 2007 11:36:43 +0100
Message-Id: <1198924603.4172.34.camel@johannes.berg> (sfid-20071229_103719_753703_0D914C0F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-REqksYWHcxfBT/uWNFij
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> If it helps as reference, rt2x00 allocates and initializes the data as fo=
llows:
>=20
> 		skb_reserve(skb, NET_IP_ALIGN);
> 		skb_put(skb, desc.size); /* Always a multiple of 4 bytes */
> 		memcpy(skb->data, entry->data_addr, desc.size);

So why do you copy all the data anyway? You have DMA queues and no need
to not have the hardware dump the data into the frame to start with, no?

In any case, with wireless NET_IP_ALIGN is pretty useless unless you
want to add two to it and then align the result. Maybe the mac80211
warning should be relaxed to take NET_IP_ALIGN into account.

johannes

--=-REqksYWHcxfBT/uWNFij
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3YjOqVg1VMiehFYAQLkuQ/9Hl2s4BjQZHi22c6Yo+gT7bNXdHOFv7k6
M5vifjr+W3mhQ4nE95iWq3zutHR+hKFqmGatQyqSxYSbJEJEHCYz3LLWHnuZy1h6
wRS/ZxVqYglmgwm7dTgmr0plhVDVD28zL65EywC1boc+kb4Q8M3YWmM5sttkrIIF
w+pyeApSkjCVG1PDzNPRjI/jsGRSbZJjkB1qGv7w5fal3eNvZcSMuF+hIo6rCC5f
MzWAxAvJK9S4+WKOLeDsGZUMUBy2fwnojuBujERXSv9miTVjcjKwimE1pI/sb9hB
/vfyfXTLAQJxLQNNgvfrtAz4ePWHl5XoUgJuRiiW2sztZLPsfYvPko+CcGcmglZX
eJh1ZQX6ryRkkeBYLZcaEJry52O8KJ/eGYzDg7GAw0nPKaB/q2h1hM/daaOIEGgq
mS9yal/vNXbD20XJUn1CE5HXB8RVWdyzei7ggP1l9TE+3TCWyN58XrT3C1YQ4i03
WufJhACv+MxH7iWFcIkzNGQflbKxA1UBkdKPW7P37H56qExQjekkq/o4s1i2ZlhT
vXQKGznwWMzuMgyhf4fW3XSnSVOhg883tss+UtCUKe5I9RlgU99fkOtGmi13g/G+
7m4KcvFsr6OMFgZghji2+2GUFGYIPACw+2sfXYf/dUTjGuVF2Zm6BAwEsP/bkMSx
OPwi0KI/X/I=
=97BC
-----END PGP SIGNATURE-----

--=-REqksYWHcxfBT/uWNFij--


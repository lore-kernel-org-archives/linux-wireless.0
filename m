Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYBFO6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 09:58:20 -0500
Subject: Re: [RFC v2] mac80211: add general rate information to Tx status
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240802060644k3f0b5e7cgb48380a2b3181f41@mail.gmail.com> (sfid-20080206_144434_491529_7C2000BB)
References: <12022263282085-git-send-email-tomas.winkler@intel.com>
	 <1202307331.4395.41.camel@johannes.berg>
	 <1ba2fa240802060644k3f0b5e7cgb48380a2b3181f41@mail.gmail.com>
	 (sfid-20080206_144434_491529_7C2000BB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jaqwv2s65DY8aWsdLHQY"
Date: Wed, 06 Feb 2008 15:58:05 +0100
Message-Id: <1202309885.9965.3.camel@johannes.berg> (sfid-20080206_145825_314653_284FF518)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jaqwv2s65DY8aWsdLHQY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> In general the driver should know how many rates it wants to report so
> in TX-response path it's allocates enough memory.

Yeah, obviously.

> Since on the TX path tx_status resides on stack this has to be copied
> by the driver for TX-response path use.

I don't think I understand? This is tx status, what are you referring to
by "tx response"?

> void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
> 				 struct sk_buff *skb,
> 				 struct ieee80211_tx_status *status)
> =09
>=20
> 	skb->dev =3D local->mdev;
> 	saved =3D kmalloc(sizeof(struct ieee80211_tx_status), GFP_ATOMIC); ---
> this has to be changed as well.

Yeah that's what I was thinking of. Maybe we should change the
ieee80211_tx_status_irqsafe() interface and require the driver to
allocate it rather than giving a pointer to a structure on the stack?
That way we the driver has to do the calculation, but we don't have to
copy things around? Doing it on the stack isn't easy, you'd have to
define something like this:

struct status {
	struct ieee80211_tx_status stat;
	struct ieee80211_tx_rate_ctrl ratectrl[N];
} status __attribute__((packed));

so requiring the driver to allocate it when using the irqsafe interface
would be better imho.

johannes

--=-jaqwv2s65DY8aWsdLHQY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6nK/KVg1VMiehFYAQJpkRAAsud5WoE7iNTKKuWZbDk6cHJ8eeNwZfB7
c7T345rnAqhOAFT0VtFkSn3VaFMPktzxoFVqCmh1B/XpCaUwvbcAirvmtCdVOUBa
EESjwvKdRjUsh76AAPg7nxTCHoPALwJwCLK5N0p2nPY894804qHkA9rDcTJ3eqOZ
eP9ziiZWz9ZkD7ckdstm868eur5PzCaKG1CsXqNz/bPMuwF1H/P+fVW84WMH3N5J
9MnkYuGWDYKDAMzH+rnjXubn31OnWa219g/0A2umkrZW+WGtjWPq3bVqCagUtPzH
0Xe17IixN6QTOBStQHIQz3R9b8mu9h2RRJCX4HPIRdwRr4vFf0P4Y84DGDva552e
9HYxWO/eAzh1cG3nFWEMpl0AMKYi4v3jkAXE/gPkm0KMPyCKNbWX0BBYr87RJWVQ
BusoRsTd4yZqjwfajOBM2ESLLWPlsz00uZHu16av9Ie3v8nZE4v00r4O70CE7HfN
n4YymtJ8FFouVgNcwdxPC8CE3EGIwpMBJJfhmF6aZm5XMMnK/ebE7neBNWYsJ4nY
UCWt6nuKwaB4IVyzQ7SLEOZvdGWLL9y7VyPEFs/twWFZSYMolSweQ5kK1wJNd/Vq
7qyB75WYuEHn9oDln4PIaA0QNJ4Wz4NUEtbp9BGP/XftU+oS6QCP7lH72e70W7yL
+k3kvz04pe0=
=W5CW
-----END PGP SIGNATURE-----

--=-jaqwv2s65DY8aWsdLHQY--


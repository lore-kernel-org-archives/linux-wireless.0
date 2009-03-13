Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZCMK5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 06:57:22 -0400
Subject: Re: ath9k fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <18874.14867.311121.242263@gargle.gargle.HOWL>
References: <1236881434.25931.1.camel@johannes.local>
	 <18873.48952.353253.595670@gargle.gargle.HOWL>
	 <1236934984.25931.48.camel@johannes.local>
	 <18874.14867.311121.242263@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LaruY9HQid9eD0eMsaM2"
Date: Fri, 13 Mar 2009 11:56:47 +0100
Message-Id: <1236941807.5235.24.camel@johannes.local> (sfid-20090313_115725_571371_CA3E790F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LaruY9HQid9eD0eMsaM2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-13 at 16:18 +0530, Sujith wrote:

> Managing per-TID state to handle Block ACKs, failed sub-frames,
> sub-frame retries and other window management stuff.
> ath9k manages all this internally.

Ok. I'd have to look into it to understand what we could do there.

> > For ampdu_action(), I recently saw something, somewhere, saying
> > "mac80211 expects us to fill in the seqno variable" or so, but this is
> > only true if you don't use mac80211's sequence numbers, otherwise it is
> > fine to leave it at the pre-assigned value.
>=20
> ampdu_action() requires the driver to set the starting sequence number
> for initiating an ADDBA session, ath9k was filling it incorrectly.
> This was fixed in the patch, "ath9k: Fix bug in TX aggregation".

Yes, but it only requires it to do that if the driver assigns sequence
numbers, if it relies on mac80211 then it doesn't need to touch the
value :)

johannes

--=-LaruY9HQid9eD0eMsaM2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJujvtAAoJEKVg1VMiehFYst4P+gPUk/cm4oVHKetofF/0VWpW
yU1RpU2J9R80LndMosp5zj2vTxPDYRQJFn/DDTHB5ZiVRjOFmSoqZGKi63fnRSVJ
NzXJexJS2KzCOaHD7GI4rrvHna1AAHNYvvan1td6Y2+epftpfseuPV7exB5w6lGk
D7+cDoPwk+Q3V8LMQoZCPOyjWvpY38hZt5IQpgc0UIX9Vzv9jjH/3mXBGavVbARf
oG6H9pJ0DFi8gQnkDGzITWFOfxowLuSrMPsqBAVd6F+G+fdeBiq8hgFX2tG1Z8L0
oXiYl3fOvqStEtR1VMoQMNxPAX5AAukPaGp6C+yvLguUEZo5l8eQPRXPKezFpO3l
ih63seQFiD4vXpdB4VW23nosUlVaSvvtjMrmHNfJAOEU0729075XflcxlBN2CtV7
RXlKs2klKqrzt7ddKHJJlOvYH1DgLuB4itqTWNriLXj4ZCybaILDedXwZsmCamGA
C9UIdNCEFSXytRbWuP24MWRYBgSOLpMPZ5SU5jaYvnaOQwvc/CXI3aYrX3U3CVEH
Udz9w6c6ZpCeUoMNAebyeO5pq4UzGvGMBnqmIbqeBX1rvno3OLhnfVEADaQiDgGE
2xIdXh9Va8y+6GMSgyRIVRczW9D+uIW5qjRVDK/7L8/jXCIL2vgvTBkDH1imDssp
Ew5JCUU7g0QMROth1ByO
=kkt2
-----END PGP SIGNATURE-----

--=-LaruY9HQid9eD0eMsaM2--


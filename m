Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZA0Ki7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 05:38:59 -0500
Subject: Re: [RFC/RFT 5/7] mac80211: fix race in TX aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com, Sujith.Manoharan@atheros.com, tomasw@gmail.com
In-Reply-To: <20090126184925.500822996@sipsolutions.net> (sfid-20090126_195229_608528_A11909E9)
References: <20090126184740.036240879@sipsolutions.net>
	 <20090126184925.500822996@sipsolutions.net>
	 (sfid-20090126_195229_608528_A11909E9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h6c+Hyy+WQz5pr8nl9pc"
Date: Tue, 27 Jan 2009 11:38:54 +0100
Message-Id: <1233052734.4012.29.camel@johannes.local> (sfid-20090127_113901_750052_29B4D074)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h6c+Hyy+WQz5pr8nl9pc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-26 at 19:47 +0100, Johannes Berg wrote:
> plain text document attachment (017-mac80211-fix-tx-agg.patch)
> When disabling TX aggregation because it was rejected, there
> is a window where we first set the state to operation. unlock,
> and then undo the whole thing. Avoid that by splitting up the
> stop function.

Need to take part of the 7/7 patch and put it into this, split it up
wrongly by accident. And 7/7 needs to be _before_ this, because this
patch makes the race triggerable.

johannes

--=-h6c+Hyy+WQz5pr8nl9pc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfuQ8AAoJEKVg1VMiehFYUOkQAK04NTdlMvZuGg0gGOsBkz2m
49NBw1IWAWQqVQ8caFnd/DDZn3Z66bHZUdm2kQhTsZYS5kuJ7Zdm3Dz3z3mE/v60
wCbVXblrQX51tZPQ7LkuvH7YiAHsTMkawZA5Ac5zMeLjHjN817d79CvAoNGtROaY
pSlKnKx5ru/cChlCGbitAUKdNIFvd6vmjzM67mEjfUtYarcOAKpGb3eDMZ7QcwAB
7bb2QyF1uR5IyXhzTRGajBstB8Nu06xOknt+5hFA5TTERdpRzSTOsqnsuWIiHR4a
cgfBdvDIUHy5USPwsR2grtok6dNYsWlqAB4j8Y9qvA8p8IRfIOtcT3qoscoa3LEv
GsL33YSsnrDP5RQcWE08rTCyKFceMDXesExlUmKHBhHzzTbdLFqoKhVqUTHygM3B
9mcYBLFw6dDL54F0YXvHjeEKjqLOwkNpoTPlOmjiaoxNScSClhyyPrAILOA5AU1o
585SfIFqAZL75WNf9Itg5vhybm32fZMq/4pv+/t5763WyA93BSCrHrMHq8VEv6qc
92DePoS164PAVGu4I/Osuqz7/9QUdVNFzQ17xcFT81PsTVtWSZghpPuir/o1PEC7
zIgu1Y5/8+CBzwcmILLA6qXqlKHULucQzlqr4mhrU6+fg+7nAX/76SFP3/GLSE37
W2sILKoE2Nkg8plpYqSg
=MS0E
-----END PGP SIGNATURE-----

--=-h6c+Hyy+WQz5pr8nl9pc--


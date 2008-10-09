Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbYJIJeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 05:34:18 -0400
Subject: iwlwifi: bug in iwl_tx_skb
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AAPk7lHeevX85lCF43YD"
Date: Thu, 09 Oct 2008 11:04:41 +0200
Message-Id: <1223543081.22490.2.camel@johannes.berg> (sfid-20081009_113422_501476_FD951153)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AAPk7lHeevX85lCF43YD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

When iwl_txq_update_write_ptr fails, you have a huge problem: the skb is
linked on the queue, the write_ptr has been incremented, but you pretend
you can just free it.

johannes

--=-AAPk7lHeevX85lCF43YD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7ckjAAoJEKVg1VMiehFYRQYP/0A4URYlWwXGXvPGl/poXTOw
s3xsk3GbRDTHrlFUZygw1AEoG98lppFxJbgX6FSwF9TeZKInIt9YIa9NSddoPP6h
PhfktondjlFP7SHRl+DaBiEzb39m2u6virPedopoI+GEgNlbeeW+YCVuiqlDlj1j
PuzAEKCOt39ezmAbl1KmridCQkKLRT87PKKuPEEJkXltMml5tpr6+rnLCnqF6zXr
OgSdkGt9R5AvESUZ3dOtUjukpFQyzzeUtCG3td8mT1aBk0W8Bz3xeT41CRnGbap9
gayVot9/VQFWsHuBR8TuqcMZxk8eQGazy7klsdb42sqDGwm+97ZykaTV6Eq1vcTx
Zz79fwuL3Vynd1JwecYgURU1Gj0HPpY3F0NYdglX7+MXZOZckyu2xiRKvvjzWrh/
6mjridwIIVb8TYYsAQ2i2lcJXNMO0ouPz9N2ndA6uArEyEPnFcJ/1R5YCIM1kryq
UaArhOs9gjr2OK2VyT9hs+hphrHDX9IHYUnl8uwEGN4190cQyQM4L2upD2MSerb1
XlPmP2s+qBltGKog3ii4R7j3eQ7l1BOniL3Egm9RX6XR7zA6/BKshdFhT0qaBgak
S7ys7cpzt4DT4lK7gQjHQuKWXxqANOLM6R/UltBXh4rzHV14ymttRcmk8GgMRyiu
rbsV6PjRzSMAkCXydseH
=WGat
-----END PGP SIGNATURE-----

--=-AAPk7lHeevX85lCF43YD--


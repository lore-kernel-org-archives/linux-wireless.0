Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43793 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbXKPL4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 06:56:17 -0500
Subject: Re: [PATCH] mac80211: fix allmulti/promisc behaviour
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1195178093.8147.91.camel@johannes.berg>
References: <1195178093.8147.91.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-65wGSfTfNv1W3NJknJrc"
Date: Fri, 16 Nov 2007 11:46:05 +0100
Message-Id: <1195209965.8147.97.camel@johannes.berg> (sfid-20071116_115619_876662_BB751B58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-65wGSfTfNv1W3NJknJrc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-11-16 at 02:54 +0100, Johannes Berg wrote:
> When an interface with promisc/allmulti bit is taken down,
> the mac80211 state can become confused. This fixes it by
> making mac80211 keep track of all *active* interfaces that
> have the promisc/allmulti bit set in the sdata, we sync
> the interface bit into sdata at set_multicast_list() time
> so this works.
>=20
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> I'm 99.9% sure this is the correct fix but I need to test it.

Done. This patch makes it work correctly, please push for 2.6.24.

johannes

--=-65wGSfTfNv1W3NJknJrc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARz107KVg1VMiehFYAQKjDRAAkjhK/1cGyF4DmavGZdY89bM8Z5pgxUwi
iFk0roCWXASh0e1maQDUOYHSGk4oqODeNK2ixJ4EoFZvsEoWb1sw3SPAt8ejPxi0
SwPosctvRTkmdPssQCtATJqDehO45yzS1ahi15IZzNWbtgQrTMSc1VCo237JW+Ch
1cqnvTo3US2htTXdW9b/e8EAFxFveoGAOn8WmNHFp6pv7pTvUUwXVATPiOlsVZDm
6yA3HktgKZW/u+b4TaR2yjT64L035nPd8HyzZlfkl3nc2DsxtaC74f7ypc4Fd2Ci
rU8CP3Vr6gTrjTmwtF88prI623ZdXGsIyY0flY8KoYw14KuuUVWLJqSb3Dmq6hVY
5Q5NbouX40tEqjCkzDgn/UZrojMPy9nGB+xoaEGuJRDtGJGYVLstSGyKlgXTNnL/
mNFSULhnQ7FLyVcof6DPZzXacKRynkPK3P1lY3vCKxtyfj4YW/UqXtIrLhNqB9Vu
uDePQYA2zhgkKQ3grQxZsReinf0/P6B5+kSsrhx4xhV7OUWmiFRcskr59r7JH5Yt
JM2PCaYvH/0ggw6caQCSxnxSWxyOfVWFXsVp9lqpHKoBX40ZRQ+cUIkPV89gAX61
/iFPiA9F52+maUyzvzcXnvUw4Pqb6bM9gbt+TI2aKQcS2ymQTapAPutnUSjtjKT3
7QboAHs6Rr8=
=C4m5
-----END PGP SIGNATURE-----

--=-65wGSfTfNv1W3NJknJrc--


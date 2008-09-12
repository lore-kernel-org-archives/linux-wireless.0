Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44041 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbYILU0E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 16:26:04 -0400
Subject: Re: [PATCH] mac80211 : Fix mode change hard_start_xmit function
From: Johannes Berg <johannes@sipsolutions.net>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: linux-wireless@vger.kernel.org, yi.zhu@intel.com
In-Reply-To: <1221241327-15720-1-git-send-email-abhijeet.kolekar@intel.com> (sfid-20080912_194212_937819_A2160941)
References: <>
	 <1221241327-15720-1-git-send-email-abhijeet.kolekar@intel.com>
	 (sfid-20080912_194212_937819_A2160941)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ccyCLvu5LADoM/oCg+d7"
Date: Fri, 12 Sep 2008 22:25:58 +0200
Message-Id: <1221251158.5576.14.camel@johannes.berg> (sfid-20080912_222609_625283_0AF6BAD8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ccyCLvu5LADoM/oCg+d7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-12 at 10:42 -0700, Abhijeet Kolekar wrote:
> When monitor mode is changed to BSS or IBSS, data trasnfer can not happen
> because proper transmit function is not assigend for BSS ,IBSS mode.
> This patch fixes this problem assigning the ieee80211_subif_start_xmit
> to device's hard_start_xmit function.
>=20
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks for the fix. Unfortunately, you missed WDS and VLAN. Please just
do the assignment once before the switch so that only monitor gets
changed.

johannes

--=-ccyCLvu5LADoM/oCg+d7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIytBSAAoJEKVg1VMiehFY5H0QALuf9D1T/JajIAEpKerssHoV
fGBEqq/WavQiBgZZ5EJoseqpgRYhyv9je3T6EUOH1vEkVYdqP/AR0pyq6kNrNaEI
It6T0ukxPJCodDDfi/ei8kTV/k9/mxPKVWpsNNdR0sHTUVBxYPIiCcejVdN6T8by
PMarjshJqbyPTH81Suy51Kg95JPkZQytcbCClMisJ3mjRvaW/D07Y1ZwEWvdgTaM
OPmTj/khwwMlaNJsWEhBr6zqAWFTW/K6hnlzpx8Vj30eXQQIjx8vrloMvLIiGvCA
zCOF4oFFwdciah0iEZbM/XtNuCpUQS5+DfzyNC9Jd85d/wKHKNzIHaEVfe51N8vs
H83YoWn+zxefP5RioMnymWNcG3lYcP1rci7wXnw7gsW7pcfXg8kbQAI4rIj4P37Y
Hx0ATtwWHYSy2IxWdJoyH7tqK8ZyFL4t7BRkAwW2WY7krHpWpeFuNnXmstE5KPoc
qRlC6HxInY/BpluR+/hbWCzFmv7tJvqCak4mn8UkZCQKr1OB7DL56OBw9yIHjn2J
yOlXlr9Tuj3awtml1joMbtc9jzqsdvUN3M3/FutcutXreLcfPE18NSkcHKSMlJwW
IGcU0N5EI99T4+4ZTu2Zd1UjN8+HlcTeeQF1Ajauf/WO3s1nFejXQnXfnJibAhDP
LtSPZjeL0sTcSAw3v5s0
=eUbE
-----END PGP SIGNATURE-----

--=-ccyCLvu5LADoM/oCg+d7--


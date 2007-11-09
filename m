Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbXKIUTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 15:19:31 -0500
Subject: Re: Deauthentication cycles
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <473490A0.2050403@lwfinger.net> (sfid-20071109_165359_386695_518B888E)
References: <473490A0.2050403@lwfinger.net>
	 (sfid-20071109_165359_386695_518B888E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ahcdemkVvIh7HWbR2RI/"
Date: Fri, 09 Nov 2007 21:19:29 +0100
Message-Id: <1194639569.4068.1.camel@johannes.berg> (sfid-20071109_201936_787243_FD9CBB84)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ahcdemkVvIh7HWbR2RI/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA
>=20
> Is this the correct code? If so, any ideas on why this deauthentication i=
s happening? As can be
> seen, it isn't fatal and the system always recovers.

I think that's correct. I'd guess what happens is that the AP sends you
a disassoc frame but you for some reason miss it, then the AP has you
disassociated. The next time you send a data (class three) frame it
tells you that you're not associated by sending you a deauth and
mac80211 recovers by associating again.

johannes

--=-ahcdemkVvIh7HWbR2RI/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzTA0KVg1VMiehFYAQJ2pw//WfDR5eUE8Vh0JkKWMPSwpCqihp/x9IN+
ieRSpCos9pZzb6r9cpMPoiFvEaBhkcPWm4QUUqUkRjvKEAE+1UCHU8k+vbXXcgPh
Bx5OxOHpoaKrI57VOzVMlxxh9BUqDM7W79B7hFF+k1OgEgy4rd2nYH0V+dDvFNCW
UWRCihI5poHnwWkUsauRE892UrSdbDEPxgNHpEZkY2E9XOe+9P8wo+tT2c+veMuW
Y++xS1wbX3T27bzgaCxCT+B/QcKhzRkRD1mCMFFCUCLs1UKQgCY4UbbinsdHn80H
5GlQJnY4b60loIOPtVt8zkMm1N5lHU+Aggwcl0SAnft9d66056oeME7QGV983MmZ
SPCb8mpPGJ/O0W7Q7dqWEg+KxW55XC1ZqvmrNtHkDWWHxabAliSoFnqLI22JUtEg
QrXbcK3la/wClbtlAkARJ+n6KdyrpuzELp/L3jxIwfP72R2ODMg4J3RMovZGEa7V
KLGKTiLME66aSQkVKlreIiseBhwCY/HEVzkw8nxdNIUziEvXyfRTwakK0R8Wrhaw
BkgOL0HZlMO6rLe+l12Rzrys9lEZwwFShBLCtIe2kDs4nprNzs/bzUNwO29O+Rfm
c23RJ1RxouGCz91N+ELhY+/7Ga0SthqW3MB669Yu84+S8aOErxTx7hZI7F+J25xQ
ic3+d0Te4hU=
=Xi4c
-----END PGP SIGNATURE-----

--=-ahcdemkVvIh7HWbR2RI/--


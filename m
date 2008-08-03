Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYHCSNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 14:13:04 -0400
Subject: Re: [PATCH 5/8] rfkill: add WARN_ON and BUG_ON paranoia
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20080803132103.GB12118@khazad-dum.debian.net>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217700664-20792-6-git-send-email-hmh@hmh.eng.br>
	 <200808031007.48877.IvDoorn@gmail.com>
	 <1217753845.4721.1.camel@johannes.berg>
	 <20080803132103.GB12118@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i/RXXMArKiOEeNdCELpJ"
Date: Sun, 03 Aug 2008 20:12:56 +0200
Message-Id: <1217787176.4721.16.camel@johannes.berg> (sfid-20080803_201308_975303_E705B64B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i/RXXMArKiOEeNdCELpJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-08-03 at 10:21 -0300, Henrique de Moraes Holschuh wrote:
> On Sun, 03 Aug 2008, Johannes Berg wrote:
> > if (WARN_ON(!nb))
> > 	return -EINVAL;
>=20
> I could use the notation above instead of:
> if (foo) {
> 	WARN_ON(1);
> 	return -ERROR;
> }
>=20
> Ivo, which one you prefer?  The if() with the condition and WARN on the
> branch, or the if(WARN_ON(condition)) ?

You really should either just BUG() as you guys seem to have decided on,
which is fine with me, or use if(WARN_ON()) because that'll also put in
an unlikely() etc.

johannes

--=-i/RXXMArKiOEeNdCELpJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlfUiAAoJEKVg1VMiehFYWaIQAKGE340ttAes8dUTTMAehQip
qO/p6lVChpFznXJZZCMOV8CfU8mNzKS6JXu0En/wsDOEDHSzpLS6WC7wxtdU9FBd
JYTTGufI+mdCbEMT73TwYaaRgxNsmnjeg7ZdI+lRJQMJMcMenuHiY17OIF7m/oDJ
Goi3VDbPhbCLJECMVxnk/9C8efTcOp/3r7RTSGp0JCJ4/W7vxlGEQSt6NkOBrwIg
yLGtQ1Ew8HyXhpkKLZ1RTneHDCXtAXu5Y/dSSxY6aN09pNtaCZk9U4iBYqhKc7Px
E9jLyQC7GeC5DlkW2P5nFB+d6vg+uRGAqRYoT30p6HC+/N8MKucrimh80G20erll
X7TVTGeEdpESDXK2GEfV+S3+rAJJSs/teBeMvpLB9RrK4SI89Zrb1EFoBZOcXeSo
bpDduWv1OWlmDBm9g+DvfGFlnv9tEWbK0gMGWiweyayHXh6wmk+cdyFJdAUKUsIG
yUTYkceXz5FG4tlo7WXDnXyL3uHLj9tQ8xIE3nblwFMUACHsCe47eSGjlnMVcd+M
zXLxrA0OrP1ZrFW4V7crhzZYreWAlZGMlPAUvWUlqqahYqLz3IFWGNJ0ZxbXgJlv
pTwl88tx8+riTj8Z47Qq+N8KUr8RamMkcNs3drPDHhBLYecwyjze0mH7Pkg+JEho
It4fPw7SezYqHdrXJaxP
=jqYe
-----END PGP SIGNATURE-----

--=-i/RXXMArKiOEeNdCELpJ--


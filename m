Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373AbXBBMNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Feb 2007 07:13:11 -0500
Subject: p54 warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xFRKjCELb/y9lh79qScW"
Date: Thu, 01 Feb 2007 19:50:07 +0100
Message-Id: <1170355807.22420.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xFRKjCELb/y9lh79qScW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

When building p54 on BE platforms, you get a lot of warnings like this:

drivers/net/wireless/d80211/p54/prism54usb.c: In function =E2=80=98p54u_upl=
oad_firmware_net2280=E2=80=99:
drivers/net/wireless/d80211/p54/prism54usb.c:609: warning: initialization m=
akes integer from pointer without a cast
drivers/net/wireless/d80211/p54/prism54usb.c:609: warning: passing argument=
 1 of =E2=80=98__fswab32=E2=80=99 makes integer from pointer without a cast

The cause is pretty obvious, in

	P54U_WRITE(NET2280_DEV_U32, &devreg->int_enable, 0);

you take a pointer and then pass it to cpu_to_le32(). IMHO that
&devreg->int_enable should just be written out as P54U_DEV_BASE +
INT_ENABLE or something.

All the warnings come from something like &devreg->foo btw, and all seem
to be in that function.

johannes

--=-xFRKjCELb/y9lh79qScW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFwjZf/ETPhpq3jKURAqVmAJ9u2O9eTUTmhDcfp5XngSkVa6xKNgCffiAS
k+UHvpi/CsIiIOwXW4+dISk=
=38Z5
-----END PGP SIGNATURE-----

--=-xFRKjCELb/y9lh79qScW--


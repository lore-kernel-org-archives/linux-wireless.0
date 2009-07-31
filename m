Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZGaIkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 04:40:17 -0400
Subject: Re: [PATCH] Fix SPARC64 unaligned access in zd_mac_rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Patrick Simmons <linuxrocks123@netscape.net>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
In-Reply-To: <4A72A462.6060107@netscape.net>
References: <4A72A462.6060107@netscape.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9i9oPL6E/Iv9JKOamvmN"
Date: Fri, 31 Jul 2009 10:39:43 +0200
Message-Id: <1249029583.29587.46.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9i9oPL6E/Iv9JKOamvmN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 01:59 -0600, Patrick Simmons wrote:
> I'm running zd1211rw on SPARC64 and was getting a lot of "unaligned=20
> access" messages in dmesg.  I tracked the problem down to this line, and=20
> changing the cast to a memcpy fixes the issue.
> =20
> -       fc =3D *(__le16 *)buffer;
> +       memcpy(&fc,buffer,sizeof(__le16));
>         need_padding =3D ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc)=
;

Please use get_unaligned instead.

johannes

--=-9i9oPL6E/Iv9JKOamvmN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcq3KAAoJEODzc/N7+Qmac8sP/RXugzUGOkjgOsN2LV6nwJIx
0v0/kuKR/u9ya5x52xzAKE+6JoewzmUAJfi+iea6UGXs0UcuSAo9jy67YjpCPOM1
l9Q6SxNqEx9owDI576l/3ba91TNFofb8K07T14+vn7iMpEJhq6VKE9kYXTFQ+rdX
CdW+JRcC4AdX9D1sdKJAWRsRxfvSjfJGswsseYambdVU8UyPDs627jlF9dlHIPWs
4PrMDHOgrSJ/ieroHpDoL5txS/SDsW8EzIPe3Sjl24HfoyfYAn4nroufGLXVEeLE
lGK9EThsupFf9N65y0l3mj7re3CqaXrWMRuTeb+CyVye8/Fhf7OwOShITErMefty
LGyQYNB9EB34c97TRopO/xS0GMIGLTKKWSyxhr2Z7SQVGQcDy1B3OCEi8RFlxhC0
ndCtcC5In9W6grbgPuVoc90mCGjXD/x/+SlwWgW7/eJAlWss8uKnEKZZJQPa4RSN
1EcCBrKtAggNdeECLqJZoGbUOOKEhclMaWWCgWW6IffOWi+VrND08yxebWhSMoy4
G8SntcdRoC5PatP6DWTm4Yj4IKljd/9YcxR4Xz2VN7/yIww+b3AfOhkGevQXqrFT
8lhgVq/eEaoGTmTOE0ZyblebjI8oXXGK2f54IxQZny2a2zH2UxYy3xUq33cJyqj8
S2e0+lFQa161GgVd3rIr
=MdU3
-----END PGP SIGNATURE-----

--=-9i9oPL6E/Iv9JKOamvmN--


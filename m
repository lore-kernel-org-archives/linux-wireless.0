Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60392 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489Ab1JMCZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 22:25:38 -0400
Subject: Re: Bug#645055: realtek 8188CE ad-hoc mode not supported
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Antoine =?ISO-8859-1?Q?Beaupr=E9?= <anarcat@koumbit.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	645055@bugs.debian.org
Date: Thu, 13 Oct 2011 03:25:17 +0100
In-Reply-To: <4E964896.5050004@lwfinger.net>
References: <20111012052940.17383.59248.reportbug@localhost>
	  <1318424918.4024.180.camel@deadeye> <87pqi2s0cg.fsf@marcos.anarcat.ath.cx>
	  <20111012160135.GK3366@decadent.org.uk>
	 <1318461858.4024.197.camel@deadeye> <4E964896.5050004@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-dJUWSHLJtxd1jzC0YDTx"
Message-ID: <1318472723.4024.208.camel@deadeye> (sfid-20111013_042727_374009_F63F8600)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dJUWSHLJtxd1jzC0YDTx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-10-12 at 21:10 -0500, Larry Finger wrote:
> On 10/12/2011 06:24 PM, Ben Hutchings wrote:
> > I looked a little further and saw that nl80211 does support changing
> > interface type (mode).  But this driver (rtl8192ce) only supports
> > creating new interfaces, not changing their type.
> >
> > Should mac80211 drivers generally support changing interface type
> > (change_interface operation)?
>=20
> I don't think that implementation of the WEXT interface is necessary.

The change_interface operation appears to be used in implementation of
nl80211 too.

> As to using iw, the following sequence worked:
>=20
> iw dev wlan14 interface add wlan15 type adhoc
> iw dev  set rename5 type managed
> iw dev  set rename5 type adhoc
>=20
> Why it was called "rename5" when I asked for "wlan15" is not understood,

udev's persistent name generator isn't able to distinguish the two
interfaces by MAC address, so it decides the new interface should also
be named 'wlan14'.  udev does renaming in two steps for some reason, and
the second step obviously fails.

> but the=20
> iw interface changes the mode for an existing interface when using rtl819=
2ce.
>=20
> BTW, I added a new iface because I did not want to interrupt my
> internat connection.

Hmm.  Maybe the change_interface operation is only needed to change
type/mode while the interface is up.

Antoine, did you bring the interface down before setting its mode?

Ben.

--=20
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.

--=-dJUWSHLJtxd1jzC0YDTx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATpZMDee/yOyVhhEJAQqQrw/+IGcmMpdWf/ZNfKCG+Ir+K6g/CBbiH2ew
sVlAojLEkb7N/8dwIXqUkSGw0fi8xybxDEZ0U+p6aL7BRSh739VZ6ADGi5O0OtJj
s427d6xfsk+btmnmoA38zWgOe5O7sN/CWfTxISDqYFPLTDB/dL6NKkv+z8y7Jffe
j9v5WMjMVzmihSO6WF5BOghPCLLaKQ1P54hC5ZrKIR6/6rkQhCPq1TjfxKUu9ZMy
GvWXsxk6B9VKDCQ928euUm/p4qjdgs2OzU6PVMlnJnn6n5/pzOnJXGhgXSsZSTeW
H9eAR8+HLmdsneuSvVHvWnsbLbTF1HM1p7tWUS2VF8Qi9p3JYeiuH6ijuK7Nk3CH
XbMCfG1B1nAn2MBAIHhbcPqUtAo2VtvDeP4vEZxXvM07BekdcfKCJMdT/udeu4lH
bJJNvjBbaf8Xzm3tDlSaH9mywAlp25TYYYhwq7qubgBJJnWO+kekZtFEFoL3VPk2
h98zX1HIeWZr9F0vA2fqpPdF8kjslceq4sBk4fEP+7e8vqKfnKjfY4Jk5fC57EgY
wNpXsT3P+jnj5LPTITlxqf5HQ/1/imEACte/Kk84HSrS2CKy8FLBbuxLOQChyhKk
RAtkC5yHwzMqFf6Q3XHycTPOZaDU/Ls1cnx4kj9bc4XVhCNivEvA4TrB0VhEVoTc
SIamaVGAKOE=
=eyLt
-----END PGP SIGNATURE-----

--=-dJUWSHLJtxd1jzC0YDTx--
